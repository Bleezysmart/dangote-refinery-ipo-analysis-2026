# Dangote Refinery IPO Analysis 2026

**Investment Research, Financial Modelling, Valuation & Power BI Dashboard**

A portfolio project examining the Dangote Petroleum Refinery & Petrochemicals IPO at **₦525 per share**, using reported financial and operating data through **H1 2026**.

## Research question

> **Is ₦525 fair?**

The analysis does not attempt to prove that the IPO is attractive or unattractive. It separates reported facts, analyst calculations, explicit valuation assumptions, scenario outputs and data limitations to test what earnings power the offer price requires.

## Key findings

| Metric | H1 2026 / IPO reference |
|---|---:|
| IPO offer price | ₦525/share |
| Post-IPO equity value | ~$47.82B |
| Business value | ~$49.22B |
| Revenue | $13.91B |
| Net profit | $1.82B |
| Analytical EBITDA / operating earnings | ~$2.60B |
| Refinery utilization | 83.6% |
| Refining margin | $24.50/bbl |
| Net debt | $1.40B |
| Expansion programme | ~$14.30B |
| Remaining expansion spending | ~$11.80B |

## Valuation framework

A **10× EV/EBITDA** multiple is used as an explicit analyst assumption, not as a reported company valuation.

- Required sustainable operating earnings: **~$4.92B**
- Annualized H1 2026 operating earnings: **~$5.20B**
- Headroom: **~$0.28B**
- Base scenario implied share price: **₦446**
- Scenario range: **₦314–₦588**

Annualized H1 2026 figures are a **run-rate, not a forecast**.

The PostgreSQL financial table does not store EBITDA as a reported field. The project therefore distinguishes the analytical/reconstructed EBITDA used in the valuation framework from the reported operating-profit field stored in the database.

## What the project demonstrates

- PostgreSQL star-schema data modelling
- Financial statement and operating-performance analysis
- Power BI dashboard development
- Refinery throughput, utilization and margin analysis
- Global peer benchmarking
- IPO valuation and scenario analysis
- Funding and expansion-capex analysis
- Risk and thesis-break analysis
- Data-quality reconciliation and source tracking

## Data-quality note

The original product-sales workbook omitted three H1 2026 revenue lines: **CBFS, LPG and Propane**. These were reconciled to the reported H1 2026 revenue total and incorporated into the corrected analytical workbook and project datasets. The original workbook is retained for data lineage, while `Dangote_IPO_Data_Collection_FINAL.xlsx` is the corrected workbook.

A separate H1 2026 cash-flow reconciliation issue is documented in the research report rather than silently replacing one reported figure with another.

## Project structure

```text
01_dashboard/
  ├── Dashboard PDF
  └── README.md

02_research/
  ├── Full research report
  ├── Investor snapshot
  └── README.md

03_data/
  ├── Dangote_IPO_Data_Collection_v2.xlsx       # original collection workbook
  ├── Dangote_IPO_Data_Collection_FINAL.xlsx    # corrected workbook
  ├── Analytical CSV datasets
  ├── Source-pack CSVs
  └── README.md

04_database/
  ├── PostgreSQL schema
  ├── Six analytical SQL queries
  ├── Database README
  └── Data dictionary
```

## Dashboard pages

1. IPO At a Glance
2. Operating Performance
3. Peer Comparison
4. Growth & Funding
5. Valuation
6. Investment Conclusion

## Sources

Primary and secondary sources used include the Dangote Refinery IPO prospectus and H1 2026 disclosures, Nigeria's Securities and Exchange Commission, company filings from selected global refinery peers, and relevant financial reporting.

Key public references:

- SEC Nigeria: https://www.sec.gov.ng/for-investors/keep-track-of-circulars/dangote-petroleum-refinery-and-petrochemicals-initial-public-offering/
- Reuters — IPO facts: https://www.reuters.com/business/energy/facts-about-nigerias-dangote-oil-refinery-initial-public-offering-2026-09-14/
- Reuters — H1 2026 earnings: https://www.reuters.com/business/energy/dangote-profits-europe-fuel-crunch-ipo-tests-investor-appetite-2026-09-15/

## Important disclosure

This repository contains an independent analytical research project for educational and portfolio purposes. It is not a prospectus, solicitation, personalised investment recommendation or financial advice. Historical and H1 2026 results do not guarantee future performance, and scenario outputs depend on the assumptions stated in the report.

**Author:** CryptoKnight / Bleezysmart  
**Project:** Dangote Refinery IPO Analysis 2026
