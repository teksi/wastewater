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
