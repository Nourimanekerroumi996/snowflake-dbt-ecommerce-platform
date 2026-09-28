-- =============================================================================
-- 02_infrastructure.sql
-- Database, medallion schemas, dedicated warehouse, analyst access
--
-- Run as: DATA_ENGINEER (objects are owned by this role)
-- Idempotent: safe to re-run
-- =============================================================================

USE ROLE DATA_ENGINEER;
USE WAREHOUSE COMPUTE_WH;

-- -----------------------------------------------------------------------------
-- 1. Dedicated warehouse with auto-suspend (cost control)
-- -----------------------------------------------------------------------------
CREATE WAREHOUSE IF NOT EXISTS ECOMMERCE_WH
  WAREHOUSE_SIZE      = 'XSMALL'
  AUTO_SUSPEND        = 60      -- suspend after 60s of inactivity
  AUTO_RESUME         = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT             = 'Compute for ingestion and dbt transformations';

USE WAREHOUSE ECOMMERCE_WH;

-- -----------------------------------------------------------------------------
-- 2. Database and medallion schemas
--    RAW          : raw data loaded as-is (COPY INTO)
--    STAGING      : cleaned, typed, renamed (dbt views)
--    INTERMEDIATE : joins and aggregations (dbt views)
--    MART         : business-ready tables (dbt tables)
--    SNAPSHOTS    : SCD type 2 history (created by dbt snapshot)
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ECOMMERCE_DB
  COMMENT = 'E-commerce data platform';

USE DATABASE ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS RAW          COMMENT = 'Raw data loaded from CSV/JSON files';
CREATE SCHEMA IF NOT EXISTS STAGING      COMMENT = 'dbt staging layer';
CREATE SCHEMA IF NOT EXISTS INTERMEDIATE COMMENT = 'dbt intermediate layer';
CREATE SCHEMA IF NOT EXISTS MART         COMMENT = 'dbt marts layer';

-- -----------------------------------------------------------------------------
-- 3. Read-only access for ANALYST on the MART layer
-- -----------------------------------------------------------------------------
GRANT USAGE  ON WAREHOUSE ECOMMERCE_WH           TO ROLE ANALYST;
GRANT USAGE  ON DATABASE  ECOMMERCE_DB           TO ROLE ANALYST;
GRANT USAGE  ON SCHEMA    ECOMMERCE_DB.MART      TO ROLE ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA ECOMMERCE_DB.MART TO ROLE ANALYST;

-- Future grants require MANAGE GRANTS: run as SECURITYADMIN
USE ROLE SECURITYADMIN;
GRANT SELECT ON FUTURE TABLES IN SCHEMA ECOMMERCE_DB.MART TO ROLE ANALYST;
GRANT SELECT ON FUTURE VIEWS  IN SCHEMA ECOMMERCE_DB.MART TO ROLE ANALYST;

-- -----------------------------------------------------------------------------
-- Checks
-- -----------------------------------------------------------------------------
USE ROLE DATA_ENGINEER;
SHOW WAREHOUSES LIKE 'ECOMMERCE_WH';
SHOW SCHEMAS IN DATABASE ECOMMERCE_DB;
