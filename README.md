
# Store Margin & Performance Intelligence

**Financial Data Analytics Portfolio | Google BigQuery · SQL · Tableau Public · GitHub**

An end-to-end retail financial analytics case study examining **why modeled gross margin declined despite strong revenue and unit-sales growth**.

Using the Maven Analytics Mexico Toy Sales dataset, this project moves from data preparation and financial reconciliation to store, product, category, and monthly analysis, concluding with three interactive executive dashboards and evidence-based management recommendations.

### [Explore the Interactive Tableau Dashboards](https://public.tableau.com/views/StoreMarginPerformanceIntelligence/ExecutiveDashboardFinancialPerformance)

**Reporting Period:** January–September 2022 vs. January–September 2023  
**Business Scope:** 50 stores across Mexico  
**Tools:** Google BigQuery, SQL, Tableau Public, GitHub  
**Project Status:** Completed analytical and visualization stages

> **Financial interpretation:** Revenue, COGS, and gross profit are modeled using static product-master prices and costs. They do not represent independently verified historical accounting transactions.

---

## 1. Business Problem

Strong sales growth does not necessarily translate into improved profitability.

Between January–September 2022 and the equivalent period in 2023, the company experienced significant revenue growth. However, modeled cost of goods sold increased faster than revenue, resulting in deterioration of the company's overall gross-margin percentage.

### Central Business Question

> Why did gross margin deteriorate despite strong revenue growth, and which stores, product categories, individual products, and reporting periods deserve management attention?

The project addresses this question through:

- Financial KPI reconciliation
- Year-over-year performance comparisons
- Store-level profitability analysis
- Category-level margin decomposition
- Product-level margin-mix contributions
- Monthly financial trend analysis
- Modeled store financial-impact measurement
- Interactive executive reporting

The ultimate objective is to transform financial data into actionable business intelligence.

---

## 2. Executive Financial Summary

**Comparable Reporting Periods:**

- January 1–September 30, 2022
- January 1–September 30, 2023

| Financial KPI | 2022 | 2023 | YoY Change |
|---|---:|---:|---:|
| Units Sold | 384,415 | 541,073 | +40.75% |
| Modeled Revenue | $5,320,115.85 | $6,962,074.27 | **+30.86%** |
| Modeled COGS | $3,748,078.85 | $5,137,832.27 | **+37.08%** |
| Modeled Gross Profit | $1,572,037.00 | $1,824,242.00 | **+16.04%** |
| Modeled Gross Margin | 29.5489% | 26.2026% | **−3.3464 pp** |

### Executive Interpretation

Revenue increased by **30.86%**, but modeled gross profit increased by only **16.04%**.

The primary financial observation is that modeled COGS grew faster than revenue, resulting in a decline of **3.3464 percentage points** in the company-wide gross-margin rate.

This does not mean total gross profit declined. Rather, the company generated less modeled gross profit per dollar of revenue in 2023 than in 2022.

**Management concern:** Sales expansion was not accompanied by proportional growth in modeled gross profitability.

---

## 3. Interactive Tableau Dashboards

The completed analytical results are presented through three interconnected Tableau dashboards designed to support executive financial decision-making.

### [Launch the Complete Interactive Dashboard](https://public.tableau.com/views/StoreMarginPerformanceIntelligence/ExecutiveDashboardFinancialPerformance)

### 01 — Executive Financial Overview

**Purpose:** Communicate overall financial performance and identify the principal drivers of gross-margin deterioration.

**Key Features:**

- Revenue Growth YoY
- Gross Profit Growth YoY
- COGS Growth YoY
- Gross Margin Change
- Revenue comparison: 2022 vs. 2023
- Gross-margin comparison: 2022 vs. 2023
- Product-category gross-margin contributions
- Executive analytical findings

**Business Value:**

Allows management to understand why substantial revenue growth did not generate equivalent growth in modeled gross profit.

### 02 — Monthly Financial Performance

**Purpose:** Identify how revenue and gross-margin performance changed across the comparable reporting months.

**Key Features:**

- Monthly revenue trends
- Monthly gross-margin comparisons
- January–September 2022 vs. 2023
- Interactive month filtering
- Executive analytical commentary
- Identification of the largest monthly margin declines

**Business Value:**

Helps management identify reporting periods that require deeper investigation.

### 03 — Store Profitability Intelligence

**Purpose:** Identify location-level performance drivers and prioritize stores based on their modeled financial margin impact.

