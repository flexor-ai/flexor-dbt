{% macro category(flex_json) %}

{% if target.type == 'bigquery' %}
    JSON_VALUE({{flex_json}}, '$.category')
{% elif target.type == 'snowflake' %}
    JSON_VALUE({{flex_json}}, '$.category')
{% else %}
    {% do exceptions.raise_compiler_error("FLEX supports only bigquery and snowflake") %}
{% endif %}

{% endmacro %}
