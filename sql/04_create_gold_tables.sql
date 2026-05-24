/*
=========================================================
CREATE GOLD LAYER TABLES
=========================================================
Purpose:
Create reporting-ready dimension and fact tables
for executive analytics and Power BI reporting.
=========================================================
*/


/*
=========================================================
DIMENSION TABLES
=========================================================
*/


/*
=========================================================
gold.dim_date
=========================================================
*/

IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
    DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date (

    date_value DATE,

    year_number INT,

    quarter_number INT,

    month_number INT,

    month_name VARCHAR(20)

);
GO


/*
=========================================================
gold.dim_lead_source
=========================================================
*/

IF OBJECT_ID('gold.dim_lead_source', 'U') IS NOT NULL
    DROP TABLE gold.dim_lead_source;
GO

CREATE TABLE gold.dim_lead_source (

    lead_source VARCHAR(100),

    source_category VARCHAR(50)

);
GO


/*
=========================================================
gold.dim_pipeline_stage
=========================================================
*/

IF OBJECT_ID('gold.dim_pipeline_stage', 'U') IS NOT NULL
    DROP TABLE gold.dim_pipeline_stage;
GO

CREATE TABLE gold.dim_pipeline_stage (

    pipeline_stage VARCHAR(100),

    stage_order INT,

    funnel_group VARCHAR(50)

);
GO


/*
=========================================================
gold.dim_representative
=========================================================
*/

IF OBJECT_ID('gold.dim_representative', 'U') IS NOT NULL
    DROP TABLE gold.dim_representative;
GO

CREATE TABLE gold.dim_representative (

    representative_name VARCHAR(100),

    department VARCHAR(50)

);
GO


/*
=========================================================
FACT TABLES
=========================================================
*/


/*
=========================================================
gold.fact_pipeline
=========================================================
*/

IF OBJECT_ID('gold.fact_pipeline', 'U') IS NOT NULL
    DROP TABLE gold.fact_pipeline;
GO

CREATE TABLE gold.fact_pipeline (

    opportunity_id VARCHAR(20),

    lead_id VARCHAR(20),

    created_date DATE,

    expected_close_date DATE,

    lead_source VARCHAR(100),

    representative_name VARCHAR(100),

    pipeline_stage VARCHAR(100),

    deal_value_usd FLOAT,

    probability_percent FLOAT,

    weighted_pipeline_value FLOAT,

    aging_days INT,

    aging_bucket VARCHAR(50),

    lost_reason VARCHAR(255)

);
GO


/*
=========================================================
gold.fact_proposals
=========================================================
*/

IF OBJECT_ID('gold.fact_proposals', 'U') IS NOT NULL
    DROP TABLE gold.fact_proposals;
GO

CREATE TABLE gold.fact_proposals (

    proposal_id VARCHAR(20),

    opportunity_id VARCHAR(20),

    proposal_sent_date DATE,

    turnaround_category VARCHAR(50),

    proposal_turnaround_days INT,

    revision_count INT,

    proposal_status VARCHAR(100),

    representative_name VARCHAR(100),

    deal_value_usd FLOAT,

    pipeline_stage VARCHAR(100)

);
GO