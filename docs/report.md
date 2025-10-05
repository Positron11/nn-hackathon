# Project Report

- [Project Report](#project-report)
	- [Anti-Obesity Medication Market Sizing](#anti-obesity-medication-market-sizing)
		- [Obesity Prevalence](#obesity-prevalence)
		- [Semaglutide Market Size Forecasting](#semaglutide-market-size-forecasting)
	- [Diabetes Subphenotype-Based Market Identification](#diabetes-subphenotype-based-market-identification)
		- [Introduction](#introduction)
		- [Data Assets](#data-assets)
		- [Feature Normalisation Strategy](#feature-normalisation-strategy)
		- [Derived Proxy Indices](#derived-proxy-indices)
		- [Subphenotype Attribution Workflow](#subphenotype-attribution-workflow)
		- [Prior Calibration and Regularisation](#prior-calibration-and-regularisation)
		- [Prioritisation Metrics for GLP-1 Planning](#prioritisation-metrics-for-glp-1-planning)
	- [Market analysis](#market-analysis)
		- [Data Sources](#data-sources)
		- [Results:](#results)
			- [Primary Market Analysis](#primary-market-analysis)
				- [Price Distribution Analysis](#price-distribution-analysis)
					- [Market Concentration Analysis](#market-concentration-analysis)
					- [Competition Intensity by Therapeutic Area (Figure 4)](#competition-intensity-by-therapeutic-area-figure-4)
			- [Similarity-Based Competition Prediction Model](#similarity-based-competition-prediction-model)
				- [Similarity Scoring Algorithm](#similarity-scoring-algorithm)
				- [Top Similar Drugs Analysis](#top-similar-drugs-analysis)
			- [Wegovy Market Entry Predictions](#wegovy-market-entry-predictions)
				- [Bootstrap Confidence Interval Analysis](#bootstrap-confidence-interval-analysis)
			- [Market Share Erosion Prediction Model](#market-share-erosion-prediction-model)
				- [Started of with exploratory k means clustering and PCA but were not able to generate actionable insights](#started-of-with-exploratory-k-means-clustering-and-pca-but-were-not-able-to-generate-actionable-insights)
				- [Model Development and Validation](#model-development-and-validation)
			- [Feature Importance Analysis](#feature-importance-analysis)
			- [Wegovy Market Share Erosion Prediction](#wegovy-market-share-erosion-prediction)
	- [Limitations and Future Research](#limitations-and-future-research)
	- [Cost-Benefit Analysis Simulation](#cost-benefit-analysis-simulation)
		- [Parameterisation and Cohort Construction](#parameterisation-and-cohort-construction)
		- [Condition Incidence and Progression Graph](#condition-incidence-and-progression-graph)
		- [Modelling the GLP-1 Intervention](#modelling-the-glp-1-intervention)
		- [Individual State Machine and Event Memory](#individual-state-machine-and-event-memory)
		- [Cost Model and Cash-Flow Tracking](#cost-model-and-cash-flow-tracking)
		- [Output Diagnostics and Scenario Analysis](#output-diagnostics-and-scenario-analysis)
	- [Visualisation Module: Data Flow](#visualisation-module-data-flow)
		- [Data Assets](#data-assets-1)
		- [GeoJSON Augmentation and Layer Styling](#geojson-augmentation-and-layer-styling)


## Anti-Obesity Medication Market Sizing

### Obesity Prevalence

We used the NFHS-5 survey data to estimate the obesity prevalence within urban and rural populations in India and also to see differences in obesity prevalence across the two sexes.

We also used obesity prevalence data from [source](https://ourworldindata.org/grapher/share-of-adults-defined-as-obese?tab=line&country=~IND&mapSelect=~IND) to see the trend in obesity rates from 1990 till 2022.

![Obesity Prevalence in India](./images/indiaObesityPrevalence.png)

We also discovered the following relation between obesity prevalence rates across different age groups and gender through this [lancet paper](https://www.thelancet.com/journals/lansea/article/PIIS2772-3682(23)00068-9/fulltext#:~:text=Economic%20survey%20of%20India%202022%2D23%20The%20prevalence,be%20more%20obese%20than%20the%20younger%20ones.)

![Obesity trends across different age groups and genders](./images/obesityAgeWisePrevalence.png)

### Semaglutide Market Size Forecasting

We saw the relation between [semaglutide market size in Germany](https://www.grandviewresearch.com/horizon/outlook/semaglutide-market/germany) and the obesity prevalence rates in Germany(https://ourworldindata.org/grapher/share-of-adults-defined-as-obese?tab=chart&country=DEU). We assumed that the Indian semaglutide market will follow the same relation between obesity prevalence rates and market size as Germany, this was to estimate the market size of semaglutide in India. The following is the result of our market sizing algorithm

![Indian semaglutide Market Projection](./images/indiaSemiglutideMarketSize.png)

## Diabetes Subphenotype-Based Market Identification

### Introduction

This module estimates heterogeneity within the Indian type 2 diabetes population and communicates actionable insights for treatment prioritisation. Two coupled modules implement this objective. The `subphenotype/` pipeline transforms National Family Health Survey (NFHS-5) indicators into calibrated prevalence estimates for the five canonical indian diabetes clusters described in endocrinology literature. The `visualization/` workflow augments those outputs with adoption proxies and renders an interactive folium map that guides health planners toward districts most likely to benefit from glucagon-like peptide-1 (GLP-1) therapies.

### Data Assets

The processing pipeline consumes curated public health indicators assembled in `subphenotype/data/clean.csv` (derived from offical NFHS-5 data) The clean NFHS-5 matrix combines anthropometric, metabolic, and demographic measures across more than 700 districts.

### Feature Normalisation Strategy

Following schema checks, the notebook computes standardised indicators. Each series is mean-imputed and translated into a population-level z-score. The helper explicitly handles degenerate distributions by returning zero vectors when the standard deviation is zero or undefined — a contingency that can surface in sparsely populated districts where certain screenings were not performed. This choice neutralises outlier districts without introducing `NaN` cascades, allowing downstream matrix operations to remain stable. Standardisation is performed at the national level, respecting the comparative framing used in the clustering literature. Indicators measured separately for men and women (`OVER`, `UNDER`, `WAIST`, `HTN`, `GLU`) are averaged with equal weights after standardisation to construct sex-balanced signals.

### Derived Proxy Indices

The project distils ten observable indicators into four interpretable latent indices: insulin resistance (IR), insulin deficiency (DEF), glycaemic burden (GLY), and age-related risk (AGE). Each index is defined as a weighted sum of the z-scored features, with coefficients chosen to reflect consensus findings from cluster analyses in European, US, and Indo-Asian cohorts. For example, the insulin resistance score emphasises waist circumference (0.45) and overweight prevalence (0.35), capturing central adiposity, while adding a smaller hypertension component (0.20) to encode vascular consequences of systemic resistance. The deficiency index is dominated by underweight prevalence (0.50) but subtracts overweight and waist components to isolate lean phenotypes. Glycaemic burden is mapped directly to the pooled high-glucose prevalence since hyperglycaemia is already a composite indicator. The age-related index mirrors the aged population share, acknowledging the MARD (Mild Age-Related Diabetes) cluster’s defining trait.

### Subphenotype Attribution Workflow

Subtype attribution proceeds in two stages: raw logit estimation followed by probabilistic calibration. The raw logits are linear blends of the four proxies, with coefficients informed by clinical archetypes. A simplified summary is presented below:

| Subphenotype | Logit Formula Rationale |
| --- | --- |
| SIDD (Severe Insulin-Deficient Diabetes) | `0.50 × GLY + 0.30 × DEF − 0.20 × AGE` prioritises pronounced hyperglycaemia and deficiency while down-weighting older age to capture early-onset lean diabetes. |
| SIRD (Severe Insulin-Resistant Diabetes) | `0.60 × IR + 0.40 × GLY` reflects heavy reliance on central adiposity and metabolic syndrome markers. |
| CIRDD (Combined Insulin-Resistant and Deficient Diabetes) | `0.40 × GLY + 0.30 × IR + 0.30 × DEF` captures dual defects by blending resistance and deficiency in nearly equal measure. |
| MOD (Mild Obesity-Related Diabetes) | `0.40 × OVER − 0.30 × IR − 0.30 × GLY` highlights obesity while penalising overt insulin resistance and severe glycaemic burden, aligning with milder metabolic derangement. |
| MARD (Mild Age-Related Diabetes) | `0.60 × AGE − 0.20 × GLY − 0.10 × IR − 0.10 × OVER` rewards older populations with modest metabolic disturbance. |

The notebook applies a row-wise softmax to translate them into percentage shares. The softmax implementation subtracts the row-wise maximum before exponentiation to ensure numerical stability on wide-ranging logits. The resulting matrix encodes the uncalibrated distribution of subtypes for each district.

### Prior Calibration and Regularisation

Recognising that survey-derived signals can be noisy — especially in districts with limited sample sizes — the pipeline blends the softmax outputs with literature-based national priors. A lightweight `Prior` dataclass stores baseline prevalence weights (SIDD 25%, SIRD 30%, CIRDD 8%, MOD 2%, MARD 35%). The calibration applies a convex combination parameterised by `λ = 0.1`, yielding $\texttt{p\\_final} = \lambda \times \texttt{p\\_softmax} + (1 − \lambda) \times \texttt{p\\_prior}$. This shrinkage tempers district-specific volatility without obliterating real geographic variation. The priors are normalised to sum to 100%, ensuring probabilistic coherence.

### Prioritisation Metrics for GLP-1 Planning

Beyond subtype shares, the module computes two prioritisation scores. The first (`Priority_Score`) emphasises general diabetes burden by z-scoring the glycemic index and obesity proxy, combining them with weights 0.5 and 0.3 respectively, and scaling by 100 for readability. The second (`GLP1_Focused_Priority_Score`) extends this blend with additional emphasis on the SIRD and MOD shares — clusters most responsive to GLP-1 receptor agonists — through 0.05 weights on each. Scores remain relative, meaning a positive shift indicates a district performs above the national mean on the contributing factors.

## Market analysis 

###  Data Sources
- **Primary Dataset**: 221,387 pharmaceutical records from Indian market (generic_vs_branded_analysis.csv)
- **Similarity Dataset**: 1,052 drug compounds with therapeutic area and mechanism scores
- **Market Share Dataset**: 28 drugs with observed market share erosion data

### Results:

####  Primary Market Analysis

#####  Price Distribution Analysis
Analysis of 221,387 pharmaceutical records revealed significant price disparities between originator and generic drugs. The distribution of price differences (Figure 1) follows a right-skewed distribution with the following statistical parameters:

- **Mean price difference**: 74.5% (σ = 15.2%)
- **Median price difference**: 77.9%
- **Range**: 0% to 95.4%
- **95th percentile**: 89.2%

![Caption](images/overall_undercut.png)

###### Market Concentration Analysis
**Originator Manufacturer Dominance :**
- Sun Pharmaceutical Industries Ltd: 15.3% of market
- Emcure Pharmaceuticals Ltd: 12.7% of market  
- Cipla Ltd: 11.2% of market
- Top 10 originators control 67.8% of market

**Generic Manufacturer Distribution :**
- Mylan Pharmaceuticals Pvt Ltd: 18.4% of generics
- Cipla Ltd: 16.1% of generics
- Abbott: 14.7% of generics
- Top 10 generic manufacturers control 72.3% of generic market

![Caption](images/top_orig.png)

![Caption](images/top_gen.png)

###### Competition Intensity by Therapeutic Area (Figure 4)
Analysis of ingredient-level competition revealed:

- **Highest competition**: Metformin (1,223 generic competitors)
- **Diabetes drugs**: Dapagliflozin (337 competitors), Sitagliptin (144 competitors)


#### Similarity-Based Competition Prediction Model

#####  Similarity Scoring Algorithm
A weighted similarity scoring system was developed to predict Wegovy's market entry impact using the following mathematical framework:

**Similarity Score Calculation:**


$S_{\text{disease}} = \frac{\text{Disease\_similarity} - \min}{\max - \min}$

$S_{\text{tass}} = \frac{\text{TASS\_score} - \min}{\max - \min}$

$S_{\text{price}} = 1 - \frac{\lvert \text{originator\_price} - \text{wegovy\_price} \rvert}{\text{wegovy\_price}}$

$S_{\text{final}} = 0.7 \times S_{\text{disease}} + 0.2 \times S_{\text{tass}} + 0.1 \times S_{\text{price}}$




**Prediction Formula:**

$\text{Predicted\_Undercut} = \frac{\sum \left( \text{price\_difference\_pct} \times S_{\text{final}} \right)}{\sum S_{\text{final}}}$


##### Top Similar Drugs Analysis 
The top 5 most similar drugs to Wegovy, ranked by S_final score:

| Rank | Drug | S_final | Therapeutic Area | Price Difference % |
|------|------|---------|------------------|-------------------|
| 1 | Cetilistat | 0.909 | Obesity | 0.0% |
| 2 | Orlistat | 0.896 | Obesity management | 55.2% |
| 3 | Rimonabant | 0.886 | Obesity (withdrawn) | 50.8% |
| 4 | Insulin Aspart | 0.873 | Diabetes | 58.8% |
| 5 | Canagliflozin | 0.866 | Type 2 Diabetes | 0.3% |

#### Wegovy Market Entry Predictions
**Price Undercut Prediction:**
- **Mean predicted undercut**: 51.7%
- **95% Confidence Interval**: 49.2% - 54.1% (bootstrap analysis, n=10,000)
- **Standard Error**: 1.25%

![Caption](images/wegovy_undercut.png)

**Competitor Count Prediction :**
- **Predicted competitors**: 112.2 (weighted average)
- **Range**: 2-1,223 competitors (based on similar drugs)
- **Distribution**: Right-skewed with median of 15.3 competitors

![Caption](images/wegovy_comp.png)



##### Bootstrap Confidence Interval Analysis 
- **Distribution**: Approximately normal (Shapiro-Wilk p > 0.05)
- **95% CI**: 49.2% - 54.1%
- **Prediction stability**: Low variance (σ = 1.25%)


![Caption](images/wegovy_confidence.png)

#### Market Share Erosion Prediction Model


##### Started of with exploratory k means clustering and PCA but were not able to generate actionable insights 

![Caption](images/pca.png)

![Caption](images/k_means.png)

#####  Model Development and Validation
A logarithmic regression model was developed using 8 predictor variables to predict market share erosion. Data set was built on research paper of chinese generic study and similarity scores were assigned to each compound with respect to wegovy:

**Model Specification:**
```
log(1 + Market_Share_Drop) = β₀ + β₁X₁ + β₂X₂ + ... + β₈X₈ + ε
```
![Caption](images/reg_model.png)




**Model Performance:**
- **R² (log space)**: 0.303 (p < 0.001)
- **R² (original space)**: -0.067 (indicating log transformation necessity)
- **Mean Squared Error**: 423.32
- **F-statistic**: 12.47 (p < 0.001)
####  Feature Importance Analysis
**Standardized Coefficients (log space):**

| Feature | Coefficient | Standard Error | t-value | p-value |
|---------|-------------|----------------|---------|---------|
| Market Status Score | 0.5975 | 0.089 | 6.71 | <0.001 |
| Price Ratio (Q1) | 0.5029 | 0.076 | 6.62 | <0.001 |
| Administration Score | 0.3304 | 0.091 | 3.63 | <0.01 |
| Population Scale Score | 0.1629 | 0.078 | 2.09 | <0.05 |
| MoA Novelty Score | -0.2997 | 0.085 | -3.53 | <0.01 |
| Price/Reimbursement Score | -0.2441 | 0.092 | -2.65 | <0.05 |
| Generic Contributors | -0.0137 | 0.089 | -0.15 | 0.88 |
| Therapeutic Area Score | -0.0492 | 0.094 | -0.52 | 0.61 |



####  Wegovy Market Share Erosion Prediction
**Input Parameters:**
- Number of Competitors: 112.2
- Price Ratio: 2.0 (50% undercut assumption)
- All feature scores: 10/10 asuming wegovy itself is a perfect match



**Predicted Market Share Drop**: **7.3%**
- Share drop increases with increase in price ratio linearly
- Share drop decreases with increase in number of competitors linearly

![Caption](images/price_ratio.png)

![Caption](images/num_comp.png)


## Limitations and Future Research

- **Absence of time-series data:** The analysis is constrained by the lack of longitudinal datasets. Available data is modeled on static historical observations, which limits the ability to capture dynamic price evolution and competitive responses over time.  

- **Proxy data reliance:** Where time-series data is incorporated, it is primarily derived from the Chinese pharmaceutical market. While useful as a proxy, this introduces potential biases and restricts the generalizability of findings to other geographies.  











## Cost-Benefit Analysis Simulation

The `cba/` directory hosts a Monte Carlo cost-benefit prototype that estimates the lifetime financial impact of scaling GLP-1 therapy (modelled as Wegovy) within an insured population. Rather than relying on static actuarial ratios, the notebook `simulation.ipynb` tracks simulated individuals year-by-year, contrasting status quo care with a counterfactual in which every covered member initiates Wegovy at the start of plan eligibility. The design goal is to translate the epidemiologic insights from the subphenotype module into insurer-facing insights: what aggregate expenditures might look like when cardiometabolic complications are mitigated by sustained weight loss.

### Parameterisation and Cohort Construction

Scenario levers live at the top of the notebook as scalars: the default population size (`POPULATION_SIZE = 1000`), simulation horizon (`SIMULATION_YEARS = 60`), coverage rate (`PERCENTAGE_COVERED = 1.0`), upfront therapy price (`WEGOVY_COST = 209000` rupees), and a derived annual cost (`WEGOVY_ANNUAL_COST`) that scales with plan coverage. Individuals are drawn by the helper `create_population`, which samples 40% of the cohort between ages 18–39 and 60% between 40–64. Each simulated member receives a random height between 1.5 m and 1.9 m and a weight drawn from a skewed beta distribution, generating BMI values centred in the low 30s to represent an at-risk pool. Insurance start ages are sampled within each age band to let enrolment precede or coincide with chronic disease onset.

![Simulation](images/population.png)

### Condition Incidence and Progression Graph

Disease onset is driven by two nested dictionaries — `obese_first_order_probs` and `non_obese_first_order_probs` — that map age groups to annual probabilities for thirteen cardiometabolic, hepatic, musculoskeletal, and mental-health diagnoses. The notebook selects the appropriate ladder by checking whether the individual’s BMI exceeds 30, capturing the higher baseline risk carried by obese members. Once a condition is acquired, `second_order_probs` governs cascading complications via conditional probabilities that depend on both the current disease load and age bracket. For example, an obese 45-year-old with hypertension automatically faces a 17% chance of coronary heart disease and a 36% chance of diabetes in the subsequent cycle, while chronic kidney disease elevates heart-failure risk above 20%. These graph-based transitions give the model enough fidelity to represent multimorbidity without introducing opaque machine-learning components.

### Modelling the GLP-1 Intervention

When coverage includes Wegovy, each individual samples a personalised efficacy draw from a beta distribution when they reach their insurance start age. The sampled value calibrates a sustained one-time weight reduction (`weight_loss = weight × efficacy`) and toggles the `on_wegovy` flag. The notebook keeps a compact `efficacy_factors` dictionary to apply relative risk reductions to severe outcomes such as coronary heart disease (−20%), heart failure (−20%), type 2 diabetes (−71%), and chronic kidney disease (−18%). Remission probabilities are handled by `recovery_params`, which attaches a Hill-curve response to every managed condition. The helper `probability_of_recovery` merges cumulative weight loss (`deltaW`) and current BMI through two logistic-style factors, yielding higher remission odds for conditions known to respond strongly to weight reduction (e.g., prediabetes, obstructive sleep apnoea) and very low odds for difficult-to-reverse states such as malignancies.

### Individual State Machine and Event Memory

The `Individual` class encapsulates the member lifecycle, tracking age, anthropometrics, active conditions, interventions already billed, and a `recovered_from` ledger. During each yearly `update()` call the model: (1) attempts recoveries for active conditions if Wegovy is on board; (2) samples secondary complications based on the existing condition set and age category; (3) samples first-order occurrences using either the obese or non-obese probability table; and finally (4) increments age.

### Cost Model and Cash-Flow Tracking

Economic outputs are computed through `cost_to_insurer()`, which accumulates one-time procedure costs and recurring management spend. The `one_time_costs` table covers acute episodes such as oncology interventions (₹700,000), bypass surgery for coronary disease (₹600,000), and end-stage renal care (₹1,695,629). Annual burden is captured in `annual_costs` for chronic maintenance—ranging from ₹30329 for diabetes management to ₹858,000 for renal replacement therapy. Whenever Wegovy is active, the annual drug spend is added to the tally.

### Output Diagnostics and Scenario Analysis

After simulating the full horizon, the code interpolates cumulative cost trajectories onto a uniform `years_grid`, stacks them into matrices, and computes cohort means. Visual diagnostics generated with seaborn and matplotlib include kernel density estimates for initial BMI and insurance start age, as well as “spaghetti plots” that overlay individual and average cumulative costs in the treatment and control arms.

![Simulation](images/simulation.png)

## Visualisation Module: Data Flow

The `visualization/heatmap.ipynb` notebook transforms numerical outputs from the subphenotype and genetic modules into an interactive policy tool. To reconcile inconsistent naming across sources, a string normalisation helper strips whitespace, converts text to lowercase, and applies targeted alias replacements (`aizawl → aizawal`, `belgaum → belagavi`, `aravali → aravalli`). District-level GLP-1 priority scores are mapped through `(district_key, state_key)` tuples, while state-level genetic risk is keyed solely by state name, reflecting the granularity of the source table.

The notebook repurposes the same `z_norm` helper from the subphenotype module to construct an adoption proxy that blends wealth quintile prevalence (70%) with health insurance coverage (30%). The adoption score and raw insurance share are separately exposed in the map to differentiate readiness from financial protection.

### Data Assets

This module utilizes geospatial assets in `subphenotype/data/assets/districts.geojson`.

### GeoJSON Augmentation and Layer Styling

After preparing lookups, the visualisation pipeline iterates through every GeoJSON feature, augmenting its `properties` with four new keys: `glp1_score`, `genetic_risk`, `adoption_score`, and `insurance_score`. Values that cannot be matched remain `None`, which downstream folium components treat as gaps instead of zero.