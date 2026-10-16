
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 12 - Monthly Financial Performance & Margin Trends
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- When did the company's gross-margin deterioration occur?
-- Which months experienced the largest YoY margin declines?
--
-- REPORTING PERIODS
-- Jan 1 - Sep 30, 2022
-- Jan 1 - Sep 30, 2023
--
-- REPORTING GRAIN
-- One row per calendar month (9 months expected).
--
-- FINANCIAL DEFINITIONS
-- Revenue      = SUM(units * product_price)
-- COGS         = SUM(units * product_cost)
-- Gross Profit = Revenue - COGS
-- Gross Margin = Gross Profit / Revenue * 100
--
-- COMPARISON
-- Same calendar month in 2022 versus 2023.
--
-- VALIDATION
-- Monthly totals must reconcile to the validated
-- company financial baseline for each reporting period.
--
-- IMPORTANT
-- Overall gross margin must be calculated as
-- total gross profit / total revenue.
-- Do NOT average monthly margin percentages.
--
-- LIMITATIONS
-- Product prices and costs are static source attributes.
-- The analysis describes modeled financial patterns,
-- not verified historical price or cost changes.
-- ============================================================

WITH monthly_financials AS (

    SELECT
        EXTRACT(YEAR FROM s.date) AS sales_year,
        EXTRACT(MONTH FROM s.date) AS sales_month,

        COUNT(*) AS sales_records,

        SUM(s.units) AS units_sold,

        SUM(
            s.units * p.product_price
        ) AS revenue,

        SUM(
            s.units * p.product_cost
        ) AS cogs,

        SUM(
            s.units * (p.product_price - p.product_cost)
        ) AS gross_profit

    FROM `store-margin-intelligence.maven_toys_clean.sales` AS s

    INNER JOIN `store-margin-intelligence.maven_toys_clean.products` AS p
        ON s.product_id = p.product_id

    WHERE
        (s.date BETWEEN '2022-01-01' AND '2022-09-30')
        OR
        (s.date BETWEEN '2023-01-01' AND '2023-09-30')

    GROUP BY
        sales_year,
        sales_month
),

monthly_comparison AS (

    SELECT
        sales_month,

        SUM(IF(sales_year = 2022, sales_records, 0))
            AS sales_records_2022,

        SUM(IF(sales_year = 2023, sales_records, 0))
            AS sales_records_2023,

        SUM(IF(sales_year = 2022, units_sold, 0))
            AS units_2022,

        SUM(IF(sales_year = 2023, units_sold, 0))
            AS units_2023,

        SUM(IF(sales_year = 2022, revenue, 0))
            AS revenue_2022,

        SUM(IF(sales_year = 2023, revenue, 0))
            AS revenue_2023,

        SUM(IF(sales_year = 2022, cogs, 0))
            AS cogs_2022,

        SUM(IF(sales_year = 2023, cogs, 0))
            AS cogs_2023,

        SUM(IF(sales_year = 2022, gross_profit, 0))
            AS gp_2022,

        SUM(IF(sales_year = 2023, gross_profit, 0))
            AS gp_2023

    FROM monthly_financials

    GROUP BY sales_month
),

monthly_metrics AS (

    SELECT
        *,

        SAFE_DIVIDE(gp_2022, revenue_2022) * 100
            AS gm_2022_pct,

        SAFE_DIVIDE(gp_2023, revenue_2023) * 100
            AS gm_2023_pct,

        SAFE_DIVIDE(
            units_2023 - units_2022,
            NULLIF(units_2022, 0)
        ) * 100 AS units_yoy_pct,

        SAFE_DIVIDE(
            revenue_2023 - revenue_2022,
            NULLIF(revenue_2022, 0)
        ) * 100 AS revenue_yoy_pct,

        SAFE_DIVIDE(
            cogs_2023 - cogs_2022,
            NULLIF(cogs_2022, 0)
        ) * 100 AS cogs_yoy_pct,

        SAFE_DIVIDE(
            gp_2023 - gp_2022,
            NULLIF(gp_2022, 0)
        ) * 100 AS gp_yoy_pct

    FROM monthly_comparison
),

