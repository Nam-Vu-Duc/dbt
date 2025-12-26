select *
from {{ source('raw', 'fhir_patients') }}
where air_pollution <= 0
  or alcohol_use <= 0
  or dust_allergy <= 0
  or smoking <= 0
  or passive_smoker <= 0
  or fatigue <= 0