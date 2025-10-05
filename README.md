# Novo Nordisk Hackathon: Diabetes Strategy Workbench

This repository assembles the analytics, simulations, and market intelligence that informed our Novo Nordisk hackathon submission on prioritising type 2 diabetes subphenotypes across India. Each module is notebook-first and ships with lightweight datasets so the full decision flow can be rerun end to end.

## Platform Modules
- **Subphenotype intelligence (`subphenotype/`)** translates NFHS-5 indicators into district-level subtype mixes and readiness signals for GLP-1 launches.
- **Genetic + contraindication overlays (`genetic/`)** temper district scores with state-level risk modifiers derived from literature and claims heuristics.
- **Cost-benefit modelling (`cba/`)** runs Monte Carlo scenarios on payer economics when expanding GLP-1 coverage.
- **Market intelligence (`market/`)** compiles analogue drug launches, price erosion patterns, and similarity scoring to guide launch positioning.
- **Visual analytics (`visualization/`)** packages folium heatmaps and dashboards that surface geographic prioritisation outputs for stakeholders.

## Directory Overview
| Path | Focus | Primary Assets |
| --- | --- | --- |
| `subphenotype/` | Feature engineering, subtype scoring, prioritisation heuristics | `pipeline.ipynb`, `docs/`, `data/`, `out/` |
| `genetic/` | State-level modifiers for contraindications vs. uplift | `data/state_scores.csv`, `README.md` |
| `cba/` | GLP-1 coverage Monte Carlo economics | `simulation.ipynb`, `README.md` |
| `market/` | Pricing erosion, competitor similarity, undercut modelling | `README.md`, market CSVs, scenario notebooks |
| `visualization/` | Folium heatmaps and other rendered artefacts | `heatmap.ipynb`, `out/` |
| `papers/` | Background literature snapshots referenced in notebooks | PDF notes |
| `requirements.txt` | Minimal Python environment spec | Dependency pin list |

## Suggested Workflow
1. **Reproduce subtype baselines:** Execute `subphenotype/pipeline.ipynb` to refresh district-level subtype shares and prioritisation metrics.
2. **Layer contraindication context:** Blend `genetic/data/state_scores.csv` into downstream reports to adjust for genetic and comorbidity risk.
3. **Stress test economics:** Tweak coverage assumptions inside `cba/simulation.ipynb` to quantify potential payer ROI.
4. **Assess competitive pressure:** Explore the notebooks and data inside `market/` to understand likely price erosion and competitor similarity scenarios.
5. **Publish visuals:** Run `visualization/heatmap.ipynb` (or export from the `subphenotype` notebooks) to regenerate decision-ready maps.

## Getting Started
1. Use Python 3.9 or later and create a virtual environment in the repo root.
2. Install dependencies with `pip install -r requirements.txt`.
3. Launch Jupyter Lab or VS Code notebooks and open the module-specific notebooks listed above.
4. Refer to the README within each module for execution notes, parameter descriptions, and data provenance.

## Data Stewardship & Credits
- `subphenotype/data/README.md` catalogues NFHS-5 sources, indicator transformations, and licensing notes.
- Market analogues originate from public pricing datasets and secondary research; see inline notebook citations for attribution.
- Simulation parameters in `cba/` combine published literature with payer heuristics—update assumptions inline and document changes.

## Support & Extensions
Questions, new assumptions, or additional scenarios can be tracked inside the module READMEs or the `subphenotype/docs/` notes. Extend notebooks with scenario branches and commit derived outputs to the corresponding `out/` folders for traceability.
