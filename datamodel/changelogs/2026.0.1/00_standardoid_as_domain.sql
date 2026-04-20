CREATE DOMAIN tww_od.interlis_standardoid AS text
CHECK (
    length(VALUE) = 16
    AND VALUE ~ '^[A-Za-z0-9]+$'
);


DO $$
DECLARE
    r record;
    cnt bigint;
BEGIN
    FOR r IN
        SELECT n.nspname, c.relname
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_attribute a ON a.attrelid = c.oid
        WHERE n.nspname = 'tww_od'
          AND c.relkind = 'r'
          AND a.attname = 'obj_id'
    LOOP
        EXECUTE format(
            'SELECT count(*) FROM %I.%I
             WHERE obj_id IS NULL
                OR length(obj_id) <> 16
                OR obj_id !~ ''^[A-Za-z0-9]{16}$''',
            r.nspname,
            r.relname
        ) INTO cnt;

        IF cnt > 0 THEN
            RAISE EXCEPTION
                USING
                    MESSAGE = format(
                        'Aborting upgrade: %I.%I has %s non-confore obj_id values.',
                        r.nspname,
                        r.relname,
                        cnt
                    ),
                    ERRCODE = 'check_violation';
        END IF;
    END LOOP;
END;
$$;



DO $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT
            n.nspname  AS schema_name,
            c.relname  AS table_name,
            a.attname  AS column_name
        FROM pg_attribute a
        JOIN pg_class c     ON c.oid = a.attrelid
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_type t      ON t.oid = a.atttypid
        WHERE n.nspname = 'tww_od'
          AND c.relkind = 'r'              -- ordinary tables only
          AND a.attname = 'obj_id'
          AND NOT a.attisdropped
          AND t.typname <> 'interlis_standardoid'
    LOOP
        RAISE NOTICE
            'Altering %.% (%)',
            r.schema_name,
            r.table_name,
            r.column_name;

        EXECUTE format(
            'ALTER TABLE %I.%I ALTER COLUMN %I TYPE tww_od.interlis_standardoid',
            r.schema_name,
            r.table_name,
            r.column_name
        );
    END LOOP;
END;
$$;
