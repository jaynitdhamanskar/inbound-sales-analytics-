/*
========================================
bronze.crm_leads_raw
Raw CRM lead data ingested from source systems
========================================
*/

CREATE TABLE bronze.crm_leads_raw (
    lead_id VARCHAR(20),
    created_at DATETIME,

    -- Original acquisition channel of the lead
    lead_source VARCHAR(100),

    company_name VARCHAR(255),
    industry VARCHAR(100),
    employee_size VARCHAR(100),
    country VARCHAR(100),

    -- Estimated deal budget captured during lead qualification
    estimated_budget FLOAT,

    inquiry_type VARCHAR(255),
    assigned_rep VARCHAR(100),

    -- Current lead lifecycle status
    lead_status VARCHAR(50),

    email VARCHAR(255)
);

GO


/*
========================================
bronze.crm_activities_raw
Raw sales activity history linked to leads
========================================
*/

CREATE TABLE bronze.crm_activities_raw (
    activity_id VARCHAR(20),
    lead_id VARCHAR(20),

    rep_name VARCHAR(100),
    activity_type VARCHAR(100),
    activity_timestamp DATETIME,

    -- Time taken by sales rep to respond to lead activity
    response_time_hours FLOAT,

    activity_outcome VARCHAR(100),

    -- Free-text notes from CRM activity logs
    notes VARCHAR(MAX)
);

GO


/*
========================================
bronze.crm_opportunities_raw
Raw opportunity pipeline and deal progression data
========================================
*/

CREATE TABLE bronze.crm_opportunities_raw (
    opportunity_id VARCHAR(20),
    lead_id VARCHAR(20),

    current_stage VARCHAR(100),

    -- Expected deal value at current pipeline stage
    deal_value FLOAT,

    probability FLOAT,

    created_date DATETIME,
    proposal_sent_date DATETIME,
    expected_close_date DATETIME,
    actual_close_date DATETIME,

    -- Number of days opportunity remained in current stage
    days_in_stage INT,

    proposal_revisions INT,
    opportunity_status VARCHAR(50),

    -- Captured only for lost opportunities
    loss_reason VARCHAR(255)
);


/*
========================================
bronze.proposal_tracker_raw
Raw proposal submission and approval tracking data
========================================
*/

CREATE TABLE bronze.proposal_tracker_raw (
    proposal_id VARCHAR(20),
    opportunity_id VARCHAR(20),

    -- Version number used to track proposal revisions
    proposal_version INT,

    sent_date DATETIME,
    approval_status VARCHAR(50),

    -- Proposal approval turnaround time in days
    turnaround_days INT,

    proposal_amount FLOAT
);


/*
========================================
bronze.revenue_forecast_raw
Raw forecasted vs actual revenue tracking data
========================================
*/

CREATE TABLE bronze.revenue_forecast_raw (
    forecast_id VARCHAR(20),
    opportunity_id VARCHAR(20),

    -- Forecast reporting month
    forecast_month VARCHAR(20),

    predicted_revenue FLOAT,
    actual_revenue FLOAT,

    -- Confidence level assigned to revenue prediction
    forecast_confidence VARCHAR(50)
);