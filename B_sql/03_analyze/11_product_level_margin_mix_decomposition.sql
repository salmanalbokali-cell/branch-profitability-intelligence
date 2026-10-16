
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 11 - Product-Level Gross-Margin Mix Decomposition
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- Which individual products contributed most to the
-- change in company-wide gross-margin percentage?
--
-- REPORTING PERIODS
-- Jan 1 - Sep 30, 2022
-- Jan 1 - Sep 30, 2023
--
-- REPORTING GRAIN
-- One row per product (35 products expected).
--
-- METHOD
-- Company Gross Margin =
--   SUM(Product Revenue Share * Product Margin Rate)
--
-- Product Contribution (pp) =
--   (2023 Revenue Share - 2022 Revenue Share)
--   * Product Margin Rate * 100
--
-- This is an exact product revenue-mix decomposition
-- when product margin rates are constant across periods.
--
-- ZERO-SALES HANDLING
-- Products without sales in a period receive zero revenue
-- and zero company revenue share for that period.
-- Their modeled margin rate comes from the product master.
--
-- VALIDATION
-- Expected company margin change: approximately -3.3464 pp
-- Expected products: 35
-- Expected company revenues:
--   2022 = 5,320,115.85
--   2023 = 6,962,074.27
--
-- LIMITATIONS
-- Product prices and costs are static source attributes.
-- The analysis does not establish historical price changes,
-- historical cost inflation, or causation.
-- ============================================================

WITH product_master AS (

    SELECT
        product_id,
        product_name,
        product_category,
        product_price,
        product_cost,

        SAFE_DIVIDE(
            product_price - product_cost,
            product_price
        ) AS product_margin_rate

    FROM `store-margin-intelligence.maven_toys_clean.products`
),

product_sales AS (

    SELECT
        s.product_id,
        EXTRACT(YEAR FROM s.date) AS sales_year,
        SUM(s.units) AS units_sold

    FROM `store-margin-intelligence.maven_toys_clean.sales` AS s

    WHERE
        (s.date BETWEEN '2022-01-01' AND '2022-09-30')
        OR
        (s.date BETWEEN '2023-01-01' AND '2023-09-30')

    GROUP BY
        s.product_id,
        sales_year
),

product_year_financials AS (

    SELECT
        p.product_id,
        p.product_name,
        p.product_category,
        p.product_margin_rate,

        COALESCE(
            SUM(
                IF(
                    s.sales_year = 2022,
                    s.units_sold * p.product_price,
                    0
                )
            ),
            0
        ) AS revenue_2022,

        COALESCE(
            SUM(
                IF(
                    s.sales_year = 2023,
                    s.units_sold * p.product_price,
                    0
                )
            ),
            0
        ) AS revenue_2023

    FROM product_master AS p

    LEFT JOIN product_sales AS s
        ON p.product_id = s.product_id

    GROUP BY
        p.product_id,
        p.product_name,
        p.product_category,
        p.product_margin_rate
),

revenue_shares AS (

    SELECT
        *,

        SAFE_DIVIDE(
            revenue_2022,
            SUM(revenue_2022) OVER ()
        ) AS share_2022,

        SAFE_DIVIDE(
            revenue_2023,
            SUM(revenue_2023) OVER ()
        ) AS share_2023

    FROM product_year_financials
),

product_contributions AS (

    SELECT
        *,

        (share_2023 - share_2022)
            * product_margin_rate
            * 100 AS product_mix_contribution_pp

    FROM revenue_shares
),

reconciliation AS (

    SELECT
        *,

        SUM(product_mix_contribution_pp) OVER ()
            AS total_company_margin_change_pp,

        SUM(
            share_2022 * product_margin_rate
        ) OVER () * 100 AS company_gm_2022_pct,

        SUM(
            share_2023 * product_margin_rate
        ) OVER () * 100 AS company_gm_2023_pct,

        SUM(revenue_2022) OVER ()
            AS company_revenue_2022,

        SUM(revenue_2023) OVER ()
            AS company_revenue_2023,

        COUNT(*) OVER () AS products_analyzed

    FROM product_contributions
)

SELECT
    product_id,
    product_name,
    product_category,

    CASE
        WHEN revenue_2022 > 0 AND revenue_2023 > 0
            THEN 'Continuing Product'
        WHEN revenue_2022 = 0 AND revenue_2023 > 0
            THEN 'No 2022 Sales'
        WHEN revenue_2022 > 0 AND revenue_2023 = 0
            THEN 'No 2023 Sales'
        ELSE 'No Sales in Either Period'
    END AS product_comparison_status,

    ROUND(revenue_2022, 2) AS revenue_2022,
    ROUND(revenue_2023, 2) AS revenue_2023,

    ROUND(product_margin_rate * 100, 2)
        AS product_gross_margin_pct,

    ROUND(share_2022 * 100, 2)
        AS company_revenue_share_2022_pct,

    ROUND(share_2023 * 100, 2)
        AS company_revenue_share_2023_pct,

    ROUND((share_2023 - share_2022) * 100, 2)
        AS revenue_share_change_pp,

    ROUND(product_mix_contribution_pp, 4)
        AS product_mix_contribution_pp,

    ROUND(
        total_company_margin_change_pp,
        4
    ) AS company_margin_change_pp,

    ROUND(company_gm_2022_pct, 4)
        AS company_gm_2022_pct,

    ROUND(company_gm_2023_pct, 4)
        AS company_gm_2023_pct,

    products_analyzed,

    ROUND(company_revenue_2022, 2)
        AS company_revenue_2022_check,

    ROUND(company_revenue_2023, 2)
        AS company_revenue_2023_check,

    CASE
        WHEN products_analyzed = 35

         AND ABS(
             company_revenue_2022 - 5320115.85
         ) < 0.01

         AND ABS(
             company_revenue_2023 - 6962074.27
         ) < 0.01

         AND ABS(
             total_company_margin_change_pp
             - (company_gm_2023_pct - company_gm_2022_pct)
         ) < 0.000001

         AND ABS(
             total_company_margin_change_pp - (-3.3464)
         ) < 0.0001

        THEN 'PASS'
        ELSE 'REVIEW'
    END AS reconciliation_status

FROM reconciliation

ORDER BY
    product_mix_contribution_pp ASC,
    product_name;
