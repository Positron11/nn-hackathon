# Data Catalog & Attribution

This directory contains the datasets and supporting assets used by the diabetes subphenotype pipeline.

## Processed Input
- `clean.csv` – Model-ready NFHS-5 indicator matrix assembled from the raw CSVs, reindexed by district, and enriched with engineered features for subtype attribution.

## Raw Sources
- `raw/kaggle.csv` – National Family Health Survey (NFHS-5, 2019–21) indicators downloaded from the Kaggle dataset curated by Bhanu Pratap Biswas: https://www.kaggle.com/datasets/bhanupratapbiswas/national-family-health-survey-nfhs-2019-21
- `raw/github.csv` – NFHS-5 indicators compiled by Pratap Vardhan: https://github.com/pratapvardhan/NFHS-5

A concise provenance log is also captured in `raw/sources.md`.

## Geospatial Assets
- `assets/districts.geojson` – District boundaries converted from the TopoJSON published at https://github.com/guneetnarula/indian-district-boundaries/blob/master/topojson/india-districts-727.json. Converted locally to GeoJSON for folium compatibility; all credit to the original author.

## Reports
- `reports/` – Comprehensive government survey studies (e.g., NFHS-5 India Report, IIPS population projections) referenced for context and validation.

Please review the source licences before redistributing the derived datasets or visualisations.
