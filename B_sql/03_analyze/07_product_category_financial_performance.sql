
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 07 - Product Category Financial Performance
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- Which product categories experienced the largest changes
-- in revenue, gross profit, and gross-margin performance
-- between Jan-Sep 2022 and Jan-Sep 2023?
--
-- REPORTING GRAIN
-- One row per product category (5 categories expected).
--
-- FINANCIAL DEFINITIONS
-- Revenue       = SUM(units * product_price)
-- COGS          = SUM(units * product_cost)
-- Gross Profit  = Revenue - COGS
-- Gross Margin  = Gross Profit / Revenue * 100
-- Revenue Share = Category Revenue / Company Revenue * 100
-- YoY Growth    = (2023 value - 2022 value)
--                 / 2022 value * 100
-- Margin Change = GM 2023 - GM 2022 (percentage points)
--
-- METHODOLOGY
-- 1. Aggregate transaction data by category and year.
-- 2. Compare equivalent Jan-Sep reporting periods.
-- 3. Calculate revenue, COGS, and gross profit.
-- 4. Calculate category gross-margin rates.
-- 5. Calculate each category's share of company revenue.
-- 6. Rank categories by gross-margin deterioration.
--
-- VALIDATED BASELINE
-- 2022 Revenue:      5,320,115.85
-- 2023 Revenue:      6,962,074.27
-- 2022 Gross Profit: 1,572,037.00
-- 2023 Gross Profit: 1,824,242.00
-- Company GM Change: -3.3464 percentage points
--
-- LIMITATIONS
-- Product prices and costs are static source attributes,
-- not verified historical transaction-level amounts.
-- The analysis measures modeled gross financial performance,
-- not operating or net profitability.
-- ============================================================

WITH category_financials AS (

    SELECT
        p.product_category,
        EXTRACT(YEAR FROM s.date) AS sales_year,

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
        p.product_category,
        sales_year
),

category_metrics AS (

    SELECT
        product_category,
        sales_year,
        units_sold,
        revenue,
        cogs,
        gross_profit,

        SAFE_DIVIDE(
            gross_profit,
            revenue
        ) * 100 AS gross_margin_pct,

        SAFE_DIVIDE(
            revenue,
            SUM(revenue) OVER (PARTITION BY sales_year)
        ) * 100 AS revenue_share_pct

    FROM category_financials
),

year_comparison AS (

    SELECT
        product_category,

        MAX(IF(sales_year = 2022, units_sold, NULL))
            AS units_2022,

        MAX(IF(sales_year = 2023, units_sold, NULL))
            AS units_2023,

        MAX(IF(sales_year = 2022, revenue, NULL))
            AS revenue_2022,

        MAX(IF(sales_year = 2023, revenue, NULL))
            AS revenue_2023,

        MAX(IF(sales_year = 2022, gross_profit, NULL))
            AS gp_2022,

        MAX(IF(sales_year = 2023, gross_profit, NULL))
            AS gp_2023,

        MAX(IF(sales_year = 2022, gross_margin_pct, NULL))
            AS gm_2022_pct,

        MAX(IF(sales_year = 2023, gross_margin_pct, NULL))
            AS gm_2023_pct,

        MAX(IF(sales_year = 2022, revenue_share_pct, NULL))
            AS revenue_share_2022_pct,

        MAX(IF(sales_year = 2023, revenue_share_pct, NULL))
            AS revenue_share_2023_pct

    FROM category_metrics

    GROUP BY
        product_category
)

SELECT
    product_category,

    units_2022,
    units_2023,

    ROUND(
        SAFE_DIVIDE(
            units_2023 - units_2022,
            units_2022
        ) * 100,
        2
    ) AS units_yoy_pct,

    ROUND(revenue_2022, 2) AS revenue_2022,
    ROUND(revenue_2023, 2) AS revenue_2023,

    ROUND(
        SAFE_DIVIDE(
            revenue_2023 - revenue_2022,
            revenue_2022
        ) * 100,
        2
    ) AS revenue_yoy_pct,

    ROUND(gp_2022, 2) AS gp_2022,
    ROUND(gp_2023, 2) AS gp_2023,

    ROUND(
        SAFE_DIVIDE(
            gp_2023 - gp_2022,
            gp_2022
        ) * 100,
        2
    ) AS gp_yoy_pct,

    ROUND(gm_2022_pct, 2) AS gm_2022_pct,
    ROUND(gm_2023_pct, 2) AS gm_2023_pct,

    ROUND(
        gm_2023_pct - gm_2022_pct,
        2
    ) AS gm_change_pp,

    ROUND(revenue_share_2022_pct, 2)
        AS revenue_share_2022_pct,

    ROUND(revenue_share_2023_pct, 2)
        AS revenue_share_2023_pct,

    ROUND(
        revenue_share_2023_pct - revenue_share_2022_pct,
        2
    ) AS revenue_share_change_pp

FROM year_comparison

ORDER BY gm_change_pp ASC;
