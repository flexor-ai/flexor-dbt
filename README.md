
# Flexor's dbt Core Package For Transforming Unstructured Data
<p align="center">
   <img alt="GitHub License" src="https://img.shields.io/github/license/flexor-ai/dbt-zendesk">
   <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" />
   <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" />
</p>

> 💡 Note: This package is meant to be run by [Flexor](https://flexor.ai) users in order to transform unstructured data (such as [ZenDesk tickets](https://github.com/flexor-ai/dbt-zendesk), [Steam  Reviews](https://github.com/flexor-ai/dbt-steam-example) and more) into structued data in dbt. If you found us on GitHub, please contact us at hello@flexor.ai to get access! 

## 📣 What does this dbt package do?

Flexor is an [Unstructured Transformation Layer](https://flexor.ai/product/), that allows for the creation of gold-standard tables from unstructured data by performing transformations on the raw text.

This package is meant to help Flexor users who are also dbt users perform `flex` transformations as part of dbt models. The package contains `flexor` macros that can be (re)used across dbt projects. The most useful is `flexor.flex` that allows to ask any question on ingested data.

Assuming your data is loaded into a data warehouse, for every ticket and ticket comment, the package exposes 3 types of data:
1. Data referenced from the source ordered by comment_timestamp (View).
2. Various `flex` transformations on the unstructured data.
   Each transformation is stored in a separate incremental table.
   The table columns are
 - flex json column (with the flex transformation results)
 - flex_id string column (used for joins)
3. Statistics on the ticket (Views).


## 🛠️ Supported Platforms
Flexor itself is agnostic, and can be run in any data warehouse - including Amazon Redshift, Google BigQuery, Snowflake, Vertica and more.

This package currently only supports 🧱Databricks and ❄️Snowflake, but more platforms are coming soon!

## 🎮 Example Project
To get a sense of how Flexor works with real data, take a look at the [Zendesk example project](https://github.com/flexor-ai/dbt-zendesk). 

Note that the ZenDesk package also contains our approach to **which questions you should ask** about your ZenDesk data, and the exact `flex` queries you should use to extract said information.

# Flexor Macros - A Breakdown

## `flex` Macros

### `flexor.flex`


Wraps `FLEX(flex_id, "flex_query")` db function to be more suitable for dbt.
Requires that `src_table` will have a "flex_id" column.

**Syntax:**

`flexor.flex(src_table, flex_query, cache_mode=True, online_mode=True) -> json`

**Example:**
```
flexor.flex(ref('train_review'), 'Is it slow?')
```

**Notes:**
* `cache_mode` - if set to false, even in incremental mode, re-run the query
* `online_mode` - if set to false, never run real transformation and use only incremental (cached) results

## Parse `flex` result macros

### flexor.answer
Converts classification results to boolean

**Syntax:**

`flexor.answer(flex_json) -> bool`  

**Example:**
```
flexor.answer(flexor.flex(ref('train_review'), 'Is it slow?'))
```

### flexor.category
Converts categorization results to a nullable string.

**Syntax:**

`flexor.category(flex_json) -> string | null`


### flexor.prediction
Converts prediction results to a nullable string.

**Syntax:**

`flexor.prediction(flex_json) -> string | null`

## Statistics Macros
Exploration macros - great for views to go over the data.

### flexor.prediction_statistics
Count and aggregates predictions of a `flexor.flex` model. Can split based on `reference_table_fields`


**Syntax:**

`flexor.prediction_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true)`

**Example:**
```
{{ flexor.prediction_statistics(ref('train_review_slow')) }}
```
**Another Example:**
```
{{ flexor.prediction_statistics(ref('train_review_slow'), ref('train_review'), ["year", "month"]) }}
```

### flexor.predictions_statistics

Count and aggregates predictions the of multiple `flexor.flex` models (including intersections). Can split based on `reference_table_fields`.

**Syntax:**

`flexor.predictions_statistics(flex_tables, reference_table=null, reference_table_fields=null)`

**Example:**
```
{{ flexor.predictions_statistics([
    ref('train_review_slow'),
    ref('train_review_fun')
]) }}
```

### flexor.categories_statistics

Count and aggregates categorization of a `flexor.flex` model. Can split based on `reference_table_fields`

**Syntax:**

`flexor.categories_statistics(flex_table, reference_table=null, reference_table_fields=null, filter_nulls=true)`


# 🔍 Does this package have dependencies?
No - but you should have acess to the [Flexor](https://flexor.ai) platform in order to use it. 

# 🙌 How is this package maintained and can I contribute?
The Flexor team actively maintains this package - if you have any questions or want to contribute, simply open a PR or email us at hello@flexor.ai.

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/flexor-ai/flexor-dbt/issues/new/choose) section and create an issue.
- If you want to learn more about Flexor, you can visit our website at [Flexor.ai](https://flexor.ai)
