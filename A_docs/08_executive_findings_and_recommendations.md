# Store Margin & Performance Intelligence
## Executive Financial Findings & Management Recommendations

**Audience:** CFO and Senior Management  
**Project phase:** ANALYZE — Executive Synthesis  
**Reporting period:** January 1–September 30, 2022 vs. January 1–September 30, 2023  
**Source:** Maven Analytics Mexico Toy Sales dataset  
**Analytical platform:** Google BigQuery  
**Supporting evidence:** `B_sql/03_analyze/01` through `12`  
**Financial basis:** Modeled revenue and cost of goods sold using the product master data

---

## 1. Executive Summary

The business achieved strong sales growth during the first nine months of 2023 compared with the equivalent period in 2022. However, this growth did not translate into proportional gross-profit growth.

Revenue increased by **30.86%**, while gross profit increased by only **16.04%**. Gross margin declined from **29.5489% to 26.2026%**, representing a deterioration of **3.3464 percentage points**.

The analysis identifies three important patterns:

1. **Broad store-level deterioration:** 49 of 50 stores experienced a lower gross-margin percentage.
2. **Significant product-mix changes:** Revenue shifted among products with substantially different modeled gross-margin rates, including a major reduction in the revenue share of high-margin Colorbuds.
3. **Persistent monthly deterioration:** Every comparable month recorded a lower gross margin in 2023, with the largest individual monthly declines occurring in July and August.

The findings suggest that management should prioritize understanding changes in product sales composition, identifying stores with the largest revenue-weighted margin impact, and investigating the particularly weak July–August comparisons.

These are evidence-based priorities for further investigation, not proof of underlying operational causes.

---

## 2. Financial Performance Overview

| Financial KPI | Jan–Sep 2022 | Jan–Sep 2023 | YoY change |
|---|---:|---:|---:|
| Units sold | 384,415 | 541,073 | +40.75% |
| Revenue | 5,320,115.85 | 6,962,074.27 | +30.86% |
| Cost of goods sold | 3,748,078.85 | 5,137,832.27 | +37.08% |
| Gross profit | 1,572,037.00 | 1,824,242.00 | +16.04% |
| Gross margin | 29.5489% | 26.2026% | −3.3464 pp |

### Management Interpretation

The company sold substantially more units and generated higher total gross profit in 2023. Nevertheless, modeled COGS grew faster than revenue, reducing the proportion of sales retained as gross profit.

This creates an important distinction:

**The business became larger in revenue and absolute gross profit, but less efficient in gross-profit generation per unit of revenue.**

A decline in gross-margin percentage does not mean the company generated less total gross profit. Both measures must be presented together.

---

## 3. Store-Level Performance

### 3.1 Geographic and Store-Level Breadth

Among the 50 stores analyzed:

- **49 stores** recorded a YoY gross-margin decline.
- **1 store**, Guadalajara 1, recorded a modest improvement of approximately **0.41 percentage points**.

The widespread nature of the deterioration indicates that the issue was not confined to a small number of underperforming locations.

### 3.2 Largest Store Margin-Rate Declines

| Store | YoY gross-margin change |
|---|---:|
| Ciudad Victoria 1 | −9.32 pp |
| Mexicali 1 | −8.93 pp |
| Campeche 1 | −6.27 pp |
| Villahermosa 1 | −6.05 pp |
| Campeche 2 | −6.04 pp |

These stores experienced the largest percentage-point reductions in their individual gross-margin rates.

### 3.3 Largest Negative Store Contributions to Company Margin

| Store | Contribution to company GM change |
|---|---:|
| Ciudad de Mexico 2 | −0.2848 pp |
| Mexicali 1 | −0.2512 pp |
| Guadalajara 4 | −0.2480 pp |
| Monterrey 1 | −0.2400 pp |
| Guadalajara 2 | −0.1811 pp |

These contribution figures are different from store-level margin-rate changes because they incorporate each store's revenue weighting.

A store with a smaller individual margin decline may have a greater impact on company results if it accounts for a larger proportion of revenue.

### 3.4 Store-Level Margin Decomposition

| Component | Effect on company GM |
|---|---:|
| Within-store margin effect | −3.3224 pp |
| Between-store revenue-mix effect | −0.0240 pp |
| Total company GM change | −3.3464 pp |

Approximately **99.28%** of the net decline is attributable to the within-store margin component, with approximately **0.72%** attributable to the between-store revenue-mix component.

**Management implication:** Investigations should focus primarily on what changed within stores, rather than assuming that the company-level decline resulted mainly from sales shifting between store locations.