**Key Features:**

- Revenue Growth Drivers by Store Location
- Gross Profit Growth Contribution by Location
- Top 10 Stores with the Largest Negative Modeled Financial Margin Impact
- Gross Margin Evolution by Store Location
- Interactive highlighting and financial tooltips

**Business Value:**

Supports financial prioritization by identifying stores where modeled margin deterioration had the greatest monetary impact relative to a historical-margin benchmark.

### Dashboard Interactivity

The published Tableau workbook provides:

- Navigation between all three dashboards
- Interactive financial tooltips
- Month-based filtering
- Location-level highlighting
- Executive analytical commentary
- Consistent financial performance measures

**[View the Published Tableau Project](https://public.tableau.com/views/StoreMarginPerformanceIntelligence/ExecutiveDashboardFinancialPerformance)**

---

## 4. Key Analytical Findings

### Finding 1 — Gross-Margin Deterioration Was Widespread Across Stores

The store-level analysis identified broad deterioration in modeled gross-margin performance.

**Key Results:**

- **49 of 50 stores** experienced a lower gross-margin percentage.
- **Guadalajara 1** was the only store recording an improvement.
- The within-store margin component accounted for approximately **99.28%** of the net company margin decline under the project's store-level decomposition method.

This indicates that changes in modeled margin rates within stores deserve more attention than changes in revenue distribution between stores alone.

**Management Implication:**

Investigate product assortment, category composition, pricing information, and cost structures within affected stores.

The decomposition identifies mathematical contributions; it does not independently establish the operational cause of deterioration.

### Finding 2 — Product-Category Composition Changed Significantly

The analysis identified major changes in modeled revenue distribution across product categories.

**Electronics:**

- Revenue declined approximately **27.85%**.
- Revenue share decreased from approximately **21.00% to 11.58%**.

**Art & Crafts:**

- Revenue increased approximately **251.90%**.
- Revenue share increased from approximately **9.61% to 25.84%**.

#### Category Margin Decomposition

The overall company margin decline was decomposed into two components:

| Component | Contribution |
|---|---:|
| Within-Category Margin Changes | −1.7934 pp |
| Category Revenue-Mix Changes | −1.5529 pp |
| **Total Gross-Margin Change** | **−3.3464 pp** |

#### Contribution by Product Category

| Product Category | Total Contribution |
|---|---:|
| Electronics | **−5.4019 pp** |
| Toys | −1.5746 pp |
| Games | −0.6750 pp |
| Sports & Outdoors | +0.1240 pp |
| Art & Crafts | **+4.1812 pp** |

*The displayed category values are rounded. Small reconciliation differences may arise when summing individually rounded contributions.*

**Interpretation:**

Electronics was the largest negative contributor under the selected decomposition methodology.

Art & Crafts recorded the largest positive contribution, partially offsetting negative contributions elsewhere.

These are mathematical contributions to the overall margin movement, not proof of specific operational causes.

**Management Implication:**

Investigate changes in category revenue shares, category-level modeled margins, and product composition before deciding on corrective actions.

### Finding 3 — Modeled Store Margin Impact Reached −$231,306.41

The project developed a financial-impact measure to prioritize stores experiencing gross-margin deterioration.

**Combined Modeled Store Margin Impact:**

### **−$231,306.41**

This calculation compares each store's actual modeled 2023 gross margin with the modeled gross profit it would have generated if it had maintained its 2022 gross-margin percentage on its 2023 revenue.

#### Calculation

```text
Modeled Store Margin Impact (USD)

= 2023 Store Revenue
  × (2023 Store Gross Margin − 2022 Store Gross Margin)
```

The margin rates are expressed as decimal values.

#### Selected High-Impact Stores

| Store | Modeled Financial Margin Impact |
|---|---:|
| Maven Toys Ciudad de Mexico 2 | −$14,538.43 |
| Maven Toys Ciudad Victoria 1 | −$14,176.75 |
| Maven Toys Mexicali 1 | −$11,640.01 |
| Maven Toys Guadalajara 3 | −$11,530.40 |
| Maven Toys Monterrey 2 | −$11,247.07 |

**Important Interpretation:**

The value of **−$231,306.41** represents a modeled benchmark shortfall relative to maintaining prior-year store gross-margin rates.

It is **not** an actual realized cash loss, an audited financial loss, or a guaranteed recoverable amount.

**Management Implication:**

Prioritize investigation of stores exhibiting the largest absolute negative modeled margin impact, while considering sales volumes, category mix, and operational evidence.

### Finding 4 — High-Margin Product Revenue Share Declined

The product-level analysis identified an important change involving **Colorbuds**, a product with an approximately **53.37% modeled gross margin**.

**Key Results:**

- Modeled revenue declined approximately **53.08%**.
- Company revenue share decreased from approximately **17.51% to 6.28%**.
- Product-level margin-mix contribution was approximately **−5.9934 pp**.

Other products generated offsetting positive contributions.

The complete product-level decomposition reconciled to the company's total gross-margin change of **−3.3464 pp**.

The Colorbuds contribution belongs to the product-level decomposition and must not be added to category-level or store-level contributions.

**Management Implication:**

Investigate changes in product demand, assortment, inventory availability, and competitive positioning.

These potential explanations require additional supporting evidence.

### Finding 5 — Gross Margin Declined Across All Nine Months

Monthly analysis showed that modeled gross-margin percentages declined during every comparable month from January through September.

#### Largest Monthly Declines

| Month | Gross-Margin YoY Change |
|---|---:|
| July | **−6.4902 pp** |
| August | **−5.9874 pp** |
| February | −3.7016 pp |

September recorded the smallest decline at approximately **−0.9878 pp**.

**Management Implication:**

Investigate the category and product composition of sales during July and August, when margin deterioration was most pronounced.

Two comparable partial-year periods are insufficient to establish recurring seasonality.

---

## 5. Analytical Methodology

The project follows the Google Data Analytics analytical process:

**ASK → PREPARE → PROCESS → ANALYZE → SHARE → ACT**

### ASK — Define the Business Problem

Established the central financial question, stakeholders, reporting scope, success criteria, and analytical objectives.

**Focus:**

Understand the relationship between revenue growth, modeled cost growth, gross-profit performance, and declining gross-margin percentages.

### PREPARE — Understand the Data

Reviewed the source datasets and assessed their suitability for the business problem.

Activities included:

- Dataset structure review
- Metadata inspection
- Primary and foreign key identification
- Date coverage validation
- Source relationship analysis
- Data-quality assessment

### PROCESS — Prepare and Validate Data

Created the analysis-ready CLEAN layer in Google BigQuery.

Processing included:

- Standardizing data types
- Applying consistent `lower_snake_case` naming
- Validating dates and numeric fields
- Checking primary and foreign key relationships
- Testing temporal integrity
- Auditing RAW-to-CLEAN row preservation
- Preparing consistent analytical datasets

### ANALYZE — Financial Investigation

Developed and validated **12 SQL analyses** covering:

- Financial baselines
- Year-over-year comparisons
- Financial KPI reconciliation
- Store profitability analysis
- Store-level margin decomposition
- Category profitability analysis
- Category-level margin decomposition
- Product-level margin-mix contributions
- Monthly performance trends

The analyses were designed to reconcile financial calculations and identify contributions to the modeled company-wide margin change.

### SHARE — Executive Business Intelligence

**Status: Completed**

Developed and published three interactive Tableau dashboards:

1. Executive Financial Overview
2. Monthly Financial Performance
3. Store Profitability Intelligence

The dashboards communicate the validated financial findings through executive KPIs, interactive visualizations, financial-impact comparisons, and management-focused insights.

**[Explore the Tableau Dashboards](https://public.tableau.com/views/StoreMarginPerformanceIntelligence/ExecutiveDashboardFinancialPerformance)**

The Tableau workbook uses locally prepared CSV extracts derived from the analytical work rather than a live BigQuery connection.

### ACT — Management Recommendations

Translated the analytical findings into prioritized management investigations and monitoring recommendations.

The ACT stage documents recommended actions.

It does not claim that operational changes were implemented or that financial improvements have already been achieved.

---

## 6. Data Model and Financial Calculations

### Source Datasets

The project uses five source datasets.

| Dataset | Purpose |
|---|---|
| Sales | Transaction-level sales records |
| Products | Product attributes, categories, prices, and costs |
| Stores | Store names, cities, locations, and opening dates |
| Inventory | Stock-on-hand snapshot by store and product |
| Calendar | Date reference information |

### BigQuery Analytical Dataset

`store-margin-intelligence.maven_toys_clean`

### Core Financial Calculations

**Modeled Revenue**

```sql
SUM(units * product_price)
```

**Modeled Cost of Goods Sold**

```sql
SUM(units * product_cost)
```

**Modeled Gross Profit**

```text
Revenue − COGS
```

**Gross Margin (%)**

```text
Gross Profit / Revenue × 100
```

**Year-over-Year Gross-Margin Change**

```text
Gross Margin 2023 (%) − Gross Margin 2022 (%)
```

**Modeled Store Margin Impact**

```text
2023 Store Revenue
× (2023 Store Margin Rate − 2022 Store Margin Rate)
```

For the store-impact calculation, margin rates are decimal values, not percentage numbers.

### Financial Calculation Principle

Company-wide gross margin is calculated using:

```text
Total Gross Profit / Total Revenue
```

It is not calculated by taking the simple average of store, category, product, or monthly gross-margin percentages.

This ensures that the company-wide result correctly reflects revenue weighting.

---

## 7. Financial Reconciliation and Analytical Controls

Financial accuracy, reconciliation, and reproducibility are central to this project.

The SQL analyses include:

- Revenue, COGS, and gross-profit reconciliation
- Comparable reporting-period validation
- RAW-to-CLEAN data preservation checks
- Primary and foreign key validation
- Store-level margin decomposition
- Category-level margin decomposition
- Product-level margin-mix reconciliation
- Monthly financial-total reconciliation
- Store-level benchmark impact calculations

### Reconciliation Principle

The store, category, and product decompositions independently explain the same company-wide gross-margin movement of approximately **−3.3464 percentage points**.

These are alternative analytical perspectives.

**They must not be added together.**

The modeled store margin impact of **−$231,306.41** is a separate dollar-denominated benchmark comparison, not another percentage-point decomposition.

---

## 8. Repository Structure and Supporting Evidence

The repository documents the analytical workflow, SQL development, methodology, and financial findings.

### Project Documentation

[View Project Documentation](A_docs/)

Key deliverable:

[Executive Financial Findings & Management Recommendations](A_docs/08_executive_findings_and_recommendations.md)

### SQL Analysis

[View SQL Repository](B_sql/)

- [PREPARE SQL](B_sql/01_prepare/)
- [PROCESS SQL](B_sql/02_process/)
- [ANALYZE SQL — 12 Queries](B_sql/03_analyze/)

The SQL files document the analytical logic supporting the final business findings.

### Supporting Evidence

[View Evidence Repository](C_evidence/)

- [PREPARE Evidence](C_evidence/01_prepare/)
- [PROCESS Evidence](C_evidence/02_process/)
- [ANALYZE Evidence](C_evidence/03_analyze/)

Selected ANALYZE evidence:

1. [Financial Reconciliation](C_evidence/03_analyze/01_financial_reconciliation.png)
2. [Gross-Margin Decomposition](C_evidence/03_analyze/02_margin_decomposition.png)
3. [Monthly Margin Trends](C_evidence/03_analyze/03_monthly_margin_trends.png)

### Tableau Dashboard Evidence

The final dashboards can be documented using the following image structure:

```text
C_evidence/
    04_tableau_dashboards/
        01_executive_overview.png
        02_monthly_performance.png
        03_store_profitability.png
```

These screenshot files are intended to be added as supporting visual evidence.

The live Tableau Public workbook remains the primary interactive reporting deliverable.

---

## 9. Tools and Technologies

| Technology | Application |
|---|---|
| Google BigQuery | Data storage, analytical queries, RAW and CLEAN layers, financial reconciliation |
| SQL | Joins, CTEs, aggregations, conditional logic, window functions, KPI calculations, and margin decomposition |
| Tableau Public Desktop | Development of three interactive executive financial dashboards using prepared CSV extracts |
| Tableau Public | Publication and interactive sharing of the completed dashboards |
| GitHub | Version-controlled SQL, analytical documentation, supporting evidence, and professional portfolio presentation |

### Technical Capabilities Demonstrated

- Relational data analysis
- SQL query development
- Financial modeling
- Data preparation and quality assurance
- Financial KPI reconciliation
- Revenue-weighted calculations
- Gross-margin decomposition
- Financial-impact analysis
- Interactive data visualization
- Executive business reporting
- Evidence-based recommendations

---

## 10. Data Limitations and Interpretation

This project uses a public retail dataset and modeled financial measures rather than independently audited financial statements.

Important limitations include:

1. Product prices and costs are static master-data attributes.
2. Historical transaction-level selling prices and acquisition costs are unavailable.
3. Revenue, COGS, gross profit, and gross margins are modeled financial measures.
4. Actual supplier cost inflation and historical price changes cannot be verified.
5. Historical product stockouts cannot be inferred from a single inventory snapshot.
6. Gross-margin decomposition is mathematical attribution, not proof of operational causation.
7. Two comparable partial-year reporting periods are insufficient to establish recurring seasonality.
8. The modeled store margin impact is a counterfactual benchmark shortfall, not an actual realized loss.
9. Operating expenses, financing costs, taxes, and net income are outside the analysis scope.
10. Tableau dashboards use prepared analytical extracts rather than continuously refreshed live financial systems.

These limitations are considered when interpreting findings and recommending management actions.

All recommendations represent evidence-based priorities for further investigation.

---

## 11. Management Recommendations

Based on the analytical findings, management should prioritize the following actions.

### Recommendation 1 — Investigate Category Composition

Review the contraction in Electronics revenue share and the expansion of Art & Crafts.

Examine changes in category-level margins, sales composition, and individual product contributions.

### Recommendation 2 — Prioritize High-Impact Stores

Investigate stores showing the largest negative modeled financial margin impacts.

Use store-level analysis to identify the product and category changes contributing to each result.

### Recommendation 3 — Examine Colorbuds Performance

Review the substantial reduction in Colorbuds revenue and company revenue share.

Investigate potential changes in demand, assortment, pricing, and product availability using additional evidence.

### Recommendation 4 — Investigate July and August

Examine the financial and product-mix movements associated with the two largest monthly margin declines.

Identify whether these changes were concentrated in specific categories, products, or stores.

### Recommendation 5 — Establish Ongoing Financial Monitoring

Use the developed Tableau dashboards as a prototype for a recurring executive financial monitoring framework.

For production use, integrate current transaction-level pricing, cost, inventory, and operating data.

Detailed recommendations are available in the:

[Executive Financial Findings & Management Recommendations Report](A_docs/08_executive_findings_and_recommendations.md)

---

## 12. Project Status

| Analytical Stage | Status |
|---|---|
| ASK | Completed |
| PREPARE | Completed |
| PROCESS | Completed |
| ANALYZE | Completed — 12 validated SQL analyses |
| SHARE | **Completed — 3 interactive dashboards published on Tableau Public** |
| ACT | Recommendations documented; implementation and real-world outcomes not evaluated |

### Completed Deliverables

- Business problem definition
- Source-data review
- Analysis-ready BigQuery data preparation
- Financial KPI reconciliation
- Twelve documented SQL analyses
- Store, category, and product profitability analysis
- Monthly financial performance analysis
- Modeled store financial-impact evaluation
- Three interactive Tableau dashboards
- Executive financial findings
- Evidence-based management recommendations

**Portfolio Status:** Analytical and visualization deliverables completed. GitHub evidence organization and documentation alignment remain subject to final review.

---

## 13. Project Purpose

This project demonstrates practical capabilities in:

- Financial data analysis
- Business problem solving
- SQL development
- Data preparation and validation
- Financial reconciliation
- Gross-margin decomposition
- Financial-impact modeling
- Tableau dashboard development
- Analytical interpretation
- Executive communication
- Evidence-based management recommendations
- Reproducible portfolio documentation

The intended audience includes:

- Financial Data Analysts
- Business Analysts
- Finance Managers
- Financial Planning and Analysis Professionals
- Senior Management Stakeholders

---

### Project Information

**Project Name:** Store Margin & Performance Intelligence

**Dataset:** Maven Analytics — Mexico Toy Sales

**Reporting Period:** January–September 2022 vs. January–September 2023

**Primary Technologies:** Google BigQuery, SQL, Tableau Public, GitHub

**GitHub Repository:** [branch-profitability-intelligence](https://github.com/salmanalbokali-cell/branch-profitability-intelligence)

**Interactive Tableau Portfolio:** [View the Three Executive Dashboards](https://public.tableau.com/views/StoreMarginPerformanceIntelligence/ExecutiveDashboardFinancialPerformance)

**Project Status:** Completed analytical and Tableau reporting stages

---

*This project is an independent educational and professional portfolio case study using publicly available retail data. Financial results are modeled for analytical purposes and should not be interpreted as audited accounting figures.*
