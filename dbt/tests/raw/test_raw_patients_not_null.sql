-- Test that critical columns in raw_patients have no null values
select *
from {{ source('raw', 'fhir_patients') }}
where patient_id is null
   or age is null
   or level is null
