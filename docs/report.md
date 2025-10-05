# Project Report

- [Project Report](#project-report)
	- [Diabetes Subphenotype \& Visualisation Modules Technical Report](#diabetes-subphenotype--visualisation-modules-technical-report)
		- [Introduction](#introduction)
		- [Data Assets](#data-assets)
		- [Feature Normalisation Strategy](#feature-normalisation-strategy)
		- [Derived Proxy Indices](#derived-proxy-indices)
		- [Subphenotype Attribution Workflow](#subphenotype-attribution-workflow)
		- [Prior Calibration and Regularisation](#prior-calibration-and-regularisation)
		- [Prioritisation Metrics for GLP-1 Planning](#prioritisation-metrics-for-glp-1-planning)
	- [Visualisation Module: Data Flow](#visualisation-module-data-flow)
		- [Data Assets](#data-assets-1)
		- [GeoJSON Augmentation and Layer Styling](#geojson-augmentation-and-layer-styling)


## Diabetes Subphenotype & Visualisation Modules Technical Report

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

Recognising that survey-derived signals can be noisy — especially in districts with limited sample sizes — the pipeline blends the softmax outputs with literature-based national priors. A lightweight `Prior` dataclass stores baseline prevalence weights (SIDD 25%, SIRD 30%, CIRDD 8%, MOD 2%, MARD 35%). The calibration applies a convex combination parameterised by `λ = 0.1`, yielding $\texttt{p\_final} = \lambda \times \texttt{p\_softmax} + (1 − \lambda) \times \texttt{p\_prior}$. This shrinkage tempers district-specific volatility without obliterating real geographic variation. The priors are normalised to sum to 100%, ensuring probabilistic coherence.

### Prioritisation Metrics for GLP-1 Planning

Beyond subtype shares, the module computes two prioritisation scores. The first (`Priority_Score`) emphasises general diabetes burden by z-scoring the glycemic index and obesity proxy, combining them with weights 0.5 and 0.3 respectively, and scaling by 100 for readability. The second (`GLP1_Focused_Priority_Score`) extends this blend with additional emphasis on the SIRD and MOD shares — clusters most responsive to GLP-1 receptor agonists — through 0.05 weights on each. Scores remain relative, meaning a positive shift indicates a district performs above the national mean on the contributing factors.

## Visualisation Module: Data Flow

The `visualization/heatmap.ipynb` notebook transforms numerical outputs from the subphenotype and genetic modules into an interactive policy tool. To reconcile inconsistent naming across sources, a string normalisation helper strips whitespace, converts text to lowercase, and applies targeted alias replacements (`aizawl → aizawal`, `belgaum → belagavi`, `aravali → aravalli`). District-level GLP-1 priority scores are mapped through `(district_key, state_key)` tuples, while state-level genetic risk is keyed solely by state name, reflecting the granularity of the source table.

The notebook repurposes the same `z_norm` helper from the subphenotype module to construct an adoption proxy that blends wealth quintile prevalence (70%) with health insurance coverage (30%). The adoption score and raw insurance share are separately exposed in the map to differentiate readiness from financial protection.

### Data Assets

This module utilizes geospatial assets in `subphenotype/data/assets/districts.geojson`.

### GeoJSON Augmentation and Layer Styling

After preparing lookups, the visualisation pipeline iterates through every GeoJSON feature, augmenting its `properties` with four new keys: `glp1_score`, `genetic_risk`, `adoption_score`, and `insurance_score`. Values that cannot be matched remain `None`, which downstream folium components treat as gaps instead of zero.