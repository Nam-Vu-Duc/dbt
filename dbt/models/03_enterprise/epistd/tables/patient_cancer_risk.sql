{{ config(
    materialized='table',
    alias='patient_cancer_risk'
) }}

select
    cancer_severity_level,
    age_group,
    count(*) as patient_count,
    round(avg(total_risk_score), 2) as avg_risk_score,
    round(avg(total_symptom_score), 2) as avg_symptom_score,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as pct_of_total_patients
from adp_lakehouse.adp_lakehouse_refined.refined_patients
group by cancer_severity_level, age_group