This decomposition is an accounting attribution, not a causal explanation of store operating conditions.

---

## 4. Product Category Performance

The analysis covers five product categories:

- Electronics
- Games
- Art & Crafts
- Toys
- Sports & Outdoors

### 4.1 Major Category Developments

**Electronics**

Electronics revenue declined by **27.85%**, and its share of company revenue fell from approximately **21.00% to 11.58%**.

Its modeled gross margin also declined from approximately **48.08% to 40.56%**.

Because Electronics remained a relatively high-margin category, its reduced revenue share is an important part of the overall margin-mix investigation.

**Art & Crafts**

Art & Crafts revenue increased by **251.90%**, and its company revenue share expanded from approximately **9.61% to 25.84%**.

Its modeled gross margin declined from approximately **28.30% to 26.71%**.

The rapid expansion of this category materially changed the company's sales composition.

**Sports & Outdoors**

Sports & Outdoors was the only category to record a positive YoY gross-margin-rate change, improving by approximately **1.83 percentage points**.

This warrants investigation into the products and sales mix associated with the improvement.

### 4.2 Category-Level Margin Decomposition

| Component | Effect on company GM |
|---|---:|
| Within-category margin effect | −1.7934 pp |
| Between-category revenue-mix effect | −1.5529 pp |
| Total company GM change | −3.3464 pp |

Approximately **53.59%** of the net decline is attributed to changes in margins within categories, while approximately **46.41%** is attributed to shifts in revenue share between categories.

The category-level results reveal a more substantial mix effect than the store-level decomposition.

### 4.3 Category Contributions

| Category | Within-category effect | Revenue-mix effect | Total effect |
|---|---:|---:|---:|
| Electronics | −0.8711 pp | −4.5308 pp | −5.4019 pp |
| Toys | −0.5115 pp | −1.0631 pp | −1.5746 pp |
| Games | −0.2767 pp | −0.3983 pp | −0.6750 pp |
| Sports & Outdoors | +0.2775 pp | −0.1535 pp | +0.1240 pp |
| Art & Crafts | −0.4116 pp | +4.5928 pp | +4.1812 pp |

These figures use a defined margin-decomposition method and are additive within the category dimension.

**Interpretation caution:** A positive mix contribution for Art & Crafts does not establish that shifting sales toward Art & Crafts improved company margin relative to alternative products or categories. Its positive contribution must be interpreted alongside the offsetting changes elsewhere in the portfolio.

---

## 5. Product-Level Financial Findings

The product analysis covers **35 products**.

Of these, **32 products** recorded sales in both comparison periods, while **three products** had no recorded sales in January–September 2022:

- Etch A Sketch
- Foam Disk Launcher
- Playfoam

The absence of 2022 sales does not establish when these products were launched.

### 5.1 Product-Mix Decomposition

The validated product-level analysis reconciles the full company gross-margin change of **−3.3464 percentage points**.

Product-level modeled margin rates remain unchanged across the two periods because the source product master contains one price and one cost per product rather than transaction-level historical prices and costs.

Consequently, the product-level gross-margin movement is explained by changes in the distribution of revenue across products with different modeled margins.

### 5.2 Largest Negative Product Contributions

| Product | Contribution to company GM change |
|---|---:|
| Colorbuds | −5.9934 pp |
| Action Figure | −1.5234 pp |
| Kids Makeup Kit | −0.7229 pp |
| Dart Gun | −0.6237 pp |
| Deck Of Cards | −0.4036 pp |

**Colorbuds is a particularly important investigation priority.**

Its modeled gross margin is approximately **53.37%**, while its revenue share declined from approximately **17.51% to 6.28%**.

Colorbuds revenue declined by approximately **53.08%**.

This large reduction in the revenue contribution of a relatively high-margin product was a major negative component of the company's product-mix movement.

### 5.3 Largest Positive Product Contributions

| Product | Contribution to company GM change |
|---|---:|
| Barrel O' Slime | +1.5586 pp |
| Magic Sand | +1.5527 pp |
| Etch A Sketch | +1.3828 pp |
| Gamer Headphones | +0.7459 pp |
| Nerf Gun | +0.6040 pp |

**Magic Sand requires careful interpretation.**

Its revenue share increased sharply, from approximately **0.07% to 12.48%**, but its modeled gross-margin rate is only approximately **12.51%**.

Its positive contribution in the selected additive decomposition does **not** mean that expanding Magic Sand sales improved the company's overall margin relative to other products.

Management should examine both product growth and relative profitability when making assortment decisions.

---

## 6. Monthly Financial Performance

The monthly comparison covers January through September in both 2022 and 2023.

