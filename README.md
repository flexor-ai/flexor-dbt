# Flexor dbt

# What does this examples do?
This dbt package contains  `flexor` macros that can be (re)used across dbt projects

# Example project?
* [Steam Example](https://github.com/flexor-ai/dbt-steam-example)

# Useful macros

## Wrap flex Macros

### flexor.flex(src_table, flex_query, cache_mode=True, online_mode=True)

## Prase flex result Macros

### flexor.answer(flex_json)

### flexor.category(flex_json)

### flexor.prediction(flex_json)

## Statistics Macros

### flexor.categories_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true)

### flexor.prediction_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true)

### flexor.predictions_statistics(flex_tables, reference_table=null, reference_table_fields=null)

# Other Macros

## Wrap flex Macros

### flexor.flex_raw(flexor_id, flex_query)

### flexor.incremental_flex(src_table, flex_query)

### flexor.incremental_flex(src_table, flex_query)

### flexor.non_incremental_flex(src_table, flex_query)

### readonly_flex(src_table, flex_query)
