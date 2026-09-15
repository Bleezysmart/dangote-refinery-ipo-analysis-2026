/*
====================================================================
DANGOTE REFINERY IPO ANALYSIS
03 — PRODUCT SALES & REVENUE MIX
====================================================================

BUSINESS QUESTION
-----------------
What products are driving Dangote Refinery's revenue, and how
concentrated is the company's H1 2026 revenue across its product
portfolio?

ANALYTICAL OBJECTIVE
--------------------
Evaluate the H1 2026 revenue engine by examining:

1. Product-level sales revenue
2. Product revenue share
3. Sales volume where available
4. Average realised selling price where available
5. Ranking of products by revenue contribution

METHODOLOGY
-----------
- Product sales data is joined to the product and reporting-period
  dimensions.
- Dangote Refinery is identified using the is_dangote flag.
- H1 2026 is isolated for the product-mix analysis.
- Product revenue is measured in USD billions.
- Revenue share is calculated as each product's revenue divided by
  total H1 2026 product revenue.
- NULL sales-volume and realised-price values are retained rather
  than replaced with estimates.

DATA QUALITY NOTE
-----------------
The original data collection contained five H1 2026 products and
did not fully reconcile to reported H1 2026 revenue.

The dataset was subsequently corrected to include:
- CBFS
- LPG
- Propane

The corrected eight-product dataset reconciles to approximately
$13.91B of H1 2026 product revenue.

ANALYTICAL PURPOSE
------------------
This analysis supports the Power BI "Revenue Engine" visual and
helps identify the products most important to the company's current
revenue base.

====================================================================
*/


-- ================================================================
-- 1. H1 2026 PRODUCT SALES
-- ================================================================
-- Displays product-level revenue, volume and realised price.
-- ================================================================

SELECT
    p.product_name,

    p.product_category,

    ps.sales_volume_tonnes,

    ps.average_realised_price_usd_per_tonne,

    ps.sales_revenue_usd_bn

FROM dangote_ipo.product_sales AS ps

INNER JOIN dangote_ipo.products AS p
    ON ps.product_id = p.product_id

INNER JOIN dangote_ipo.companies AS c
    ON ps.company_id = c.company_id

INNER JOIN dangote_ipo.time_periods AS tp
    ON ps.period_id = tp.period_id

WHERE c.is_dangote = TRUE
  AND tp.period_name = 'H1 2026'

ORDER BY
    ps.sales_revenue_usd_bn DESC;


-- ================================================================
-- 2. PRODUCT REVENUE SHARE
-- ================================================================
-- Calculates each product's contribution to total H1 2026 product
-- revenue.
-- ================================================================

WITH product_revenue AS (

    SELECT
        p.product_name,
        ps.sales_revenue_usd_bn

    FROM dangote_ipo.product_sales AS ps

    INNER JOIN dangote_ipo.products AS p
        ON ps.product_id = p.product_id

    INNER JOIN dangote_ipo.companies AS c
        ON ps.company_id = c.company_id

    INNER JOIN dangote_ipo.time_periods AS tp
        ON ps.period_id = tp.period_id

    WHERE c.is_dangote = TRUE
      AND tp.period_name = 'H1 2026'
)

SELECT
    product_name,

    sales_revenue_usd_bn,

    ROUND(
        (
            sales_revenue_usd_bn
            /
            NULLIF(
                SUM(sales_revenue_usd_bn) OVER (),
                0
            )
        ) * 100,
        2
    ) AS revenue_share_pct

FROM product_revenue

ORDER BY
    sales_revenue_usd_bn DESC;


-- ================================================================
-- 3. PRODUCT REVENUE RANKING
-- ================================================================
-- Ranks products according to their contribution to H1 2026
-- product revenue.
-- ================================================================

WITH ranked_products AS (

    SELECT
        p.product_name,

        ps.sales_revenue_usd_bn,

        RANK() OVER (
            ORDER BY ps.sales_revenue_usd_bn DESC
        ) AS revenue_rank

    FROM dangote_ipo.product_sales AS ps

    INNER JOIN dangote_ipo.products AS p
        ON ps.product_id = p.product_id

    INNER JOIN dangote_ipo.companies AS c
        ON ps.company_id = c.company_id

    INNER JOIN dangote_ipo.time_periods AS tp
        ON ps.period_id = tp.period_id

    WHERE c.is_dangote = TRUE
      AND tp.period_name = 'H1 2026'
)

