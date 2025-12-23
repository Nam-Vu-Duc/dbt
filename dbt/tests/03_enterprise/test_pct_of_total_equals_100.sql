-- Test that pct_of_total_patients sums to 100
select *
from (
    select sum(pct_of_total_patients) as total_pct
    from {{ ref('patient_cancer_risk') }}
) agg
where total_pct <> 100
