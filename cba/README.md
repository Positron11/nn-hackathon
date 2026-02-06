# Cost-Benefit Analysis Prototype

The `simulation.ipynb` notebook models the long-term financial impact of expanding GLP-1 coverage (e.g., Wegovy) for an insured population. It uses a Monte Carlo engine to simulate chronic condition onset, downstream complications, and payer costs under varying assumptions.

## Inputs & Configuration
- `data/costs.csv` – Annual and one-time payer cost assumptions by condition.
- `data/transitions.csv` – Baseline incidence and progression probabilities for the simulated cohort.
- In-notebook constants configure cohort size (`POPULATION_SIZE`), coverage penetration, time horizon (`SIMULATION_YEARS`), and therapy cost assumptions (`WEGOVY_ANNUAL_COST`).

## Running the Notebook
1. Install dependencies from the repository root (`pip install -r ../requirements.txt`) and start Jupyter.
2. Open `simulation.ipynb` and review the assumption cells at the top before executing.
3. Run all cells to generate scenario tables, cumulative savings, and visual summaries.
4. Export results (e.g., CSV tables or plots) to `out/` or paste directly into the presentation deck.

## Extending the Model
- Adjust probability tables in `data/transitions.csv` to reflect newer clinical evidence or segmented cohorts.
- Swap in alternative cost scenarios by editing `data/costs.csv` or duplicating the notebook for side-by-side comparisons.
- Wire the outputs into the `market/` notebooks to test sensitivity to pricing curves or into `preliminary/` visuals for quick narratives.

Document material changes to assumptions either in new notebook markdown cells or a short changelog appended to this README.
