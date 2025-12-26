-- Test that pct_of_total_patients sums to 100
select *
from (
    select sum(pct_of_total_patients) as total_pct
    from {{ ref('enterprise_patients') }}
) agg
where total_pct = 100
