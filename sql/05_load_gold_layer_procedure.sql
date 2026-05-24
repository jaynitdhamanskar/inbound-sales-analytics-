CREATE OR ALTER PROCEDURE gold.load_gold
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
        PRINT 'LOADING GOLD LAYER';
        PRINT '=====================================';


        /*
        =========================================================
        LOAD: gold.dim_date
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: gold.dim_date';
        PRINT '-------------------------------------';

        TRUNCATE TABLE gold.dim_date;

        INSERT INTO gold.dim_date (

            date_value,
            year_number,
            quarter_number,
            month_number,
            month_name

        )

        SELECT DISTINCT

            CAST(created_at AS DATE) AS date_value,

            YEAR(created_at) AS year_number,

            DATEPART(QUARTER, created_at) AS quarter_number,

            MONTH(created_at) AS month_number,

            DATENAME(MONTH, created_at) AS month_name

        FROM silver.crm_leads;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'dim_date loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: gold.dim_lead_source
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: gold.dim_lead_source';
        PRINT '-------------------------------------';

        TRUNCATE TABLE gold.dim_lead_source;

        INSERT INTO gold.dim_lead_source (

            lead_source,
            source_category

        )

        SELECT DISTINCT

            lead_source,

            CASE

                WHEN lead_source IN ('LinkedIn Ads', 'Google Ads')
                    THEN 'Paid'

                WHEN lead_source IN ('Referral', 'Partner Referral', 'Existing Client Upsell')
                    THEN 'Referral'

                ELSE 'Organic'

            END AS source_category

        FROM silver.crm_leads;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'dim_lead_source loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: gold.dim_pipeline_stage
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: gold.dim_pipeline_stage';
        PRINT '-------------------------------------';

        TRUNCATE TABLE gold.dim_pipeline_stage;

        INSERT INTO gold.dim_pipeline_stage (

            pipeline_stage,
            stage_order,
            funnel_group

        )

        SELECT DISTINCT

            pipeline_stage,

            CASE

                WHEN pipeline_stage = 'Inbound Lead'
                    THEN 1

                WHEN pipeline_stage = 'Discovery Call'
                    THEN 2

                WHEN pipeline_stage = 'Technical Consultation'
                    THEN 3

                WHEN pipeline_stage = 'Proposal Shared'
                    THEN 4

                WHEN pipeline_stage = 'Negotiation'
                    THEN 5

                WHEN pipeline_stage = 'Closed Won'
                    THEN 6

                WHEN pipeline_stage = 'Closed Lost'
                    THEN 7

            END AS stage_order,

            CASE

                WHEN pipeline_stage IN ('Closed Won', 'Closed Lost')
                    THEN 'Closed'

                ELSE 'Open'

            END AS funnel_group

        FROM silver.crm_opportunities;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'dim_pipeline_stage loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: gold.dim_representative
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: gold.dim_representative';
        PRINT '-------------------------------------';

        TRUNCATE TABLE gold.dim_representative;

        INSERT INTO gold.dim_representative (

            representative_name,
            department

        )

        SELECT DISTINCT

            assigned_rep AS representative_name,

            'Sales' AS department

        FROM silver.crm_leads;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'dim_representative loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: gold.fact_pipeline
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: gold.fact_pipeline';
        PRINT '-------------------------------------';

        TRUNCATE TABLE gold.fact_pipeline;

        INSERT INTO gold.fact_pipeline (

            opportunity_id,
            lead_id,
            created_date,
            expected_close_date,
            lead_source,
            representative_name,
            pipeline_stage,
            deal_value_usd,
            probability_percent,
            weighted_pipeline_value,
            aging_days,
            aging_bucket,
            lost_reason,
            response_time_hours,
            response_sla_category

        )

        SELECT

            o.opportunity_id,

            o.lead_id,

            CAST(l.created_at AS DATE) AS created_date,

            o.expected_close_date,

            l.lead_source,

            o.assigned_rep AS representative_name,

            o.pipeline_stage,

            o.deal_value_usd,

            o.probability_percent,

            o.weighted_pipeline_value,

            o.aging_days,

            o.aging_bucket,

            o.lost_reason,

            l.response_time_hours,

            l.response_sla_category

        FROM silver.crm_opportunities o

        LEFT JOIN silver.crm_leads l
            ON o.lead_id = l.lead_id;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'fact_pipeline loaded successfully';
        PRINT 'Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)
            + ' seconds';


        /*
        =========================================================
        LOAD: gold.fact_proposals
        =========================================================
        */

        SET @start_time = GETDATE();

        PRINT '-------------------------------------';
        PRINT 'Loading: gold.fact_proposals';
        PRINT '-------------------------------------';

        TRUNCATE TABLE gold.fact_proposals;

        INSERT INTO gold.fact_proposals (

            proposal_id,
            opportunity_id,
            proposal_sent_date,
            turnaround_category,
            proposal_turnaround_days,
            revision_count,
            proposal_status,
            representative_name,
            deal_value_usd,
            pipeline_stage,
            lead_source

        )

        SELECT

            p.proposal_id,

            p.opportunity_id,

            p.proposal_sent_date,

            p.turnaround_category,

            p.proposal_turnaround_days,

            p.revision_count,

            p.proposal_status,

            o.assigned_rep AS representative_name,

            o.deal_value_usd,

            o.pipeline_stage,

            l.lead_source

        FROM silver.proposals p

        LEFT JOIN silver.crm_opportunities o
            ON p.opportunity_id = o.opportunity_id

        LEFT JOIN silver.crm_leads l
            ON o.lead_id = l.lead_id;

        PRINT 'Rows Inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

        SET @end_time = GETDATE();

        PRINT 'fact_proposals loaded successfully';
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
        PRINT 'GOLD LAYER LOAD COMPLETED';
        PRINT 'Total Duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR)
            + ' seconds';
        PRINT '=====================================';

    END TRY

    BEGIN CATCH

        PRINT '=====================================';
        PRINT 'ERROR OCCURRED DURING GOLD LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
        PRINT '=====================================';

    END CATCH

END;
GO

EXEC gold.load_gold;
GO


ALTER TABLE gold.fact_proposals
ADD lead_source VARCHAR(100);

ALTER TABLE gold.fact_pipeline
ADD response_time_hours FLOAT;

ALTER TABLE gold.fact_pipeline
ADD response_sla_category VARCHAR(50);


SELECT TOP 1 *
FROM gold.fact_pipeline;


SELECT TOP 5 *
FROM silver.crm_leads;