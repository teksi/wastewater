------------------------------------------
/* GRANT on schema - once per database */
------------------------------------------

/* User */
GRANT ALL ON SCHEMA {ext_schema} TO tww_user;
GRANT ALL ON ALL TABLES IN SCHEMA {ext_schema} TO tww_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA {ext_schema} TO tww_user;
GRANT ALL ON ALL TABLES IN SCHEMA tww_cfg TO tww_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema} GRANT ALL ON TABLES TO tww_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema} GRANT ALL ON SEQUENCES TO tww_user;

/*
-- Revoke
REVOKE ALL ON SCHEMA {ext_schema}  FROM tww_user;
REVOKE ALL ON ALL TABLES IN SCHEMA {ext_schema}  FROM tww_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema}  REVOKE ALL ON TABLES  FROM tww_user;

*/
