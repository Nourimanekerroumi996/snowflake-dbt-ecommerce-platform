-- =============================================================================
-- 01_security.sql
-- Roles, service user and account-level privileges (RBAC)
--
-- Run as: ACCOUNTADMIN
-- Idempotent: safe to re-run
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- -----------------------------------------------------------------------------
-- 1. Functional roles
--    DATA_ENGINEER : builds and owns the data platform (DB, schemas, tables)
--    ANALYST       : read-only access to the MART layer
-- -----------------------------------------------------------------------------
CREATE ROLE IF NOT EXISTS DATA_ENGINEER
  COMMENT = 'Builds and maintains the e-commerce data platform';

CREATE ROLE IF NOT EXISTS ANALYST
  COMMENT = 'Read-only access to business-ready MART tables';

-- Attach custom roles to SYSADMIN (Snowflake best practice: no orphan roles)
GRANT ROLE DATA_ENGINEER TO ROLE SYSADMIN;
GRANT ROLE ANALYST       TO ROLE SYSADMIN;

-- -----------------------------------------------------------------------------
-- 2. Default compute (COMPUTE_WH is not created by default on recent accounts)
-- -----------------------------------------------------------------------------
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
  WAREHOUSE_SIZE      = 'XSMALL'
  AUTO_SUSPEND        = 60
  AUTO_RESUME         = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- -----------------------------------------------------------------------------
-- 3. Data engineer user (used by dbt)
--    Replace <YOUR_PASSWORD> before running. Never commit real credentials.
-- -----------------------------------------------------------------------------
CREATE USER IF NOT EXISTS DBT_ENGINEER_USER
  PASSWORD             = '<YOUR_PASSWORD>'
  DEFAULT_ROLE         = DATA_ENGINEER
  DEFAULT_WAREHOUSE    = COMPUTE_WH
  MUST_CHANGE_PASSWORD = FALSE
  COMMENT              = 'User for data engineering work and dbt runs';

GRANT ROLE DATA_ENGINEER TO USER DBT_ENGINEER_USER;

-- -----------------------------------------------------------------------------
-- 4. Account-level privileges for DATA_ENGINEER
--    DATA_ENGINEER then creates (and therefore owns) all platform objects.
-- -----------------------------------------------------------------------------
GRANT CREATE DATABASE  ON ACCOUNT       TO ROLE DATA_ENGINEER;
GRANT CREATE WAREHOUSE ON ACCOUNT       TO ROLE DATA_ENGINEER;
GRANT USAGE            ON WAREHOUSE COMPUTE_WH TO ROLE DATA_ENGINEER;

-- -----------------------------------------------------------------------------
-- Checks
-- -----------------------------------------------------------------------------
SHOW ROLES LIKE '%ENGINEER%';
SHOW GRANTS TO USER DBT_ENGINEER_USER;
SHOW GRANTS TO ROLE DATA_ENGINEER;
