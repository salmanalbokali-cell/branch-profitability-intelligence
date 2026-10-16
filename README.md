
# Store Margin & Performance Intelligence

### Financial Performance Analysis | Google BigQuery | SQL | Retail Analytics

An end-to-end retail financial analytics case study investigating why
gross-margin performance deteriorated despite substantial revenue and
unit-sales growth.

The project uses the Maven Analytics Mexico Toy Sales dataset to examine
company-wide performance, store profitability, product-category mix,
product-level contributions, and monthly financial trends.

The objective is to transform validated financial data into
evidence-based insights that support management decision-making.

---

## 1. Business Problem

The company achieved strong sales growth during January–September 2023
compared with the equivalent period in 2022.

However, gross profit grew more slowly than revenue, resulting in a
decline in the company's gross-margin percentage.

This raises a central business question:

> Why did gross margin deteriorate despite strong sales growth,
> and which stores, categories, products, and periods deserve
> management attention?

The analysis addresses this question through financial reconciliation,
year-over-year comparisons, and gross-margin decomposition.

---

## 2. Executive Financial Summary

**Comparison:** January 1–September 30, 2022 vs.
January 1–September 30, 2023

| Financial KPI | 2022 | 2023 | YoY change |
|---|---:|---:|---:|
| Units sold | 384,415 | 541,073 | +40.75% |
| Revenue | 5,320,115.85 | 6,962,074.27 | +30.86% |
| Cost of goods sold | 3,748,078.85 | 5,137,832.27 | +37.08% |
| Gross profit | 1,572,037.00 | 1,824,242.00 | +16.04% |
| Gross margin | 29.5489% | 26.2026% | -3.3464 pp |

### Key Finding

Revenue increased by **30.86%**, but gross profit increased by only
**16.04%**.

Gross margin declined by **3.3464 percentage points**, indicating that
the business generated less modeled gross profit per unit of revenue.

Although total gross profit increased, the company's gross-margin
percentage deteriorated.

---

## 3. Key Analytical Findings

### Finding 1 — Margin Deterioration Was Widespread Across Stores

- 49 of 50 stores experienced a lower gross-margin percentage.
- Guadalajara 1 was the only store with an improvement.
- The within-store margin component accounted for approximately
  99.28% of the net company margin decline in the store-level
  decomposition.

**Management implication:** Prioritize investigation of product-mix
and profitability changes within stores rather than focusing only
on shifts in revenue between locations.

### Finding 2 — Product Category Mix Changed Significantly

- Electronics revenue declined by 27.85%.
- Electronics revenue share fell from approximately 21.00%
  to 11.58%.
- Art & Crafts revenue increased by 251.90%.
- Art & Crafts revenue share expanded from approximately
  9.61% to 25.84%.

The category-level decomposition attributed:

- **-1.7934 pp** to within-category margin changes.
- **-1.5529 pp** to category revenue-mix changes.

Both components reconcile to the overall **-3.3464 pp** company
gross-margin change.

### Finding 3 — High-Margin Product Revenue Share Declined

Colorbuds, a product with a modeled gross margin of approximately
53.37%, experienced a substantial decline in revenue contribution.

- Revenue declined by approximately 53.08%.
- Company revenue share fell from approximately 17.51%
  to 6.28%.
- Its contribution to the product-level margin-mix
  decomposition was approximately -5.9934 pp.

Other products generated offsetting positive contributions.

The complete product-level decomposition reconciled to the
company-wide gross-margin change of -3.3464 pp.

**Management implication:** Investigate the reduction in Colorbuds
sales and determine whether assortment, availability, or customer
demand contributed to the observed change.

These potential explanations require additional evidence.

### Finding 4 — July and August Had the Largest Monthly Declines

Gross-margin percentage declined in every comparable month
from January through September.

The largest individual monthly year-over-year declines occurred in:

| Month | Gross-margin change |
|---|---:|
| July | -6.4902 pp |
| August | -5.9874 pp |
| February | -3.7016 pp |

September recorded the smallest individual monthly decline
at -0.9878 pp.

**Management implication:** Investigate product and category
revenue-mix changes during July and August.

---

## 4. Analytical Methodology

The project follows a structured analytics workflow:

**ASK → PREPARE → PROCESS → ANALYZE → SHARE → ACT**

### ASK

Define the financial business problem, stakeholders, scope,
success criteria, and analytical questions.

### PREPARE

Review the source datasets, metadata, data quality,
relationships, and reporting coverage.

### PROCESS

Create an analysis-ready CLEAN data layer in Google BigQuery.

Processing and validation included:

- Data-type standardization
- Consistent lower_snake_case naming
- Date and numeric field validation
- Key and relationship checks
- Temporal-integrity checks
- RAW-to-CLEAN row-preservation auditing

### ANALYZE

Develop and validate 12 documented SQL analyses covering:

- Financial baselines and YoY comparisons
- Financial KPI reconciliation
- Store performance and margin decomposition
- Category performance and margin decomposition
- Product performance and margin-mix contributions
- Monthly financial performance and margin trends

### SHARE

**Next phase:** Develop an executive dashboard and communicate
the validated findings through a management-focused narrative.

### ACT

Translate analytical findings into prioritized management
investigations and measurable follow-up actions.

The ACT phase will present recommendations, not claim that
operational changes have already been implemented.

---

## 5. Data Model

The analysis uses five source datasets.

