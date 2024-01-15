{% macro flex(src_table, flex_query, cache_mode=True, online_mode=True) %}

{% if online_mode %}
    {% set actual_online_mode = var('flex_online_mode', false) %}
{% else %}
    {% set actual_online_mode = false %}
{% endif %}

{% if cache_mode and actual_online_mode %}
    {{ flexor.incremental_flex(src_table, '' ~ flex_query ~ '') }}
{% elif cache_mode %}
    {{ flexor.readonly_flex(src_table, '' ~ flex_query ~ '') }}
{% elif actual_online_mode %}
    {{ flexor.non_incremental_flex(src_table, '' ~ flex_query ~ '') }}
{% else %}
    {% do exceptions.raise_compiler_error("Cannot set both online_mode and cache_mode to False.") %}
{% endif %}

{% endmacro %}
