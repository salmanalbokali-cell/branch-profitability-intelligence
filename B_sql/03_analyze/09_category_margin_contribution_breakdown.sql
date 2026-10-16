
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 09 - Category Margin Contribution Breakdown
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- Which product categories contributed most to the
-- company-wide gross-margin change, and how much of each
-- contribution was associated with category margin changes
-- versus category revenue-share changes?
--
-- REPORTING PERIODS
-- Jan 1 - Sep 30, 2022
-- Jan 1 - Sep 30, 2023
--
-- REPORTING GRAIN
-- One row per product category (5 categories expected).
--
-- FINANCIAL DEFINITIONS
-- Revenue      = SUM(units * product_price)
-- Gross Profit = SUM(units * (product_price - product_cost))
-- Margin Rate  = Gross Profit / Revenue
-- Revenue Share = Category Revenue / Company Revenue
--
-- DECOMPOSITION METHOD
-- Margin Effect (pp):
--   2023 share * (2023 margin - 2022 margin) * 100
--
-- Revenue-Mix Effect (pp):
--   (2023 share - 2022 share) * 2022 margin * 100
--
-- Total Contribution (pp):
--   Margin Effect + Revenue-Mix Effect
--
-- EXACT IDENTITY
-- Sum of category contributions =
-- Company gross-margin change.
--
-- INTERPRETATION
-- Negative contributions reduce company gross margin.
-- Positive contributions offset negative contributions.
--
-- A category's positive mix effect does not necessarily
-- mean that shifting sales toward that category improved
-- overall profitability relative to other categories.
--
-- VALIDATION
-- Compare the summed contributions with the previously
-- verified company gross-margin change of -3.3464 pp.
-- A tolerance of 0.0001 pp accommodates baseline rounding.
--
-- LIMITATIONS
-- Product prices and costs are static source attributes,
-- not verified historical transaction-level amounts.
-- This decomposition identifies accounting contributions,
-- not independently established causal relationships.
-- ============================================================

WITH category_financials AS (

    SELECT
        p.product_category,
        EXTRACT(YEAR FROM s.date) AS sales_year,

        SUM(s.units * p.product_price) AS revenue,

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

        SAFE_DIVIDE(
            revenue,
            SUM(revenue) OVER (PARTITION BY sales_year)
        ) AS revenue_share,

        SAFE_DIVIDE(
            gross_profit,
            revenue
        ) AS gross_margin_rate

    FROM category_financials
),

year_comparison AS (

    SELECT
        product_category,

        MAX(IF(sales_year = 2022, revenue_share, NULL))
            AS share_2022,

        MAX(IF(sales_year = 2023, revenue_share, NULL))
            AS share_2023,

        MAX(IF(sales_year = 2022, gross_margin_rate, NULL))
            AS margin_2022,

        MAX(IF(sales_year = 2023, gross_margin_rate, NULL))
            AS margin_2023

    FROM category_metrics

    GROUP BY
        product_category
),

decomposition AS (

    SELECT
        product_category,
        share_2022,
        share_2023,
        margin_2022,
        margin_2023,

        share_2023
            * (margin_2023 - margin_2022)
            * 100 AS margin_effect_pp,

        (share_2023 - share_2022)
            * margin_2022
            * 100 AS mix_effect_pp

    FROM year_comparison
),

contributions AS (

    SELECT
        *,

        margin_effect_pp + mix_effect_pp
            AS total_effect_pp

    FROM decomposition
)

SELECT
    product_category,

    ROUND(share_2022 * 100, 2)
        AS revenue_share_2022_pct,

    ROUND(share_2023 * 100, 2)
        AS revenue_share_2023_pct,

    ROUND(margin_2022 * 100, 2)
        AS gm_2022_pct,

    ROUND(margin_2023 * 100, 2)
        AS gm_2023_pct,

    ROUND(margin_effect_pp, 4)
        AS within_category_margin_effect_pp,

    ROUND(mix_effect_pp, 4)
        AS category_revenue_mix_effect_pp,

    ROUND(total_effect_pp, 4)
        AS total_contribution_pp,

    ROUND(
        SUM(total_effect_pp) OVER (),
        4
    ) AS company_margin_change_pp,

    CASE
        WHEN ABS(
            SUM(total_effect_pp) OVER ()
            - (-3.3464)
        ) < 0.0001
        THEN 'PASS'
        ELSE 'REVIEW'
    END AS baseline_reconciliation_status

FROM contributions

ORDER BY total_effect_pp ASC;
