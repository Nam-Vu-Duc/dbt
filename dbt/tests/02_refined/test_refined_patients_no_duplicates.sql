-- Test that refined_patients has no duplicate patient_ids
select patient_id, count(*) as cnt
from {{ ref('refined_patients') }}
group by patient_id
having count(*) > 1
