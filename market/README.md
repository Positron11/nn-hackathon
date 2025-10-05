# Market Intelligence Module

The `market/` workspace benchmarks how GLP-1 launches could behave once generics and analogues reach the Indian market. It combines exploratory notebooks, curated CSVs, and clustering models to estimate erosion risk and competitive positioning for Wegovy.

## Contents
- `generic_vs_branded_analysis.csv` – Historical originator vs. generic price benchmarks with per-ingredient competition counts and percentage erosion.
- `similarity final - similarity.csv` – Launch analogues scored on therapeutic area, mechanism overlap, market maturity, and observed share drops.
- `Similarity scoring final  - Start research (1).csv` – Qualitative similarity scoring with narrative rationales that pairs with the quantitative sheet above.
- `Primary_data_analysis.ipynb` – Quick EDA for the pricing datasets (distributions, outliers, coverage).
- `Erosion_predicition.ipynb` – PCA + K-means analysis to scope potential relations between metrics and marketshare. logrithmic regression using factors as weights and taking predicted output as marketshare. 
   - plots of marketshare as a function of 1. original vs generic price ratio 2. numberof competitors
- `Undercut_and_competitor_prediction.ipynb` – Gradient-based regression and rule heuristics estimating potential Wegovy pricing gaps versus expected generics.

## How to Use
1. Open the notebooks in Jupyter after installing repository dependencies (`pip install -r ../requirements.txt`).
2. Run `Primary_data_analysis.ipynb` first to validate dataset integrity and flag ingredients lacking competition data.
3. Use `Erosion_predicition.ipynb` to generate erosion clusters, then feed the cluster medians into your downstream pricing models.
4. Adjust assumptions in `Undercut_and_competitor_prediction.ipynb` (e.g., similarity weights, reimbursement factors) to simulate alternative competitive timelines.

## Extending the Module
- Append new analogue launches or GLP-1 class competitors to the CSVs and rerun the clustering notebook to refresh the erosion bands.
- Integrate outputs with the cost-benefit simulation (`cba/`) to stress test payer ROI under varied price curves.
- Track major assumption changes inside the notebooks or append notes to this README for future hackathon iterations.
