# Inbound Sales Analytics

End-to-end sales analytics platform built using SQL Server and Power BI to analyze inbound sales performance, funnel conversion, proposal efficiency, lead responsiveness, and revenue operations.

---

# Project Overview

This project simulates a modern inbound sales analytics environment using a Medallion Architecture (Bronze → Silver → Gold) implemented in SQL Server and visualized through interactive Power BI dashboards.

The solution transforms raw CRM datasets into business-ready analytical models that support executive decision-making, funnel performance analysis, operational monitoring, proposal intelligence, and revenue optimization.

---

# Business Problem

Sales organizations often struggle with:

- Funnel leakage across pipeline stages
- Low proposal acceptance rates
- Delayed lead response times
- Poor lead response compliance
- Pipeline stagnation
- Inefficient lead source allocation

This project was designed to identify operational bottlenecks, improve visibility into sales performance, and generate actionable business insights through analytics engineering and BI reporting.

---

# Tech Stack

| Technology | Purpose |
|---|---|
| SQL Server | Data Warehouse & ETL |
| Power BI | Dashboarding & Visualization |
| DAX | KPI Calculations & Measures |
| CSV Files | Source CRM Datasets |
| Medallion Architecture | Data Layering Framework |

---

# Architecture

The project follows a Medallion Architecture design pattern:

```text
CSV Files
   ↓
Bronze Layer (Raw Data)
   ↓
Silver Layer (Cleaned & Standardized Data)
   ↓
Gold Layer (Business-Ready Star Schema)
   ↓
Power BI Executive Dashboards
```

## Architecture Diagram

![Architecture Diagram](https://github.com/jaynitdhamanskar/inbound-sales-analytics/blob/main/screenshots/inbound_sales_analytics_architecture.drawio.png)

---

# Data Warehouse Layers

## Bronze Layer
Raw ingestion layer containing unmodified CRM datasets.

### Tables
- bronze.crm_leads
- bronze.crm_opportunities
- bronze.crm_activities
- bronze.proposals

### Features
- Batch ingestion
- Full load processing
- Raw data preservation

---

## Silver Layer
Cleaned and standardized analytical layer.

### Tables
- silver.crm_leads
- silver.crm_opportunities
- silver.crm_activities
- silver.proposals

### Transformations
- Data cleaning
- Standardization
- Null handling
- Lead Response categorization
- Aging bucket creation
- Weighted pipeline calculations
- Proposal metric enrichment
- Derived columns

---

## Gold Layer
Business-ready dimensional model optimized for analytics.

### Dimension Tables
- gold.dim_date
- gold.dim_lead_source
- gold.dim_pipeline_stage
- gold.dim_representative

### Fact Tables
- gold.fact_pipeline
- gold.fact_proposals

### Features
- Star schema modeling
- Revenue aggregations
- Funnel KPIs
- Proposal analytics
- Lead response metrics
- Business logic integration

---

# Data Model

The Gold Layer follows a Star Schema design:

- Fact tables store transactional sales and proposal metrics
- Dimension tables provide descriptive business context
- Optimized for analytical querying and Power BI reporting

---

# Dashboard Overview

## 1. Executive Overview

High-level business performance overview including:
- Total Pipeline
- Weighted Pipeline
- Closed Won Revenue
- Win Rate
- Proposal Acceptance Rate

![Executive Overview](https://github.com/jaynitdhamanskar/inbound-sales-analytics-/blob/main/screenshots/Executive%20Overview.png)

---

## 2. Funnel Analytics

Sales funnel performance analysis including:
- Funnel conversion analysis
- Pipeline stage performance
- Lost opportunity analysis
- Opportunity aging distribution

![Funnel Analytics](https://github.com/jaynitdhamanskar/inbound-sales-analytics-/blob/main/screenshots/Funnel%20Analytics.png)

---

## 3. Lead Source Performance

Lead acquisition and conversion analysis including:
- Revenue contribution by source
- Lead acquisition mix
- Win rate by lead source
- Source conversion efficiency

![Lead Source Performance](https://github.com/jaynitdhamanskar/inbound-sales-analytics-/blob/main/screenshots/Lead%20Source%20Performance.png)

---

## 4. Proposal Intelligence

Proposal workflow and conversion analysis including:
- Proposal acceptance trends
- Proposal turnaround analysis
- Revision impact analysis
- Proposal rejection metrics

![Proposal Intelligence](https://github.com/jaynitdhamanskar/inbound-sales-analytics-/blob/main/screenshots/Proposal%20Intelligence.png)

---

## 5. Sales Operations

Operational sales efficiency monitoring including:
- Lead Response compliance tracking
- Response time analysis
- Representative performance
- Opportunity aging analysis
- Activity monitoring

![Sales Operations](https://github.com/jaynitdhamanskar/inbound-sales-analytics/blob/main/screenshots/Sales%20Operations.png)

---

## 6. Executive Insights & Recommendations

Strategic business findings and operational recommendations derived from dashboard analysis.

![Executive Insights](https://github.com/jaynitdhamanskar/inbound-sales-analytics/blob/main/screenshots/Executive%20Overview%20%26%20Recommendations.png)

---

# Key KPIs

| KPI | Description |
|---|---|
| Win Rate | Percentage of closed-won opportunities |
| Proposal Acceptance Rate | Percentage of accepted proposals |
| Funnel Conversion Rate | Lead-to-close conversion efficiency |
| Weighted Pipeline | Probability-adjusted revenue forecast |
| Lead Response Compliance Rate | Percentage of leads responded within lead response compliance |
| Average Deal Size | Average opportunity value |
| Average Aging Days | Average opportunity aging duration |

---

# Key Business Insights

- Proposal acceptance remained relatively low at 34%, indicating significant proposal-stage leakage.
- Closed opportunities demonstrated a strong 55.4% win rate, suggesting effective late-stage sales execution.
- Lead response compliance remained below 25%, highlighting operational responsiveness challenges.
- Referral and LinkedIn-based acquisition channels consistently outperformed broader lead sources.
- Pipeline aging patterns indicated stagnation within negotiation and proposal stages.

---

# Strategic Recommendations

- Improve proposal qualification frameworks
- Standardize proposal workflows and pricing reviews
- Implement stronger lead response governance and monitoring
- Optimize acquisition spend toward high-performing channels
- Escalate aging opportunities through structured review processes

---

# Repository Structure

```text
Inbound-Sales-Analytics/

│
├── sql/
│   ├── bronze_layer.sql
│   ├── silver_layer.sql
│   ├── gold_layer.sql
│   ├── qc_queries.sql
│
├── powerbi/
│   └── inbound_sales_dashboard.pbix
│
├── screenshots/
│   ├── executive_overview.png
│   ├── funnel_analytics.png
│   ├── lead_source_performance.png
│   ├── proposal_intelligence.png
│   ├── sales_operations.png
│   ├── executive_insights.png
│
├── docs/
│   └── architecture_diagram.png
│
└── README.md
```

---

# Author

Jaynit Dhamanskar
