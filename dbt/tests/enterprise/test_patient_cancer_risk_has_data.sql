select count(*) as record_count
from {{ ref('enterprise_patients') }}
having count(*) > 0