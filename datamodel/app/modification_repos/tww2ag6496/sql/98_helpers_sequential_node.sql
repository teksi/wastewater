CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gepknoten_representation(
    _node_id text
)
RETURNS text
LANGUAGE sql
STABLE
STRICT
AS
$function$
    SELECT
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM tww_od.agxx_unconnected_node_bwrel AS un
                WHERE un.obj_id = _node_id
            )
            THEN 'synthetic'

            WHEN EXISTS (
                SELECT 1
                FROM tww_od.wastewater_node AS wn
                WHERE wn.obj_id = _node_id
            )
            THEN 'dss'

            /*
             * A new node has not passed through persistence yet. Default it
             * to the AGXX synthetic representation rather than creating a
             * protected DSS wastewater node.
             */
            ELSE 'synthetic'
        END;
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gepknoten_dss_effects(
    _row jsonb,
    _import_schema text
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _effects jsonb := '[]'::jsonb;

    _node_id text;

    _networkelement_id text;
    _structure_id text;

    _provider_wi text;
    _provider_gep text;
    _measure_id text;

    _gateway_code bigint;

    _node_identity jsonb;
    _networkelement_identity jsonb;
    _agxx_node_identity jsonb;
    _agxx_networkelement_identity jsonb;
    _last_modification_identity jsonb;
    _agxx_structure_identity jsonb;

    _organisation_identity jsonb;
BEGIN
    _node_id := NULLIF(
        _row ->> 't_ili_tid',
        ''
    );

    _node_identity := tww_app.fct_effect_identity(
        'wastewater_node',
        'obj_id',
        _node_id
    );

    _networkelement_identity := tww_app.fct_effect_identity(
        'wastewater_networkelement',
        'obj_id',
        _node_id
    );

    _agxx_node_identity := tww_app.fct_effect_identity(
        'agxx_wastewater_node',
        'fk_wastewater_node',
        _node_id
    );

    _agxx_networkelement_identity := tww_app.fct_effect_identity(
        'agxx_wastewater_networkelement',
        'fk_wastewater_networkelement',
        _node_id
    );

    _last_modification_identity := tww_app.fct_effect_identity(
        'agxx_last_modification',
        'fk_element',
        _node_id
    );

    /*
     * Verify core DSS objects. Missing objects are blocked by the Python
     * evaluation policy.
     */
    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _node_identity
        )
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _networkelement_identity
        )
    );

    /*
     * AGXX node extension.
     */
    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _agxx_node_identity
        )
    );

    _gateway_code := tww_app.fct_value_list_code(
        'tww_vl',
        'wastewater_node_ag96_is_gateway',
        'value_de',
        _row ->> 'istschnittstelle'
    );

    IF (
        _row ->> 'istschnittstelle'
    ) IS NOT NULL THEN
        IF _gateway_code IS NULL THEN
            /*
             * TODO:
             * Replace the virtual missing-mapping identity once value-list
             * extension effects have a concrete canonical representation.
             */
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'wastewater_node_ag96_is_gateway',
                        _row ->> 'istschnittstelle'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _agxx_node_identity,
                    'ag96_is_gateway',
                    to_jsonb(
                        _gateway_code
                    )
                )
            );
        END IF;
    END IF;

    /*
     * AGXX network-element extension.
     */
    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _agxx_networkelement_identity
        )
    );

    _provider_wi := tww_app.fct_agxx_live_organisation_oid(
        _import_schema,
        _row -> 'datenbewirtschafter_wi'
    );

    _provider_gep := tww_app.fct_agxx_live_organisation_oid(
        _import_schema,
        _row -> 'datenbewirtschafter_gep'
    );

    IF _provider_wi IS NOT NULL THEN
        _organisation_identity := tww_app.fct_effect_identity(
            'organisation',
            'obj_id',
            _provider_wi
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                _organisation_identity
            )
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_update(
                _agxx_networkelement_identity,
                'ag64_fk_provider',
                to_jsonb(
                    _provider_wi
                )
            )
        );
    END IF;

    IF _provider_gep IS NOT NULL THEN
        _organisation_identity := tww_app.fct_effect_identity(
            'organisation',
            'obj_id',
            _provider_gep
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                _organisation_identity
            )
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_update(
                _agxx_networkelement_identity,
                'ag96_fk_provider',
                to_jsonb(
                    _provider_gep
                )
            )
        );
    END IF;

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'bemerkung_wi',
        _agxx_networkelement_identity,
        'ag64_remark'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'bemerkung_gep',
        _agxx_networkelement_identity,
        'ag96_remark'
    );

    /*
     * Modification timestamps.
     */
    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _last_modification_identity
        )
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'letzte_aenderung_wi',
        _last_modification_identity,
        'ag64_last_modification'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'letzte_aenderung_gep',
        _last_modification_identity,
        'ag96_last_modification'
    );

    /*
     * Structure extension.
     *
     * No DSS structure values are modified here.
     */
    SELECT COALESCE(
        ne.fk_wastewater_structure,
        ws.obj_id
    )
    INTO _structure_id
    FROM tww_od.wastewater_networkelement AS ne
    LEFT JOIN tww_od.wastewater_structure AS ws
      ON ws.fk_main_wastewater_node = ne.obj_id
    WHERE ne.obj_id = _node_id
    LIMIT 1;

    IF (
        _row ->> 'gepmassnahmeref'
    ) IS NOT NULL THEN
        IF _structure_id IS NULL THEN
            /*
             * A protected core structure is required but absent. Let Python
             * decide that this is blocked.
             *
             * TODO:
             * Replace the placeholder identity if deterministic structure
             * creation is introduced.
             */
            _structure_id := concat(
                _node_id,
                ':missing-structure'
            );

            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_effect_identity(
                        'wastewater_structure',
                        'obj_id',
                        _structure_id
                    )
                )
            );
        ELSE
            _agxx_structure_identity := (
                tww_app.fct_effect_identity(
                    'agxx_wastewater_structure',
                    'fk_wastewater_structure',
                    _structure_id
                )
            );

            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    _agxx_structure_identity
                )
            );

            _measure_id := (
                tww_app.fct_quarantine_reference_oid(
                    _import_schema,
                    'gepmassnahme',
                    _row -> 'gepmassnahmeref'
                )
            );

            IF _measure_id IS NOT NULL THEN
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_enforce_exists(
                        tww_app.fct_effect_identity(
                            'measure',
                            'obj_id',
                            _measure_id
                        )
                    )
                );
            END IF;

            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _agxx_structure_identity,
                    'ag96_fk_measure',
                    to_jsonb(
                        _measure_id
                    )
                )
            );
        END IF;
    END IF;

    /*
     * FunktionAG:
     *
     * Existing related canonical rows determine the exported value. The DSS
     * path must not rewrite DSS subtype tables.
     *
     * TODO:
     * Add only structural enforce_exists checks for values such as Messstelle
     * once the canonical identity of measuring_point has been confirmed.
     */

    RETURN _effects;
