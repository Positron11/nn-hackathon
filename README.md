# Novo Nordisk Hackathon: Diabetes Subtype Prioritization

This repository contains the district-level analytics submitted for the Novo Nordisk hackathon. The notebook-driven workflow transforms National Family Health Survey (NFHS-5) indicators into estimates of the five canonical type 2 diabetes subgroups and produces prioritisation scores that highlight where GLP-1 focused interventions may have the greatest impact.

## Getting Started

### Prerequisites
- Python 3.9+
- Recommended packages: `pandas`, `numpy`, `jupyter`

Install the dependencies with pip:

```bash
pip install pandas numpy jupyter
```

### Running the pipeline
1. Launch Jupyter Lab/Notebook in the repository root.
2. Open `main.ipynb` and execute all cells to reproduce the processing flow.
   - The notebook loads `data/clean.csv`, validates schema completeness, computes derived indicators, blends subtype priors, and writes the results to `out.csv`.
3. Alternatively, execute the notebook headlessly:

   ```bash
   jupyter nbconvert --to notebook --execute main.ipynb
   ```

   The generated `out.csv` in the project root contains the refreshed outputs.

## Repository Structure

- `main.ipynb` – Core processing pipeline for T2D subtype attribution and prioritisation scoring.
- `out.csv` – Current export of subtype shares (`SIDD_pct`, `SIRD_pct`, `CIRDD_pct`, `MOD_pct`, `MARD_pct`) and prioritisation metrics.
- `data/clean.csv` – Curated feature set assembled from NFHS indicators (age structure, anthropometrics, hypertension, glucose control, wealth, insurance coverage).
- `data/raw/` – Source files used to build the clean dataset, plus `sources.md` documenting provenance.
- `data/reports/` – Placeholder for exploratory summaries (currently empty).
- `papers/` – Reference literature motivating the subtype weighting strategy.

## Methodology Highlights

1. **Standardisation:** NFHS indicators are z-scored nationally, with mean imputation for gaps.
2. **Derived indices:** Composite signals approximate insulin resistance, glucose burden, age distribution, and nutritional deficiency using weighted combinations of the standardised inputs.
3. **Subtype attribution:** Linear blends of the indices produce logits for the five recognised clusters (SIDD, SIRD, CIRDD, MOD, MARD). A row-wise softmax converts logits to percentage shares.
4. **Prior calibration:** Shares are smoothed with literature-informed national priors (lambda = 0.1) to prevent overfitting to noisy districts.
5. **Priority scoring:** District-level prioritisation scores combine diabetes burden, obesity prevalence, affluence (as a prescribing proxy), and subtype emphasis to flag GLP-1 readiness.

## Outputs

`out.csv` includes:
- `SIDD_pct`, `SIRD_pct`, `CIRDD_pct`, `MOD_pct`, `MARD_pct` – Calibrated subtype prevalence estimates per district (percentage scale).
- `Priority_Score` – Composite signal (0-centred, higher is higher urgency) blending diabetes, obesity, and affluence indicators.
- `GLP1_Focused_Priority_Score` – Variant score with additional weight on SIRD and MOD prevalence to reflect GLP-1 responsiveness.

Use these metrics to rank districts or feed downstream mapping/dashboards. The accompanying `audit` dataframe created inside the notebook (not exported) can be extended for diagnostics or visualisation.

## Data Sources

- NFHS-5 derived CSVs (`data/raw/kaggle.csv`, `data/raw/github.csv`) sourced from [Kaggle](https://www.kaggle.com/datasets/bhanupratapbiswas/national-family-health-survey-nfhs-2019-21) and the [NFHS-5 GitHub repository](https://github.com/pratapvardhan/NFHS-5).
- Cleaned indicators compiled into `data/clean.csv` for streamlined processing.

## References

- Ahlqvist, E. et al. “Novel subgroups of adult-onset diabetes and their association with outcomes.”
- Clustering studies on Indian populations (see PDFs under `papers/`) informing prior and weighting design.

## Next Steps

Potential extensions include exporting the audit frame for QA, integrating geospatial shapefiles for mapping, and experimenting with alternative priors or feature sets to stress-test robustness.

