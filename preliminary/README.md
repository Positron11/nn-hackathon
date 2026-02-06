# Preliminary Opportunity Sizing

This folder holds quick-turn artefacts created during early ideation workshops. The goal is to translate rough secondary research signals into shareable visuals before the core models are finalised.

## Notebook
- `forecasting.ipynb` – Back-of-the-envelope semaglutide market forecast for India using obesity prevalence ratios and German market growth benchmarks. The notebook generates both narrative infographics and a growth bar chart for inclusion in slides.

## Running the Notebook
1. Install repository dependencies (`pip install -r ../requirements.txt`) and launch Jupyter.
2. Open `forecasting.ipynb`, adjust the hard-coded prevalence or market size assumptions as new source material arrives, then execute the notebook.
3. Regenerated visuals will be saved locally as PNG files alongside the notebook.

## Outputs
- `india_market_projection_infographic.png` – Side-by-side comparison of German benchmarks vs. projected Indian market size.
- `india_market_growth_chart.png` – Annual projection of India’s semaglutide market (2022–2035) assuming Germany’s observed CAGR.

Treat the figures as directional placeholders until validated pricing data and adoption curves are introduced into the main `market/` and `cba/` models.
