-------------------------------------------
/* CREATE roles - cluster initialisation */
-------------------------------------------

GRANT USAGE ON SCHEMA tww_app  TO tww_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_app  TO tww_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_app  TO tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer;

GRANT ALL ON SCHEMA tww_app TO tww_user;
GRANT ALL ON ALL TABLES IN SCHEMA tww_app TO tww_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_app TO tww_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON TABLES TO tww_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON SEQUENCES TO tww_user;




-------------------------------------------
/* database-specific roles */
-------------------------------------------
DO
$$
BEGIN
	CASE WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tww_viewer_{db_identifier}') THEN
		GRANT USAGE ON SCHEMA tww_app  TO tww_viewer_{db_identifier};
		GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_app  TO tww_viewer_{db_identifier};
		GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_app  TO tww_viewer_{db_identifier};
		ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_{db_identifier};
	ELSE NULL;
	END CASE;
	CASE WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tww_user_{db_identifier}') THEN
		GRANT ALL ON SCHEMA tww_app TO tww_user_{db_identifier};
		GRANT ALL ON ALL TABLES IN SCHEMA tww_app TO tww_user_{db_identifier};
		GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_app TO tww_user_{db_identifier};
		ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON TABLES TO tww_user_{db_identifier};
		ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON SEQUENCES TO tww_user_{db_identifier};
	ELSE NULL;
	END CASE;
END;
$$
/*
-- Revoke

REVOKE ALL ON SCHEMA tww_app FROM tww_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_app FROM tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app REVOKE ALL ON TABLES FROM tww_viewer;
CASE WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tww_viewer_{db_identifier}') THEN
	REVOKE ALL ON SCHEMA tww_app FROM tww_viewer_{db_identifier};
	REVOKE ALL ON ALL TABLES IN SCHEMA tww_app FROM tww_viewer_{db_identifier};
	ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app REVOKE ALL ON TABLES FROM tww_user_{db_identifier};
END CASE;

*/
