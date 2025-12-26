{{ config(
    materialized='view',
    alias='stg_patients',
    schema='refined'
) }}

select
    SequenceNumber,
    try_cast(EnqueuedTimeUtc as datetime2(6)) as EnqueuedTimeUtc,
    patient_id,
    identifier_system,
    mrn,
    active,
    family_name,
    given_name,
    gender,
    try_cast(birth_date as date) as birth_date,
    version_id,
    try_cast(last_updated as datetime2(6)) as last_updated,
    
    -- Derived fields
    cast(floor(DATEDIFF(year, try_cast(birth_date as date), GETDATE())) as int) as age,
    case 
        when DATEDIFF(year, try_cast(birth_date as date), GETDATE()) >= 60 then 'Senior' 
        else 'Adult' 
    end as age_group,
    
    sysdatetime() as dbt_created_at  -- Returns datetime2(7) – safe in Fabric

from {{ source('raw', 'fhir_patients') }}

{% if is_incremental() %}
    where try_cast(last_updated as datetime2(6)) > 
          (select coalesce(max(try_cast(last_updated as datetime2(6))), cast('1900-01-01' as datetime2(6))) from {{ this }})
{% endif %}