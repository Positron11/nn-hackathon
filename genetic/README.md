# Genetic Contraindication Scoring

This module tracks state-level contraindication adjustments that complement the district subphenotype pipeline. Scores summarise how frequently genetic or comorbidity red flags appear alongside GLP-1 target signals.

## Contents
- `data/state_scores.csv` – Normalised z-scores for each Indian state or union territory:
  - `Target Score` captures uplift potential based on subtype prevalence and market readiness proxies.
  - `Contraindication Score` captures relative prevalence of risk factors that suppress treatment eligibility.
  - `Priority Score` is the combined heuristic that penalises contraindications while rewarding target potential.

## Usage
Load the CSV into pandas to merge state-level adjustments back into downstream reporting:

```python
import pandas as pd

scores = pd.read_csv("genetic/data/state_scores.csv")
```

The scores are designed to be applied as state-wide modifiers atop district estimates when ranking launch geographies. Extend or regenerate the table in a notebook of your choice; document additional derivations alongside the CSV.
