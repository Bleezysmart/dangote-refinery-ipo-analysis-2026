/*
============================================================
DANGOTE REFINERY IPO ANALYSIS
QUERY 04 — PEER COMPARISON
============================================================

BUSINESS QUESTION:
How does Dangote Refinery compare with selected global
refining peers on utilization, refining margin and
market value?

ANALYTICAL OBJECTIVE:
Compare Dangote with selected global refining peers using:
1. Capacity utilisation
2. Refining margin benchmark
3. Market value
4. Enterprise value where available

PERIOD NOTE:
- Dangote: H1 2026 (period_id = 4)
- Global peers: FY2025 (period_id = 2)

IMPORTANT:
Refining-margin definitions differ across companies.
The margin comparison should therefore be treated as a
benchmark rather than a perfectly like-for-like metric.
============================================================
*/


/*
============================================================
RESULT SET 1 — CORE PEER COMPARISON
============================================================
*/

SELECT
    c.company_name,
    c.country,

    CASE
        WHEN c.is_dangote = TRUE THEN 'H1 2026'
        ELSE 'FY2025'
    END AS benchmark_period,

    pb.utilisation_pct,
    pb.refining_margin_usd_per_bbl,

    cv.market_value_usd_bn,
    cv.enterprise_value_usd_bn

FROM dangote_ipo.companies AS c

INNER JOIN dangote_ipo.peer_benchmarks AS pb
    ON c.company_id = pb.company_id

LEFT JOIN dangote_ipo.company_valuation AS cv
    ON c.company_id = cv.company_id
    AND cv.period_id = pb.period_id

WHERE
    (
        c.is_dangote = TRUE
        AND pb.period_id = 4
    )
    OR
    (
        c.is_dangote = FALSE
        AND c.company_type = 'Refinery'
        AND pb.period_id = 2
    )

ORDER BY
    pb.refining_margin_usd_per_bbl DESC;


/*
============================================================
RESULT SET 2 — UTILISATION COMPARISON
============================================================
*/

SELECT
    c.company_name,

    CASE
        WHEN c.is_dangote = TRUE THEN 'H1 2026'
        ELSE 'FY2025'
    END AS benchmark_period,

    pb.utilisation_pct

FROM dangote_ipo.companies AS c

INNER JOIN dangote_ipo.peer_benchmarks AS pb
    ON c.company_id = pb.company_id

WHERE
    (
        c.is_dangote = TRUE
        AND pb.period_id = 4
    )
    OR
    (
        c.is_dangote = FALSE
        AND c.company_type = 'Refinery'
        AND pb.period_id = 2
    )

ORDER BY
    pb.utilisation_pct DESC;


/*
============================================================
RESULT SET 3 — REFINING MARGIN COMPARISON
============================================================

IMPORTANT:
These metrics are not necessarily defined identically by
each company. Treat this as contextual benchmarking rather
than a strict like-for-like ranking.
============================================================
*/

SELECT
    c.company_name,

    CASE
        WHEN c.is_dangote = TRUE THEN 'H1 2026'
        ELSE 'FY2025'
    END AS benchmark_period,

    pb.refining_margin_usd_per_bbl

FROM dangote_ipo.companies AS c

INNER JOIN dangote_ipo.peer_benchmarks AS pb
    ON c.company_id = pb.company_id

WHERE
    (
        c.is_dangote = TRUE
        AND pb.period_id = 4
    )
    OR
    (
        c.is_dangote = FALSE
        AND c.company_type = 'Refinery'
        AND pb.period_id = 2
    )

ORDER BY
    pb.refining_margin_usd_per_bbl DESC;


/*
============================================================
RESULT SET 4 — MARKET VALUE COMPARISON
============================================================
*/

SELECT
    c.company_name,
    c.country,

    CASE
        WHEN c.is_dangote = TRUE THEN 'H1 2026'
        ELSE 'FY2025'
    END AS valuation_period,

    cv.market_value_usd_bn,
    cv.enterprise_value_usd_bn

FROM dangote_ipo.companies AS c

INNER JOIN dangote_ipo.company_valuation AS cv
    ON c.company_id = cv.company_id

WHERE
    (
        c.is_dangote = TRUE
        AND cv.period_id = 4
    )
    OR
    (
        c.is_dangote = FALSE
        AND c.company_type = 'Refinery'
        AND cv.period_id = 2
    )

ORDER BY
    cv.market_value_usd_bn DESC;


/*
============================================================
RESULT SET 5 — DANGOTE VS PEER AVERAGE
============================================================

Purpose:
Calculate the average utilisation and refining margin
among the selected global refining peers and compare
Dangote's H1 2026 figures with those averages.

This is descriptive benchmarking, not an investment ranking.
============================================================
*/

WITH peer_data AS (

    SELECT
        c.company_name,
        c.is_dangote,
        pb.utilisation_pct,
        pb.refining_margin_usd_per_bbl

    FROM dangote_ipo.companies AS c

    INNER JOIN dangote_ipo.peer_benchmarks AS pb
        ON c.company_id = pb.company_id

    WHERE
        (
            c.is_dangote = TRUE
            AND pb.period_id = 4
        )
        OR
        (
            c.is_dangote = FALSE
            AND c.company_type = 'Refinery'
            AND pb.period_id = 2
        )
),

peer_average AS (

    SELECT
        AVG(utilisation_pct) AS avg_peer_utilisation,
        AVG(refining_margin_usd_per_bbl)
            AS avg_peer_refining_margin

    FROM peer_data

    WHERE is_dangote = FALSE
)

SELECT
    d.company_name,

    d.utilisation_pct,
    p.avg_peer_utilisation,

    d.utilisation_pct
        - p.avg_peer_utilisation
        AS utilisation_difference,

    d.refining_margin_usd_per_bbl,
    p.avg_peer_refining_margin,

    d.refining_margin_usd_per_bbl
        - p.avg_peer_refining_margin
        AS refining_margin_difference

FROM peer_data AS d

CROSS JOIN peer_average AS p

WHERE d.is_dangote = TRUE;


/*
============================================================
END OF QUERY 04
============================================================
*/