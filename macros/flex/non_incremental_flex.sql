{% macro non_incremental_flex(src_table, flex_query) %}

WITH flex_results AS (
    SELECT
        src.flexor_id,
        {{ flexor.flex_raw('src.flexor_id', '' ~ flex_query ~ '') }} as flex
    FROM
        {{ src_table }} src
)
SELECT
    flex_results.flexor_id,
    flex_results.flex
FROM flex_results
WHERE flex_results.flex IS NOT NULL

{% endmacro %}
