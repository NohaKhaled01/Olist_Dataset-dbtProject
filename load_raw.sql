-- Loads the 9 Olist CSVs into a `raw` schema in DuckDB.
-- Run from the project directory
-- CSVs must be in ./olist_raw/ (download from Kaggle - see README)

CREATE SCHEMA IF NOT EXISTS raw;

CREATE OR REPLACE TABLE raw.order     AS SELECT * FROM read_csv_auto('olist_raw/olist_orders_dataset.csv');
CREATE OR REPLACE TABLE raw.order_items AS SELECT * FROM read_csv_auto('olist_raw/olist_order_items_dataset.csv');
CREATE OR REPLACE TABLE raw.payments   AS SELECT * FROM read_csv_auto('olist_raw/olist_order_payments_dataset.csv');
CREATE OR REPLACE TABLE raw.reviews    AS SELECT * FROM read_csv_auto('olist_raw/olist_order_reviews_dataset.csv');
CREATE OR REPLACE TABLE raw.customers  AS SELECT * FROM read_csv_auto('olist_raw/olist_customers_dataset.csv');
CREATE OR REPLACE TABLE raw.products   AS SELECT * FROM read_csv_auto('olist_raw/olist_products_dataset.csv');
CREATE OR REPLACE TABLE raw.sellers    AS SELECT * FROM read_csv_auto('olist_raw/olist_sellers_dataset.csv');
CREATE OR REPLACE TABLE raw.geolocation AS SELECT * FROM read_csv_auto('olist_raw/olist_geolocation_dataset.csv');