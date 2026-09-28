-- =============================================================================
-- 04_exploratory_analysis.sql
-- First look at the RAW data
--
-- Run as: DATA_ENGINEER (or any role with read access on RAW)
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE ECOMMERCE_WH;
USE SCHEMA ECOMMERCE_DB.RAW;

-- 1. Preview orders
SELECT *
FROM orders
ORDER BY order_date
LIMIT 10;

-- 2. Total revenue
SELECT SUM(amount) AS total_revenue
FROM orders;

-- 3. Top 5 best-selling products (by number of orders, then revenue)
SELECT
    p.product_id,
    p.name             AS product_name,
    p.category,
    COUNT(o.order_id)  AS nb_orders,
    SUM(o.amount)      AS revenue
FROM orders o
JOIN products p
  ON o.product_id = p.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY nb_orders DESC, revenue DESC
LIMIT 5;

-- 4. Parse JSON events
SELECT
    raw_data:user_id::STRING            AS user_id,
    raw_data:event_type::STRING         AS event_type,
    raw_data:timestamp::TIMESTAMP_NTZ   AS event_timestamp
FROM events
ORDER BY event_timestamp;
