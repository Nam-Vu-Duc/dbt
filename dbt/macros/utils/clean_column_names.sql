{% macro clean_column_name(column_name) %}
  {{ return(column_name | replace(" ", "_") | replace(".", "") | lower) }}
{% endmacro %}