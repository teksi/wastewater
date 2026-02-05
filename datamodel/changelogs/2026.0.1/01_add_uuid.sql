DO
$BODY$
DECLARE
    tbl text;
BEGIN
	FOR tbl IN
	SELECT
       c.table_name
    FROM information_schema.columns c
	LEFT JOIN information_schema.tables t
	ON c.table_name = t.table_name
      AND c.table_schema = t.table_schema
    WHERE c.column_name ='obj_id'
      AND c.table_schema ='tww_od'
	  AND t.table_type = 'BASE TABLE'
    LOOP
        EXECUTE format($$ ALTER TABLE tww_od.%I ADD COLUMN IF NOT EXISTS uuidoid uuid DEFAULT uuid_generate_v4() $$, tbl);
        EXECUTE format($$ UPDATE tww_od.%I SET uuidoid = uuid_generate_v4() WHERE uuidoid IS NULL$$, tbl);
    END LOOP;

END;
$BODY$

DO $$
DECLARE
    fk_record RECORD;
BEGIN
    FOR fk_record IN
        SELECT
            kcu.table_name AS child,
            ccu.table_name AS parent
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
            ON tc.constraint_name = kcu.constraint_name
            AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
            AND tc.table_schema = ccu.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
            AND tc.table_schema = 'tww_od'
            AND kcu.column_name = 'obj_id'
            AND ccu.column_name = 'obj_id'
    LOOP
        -- Overwrite child's uuidoid with parent's uuidoid
        EXECUTE format('
            UPDATE tww_od.%I child
            SET uuidoid = parent.uuidoid
            FROM tww_od.%I pparent
            WHERE child.obj_id = parent.obj_id',
            fk_record.child, fk_record.parent
        );
    END LOOP;
END $$;
