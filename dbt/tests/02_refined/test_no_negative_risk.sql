select *
from {{ ref('refined_patients') }}
where total_risk_score < 0