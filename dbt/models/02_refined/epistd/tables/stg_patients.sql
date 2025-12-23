{{ config(
    materialized='incremental',
    file_format='delta',
    unique_key='patient_id',
    incremental_strategy='merge',
    schema='refined'
) }}

{% set columns = adapter.get_columns_in_relation(source('adp_lakehouse_raw', 'raw_patients')) %}
select
    {% for col in columns %}
        {{ col.name | lower | replace(' ', '_') | replace('-', '_') }} as {{ col.name | lower | replace(' ', '_') | replace('-', '_') }}{% if not loop.last %},{% endif %}
    {% endfor %},
    
    -- Derived fields
    case when age >= 60 then 'Senior' else 'Adult' end as age_group,
    level as cancer_severity_level

from {{ source('adp_lakehouse_raw', 'raw_patients') }}

{% if is_incremental() %}
    -- Filter to only new/updated raw data (adjust column if needed)
    where load_date > (select coalesce(max(load_date), '1900-01-01') from {{ this }})
{% endif %}