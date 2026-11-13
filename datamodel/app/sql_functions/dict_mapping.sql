CREATE OR REPLACE FUNCTION tww_app.fct_validate_dict_mapping_jsonb(
    mapping jsonb
)
RETURNS bool
LANGUAGE plpgsql
AS
$BODY$
DECLARE
    target_schema CONSTANT text := 'tww_od';

    allowed_effect_kinds text[] := ARRAY[
        'update_attribute',
        'enforce_exists',
        'enforce_not_exists'
    ];

    effect jsonb;
    effect_kind text;

    identity jsonb;
    identity_attributes jsonb;

    target_table text;
    target_attribute text;

    target_table_oid oid;
    target_attribute_type regtype;

    id_key text;
    id_val jsonb;
    id_val_text text;
    identity_column_type regtype;

    value_json jsonb;
    value_text text;

    version_value integer;
BEGIN
    -------------------------------------------------------------------------
    -- Top-level contract checks
    -------------------------------------------------------------------------

    IF mapping IS NULL THEN
        RAISE EXCEPTION
            'dict mapping jsonb validation failed: mapping must not be NULL.';
    END IF;

    IF jsonb_typeof(mapping) <> 'object' THEN
        RAISE EXCEPTION
            'dict mapping jsonb validation failed: mapping must be a JSON object.';
    END IF;

    IF NOT mapping ? 'version' THEN
        RAISE EXCEPTION
            'dict mapping jsonb validation failed: mapping must contain field "version".';
    END IF;

    BEGIN
        version_value := (mapping ->> 'version')::integer;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: mapping.version must be an integer. Got: %',
                mapping -> 'version';
    END;

    IF version_value <> 1 THEN
        RAISE EXCEPTION
            'dict mapping jsonb validation failed: unsupported mapping version %. Expected 1.',
            version_value;
    END IF;

    IF NOT mapping ? 'effects'
       OR jsonb_typeof(mapping -> 'effects') <> 'array'
    THEN
        RAISE EXCEPTION
            'dict mapping jsonb validation failed: mapping.effects must be an array.';
    END IF;

    -------------------------------------------------------------------------
    -- Effect checks
    -------------------------------------------------------------------------

    FOR effect IN
        SELECT value
        FROM jsonb_array_elements(mapping -> 'effects')
    LOOP
        IF jsonb_typeof(effect) <> 'object' THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: each effect must be an object. Got: %',
                effect;
        END IF;

        effect_kind := effect ->> 'kind';

        IF effect_kind IS NULL
           OR NOT effect_kind = ANY(allowed_effect_kinds)
        THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: unsupported effect kind "%". Effect: %',
                effect_kind,
                effect;
        END IF;

        ---------------------------------------------------------------------
        -- Canonical identity checks
        ---------------------------------------------------------------------

        identity := effect -> 'identity';

        IF identity IS NULL
           OR jsonb_typeof(identity) <> 'object'
        THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: effect must contain object field identity. Effect: %',
                effect;
        END IF;

        target_table := identity ->> 'class_id';

        IF target_table IS NULL
           OR target_table = ''
        THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: identity.class_id must be set. Effect: %',
                effect;
        END IF;

        identity_attributes := identity -> 'attributes';

        IF identity_attributes IS NULL
           OR jsonb_typeof(identity_attributes) <> 'object'
           OR identity_attributes = '{{}}'::jsonb
        THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: identity.attributes must be a non-empty object. Effect: %',
                effect;
        END IF;

        ---------------------------------------------------------------------
        -- Target table checks
        ---------------------------------------------------------------------

        SELECT c.oid
        INTO target_table_oid
        FROM pg_class c
        JOIN pg_namespace n
            ON n.oid = c.relnamespace
        WHERE n.nspname = target_schema
          AND c.relname = target_table
          AND c.relkind IN ('r', 'p');

        IF target_table_oid IS NULL THEN
            RAISE EXCEPTION
                'dict mapping jsonb validation failed: target table %.% does not exist or is not a table.',
                target_schema,
                target_table;
        END IF;

        ---------------------------------------------------------------------
        -- Identity attribute checks
        ---------------------------------------------------------------------

        FOR id_key, id_val IN
            SELECT key, value
            FROM jsonb_each(identity_attributes)
        LOOP
            SELECT a.atttypid::regtype
            INTO identity_column_type
            FROM pg_attribute a
            WHERE a.attrelid = target_table_oid
              AND a.attname = id_key
              AND a.attnum > 0
              AND NOT a.attisdropped;

            IF identity_column_type IS NULL THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: identity column %.%.% does not exist.',
                    target_schema,
                    target_table,
                    id_key;
            END IF;

            IF jsonb_typeof(id_val) = 'null' THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: identity value for %.%.% must not be NULL.',
                    target_schema,
                    target_table,
                    id_key;
            END IF;

            IF jsonb_typeof(id_val) NOT IN (
                'string',
                'number',
                'boolean'
            ) THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: identity value for %.%.% must be scalar. Got: %',
                    target_schema,
                    target_table,
                    id_key,
                    id_val;
            END IF;

            id_val_text := id_val #>> '{{}}';

            BEGIN
                EXECUTE format(
                    'SELECT ($1)::%s',
                    identity_column_type
                )
                USING id_val_text;
            EXCEPTION
                WHEN others THEN
                    RAISE EXCEPTION
                        'dict mapping jsonb validation failed: identity value "%" cannot be cast to %. Column: %.%.%',
                        id_val_text,
                        identity_column_type,
                        target_schema,
                        target_table,
                        id_key;
            END;
        END LOOP;

        ---------------------------------------------------------------------
        -- update_attribute checks
        ---------------------------------------------------------------------

        IF effect_kind = 'update_attribute' THEN
            target_attribute := effect ->> 'tww_attribute_id';

            IF target_attribute IS NULL
               OR target_attribute = ''
            THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: update_attribute effect is missing tww_attribute_id. Effect: %',
                    effect;
            END IF;

            SELECT a.atttypid::regtype
            INTO target_attribute_type
            FROM pg_attribute a
            WHERE a.attrelid = target_table_oid
              AND a.attname = target_attribute
              AND a.attnum > 0
              AND NOT a.attisdropped;

            IF target_attribute_type IS NULL THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: target attribute %.%.% does not exist.',
                    target_schema,
                    target_table,
                    target_attribute;
            END IF;

            IF effect ? 'value_id'
               AND effect ? 'value'
            THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: update_attribute effect must not contain both value_id and value. Effect: %',
                    effect;
            END IF;

            IF effect ? 'value_id' THEN
                value_json := effect -> 'value_id';
            ELSIF effect ? 'value' THEN
                value_json := effect -> 'value';
            ELSE
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: update_attribute effect must contain value_id or value. Effect: %',
                    effect;
            END IF;

            IF jsonb_typeof(value_json) NOT IN (
                'string',
                'number',
                'boolean',
                'null'
            ) THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: attribute value for %.%.% must be scalar or null. Got: %',
                    target_schema,
                    target_table,
                    target_attribute,
                    value_json;
            END IF;

            IF jsonb_typeof(value_json) = 'null' THEN
                value_text := NULL;
            ELSE
                value_text := value_json #>> '{{}}';
            END IF;

            IF value_text IS NOT NULL THEN
                BEGIN
                    EXECUTE format(
                        'SELECT ($1)::%s',
                        target_attribute_type
                    )
                    USING value_text;
                EXCEPTION
                    WHEN others THEN
                        RAISE EXCEPTION
                            'dict mapping jsonb validation failed: value "%" cannot be cast to %. Target: %.%.%',
                            value_text,
                            target_attribute_type,
                            target_schema,
                            target_table,
                            target_attribute;
                END;
            END IF;
        ELSE
            -----------------------------------------------------------------
            -- Non-attribute effect checks
            -----------------------------------------------------------------

            IF effect ? 'tww_attribute_id' THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: non-attribute effects must not contain tww_attribute_id. Effect: %',
                    effect;
            END IF;

            IF effect ? 'value'
               OR effect ? 'value_id'
            THEN
                RAISE EXCEPTION
                    'dict mapping jsonb validation failed: non-attribute effects must not contain value or value_id. Effect: %',
                    effect;
            END IF;
        END IF;
    END LOOP;

    RETURN true;
