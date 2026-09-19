-- ============================================================
-- Store Margin & Performance Intelligence
-- PROCESS Stage - Create Analysis-Ready CLEAN Tables
-- Platform: Google BigQuery
--
-- Source layer: maven_toys_raw
-- Target layer: maven_toys_clean
--
-- RAW tables remain unchanged.
-- CLEAN-layer columns use lower_snake_case.
-- ============================================================


-- ============================================================
-- 1. PRODUCTS
-- Convert cost and price from currency-formatted STRING
-- values to NUMERIC.
-- ============================================================

CREATE OR REPLACE TABLE
    `store-margin-intelligence.maven_toys_clean.products` AS

SELECT
    Product_ID AS product_id,
    Product_Name AS product_name,
    Product_Category AS product_category,
    SAFE_CAST(SUBSTR(Product_Cost, 2) AS NUMERIC) AS product_cost,
    SAFE_CAST(SUBSTR(Product_Price, 2) AS NUMERIC) AS product_price
FROM `store-margin-intelligence.maven_toys_raw.products`;


-- ============================================================
-- 2. STORES
-- Convert store opening date from STRING to DATE.
-- ============================================================

CREATE OR REPLACE TABLE
    `store-margin-intelligence.maven_toys_clean.stores` AS

SELECT
    Store_ID AS store_id,
    Store_Name AS store_name,
    Store_City AS store_city,
    Store_Location AS store_location,
    SAFE_CAST(Store_Open_Date AS DATE) AS store_open_date
FROM `store-margin-intelligence.maven_toys_raw.stores`;


-- ============================================================
-- 3. INVENTORY
-- Convert stock quantity from STRING to INT64.
-- ============================================================

CREATE OR REPLACE TABLE
    `store-margin-intelligence.maven_toys_clean.inventory` AS

SELECT
    Store_ID AS store_id,
    Product_ID AS product_id,
    SAFE_CAST(Stock_On_Hand AS INT64) AS stock_on_hand
FROM `store-margin-intelligence.maven_toys_raw.inventory`;


-- ============================================================
-- 4. CALENDAR
-- Parse M/D/YYYY source strings into DATE values.
-- ============================================================

CREATE OR REPLACE TABLE
    `store-margin-intelligence.maven_toys_clean.calendar` AS

SELECT
    SAFE.PARSE_DATE('%m/%d/%Y', Date) AS date
FROM `store-margin-intelligence.maven_toys_raw.calendar`;


-- ============================================================
-- 5. SALES
-- Convert sales date to DATE and units to INT64.
-- Preserve identifier fields as STRING.
-- ============================================================

CREATE OR REPLACE TABLE
    `store-margin-intelligence.maven_toys_clean.sales` AS

SELECT
    Sale_ID AS sale_id,
    SAFE_CAST(Date AS DATE) AS date,
    Store_ID AS store_id,
    Product_ID AS product_id,
    SAFE_CAST(Units AS INT64) AS units
FROM `store-margin-intelligence.maven_toys_raw.sales`;


-- ============================================================
-- 6. DATA DICTIONARY
-- Standardize metadata column names and align documented
-- field names with the CLEAN-layer schema.
-- ============================================================

CREATE OR REPLACE TABLE
    `store-margin-intelligence.maven_toys_clean.data_dictionary` AS

SELECT
    `Table` AS table_name,

    CASE Field
        WHEN 'Product_ID' THEN 'product_id'
        WHEN 'Product_Name' THEN 'product_name'
        WHEN 'Product_Category' THEN 'product_category'
        WHEN 'Product_Cost' THEN 'product_cost'
        WHEN 'Product_Price' THEN 'product_price'
        WHEN 'Store_ID' THEN 'store_id'
        WHEN 'Store_Name' THEN 'store_name'
        WHEN 'Store_City' THEN 'store_city'
        WHEN 'Store_Location' THEN 'store_location'
        WHEN 'Store_Open_Date' THEN 'store_open_date'
        WHEN 'Sale_ID' THEN 'sale_id'
        WHEN 'Date' THEN 'date'
        WHEN 'Units' THEN 'units'
        WHEN 'Stock_On_Hand' THEN 'stock_on_hand'
        ELSE Field
    END AS field_name,

    Description AS description

FROM `store-margin-intelligence.maven_toys_raw.data_dictionary`;
