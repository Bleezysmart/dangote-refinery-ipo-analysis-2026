/*
====================================================================
DANGOTE REFINERY IPO ANALYSIS
01 — FINANCIAL PERFORMANCE
====================================================================

BUSINESS QUESTION
-----------------
How has Dangote Refinery's financial performance changed from
FY2024 through H1 2026?

ANALYTICAL OBJECTIVE
--------------------
Evaluate the company's financial turnaround leading into the IPO by
examining:

1. Revenue
2. Gross profit and gross margin
3. Operating profit and operating margin
4. Net profit and net margin
5. Operating cash flow

METHODOLOGY
-----------
- Financial data is joined to the reporting-period dimension.
- The company is identified using the is_dangote flag rather than
  relying on a hard-coded company name.
- Profit margins are calculated from reported revenue and profit
  figures.
- Periods are displayed in chronological order.
- Reported financial figures are presented in USD billions.
- H1 2026 is treated as a six-month reporting period and is not
  treated as a full-year forecast.

ANALYTICAL PURPOSE
------------------
The output supports the Power BI financial-performance analysis and
provides the historical earnings context required for the subsequent
valuation analysis.

DATA PERIOD
-----------
FY2024
H1 2025
FY2025
H1 2026

====================================================================
*/


-- ================================================================
-- 1. CORE FINANCIAL PERFORMANCE
-- ================================================================
-- Shows the reported financial performance for each period and
-- calculates the major profitability margins.
-- ================================================================

SELECT
    tp.period_name,

    -- Revenue
    fp.revenue_usd_bn,

    -- Gross profit
    fp.gross_profit_usd_bn,

    -- Operating profit
    fp.operating_profit_usd_bn,

    -- Net profit
    fp.net_profit_usd_bn,

    -- Operating cash flow
    fp.operating_cash_flow_usd_bn,

    -- Gross margin
    ROUND(
        (
            fp.gross_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS gross_margin_pct,

    -- Operating margin
    ROUND(
        (
            fp.operating_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS operating_margin_pct,

    -- Net margin
    ROUND(
        (
            fp.net_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS net_margin_pct

FROM dangote_ipo.financial_performance AS fp

INNER JOIN dangote_ipo.time_periods AS tp
    ON fp.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON fp.company_id = c.company_id

WHERE c.is_dangote = TRUE

ORDER BY
    CASE tp.period_name
        WHEN 'FY2024' THEN 1
        WHEN 'H1 2025' THEN 2
        WHEN 'FY2025' THEN 3
        WHEN 'H1 2026' THEN 4
        ELSE 5
    END;


-- ================================================================
-- 2. PROFITABILITY TURNAROUND
-- ================================================================
-- Is the company moving from the ramp-up losses seen in earlier
-- periods toward sustainable profitability?
--
-- This query isolates revenue, profit and margin indicators so the
-- turnaround can be reviewed without mixing in valuation assumptions.
-- ================================================================

SELECT
    tp.period_name,

    fp.revenue_usd_bn AS revenue_usd_bn,

    fp.gross_profit_usd_bn AS gross_profit_usd_bn,

    fp.operating_profit_usd_bn AS operating_profit_usd_bn,

    fp.net_profit_usd_bn AS net_profit_usd_bn,

    ROUND(
        (
            fp.gross_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS gross_margin_pct,

    ROUND(
        (
            fp.operating_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS operating_margin_pct,

    ROUND(
        (
            fp.net_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS net_margin_pct

FROM dangote_ipo.financial_performance AS fp

INNER JOIN dangote_ipo.time_periods AS tp
    ON fp.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON fp.company_id = c.company_id

WHERE c.is_dangote = TRUE

ORDER BY
    CASE tp.period_name
        WHEN 'FY2024' THEN 1
        WHEN 'H1 2025' THEN 2
        WHEN 'FY2025' THEN 3
        WHEN 'H1 2026' THEN 4
        ELSE 5
    END;


-- ================================================================
-- 3. CASH GENERATION
-- ================================================================
-- Examines whether improving accounting profitability is also being
-- accompanied by stronger operating cash generation.
-- ================================================================

SELECT
    tp.period_name,

    fp.operating_cash_flow_usd_bn,

    CASE
        WHEN fp.operating_cash_flow_usd_bn > 0
            THEN 'Positive'

        WHEN fp.operating_cash_flow_usd_bn < 0
            THEN 'Negative'

        ELSE 'Break-even'
    END AS cash_flow_status

FROM dangote_ipo.financial_performance AS fp

INNER JOIN dangote_ipo.time_periods AS tp
    ON fp.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON fp.company_id = c.company_id

WHERE c.is_dangote = TRUE

ORDER BY
    CASE tp.period_name
        WHEN 'FY2024' THEN 1
        WHEN 'H1 2025' THEN 2
        WHEN 'FY2025' THEN 3
        WHEN 'H1 2026' THEN 4
        ELSE 5
    END;


-- ================================================================
-- 4. FINANCIAL PERFORMANCE SUMMARY
-- ================================================================
-- Compact output for quickly reviewing the major financial
-- indicators used in the investment dashboard.
-- ================================================================

SELECT
    tp.period_name,

    ROUND(fp.revenue_usd_bn, 2)
        AS revenue_usd_bn,

    ROUND(fp.operating_profit_usd_bn, 2)
        AS operating_profit_usd_bn,

    ROUND(fp.net_profit_usd_bn, 2)
        AS net_profit_usd_bn,

    ROUND(
        (
            fp.operating_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS operating_margin_pct,

    ROUND(
        (
            fp.net_profit_usd_bn
            / NULLIF(fp.revenue_usd_bn, 0)
        ) * 100,
        2
    ) AS net_margin_pct,

    ROUND(fp.operating_cash_flow_usd_bn, 2)
        AS operating_cash_flow_usd_bn

FROM dangote_ipo.financial_performance AS fp

INNER JOIN dangote_ipo.time_periods AS tp
    ON fp.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON fp.company_id = c.company_id

WHERE c.is_dangote = TRUE

ORDER BY
    CASE tp.period_name
        WHEN 'FY2024' THEN 1
        WHEN 'H1 2025' THEN 2
        WHEN 'FY2025' THEN 3
        WHEN 'H1 2026' THEN 4
        ELSE 5
    END;


/*
====================================================================
EXPECTED ANALYTICAL READING
====================================================================

The output should show:

- Revenue increasing materially across the reporting periods.
- Gross and operating margins moving from negative/low levels toward
  positive territory.
- Net profit moving from losses to positive earnings in H1 2026.
- Operating cash flow moving from negative in FY2024 to positive
  territory as refinery operations scaled.

IMPORTANT LIMITATION
--------------------
The periods contain both full-year and half-year reporting periods.
Therefore, this query does not calculate misleading year-on-year
growth rates between FY and H1 periods.

H1 2026 should be interpreted as a six-month reporting period.

====================================================================
*/