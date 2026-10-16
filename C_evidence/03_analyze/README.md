
# ANALYZE — Financial Analysis Evidence

## 1. Purpose

This folder contains selected supporting evidence for the
ANALYZE stage of the Store Margin & Performance Intelligence
portfolio project.

The evidence supports the findings documented in:

[Executive Financial Findings & Management Recommendations](../../A_docs/08_executive_findings_and_recommendations.md)

The underlying SQL is maintained in:

[ANALYZE SQL Queries](../../B_sql/03_analyze/)

The objective is to make the analysis transparent, reproducible,
and easy for reviewers to verify.

---

## 2. Reporting Scope

**Comparison periods:**
- January 1–September 30, 2022
- January 1–September 30, 2023

**Data source:** Maven Analytics Mexico Toy Sales

**Platform:** Google BigQuery

**Financial definitions:**
- Revenue = Units sold × Product price
- COGS = Units sold × Product cost
- Gross profit = Revenue − COGS
- Gross margin (%) = Gross profit / Revenue × 100

Financial measures are modeled using static product master
prices and costs rather than transaction-level historical
prices and costs.

---

## 3. Evidence Register

The following evidence files are planned.

| ID | Evidence filename | Related SQL | Verification objective |
|---|---|---|---|
| A01 | `01_company_financial_baseline.png` | 01–03 | Confirm 2022 and 2023 financial KPIs |
| A02 | `02_financial_reconciliation.png` | 03 | Confirm financial reconciliation status |
| A03 | `03_store_margin_decomposition.png` | 06 | Verify within-store and store-mix effects |
| A04 | `04_category_margin_decomposition.png` | 08 | Verify within-category and category-mix effects |
| A05 | `05_product_margin_mix_decomposition.png` | 11 | Verify product-mix contributions and company reconciliation |
| A06 | `06_monthly_margin_trends.png` | 12 | Verify monthly YoY margin changes and financial totals |

**Evidence status:** Planned. Filenames in this register do
not indicate that screenshots have already been uploaded.

Additional screenshots should be included only when they
demonstrate a material finding or validation control not
already covered by the existing evidence.

---

## 4. Financial Reconciliation Targets

The following figures were validated during the ANALYZE stage.

| Metric | Jan–Sep 2022 | Jan–Sep 2023 |
|---|---:|---:|
| Units sold | 384,415 | 541,073 |
| Revenue | 5,320,115.85 | 6,962,074.27 |
| COGS | 3,748,078.85 | 5,137,832.27 |
| Gross profit | 1,572,037.00 | 1,824,242.00 |
| Gross margin | 29.5489% | 26.2026% |

**Company gross-margin change: −3.3464 percentage points.**

Screenshots should display enough information to verify
the relevant financial totals and reconciliation results.

---

## 5. Margin Decomposition Controls

### Store-level decomposition

| Component | Effect |
|---|---:|
| Within-store margin | −3.3224 pp |
| Between-store revenue mix | −0.0240 pp |
| Total change | −3.3464 pp |

### Category-level decomposition

| Component | Effect |
|---|---:|
| Within-category margin | −1.7934 pp |
| Between-category revenue mix | −1.5529 pp |
| Total change | −3.3464 pp |

### Product-level decomposition

The product-level revenue-mix decomposition reconciles
to the same company gross-margin change of −3.3464 pp.

Store, category, and product decompositions are
alternative explanations of the same financial movement.

**They must not be added together.**

---

## 6. Evidence Capture Standards

Each screenshot should:

1. Show the relevant BigQuery results clearly.
2. Include the important metric names and values.
3. Preserve the reconciliation status when applicable.
4. Avoid unnecessary browser or interface clutter.
5. Use the exact filename specified in the evidence register.
6. Correspond to the SQL query referenced in the register.
7. Remain legible when viewed directly on GitHub.

Screenshots are supporting evidence, not substitutes
for reproducible SQL.

Where a result is too wide or contains too many rows
to capture legibly, a CSV export may be more appropriate.
Any such export should be documented in this register.

---

## 7. Evidence Review Procedure

For each evidence file:

1. Open the related SQL query in `B_sql/03_analyze/`.
2. Review its business question and calculation logic.
3. Execute the query against the documented BigQuery dataset.
4. Compare the output with the evidence file.
5. Verify the financial totals and reconciliation controls.
6. Confirm that the executive report accurately reflects
   the supported results.

---

## 8. Analytical Limitations

- Product prices and costs are static source attributes.
- Historical selling-price changes cannot be established.
- Supplier cost inflation cannot be established.
- The inventory table is a stock-on-hand snapshot.
- Historical stockouts cannot be inferred from that snapshot.
- Margin attribution does not prove operational causation.
- Nine months across two years do not establish reliable
  recurring seasonality.
- Gross profit is not operating profit or net income.

These limitations should remain visible when presenting
the findings to management or portfolio reviewers.

---

## 9. Project Documentation

- [Executive Findings](../../A_docs/08_executive_findings_and_recommendations.md)
- [ANALYZE SQL Folder](../../B_sql/03_analyze/)
- [PREPARE Evidence](../01_prepare/)
- [PROCESS Evidence](../02_process/)

---

**Stage:** ANALYZE

**Evidence register status:** Created; evidence collection pending.

**Next stage:** SHARE — Executive Dashboard and
Portfolio Presentation.