SELECT
    revenue_rank,

    product_name,

    sales_revenue_usd_bn

FROM ranked_products

ORDER BY
    revenue_rank;


-- ================================================================
-- 4. PRODUCT MIX CONCENTRATION
-- ================================================================
-- Measures the combined revenue contribution of the largest
-- products to identify concentration within the revenue engine.
-- ================================================================

WITH product_share AS (

    SELECT
        p.product_name,

        ps.sales_revenue_usd_bn,

        (
            ps.sales_revenue_usd_bn
            /
            NULLIF(
                SUM(ps.sales_revenue_usd_bn) OVER (),
                0
            )
        ) * 100 AS revenue_share_pct

    FROM dangote_ipo.product_sales AS ps

    INNER JOIN dangote_ipo.products AS p
        ON ps.product_id = p.product_id

    INNER JOIN dangote_ipo.companies AS c
        ON ps.company_id = c.company_id

    INNER JOIN dangote_ipo.time_periods AS tp
        ON ps.period_id = tp.period_id

    WHERE c.is_dangote = TRUE
      AND tp.period_name = 'H1 2026'
),

ranked_products AS (

    SELECT
        product_name,
        sales_revenue_usd_bn,
        revenue_share_pct,

        ROW_NUMBER() OVER (
            ORDER BY sales_revenue_usd_bn DESC
        ) AS product_rank

    FROM product_share
)

SELECT
    COUNT(*) AS products_in_dataset,

    ROUND(
        SUM(sales_revenue_usd_bn),
        2
    ) AS total_product_revenue_usd_bn,

    ROUND(
        SUM(
            CASE
                WHEN product_rank <= 3
                    THEN sales_revenue_usd_bn
                ELSE 0
            END
        ),
        2
    ) AS top_3_product_revenue_usd_bn,

    ROUND(
        SUM(
            CASE
                WHEN product_rank <= 3
                    THEN revenue_share_pct
                ELSE 0
            END
        ),
        2
    ) AS top_3_revenue_share_pct

FROM ranked_products;


-- ================================================================
-- 5. COMPLETE PRODUCT REVENUE SUMMARY
-- ================================================================
-- Produces a compact output suitable for validation against the
-- H1 2026 revenue figure used in the Power BI dashboard.
-- ================================================================

SELECT
    COUNT(*) AS number_of_products,

    ROUND(
        SUM(ps.sales_revenue_usd_bn),
        2
    ) AS total_product_revenue_usd_bn,

    ROUND(
        (
            SUM(ps.sales_revenue_usd_bn)
            /
            NULLIF(
                MAX(fp.revenue_usd_bn),
                0
            )
        ) * 100,
        2
    ) AS product_revenue_as_pct_of_reported_revenue

FROM dangote_ipo.product_sales AS ps

INNER JOIN dangote_ipo.companies AS c
    ON ps.company_id = c.company_id

INNER JOIN dangote_ipo.time_periods AS tp
    ON ps.period_id = tp.period_id

LEFT JOIN dangote_ipo.financial_performance AS fp
    ON ps.company_id = fp.company_id
   AND ps.period_id = fp.period_id

WHERE c.is_dangote = TRUE
  AND tp.period_name = 'H1 2026';


/*
====================================================================
EXPECTED ANALYTICAL READING
====================================================================

The H1 2026 product revenue dataset should contain eight products:

1. PMS
2. AGO
3. Jet Fuel
4. RCO
5. CBFS
6. Polypropylene
7. LPG
8. Propane

The corrected product revenue should reconcile to approximately
$13.91B, matching reported H1 2026 revenue.

The largest contributors are expected to be PMS, AGO and Jet Fuel.

IMPORTANT DATA LIMITATION
--------------------------
Sales volume and average realised price are not available for every
product in the corrected dataset.

Where these fields are NULL, this query deliberately preserves the
NULL value instead of estimating or imputing a figure.

REVENUE RECONCILIATION
----------------------
The product-level revenue total is compared with reported H1 2026
financial revenue.

A close reconciliation provides a data-quality check between the
product-sales dataset and the financial-performance dataset.

====================================================================
*/