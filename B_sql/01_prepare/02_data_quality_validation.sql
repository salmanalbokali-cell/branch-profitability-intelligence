-- ============================================================
-- Store Margin & Performance Intelligence
-- PREPARE Stage - Data Quality Validation
-- Platform: Google BigQuery
-- ============================================================


-- 1. PRODUCTS COMPLETENESS

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(Product_ID IS NULL) AS null_product_id,
    COUNTIF(Product_Name IS NULL) AS null_product_name,
    COUNTIF(Product_Category IS NULL) AS null_product_category,
    COUNTIF(Product_Cost IS NULL) AS null_product_cost,
    COUNTIF(Product_Price IS NULL) AS null_product_price
FROM maven_toys_raw.products;


-- 2. STORES COMPLETENESS

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(Store_ID IS NULL) AS null_store_id,
    COUNTIF(Store_Name IS NULL) AS null_store_name,
    COUNTIF(Store_City IS NULL) AS null_store_city,
    COUNTIF(Store_Location IS NULL) AS null_store_location,
    COUNTIF(Store_Open_Date IS NULL) AS null_store_open_date
FROM maven_toys_raw.stores;


-- 3. INVENTORY COMPLETENESS AND VALIDITY

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(Store_ID IS NULL) AS null_store_id,
    COUNTIF(Product_ID IS NULL) AS null_product_id,
    COUNTIF(Stock_On_Hand IS NULL) AS null_stock_on_hand,
    COUNTIF(SAFE_CAST(Stock_On_Hand AS INT64) IS NULL) AS invalid_stock,
    COUNTIF(SAFE_CAST(Stock_On_Hand AS INT64) < 0) AS negative_stock,
    MIN(SAFE_CAST(Stock_On_Hand AS INT64)) AS min_stock,
    MAX(SAFE_CAST(Stock_On_Hand AS INT64)) AS max_stock
FROM maven_toys_raw.inventory;


-- 4. CALENDAR CONTINUITY

WITH date_series AS (
    SELECT day
    FROM UNNEST(
        GENERATE_DATE_ARRAY(
            DATE(2022, 1, 1),
            DATE(2023, 9, 30)
        )
    ) AS day
)

SELECT
    COUNT(*) AS expected_dates,
    COUNTIF(c.Date IS NOT NULL) AS dates_found,
    COUNTIF(c.Date IS NULL) AS missing_dates
FROM date_series AS d
LEFT JOIN maven_toys_raw.calendar AS c
    ON d.day = SAFE.PARSE_DATE('%m/%d/%Y', c.Date);


-- 5. STORE OPEN DATE VALIDITY

SELECT
    COUNT(*) AS total_rows,
    COUNTIF(SAFE_CAST(Store_Open_Date AS DATE) IS NULL) AS invalid_open_dates,
    MIN(SAFE_CAST(Store_Open_Date AS DATE)) AS earliest_open_date,
    MAX(SAFE_CAST(Store_Open_Date AS DATE)) AS latest_open_date
FROM maven_toys_raw.stores;


-- 6. TEMPORAL INTEGRITY

SELECT
    COUNT(*) AS total_sales_rows,
    COUNTIF(
        SAFE_CAST(s.Date AS DATE) < SAFE_CAST(st.Store_Open_Date AS DATE)
    ) AS sales_before_store_open
FROM maven_toys_raw.sales AS s
JOIN maven_toys_raw.stores AS st
    ON s.Store_ID = st.Store_ID;


-- 7. SALES COVERAGE

SELECT
    (SELECT COUNT(*) FROM maven_toys_raw.stores) AS total_stores,
    COUNT(DISTINCT Store_ID) AS stores_with_sales,
    (SELECT COUNT(*) FROM maven_toys_raw.products) AS total_products,
    COUNT(DISTINCT Product_ID) AS products_with_sales
FROM maven_toys_raw.sales;


-- 8. INVENTORY COVERAGE

WITH sold_pairs AS (
    SELECT DISTINCT
        Store_ID,
        Product_ID
    FROM maven_toys_raw.sales
)

SELECT
    COUNTIF(i.Store_ID IS NULL) AS sold_pairs_missing_inventory,
    COUNTIF(s.Store_ID IS NULL) AS inventory_pairs_without_sales
FROM sold_pairs AS s
FULL OUTER JOIN maven_toys_raw.inventory AS i
    ON s.Store_ID = i.Store_ID
    AND s.Product_ID = i.Product_ID;
