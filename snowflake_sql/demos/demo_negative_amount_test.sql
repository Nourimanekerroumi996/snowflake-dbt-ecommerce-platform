-- =============================================================================
-- demo_negative_amount_test.sql
-- Shows the custom test assert_no_negative_amount catching bad data
--
-- Steps:
--   1. Run the INSERT below (order with a negative amount)
--   2. dbt test --select assert_no_negative_amount  -> FAIL 1
--   3. Run the DELETE below (cleanup)
--   4. dbt test --select assert_no_negative_amount  -> PASS
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE ECOMMERCE_WH;

-- Step 1: inject a bad record
INSERT INTO ECOMMERCE_DB.RAW.orders
VALUES ('O12', 'C2', 'P1', '2024-01-12', -50.00);

-- Step 3: cleanup
DELETE FROM ECOMMERCE_DB.RAW.orders WHERE order_id = 'O12';