| Dataset | Purpose |
|---|---|
| Sales | Transaction-level sales records |
| Products | Product attributes, categories, prices, and costs |
| Stores | Store names, cities, locations, and opening dates |
| Inventory | Stock-on-hand snapshot by store and product |
| Calendar | Date reference data |

The analysis-ready tables are maintained in the
Google BigQuery dataset:

`store-margin-intelligence.maven_toys_clean`

### Financial Calculations

**Revenue**

`SUM(units * product_price)`

**Cost of Goods Sold**

`SUM(units * product_cost)`

**Gross Profit**

`Revenue - COGS`

**Gross Margin (%)**

`Gross Profit / Revenue * 100`

**YoY Gross-Margin Change (pp)**

`Gross Margin 2023 (%) - Gross Margin 2022 (%)`

All company gross-margin percentages are calculated using
total gross profit divided by total revenue.

Monthly, store, category, or product margin percentages
are not averaged to calculate the company margin.

---

## 6. Financial Reconciliation and Analytical Controls

Financial accuracy and reproducibility are central
to this project.

The analyses include:

- Revenue, COGS, and gross-profit reconciliation
- Comparable reporting-period controls
- Store-level margin-decomposition reconciliation
- Category-level margin-decomposition reconciliation
- Product-level margin-mix reconciliation
- Monthly financial-total reconciliation

The store, category, and product decompositions each
independently reconcile to the same company-wide
gross-margin change of **-3.3464 pp**.

These are alternative analytical views of the same
financial movement.

**Their effects must not be added together.**

---

## 7. Project Repository

### Documentation

[View Project Documentation](A_docs/)

Key deliverable:

[Executive Financial Findings & Management Recommendations](A_docs/08_executive_findings_and_recommendations.md)

### SQL Analysis

[View SQL Repository](B_sql/)

- [PREPARE SQL](B_sql/01_prepare/)
- [PROCESS SQL](B_sql/02_process/)
- [ANALYZE SQL — 12 Queries](B_sql/03_analyze/)

### Supporting Evidence

[View Evidence Repository](C_evidence/)

- [PREPARE Evidence](C_evidence/01_prepare/)
- [PROCESS Evidence](C_evidence/02_process/)
- [ANALYZE Evidence](C_evidence/03_analyze/)

Selected ANALYZE evidence:

1. [Financial Reconciliation](C_evidence/03_analyze/01_financial_reconciliation.png)
2. [Gross-Margin Decomposition](C_evidence/03_analyze/02_margin_decomposition.png)
3. [Monthly Margin Trends](C_evidence/03_analyze/03_monthly_margin_trends.png)

The evidence images supplement the documented SQL queries.
They do not replace reproducible analysis.

---

## 8. Tools and Technologies

### Used in the Completed Analytical Workflow

**Google BigQuery**
- Data storage and analytical queries
- RAW and CLEAN data layers
- Financial aggregation and reconciliation

**SQL**
- Common table expressions
- Joins and aggregations
- Conditional calculations
- Window functions
- Financial KPI calculations
- Margin-mix decomposition

**GitHub**
- Version-controlled SQL
- Project documentation
- Supporting analytical evidence

### Planned for the SHARE Stage

**Business Intelligence Dashboard**
- Executive KPI reporting
- Financial trend visualization
- Store and product performance analysis
- Interactive financial exploration

The dashboard tool and final reporting artifacts will be
documented when implemented.

---

## 9. Data Limitations and Interpretation

This project uses a public retail dataset and modeled
financial measures.

Important limitations include:

- Product prices and costs are static master-data attributes.
- Historical transaction-level prices and costs are unavailable.
- Supplier cost inflation cannot be verified.
- Historical product stockouts cannot be inferred from
  the inventory snapshot.
- Gross-margin decomposition is mathematical attribution,
  not proof of operational causation.
- Two partial-year comparison periods do not establish
  reliable recurring seasonality.
- Operating expenses, financing costs, and net income
  are outside the analysis scope.

All management recommendations are framed as
evidence-based investigative priorities.

---

## 10. Management Recommendations

Based on the validated analysis, management should prioritize:

1. Investigating the substantial reduction in Colorbuds
   revenue and company revenue share.
2. Reviewing the contraction in Electronics and changes
   in product-category revenue composition.
3. Examining stores with the largest negative
   revenue-weighted margin contributions.
4. Investigating July and August product-mix changes.
5. Establishing a recurring gross-margin monitoring
   framework through an executive dashboard.

For supporting calculations and detailed interpretation,
see the
[Executive Findings Report](A_docs/08_executive_findings_and_recommendations.md).

---

## 11. Project Status

| Stage | Status |
|---|---|
| ASK | Completed |
| PREPARE | Completed |
| PROCESS | Completed |
| ANALYZE | Completed — 12 validated SQL analyses |
| SHARE | Next — Executive dashboard development |
| ACT | Recommendations documented; implementation not evaluated |

### Next Milestone

Develop a professional executive financial dashboard
that communicates the company's financial performance,
gross-margin deterioration, product-mix changes,
and management priorities.

---

## 12. Project Purpose

This project demonstrates practical capabilities in:

- Financial data analysis
- Business problem solving
- SQL development
- Data preparation and validation
- Financial reconciliation
- Gross-margin decomposition
- Analytical interpretation
- Executive communication
- Reproducible portfolio documentation

The intended audience includes financial analysts,
business analysts, finance managers, and senior
management stakeholders.

**Project:** Store Margin & Performance Intelligence

**Data source:** Maven Analytics — Mexico Toy Sales

**Current phase:** SHARE — Executive Dashboard Development
