USE InboundRevenueAnalytics;
GO

/*
=========================================================
SILVER LAYER TABLES
=========================================================
Purpose:
Create cleaned and analytics-ready Silver layer tables.

These tables will later be populated using
stored procedures.
=========================================================
*/


/*
=========================================================
silver.crm_leads
=========================================================
*/

IF OBJECT_ID('silver.crm_leads', 'U') IS NOT NULL
    DROP TABLE silver.crm_leads;
GO

CREATE TABLE silver.crm_leads (

    lead_id VARCHAR(20),

    created_at DATETIME,

    company_name VARCHAR(255),

    industry VARCHAR(100),

    country VARCHAR(100),

    lead_source VARCHAR(100),

    estimated_budget_usd FLOAT,

    budget_segment VARCHAR(50),

    response_time_hours INT,

    response_sla_category VARCHAR(50),

    contact_email VARCHAR(255),

    assigned_rep VARCHAR(100)

);
GO


/*
=========================================================
silver.crm_opportunities
=========================================================
*/

IF OBJECT_ID('silver.crm_opportunities', 'U') IS NOT NULL
    DROP TABLE silver.crm_opportunities;
GO

CREATE TABLE silver.crm_opportunities (

    opportunity_id VARCHAR(20),

    lead_id VARCHAR(20),

    pipeline_stage VARCHAR(100),

    deal_value_usd FLOAT,

    probability_percent FLOAT,

    weighted_pipeline_value FLOAT,

    aging_days INT,

    aging_bucket VARCHAR(50),

    expected_close_date DATE,

    assigned_rep VARCHAR(100),

    lost_reason VARCHAR(255)

);
GO


/*
=========================================================
silver.crm_activities
=========================================================
*/

IF OBJECT_ID('silver.crm_activities', 'U') IS NOT NULL
    DROP TABLE silver.crm_activities;
GO

CREATE TABLE silver.crm_activities (

    activity_id VARCHAR(20),

    opportunity_id VARCHAR(20),

    activity_type VARCHAR(100),

    activity_date DATE,

    activity_outcome VARCHAR(100),

    owner VARCHAR(100)

);
GO


/*
=========================================================
silver.proposals
=========================================================
*/

IF OBJECT_ID('silver.proposals', 'U') IS NOT NULL
    DROP TABLE silver.proposals;
GO

CREATE TABLE silver.proposals (

    proposal_id VARCHAR(20),

    opportunity_id VARCHAR(20),

    proposal_sent_date DATE,

    proposal_turnaround_days INT,

    turnaround_category VARCHAR(50),

    revision_count INT,

    proposal_status VARCHAR(100)

);
GO