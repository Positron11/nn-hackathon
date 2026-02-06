# Market Intelligence Module

The `market/` workspace benchmarks how GLP-1 launches could behave once generics and analogues reach the Indian market. It combines exploratory notebooks, curated CSVs, and clustering models to estimate erosion risk and competitive positioning for Wegovy.

## Data Files
- `generic_vs_branded_analysis.csv` – Historical originator vs. generic price benchmarks with per-ingredient competition counts and percentage erosion.
- `similarity final - similarity.csv` – Launch analogues scored on therapeutic area, mechanism overlap, market maturity, and observed share drops.
- `Similarity scoring final  - Start research (1).csv` – Qualitative similarity scoring with narrative rationales that pairs with the quantitative sheet above.

## Notebooks
- `Primary_data_analysis.ipynb` – Exploratory data analysis for the pricing datasets (distributions, coverage checks, outlier flags).
- `Erosion_predicition.ipynb` – PCA + K-means clustering to scope potential relations between pricing metrics and market share erosion; also houses the logit-based share estimator.
- `Undercut_and_competitor_prediction.ipynb` – Gradient-based regression and rule heuristics estimating potential Wegovy pricing gaps versus expected generics.

## Suggested Workflow
1. Run `Primary_data_analysis.ipynb` to validate dataset integrity and flag ingredients lacking competition data.
2. Execute `Erosion_predicition.ipynb` to generate erosion clusters, then export the labelled outputs for downstream modelling.
3. Iterate on `Undercut_and_competitor_prediction.ipynb` to simulate alternate price corridors or competitive entry timings.
4. Push scenario summaries or plots into `../cba/` or `../preliminary/` when building narratives for the submission deck.

## Extending the Module
- Append new analogue launches or GLP-1 class competitors to the CSVs and rerun the clustering notebook to refresh the erosion bands.
- Archive any raw market data snapshots in a dated subfolder before overwriting the working CSVs.
- Track major assumption changes inside the notebooks or append notes to this README for future hackathon iterations.
