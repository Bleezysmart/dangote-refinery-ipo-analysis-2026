# PostgreSQL Database

This folder contains the PostgreSQL implementation and analytical SQL used for the Dangote Refinery IPO Analysis 2026.

## Purpose

The database provides the structured analytical layer between the collected source data and the Power BI investment dashboard. It stores financial performance, refinery operations, product sales, market conditions, valuation, expansion/funding, scenarios and investment risks in a relational model.

## Schema

The project uses the `dangote_ipo` schema. The main entity and fact tables are:

- `companies` — company master data and Dangote/peer identification.
- `time_periods` — reporting-period dimension.
- `products` — product dimension.
- `financial_performance` — revenue, profitability and cash-flow data.
- `refinery_operations` — capacity, throughput, utilisation and refining-margin data.
- `product_sales` — product-level revenue, volume and realised-price data.
- `market_conditions` — crude, product-crack and FX market inputs.
- `company_valuation` — share price, market value, enterprise value and valuation multiples.
- `expansion_and_funding` — capacity targets, expansion capital, IPO proceeds and debt/cash position.
- `investment_scenarios` — valuation scenarios and their assumptions.
- `investment_risks` — documented investment risks and measurable drivers.
- `peer_benchmarks` — selected peer utilisation and refining-margin benchmarks used by the peer-comparison analysis.

## Analytical SQL

| File | Business question |
|---|---|
| `01_financial_performance.sql` | How has financial performance changed from FY2024 through H1 2026? |
| `02_operating_performance.sql` | How has utilisation, throughput and refining margin changed? |
| `03_product_sales.sql` | What products are driving H1 2026 revenue? |
| `04_peer_comparison.sql` | How does Dangote compare with selected global refining peers? |
| `05_valuation.sql` | What earnings power does the ₦525 IPO price assume? |
| `06_risk_analysis.sql` | What factors could weaken the investment thesis? |

Each SQL file documents its business question, analytical objective, methodology and limitations before the queries.

## Reproducing the database

1. Install PostgreSQL.
2. Create a database for the project.
3. Run `Dangote_Refinery_IPO_Analysis_2026_PostgreSQL_Schema.sql`.
4. Load the project datasets into the corresponding tables.
5. Run the analytical SQL files in sequence to reproduce the analysis outputs.
6. Connect the resulting tables to Power BI for dashboard modelling and visualisation.

The schema script is the structural definition; the numbered SQL files are analytical queries and are not intended to recreate tables.

## Period convention

The core historical financial and operating analysis covers:

- FY2024
- H1 2025
- FY2025
- H1 2026

H1 2026 is a six-month reporting period. Where the valuation analysis annualises H1 figures, the result is explicitly a run-rate calculation and not a full-year forecast.

## Units

Unless otherwise stated:

- USD billions: financial, valuation and funding amounts.
- NGN/share: IPO/share-price figures.
- NGN billions/trillions: selected IPO and valuation figures where specified.
- barrels per day (bpd): refinery capacity and throughput.
- USD/bbl: refining-margin measures.
- tonnes: product sales volumes where available.
- percentages: utilisation, margins, revenue shares and scenario upside/downside.

## Important analytical limitations

### EBITDA availability

The live `financial_performance` table used during validation does not contain an EBITDA column. Query 05 therefore uses reported operating profit for its SQL-based earnings-power calculation rather than treating operating profit as EBITDA.

The wider project may contain EBITDA figures derived or reconstructed elsewhere. Those should be clearly labelled as such rather than presented as a directly reported database field.

### Peer comparison

Dangote is benchmarked using H1 2026 data while the selected global refinery peers use FY2025 data. Refining-margin definitions also differ between companies. The peer output is therefore contextual benchmarking, not a perfectly like-for-like comparison.

### Risk register

The database risk register does not contain a separate severity field. Query 06 therefore reports the documented risk information without inventing High/Medium/Low ratings.

### Data quality

The product-sales dataset was corrected to include CBFS, LPG and Propane so the eight-product H1 2026 revenue schedule reconciles to reported H1 2026 revenue. A separate H1 2026 cash-flow reconciliation issue was retained as a documented limitation rather than silently replacing one reported figure with another.

## Relationship to Power BI

PostgreSQL provides the structured source layer. Power BI uses the resulting financial, operating, sales, valuation, funding, peer and risk data to produce the six-page investment dashboard:

1. IPO At a Glance
2. Operating Performance
3. Peer Comparison
4. Growth & Funding
5. Valuation
6. Investment Conclusion

The database and SQL outputs are intended to make the analytical process auditable and reproducible rather than serving as a replacement for the research report or dashboard.
