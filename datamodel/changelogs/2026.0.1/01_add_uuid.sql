DO $$
DECLARE
    tbl text;
    is_child boolean;
BEGIN
    FOR tbl IN
        SELECT c.table_name
        FROM information_schema.columns c
        LEFT JOIN information_schema.tables t
            ON c.table_name = t.table_name
            AND c.table_schema = t.table_schema
        WHERE c.column_name = 'obj_id'
            AND c.table_schema = 'tww_od'
            AND t.table_type = 'BASE TABLE'
    LOOP
        -- Check if the table is a child in any foreign key relationship
        SELECT EXISTS (
            SELECT 1
            FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
            WHERE tc.constraint_type = 'FOREIGN KEY'
                AND tc.table_schema = 'tww_od'
                AND kcu.column_name = 'obj_id'
                AND kcu.table_name = tbl
        ) INTO is_child;

        -- Only add uuidoid if the table is not a child
        IF NOT is_child THEN
            EXECUTE format('ALTER TABLE tww_od.%I ADD COLUMN IF NOT EXISTS uuidoid uuid DEFAULT uuid_generate_v4()', tbl);
            EXECUTE format('UPDATE tww_od.%I SET uuidoid = uuid_generate_v4() WHERE uuidoid IS NULL', tbl);
        END IF;
    END LOOP;
END $$;