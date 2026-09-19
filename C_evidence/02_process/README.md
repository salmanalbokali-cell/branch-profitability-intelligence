# PROCESS Stage Evidence

BigQuery execution evidence supporting the data-cleaning and validation work completed during the PROCESS stage.

## Evidence Files

### 01_raw_vs_clean_row_audit.png

Confirms that RAW and CLEAN row counts match across all six project tables.

All tables returned:

`row_difference = 0`

This verifies that no source records were unintentionally added or removed during processing.

### 02_clean_relationship_validation.png

Confirms that CLEAN-layer relational integrity was preserved after data-type conversion and column standardization.

The following relationships returned zero unmatched rows:

- sales → stores
- sales → products
- sales → calendar
- inventory → stores
- inventory → products

## Purpose

These screenshots provide execution evidence only.

The reproducible transformation and validation logic is maintained in:

- `B_sql/02_process/01_create_clean_tables.sql`
- `B_sql/02_process/02_post_clean_validation.sql`

The full transformation rationale and validation summary is documented in:

- `A_docs/07_data_processing_log.md`