monthly_trends AS (

    SELECT
        *,

        gm_2023_pct - gm_2022_pct
            AS gm_change_pp,

        LAG(gm_2023_pct) OVER (
            ORDER BY sales_month
        ) AS previous_month_gm_2023_pct,

        SUM(revenue_2022) OVER ()
            AS total_revenue_2022,

        SUM(revenue_2023) OVER ()
            AS total_revenue_2023,

        SUM(cogs_2022) OVER ()
            AS total_cogs_2022,

        SUM(cogs_2023) OVER ()
            AS total_cogs_2023,

        SUM(gp_2022) OVER ()
            AS total_gp_2022,

        SUM(gp_2023) OVER ()
            AS total_gp_2023,

        SUM(units_2022) OVER ()
            AS total_units_2022,

        SUM(units_2023) OVER ()
            AS total_units_2023,

        COUNT(*) OVER ()
            AS months_analyzed

    FROM monthly_metrics
)

SELECT
    sales_month,

    FORMAT_DATE(
        '%B',
        DATE(2023, sales_month, 1)
    ) AS month_name,

    sales_records_2022,
    sales_records_2023,

    units_2022,
    units_2023,

    ROUND(units_yoy_pct, 2)
        AS units_yoy_pct,

    ROUND(revenue_2022, 2)
        AS revenue_2022,

    ROUND(revenue_2023, 2)
        AS revenue_2023,

    ROUND(revenue_yoy_pct, 2)
        AS revenue_yoy_pct,

    ROUND(cogs_2022, 2)
        AS cogs_2022,

    ROUND(cogs_2023, 2)
        AS cogs_2023,

    ROUND(cogs_yoy_pct, 2)
        AS cogs_yoy_pct,

    ROUND(gp_2022, 2)
        AS gp_2022,

    ROUND(gp_2023, 2)
        AS gp_2023,

    ROUND(gp_yoy_pct, 2)
        AS gp_yoy_pct,

    ROUND(gm_2022_pct, 2)
        AS gm_2022_pct,

    ROUND(gm_2023_pct, 2)
        AS gm_2023_pct,

    ROUND(gm_change_pp, 4)
        AS gm_yoy_change_pp,

    ROUND(
        gm_2023_pct - previous_month_gm_2023_pct,
        4
    ) AS gm_2023_mom_change_pp,

    months_analyzed,

    ROUND(total_revenue_2022, 2)
        AS company_revenue_2022_check,

    ROUND(total_revenue_2023, 2)
        AS company_revenue_2023_check,

    ROUND(total_gp_2022, 2)
        AS company_gp_2022_check,

    ROUND(total_gp_2023, 2)
        AS company_gp_2023_check,

    ROUND(
        SAFE_DIVIDE(total_gp_2022, total_revenue_2022)
        * 100,
        4
    ) AS company_gm_2022_check,

    ROUND(
        SAFE_DIVIDE(total_gp_2023, total_revenue_2023)
        * 100,
        4
    ) AS company_gm_2023_check,

    CASE
        WHEN months_analyzed = 9

         AND total_units_2022 = 384415
         AND total_units_2023 = 541073

         AND ABS(total_revenue_2022 - 5320115.85) < 0.01
         AND ABS(total_revenue_2023 - 6962074.27) < 0.01

         AND ABS(total_cogs_2022 - 3748078.85) < 0.01
         AND ABS(total_cogs_2023 - 5137832.27) < 0.01

         AND ABS(total_gp_2022 - 1572037.00) < 0.01
         AND ABS(total_gp_2023 - 1824242.00) < 0.01

        THEN 'PASS'
        ELSE 'REVIEW'
    END AS reconciliation_status

FROM monthly_trends

ORDER BY sales_month;
