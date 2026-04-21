DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT
            rel.relname AS table_name
        FROM pg_class rel
        JOIN pg_namespace nsp
            ON nsp.oid = rel.relnamespace
        JOIN pg_attribute att
            ON att.attrelid = rel.oid
        WHERE rel.relkind IN ('r', 'p')
        AND nsp.nspname = 'tww_od'
        AND att.attname = 'obj_id'
        AND NOT EXISTS (
            SELECT 1
            FROM pg_constraint con
            JOIN pg_attribute att_fk
                ON att_fk.attrelid = con.conrelid
                AND att_fk.attnum = ANY (con.conkey)
            WHERE con.contype = 'f'
                AND con.conrelid = rel.oid
                AND att_fk.attname = 'obj_id'
        )
    LOOP
        EXECUTE format(
            '
            ALTER TABLE tww_od.%I ADD COLUMN IF NOT EXISTS uuidoid uuid DEFAULT gen_random_uuid();
            ',
            r.relname
        );
        EXECUTE format(
            'UPDATE tww_od.%I
             SET uuidoid = gen_random_uuid()
             WHERE uuidoid IS NULL;
             ',
            r.relname
        );
    END LOOP;
END $$;
