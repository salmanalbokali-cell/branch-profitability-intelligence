# Data Dictionary

This dictionary documents the fields used in the Maven Toys analysis. Raw BigQuery fields are preserved as STRING where applicable; analytical data types will be assigned during PROCESS.

| Table | Field | Business Meaning | Raw Type | Target Type | Role |
|---|---|---|---|---|---|
| products | Product_ID | Unique product identifier | STRING | STRING | PK candidate |
| products | Product_Name | Product name | STRING | STRING | Attribute |
| products | Product_Category | Product category | STRING | STRING | Attribute |
| products | Product_Cost | Unit product cost in USD | STRING | NUMERIC | Measure |
| products | Product_Price | Unit retail price in USD | STRING | NUMERIC | Measure |
| stores | Store_ID | Unique store identifier | STRING | STRING | PK candidate |
| stores | Store_Name | Store name | STRING | STRING | Attribute |
| stores | Store_City | City where the store operates | STRING | STRING | Attribute |
| stores | Store_Location | Store location type | STRING | STRING | Attribute |
| stores | Store_Open_Date | Store opening date | STRING | DATE | Attribute |
| sales | Sale_ID | Unique sales record identifier | STRING | STRING | PK candidate |
| sales | Date | Date of the sales record | STRING | DATE | FK candidate |
| sales | Store_ID | Store associated with the sale | STRING | STRING | FK candidate |
| sales | Product_ID | Product associated with the sale | STRING | STRING | FK candidate |
| sales | Units | Number of units sold | STRING | INT64 | Measure |
| inventory | Store_ID | Store associated with inventory | STRING | STRING | Composite key / FK |
| inventory | Product_ID | Product associated with inventory | STRING | STRING | Composite key / FK |
| inventory | Stock_On_Hand | Current inventory quantity | STRING | INT64 | Measure |
| calendar | Date | Calendar date | STRING | DATE | PK candidate |

## Key Notes

- Store_ID and Product_ID are identifiers, not quantitative measures.
- inventory uses Store_ID + Product_ID as a composite key candidate.
- Product_Cost and Product_Price require removal of the currency symbol before numeric conversion.
- sales.Date and calendar.Date use different source formats and will be standardized during PROCESS.
- Key status is based on SQL validation performed during the PREPARE stage.
