-- ============================================================
-- Store Margin & Performance Intelligence
-- PREPARE Stage - Source Data Profiling and Validation
-- Platform: Google BigQuery
-- ============================================================


-- 1. SALES TABLE: GRAIN, KEY AND DATE COVERAGE

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Sale_ID) AS unique_sale_ids,
    COUNTIF(Sale_ID IS NULL) AS null_sale_ids,
    COUNTIF(SAFE_CAST(Date AS DATE) IS NULL) AS invalid_dates,
    MIN(SAFE_CAST(Date AS DATE)) AS first_date,
    MAX(SAFE_CAST(Date AS DATE)) AS last_date
FROM maven_toys_raw.sales;


-- 2. SALES FOREIGN-KEY VALIDATION

SELECT
    COUNTIF(st.Store_ID IS NULL) AS unmatched_store_ids,
    COUNTIF(p.Product_ID IS NULL) AS unmatched_product_ids
FROM maven_toys_raw.sales AS s
LEFT JOIN maven_toys_raw.stores AS st
    ON s.Store_ID = st.Store_ID
LEFT JOIN maven_toys_raw.products AS p
    ON s.Product_ID = p.Product_ID;


-- 3. INVENTORY COMPOSITE-KEY VALIDATION

WITH inventory_keys AS (
    SELECT DISTINCT
        Store_ID,
        Product_ID
    FROM maven_toys_raw.inventory
)

SELECT
    (SELECT COUNT(*) FROM maven_toys_raw.inventory) AS total_rows,
    COUNT(*) AS unique_store_product_pairs
FROM inventory_keys;


-- 4. SALES QUANTITY VALIDATION

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(SAFE_CAST(Units AS INT64) IS NULL) AS invalid_units,
    COUNTIF(SAFE_CAST(Units AS INT64) <= 0) AS non_positive_units,
    MIN(SAFE_CAST(Units AS INT64)) AS min_units,
    MAX(SAFE_CAST(Units AS INT64)) AS max_units
FROM maven_toys_raw.sales;


-- 5. PRODUCT COST AND PRICE VALIDATION

SELECT
    COUNT(*) AS total_products,
    COUNTIF(SAFE_CAST(SUBSTR(Product_Cost, 2) AS NUMERIC) IS NULL) AS invalid_cost,
    COUNTIF(SAFE_CAST(SUBSTR(Product_Price, 2) AS NUMERIC) IS NULL) AS invalid_price,
    COUNTIF(
        SAFE_CAST(SUBSTR(Product_Price, 2) AS NUMERIC)
        <= SAFE_CAST(SUBSTR(Product_Cost, 2) AS NUMERIC)
    ) AS price_not_above_cost
FROM maven_toys_raw.products;


-- 6. METADATA VALIDATION

SELECT
    COUNT(*) AS documented_fields,
    COUNTIF(c.column_name IS NULL) AS unmatched_fields
FROM maven_toys_raw.data_dictionary AS d
LEFT JOIN maven_toys_raw.INFORMATION_SCHEMA.COLUMNS AS c
    ON LOWER(d.Table) = LOWER(c.table_name)
    AND d.Field = c.column_name;
