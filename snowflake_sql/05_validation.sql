-- =============================================================================
-- 05_validation.sql
-- Post-build checks: objects created by `dbt build`
--
-- Run as: DATA_ENGINEER, after `dbt build`
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE ECOMMERCE_WH;

-- 1. All dbt objects per layer (views in STAGING/INTERMEDIATE, tables in MART/SNAPSHOTS)
SELECT
    table_schema,
    table_name,
    table_type,
    row_count
FROM ECOMMERCE_DB.INFORMATION_SCHEMA.TABLES
WHERE table_schema IN ('STAGING', 'INTERMEDIATE', 'MART', 'SNAPSHOTS')
ORDER BY table_schema, table_name;

-- 2. Business outputs
SELECT * FROM ECOMMERCE_DB.MART.MART_REVENUE_BY_COUNTRY;
SELECT * FROM ECOMMERCE_DB.MART.MART_TOP_PRODUCTS;

-- 3. Incremental model: load timestamps show which rows each run processed
SELECT order_id, order_date, amount, dbt_loaded_at
FROM ECOMMERCE_DB.MART.FCT_ORDERS_INCREMENTAL
ORDER BY dbt_loaded_at DESC, order_id;

-- 4. Snapshot: current version of each customer, and full history
SELECT * FROM ECOMMERCE_DB.SNAPSHOTS.SNAP_CUSTOMERS WHERE dbt_valid_to IS NULL;

SELECT customer_id, name, country, dbt_valid_from, dbt_valid_to
FROM ECOMMERCE_DB.SNAPSHOTS.SNAP_CUSTOMERS
ORDER BY customer_id, dbt_valid_from;
