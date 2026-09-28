-- =============================================================================
-- demo_incremental.sql
-- Shows that fct_orders_incremental only processes new rows
--
-- Steps:
--   1. dbt run --select fct_orders_incremental     (initial full load: 10 rows)
--   2. Run the INSERT below ONCE (a duplicate order_id makes the MERGE fail)
--   3. dbt run --select stg_orders fct_orders_incremental
--   4. Run the check: only the latest rows get a new dbt_loaded_at
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE ECOMMERCE_WH;

INSERT INTO ECOMMERCE_DB.RAW.orders
VALUES ('O11', 'C1', 'P4', '2024-01-11', 35.00);

SELECT order_id, order_date, amount, dbt_loaded_at
FROM ECOMMERCE_DB.MART.FCT_ORDERS_INCREMENTAL
ORDER BY dbt_loaded_at DESC, order_id;
