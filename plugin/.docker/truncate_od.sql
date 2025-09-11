DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'tww_od'
    LOOP
        EXECUTE 'TRUNCATE TABLE tww_od.' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;
