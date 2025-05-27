DO $$
DECLARE
    role text;
BEGIN
    FOREACH role IN ARRAY ARRAY['tww_viewer', 'tww_user', 'tww_manager', 'tww_sysadmin'] LOOP
      DROP ROLE IF EXISTS role;
    END LOOP;
END
$$;
