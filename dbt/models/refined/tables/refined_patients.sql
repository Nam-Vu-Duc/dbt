{{ config(
    materialized='table',
    alias='patients',
    schema='refined'
) }}

select
    cast(SequenceNumber as bigint)                              as sequence_number,
    try_cast(EnqueuedTimeUtc as datetime2(3))                   as enqueued_time_utc,
    cast(patient_id as varchar(255))                            as patient_id,
    cast(identifier_system as varchar(255))                     as identifier_system,
    cast(mrn as varchar(50))                                    as mrn,
    cast(active as bit)                                         as is_active,
    cast(family_name as varchar(100))                           as family_name,
    cast(given_name as varchar(100))                            as given_name,
    cast(gender as varchar(10))                                 as gender,
    try_cast(birth_date as date)                                as birth_date,
    cast(version_id as varchar(50))                             as version_id,
    try_cast(last_updated as datetime2(3))                      as last_updated,
    cast(age as int)                                            as age,
    cast(age_group as varchar(20))                              as age_group,
    try_cast(dbt_created_at as datetime2(3))                    as dbt_created_at,

    -- Additional fields
    case 
        when gender = 'male' then 'M'
        when gender = 'female' then 'F'
        else 'U'
    end                                                         as gender_code,

    case 
        when age < 18 then 'Pediatric'
        when age < 40 then 'Young Adult'
        when age < 60 then 'Middle-aged Adult'
        else 'Senior'
    end                                                         as age_category,

    row_number() over (order by patient_id)                     as patient_key,

    cast(sysdatetime() as datetime2(3))                         as refined_created_at,
    cast(null as datetime2(3))                                  as refined_updated_at

from {{ ref('stg_patients') }}

where patient_id is not null
  and mrn is not null
  and birth_date is not null