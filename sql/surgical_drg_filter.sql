
-- Surgical DRG Filter & Cost Benchmark Calculation
-- Purpose: Filter CMS inpatient data to surgical procedures
--          and calculate cost benchmarks vs national average

-- Step 1: Filter to surgical DRGs by category
WITH surgical_procedures AS (
    SELECT
        Rndrng_Prvdr_CCN                    AS hospital_id,
        Rndrng_Prvdr_Org_Name               AS hospital_name,
        Rndrng_Prvdr_City                   AS city,
        Rndrng_Prvdr_State_Abrvtn           AS state,
        DRG_Cd                              AS drg_code,
        DRG_Desc                            AS drg_description,
        CAST(Tot_Dschrgs AS INT)            AS total_discharges,
        CAST(Avg_Submtd_Cvrd_Chrg AS FLOAT) AS avg_submitted_charge,
        CAST(Avg_Tot_Pymt_Amt AS FLOAT)     AS avg_total_payment,
        CAST(Avg_Mdcr_Pymt_Amt AS FLOAT)    AS avg_medicare_payment,

        -- Surgical category classification
        CASE
            WHEN CAST(DRG_Cd AS INT) BETWEEN 216 AND 251 THEN 'Cardiac Surgery'
            WHEN CAST(DRG_Cd AS INT) BETWEEN 20  AND 103 THEN 'Neurosurgery'
            WHEN CAST(DRG_Cd AS INT) BETWEEN 453 AND 519 THEN 'Orthopedic Surgery'
            WHEN CAST(DRG_Cd AS INT) BETWEEN 28  AND 30  THEN 'Spinal Surgery'
            WHEN CAST(DRG_Cd AS INT) BETWEEN 252 AND 264 THEN 'Vascular Surgery'
            WHEN CAST(DRG_Cd AS INT) BETWEEN 163 AND 168 THEN 'Thoracic Surgery'
            WHEN CAST(DRG_Cd AS INT) BETWEEN 326 AND 395 THEN 'General Surgery'
            ELSE 'Other Surgical'
        END AS surgery_category

    FROM cms_inpatient_provider_service
    WHERE
        -- Include only surgical DRG ranges
        CAST(DRG_Cd AS INT) BETWEEN 216 AND 251   -- Cardiac
        OR CAST(DRG_Cd AS INT) BETWEEN 20  AND 103 -- Neuro
        OR CAST(DRG_Cd AS INT) BETWEEN 453 AND 519 -- Ortho
        OR CAST(DRG_Cd AS INT) BETWEEN 252 AND 264 -- Vascular
        OR CAST(DRG_Cd AS INT) BETWEEN 163 AND 168 -- Thoracic
        OR CAST(DRG_Cd AS INT) BETWEEN 326 AND 395 -- General
),

-- Step 2: Calculate national average payment per DRG
national_benchmarks AS (
    SELECT
        drg_code,
        AVG(avg_total_payment)    AS national_avg_payment,
        AVG(avg_submitted_charge) AS national_avg_charge,
        SUM(total_discharges)     AS national_total_discharges,
        COUNT(DISTINCT hospital_id) AS hospital_count
    FROM surgical_procedures
    GROUP BY drg_code
),

-- Step 3: Join benchmarks and calculate cost tiers
final AS (
    SELECT
        sp.*,
        nb.national_avg_payment,
        nb.national_total_discharges,
        nb.hospital_count,

        -- Cost metrics
        ROUND(sp.avg_submitted_charge /
              sp.avg_total_payment, 2)              AS charge_to_payment_ratio,

        ROUND((sp.avg_submitted_charge -
               sp.avg_total_payment) /
               sp.avg_submitted_charge * 100, 2)   AS medicare_discount_pct,

        ROUND(sp.avg_total_payment *
              sp.total_discharges, 2)               AS volume_weighted_cost,

        -- Variance from national benchmark
        ROUND(sp.avg_total_payment -
              nb.national_avg_payment, 2)           AS payment_vs_national,

        ROUND((sp.avg_total_payment -
               nb.national_avg_payment) /
               nb.national_avg_payment * 100, 2)   AS payment_vs_national_pct,

        -- Cost tier classification
        CASE
            WHEN ((sp.avg_total_payment - nb.national_avg_payment) /
                   nb.national_avg_payment * 100) < -10
                THEN 'Below Benchmark'
            WHEN ((sp.avg_total_payment - nb.national_avg_payment) /
                   nb.national_avg_payment * 100) > 10
                THEN 'Above Benchmark'
            ELSE 'At Benchmark'
        END AS cost_tier

    FROM surgical_procedures sp
    LEFT JOIN national_benchmarks nb
        ON sp.drg_code = nb.drg_code
)

SELECT * FROM final
ORDER BY volume_weighted_cost DESC;