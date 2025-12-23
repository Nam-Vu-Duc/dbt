-- Test that age_group only has valid values
select *
from {{ ref('refined_patients') }}
where age_group not in ('Senior', 'Adult')
