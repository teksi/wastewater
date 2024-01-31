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
          EXECUTE format('CREATE ROLE %1$I_%2$I NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION', role,current_catalog);
      END IF;
    END LOOP;
    EXECUTE format('GRANT tww_viewer_%1$I TO tww_user_%1$I', current_catalog);
    EXECUTE format('GRANT tww_user_%1$I TO tww_manager_%1$I', current_catalog);
    EXECUTE format('GRANT tww_manager_%1$I TO tww_sysadmin_%1$I', current_catalog);

    -- cascade database-specific grants to overall roles
    EXECUTE format('GRANT tww_viewer_%1$I TO tww_viewer', current_catalog);
    EXECUTE format('GRANT tww_user_%1$I TO tww_user', current_catalog);
    EXECUTE format('GRANT tww_manager_%1$I TO tww_manager', current_catalog);
    EXECUTE format('GRANT tww_sysadmin_%1$I TO tww_sysadmin', current_catalog);
END
$$;

------------------------------------------
/* GRANT on schemas - once per database */
------------------------------------------

/* Viewer */
DO
$$
BEGIN
EXECUTE format('
GRANT USAGE ON SCHEMA tww_od  TO tww_viewer_%1$I;
GRANT USAGE ON SCHEMA tww_sys TO tww_viewer_%1$I;
GRANT USAGE ON SCHEMA tww_vl  TO tww_viewer_%1$I;
GRANT USAGE ON SCHEMA tww_cfg  TO tww_viewer_%1$I;
GRANT USAGE ON SCHEMA tww_app  TO tww_viewer_%1$I;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_od  TO tww_viewer_%1$I;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_sys TO tww_viewer_%1$I;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_vl  TO tww_viewer_%1$I;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_cfg  TO tww_viewer_%1$I;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_app  TO tww_viewer_%1$I;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_od  TO tww_viewer_%1$I;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_sys TO tww_viewer_%1$I;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_vl  TO tww_viewer_%1$I;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_cfg  TO tww_viewer_%1$I;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_app  TO tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_cfg  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer_%1$I;

/* User */
GRANT ALL ON SCHEMA tww_od TO tww_user_%1$I;
GRANT ALL ON ALL TABLES IN SCHEMA tww_od TO tww_user_%1$I;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_od TO tww_user_%1$I;
GRANT ALL ON ALL TABLES IN SCHEMA tww_cfg TO tww_user_%1$I;
GRANT ALL ON SCHEMA tww_app TO tww_user_%1$I;
GRANT ALL ON ALL TABLES IN SCHEMA tww_app TO tww_user_%1$I;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_app TO tww_user_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od GRANT ALL ON TABLES TO tww_user_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od GRANT ALL ON SEQUENCES TO tww_user_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON TABLES TO tww_user_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON SEQUENCES TO tww_user_%1$I;
GRANT CREATE ON DATABASE %1$I TO "tww_user_%1$I";  -- required for ili2pg imports/exports

/* Manager */
GRANT ALL ON SCHEMA tww_vl TO tww_manager_%1$I;
GRANT ALL ON ALL TABLES IN SCHEMA tww_vl TO tww_manager_%1$I;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_vl TO tww_manager_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl GRANT ALL ON TABLES TO tww_manager_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl GRANT ALL ON SEQUENCES TO tww_manager_%1$I;

/* SysAdmin */
GRANT ALL ON SCHEMA tww_sys TO tww_sysadmin_%1$I;
GRANT ALL ON ALL TABLES IN SCHEMA tww_sys TO tww_sysadmin_%1$I;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_sys TO tww_sysadmin_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT ALL ON TABLES TO tww_sysadmin_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT ALL ON SEQUENCES TO tww_sysadmin_%1$I;

/*
-- Revoke

REVOKE ALL ON SCHEMA tww_od  FROM tww_viewer_%1$I;
REVOKE ALL ON SCHEMA tww_sys FROM tww_viewer_%1$I;
REVOKE ALL ON SCHEMA tww_vl  FROM tww_viewer_%1$I;
REVOKE ALL ON SCHEMA tww_app  FROM tww_viewer_%1$I;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_od  FROM tww_viewer_%1$I;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_sys FROM tww_viewer_%1$I;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_vl  FROM tww_viewer_%1$I;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_app  FROM tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od  REVOKE ALL ON TABLES  FROM tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys REVOKE ALL ON TABLES  FROM tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl  REVOKE ALL ON TABLES  FROM tww_viewer_%1$I;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app REVOKE ALL ON TABLES  FROM tww_viewer_%1$I;
*/
',current_catalog);
END
$$;