END;
$BODY$;


CREATE OR REPLACE FUNCTION tww_app.persist_dict_mapping_jsonb(
    mapping jsonb
)
RETURNS void
LANGUAGE plpgsql
AS
$BODY$
DECLARE
    target_schema CONSTANT text := 'tww_od';

    effect jsonb;
    effect_kind text;

    identity jsonb;
    identity_attributes jsonb;

    target_table text;
    target_attribute text;

    target_table_oid oid;
    target_attribute_type regtype;

    id_key text;
    id_val jsonb;
    id_val_text text;
    id_col_type regtype;

    where_clause text;
    insert_columns text;
    insert_values text;

    value_json jsonb;
    value_text text;
BEGIN
    -------------------------------------------------------------------------
    -- Validate full mapping contract before doing any write.
    -------------------------------------------------------------------------

    IF NOT tww_app.fct_validate_dict_mapping_jsonb(
        mapping
    ) THEN
        RAISE EXCEPTION
            'persist_dict_mapping_jsonb: mapping validation failed.';
    END IF;

    -------------------------------------------------------------------------
    -- Persist effects
    -------------------------------------------------------------------------

    FOR effect IN
        SELECT value
        FROM jsonb_array_elements(mapping -> 'effects')
    LOOP
        effect_kind := effect ->> 'kind';

        identity := effect -> 'identity';
        target_table := identity ->> 'class_id';
        identity_attributes := identity -> 'attributes';

        target_attribute := effect ->> 'tww_attribute_id';

        ---------------------------------------------------------------------
        -- Resolve target table OID
        ---------------------------------------------------------------------

        SELECT c.oid
        INTO target_table_oid
        FROM pg_class c
        JOIN pg_namespace n
            ON n.oid = c.relnamespace
        WHERE n.nspname = target_schema
          AND c.relname = target_table
          AND c.relkind IN ('r', 'p');

        IF target_table_oid IS NULL THEN
            RAISE EXCEPTION
                'persist_dict_mapping_jsonb: target table %.% does not exist.',
                target_schema,
                target_table;
        END IF;

        ---------------------------------------------------------------------
        -- Build typed identity WHERE clause and INSERT identity values
        ---------------------------------------------------------------------

        where_clause := NULL;
        insert_columns := NULL;
        insert_values := NULL;

        FOR id_key, id_val IN
            SELECT key, value
            FROM jsonb_each(identity_attributes)
        LOOP
            SELECT a.atttypid::regtype
            INTO id_col_type
            FROM pg_attribute a
            WHERE a.attrelid = target_table_oid
              AND a.attname = id_key
              AND a.attnum > 0
              AND NOT a.attisdropped;

            IF id_col_type IS NULL THEN
                RAISE EXCEPTION
                    'persist_dict_mapping_jsonb: identity column %.%.% does not exist.',
                    target_schema,
                    target_table,
                    id_key;
            END IF;

            id_val_text := id_val #>> '{{}}';

            where_clause := concat_ws(
                ' AND ',
                where_clause,
                format(
                    '%I = %L::%s',
                    id_key,
                    id_val_text,
                    id_col_type
                )
            );

            insert_columns := concat_ws(
                ', ',
                insert_columns,
                format(
                    '%I',
                    id_key
                )
            );

            insert_values := concat_ws(
                ', ',
                insert_values,
                format(
                    '%L::%s',
                    id_val_text,
                    id_col_type
                )
            );
        END LOOP;

        ---------------------------------------------------------------------
        -- Apply effect
        ---------------------------------------------------------------------

        IF effect_kind = 'update_attribute' THEN
            -----------------------------------------------------------------
            -- Resolve target attribute type
            -----------------------------------------------------------------

            SELECT a.atttypid::regtype
            INTO target_attribute_type
            FROM pg_attribute a
            WHERE a.attrelid = target_table_oid
              AND a.attname = target_attribute
              AND a.attnum > 0
              AND NOT a.attisdropped;

            IF target_attribute_type IS NULL THEN
                RAISE EXCEPTION
                    'persist_dict_mapping_jsonb: target attribute %.%.% does not exist.',
                    target_schema,
                    target_table,
                    target_attribute;
            END IF;

            IF effect ? 'value_id' THEN
                value_json := effect -> 'value_id';
            ELSE
                value_json := effect -> 'value';
            END IF;

            IF jsonb_typeof(value_json) = 'null' THEN
                EXECUTE format(
                    'UPDATE %I.%I SET %I = NULL WHERE %s',
                    target_schema,
                    target_table,
                    target_attribute,
                    where_clause
                );
            ELSE
                value_text := value_json #>> '{{}}';

                EXECUTE format(
                    'UPDATE %I.%I SET %I = %L::%s WHERE %s',
                    target_schema,
                    target_table,
                    target_attribute,
                    value_text,
                    target_attribute_type,
                    where_clause
                );
            END IF;

        ELSIF effect_kind = 'enforce_exists' THEN
            EXECUTE format(
                'INSERT INTO %I.%I (%s) VALUES (%s) ON CONFLICT DO NOTHING',
                target_schema,
                target_table,
                insert_columns,
                insert_values
            );

        ELSIF effect_kind = 'enforce_not_exists' THEN
            EXECUTE format(
                'DELETE FROM %I.%I WHERE %s',
                target_schema,
                target_table,
                where_clause
            );

        ELSE
            RAISE EXCEPTION
                'persist_dict_mapping_jsonb: unsupported effect kind "%". Effect: %',
                effect_kind,
                effect;
        END IF;
    END LOOP;
END;
$BODY$;
