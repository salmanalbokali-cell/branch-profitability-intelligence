
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 10 - Product-Level Financial Performance
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- Which individual products experienced the largest changes
-- in revenue, gross profit, sales volume, and revenue share?
--
-- REPORTING PERIODS
-- Jan-Sep 2022 versus Jan-Sep 2023
--
-- REPORTING GRAIN
-- One row per product with sales in either period.
--
-- IMPORTANT METHODOLOGY
-- Products without sales in one period are retained.
-- Missing sales-period financial values are treated as zero
-- for additive financial metrics and revenue shares.
--
-- YoY growth is NULL when the baseline value is zero.
-- Gross margin is NULL when product revenue is zero.
--
-- A product with no recorded 2022 sales is NOT assumed
-- to have been newly launched.
--
-- FINANCIAL DEFINITIONS
-- Revenue       = SUM(units * product_price)
-- COGS          = SUM(units * product_cost)
-- Gross Profit  = Revenue - COGS
-- Gross Margin  = Gross Profit / Revenue * 100
-- Revenue Share = Product Revenue / Company Revenue * 100
--
-- VALIDATION
-- Expected products: 35
-- Revenue 2022: 5,320,115.85
-- Revenue 2023: 6,962,074.27
-- Gross Profit 2022: 1,572,037.00
-- Gross Profit 2023: 1,824,242.00
--
-- LIMITATIONS
-- Product prices and costs are static source attributes.
-- Historical transaction-level price/cost changes cannot
-- be evaluated using this dataset.
-- ============================================================

WITH product_financials AS (

    SELECT
        p.product_id,
        p.product_name,
        p.product_category,
        EXTRACT(YEAR FROM s.date) AS sales_year,

        SUM(s.units) AS units_sold,

        SUM(s.units * p.product_price) AS revenue,

        SUM(s.units * p.product_cost) AS cogs,

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
        p.product_id,
        p.product_name,
        p.product_category,
        sales_year
),

year_comparison AS (

    SELECT
        product_id,
        product_name,
        product_category,

        MAX(IF(sales_year = 2022, units_sold, NULL))
            AS units_2022_raw,

        MAX(IF(sales_year = 2023, units_sold, NULL))
            AS units_2023_raw,

        MAX(IF(sales_year = 2022, revenue, NULL))
            AS revenue_2022_raw,

        MAX(IF(sales_year = 2023, revenue, NULL))
            AS revenue_2023_raw,

        MAX(IF(sales_year = 2022, gross_profit, NULL))
            AS gp_2022_raw,

        MAX(IF(sales_year = 2023, gross_profit, NULL))
            AS gp_2023_raw

    FROM product_financials

    GROUP BY
        product_id,
        product_name,
        product_category
),

normalized_comparison AS (

    SELECT
        product_id,
        product_name,
        product_category,

        CASE
            WHEN revenue_2022_raw IS NOT NULL
             AND revenue_2023_raw IS NOT NULL
                THEN 'Continuing Product'

            WHEN revenue_2022_raw IS NULL
             AND revenue_2023_raw IS NOT NULL
                THEN 'No 2022 Sales'

            WHEN revenue_2022_raw IS NOT NULL
             AND revenue_2023_raw IS NULL
                THEN 'No 2023 Sales'

            ELSE 'Review'
        END AS product_comparison_status,

        COALESCE(units_2022_raw, 0) AS units_2022,
        COALESCE(units_2023_raw, 0) AS units_2023,

        COALESCE(revenue_2022_raw, 0) AS revenue_2022,
        COALESCE(revenue_2023_raw, 0) AS revenue_2023,

        COALESCE(gp_2022_raw, 0) AS gp_2022,
        COALESCE(gp_2023_raw, 0) AS gp_2023

    FROM year_comparison
),

product_metrics AS (

    SELECT
        *,

        SAFE_DIVIDE(gp_2022, revenue_2022) * 100
            AS gm_2022_pct,

        SAFE_DIVIDE(gp_2023, revenue_2023) * 100
            AS gm_2023_pct,

        SAFE_DIVIDE(
            revenue_2022,
            SUM(revenue_2022) OVER ()
        ) * 100 AS share_2022_pct,

        SAFE_DIVIDE(
            revenue_2023,
            SUM(revenue_2023) OVER ()
        ) * 100 AS share_2023_pct

    FROM normalized_comparison
),

product_comparison AS (

    SELECT
        *,

        SAFE_DIVIDE(
            units_2023 - units_2022,
            NULLIF(units_2022, 0)
        ) * 100 AS units_yoy_pct,

        SAFE_DIVIDE(
            revenue_2023 - revenue_2022,
            NULLIF(revenue_2022, 0)
        ) * 100 AS revenue_yoy_pct,

        SAFE_DIVIDE(
            gp_2023 - gp_2022,
            NULLIF(gp_2022, 0)
        ) * 100 AS gp_yoy_pct,

        CASE
            WHEN revenue_2022 > 0 AND revenue_2023 > 0
                THEN gm_2023_pct - gm_2022_pct
            ELSE NULL
        END AS gm_change_pp,

        share_2023_pct - share_2022_pct
            AS share_change_pp

    FROM product_metrics
)

SELECT
    product_id,
    product_name,
    product_category,
    product_comparison_status,

    units_2022,
    units_2023,
    ROUND(units_yoy_pct, 2) AS units_yoy_pct,

    ROUND(revenue_2022, 2) AS revenue_2022,
    ROUND(revenue_2023, 2) AS revenue_2023,
    ROUND(revenue_yoy_pct, 2) AS revenue_yoy_pct,

    ROUND(gp_2022, 2) AS gp_2022,
    ROUND(gp_2023, 2) AS gp_2023,
    ROUND(gp_yoy_pct, 2) AS gp_yoy_pct,

    ROUND(gm_2022_pct, 2) AS gm_2022_pct,
    ROUND(gm_2023_pct, 2) AS gm_2023_pct,
    ROUND(gm_change_pp, 4) AS gm_change_pp,

    ROUND(share_2022_pct, 2)
        AS revenue_share_2022_pct,

    ROUND(share_2023_pct, 2)
        AS revenue_share_2023_pct,

    ROUND(share_change_pp, 2)
        AS revenue_share_change_pp,

    COUNT(*) OVER () AS products_analyzed,

    COUNTIF(
        product_comparison_status = 'Continuing Product'
    ) OVER () AS continuing_products,

    COUNTIF(
        product_comparison_status = 'No 2022 Sales'
    ) OVER () AS products_without_2022_sales,

    ROUND(SUM(revenue_2022) OVER (), 2)
        AS company_revenue_2022_check,

    ROUND(SUM(revenue_2023) OVER (), 2)
        AS company_revenue_2023_check,

    ROUND(SUM(gp_2022) OVER (), 2)
        AS company_gp_2022_check,

    ROUND(SUM(gp_2023) OVER (), 2)
        AS company_gp_2023_check

FROM product_comparison

ORDER BY
    share_change_pp ASC,
    product_name;
