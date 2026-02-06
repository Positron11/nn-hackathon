# Data Catalog & Attribution

This directory contains the datasets and supporting assets consumed by the diabetes subphenotype pipeline.

## Processed Input
- `clean.csv` – Model-ready NFHS-5 indicator matrix assembled from the raw CSVs, reindexed by district, and enriched with engineered features for subtype attribution.

## Raw Sources
- `raw/kaggle.csv` – National Family Health Survey (NFHS-5, 2019–21) indicators downloaded from the Kaggle dataset curated by Bhanu Pratap Biswas: https://www.kaggle.com/datasets/bhanupratapbiswas/national-family-health-survey-nfhs-2019-21
- `raw/github.csv` – NFHS-5 indicators compiled by Pratap Vardhan: https://github.com/pratapvardhan/NFHS-5
- `raw/sources.md` – Change log describing ingestion steps, filters, and date of retrieval.

## Geospatial Assets
- `assets/districts.geojson` – District boundaries converted from the TopoJSON published at https://github.com/guneetnarula/indian-district-boundaries/blob/master/topojson/india-districts-727.json. Converted locally to GeoJSON for folium compatibility; all credit to the original author.

## Reports & References
- `reports/` – Government survey documentation (e.g., NFHS-5 India Volumes, IIPS population projections) referenced for validation and contextual commentary.

## Usage Guidance
- Keep raw files immutable—stage derived or cleaned variants in `clean.csv` (or siblings) to preserve provenance.
- When updating inputs, refresh the notes in `raw/sources.md` and re-run `../pipeline.ipynb` to propagate changes downstream.
- Review licensing for each source before redistributing derived datasets or visualisations.
