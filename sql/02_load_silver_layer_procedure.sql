USE InboundRevenueAnalytics;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '=====================================';
        PRINT 'LOADING SILVER LAYER';
        PRINT '=====================================';


        /*
        =========================================================
        LOAD: silver.crm_leads
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: silver.crm_leads';
        PRINT '-------------------------------------';

        TRUNCATE TABLE silver.crm_leads;

        WITH deduplicated_leads AS (

            SELECT
                *,
                
                ROW_NUMBER() OVER (
                    PARTITION BY lead_id
                    ORDER BY created_at DESC
                ) AS rn

            FROM bronze.crm_leads_raw

        )

        INSERT INTO silver.crm_leads (

            lead_id,
            created_at,
            company_name,
            industry,
            country,
            lead_source,
            estimated_budget_usd,
            budget_segment,
            response_time_hours,
            response_sla_category,
            contact_email,
            assigned_rep

        )

        SELECT

            lead_id,

            created_at,

            company_name,

            CASE

                WHEN LOWER(industry) IN ('health care', 'health-tech')
                    THEN 'Healthcare'

                WHEN LOWER(industry) IN ('fin tech', 'financial tech')
                    THEN 'FinTech'

                WHEN LOWER(industry) IN ('software', 'saas')
                    THEN 'SaaS'

                WHEN LOWER(industry) IN ('ecommerce', 'online retail')
                    THEN 'E-commerce'

                WHEN LOWER(industry) IN ('supply chain')
                    THEN 'Logistics'

                WHEN LOWER(industry) IN ('education tech', 'ed tech')
                    THEN 'EdTech'

                WHEN LOWER(industry) IN ('industrial')
                    THEN 'Manufacturing'

                WHEN LOWER(industry) IN ('property tech', 'real-estate')
                    THEN 'Real Estate'

                ELSE industry

            END AS industry,

            country,

            CASE

                WHEN LOWER(lead_source) IN ('linkedin organic', 'li organic')
                    THEN 'LinkedIn Organic'

                WHEN LOWER(lead_source) IN ('website form', 'website lead')
                    THEN 'Website Inquiry'

                WHEN LOWER(lead_source) IN ('client referral', 'referral')
                    THEN 'Referral'

                WHEN LOWER(lead_source) IN ('partner_ref', 'partner lead')
                    THEN 'Partner Referral'

                WHEN LOWER(lead_source) IN ('ai webinar', 'webinar signup')
                    THEN 'Webinar'

                WHEN LOWER(lead_source) IN ('clutch.co', 'clutch lead')
                    THEN 'Clutch'

                WHEN LOWER(lead_source) IN ('organic blog', 'seo')
                    THEN 'SEO / Blog'

                WHEN LOWER(lead_source) IN ('linkedin paid', 'li ads')
                    THEN 'LinkedIn Ads'

                WHEN LOWER(lead_source) IN ('google paid', 'google ppc')
                    THEN 'Google Ads'

                WHEN LOWER(lead_source) IN ('upsell', 'existing client')
                    THEN 'Existing Client Upsell'

                ELSE lead_source

            END AS lead_source,

            estimated_budget_usd,

            CASE

                WHEN estimated_budget_usd IS NULL
                    THEN 'Unknown'

                WHEN estimated_budget_usd < 10000
                    THEN 'Small'

                WHEN estimated_budget_usd < 50000
                    THEN 'Medium'

                ELSE 'Large'

            END AS budget_segment,

            CASE

                WHEN response_time_hours < 0
                    THEN NULL

                ELSE response_time_hours

            END AS response_time_hours,

            CASE

                WHEN response_time_hours < 0
                    THEN 'Invalid'

                WHEN response_time_hours < 1
                    THEN 'Excellent'

                WHEN response_time_hours <= 4
                    THEN 'Good'

                WHEN response_time_hours <= 24
                    THEN 'Delayed'

                ELSE 'Critical'

            END AS response_sla_category,

            CASE

                WHEN contact_email LIKE '%@%.%'
                    THEN contact_email

                ELSE NULL

            END AS contact_email,

            assigned_rep

        FROM deduplicated_leads

        WHERE rn = 1;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'crm_leads loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: silver.crm_opportunities
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: silver.crm_opportunities';
        PRINT '-------------------------------------';

        TRUNCATE TABLE silver.crm_opportunities;

        INSERT INTO silver.crm_opportunities (

            opportunity_id,
            lead_id,
            pipeline_stage,
            deal_value_usd,
            probability_percent,
            weighted_pipeline_value,
            aging_days,
            aging_bucket,
            expected_close_date,
            assigned_rep,
            lost_reason

        )

        SELECT

            opportunity_id,

            lead_id,

            CASE

                WHEN LOWER(pipeline_stage) IN ('proposal sent', 'proposal submitted')
                    THEN 'Proposal Shared'

                WHEN LOWER(pipeline_stage) IN ('tech call', 'solution discussion')
                    THEN 'Technical Consultation'

                WHEN LOWER(pipeline_stage) = 'won'
                    THEN 'Closed Won'

                WHEN LOWER(pipeline_stage) = 'lost'
                    THEN 'Closed Lost'

                ELSE pipeline_stage

            END AS pipeline_stage,

            deal_value_usd,

            ISNULL(probability_percent, 0) AS probability_percent,

            deal_value_usd * (ISNULL(probability_percent, 0) / 100.0)
                AS weighted_pipeline_value,

            aging_days,

            CASE

                WHEN aging_days <= 15
                    THEN '0-15 Days'

                WHEN aging_days <= 30
                    THEN '16-30 Days'

                WHEN aging_days <= 60
                    THEN '31-60 Days'

                ELSE '60+ Days'

            END AS aging_bucket,

            expected_close_date,

            assigned_rep,

            lost_reason

        FROM bronze.crm_opportunities_raw;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'crm_opportunities loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: silver.crm_activities
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: silver.crm_activities';
        PRINT '-------------------------------------';

        TRUNCATE TABLE silver.crm_activities;

        INSERT INTO silver.crm_activities (

            activity_id,
            opportunity_id,
            activity_type,
            activity_date,
            activity_outcome,
            owner

        )

        SELECT

            activity_id,

            opportunity_id,

            CASE

                WHEN LOWER(activity_type) = 'follow-up'
                    THEN 'Follow Up'

                ELSE activity_type

            END AS activity_type,

            activity_date,

            CASE

                WHEN LOWER(activity_outcome) = 'follow-up required'
                    THEN 'Follow Up Required'

                ELSE activity_outcome

            END AS activity_outcome,

            owner

        FROM bronze.crm_activities_raw;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'crm_activities loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: silver.proposals
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: silver.proposals';
        PRINT '-------------------------------------';

        TRUNCATE TABLE silver.proposals;

        INSERT INTO silver.proposals (

            proposal_id,
            opportunity_id,
            proposal_sent_date,
            proposal_turnaround_days,
            turnaround_category,
            revision_count,
            proposal_status

        )

        SELECT

            proposal_id,

            opportunity_id,

            proposal_sent_date,

            proposal_turnaround_days,

            CASE

                WHEN proposal_turnaround_days <= 2
                    THEN 'Fast'

                WHEN proposal_turnaround_days <= 5
                    THEN 'Moderate'

                ELSE 'Delayed'

            END AS turnaround_category,

            revision_count,

            proposal_status

        FROM bronze.proposals_raw;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'proposals loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        BATCH COMPLETION
        =========================================================
        */

        SET @batch_end_time = GETDATE();

        PRINT '=====================================';
        PRINT 'SILVER LAYER LOAD COMPLETED';
        PRINT 'Total Duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR)
            + ' seconds';
        PRINT '=====================================';

    END TRY

    BEGIN CATCH

        PRINT '=====================================';
        PRINT 'ERROR OCCURRED DURING SILVER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
        PRINT '=====================================';

    END CATCH

END;
GO

EXEC silver.load_silver;
GO