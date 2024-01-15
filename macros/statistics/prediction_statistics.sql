{% macro prediction_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true) %}


{% if reference_table_fields and reference_table_fields|length > 0 %}
{% set group_by_fields = reference_table_fields|join(', ') %}
{% endif %}

WITH filtered_data AS (
    SELECT
        flex_table.flexor_id as flexor_id,
        {{ flexor.answer('flex_table.flex') }} as answer
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        {% for field in reference_table_fields %}
            , reference_table.{{ field }} as {{ field }}
        {% endfor %}
        {% endif %}
    FROM {{ flex_table }} as flex_table
    {% if reference_table %}
    JOIN {{ reference_table }} as reference_table
    ON reference_table.flexor_id = flex_table.flexor_id
    {% endif %}
    {% if filter_nulls %}
    WHERE {{ flexor.answer('flex') }} is not null
    {% endif %}
),
PredictionCounts AS (
    SELECT
        answer,
        COUNT(*) AS count
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        ,{{ group_by_fields }}
        {% endif %}
    FROM filtered_data
    GROUP BY
        answer
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        ,{{ group_by_fields }}
        {% endif %}
),
TotalCount AS (
    SELECT
        SUM(count) AS total_count
    FROM PredictionCounts
),
RelativeCount AS (
    SELECT
        SUM(count) AS relative_count
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        ,{{ group_by_fields }}
        {% endif %}
    FROM PredictionCounts
    {% if reference_table_fields and reference_table_fields|length > 0 %}
    GROUP BY {{ group_by_fields }}
    {% endif %}
)
SELECT 
    PredictionCounts.answer as answer,
    {% if reference_table_fields and reference_table_fields|length > 0 %}
    {% for field in reference_table_fields %}
        PredictionCounts.{{ field }} as {{ field }},
    {% endfor %}
    {% endif %}
    PredictionCounts.count as count,
    ROUND((PredictionCounts.count / TotalCount.total_count) * 100, 2) AS percentage,
    ROUND((PredictionCounts.count / RelativeCount.relative_count) * 100, 2) AS relative_percentage
FROM PredictionCounts, TotalCount
{% if reference_table_fields and reference_table_fields|length > 0 %}
JOIN RelativeCount
ON
{% for field in reference_table_fields %}
    {% if not loop.first %} AND {% endif %}
    PredictionCounts.{{ field }} = RelativeCount.{{ field }}
{% endfor %}
{% else %}
, RelativeCount 
{% endif %}
ORDER BY
{% if reference_table_fields and reference_table_fields|length > 0 %}
{{ group_by_fields }},
{% endif %}
    PredictionCounts.count DESC
{% endmacro %}
