DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM tww_sys.oid_prefixes
        WHERE prefix = '{oid_prefix}'
        AND prefix != 'ch000000'
    ) THEN
        UPDATE tww_sys.oid_prefixes
        SET active = FALSE;

        INSERT INTO tww_sys.oid_prefixes (prefix, active)
        VALUES ('{oid_prefix}', TRUE);
    ELSIF '{oid_prefix}' != 'ch000000' THEN
        UPDATE tww_sys.oid_prefixes
        SET active = FALSE;

        UPDATE tww_sys.oid_prefixes
        SET active = TRUE
        WHERE prefix = '{oid_prefix}';
    ELSE NULL;
    END IF;
END
$$;