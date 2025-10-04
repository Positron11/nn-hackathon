# Cost-Benefit Analysis Prototype

The `simulation.ipynb` notebook models the long-term financial impact of expanding GLP-1 coverage (e.g., Wegovy) for an insured population. It uses a Monte Carlo engine to simulate chronic condition onset, downstream complications, and payer costs under varying assumptions.

## Notebook Overview
- **Population setup:** Adjustable constants (`POPULATION_SIZE`, age bands, `PERCENTAGE_COVERED`) configure cohort size, coverage penetration, and time horizon (`SIMULATION_YEARS`).
- **Clinical probabilities:** First- and second-order dictionaries encode baseline incidence and conditional progression rates for cardiometabolic and obesity-related conditions in obese versus non-obese groups.
- **Intervention effect:** `efficacy_factors` specify relative risk reductions attributable to GLP-1 therapy for key outcomes.
- **Economic inputs:** `annual_costs` and `one_time_costs` capture payer burden by condition; totals are offset by annualised therapy costs (`WEGOVY_ANNUAL_COST`).

## Running the Simulation
1. Install dependencies from `requirements.txt` and start Jupyter in the repository root.
2. Open `cba/simulation.ipynb` and execute the cells top to bottom, adjusting parameters to explore alternative coverage strategies.
3. Capture summary statistics or cash flow projections produced by the notebook for downstream reporting.
