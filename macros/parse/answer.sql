{% macro answer(flex_json) %}

{% if target.type == 'bigquery' %}
    IFNULL(
        bool({{flex_json}}.answer),
        ( ({{flex_json}}.category is not null) or ({{flex_json}}.extraction is not null) )
    )
{% elif target.type == 'snowflake' %}
    ({{flex_json}}:answer)
{% else %}
    {% do exceptions.raise_compiler_error("FLEX supports only bigquery and snowflake") %}
{% endif %}

{% endmacro %}
