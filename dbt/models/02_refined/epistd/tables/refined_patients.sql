{{ config(
    materialized='incremental',
    file_format='delta',
    unique_key='patient_id',
    incremental_strategy='merge',
    schema='refined'
) }}

with cleaned as (
    select * from {{ ref('stg_patients') }}
)

select
    patient_id,
    age,
    gender,
    age_group,
    cancer_severity_level,

    -- Sum of major risk factors (example scoring)
    (air_pollution + alcohol_use + dust_allergy + occupational_hazards +
     genetic_risk + chronic_lung_disease + smoking + passive_smoker) as total_risk_score,

    -- Symptom severity sum
    (chest_pain + coughing_of_blood + fatigue + weight_loss +
     shortness_of_breath + wheezing + swallowing_difficulty) as total_symptom_score

from cleaned