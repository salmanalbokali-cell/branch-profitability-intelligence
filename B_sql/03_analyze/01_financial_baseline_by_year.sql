
-- ============================================================
-- Store Margin & Performance Intelligence
-- ANALYZE | 01 - Financial Baseline by Year
-- Platform: Google BigQuery (Standard SQL)
--
-- Business Question:
-- How did the company's financial performance compare
-- between Jan-Sep 2022 and Jan-Sep 2023?
--
-- Grain: One row per reporting year
-- Source: Validated CLEAN sales and products tables
--
-- Financial Definitions:
-- Revenue      = SUM(units * product_price)
-- COGS         = SUM(units * product_cost)
-- Gross Profit = Revenue - COGS
-- Gross Margin = Gross Profit / Revenue * 100
--
-- Limitation:
-- Source product prices and costs may not represent
-- historical transaction-level prices and costs.
-- ============================================================

SELECT
    EXTRACT(YEAR FROM s.date) AS sales_year,

    SUM(s.units) AS units_sold,

    SUM(s.units * p.product_price) AS revenue,

    SUM(s.units * p.product_cost) AS cogs,

    SUM(
        s.units * (p.product_price - p.product_cost)
    ) AS gross_profit,

    ROUND(
        SAFE_DIVIDE(
            SUM(s.units * (p.product_price - p.product_cost)),
            SUM(s.units * p.product_price)
        ) * 100,
        2
    ) AS gross_margin_pct

FROM `store-margin-intelligence.maven_toys_clean.sales` AS s

INNER JOIN `store-margin-intelligence.maven_toys_clean.products` AS p
    ON s.product_id = p.product_id

WHERE
    (s.date BETWEEN '2022-01-01' AND '2022-09-30')
    OR
    (s.date BETWEEN '2023-01-01' AND '2023-09-30')

GROUP BY
    sales_year

ORDER BY
    sales_year;
