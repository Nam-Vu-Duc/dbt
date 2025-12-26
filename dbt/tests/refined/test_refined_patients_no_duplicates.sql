select patient_id
from {{ ref('refined_patients') }}
group by patient_id
having count(*) > 1
