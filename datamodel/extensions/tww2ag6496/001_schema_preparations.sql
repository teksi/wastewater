CREATE SCHEMA IF NOT EXISTS {ext_schema};

GRANT ALL ON SCHEMA {ext_schema} TO postgres;

GRANT ALL ON SCHEMA {ext_schema} TO tww_user;

GRANT USAGE ON SCHEMA {ext_schema} TO tww_viewer;


ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema}
GRANT ALL ON TABLES TO tww_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema}
GRANT SELECT, TRIGGER, REFERENCES ON TABLES TO tww_viewer;

ALTER DEFAULT PRIVILEGES IN SCHEMA {ext_schema}

GRANT ALL ON SEQUENCES TO tww_user;