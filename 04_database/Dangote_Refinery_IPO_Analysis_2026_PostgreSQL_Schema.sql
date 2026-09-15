-- Dangote Refinery IPO Investment Analysis
-- PostgreSQL star-schema database
-- Public-facing naming: clear table and column names, minimal abbreviations.

CREATE SCHEMA IF NOT EXISTS dangote_ipo;

CREATE TABLE IF NOT EXISTS dangote_ipo.companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(150) NOT NULL UNIQUE,
    company_type VARCHAR(50) NOT NULL,
    country VARCHAR(100),
    peer_group VARCHAR(50),
    is_dangote BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS dangote_ipo.time_periods (
    period_id SERIAL PRIMARY KEY,
    period_name VARCHAR(30) NOT NULL UNIQUE,
    calendar_year INT NOT NULL,
    period_type VARCHAR(20) NOT NULL,
    start_date DATE,
    end_date DATE
);

CREATE TABLE IF NOT EXISTS dangote_ipo.products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    product_category VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dangote_ipo.financial_performance (
    financial_performance_id BIGSERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES dangote_ipo.companies(company_id),
    period_id INT NOT NULL REFERENCES dangote_ipo.time_periods(period_id),
    revenue_usd_bn NUMERIC(18,4),
    cost_of_sales_usd_bn NUMERIC(18,4),
    gross_profit_usd_bn NUMERIC(18,4),
    operating_profit_usd_bn NUMERIC(18,4),
    finance_income_usd_bn NUMERIC(18,4),
    finance_cost_usd_bn NUMERIC(18,4),
    profit_before_tax_usd_bn NUMERIC(18,4),
    tax_usd_bn NUMERIC(18,4),
    net_profit_usd_bn NUMERIC(18,4),
    operating_cash_flow_usd_bn NUMERIC(18,4),
    investing_cash_flow_usd_bn NUMERIC(18,4),
    financing_cash_flow_usd_bn NUMERIC(18,4),
    UNIQUE(company_id, period_id)
);

CREATE TABLE IF NOT EXISTS dangote_ipo.refinery_operations (
    refinery_operations_id BIGSERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES dangote_ipo.companies(company_id),
    period_id INT NOT NULL REFERENCES dangote_ipo.time_periods(period_id),
    refinery_capacity_barrels_per_day NUMERIC(18,0),
    average_throughput_barrels_per_day NUMERIC(18,0),
    utilisation_percent NUMERIC(8,2),
    refining_margin_usd_per_barrel NUMERIC(10,2),
    UNIQUE(company_id, period_id)
);

CREATE TABLE IF NOT EXISTS dangote_ipo.product_sales (
    product_sales_id BIGSERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES dangote_ipo.companies(company_id),
    period_id INT NOT NULL REFERENCES dangote_ipo.time_periods(period_id),
    product_id INT NOT NULL REFERENCES dangote_ipo.products(product_id),
    sales_volume_tonnes NUMERIC(18,2),
    average_realised_price_usd_per_tonne NUMERIC(18,2),
    sales_revenue_usd_bn NUMERIC(18,4),
    UNIQUE(company_id, period_id, product_id)
);

CREATE TABLE IF NOT EXISTS dangote_ipo.market_conditions (
    market_conditions_id BIGSERIAL PRIMARY KEY,
    period_id INT NOT NULL REFERENCES dangote_ipo.time_periods(period_id),
    brent_crude_usd_per_barrel NUMERIC(10,2),
    gasoline_crack_usd_per_barrel NUMERIC(10,2),
    diesel_crack_usd_per_barrel NUMERIC(10,2),
    jet_fuel_crack_usd_per_barrel NUMERIC(10,2),
    usd_ngn_exchange_rate NUMERIC(12,2),
    notes TEXT,
    UNIQUE(period_id)
);

CREATE TABLE IF NOT EXISTS dangote_ipo.company_valuation (
    valuation_id BIGSERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES dangote_ipo.companies(company_id),
    period_id INT NOT NULL REFERENCES dangote_ipo.time_periods(period_id),
    share_price_ngn NUMERIC(18,2),
    market_value_usd_bn NUMERIC(18,4),
    enterprise_value_usd_bn NUMERIC(18,4),
    ev_to_ebitda_multiple NUMERIC(10,2),
    price_to_earnings_multiple NUMERIC(10,2),
    UNIQUE(company_id, period_id)
);

CREATE TABLE IF NOT EXISTS dangote_ipo.expansion_and_funding (
    expansion_funding_id BIGSERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES dangote_ipo.companies(company_id),
    period_id INT NOT NULL REFERENCES dangote_ipo.time_periods(period_id),
    current_capacity_barrels_per_day NUMERIC(18,0),
    target_capacity_barrels_per_day NUMERIC(18,0),
    expansion_capex_usd_bn NUMERIC(18,4),
    remaining_expansion_capex_usd_bn NUMERIC(18,4),
    ipo_proceeds_ngn_bn NUMERIC(18,4),
    cash_usd_bn NUMERIC(18,4),
    debt_usd_bn NUMERIC(18,4),
    net_debt_usd_bn NUMERIC(18,4),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS dangote_ipo.investment_scenarios (
    scenario_id SERIAL PRIMARY KEY,
    scenario_name VARCHAR(50) NOT NULL UNIQUE,
    refining_margin_usd_per_barrel NUMERIC(10,2),
    utilisation_percent NUMERIC(8,2),
    sustainable_ebitda_usd_bn NUMERIC(18,4),
    sustainable_net_profit_usd_bn NUMERIC(18,4),
    implied_equity_value_ngn_trillion NUMERIC(18,4),
    implied_share_price_ngn NUMERIC(18,2),
    upside_downside_percent NUMERIC(10,2),
    assumptions TEXT
);

CREATE TABLE IF NOT EXISTS dangote_ipo.investment_risks (
    risk_id SERIAL PRIMARY KEY,
    risk_name VARCHAR(100) NOT NULL UNIQUE,
    risk_category VARCHAR(50) NOT NULL,
    risk_description TEXT NOT NULL,
    potential_impact VARCHAR(20),
    measurable_driver VARCHAR(100),
    dashboard_message TEXT
);

CREATE INDEX IF NOT EXISTS idx_financial_company_period
ON dangote_ipo.financial_performance(company_id, period_id);

CREATE INDEX IF NOT EXISTS idx_operations_company_period
ON dangote_ipo.refinery_operations(company_id, period_id);

CREATE INDEX IF NOT EXISTS idx_product_sales_company_period
ON dangote_ipo.product_sales(company_id, period_id);

CREATE INDEX IF NOT EXISTS idx_valuation_company_period
ON dangote_ipo.company_valuation(company_id, period_id);

CREATE INDEX IF NOT EXISTS idx_expansion_company_period
ON dangote_ipo.expansion_and_funding(company_id, period_id);
