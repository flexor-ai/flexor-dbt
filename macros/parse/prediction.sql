{% macro prediction(flex_json) %}

{% if target.type == 'bigquery' %}
    IFNULL(BOOL({{flex_json}}.answer), IFNULL(JSON_VALUE({{flex_json}}, '$.category'), JSON_VALUE({{flex_json}}, '$.extraction')) is not null)
{% elif target.type == 'snowflake' %}
    IFNULL(BOOL({{flex_json}}.answer), IFNULL(JSON_VALUE({{flex_json}}, '$.category'), JSON_VALUE({{flex_json}}, '$.extraction')) is not null)
{% else %}
    {% do exceptions.raise_compiler_error("FLEX supports only bigquery and snowflake") %}
{% endif %}

{% endmacro %}
