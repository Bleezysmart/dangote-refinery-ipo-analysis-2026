/*
====================================================================
DANGOTE REFINERY IPO ANALYSIS
02 — OPERATING PERFORMANCE
====================================================================

BUSINESS QUESTION
-----------------
How has Dangote Refinery's operating performance changed as the
refinery moved from ramp-up toward higher utilisation?

ANALYTICAL OBJECTIVE
--------------------
Evaluate the operational drivers behind the financial turnaround by
examining:

1. Refinery capacity
2. Average crude throughput
3. Capacity utilisation
4. Refining margin

METHODOLOGY
-----------
- Operating data is joined to the reporting-period dimension.
- Dangote Refinery is identified using the is_dangote flag.
- Throughput is presented as average barrels processed per day.
- Capacity utilisation and refining margin are taken from the
  operating-performance dataset.
- Periods are displayed chronologically.
- H1 2026 is treated as a six-month reporting period.

ANALYTICAL PURPOSE
------------------
The purpose is to determine whether improving financial performance
was accompanied by higher refinery utilisation and throughput, and
to identify the role of refining margins in the earnings turnaround.

====================================================================
*/


-- ================================================================
-- 1. CORE OPERATING PERFORMANCE
-- ================================================================
-- Shows the main operating indicators across the reporting periods.
-- ================================================================

SELECT
    tp.period_name,

    ro.refinery_capacity_barrels_per_day
        AS refinery_capacity_bpd,

    ro.average_throughput_barrels_per_day
        AS average_throughput_bpd,

    ROUND(
        ro.utilisation_percent,
        1
    ) AS utilisation_percent,

    ro.refining_margin_usd_per_barrel
        AS refining_margin_usd_per_barrel

FROM dangote_ipo.refinery_operations AS ro

INNER JOIN dangote_ipo.time_periods AS tp
    ON ro.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON ro.company_id = c.company_id

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
-- 2. UTILISATION AND THROUGHPUT
-- ================================================================
-- Examines whether the refinery processed more crude as utilisation
-- increased.
-- ================================================================

SELECT
    tp.period_name,

    ro.refinery_capacity_barrels_per_day
        AS capacity_bpd,

    ro.average_throughput_barrels_per_day
        AS throughput_bpd,

    ROUND(
        ro.utilisation_percent,
        1
    ) AS utilisation_percent,

    ROUND(
        (
            ro.average_throughput_barrels_per_day
            /
            NULLIF(
                ro.refinery_capacity_barrels_per_day,
                0
            )
        ) * 100,
        1
    ) AS calculated_utilisation_percent

FROM dangote_ipo.refinery_operations AS ro

INNER JOIN dangote_ipo.time_periods AS tp
    ON ro.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON ro.company_id = c.company_id

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
-- 3. REFINING MARGIN TREND
-- ================================================================
-- Tracks the reported refining margin across the available periods.
-- This is important because refinery earnings are highly sensitive
-- to the spread between product prices and crude/input costs.
-- ================================================================

SELECT
    tp.period_name,

    ro.refining_margin_usd_per_barrel,

    CASE
        WHEN ro.refining_margin_usd_per_barrel >= 20
            THEN 'High Margin Environment'

        WHEN ro.refining_margin_usd_per_barrel >= 12
            THEN 'Moderate Margin Environment'

        ELSE 'Lower Margin Environment'
    END AS margin_environment

FROM dangote_ipo.refinery_operations AS ro

INNER JOIN dangote_ipo.time_periods AS tp
    ON ro.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON ro.company_id = c.company_id

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
-- 4. OPERATING MOMENTUM SUMMARY
-- ================================================================
-- Compact output showing the operating indicators used to explain
-- the refinery's ramp-up.
-- ================================================================

SELECT
    tp.period_name,

    ROUND(
        ro.refinery_capacity_barrels_per_day / 1000.0,
        1
    ) AS capacity_k_bpd,

    ROUND(
        ro.average_throughput_barrels_per_day / 1000.0,
        1
    ) AS throughput_k_bpd,

    ROUND(
        ro.utilisation_percent,
        1
    ) AS utilisation_percent,

    ROUND(
        ro.refining_margin_usd_per_barrel,
        2
    ) AS refining_margin_usd_per_barrel

FROM dangote_ipo.refinery_operations AS ro

INNER JOIN dangote_ipo.time_periods AS tp
    ON ro.period_id = tp.period_id

INNER JOIN dangote_ipo.companies AS c
    ON ro.company_id = c.company_id

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

The operating data should show:

FY2024
- Capacity: approximately 650K bpd
- Utilisation: 34.6%
- Throughput: approximately 225K bpd
- Refining margin: $10.70/bbl

FY2025
- Capacity: approximately 650K bpd
- Utilisation: 63.1%
- Throughput: approximately 410K bpd
- Refining margin: $13.70/bbl

H1 2026
- Capacity: 700K bpd
- Utilisation: 83.6%
- Throughput: approximately 585K bpd
- Refining margin: $24.50/bbl

KEY ANALYTICAL POINT
--------------------
The improvement in operating performance has two distinct drivers:

1. Higher refinery utilisation and throughput.
2. A significantly stronger refining-margin environment.

The second factor is particularly important for the investment
analysis because the H1 2026 refining margin was substantially above
FY2024 and FY2025 levels.

Therefore, higher utilisation alone should not be treated as proof
that the H1 2026 earnings level will persist.

====================================================================
*/