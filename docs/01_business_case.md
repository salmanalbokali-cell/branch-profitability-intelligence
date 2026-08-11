# Business Case

## Portfolio Context

This is an independent data analytics portfolio project built using the publicly available Maven Toys dataset.

In a real organization, an analytics project would normally begin with a business signal, issue, or stakeholder request. Because confidential company data cannot be used or published for this portfolio, a public dataset was selected and a limited preliminary review was performed to identify a genuine business signal.

The stakeholder scenario used throughout this case study is simulated to reflect a realistic business environment. The dataset, analytical work, methodology, findings, and recommendations will be based on the actual analysis performed during the project.

## Business Environment

Maven Toys is a multi-store toy retailer operating across Mexico.

The available data contains information about:

- Stores
- Products
- Sales transactions
- Inventory
- Calendar dates

Management needs reliable performance information to understand whether business growth is translating effectively into stronger financial results and to identify areas that may require further investigation.

## Initial Business Signal

A limited preliminary review compared January–September 2022 with January–September 2023.

The preliminary results indicated that:

- Revenue increased by approximately 30.9%
- Units sold increased by approximately 40.8%
- Gross profit increased by approximately 16.0%
- Gross margin declined from approximately 29.5% to 26.2%

This represents a decline of approximately 3.35 percentage points in gross margin.

These observations represent a preliminary business signal only. They identify something that deserves investigation but do not explain why the change occurred.

The preliminary calculations use the product cost and price information available in the source dataset. The applicability and limitations of these values will be assessed during the formal data preparation and analysis stages.

## Simulated Stakeholder Request

For this case study, imagine that **Daniel Morales, Chief Financial Officer (CFO)**, reviews the company's performance and raises the following concern:

> "Revenue and unit sales have grown compared with the same period last year, but gross-margin performance has weakened. I need to understand what is driving this gap and where management should prioritize corrective action."

## Business Problem

Despite strong sales growth from January–September 2022 to the same period in 2023, gross-margin performance weakened.

The company is generating more revenue and selling more units, but gross profit is not increasing at the same rate.

Management does not yet understand which business factors are contributing to this performance gap.

Without identifying the underlying drivers, management may be unable to determine where corrective action could have the greatest financial impact.

## Problem Classification

The project contains two related analytical problem types.

### Descriptive Analysis

The preliminary stage establishes **what happened**:

- Revenue increased
- Unit sales increased
- Gross profit increased more slowly
- Gross margin declined

### Diagnostic Analysis

The primary analytical objective is diagnostic:

> **Why is gross-margin performance weakening despite strong revenue and unit growth, where is the deterioration concentrated, and which factors are associated with the performance gap?**

The analysis will investigate possible drivers without assuming their causes in advance.

## Business Task

Investigate the factors associated with weakening gross-margin performance, determine where the largest performance gaps exist, and provide evidence that helps management identify areas requiring priority attention.

The investigation should distinguish observations from interpretations and avoid making causal claims that are not supported by the available data.

## Analyst Role

The data analyst will translate the stakeholder concern into a structured analytical project by:

- Clarifying stakeholder requirements
- Developing measurable analytical questions
- Defining the project scope and relevant metrics
- Determining the data required to answer the questions
- Assessing data quality, credibility, structure, and limitations
- Preparing and analyzing the relevant data
- Identifying meaningful findings and insights
- Communicating results clearly
- Developing evidence-based recommendations for management

## Decision to Support

The analysis should ultimately help management determine:

- Where gross-margin deterioration is concentrated
- Which business areas require the greatest management attention
- Which factors are most strongly associated with the performance gap
- Where corrective action could have the greatest financial impact
- Which performance indicators should be monitored going forward

## Analytical Boundary

At this stage, no specific store, product, category, inventory issue, or other factor is assumed to be the cause of the margin decline.

Potential explanations will be evaluated only after the analytical questions, scope, data requirements, and methodology have been formally defined.

This project will not treat association or correlation as proof of causation.
