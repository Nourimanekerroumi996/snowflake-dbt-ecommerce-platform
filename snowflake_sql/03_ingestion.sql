-- =============================================================================
-- 03_ingestion.sql
-- Internal stage, file formats, RAW tables and loading with COPY INTO
--
-- Run as: DATA_ENGINEER
-- Source files: ../data/ (customers.csv, products.csv, orders.csv, events.json)
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE ECOMMERCE_WH;
USE SCHEMA ECOMMERCE_DB.RAW;

-- -----------------------------------------------------------------------------
-- 1. Internal stage
-- -----------------------------------------------------------------------------
CREATE STAGE IF NOT EXISTS ecom_stage
  COMMENT = 'Internal stage for e-commerce source files (CSV/JSON)';

-- Upload the files to the stage, either:
--   a) Snowsight UI: Catalog > ECOMMERCE_DB > RAW > Stages > ECOM_STAGE > + Files
--   b) SnowSQL / Snowflake CLI, from the repository root:
--      PUT file://data/customers.csv @ECOMMERCE_DB.RAW.ecom_stage AUTO_COMPRESS=FALSE;
--      PUT file://data/products.csv  @ECOMMERCE_DB.RAW.ecom_stage AUTO_COMPRESS=FALSE;
--      PUT file://data/orders.csv    @ECOMMERCE_DB.RAW.ecom_stage AUTO_COMPRESS=FALSE;
--      PUT file://data/events.json   @ECOMMERCE_DB.RAW.ecom_stage AUTO_COMPRESS=FALSE;

LIST @ecom_stage;

-- -----------------------------------------------------------------------------
-- 2. File formats
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE                         = 'CSV'
  FIELD_DELIMITER              = ','
  SKIP_HEADER                  = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF                      = ('', 'NULL')
  EMPTY_FIELD_AS_NULL          = TRUE;

-- events.json is newline-delimited JSON (one object per line)
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON';

-- -----------------------------------------------------------------------------
-- 3. RAW tables (column order matches the source files)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id  VARCHAR,
    name         VARCHAR,
    country      VARCHAR
);

CREATE TABLE IF NOT EXISTS products (
    product_id   VARCHAR,
    name         VARCHAR,
    category     VARCHAR
);

CREATE TABLE IF NOT EXISTS orders (
    order_id     VARCHAR,
    customer_id  VARCHAR,
    product_id   VARCHAR,
    order_date   DATE,
    amount       NUMBER(10, 2)
);

-- Semi-structured data kept as-is in a VARIANT column; parsed in dbt staging
CREATE TABLE IF NOT EXISTS events (
    raw_data     VARIANT
);

-- -----------------------------------------------------------------------------
-- 4. Load with COPY INTO
--    Snowflake tracks loaded files: re-running skips them (no duplicates).
-- -----------------------------------------------------------------------------
COPY INTO customers FROM @ecom_stage FILES = ('customers.csv') FILE_FORMAT = (FORMAT_NAME = 'csv_format');
COPY INTO products  FROM @ecom_stage FILES = ('products.csv')  FILE_FORMAT = (FORMAT_NAME = 'csv_format');
COPY INTO orders    FROM @ecom_stage FILES = ('orders.csv')    FILE_FORMAT = (FORMAT_NAME = 'csv_format');
COPY INTO events    FROM @ecom_stage FILES = ('events.json')   FILE_FORMAT = (FORMAT_NAME = 'json_format');

-- -----------------------------------------------------------------------------
-- Checks (expected: customers 5, products 4, orders 10, events 6)
-- -----------------------------------------------------------------------------
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders',   COUNT(*) FROM orders
UNION ALL SELECT 'events',   COUNT(*) FROM events;