### 6.1 Monthly Gross-Margin Changes

| Month | GM 2022 | GM 2023 | YoY change |
|---|---:|---:|---:|
| January | 30.80% | 27.45% | −3.3577 pp |
| February | 29.90% | 26.20% | −3.7016 pp |
| March | 29.52% | 26.25% | −3.2675 pp |
| April | 27.91% | 25.99% | −1.9242 pp |
| May | 27.80% | 25.49% | −2.3096 pp |
| June | 28.67% | 25.64% | −3.0383 pp |
| July | 31.82% | 25.33% | −6.4902 pp |
| August | 32.47% | 26.49% | −5.9874 pp |
| September | 28.40% | 27.42% | −0.9878 pp |

All nine months recorded negative YoY gross-margin-rate changes.

### 6.2 July: Largest Individual Monthly Decline

July recorded the largest YoY deterioration:

- Revenue growth: **+48.97%**
- COGS growth: **+63.16%**
- Gross-profit growth: **+18.59%**
- Gross-margin change: **−6.4902 pp**

### 6.3 August: Second-Largest Individual Monthly Decline

August also showed substantial deterioration:

- Revenue growth: **+35.03%**
- COGS growth: **+47.00%**
- Gross-profit growth: **+10.13%**
- Gross-margin change: **−5.9874 pp**

### 6.4 September: Relative Improvement

September recorded the smallest individual YoY gross-margin decline, at **−0.9878 percentage points**.

This indicates a narrower gap relative to September 2022, but it does not establish a sustained recovery.

### Management Interpretation

The deterioration was persistent rather than isolated. However, the July–August comparisons were particularly weak.

Management should investigate whether the product revenue mix during these months differed materially from earlier periods.

The available two-year, nine-month comparison is insufficient to establish a reliable recurring seasonal pattern.

---

## 7. Recommended Management Priorities

The following recommendations are prioritized investigative actions. They should not be interpreted as conclusions about causes that the dataset cannot verify.

### Priority 1 — Investigate the Colorbuds Revenue Decline

**Evidence:** Colorbuds generated the largest negative product-level margin contribution, at approximately −5.9934 pp.

**Recommended actions:**

- Review product availability and historical inventory movements, if available.
- Examine sales volume and revenue trends by store and month.
- Investigate changes in product placement, promotions, assortment, and customer demand.
- Determine whether sales shifted to lower-margin substitute products.

**Management objective:** Establish why the revenue contribution of a high-margin product declined so sharply.

### Priority 2 — Review Store-Level Margin Deterioration

**Evidence:** 49 of 50 stores recorded lower gross-margin rates, and the within-store component explains most of the company decline in the store-level decomposition.

**Recommended actions:**

- Prioritize stores with the largest negative revenue-weighted contributions.
- Compare product-mix changes between high-impact and lower-impact stores.
- Investigate whether assortment, stock availability, or local demand patterns differ.
- Establish store-level margin monitoring and exception thresholds.

**Management objective:** Identify actionable differences in product composition and performance across stores.

### Priority 3 — Investigate Electronics Category Contraction

**Evidence:** Electronics revenue share fell by approximately 9.42 percentage points, and its category-level contribution was strongly negative.

**Recommended actions:**

- Identify which Electronics products accounted for the contraction.
- Compare store-level and monthly Electronics performance.
- Review whether customer demand shifted to other product categories.
- Assess the potential gross-profit implications of assortment decisions.

**Management objective:** Understand the commercial implications of the reduction in high-margin Electronics sales.

### Priority 4 — Investigate July and August Margin Performance

**Evidence:** July and August experienced the largest individual monthly YoY gross-margin-rate declines.

**Recommended actions:**

- Compare monthly product and category revenue shares.
- Identify which products contributed most to the modeled margin changes.
- Review available promotion and inventory records.
- Investigate whether similar patterns occurred across many stores or were concentrated in particular locations.

**Management objective:** Determine whether these months reflect unusual product-mix movements requiring targeted intervention.

### Priority 5 — Establish an Executive Gross-Margin Monitoring Framework

**Recommended dashboard measures:**

- Revenue
- COGS
- Gross profit
- Gross-margin percentage
- YoY revenue growth
- YoY gross-profit growth
- YoY gross-margin change in percentage points
- Store margin performance and contribution
- Category revenue mix and margin decomposition
- Product-level margin-mix contribution
- Monthly gross-margin trends

**Management objective:** Enable timely identification of deteriorating profitability and support evidence-based commercial decisions.

---

## 8. Analytical Controls and Limitations

