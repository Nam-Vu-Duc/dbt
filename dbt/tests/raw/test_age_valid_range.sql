-- Test that age values are within realistic range (0-150)
select *
from {{ source('raw', 'fhir_patients') }}
where age < 0 or age > 150
