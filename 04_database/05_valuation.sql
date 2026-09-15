/*
============================================================
DANGOTE REFINERY IPO ANALYSIS
QUERY 05 — VALUATION ANALYSIS
============================================================

BUSINESS QUESTION:
What earnings power does the ₦525 IPO price already assume?

ANALYTICAL OBJECTIVE:
Evaluate the IPO valuation using:
1. Market value
2. Enterprise value
3. H1 2026 net profit
4. Annualized net profit
5. Price / annualized net profit
6. Enterprise value / annualized operating profit
7. Required operating profit under a 10x EV / Operating
   Profit framework

IMPORTANT:
- H1 2026 figures are annualized by multiplying by 2.
- Annualization is a run-rate calculation, NOT a forecast.
- The database does not contain an EBITDA field.
- Therefore, this query uses operating profit as the
  earnings-power measure.
- 10x EV / Operating Profit is an analyst assumption,
  not a reported company valuation multiple.
============================================================
*/


/*
============================================================
RESULT SET 1 — IPO VALUATION SNAPSHOT
============================================================

Purpose:
Show the core valuation figures attached to the IPO.
============================================================
*/

SELECT
    c.company_name,

    cv.share_price_ngn
        AS ipo_share_price_ngn,

    cv.market_value_usd_bn
        AS market_value_usd_bn,

    cv.enterprise_value_usd_bn
        AS enterprise_value_usd_bn,

    cv.ev_to_ebitda_multiple,

    cv.price_to_earnings_multiple

FROM dangote_ipo.companies AS c

INNER JOIN dangote_ipo.company_valuation AS cv
    ON c.company_id = cv.company_id

WHERE
    c.is_dangote = TRUE
    AND cv.period_id = 4;


/*
============================================================
RESULT SET 2 — H1 2026 EARNINGS POWER
============================================================

Purpose:
Calculate H1 2026 operating profit and net profit,
together with annualized run-rate figures.

Annualized figure = H1 2026 figure × 2.

These are run-rate calculations, NOT forecasts.
============================================================
*/

SELECT
    c.company_name,

    f.revenue_usd_bn
        AS h1_2026_revenue_usd_bn,

    f.operating_profit_usd_bn
        AS h1_2026_operating_profit_usd_bn,

    f.operating_profit_usd_bn * 2
        AS annualized_operating_profit_usd_bn,

    f.net_profit_usd_bn
        AS h1_2026_net_profit_usd_bn,

    f.net_profit_usd_bn * 2
        AS annualized_net_profit_usd_bn

FROM dangote_ipo.companies AS c

INNER JOIN dangote_ipo.financial_performance AS f
    ON c.company_id = f.company_id

WHERE
    c.is_dangote = TRUE
    AND f.period_id = 4;


/*
============================================================
RESULT SET 3 — IMPLIED VALUATION MULTIPLES
============================================================

Purpose:
Calculate valuation multiples using the annualized
H1 2026 earnings run-rate.

Metrics:
- Price / Annualized Net Profit
- Enterprise Value / Annualized Operating Profit

The second metric is NOT EV / EBITDA because EBITDA is
not stored in the live financial_performance table.
============================================================
*/

WITH valuation AS (

    SELECT
        cv.market_value_usd_bn,
        cv.enterprise_value_usd_bn

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.company_valuation AS cv
        ON c.company_id = cv.company_id

    WHERE
        c.is_dangote = TRUE
        AND cv.period_id = 4
),

earnings AS (

    SELECT
        f.operating_profit_usd_bn * 2
            AS annualized_operating_profit_usd_bn,

        f.net_profit_usd_bn * 2
            AS annualized_net_profit_usd_bn

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.financial_performance AS f
        ON c.company_id = f.company_id

    WHERE
        c.is_dangote = TRUE
        AND f.period_id = 4
)

SELECT

    v.market_value_usd_bn,

    e.annualized_net_profit_usd_bn,

    v.market_value_usd_bn
        / NULLIF(
            e.annualized_net_profit_usd_bn,
            0
        )
        AS price_to_annualized_net_profit,

    v.enterprise_value_usd_bn,

    e.annualized_operating_profit_usd_bn,

    v.enterprise_value_usd_bn
        / NULLIF(
            e.annualized_operating_profit_usd_bn,
            0
        )
        AS ev_to_annualized_operating_profit

FROM valuation AS v

CROSS JOIN earnings AS e;


/*
============================================================
RESULT SET 4 — REQUIRED OPERATING PROFIT AT 10x
============================================================

Purpose:
Calculate the level of sustainable operating profit
required for the current enterprise value to equal
a 10x EV / Operating Profit valuation.

Formula:

Required Operating Profit =
Enterprise Value / 10

Then compare this requirement with the annualized
H1 2026 operating-profit run-rate.

IMPORTANT:
10x is an analyst assumption.
============================================================
*/

WITH valuation AS (

    SELECT
        cv.enterprise_value_usd_bn

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.company_valuation AS cv
        ON c.company_id = cv.company_id

    WHERE
        c.is_dangote = TRUE
        AND cv.period_id = 4
),

earnings AS (

    SELECT
        f.operating_profit_usd_bn * 2
            AS annualized_operating_profit_usd_bn

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.financial_performance AS f
        ON c.company_id = f.company_id

    WHERE
        c.is_dangote = TRUE
        AND f.period_id = 4
)

SELECT

    v.enterprise_value_usd_bn,

    10.0
        AS assumed_ev_to_operating_profit,

    v.enterprise_value_usd_bn / 10.0
        AS required_operating_profit_usd_bn,

    e.annualized_operating_profit_usd_bn,

    e.annualized_operating_profit_usd_bn
        - (
            v.enterprise_value_usd_bn / 10.0
        )
        AS earnings_headroom_usd_bn,

    e.annualized_operating_profit_usd_bn
        / NULLIF(
            v.enterprise_value_usd_bn / 10.0,
            0
        )
        AS earnings_coverage_ratio

FROM valuation AS v

CROSS JOIN earnings AS e;


/*
============================================================
RESULT SET 5 — VALUATION INTERPRETATION BRIDGE
============================================================

Purpose:
Bring the key valuation figures into one concise output.

This separates:
- Current valuation
- Current earnings run-rate
- Required earnings
- Headroom

The earnings measure is operating profit because EBITDA
is not available in the live financial_performance table.
============================================================
*/

WITH valuation AS (

    SELECT
        cv.market_value_usd_bn,
        cv.enterprise_value_usd_bn

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.company_valuation AS cv
        ON c.company_id = cv.company_id

    WHERE
        c.is_dangote = TRUE
        AND cv.period_id = 4
),

earnings AS (

    SELECT
        f.operating_profit_usd_bn * 2
            AS annualized_operating_profit_usd_bn,

        f.net_profit_usd_bn * 2
            AS annualized_net_profit_usd_bn

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.financial_performance AS f
        ON c.company_id = f.company_id

    WHERE
        c.is_dangote = TRUE
        AND f.period_id = 4
)

SELECT

    v.market_value_usd_bn
        AS company_value_usd_bn,

    v.enterprise_value_usd_bn
        AS business_value_usd_bn,

    e.annualized_operating_profit_usd_bn,

    e.annualized_net_profit_usd_bn,

    v.enterprise_value_usd_bn / 10.0
        AS required_operating_profit_at_10x_usd_bn,

    e.annualized_operating_profit_usd_bn
        - (
            v.enterprise_value_usd_bn / 10.0
        )
        AS headroom_usd_bn

FROM valuation AS v

CROSS JOIN earnings AS e;


/*
============================================================
END OF QUERY 05
============================================================
*/