END;
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gepknoten_synthetic_effects(
    _row jsonb,
    _import_schema text
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _effects jsonb := '[]'::jsonb;

    _node_id text;

    _identity jsonb;
    _organisation_identity jsonb;
    _measure_identity jsonb;

    _operator_id text;
    _owner_id text;
    _measure_id text;

    _structure_condition_code bigint;
    _status_code bigint;
    _financing_code bigint;
    _renovation_code bigint;
    _accessibility_code bigint;
    _cover_accuracy_code bigint;
    _function_hierarchic_code bigint;
BEGIN
    _node_id := NULLIF(
        _row ->> 't_ili_tid',
        ''
    );

    _identity := tww_app.fct_effect_identity(
        'agxx_unconnected_node_bwrel',
        'obj_id',
        _node_id
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _identity
        )
    );

    /*
     * Direct scalar storage required for synthetic AGXX topology nodes.
     */
    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'ara_nr',
        _identity,
        'wwtp_number'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'baujahr',
        _identity,
        'year_of_construction'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'jahr_zustandserhebung',
        _identity,
        'status_survey_year'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'maxrueckstauhoehe',
        _identity,
        'backflow_level_current'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'sohlenkote',
        _identity,
        'bottom_level'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'lage',
        _identity,
        'situation3d_geometry'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'deckelkote',
        _identity,
        'co_level'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'detailgeometrie',
        _identity,
        'detail_geometry3d_geometry'
    );

    /*
     * VSA value lists are always resolved to canonical codes.
     */
    IF (
        _row ->> 'baulicherzustand'
    ) IS NOT NULL THEN
        _structure_condition_code := (
            tww_app.fct_value_list_code(
                'tww_vl',
                'wastewater_structure_structure_condition',
                'value_de',
                _row ->> 'baulicherzustand'
            )
        );

        IF _structure_condition_code IS NULL THEN
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'wastewater_structure_structure_condition',
                        _row ->> 'baulicherzustand'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    'structure_condition',
                    to_jsonb(
                        _structure_condition_code
                    )
                )
            );
        END IF;
    END IF;

    IF (
        _row ->> 'bauwerkstatus'
    ) IS NOT NULL THEN
        _status_code := tww_app.fct_value_list_code(
            'tww_vl',
            'wastewater_structure_status',
            'value_de',
            replace(
                _row ->> 'bauwerkstatus',
                '.in_Betrieb',
                ''
            )
        );

        IF _status_code IS NULL THEN
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'wastewater_structure_status',
                        _row ->> 'bauwerkstatus'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    'status',
                    to_jsonb(
                        _status_code
                    )
                )
            );
        END IF;
    END IF;

    IF (
        _row ->> 'finanzierung'
    ) IS NOT NULL THEN
        _financing_code := tww_app.fct_value_list_code(
            'tww_vl',
            'wastewater_structure_financing',
            'value_de',
            _row ->> 'finanzierung'
        );

        IF _financing_code IS NULL THEN
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'wastewater_structure_financing',
                        _row ->> 'finanzierung'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    'financing',
                    to_jsonb(
                        _financing_code
                    )
                )
            );
        END IF;
    END IF;

    IF (
        _row ->> 'sanierungsbedarf'
    ) IS NOT NULL THEN
        _renovation_code := tww_app.fct_value_list_code(
            'tww_vl',
            'wastewater_structure_renovation_necessity',
            'value_de',
            _row ->> 'sanierungsbedarf'
        );

        IF _renovation_code IS NULL THEN
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'wastewater_structure_renovation_necessity',
                        _row ->> 'sanierungsbedarf'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    'renovation_necessity',
                    to_jsonb(
                        _renovation_code
                    )
                )
            );
        END IF;
    END IF;

    IF (
        _row ->> 'zugaenglichkeit'
    ) IS NOT NULL THEN
        _accessibility_code := tww_app.fct_value_list_code(
            'tww_vl',
            'wastewater_structure_accessibility',
            'value_de',
            _row ->> 'zugaenglichkeit'
        );

        IF _accessibility_code IS NULL THEN
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'wastewater_structure_accessibility',
                        _row ->> 'zugaenglichkeit'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    'accessibility',
                    to_jsonb(
                        _accessibility_code
                    )
                )
            );
        END IF;
    END IF;

    IF (
        _row ->> 'lagegenauigkeit'
    ) IS NOT NULL THEN
        _cover_accuracy_code := (
            tww_app.fct_value_list_code(
                'tww_vl',
                'cover_positional_accuracy',
                'value_de',
                _row ->> 'lagegenauigkeit'
            )
        );

        IF _cover_accuracy_code IS NULL THEN
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_missing_mapping_identity(
                        'cover_positional_accuracy',
                        _row ->> 'lagegenauigkeit'
                    )
                )
            );
        ELSE
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_update(
                    _identity,
                    'co_positional_accuracy',
                    to_jsonb(
                        _cover_accuracy_code
                    )
                )
            );
        END IF;
    END IF;

    IF (
        _row ->> 'funktionhierarchisch'
    ) IS NOT NULL THEN
        /*
         * PLACEHOLDER:
         *
         * The export uses left(value_de, 3), which may not be unique.
         * Add a dedicated channel_function_hierarchic_import_rel_agxx
         * relation before implementing this lookup.
         */
        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                tww_app.fct_missing_mapping_identity(
                    'channel_function_hierarchic_import_rel_agxx',
                    _row ->> 'funktionhierarchisch'
                )
            )
        );
    END IF;

    /*
     * Organisation references.
     */
    _operator_id := tww_app.fct_agxx_live_organisation_oid(
        _import_schema,
        _row -> 'betreiber'
    );

    _owner_id := tww_app.fct_agxx_live_organisation_oid(
        _import_schema,
        _row -> 'eigentuemer'
    );

    IF _operator_id IS NOT NULL THEN
        _organisation_identity := tww_app.fct_effect_identity(
            'organisation',
            'obj_id',
            _operator_id
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                _organisation_identity
            )
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_update(
                _identity,
                'fk_operator',
                to_jsonb(
                    _operator_id
                )
            )
        );
    END IF;

    IF _owner_id IS NOT NULL THEN
        _organisation_identity := tww_app.fct_effect_identity(
            'organisation',
            'obj_id',
            _owner_id
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                _organisation_identity
            )
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_update(
                _identity,
                'fk_owner',
                to_jsonb(
                    _owner_id
                )
            )
        );
    END IF;

    /*
     * Measure reference.
     */
    IF _row ? 'gepmassnahmeref' THEN
        _measure_id := tww_app.fct_quarantine_reference_oid(
            _import_schema,
            'gepmassnahme',
            _row -> 'gepmassnahmeref'
        );

        IF _measure_id IS NOT NULL THEN
            _measure_identity := tww_app.fct_effect_identity(
                'measure',
                'obj_id',
                _measure_id
            );

            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    _measure_identity
                )
            );
        END IF;

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_update(
                _identity,
                'ag96_fk_measure',
                to_jsonb(
                    _measure_id
                )
            )
        );
    END IF;

    /*
     * agxx_reach_point is deliberately handled by GepHaltung because that
     * mapping has endpoint and canonical reach-point context.
     */

    RETURN _effects;
END;
$function$;