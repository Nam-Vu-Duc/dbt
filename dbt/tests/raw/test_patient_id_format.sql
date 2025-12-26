-- Test that patient_id starts with 'P' and the rest are digits
select *
from {{ source('raw', 'fhir_patients') }}
where patient_id not rlike '^P[0-9]+$'