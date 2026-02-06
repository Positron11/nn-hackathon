# Novo Nordisk Hackathon: Diabetes Strategy Workbench

This repository assembles the analytics, simulations, and market intelligence used in our Novo Nordisk hackathon submission on prioritising type 2 diabetes subphenotypes across India. Each module is notebook-first and ships with lightweight datasets so the full decision flow can be rerun end to end.

## Platform Modules
- **Subphenotype intelligence (`subphenotype/`)** translates NFHS-5 indicators into district-level subtype mixes and readiness signals for GLP-1 launches.
- **Genetic + contraindication overlays (`genetic/`)** temper district scores with state-level risk modifiers derived from literature and claims heuristics.
- **Cost-benefit modelling (`cba/`)** runs Monte Carlo scenarios on payer economics when expanding GLP-1 coverage.
- **Market intelligence (`market/`)** compiles analogue drug launches, price erosion patterns, and similarity scoring to guide launch positioning.
- **Early opportunity sizing (`preliminary/`)** experiments with quick-turn forecasting narratives and infographics used in ideation workshops.
- **Visual analytics (`visualization/`)** packages folium heatmaps and dashboards that surface geographic prioritisation outputs for stakeholders.

## Directory Overview
| Path | Focus | Primary Assets |
| --- | --- | --- |
| `subphenotype/` | Feature engineering, subtype scoring, prioritisation heuristics | `pipeline.ipynb`, `docs/`, `data/`, `out/` |
| `subphenotype/data/` | NFHS-5 provenance, processed inputs, geospatial layers | `clean.csv`, `raw/`, `assets/`, `reports/` |
| `genetic/` | State-level modifiers for contraindications vs. uplift | `scoring.ipynb`, `data/state_scores.csv`, `plink.sh` |
| `cba/` | GLP-1 coverage Monte Carlo economics | `simulation.ipynb`, `data/costs.csv`, `data/transitions.csv` |
| `market/` | Pricing erosion, competitor similarity, undercut modelling | `Erosion_predicition.ipynb`, curated CSVs |
| `preliminary/` | Exploratory forecasting visuals and back-of-the-envelope sizing | `forecasting.ipynb`, generated PNG exports |
| `visualization/` | Folium heatmaps and other rendered artefacts | `heatmap.ipynb`, `out/` |
| `docs/` | Narrative collateral for the hackathon submission | `report.md`, `images/` |
| `subphenotype/papers/` | Background literature snapshots referenced in notebooks | Diabetes cluster PDFs |
| `requirements.txt` | Minimal Python environment spec | Dependency pin list |

## Suggested Workflow
1. **Reproduce subtype baselines:** Execute `subphenotype/pipeline.ipynb` to refresh district-level subtype shares and prioritisation metrics.
2. **Layer contraindication context:** Blend `genetic/data/state_scores.csv` into downstream reports to adjust for genetic and comorbidity risk.
3. **Stress test economics:** Tweak coverage assumptions inside `cba/simulation.ipynb` to quantify potential payer ROI.
4. **Assess competitive pressure:** Explore the notebooks and data inside `market/` to understand likely price erosion and competitor similarity scenarios.
5. **Publish visuals & narratives:** Run the folium workflows in `visualization/` and leverage the quick-turn artefacts in `preliminary/` when socialising early findings.

## Getting Started
1. Use Python 3.9 or later and create a virtual environment in the repo root.
2. Install dependencies with `pip install -r requirements.txt`.
3. Launch Jupyter Lab or VS Code notebooks and open the module-specific notebooks listed above.
4. Refer to the README within each module for execution notes, parameter descriptions, and data provenance.

## Data Stewardship & Credits
- `subphenotype/data/README.md` catalogues NFHS-5 sources, indicator transformations, and licensing notes.
- Market analogues originate from public pricing datasets and secondary research; see inline notebook citations for attribution.
- Simulation parameters in `cba/` combine published literature with payer heuristics—update assumptions inline and document changes.
- Quick-turn forecasts in `preliminary/` rely on conference slide digitisation; treat the numbers as directional and update when fresher market signals arrive.

## Support & Extensions
Questions, new assumptions, or additional scenarios can be tracked inside the module READMEs or the `subphenotype/docs/` notes. Extend notebooks with scenario branches and commit derived outputs to the corresponding `out/` folders for traceability.
