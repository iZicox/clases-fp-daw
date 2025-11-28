-- =======================================================
-- create the HR schema user
-- =======================================================

CREATE USER hr IDENTIFIED BY oracle123
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
  TO hr;
