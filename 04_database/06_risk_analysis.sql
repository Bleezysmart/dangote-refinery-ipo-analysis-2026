/*
============================================================
DANGOTE REFINERY IPO ANALYSIS
QUERY 06 — RISK ANALYSIS
============================================================

BUSINESS QUESTION:
What factors could materially weaken the ₦525 investment thesis?

ANALYTICAL OBJECTIVE:
Analyse the documented investment risks using:
1. Risk name
2. Risk category
3. Risk description
4. Potential impact
5. Measurable driver
6. Dashboard message

IMPORTANT:
The investment_risks table does not contain a severity field.
Therefore, this query does not create or assume a risk rating.
============================================================
*/


/*
============================================================
RESULT SET 1 — COMPLETE RISK REGISTER
============================================================
*/

SELECT
    risk_id,
    risk_name,
    risk_category,
    risk_description,
    potential_impact,
    measurable_driver,
    dashboard_message

FROM dangote_ipo.investment_risks

ORDER BY
    risk_id;


/*
============================================================
RESULT SET 2 — RISKS BY CATEGORY
============================================================

Purpose:
Count documented risks within each risk category.
============================================================
*/

SELECT
    risk_category,
    COUNT(*) AS risk_count

FROM dangote_ipo.investment_risks

GROUP BY
    risk_category

ORDER BY
    risk_count DESC,
    risk_category;


/*
============================================================
RESULT SET 3 — RISK IMPACT SUMMARY
============================================================

Purpose:
Show each risk alongside its documented potential impact
and measurable driver.
============================================================
*/

SELECT
    risk_name,
    risk_category,
    potential_impact,
    measurable_driver

FROM dangote_ipo.investment_risks

ORDER BY
    risk_category,
    risk_name;


/*
============================================================
RESULT SET 4 — INVESTOR RISK WATCHLIST
============================================================

Purpose:
Create a concise monitoring list linking each risk to
the factor that should be watched.
============================================================
*/

SELECT
    risk_name,
    risk_category,
    measurable_driver,
    potential_impact

FROM dangote_ipo.investment_risks

ORDER BY
    risk_category,
    risk_name;


/*
============================================================
RESULT SET 5 — DASHBOARD RISK MESSAGES
============================================================

Purpose:
Extract the documented interpretation prepared for
the investment dashboard.
============================================================
*/

SELECT
    risk_name,
    risk_category,
    dashboard_message

FROM dangote_ipo.investment_risks

ORDER BY
    risk_id;


/*
============================================================
RESULT SET 6 — RISK MONITORING FRAMEWORK
============================================================

Purpose:
Link every documented risk to its monitoring driver
and potential consequence.
============================================================
*/

SELECT
    risk_id,
    risk_name,
    risk_category,

    measurable_driver
        AS monitoring_driver,

    potential_impact
        AS potential_consequence

FROM dangote_ipo.investment_risks

ORDER BY
    risk_id;


/*
============================================================
END OF QUERY 06
============================================================
*/