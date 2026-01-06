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
