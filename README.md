# Flexor dbt

# What does this project do?
This dbt package contains `flexor` macros that can be (re)used across dbt projects. The most useful is `flexor.flex` that allows to ask any question on ingested data,

## Supports:
* Bigquery
* Snowflake (upcoming - February)

# How to start?

Jump to the example [Steam](https://github.com/flexor-ai/dbt-steam-example) project - read & run it.

## Example project
* [Steam](https://github.com/flexor-ai/dbt-steam-example) with data
* [Zendesk](https://github.com/flexor-ai/dbt-zendesk)

# macros

## flex Macros

### flexor.flex
`flexor.flex(src_table, flex_query, cache_mode=True, online_mode=True) -> json`

Wraps `FLEX(flex_id, "flex_query")` db function to be more suitable for dbt.
Requires that `src_table` will have a "flex_id" column.

Example:
```
flexor.flex(ref('train_review'), 'Is it slow?')
```
* `cache_mode` - if set to false, even in incremental mode, re-run the query
* `online_mode` - if set to false, never run real transformation and use only incremental (cached) results

## Prase flex result macros

### flexor.answer
`flexor.answer(flex_json) -> bool`  
Converts classification results to boolean

Example:
```
flexor.answer(flexor.flex(ref('train_review'), 'Is it slow?'))
```

### flexor.category
`flexor.category(flex_json) -> string | null`
Converts categorization results to nullable string

### flexor.prediction
`flexor.prediction(flex_json) -> string | null`
Converts prediction results to nullable string

## Statistics Macros
Exploration macros - great for views to go over the data

### flexor.prediction_statistics
`flexor.prediction_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true)`

Count and aggregates predictions of a `flexor.flex` model. Can split based on `reference_table_fields`

Examples:
```
{{ flexor.prediction_statistics(ref('train_review_slow')) }}
```
```
{{ flexor.prediction_statistics(ref('train_review_slow'), ref('train_review'), ["year", "month"]) }}
```

### flexor.predictions_statistics
`flexor.predictions_statistics(flex_tables, reference_table=null, reference_table_fields=null)`

Count and aggregates predictions the of multiple `flexor.flex` models (including intersections). Can split based on `reference_table_fields`

Example:
```
{{ flexor.predictions_statistics([
    ref('train_review_slow'),
    ref('train_review_fun')
]) }}
```

### flexor.categories_statistics
`flexor.categories_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true)`

Count and aggregates categorization of a `flexor.flex` model. Can split based on `reference_table_fields`

# Internal Macros
Those Macros are used internally by `flexor.flex` to support incremental and online modes.
There are no reason to use them.
### flexor.flex_raw(flexor_id, flex_query)

### flexor.incremental_flex(src_table, flex_query)

### flexor.incremental_flex(src_table, flex_query)

### flexor.non_incremental_flex(src_table, flex_query)

### readonly_flex(src_table, flex_query)
