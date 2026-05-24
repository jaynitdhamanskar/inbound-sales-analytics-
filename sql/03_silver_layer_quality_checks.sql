/*
=========================================================
SILVER LAYER QC CHECKS
=========================================================
Purpose:
Validate Silver layer transformations, standardization,
and business rule implementation.
=========================================================
*/


/*
=========================================================
ROW COUNT VALIDATION
=========================================================
Check total records loaded into Silver tables.
=========================================================
*/

SELECT 'crm_leads' AS table_name, COUNT(*) AS total_rows
FROM silver.crm_leads

UNION ALL

SELECT 'crm_opportunities', COUNT(*)
FROM silver.crm_opportunities

UNION ALL

SELECT 'crm_activities', COUNT(*)
FROM silver.crm_activities

UNION ALL

SELECT 'proposals', COUNT(*)
FROM silver.proposals;


/*
=========================================================
DUPLICATE VALIDATION
=========================================================
Ensure duplicate lead records were removed.
=========================================================
*/

SELECT

    lead_id,
    COUNT(*) AS duplicate_count

FROM silver.crm_leads

GROUP BY lead_id

HAVING COUNT(*) > 1;


/*
=========================================================
LEAD SOURCE STANDARDIZATION CHECK
=========================================================
Validate cleaned lead source values.
=========================================================
*/

SELECT DISTINCT lead_source
FROM silver.crm_leads
ORDER BY lead_source;


/*
=========================================================
INDUSTRY STANDARDIZATION CHECK
=========================================================
Validate cleaned industry values.
=========================================================
*/

SELECT DISTINCT industry
FROM silver.crm_leads
ORDER BY industry;


/*
=========================================================
EMAIL VALIDATION CHECK
=========================================================
Ensure invalid email formats were cleaned.
=========================================================
*/

SELECT *
FROM silver.crm_leads
WHERE contact_email NOT LIKE '%@%.%'
    AND contact_email IS NOT NULL;


/*
=========================================================
RESPONSE TIME VALIDATION
=========================================================
Ensure negative response times were removed.
=========================================================
*/

SELECT *
FROM silver.crm_leads
WHERE response_time_hours < 0;


/*
=========================================================
SLA CATEGORY DISTRIBUTION
=========================================================
Review SLA category segmentation.
=========================================================
*/

SELECT

    response_sla_category,
    COUNT(*) AS total_leads

FROM silver.crm_leads

GROUP BY response_sla_category

ORDER BY total_leads DESC;


/*
=========================================================
BUDGET SEGMENT VALIDATION
=========================================================
Review budget category distribution.
=========================================================
*/

SELECT

    budget_segment,
    COUNT(*) AS total_leads

FROM silver.crm_leads

GROUP BY budget_segment;


/*
=========================================================
PIPELINE STAGE STANDARDIZATION CHECK
=========================================================
Validate cleaned opportunity stage values.
=========================================================
*/

SELECT DISTINCT pipeline_stage
FROM silver.crm_opportunities
ORDER BY pipeline_stage;


/*
=========================================================
WEIGHTED PIPELINE VALIDATION
=========================================================
Verify weighted revenue calculations.
=========================================================
*/

SELECT TOP 20

    deal_value_usd,
    probability_percent,
    weighted_pipeline_value

FROM silver.crm_opportunities;


/*
=========================================================
AGING BUCKET VALIDATION
=========================================================
Review opportunity aging distribution.
=========================================================
*/

SELECT

    aging_bucket,
    COUNT(*) AS total_opportunities

FROM silver.crm_opportunities

GROUP BY aging_bucket;


/*
=========================================================
PROPOSAL TURNAROUND VALIDATION
=========================================================
Review proposal turnaround segmentation.
=========================================================
*/

SELECT

    turnaround_category,
    COUNT(*) AS total_proposals

FROM silver.proposals

GROUP BY turnaround_category;


/*
=========================================================
NULL PROBABILITY VALIDATION
=========================================================
Ensure probability values were handled properly.
=========================================================
*/

SELECT *
FROM silver.crm_opportunities
WHERE probability_percent IS NULL;


/*
=========================================================
RELATIONSHIP VALIDATION
=========================================================
Ensure all opportunities map to valid leads.
=========================================================
*/

SELECT o.*
FROM silver.crm_opportunities o

LEFT JOIN silver.crm_leads l
    ON o.lead_id = l.lead_id

WHERE l.lead_id IS NULL;


/*
=========================================================
ACTIVITY RELATIONSHIP VALIDATION
=========================================================
Ensure all activities map to valid opportunities.
=========================================================
*/

SELECT a.*
FROM silver.crm_activities a

LEFT JOIN silver.crm_opportunities o
    ON a.opportunity_id = o.opportunity_id

WHERE o.opportunity_id IS NULL;