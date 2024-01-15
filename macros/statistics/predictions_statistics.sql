{% macro predictions_statistics(flex_tables, reference_table=null, reference_table_fields=null) %}


{% if reference_table_fields and reference_table_fields|length > 0 %}
{% set group_by_fields = reference_table_fields|join(', ') %}
{% endif %}

WITH filtered_data AS (
    SELECT
        {% for flex_table in flex_tables %}
            {{flexor.answer(flex_table.name ~ '_table.flex')}} as {{ flex_table.name }},
        {% endfor %}
        {{ flex_tables[0].name }}_table.flexor_id as flexor_id
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        {% for field in reference_table_fields %}
            , reference_table.{{ field }} as {{ field }}
        {% endfor %}
        {% endif %}
    FROM {{ flex_tables[0] }} as {{ flex_tables[0].name }}_table
    {% if reference_table %}
    JOIN {{ reference_table }} as reference_table
    ON reference_table.flexor_id = {{ flex_tables[0].name }}_table.flexor_id
    {% endif %}
    {% for flex_table in flex_tables %}
        {% if not loop.first %}
            JOIN {{ flex_table }} as {{ flex_table.name }}_table
            ON {{ flex_table.name }}_table.flexor_id = {{ flex_tables[0].name }}_table.flexor_id
        {% endif %}
    {% endfor %}
),
PredictionCounts AS (
    SELECT
        {% for flex_table in flex_tables %}
            {{flex_table.name}},
        {% endfor %}
        COUNT(*) AS count
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        ,{{ group_by_fields }}
        {% endif %}
    FROM filtered_data
    GROUP BY
        {% for flex_table in flex_tables %}
            {% if not loop.first %}, {% endif %} {{flex_table.name}}
        {% endfor %}
        {% if reference_table_fields and reference_table_fields|length > 0 %}
        , {{ group_by_fields }}
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
    {% for flex_table in flex_tables %}
        PredictionCounts.{{flex_table.name}} as {{flex_table.name}},
    {% endfor %}
    {% if reference_table_fields and reference_table_fields|length > 0 %}
    {% for field in reference_table_fields %}
        PredictionCounts.{{ field }} as {{ field }},
    {% endfor %}
    {% endif %}
    PredictionCounts.count as count,
    ROUND((PredictionCounts.count / TotalCount.total_count) * 100, 2) AS percentage
    {% if reference_table_fields and reference_table_fields|length > 0 %},
    ROUND((PredictionCounts.count / RelativeCount.relative_count) * 100, 2) AS relative_percentage
    {% endif %}
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
