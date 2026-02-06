# Genetic Contraindication Scoring

This module tracks state-level contraindication adjustments that complement the district subphenotype pipeline. Scores summarise how frequently genetic or comorbidity red flags appear alongside GLP-1 target signals and can be layered onto prioritisation outputs.

## Contents
- `data/state_scores.csv` – Normalised z-scores for each Indian state or union territory. Key columns:
  - `Target Score` captures uplift potential based on subtype prevalence and market readiness proxies.
  - `Contraindication Score` captures relative prevalence of risk factors that suppress treatment eligibility.
  - `Priority Score` blends the two to down-weight high-risk geographies.
- `scoring.ipynb` – Notebook that assembles the upstream indicators, applies weighting heuristics, and refreshes `state_scores.csv`.
- `plink.sh` – Shell helper for rebuilding any PLINK-derived intermediate metrics if future analyses introduce genotype inputs.

## Quick Use
1. Load `data/state_scores.csv` in pandas and merge on state or union territory names before presenting district recommendations.
2. When rerunning `scoring.ipynb`, document changed assumptions (weighting, indicator selection) inside the notebook and commit the regenerated CSV.
3. If PLINK workflows are required, adapt `plink.sh` with the appropriate dataset paths and credentials; keep derived binaries out of source control.

```python
import pandas as pd
scores = pd.read_csv("genetic/data/state_scores.csv")
```

## Integration Notes
- Apply the `Priority Score` as a multiplicative or subtractive modifier alongside `subphenotype/out/subphenotypes.csv` to introduce state-level risk context.
- Keep the CSV lightweight for presentation by limiting the number of supporting columns; stash exploratory columns in the notebook instead.
