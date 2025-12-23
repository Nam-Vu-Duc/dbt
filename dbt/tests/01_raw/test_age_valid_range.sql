-- Test that age values are within realistic range (0-150)
select *
from {{ source('adp_lakehouse_raw', 'raw_patients') }}
where age < 0 or age > 150
