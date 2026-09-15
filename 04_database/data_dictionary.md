# Data Dictionary

## Database schema

Schema name: `dangote_ipo`

The database separates descriptive dimensions from analytical fact tables. Foreign keys use `company_id`, `period_id` and `product_id` to connect records across the model.

## Dimension / master tables

### `companies`

| Field | Meaning | Typical use |
|---|---|---|
| `company_id` | Unique company identifier | Primary/foreign key |
| `company_name` | Company name | Labels and joins |
| `company_type` | Company classification | Peer selection |
| `country` | Company country | Peer context |
| `comparison_group` / `peer_group` | Peer classification field in the project model | Peer grouping |
| `is_dangote` | Boolean flag identifying Dangote Refinery | Filters the focal company |

> **Implementation note:** the live PostgreSQL instance used during project validation exposed `comparison_group` rather than `peer_group`. The repository schema script should be kept aligned with the live implementation before a third party recreates the database from scratch.

### `time_periods`

| Field | Meaning |
|---|---|
| `period_id` | Unique reporting-period identifier |
| `period_name` | Display period, e.g. FY2024 or H1 2026 |
| `calendar_year` | Calendar year |
| `period_type` | Reporting-period type |
| `start_date` | Period start |
| `end_date` | Period end |

Core periods used in the analysis: FY2024, H1 2025, FY2025 and H1 2026.

### `products`

| Field | Meaning |
|---|---|
| `product_id` | Unique product identifier |
| `product_name` | Product name |
| `product_category` | Product classification |

## Fact tables

### `financial_performance`

| Field | Unit | Meaning |
|---|---|---|
| `financial_performance_id` | ID | Unique record |
| `company_id` | ID | Company key |
| `period_id` | ID | Reporting-period key |
| `revenue_usd_bn` | USD bn | Revenue |
| `cost_of_sales_usd_bn` | USD bn | Cost of sales |
| `gross_profit_usd_bn` | USD bn | Gross profit |
| `operating_profit_usd_bn` | USD bn | Operating profit |
| `finance_income_usd_bn` | USD bn | Finance income |
| `finance_cost_usd_bn` | USD bn | Finance cost |
| `profit_before_tax_usd_bn` | USD bn | Profit before tax |
| `tax_usd_bn` | USD bn | Tax expense |
| `net_profit_usd_bn` | USD bn | Net profit |
| `operating_cash_flow_usd_bn` | USD bn | Operating cash flow |
| `investing_cash_flow_usd_bn` | USD bn | Investing cash flow |
| `financing_cash_flow_usd_bn` | USD bn | Financing cash flow |

**Important:** EBITDA is not a field in the live `financial_performance` table. SQL valuation analysis therefore uses operating profit where an earnings-power measure is required.

### `refinery_operations`

| Field | Unit | Meaning |
|---|---|---|
| `refinery_operations_id` | ID | Unique record |
| `company_id` | ID | Company key |
| `period_id` | ID | Reporting-period key |
| `refinery_capacity_barrels_per_day` | bpd | Installed refinery capacity |
| `average_throughput_barrels_per_day` | bpd | Average crude processed |
| `utilisation_percent` | % | Capacity utilisation |
| `refining_margin_usd_per_barrel` | USD/bbl | Refining-margin measure |

### `product_sales`

| Field | Unit | Meaning |
|---|---|---|
| `product_sales_id` | ID | Unique record |
| `company_id` | ID | Company key |
| `period_id` | ID | Reporting-period key |
| `product_id` | ID | Product key |
| `sales_volume_tonnes` | tonnes | Sales volume where available |
| `average_realised_price_usd_per_tonne` | USD/tonne | Realised price where available |
| `sales_revenue_usd_bn` | USD bn | Product sales revenue |

NULL volume or realised-price values are retained where the source data did not provide a value; they are not imputed.

### `market_conditions`

| Field | Unit | Meaning |
|---|---|---|
| `market_conditions_id` | ID | Unique record |
| `period_id` | ID | Reporting-period key |
| `brent_crude_usd_per_barrel` | USD/bbl | Brent crude benchmark |
| `gasoline_crack_usd_per_barrel` | USD/bbl | Gasoline crack benchmark |
| `diesel_crack_usd_per_barrel` | USD/bbl | Diesel crack benchmark |
| `jet_fuel_crack_usd_per_barrel` | USD/bbl | Jet-fuel crack benchmark |
| `usd_ngn_exchange_rate` | NGN/USD | FX input |
| `notes` | Text | Contextual notes |

