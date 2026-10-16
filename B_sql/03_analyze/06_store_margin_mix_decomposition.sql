
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 06 - Store Margin and Revenue-Mix Decomposition
-- Platform: Google BigQuery (Standard SQL)
--
-- BUSINESS QUESTION
-- How much of the company gross-margin change is explained
-- by within-store margin changes versus store revenue mix?
--
-- REPORTING PERIODS
-- Jan 1 - Sep 30, 2022
-- Jan 1 - Sep 30, 2023
--
-- REPORTING GRAIN
-- Store-year financials; company-level final output.
--
-- FINANCIAL DEFINITIONS
-- Revenue      = SUM(units * product_price)
-- Gross Profit = SUM(units * (product_price - product_cost))
-- Store Margin = Store Gross Profit / Store Revenue
-- Revenue Share = Store Revenue / Company Revenue
--
-- DECOMPOSITION METHOD
-- Margin Effect:
--   2023 revenue share * (2023 margin - 2022 margin)
--
-- Revenue-Mix Effect:
--   (2023 revenue share - 2022 revenue share)
--   * 2022 margin
--
-- Effects are summed across stores and converted
-- to percentage points.
--
-- EXACT IDENTITY
-- Company GM Change = Margin Effect + Revenue-Mix Effect
--
-- VALIDATION
-- Compare the sum of decomposition effects with the
-- actual change in company gross margin.
-- A tolerance of 0.000001 percentage points is allowed
-- for numerical precision.
--
-- INTERPRETATION
-- The within-store effect may reflect changes in
-- product/category sales mix within individual stores.
-- This decomposition does not establish causation.
--
-- LIMITATIONS
-- Product prices and costs are static source attributes,
-- not verified historical transaction-level amounts.
-- Stores are expected to have revenue in both periods.
-- The dataset contains 50 stores.
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

store_metrics AS (

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

        SAFE_DIVIDE(gross_profit, revenue)
            AS gross_margin_rate

    FROM store_financials
),

year_comparison AS (

    SELECT
        store_id,
        store_name,

        MAX(IF(sales_year = 2022, revenue_share, NULL))
            AS share_2022,

        MAX(IF(sales_year = 2023, revenue_share, NULL))
            AS share_2023,

        MAX(IF(sales_year = 2022, gross_margin_rate, NULL))
            AS margin_2022,

        MAX(IF(sales_year = 2023, gross_margin_rate, NULL))
            AS margin_2023

    FROM store_metrics
    GROUP BY store_id, store_name
),

decomposition AS (

    SELECT
        store_id,
        store_name,

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

    FROM store_financials
    GROUP BY sales_year
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
        COUNT(*) AS stores_analyzed,

        SUM(margin_effect_pp)
            AS total_margin_effect_pp,

        SUM(mix_effect_pp)
            AS total_mix_effect_pp,

        SUM(margin_effect_pp + mix_effect_pp)
            AS decomposed_change_pp

    FROM decomposition
)

SELECT
    r.stores_analyzed,

    ROUND(r.total_margin_effect_pp, 4)
        AS within_store_margin_effect_pp,

    ROUND(r.total_mix_effect_pp, 4)
        AS revenue_mix_effect_pp,

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
        WHEN r.stores_analyzed = 50
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
