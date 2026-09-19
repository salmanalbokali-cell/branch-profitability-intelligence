# Data Processing Log

## Project

**Store Margin & Performance Intelligence**

## Processing Objective

The PROCESS stage converts the preserved RAW source data into a standardized, analysis-ready CLEAN layer while maintaining data integrity, row-level coverage, key relationships, and documented source limitations.

The original tables in `maven_toys_raw` remain unchanged.

Processed tables are stored separately in:

`maven_toys_clean`

---

## Processing Principles

The following rules were applied throughout the PROCESS stage:

- Preserve the RAW source without modification.
- Create a separate CLEAN layer for analysis-ready data.
- Apply only transformations supported by PREPARE-stage findings.
- Do not delete records without confirmed evidence of error.
- Standardize CLEAN-layer column names using `lower_snake_case`.
- Preserve identifier fields as STRING.
- Convert analytical measures and dates to appropriate data types.
- Validate every transformation after processing.
- Recheck table keys, relationships, date logic, and row counts after cleaning.
- Distinguish confirmed data-quality issues from source-data limitations.

---

# Transformation Summary

## 1. Products

### Source

`maven_toys_raw.products`

### Issue

`Product_Cost` and `Product_Price` were stored as STRING values containing currency symbols.

Example:

`$10.99`

These fields require numeric data types for future revenue, COGS, gross-profit, and gross-margin calculations.

### Action

- Renamed columns to `lower_snake_case`.
- Removed the leading currency symbol.
- Converted:
  - `Product_Cost` → `product_cost` NUMERIC
  - `Product_Price` → `product_price` NUMERIC
- Preserved product identifiers and descriptive fields as STRING.

### Validation

Confirmed:

- 35 rows preserved.
- No failed cost conversions.
- No failed price conversions.
- No non-positive costs.
- No non-positive prices.
- No products with price less than or equal to cost.
- Cost range remained 1.99 to 34.99.
- Price range remained 2.99 to 39.99.

### Result

`maven_toys_clean.products`

---

## 2. Stores

### Source

`maven_toys_raw.stores`

### Issue

`Store_Open_Date` was stored as STRING rather than a DATE.

### Action

- Standardized all column names to `lower_snake_case`.
- Converted:
  - `Store_Open_Date` → `store_open_date` DATE
- Preserved store identifiers and descriptive attributes as STRING.

### Validation

Confirmed:

- 50 rows preserved.
- 50 unique `store_id` values.
- No null store identifiers.
- No failed date conversions.
- Earliest store opening date remained 1992-09-18.
- Latest store opening date remained 2016-05-18.

### Result

`maven_toys_clean.stores`

---

## 3. Inventory

### Source

`maven_toys_raw.inventory`

### Issue

`Stock_On_Hand` was stored as STRING rather than an integer quantity.

### Action

- Standardized all column names to `lower_snake_case`.
- Preserved:
  - `store_id` as STRING
  - `product_id` as STRING
- Converted:
  - `Stock_On_Hand` → `stock_on_hand` INT64

### Validation

Confirmed:

- 1,593 rows preserved.
- 1,593 unique store-product combinations.
- No null store identifiers.
- No null product identifiers.
- No failed stock conversions.
- No negative stock quantities.
- Stock range remained 0 to 139.

### Result

`maven_toys_clean.inventory`

---

## 4. Calendar

### Source

`maven_toys_raw.calendar`

### Issue

Calendar dates were stored as STRING values using month/day/year formatting.

Example:

`1/1/2022`

### Action

Parsed the source date using the expected source format:

`%m/%d/%Y`

and converted it to a true DATE field:

`date`

### Validation

Confirmed:

- 638 rows preserved.
- 638 unique dates.
- No failed date conversions.
- First date remained 2022-01-01.
- Last date remained 2023-09-30.

Calendar continuity had already been confirmed during PREPARE.

### Result

`maven_toys_clean.calendar`

---

## 5. Sales

### Source

`maven_toys_raw.sales`

### Issues

- `Date` was stored as STRING.
- `Units` was stored as STRING.
- Source column names did not follow the CLEAN-layer naming convention.

### Action

