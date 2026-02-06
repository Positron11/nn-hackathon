# Diabetes Subphenotype Prioritisation

This module estimates the distribution of canonical type 2 diabetes subphenotypes across Indian districts and ranks locations where GLP-1 focused interventions may have the greatest impact. The workflow is notebook-driven and relies on curated NFHS-5 indicators plus geospatial assets for mapping.

## Key Notebooks
- `pipeline.ipynb` – Core processing pipeline that ingests `data/clean.csv`, constructs subtype logits, calibrates them with literature-informed priors, and exports `out/subphenotypes.csv` alongside an audit dataframe.
- `heatmap.ipynb` – Visualisation notebook that merges the processed results with `data/assets/districts.geojson` to create interactive folium heatmaps saved to `out/heatmap.html`.

## Quick Start
1. Launch Jupyter Lab or Notebook within the repository root after installing dependencies (`pip install -r ../requirements.txt` from this folder).
2. Execute `pipeline.ipynb` top-to-bottom to refresh the subtype attribution outputs.
   - For headless execution, run `jupyter nbconvert --to notebook --execute subphenotype/pipeline.ipynb` from the repo root.
3. Optionally open `heatmap.ipynb` to regenerate folium maps for presentations or the `visualization/` module.
4. Blend the outputs with state-level modifiers from `../genetic/data/state_scores.csv` as needed before exporting to reporting decks.

## Data Assets
- `data/clean.csv` – Model-ready NFHS-5 indicator matrix used as pipeline input.
- `data/raw/` – Source CSVs and provenance notes (see `data/raw/sources.md`).
- `data/assets/districts.geojson` – District boundaries converted from the TopoJSON published at https://github.com/guneetnarula/indian-district-boundaries/blob/master/topojson/india-districts-727.json.
- `data/reports/` – Survey documentation and supporting government publications.
- Additional attribution and licensing notes live in `data/README.md`.

## Outputs
- `out/subphenotypes.csv` – Calibrated prevalence estimates for SIDD, SIRD, CIRDD, MOD, and MARD plus prioritisation metrics.
- `out/heatmap.html` – Interactive district dashboard highlighting GLP-1 readiness signals.
- Downstream helper tables or exports should be committed to `out/` for reproducibility.

## Supporting Notes
- `docs/` captures design decisions, scoring rationale, and reviewer questions for the hackathon judging panel.
- `papers/` stores literature used to derive priors and interpretation heuristics—refer to these PDFs when adjusting weights or validating outputs.

## Methodology Highlights
1. **Standardisation:** NFHS indicators are z-scored nationally with mean imputation for incomplete coverage.
2. **Derived indices:** Composite features approximate insulin resistance, glucose burden, age structure, and nutritional stress using weighted blends of the standardised inputs.
3. **Subtype attribution:** Linear combinations of the indices produce logits for the five recognised clusters; a row-wise softmax yields percentage shares.
4. **Prior calibration:** National subtype priors (λ = 0.1) smooth district estimates to prevent overfitting to sparse indicators.
5. **Prioritisation scoring:** District-level readiness scores blend diabetes burden, obesity prevalence, and affluence proxies with emphasis on SIRD and MOD to surface GLP-1 opportunities.
