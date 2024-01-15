{% macro incremental_flex(src_table, flex_query) %}

{% if not is_incremental() %}
    {{ non_incremental_flex(src_table, '' ~ flex_query ~ '') }}
{% else %}
    WITH new_ids AS (
        SELECT
            src.flexor_id as flexor_id
        FROM
            {{ src_table }} src
        LEFT OUTER JOIN {{ this }} cached
        ON src.flexor_id = cached.flexor_id
        WHERE cached.flexor_id IS NULL
    ),
    new_results AS (
        SELECT
            src.flexor_id,
            {{ flexor.flex_raw('src.flexor_id', flex_query) }} as flex
        FROM new_ids src
    )
    SELECT
        new_results.flexor_id as flexor_id,
        new_results.flex as flex
    FROM new_results
    WHERE new_results.flex IS NOT NULL
{% endif %}

{% endmacro %}
