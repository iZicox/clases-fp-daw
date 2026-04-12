-- =======================================================
-- create the HR schema user
-- =======================================================

CREATE USER dulces IDENTIFIED BY 123
               QUOTA UNLIMITED ON USERS;

GRANT CREATE MATERIALIZED VIEW,
      CREATE PROCEDURE,
      CREATE SEQUENCE,
      CREATE SESSION,
      CREATE SYNONYM,
      CREATE TABLE,
      CREATE TRIGGER,
      CREATE TYPE,
      CREATE VIEW
  TO HR_VM;

