CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gepknoten_mapping_jsonb(
    _row jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _source_model constant text :=
        'Genereller_Entwaesserungsplan_AG';

    _source_class constant text :=
        'GepKnoten';

    _node_id text;

    _import_schema text := COALESCE(
        NULLIF(
            current_setting(
                'tww.import_schema',
                true
            ),
            ''
        ),
        'tww_app_xtf2pg_incr'
    );

    _representation text;

    _effects jsonb;
BEGIN
    _node_id := NULLIF(
        btrim(
            _row ->> 't_ili_tid'
        ),
        ''
    );

    IF _node_id IS NULL THEN
        /*
         * Malformed effect documents cannot be meaningfully passed to Python,
         * so this remains a database exception.
         */
        RAISE EXCEPTION
            'GepKnoten mapping requires a non-empty t_ili_tid.';
    END IF;

    _representation := (
        tww_app.fct_agxx_gepknoten_representation(
            _node_id
        )
    );

    CASE _representation
        WHEN 'synthetic' THEN
            _effects := (
                tww_app.fct_agxx_gepknoten_synthetic_effects(
                    _row,
                    _import_schema
                )
            );

        WHEN 'dss' THEN
            _effects := (
                tww_app.fct_agxx_gepknoten_dss_effects(
                    _row,
                    _import_schema
                )
            );

        ELSE
            /*
             * Defensive fallback. The representation helper currently always
             * returns synthetic or dss.
             */
            _effects := jsonb_build_array(
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_effect_identity(
                        'agxx_unknown_gepknoten_representation',
                        'obj_id',
                        _node_id
                    )
                )
            );
    END CASE;

    RETURN jsonb_build_object(
        'source',
        jsonb_build_object(
            'model',
            _source_model,
            'class_id',
            _source_class,
            'object_id',
            _node_id
        ),
        'effects',
        COALESCE(
            _effects,
            '[]'::jsonb
        )
    );
END;
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gephaltung_mapping_jsonb(
    _row jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _source_model constant text :=
        'Genereller_Entwaesserungsplan_AG';

    _source_class constant text :=
        'GepHaltung';

    _reach_id text;

    _import_schema text := COALESCE(
        NULLIF(
            current_setting(
                'tww.import_schema',
                true
            ),
            ''
        ),
        'tww_app_xtf2pg_incr'
    );

    _effects jsonb;
BEGIN
    _reach_id := NULLIF(
        btrim(
            _row ->> 't_ili_tid'
        ),
        ''
    );

    IF _reach_id IS NULL THEN
        /*
         * A malformed source identity cannot be represented as a useful
         * desired-state effect.
         */
        RAISE EXCEPTION
            'GepHaltung mapping requires a non-empty t_ili_tid.';
    END IF;

    _effects := tww_app.fct_agxx_gephaltung_effects(
        _row,
        _import_schema
    );

    RETURN jsonb_build_object(
        'source',
        jsonb_build_object(
            'model',
            _source_model,
            'class_id',
            _source_class,
            'object_id',
            _reach_id
        ),
        'effects',
        COALESCE(
            _effects,
            '[]'::jsonb
        )
    );
END;
$function$;
