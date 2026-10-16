
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 08 - Category Margin and Revenue-Mix Decomposition
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- How much of the company gross-margin change is associated
-- with changes in category margin rates versus changes in
-- category revenue shares?
--
-- REPORTING PERIODS
-- Jan 1 - Sep 30, 2022
-- Jan 1 - Sep 30, 2023
--
-- REPORTING GRAIN
-- Category-year financials; company-level final output.
--
-- FINANCIAL DEFINITIONS
-- Revenue       = SUM(units * product_price)
-- Gross Profit  = SUM(units * (product_price - product_cost))
-- Category GM   = Category Gross Profit / Category Revenue
-- Revenue Share = Category Revenue / Company Revenue
--
-- DECOMPOSITION METHOD
-- Margin Effect:
--   2023 revenue share * (2023 margin - 2022 margin)
--
-- Revenue-Mix Effect:
--   (2023 revenue share - 2022 revenue share)
--   * 2022 margin
--
-- Both effects are converted to percentage points.
--
-- EXACT IDENTITY
-- Company GM Change = Margin Effect + Revenue-Mix Effect
--
-- VALIDATION
-- The combined decomposition must reconcile to the
-- actual company-wide gross-margin change.
--
-- A tolerance of 0.000001 percentage points is allowed
-- for numerical precision.
--
-- INTERPRETATION
-- The margin effect captures changes in gross-margin rates
-- within product categories.
--
-- The mix effect captures changes in category revenue shares,
-- holding category margins at their 2022 levels.
--
-- The decomposition is an accounting identity and does not
-- independently establish underlying causes.
--
-- LIMITATIONS
-- Product prices and costs are static source attributes,
-- not verified historical transaction-level amounts.
-- Categories must have revenue in both comparison periods.
-- Five product categories are expected.
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
        revenue,
        gross_profit,

        SAFE_DIVIDE(
            revenue,
            SUM(revenue) OVER (PARTITION BY sales_year)
        ) AS revenue_share,

        SAFE_DIVIDE(gross_profit, revenue)
            AS gross_margin_rate

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

        share_2023 * (margin_2023 - margin_2022) * 100
            AS margin_effect_pp,

        (share_2023 - share_2022) * margin_2022 * 100
            AS mix_effect_pp

    FROM year_comparison
),

company_financials AS (

    SELECT
        sales_year,

        SAFE_DIVIDE(
            SUM(gross_profit),
            SUM(revenue)
        ) * 100 AS company_margin_pct

    FROM category_financials

    GROUP BY
        sales_year
),

company_comparison AS (

    SELECT
        MAX(IF(sales_year = 2022, company_margin_pct, NULL))
            AS company_margin_2022,

        MAX(IF(sales_year = 2023, company_margin_pct, NULL))
            AS company_margin_2023

    FROM company_financials
),

reconciliation AS (

    SELECT
        COUNT(*) AS categories_analyzed,

        SUM(margin_effect_pp)
            AS total_margin_effect_pp,

        SUM(mix_effect_pp)
            AS total_mix_effect_pp,

        SUM(margin_effect_pp + mix_effect_pp)
            AS decomposed_change_pp

    FROM decomposition
)

SELECT
    r.categories_analyzed,

    ROUND(r.total_margin_effect_pp, 4)
        AS within_category_margin_effect_pp,

    ROUND(r.total_mix_effect_pp, 4)
        AS category_revenue_mix_effect_pp,

    ROUND(r.decomposed_change_pp, 4)
        AS decomposed_change_pp,

    ROUND(
        c.company_margin_2023 - c.company_margin_2022,
        4
    ) AS actual_company_change_pp,

    ROUND(
        r.decomposed_change_pp
        - (c.company_margin_2023 - c.company_margin_2022),
        8
    ) AS reconciliation_difference_pp,

    CASE
        WHEN r.categories_analyzed = 5
         AND c.company_margin_2022 IS NOT NULL
         AND c.company_margin_2023 IS NOT NULL
         AND ABS(
             r.decomposed_change_pp
             - (c.company_margin_2023 - c.company_margin_2022)
         ) < 0.000001
            THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status

FROM reconciliation AS r
CROSS JOIN company_comparison AS c;
