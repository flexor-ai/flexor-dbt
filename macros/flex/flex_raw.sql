{% macro flex_raw(flexor_id, flex_query) %}

{% set flex_function_table = var('flex_function_table', var('flex_function_project', null)) %}
{% set flex_function_schema = var('flex_function_schema', var('flex_function_dataset', null)) %}

{% if target.type == 'bigquery' %}
    {% if flex_function_table is not null and flex_function_schema is not null %}
        {% set flex_function = '`' ~ flex_function_table ~ '.' ~ flex_function_schema ~ '.FLEX' ~ '`' %}
    {% else %}
        {% set flex_function = 'FLEX' %}
    {% endif %}
    JSON_SET(
        {{ flex_function }}({{flexor_id}}, '{{flex_query}}'),
        '$.flexor_id', {{flexor_id}}
    )
{% elif target.type == 'snowflake' %}
    {% if flex_function_table is not null and flex_function_schema is not null %}
        {% set flex_function = flex_function_table ~ '.' ~ flex_function_schema ~ '.FLEX' %}
    {% else %}
        {% set flex_function = 'FLEX' %}
    {% endif %}
    {{ flex_function }}({{flexor_id}}, '{{flex_query}}')
{% else %}
    {% do exceptions.raise_compiler_error("FLEX supports only bigquery and snowflake") %}
{% endif %}

{% endmacro %}
