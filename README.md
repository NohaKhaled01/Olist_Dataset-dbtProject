# Olist Analytics — dbt Project

A dimensional model (star schema) built on the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) using **dbt** and **DuckDB**.

This project is a **dbt re-implementation** of an earlier analysis I built with MySQL + Power BI. The goal was to learn the modern analytics-engineering workflow — transforming raw data into clean, tested, documented models — using a dataset I already understood well, so the focus stayed on the **modeling and engineering** rather than on re-learning the data.

> **Companion project:** [Olist MySQL schema, profiling & EDA](https://github.com/NohaKhaled01/Olist_DataSet) — the original work where I loaded the raw data into MySQL, profiled it statistically, and investigated data-quality issues. That prior exploration is *why* the transformation decisions here (column renames, type casts, the translation gap, the geolocation grain) were already known going in.

---

## What this project demonstrates

- **Dimensional modeling (Kimball star schema):** fact and dimension separation, grain declaration, degenerate dimensions, role-playing date dimension.
- **Layered dbt architecture:** sources → staging → marts, with a clean DAG.
- **Testing:** generic tests (unique, not_null, relationships, accepted_values, accepted_range) plus composite-key uniqueness, validating grain and referential integrity across the whole star.
- **Documentation & lineage:** model/column descriptions and a generated lineage graph.
- **Reproducibility:** the entire warehouse rebuilds from raw CSVs with a single `dbt build`.

---

## Architecture

Raw Olist CSVs are loaded into a `raw` schema in DuckDB, then transformed through two dbt layers:

**Staging** (`models/staging/`) — one view per source table; cleans, renames, and casts types. Faithful 1:1 with sources.

**Marts** (`models/marts/`) — the star schema, materialized as tables:

| Dimensions | Facts |
|---|---|
| `dim_products` (products + category translation) | `fct_orderitems` (grain: one line item — the core sales fact) |
| `dim_customers` (customers + geolocation per zip) | `fct_orders` (grain: one order) |
| `dim_sellers` (sellers + geolocation per zip) | `fct_reviews` (grain: one review per order) |
| `dim_date` (generated calendar, 2016–2018) | |

![alt text](.\docs\Lineage Graph.png)

---

## Modeling notes & decisions

A few decisions worth calling out (more in the model descriptions):

- **Translation gap fix via seed:** a handful of product categories had no English translation. I added the missing rows as a curated **seed** (`seeds/`), keeping the relationship test honest.
- **Geolocation grain:** the raw geolocation table has many rows per zip code. It's collapsed to one row per zip (averaged lat/lng) *before* joining, to preserve dimension grain. Canonical city/state come from the customers/sellers tables to avoid the geolocation table's inconsistent spellings.
- **Missing geolocation:** ~278 customers have no coordinates (gaps in the Olist geolocation data). These are kept (LEFT JOIN) with null coordinates and a `has_geolocation` flag, rather than dropped or fabricated.
- **`item_count` on `fct_orders`:** an order-grain measure aggregated up from line items. Left null (not zero) for orders with no line items, so averages aren't skewed by false zeros.
- **Degenerate dimensions:** `order_id` is carried in the facts as a degenerate dimension (no `dim_orders`), used to group line items back to their parent order.

---

## Tech stack

- **dbt Core** (transformation)
- **DuckDB** (embedded analytical warehouse)
- **dbt_utils** (composite-key tests, date spine)
- *(Planned)* **Power BI** — connecting to the marts to reproduce the dashboards from the [original project](https://github.com/NohaKhaled01/Olist_DataSet), completing the raw → dbt → BI pipeline.

---

## How to run it

**Prerequisites:** Python 3.12.7, dbt Core with the DuckDB adapter.

```bash
# 1. Install dbt + DuckDB adapter
pip install dbt-duckdb
```

Note - Optional:
**Set up the connection.** 
Copy `profiles.example.yml` to `~/.dbt/profiles.yml` (Path on Windows: `C:\Users\<you>\.dbt\profiles.yml`), creating the `.dbt` folder if needed.
[This helps configure the paths, to make sure that the load_raw.sql file in step 4 loads the raw files in the correct database path]

```bash
# 2. Install package dependencies (dbt_utils)
dbt deps
```

**3. Get the data.** The raw CSVs aren't committed (they're ~120MB). Download the [Olist dataset from Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and place the CSVs in `olist_raw/`.

**4. Load the raw CSVs** into a `raw` schema in DuckDB.
From the project directory [the directory containing the dbt_project.yml], run:
```bash
duckdb dev.duckdb < load_raw.sql
```

**5. Build and test everything:**

```bash
dbt build
```

This runs the seed, all staging models, all marts, and every test in dependency order.

**6. View the docs and lineage graph:**

```bash
dbt docs generate
dbt docs serve
```

---

## Project structure

```
models/
  staging/    # one cleaned view per source table
  marts/      # star schema (dims + facts) + tests
seeds/        # curated product category translation
dbt_project.yml
packages.yml
```
