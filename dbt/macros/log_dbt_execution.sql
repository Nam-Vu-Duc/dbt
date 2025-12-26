{% macro log_dbt_execution(status='SUCCESS', rows_affected=0, model_name=none, schema_name=none) %}

    {% set model = model_name or this.name %}
    {% set schema = schema_name or this.schema %}

    {% set log_sql %}
        INSERT INTO adp_warehouse.monitoring.dbt_run_logs
        (
            model_name,
            schema_name,
            materialization,
            rows_affected,
            status,
            execution_time,
            dbt_version,
            run_uuid,
            created_at
        )
        VALUES 
        (
            '{{ model }}',                                      -- e.g., 'patients'
            '{{ schema }}',                                    -- e.g., 'refined'
            '{{ config.get('materialized', default='view') }}',     -- 'table', 'view', 'incremental', etc.
            {{ rows_affected }},                                    -- pass actual count when possible
            '{{ status }}',                                         -- 'SUCCESS' or 'FAILURE'
            SYSDATETIME(),                                          -- execution time
            '{{ dbt_version }}',                                    -- e.g., '1.8.0'
            '{{ invocation_id }}',                                  -- unique run ID
            SYSDATETIME()                                           -- when log was inserted
        )
    {% endset %}

    {% do run_query(log_sql) %}

{% endmacro %}