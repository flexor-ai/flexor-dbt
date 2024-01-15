{% macro flex_raw(flexor_id, flex_query) %}

{% set flex_function_project = var('flex_function_project', null) %}
{% set flex_function_dataset = var('flex_function_dataset', null) %}

{% if target.type == 'bigquery' %}
    {% if flex_function_project is not null and flex_function_dataset is not null %}
        {% set flex_function = '`' ~ flex_function_project ~ '.' ~ flex_function_dataset ~ '.FLEX' ~ '`' %}
    {% else %}
        {% set flex_function = 'FLEX' %}
    {% endif %}
    JSON_SET(
        {{ flex_function }}({{flexor_id}}, '{{flex_query}}'),
        '$.flexor_id', {{flexor_id}}
    )
{% elif target.type == 'snowflake' %}
    {% set flex_function = 'FLEX' %}
    {{ flex_function }}({{flexor_id}}, '{{flex_query}}')
{% else %}
    {% do exceptions.raise_compiler_error("FLEX supports only bigquery and snowflake") %}
{% endif %}

{% endmacro %}
