{% macro readonly_flex(src_table, flex_query) %}

{% if not is_incremental() %}
   SELECT
        '' as flexor_id,
        JSON '{}' as flex
    FROM
        {{ src_table }} src
    WHERE 1 = 0
{% else %}
    SELECT
        cached.flexor_id as flexor_id,
        cached.flex as flex
    FROM
        {{ src_table }} src
    JOIN {{ this }} cached
    ON src.flexor_id = cached.flexor_id
{% endif %}

{% endmacro %}
