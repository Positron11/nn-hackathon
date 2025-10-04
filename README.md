# Novo Nordisk Hackathon: Diabetes Subtype Prioritization

This repository stores the material submitted for the Novo Nordisk Hackathon track on prioritising type 2 diabetes subphenotypes. The end-to-end notebooks, data, derived outputs, and supporting prototypes live in the `subphenotype/`, `genetic/`, and `cba/` project directories.

## Repository Layout
- `subphenotype/` – Notebook-driven pipeline, visualisations, and datasets for subtype attribution and district prioritisation.
- `genetic/` – Aggregated genetic signal scoring for states, capturing contraindication risk versus prioritisation uplift (see `genetic/README.md`).
- `cba/` – Monte Carlo cost-benefit simulations for GLP-1 coverage decisions (see `cba/README.md`).
- `requirements.txt` – Reproducible Python environment for running the notebooks.

## Getting Started
1. Use Python 3.9+ and create a virtual environment in the repository root.
2. Install dependencies with `pip install -r requirements.txt`.
3. Follow the workflow documented in `subphenotype/README.md` to reproduce the subtype analysis or generate updated artefacts.
4. Review the module-specific READMEs for context and execution tips on the genetic scoring and cost-benefit simulations.

## Data & Credits
The data dependencies and source attributions are catalogued in `subphenotype/data/README.md`. Refer to that document before reusing the datasets.

## Support
For questions or extensions, start with the methodology notes in `subphenotype/README.md` and iterate from there.
