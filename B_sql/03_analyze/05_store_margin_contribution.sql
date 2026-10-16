
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 05 - Store Margin Contribution Analysis
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- Which stores experienced the largest negative changes
-- in their contributions to company-wide gross margin
-- between Jan-Sep 2022 and Jan-Sep 2023?
--
-- REPORTING GRAIN
-- One row per store (50 stores expected).
--
-- FINANCIAL DEFINITIONS
-- Revenue       = SUM(units * product_price)
-- Gross Profit  = SUM(units * (product_price - product_cost))
-- Revenue Share = Store Revenue / Company Revenue
--
-- Margin Contribution (pp):
--   Store Gross Profit / Company Revenue * 100
--
-- Contribution Change (pp):
--   Contribution 2023 - Contribution 2022
--
-- METHODOLOGY
-- 1. Calculate revenue and gross profit by store and year.
-- 2. Calculate each store's share of company revenue.
-- 3. Calculate each store's contribution to company GM.
-- 4. Compare the contributions between reporting years.
-- 5. Rank stores by the largest negative changes.
--
-- INTERPRETATION
-- Contribution changes reflect BOTH changes in store
-- gross-margin rates and changes in store revenue shares.
--
-- A negative contribution change does not necessarily
-- mean the store's own gross margin deteriorated.
--
-- The sum of all store contribution changes reconciles
-- to the company-wide gross-margin change.
--
-- LIMITATIONS
-- Product prices and costs are source attributes, not
-- verified historical transaction-level amounts.
-- Results represent modeled gross financial performance,
-- not operating or net profit.
-- ============================================================

WITH store_financials AS (

    SELECT
        s.store_id,
        st.store_name,
        EXTRACT(YEAR FROM s.date) AS sales_year,

        SUM(s.units * p.product_price) AS revenue,

        SUM(
            s.units * (p.product_price - p.product_cost)
        ) AS gross_profit

    FROM `store-margin-intelligence.maven_toys_clean.sales` AS s

    INNER JOIN `store-margin-intelligence.maven_toys_clean.products` AS p
        ON s.product_id = p.product_id

    INNER JOIN `store-margin-intelligence.maven_toys_clean.stores` AS st
        ON s.store_id = st.store_id

    WHERE
        (s.date BETWEEN '2022-01-01' AND '2022-09-30')
        OR
        (s.date BETWEEN '2023-01-01' AND '2023-09-30')

    GROUP BY
        s.store_id,
        st.store_name,
        sales_year
),

store_contributions AS (

    SELECT
        store_id,
        store_name,
        sales_year,
        revenue,
        gross_profit,

        SAFE_DIVIDE(
            revenue,
            SUM(revenue) OVER (PARTITION BY sales_year)
        ) AS revenue_share,

        SAFE_DIVIDE(
            gross_profit,
            SUM(revenue) OVER (PARTITION BY sales_year)
        ) * 100 AS margin_contribution_pp

    FROM store_financials
),

year_comparison AS (

    SELECT
        store_id,
        store_name,

        MAX(IF(sales_year = 2022, revenue_share, NULL))
            AS revenue_share_2022,

        MAX(IF(sales_year = 2023, revenue_share, NULL))
            AS revenue_share_2023,

        MAX(IF(sales_year = 2022, margin_contribution_pp, NULL))
            AS contribution_2022,

        MAX(IF(sales_year = 2023, margin_contribution_pp, NULL))
            AS contribution_2023

    FROM store_contributions

    GROUP BY
        store_id,
        store_name
)

SELECT
    store_id,
    store_name,

    ROUND(revenue_share_2022 * 100, 2)
        AS revenue_share_2022_pct,

    ROUND(revenue_share_2023 * 100, 2)
        AS revenue_share_2023_pct,

    ROUND(contribution_2022, 4)
        AS contribution_2022_pp,

    ROUND(contribution_2023, 4)
        AS contribution_2023_pp,

    ROUND(
        contribution_2023 - contribution_2022,
        4
    ) AS contribution_change_pp

FROM year_comparison

ORDER BY contribution_change_pp ASC;
