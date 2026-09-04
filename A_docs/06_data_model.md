# Data Model

The Maven Toys source data follows a relational structure centered on sales, stores, products, inventory, and calendar dates.

```mermaid
erDiagram
    STORES ||--o{ SALES : records
    PRODUCTS ||--o{ SALES : contains
    CALENDAR ||--o{ SALES : dates
    STORES ||--o{ INVENTORY : holds
    PRODUCTS ||--o{ INVENTORY : stocks

    STORES {
        STRING Store_ID PK
        STRING Store_Name
        STRING Store_City
        STRING Store_Location
        STRING Store_Open_Date
    }

    PRODUCTS {
        STRING Product_ID PK
        STRING Product_Name
        STRING Product_Category
        STRING Product_Cost
        STRING Product_Price
    }

    SALES {
        STRING Sale_ID PK
        STRING Date FK
        STRING Store_ID FK
        STRING Product_ID FK
        STRING Units
    }

    INVENTORY {
        STRING Store_ID PK, FK
        STRING Product_ID PK, FK
        STRING Stock_On_Hand
    }

    CALENDAR {
        STRING Date PK
    }
```

## Relationship Summary

| From | To | Relationship |
|---|---|---|
| sales.Store_ID | stores.Store_ID | Many sales to one store |
| sales.Product_ID | products.Product_ID | Many sales to one product |
| sales.Date | calendar.Date | Many sales records to one date |
| inventory.Store_ID | stores.Store_ID | Many inventory records to one store |
| inventory.Product_ID | products.Product_ID | Many inventory records to one product |

## Grain

- stores: one row per store
- products: one row per product
- sales: one row per sales record
- inventory: one row per store-product combination
- calendar: one row per date

Key and relationship candidates were validated using SQL during the PREPARE stage. The raw BigQuery tables do not rely on enforced database constraints.
