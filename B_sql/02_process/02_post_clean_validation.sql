-- ============================================================
-- Store Margin & Performance Intelligence
-- PROCESS Stage - Post-Clean Validation
-- Platform: Google BigQuery
--
-- Purpose:
-- Verify that CLEAN-layer transformations preserved data
-- integrity, relationships, business rules, and row counts.
-- ============================================================


-- ============================================================
-- 1. PRODUCTS VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(product_cost IS NULL) AS null_cost,
    COUNTIF(product_price IS NULL) AS null_price,
    COUNTIF(product_cost <= 0) AS non_positive_cost,
    COUNTIF(product_price <= 0) AS non_positive_price,
    COUNTIF(product_price <= product_cost) AS price_not_above_cost,
    MIN(product_cost) AS min_cost,
    MAX(product_cost) AS max_cost,
    MIN(product_price) AS min_price,
    MAX(product_price) AS max_price
FROM `store-margin-intelligence.maven_toys_clean.products`;


-- Expected:
-- total_rows = 35
-- null_cost = 0
-- null_price = 0
-- non_positive_cost = 0
-- non_positive_price = 0
-- price_not_above_cost = 0
-- min_cost = 1.99
-- max_cost = 34.99
-- min_price = 2.99
-- max_price = 39.99


-- ============================================================
-- 2. STORES VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT store_id) AS unique_store_ids,
    COUNTIF(store_id IS NULL) AS null_store_ids,
    COUNTIF(store_open_date IS NULL) AS null_open_dates,
    MIN(store_open_date) AS earliest_open_date,
    MAX(store_open_date) AS latest_open_date
FROM `store-margin-intelligence.maven_toys_clean.stores`;


-- Expected:
-- total_rows = 50
-- unique_store_ids = 50
-- null_store_ids = 0
-- null_open_dates = 0
-- earliest_open_date = 1992-09-18
-- latest_open_date = 2016-05-18


-- ============================================================
-- 3. INVENTORY VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(store_id, '-', product_id))
        AS unique_store_product_pairs,
    COUNTIF(store_id IS NULL) AS null_store_ids,
    COUNTIF(product_id IS NULL) AS null_product_ids,
    COUNTIF(stock_on_hand IS NULL) AS null_stock,
    COUNTIF(stock_on_hand < 0) AS negative_stock,
    MIN(stock_on_hand) AS min_stock,
    MAX(stock_on_hand) AS max_stock
FROM `store-margin-intelligence.maven_toys_clean.inventory`;


-- Expected:
-- total_rows = 1593
-- unique_store_product_pairs = 1593
-- null_store_ids = 0
-- null_product_ids = 0
-- null_stock = 0
-- negative_stock = 0
-- min_stock = 0
-- max_stock = 139


-- ============================================================
-- 4. CALENDAR VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT date) AS unique_dates,
    COUNTIF(date IS NULL) AS null_dates,
    MIN(date) AS first_date,
    MAX(date) AS last_date
FROM `store-margin-intelligence.maven_toys_clean.calendar`;


-- Expected:
-- total_rows = 638
-- unique_dates = 638
-- null_dates = 0
-- first_date = 2022-01-01
-- last_date = 2023-09-30


-- ============================================================
-- 5. SALES VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT sale_id) AS unique_sale_ids,
    COUNTIF(sale_id IS NULL) AS null_sale_ids,
    COUNTIF(date IS NULL) AS null_dates,
    COUNTIF(store_id IS NULL) AS null_store_ids,
    COUNTIF(product_id IS NULL) AS null_product_ids,
    COUNTIF(units IS NULL) AS null_units,
    COUNTIF(units <= 0) AS non_positive_units,
    MIN(units) AS min_units,
    MAX(units) AS max_units,
    MIN(date) AS first_sale_date,
    MAX(date) AS last_sale_date,
    COUNT(DISTINCT store_id) AS stores_with_sales,
    COUNT(DISTINCT product_id) AS products_with_sales
FROM `store-margin-intelligence.maven_toys_clean.sales`;


-- Expected:
-- total_rows = 829262
-- unique_sale_ids = 829262
-- all null counts = 0
-- non_positive_units = 0
-- min_units = 1
-- max_units = 30
-- first_sale_date = 2022-01-01
-- last_sale_date = 2023-09-30
-- stores_with_sales = 50
-- products_with_sales = 35


-- ============================================================
-- 6. DATA DICTIONARY VALIDATION
-- Verify that documented CLEAN field names match the actual
-- CLEAN-layer schemas.
-- ============================================================

