# Data Preparation Assessment

## Data Source

- Dataset: Mexico Toy Sales
- Source: Maven Analytics
- Source type: External secondary data
- License: Public Domain
- Analytical period: 2022-01-01 to 2023-09-30
- Platform used for preparation: Google BigQuery

The original CSV files were loaded into the `maven_toys_raw` BigQuery dataset without cleaning or transformation.

## Source Structure

| Table | Rows | Grain | Key Candidate |
|---|---:|---|---|
| stores | 50 | One store | Store_ID |
| products | 35 | One product | Product_ID |
| inventory | 1,593 | One store-product combination | Store_ID + Product_ID |
| calendar | 638 | One date | Date |
| sales | 829,262 | One sales record | Sale_ID |
| data_dictionary | 19 | One field definition | N/A |

## Validation Results

BigQuery and SQL validation confirmed:

- No null values in the core source tables
- Sale_ID, Store_ID, Product_ID, and calendar dates are unique where required
- All sales and inventory Store_ID and Product_ID values match their reference tables
- All sales dates exist in the calendar
- Calendar coverage is continuous across 638 days
- Units and Stock_On_Hand contain valid integer-compatible values
- Product_Cost and Product_Price contain valid positive monetary values
- No sales were recorded before the related store opening date
- All 50 stores and all 35 products appear in sales
- All 19 metadata definitions match the actual table schemas

SQL evidence: [View BigQuery profiling queries](../B_sql/01_prepare/01_data_profiling.sql)

## Processing Requirements

The raw layer intentionally preserves the source representation. The PROCESS stage will address:

- Sales and calendar date format differences
- Product_Cost and Product_Price conversion to numeric types
- Units and Stock_On_Hand conversion to integer types
- Store_Open_Date conversion to DATE

## Inventory Limitation

Historical sales contain 1,631 store-product combinations compared with 1,593 combinations in the inventory snapshot.

- 41 historically sold combinations are absent from inventory
- 3 inventory combinations have no sales history

These differences are treated as coverage characteristics rather than confirmed errors because historical inventory movements are unavailable.

## Preparation Decision

The available data is sufficiently complete, consistent, and relevant for the defined sales and gross-margin investigation.

The raw tables will remain unchanged. Cleaning and transformation will be performed separately during the PROCESS stage.
