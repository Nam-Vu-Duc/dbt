{{ config(
    materialized = 'table',
    alias = 'patients',
    schema = 'enterprise'
) }}

select
    gender_code,
    age_category,

    count(*) as patient_count,

    round(avg(age), 1) as avg_age,

    min(age) as min_age,
    max(age) as max_age,

    -- Percentage of total patients in this group
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_total_patients

from {{ ref('refined_patients') }}

where is_active = 1
  and patient_id is not null

group by 
    gender_code,
    age_category