### `company_valuation`

| Field | Unit | Meaning |
|---|---|---|
| `valuation_id` | ID | Unique valuation record |
| `company_id` | ID | Company key |
| `period_id` | ID | Valuation-period key |
| `share_price_ngn` | NGN/share | Share price reference |
| `market_value_usd_bn` | USD bn | Equity/market value |
| `enterprise_value_usd_bn` | USD bn | Enterprise/business value |
| `ev_to_ebitda_multiple` | x | Stored EV/EBITDA multiple where available |
| `price_to_earnings_multiple` | x | Stored P/E multiple where available |

### `expansion_and_funding`

| Field | Unit | Meaning |
|---|---|---|
| `expansion_funding_id` | ID | Unique record |
| `company_id` | ID | Company key |
| `period_id` | ID | Reporting-period key |
| `current_capacity_barrels_per_day` | bpd | Current capacity |
| `target_capacity_barrels_per_day` | bpd | Target capacity |
| `expansion_capex_usd_bn` | USD bn | Expansion programme |
| `remaining_expansion_capex_usd_bn` | USD bn | Remaining spending |
| `ipo_proceeds_ngn_bn` | NGN bn | IPO proceeds |
| `cash_usd_bn` | USD bn | Cash balance |
| `debt_usd_bn` | USD bn | Debt balance |
| `net_debt_usd_bn` | USD bn | Net debt |
| `notes` | Text | Funding/expansion notes |

### `peer_benchmarks`

This table is present in the live PostgreSQL database and supports Query 04.

| Field | Unit | Meaning |
|---|---|---|
| `peer_benchmark_id` | ID | Unique benchmark record |
| `company_id` | ID | Peer company key |
| `period_id` | ID | Benchmark period key |
| `utilisation_pct` | % | Capacity utilisation benchmark |
| `refining_margin_usd_per_bbl` | USD/bbl | Refining-margin benchmark |

The project uses Dangote H1 2026 (`period_id = 4`) and selected refinery peers at FY2025 (`period_id = 2`).

## Analytical tables

### `investment_scenarios`

| Field | Unit | Meaning |
|---|---|---|
| `scenario_id` | ID | Scenario identifier |
| `scenario_name` | Text | Stress, Bear, Base, Strong or Bull |
| `refining_margin_usd_per_barrel` | USD/bbl | Scenario refining margin |
| `utilisation_percent` | % | Scenario utilisation |
| `sustainable_ebitda_usd_bn` | USD bn | Scenario EBITDA assumption |
| `sustainable_net_profit_usd_bn` | USD bn | Scenario net-profit assumption |
| `implied_equity_value_ngn_trillion` | NGN tn | Scenario equity value |
| `implied_share_price_ngn` | NGN/share | Scenario share price |
| `upside_downside_percent` | % | Scenario change versus IPO reference |
| `assumptions` | Text | Scenario assumptions |

### `investment_risks`

| Field | Meaning |
|---|---|
| `risk_id` | Risk identifier |
| `risk_name` | Named investment risk |
| `risk_category` | Risk classification |
| `risk_description` | Description of the risk |
| `potential_impact` | Documented potential impact |
| `measurable_driver` | Indicator that can be monitored |
| `dashboard_message` | Dashboard interpretation |

The live risk table does not contain a separate severity field. The project therefore does not invent a High/Medium/Low rating in Query 06.

## Key modelling conventions

### Primary keys

Each main table has a unique identifier. Fact tables connect to dimensions through foreign keys.

### Period handling

Full-year and half-year periods are kept as separate reporting periods. H1 2026 is not treated as a full-year result.

### Annualisation

Where used in valuation analysis:

`Annualised H1 figure = H1 figure × 2`

This is a run-rate calculation, not a forecast.

### Currency

The core financial and valuation datasets use USD billions for comparability. IPO/share-price analysis uses NGN where explicitly stated.

### Data quality

The product-sales schedule was corrected to include CBFS, LPG and Propane, allowing the eight-product H1 2026 revenue total to reconcile to approximately $13.91B. A separate H1 2026 cash-flow reconciliation issue was retained as a documented limitation.

## Source lineage

The database is supported by the source-pack files in `03_data/source_pack_csv/`, including the source map, collection priorities and data schema. The research report and SQL files document the analytical treatment and limitations.
