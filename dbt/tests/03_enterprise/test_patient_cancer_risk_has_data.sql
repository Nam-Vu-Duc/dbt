select count(*) as record_count
from {{ ref('patient_cancer_risk') }}
having count(*) = 0