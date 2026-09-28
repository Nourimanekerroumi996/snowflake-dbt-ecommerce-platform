-- =============================================================================
-- demo_snapshot.sql
-- Shows SCD type 2 history in snap_customers
--
-- Steps:
--   1. dbt snapshot                                 (initial: 1 version per customer)
--   2. Run the UPDATE below (customer C1 moves from FR to MA)
--   3. dbt snapshot                                 (old version closed, new one added)
--   4. Run the check: C1 has 2 rows, the old one with dbt_valid_to filled
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE ECOMMERCE_WH;

UPDATE ECOMMERCE_DB.RAW.customers
SET country = 'MA'
WHERE customer_id = 'C1';

SELECT customer_id, name, country, dbt_valid_from, dbt_valid_to
FROM ECOMMERCE_DB.SNAPSHOTS.SNAP_CUSTOMERS
ORDER BY customer_id, dbt_valid_from;