### 8.1 Financial Reconciliation

The financial baseline and subsequent decomposition analyses were validated against the same company totals.

For January–September 2023:

- Revenue: **6,962,074.27**
- COGS: **5,137,832.27**
- Gross profit: **1,824,242.00**
- Gross margin: **26.2026%**

The monthly analysis reconciled successfully to the company baseline.

### 8.2 Static Product Prices and Costs

Revenue and COGS are calculated using the product master fields `product_price` and `product_cost`.

These fields are not historical transaction-level records.

Accordingly, this analysis cannot establish:

- Actual historical selling-price changes
- Supplier cost inflation
- Transaction-specific discounts
- Changes in realized selling prices
- Actual product-level cost changes over time

References to margin deterioration describe changes in **modeled gross margin** based on the available source data.

### 8.3 Inventory Limitations

The inventory table represents a stock-on-hand snapshot.

It cannot independently establish historical stockouts, replenishment delays, or inventory availability during the reporting periods.

Inventory-related explanations require additional historical records.

### 8.4 Attribution Is Not Causation

Margin decomposition identifies how measured differences can be mathematically allocated across business dimensions.

It does not prove why those differences occurred.

The recommended investigations require additional operational or commercial evidence.

### 8.5 Do Not Add Decompositions Across Dimensions

Store-level, category-level, and product-level decompositions are alternative views of the **same −3.3464 pp company margin change**.

They must not be added together.

Each decomposition reconciles the same company result within its own analytical dimension.

### 8.6 Percentage Points Versus Percentages

Gross-margin-rate differences are reported in **percentage points (pp)**.

Revenue, COGS, units, and gross-profit growth are reported as percentage changes.

These measurements are not interchangeable.

### 8.7 Scope of Financial Performance

The analysis evaluates modeled gross profit and gross margin, not operating profit or net income.

Operating expenses, financing costs, taxes, and other below-gross-profit items are outside the current dataset and scope.

---

## 9. Executive Conclusion

The company achieved substantial revenue and unit-sales growth in January–September 2023, but this expansion was accompanied by a lower modeled gross-margin percentage.

The deterioration was broad across stores and months, while product and category analyses revealed significant changes in revenue composition.

The most important management priorities are to investigate the sharp reduction in Colorbuds revenue share, understand the contraction in Electronics, evaluate high-impact store performance, and examine the July–August margin declines.

The analysis provides a reconciled financial foundation for management decision-making. The next step is to present these findings through a concise executive dashboard that enables leadership to monitor revenue growth, gross-profit performance, and margin-mix changes.

---


## 10. Supporting SQL Evidence

All supporting SQL analyses are maintained in the
[ANALYZE SQL folder](../B_sql/03_analyze/).

Each query is documented and available for independent review.

| Query | Analytical purpose | SQL evidence |
|---|---|---|
| 01 | Financial baseline by year | [View SQL](../B_sql/03_analyze/01_financial_baseline_by_year.sql) |
| 02 | Financial YoY comparison | [View SQL](../B_sql/03_analyze/02_financial_yoy_comparison.sql) |
| 03 | Financial KPI reconciliation | [View SQL](../B_sql/03_analyze/03_financial_kpi_reconciliation.sql) |
| 04 | Store margin YoY analysis | [View SQL](../B_sql/03_analyze/04_store_margin_yoy_analysis.sql) |
| 05 | Store margin contribution | [View SQL](../B_sql/03_analyze/05_store_margin_contribution.sql) |
| 06 | Store margin-mix decomposition | [View SQL](../B_sql/03_analyze/06_store_margin_mix_decomposition.sql) |
| 07 | Product category financial performance | [View SQL](../B_sql/03_analyze/07_product_category_financial_performance.sql) |
| 08 | Category margin-mix decomposition | [View SQL](../B_sql/03_analyze/08_category_margin_mix_decomposition.sql) |
| 09 | Category margin contribution breakdown | [View SQL](../B_sql/03_analyze/09_category_margin_contribution_breakdown.sql) |
| 10 | Product-level financial performance | [View SQL](../B_sql/03_analyze/10_product_level_financial_performance.sql) |
| 11 | Product-level margin-mix decomposition | [View SQL](../B_sql/03_analyze/11_product_level_margin_mix_decomposition.sql) |
| 12 | Monthly financial performance and margin trends | [View SQL](../B_sql/03_analyze/12_monthly_financial_performance_and_margin_trends.sql) |

**Document status:** Executive synthesis prepared from
validated ANALYZE-stage results.

**Next project phase:** SHARE — Executive Dashboard
and Portfolio Presentation.

