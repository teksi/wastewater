-------------------------------------------
/* CREATE roles - cluster initialisation */
-------------------------------------------
DO $$
DECLARE
    role text;
BEGIN
    FOREACH role IN ARRAY ARRAY['qgep_viewer', 'qgep_user', 'qgep_manager', 'qgep_sysadmin'] LOOP
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role) THEN
          EXECUTE format('CREATE ROLE %1$I NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION', role);
      END IF;
    END LOOP;
END
$$;
GRANT qgep_viewer TO qgep_user;
GRANT qgep_user TO qgep_manager;
GRANT qgep_manager TO qgep_sysadmin;
