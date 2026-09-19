# Store Margin & Performance Intelligence

End-to-end financial and operational analytics case study using public retail data, BigQuery, SQL, Excel, Python, and Tableau.

## Project Objective

Investigate why gross-margin performance weakened despite strong revenue and unit growth, identify where the deterioration is concentrated, and support management with evidence-based priorities.

## Preliminary Business Signal

January–September 2023 vs. January–September 2022:

- Revenue: +30.9%
- Units sold: +40.8%
- Gross profit: +16.0%
- Gross margin: 29.5% → 26.2% (-3.35 pp)

## Project Workflow

A. [Documentation](A_docs/)  
B. [SQL](B_sql/)  
C. [Evidence](C_evidence/)  
D. Data Processing  
E. Analysis  
F. Dashboard & Reporting

## Current Stage

**PROCESS — Completed**

The RAW source layer has been preserved and transformed into a separate analysis-ready CLEAN layer in Google BigQuery.

The PROCESS stage included:

- Data-type conversion for dates, quantities, costs, and prices
- `lower_snake_case` naming standardization
- CLEAN-layer metadata alignment
- Post-clean key and relationship validation
- Temporal-integrity validation
- RAW vs CLEAN row-preservation auditing

All required PROCESS checks passed, and the CLEAN dataset is ready for the ANALYZE stage.
