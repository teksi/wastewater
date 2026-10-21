CREATE OR REPLACE FUNCTION tww_app.fct_effect_identity(
    _class_id text,
    _attribute_name text,
    _attribute_value text
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
STRICT
AS
$function$
    SELECT jsonb_build_object(
        'class_id',
        _class_id,
        'attributes',
        jsonb_build_object(
            _attribute_name,
            _attribute_value
        )
    );
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_effect_enforce_exists(
    _identity jsonb
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
STRICT
AS
$function$
    SELECT jsonb_build_object(
        'kind',
        'enforce_exists',
        'identity',
        _identity
    );
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_effect_enforce_not_exists(
    _identity jsonb
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
STRICT
AS
$function$
    SELECT jsonb_build_object(
        'kind',
        'enforce_not_exists',
        'identity',
        _identity
    );
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_effect_update(
    _identity jsonb,
    _attribute_name text,
    _value jsonb
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS
$function$
    SELECT jsonb_build_object(
        'kind',
        'update_attribute',
        'identity',
        _identity,
        'attribute_id',
        _attribute_name,
        'value',
        COALESCE(
            _value,
            'null'::jsonb
        )
    );
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_effect_append(
    _effects jsonb,
    _effect jsonb
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS
$function$
    SELECT COALESCE(
        _effects,
        '[]'::jsonb
    ) || jsonb_build_array(
        _effect
    );
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_effect_append_update_if_present(
    _effects jsonb,
    _row jsonb,
    _source_attribute text,
    _identity jsonb,
    _target_attribute text
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS
$function$
    SELECT
        CASE
            WHEN _row ? _source_attribute
            THEN tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    _target_attribute,
                    _row -> _source_attribute
                )
            )
            ELSE COALESCE(
                _effects,
                '[]'::jsonb
            )
        END;
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_quarantine_tid_to_t_ili_tid(
    _schema_name text,
    _relation_name text,
    _t_id bigint
)
RETURNS text
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _result text;
BEGIN
    IF _t_id IS NULL THEN
        RETURN NULL;
    END IF;

    EXECUTE format(
        'SELECT t_ili_tid::text
         FROM %I.%I
         WHERE t_id = $1',
        _schema_name,
        _relation_name
    )
    INTO _result
    USING _t_id;

    RETURN _result;
END;
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_value_list_code(
    _schema_name text,
    _relation_name text,
    _value_column text,
    _value text
)
RETURNS bigint
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _code bigint;
BEGIN
    IF _value IS NULL THEN
        RETURN NULL;
    END IF;

    EXECUTE format(
        'SELECT code
         FROM %I.%I
         WHERE %I = $1',
        _schema_name,
        _relation_name,
        _value_column
    )
    INTO _code
    USING _value;

    /*
     * Missing values return NULL. The caller can emit a failed existence
     * requirement or a placeholder effect instead of raising in SQL.
     */
    RETURN _code;
END;
$function$;