SELECT
    COUNT(*) AS documented_fields,
    COUNTIF(c.column_name IS NULL) AS unmatched_fields
FROM `store-margin-intelligence.maven_toys_clean.data_dictionary` AS d

LEFT JOIN
    `store-margin-intelligence.maven_toys_clean.INFORMATION_SCHEMA.COLUMNS`
    AS c
    ON LOWER(d.table_name) = LOWER(c.table_name)
    AND LOWER(d.field_name) = LOWER(c.column_name);


-- Expected:
-- documented_fields = 19
-- unmatched_fields = 0


-- ============================================================
-- 7. SALES RELATIONSHIP VALIDATION
-- ============================================================

SELECT
    COUNTIF(st.store_id IS NULL) AS unmatched_store_ids,
    COUNTIF(p.product_id IS NULL) AS unmatched_product_ids,
    COUNTIF(c.date IS NULL) AS unmatched_dates
FROM `store-margin-intelligence.maven_toys_clean.sales` AS s

LEFT JOIN `store-margin-intelligence.maven_toys_clean.stores` AS st
    ON s.store_id = st.store_id

LEFT JOIN `store-margin-intelligence.maven_toys_clean.products` AS p
    ON s.product_id = p.product_id

LEFT JOIN `store-margin-intelligence.maven_toys_clean.calendar` AS c
    ON s.date = c.date;


-- Expected:
-- unmatched_store_ids = 0
-- unmatched_product_ids = 0
-- unmatched_dates = 0


-- ============================================================
-- 8. INVENTORY RELATIONSHIP VALIDATION
-- ============================================================

SELECT
    COUNTIF(st.store_id IS NULL) AS unmatched_store_ids,
    COUNTIF(p.product_id IS NULL) AS unmatched_product_ids
FROM `store-margin-intelligence.maven_toys_clean.inventory` AS i

LEFT JOIN `store-margin-intelligence.maven_toys_clean.stores` AS st
    ON i.store_id = st.store_id

LEFT JOIN `store-margin-intelligence.maven_toys_clean.products` AS p
    ON i.product_id = p.product_id;


-- Expected:
-- unmatched_store_ids = 0
-- unmatched_product_ids = 0


-- ============================================================
-- 9. TEMPORAL INTEGRITY
-- Verify that no sale occurred before its store opened.
-- ============================================================

SELECT
    COUNT(*) AS total_sales_rows,
    COUNTIF(s.date < st.store_open_date)
        AS sales_before_store_open
FROM `store-margin-intelligence.maven_toys_clean.sales` AS s

JOIN `store-margin-intelligence.maven_toys_clean.stores` AS st
    ON s.store_id = st.store_id;


-- Expected:
-- total_sales_rows = 829262
-- sales_before_store_open = 0


-- ============================================================
-- 10. RAW VS CLEAN ROW-PRESERVATION AUDIT
-- ============================================================

WITH raw_counts AS (

    SELECT 'products' AS table_name, COUNT(*) AS row_count
    FROM `store-margin-intelligence.maven_toys_raw.products`

    UNION ALL

    SELECT 'stores', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_raw.stores`

    UNION ALL

    SELECT 'inventory', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_raw.inventory`

    UNION ALL

    SELECT 'calendar', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_raw.calendar`

    UNION ALL

    SELECT 'sales', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_raw.sales`

    UNION ALL

    SELECT 'data_dictionary', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_raw.data_dictionary`
),

clean_counts AS (

    SELECT 'products' AS table_name, COUNT(*) AS row_count
    FROM `store-margin-intelligence.maven_toys_clean.products`

    UNION ALL

    SELECT 'stores', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_clean.stores`

    UNION ALL

    SELECT 'inventory', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_clean.inventory`

    UNION ALL

    SELECT 'calendar', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_clean.calendar`

    UNION ALL

    SELECT 'sales', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_clean.sales`

    UNION ALL

    SELECT 'data_dictionary', COUNT(*)
    FROM `store-margin-intelligence.maven_toys_clean.data_dictionary`
)

SELECT
    r.table_name,
    r.row_count AS raw_rows,
    c.row_count AS clean_rows,
    c.row_count - r.row_count AS row_difference
FROM raw_counts AS r

JOIN clean_counts AS c
    USING (table_name)

ORDER BY r.table_name;


-- Expected:
-- Every table must have row_difference = 0.