- Standardized all column names to `lower_snake_case`.
- Preserved identifiers as STRING:
  - `sale_id`
  - `store_id`
  - `product_id`
- Converted:
  - `Date` → `date` DATE
  - `Units` → `units` INT64

### Validation

Confirmed:

- 829,262 rows preserved.
- 829,262 unique sale identifiers.
- No null sale identifiers.
- No failed date conversions.
- No null store identifiers.
- No null product identifiers.
- No failed units conversions.
- No non-positive units.
- Units remained within the validated range of 1 to 30.
- Sales date coverage remained 2022-01-01 to 2023-09-30.
- All 50 stores remained represented.
- All 35 products remained represented.

### Result

`maven_toys_clean.sales`

---

## 6. Data Dictionary

### Source

`maven_toys_raw.data_dictionary`

### Issue

The source metadata documented RAW field names, while the CLEAN layer uses standardized `lower_snake_case` field names.

### Action

- Standardized metadata column names:
  - `Table` → `table_name`
  - `Field` → `field_name`
  - `Description` → `description`
- Updated documented field names to match the CLEAN-layer schema.
- Preserved the original field descriptions.

### Validation

Confirmed:

- 19 metadata definitions preserved.
- 0 documented fields unmatched to the CLEAN table schemas.

### Result

`maven_toys_clean.data_dictionary`

---

# Post-Clean Relationship Validation

Relationships were revalidated after all transformations.

The following relationships returned zero unmatched records:

- `sales.store_id` → `stores.store_id`
- `sales.product_id` → `products.product_id`
- `sales.date` → `calendar.date`
- `inventory.store_id` → `stores.store_id`
- `inventory.product_id` → `products.product_id`

This confirms that data-type conversions and naming standardization did not break the relational structure.

---

# Temporal Integrity Validation

The CLEAN sales and stores tables were tested to confirm that no sales occurred before the related store opening date.

Result:

- Sales rows: 829,262
- Sales before store opening: 0

The temporal business rule remained valid after date conversion.

---

# RAW vs CLEAN Row Preservation Audit

Final row counts were compared across all source and processed tables.

| Table | RAW Rows | CLEAN Rows | Difference |
|---|---:|---:|---:|
| products | 35 | 35 | 0 |
| stores | 50 | 50 | 0 |
| inventory | 1,593 | 1,593 | 0 |
| calendar | 638 | 638 | 0 |
| sales | 829,262 | 829,262 | 0 |
| data_dictionary | 19 | 19 | 0 |

No records were added or removed during PROCESS.

---

# Inventory Coverage Limitation

The PREPARE-stage inventory coverage findings remain unchanged.

Historical sales contain 1,631 store-product combinations, while the available inventory snapshot contains 1,593 combinations.

- 41 historically sold combinations are absent from the inventory snapshot.
- 3 inventory combinations have no historical sales.

These differences are retained as source coverage characteristics, not treated as confirmed data errors.

The project will not infer historical stockouts from the current inventory snapshot.

---

# Naming Convention

The project uses the following naming rule:

**RAW layer**

Preserve source field names and source representation.

**CLEAN layer**

Use `lower_snake_case`.

Examples:

- `Product_ID` → `product_id`
- `Product_Cost` → `product_cost`
- `Store_Open_Date` → `store_open_date`
- `Stock_On_Hand` → `stock_on_hand`

This convention improves consistency and portability across SQL platforms and analytical tools.

---

# Processing Environment Note

The project currently operates in the BigQuery sandbox environment.

Because billing is not enabled, BigQuery applies automatic table-expiration limitations to sandbox resources.

The analytical SQL and GitHub documentation are retained independently so that the CLEAN layer can be recreated reproducibly when required.

---

# PROCESS Stage Status

The required source transformations have been completed and validated.

The CLEAN layer now contains:

- `products`
- `stores`
- `inventory`
- `calendar`
- `sales`
- `data_dictionary`

All required type conversions, naming standardization, key checks, relationship checks, metadata checks, temporal-integrity checks, and RAW-vs-CLEAN row-preservation checks have passed.

The dataset is ready for consolidation of the PROCESS SQL scripts and final PROCESS-stage evidence before advancing to ANALYZE.
