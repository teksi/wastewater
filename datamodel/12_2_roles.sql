-------------------------------------------
/* CREATE roles - cluster initialisation */
-------------------------------------------
DO $$
DECLARE
    role text;
BEGIN
    FOREACH role IN ARRAY ARRAY['tww_viewer', 'tww_user', 'tww_manager', 'tww_sysadmin'] LOOP
      -- overall roles
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role) THEN
          EXECUTE format('CREATE ROLE %1$I NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION', role);
      END IF;
	  -- database-specific roles
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role||'_'||current_catalog) THEN
          EXECUTE format('CREATE ROLE %1$I_{db_identifier} NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION', role);
      END IF;
    END LOOP;
    GRANT tww_viewer_{db_identifier} TO tww_user_{db_identifier};
    GRANT tww_user_{db_identifier} TO tww_manager_{db_identifier};
    GRANT tww_manager_{db_identifier} TO tww_sysadmin_{db_identifier};

    -- cascade database-specific grants to overall roles
    GRANT tww_viewer_{db_identifier} TO tww_viewer;
    GRANT tww_user_{db_identifier} TO tww_user;
    GRANT tww_manager_{db_identifier} TO tww_manager;
    GRANT tww_sysadmin_{db_identifier} TO tww_sysadmin;
END
$$;

------------------------------------------
/* GRANT on schemas - once per database */
------------------------------------------

/* Viewer */

GRANT USAGE ON SCHEMA tww_od  TO tww_viewer_{db_identifier};
GRANT USAGE ON SCHEMA tww_sys TO tww_viewer_{db_identifier};
GRANT USAGE ON SCHEMA tww_vl  TO tww_viewer_{db_identifier};
GRANT USAGE ON SCHEMA tww_cfg  TO tww_viewer_{db_identifier};
GRANT USAGE ON SCHEMA tww_app  TO tww_viewer_{db_identifier};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_od  TO tww_viewer_{db_identifier};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_sys TO tww_viewer_{db_identifier};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_vl  TO tww_viewer_{db_identifier};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_cfg  TO tww_viewer_{db_identifier};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_app  TO tww_viewer_{db_identifier};
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_od  TO tww_viewer_{db_identifier};
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_sys TO tww_viewer_{db_identifier};
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_vl  TO tww_viewer_{db_identifier};
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_cfg  TO tww_viewer_{db_identifier};
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_app  TO tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_cfg  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_{db_identifier};

/* User */
GRANT ALL ON SCHEMA tww_od TO tww_user_{db_identifier};
GRANT ALL ON ALL TABLES IN SCHEMA tww_od TO tww_user_{db_identifier};
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_od TO tww_user_{db_identifier};
GRANT ALL ON ALL TABLES IN SCHEMA tww_cfg TO tww_user_{db_identifier};
GRANT ALL ON SCHEMA tww_app TO tww_user_{db_identifier};
GRANT ALL ON ALL TABLES IN SCHEMA tww_app TO tww_user_{db_identifier};
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_app TO tww_user_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od GRANT ALL ON TABLES TO tww_user_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od GRANT ALL ON SEQUENCES TO tww_user_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON TABLES TO tww_user_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON SEQUENCES TO tww_user_{db_identifier};
DO $$BEGIN EXECUTE FORMAT('GRANT CREATE ON DATABASE %1$I TO tww_user_{db_identifier}',current_catalog) ;END;$$  ;-- required for ili2pg imports/exports

/* Manager */
GRANT ALL ON SCHEMA tww_vl TO tww_manager_{db_identifier};
GRANT ALL ON ALL TABLES IN SCHEMA tww_vl TO tww_manager_{db_identifier};
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_vl TO tww_manager_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl GRANT ALL ON TABLES TO tww_manager_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl GRANT ALL ON SEQUENCES TO tww_manager_{db_identifier};

/* SysAdmin */
GRANT ALL ON SCHEMA tww_sys TO tww_sysadmin_{db_identifier};
GRANT ALL ON ALL TABLES IN SCHEMA tww_sys TO tww_sysadmin_{db_identifier};
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_sys TO tww_sysadmin_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT ALL ON TABLES TO tww_sysadmin_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT ALL ON SEQUENCES TO tww_sysadmin_{db_identifier};

/*
-- Revoke

REVOKE ALL ON SCHEMA tww_od  FROM tww_viewer_{db_identifier};
REVOKE ALL ON SCHEMA tww_sys FROM tww_viewer_{db_identifier};
REVOKE ALL ON SCHEMA tww_vl  FROM tww_viewer_{db_identifier};
REVOKE ALL ON SCHEMA tww_app  FROM tww_viewer_{db_identifier};
REVOKE ALL ON ALL TABLES IN SCHEMA tww_od  FROM tww_viewer_{db_identifier};
REVOKE ALL ON ALL TABLES IN SCHEMA tww_sys FROM tww_viewer_{db_identifier};
REVOKE ALL ON ALL TABLES IN SCHEMA tww_vl  FROM tww_viewer_{db_identifier};
REVOKE ALL ON ALL TABLES IN SCHEMA tww_app  FROM tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od  REVOKE ALL ON TABLES  FROM tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys REVOKE ALL ON TABLES  FROM tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl  REVOKE ALL ON TABLES  FROM tww_viewer_{db_identifier};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app REVOKE ALL ON TABLES  FROM tww_viewer_{db_identifier};
*/
