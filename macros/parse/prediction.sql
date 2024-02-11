{% macro prediction(flex_json) %}

{% if target.type == 'bigquery' %}
    IFNULL(BOOL({{flex_json}}.answer), IFNULL(JSON_VALUE({{flex_json}}, '$.category'), JSON_VALUE({{flex_json}}, '$.extraction')) is not null)
{% elif target.type == 'snowflake' %}
    IFNULL({{flex_json}}:prediction, TO_BOOLEAN({{flex_json}}:category IS NOT NULL OR {{flex_json}}:extraction IS NOT NULL))
{% else %}
    {% do exceptions.raise_compiler_error("FLEX supports only bigquery and snowflake") %}
{% endif %}

{% endmacro %}
