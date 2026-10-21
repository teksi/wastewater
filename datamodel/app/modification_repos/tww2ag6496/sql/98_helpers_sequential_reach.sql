CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gepknoten_reference_oid(
    _import_schema text,
    _source_reference jsonb
)
RETURNS text
LANGUAGE plpgsql
STABLE
AS
$function$
BEGIN
    RETURN tww_app.fct_quarantine_reference_oid(
        _import_schema,
        'abwasserknoten',
        _source_reference
    );
END;
$function$;


CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gephaltung_endpoint_effects(
    _reach_point_id text,
    _agxx_node_id text
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS
$function$
DECLARE
    _effects jsonb := '[]'::jsonb;

    _default_node_id text;
    _existing_agxx_node_id text;

    _reach_point_identity jsonb;
    _agxx_reach_point_identity jsonb;
    _synthetic_node_identity jsonb;
BEGIN
    IF _reach_point_id IS NULL
       OR _agxx_node_id IS NULL
    THEN
        RETURN _effects;
    END IF;

    /*
     * Normal DSS endpoint representation used by the export view when no
     * AGXX extension overrides it.
     */
    SELECT COALESCE(
        rp.fk_wastewater_networkelement,
        rp.obj_id
    )
    INTO _default_node_id
    FROM tww_od.reach_point AS rp
    WHERE rp.obj_id = _reach_point_id;

    /*
     * Verify the canonical reach point through Python rather than raising an
     * SQL exception.
     */
    _reach_point_identity := tww_app.fct_effect_identity(
        'reach_point',
        'obj_id',
        _reach_point_id
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _reach_point_identity
        )
    );

    SELECT arp.ag64_fk_wastewater_node
    INTO _existing_agxx_node_id
    FROM tww_od.agxx_reach_point AS arp
    WHERE arp.fk_reach_point = _reach_point_id;

    /*
     * If the incoming endpoint is already represented by the normal DSS
     * relation and no AGXX extension exists, no AGXX row is required.
     */
    IF _agxx_node_id = _default_node_id
       AND _existing_agxx_node_id IS NULL
    THEN
        RETURN _effects;
    END IF;

    /*
     * Otherwise the AGXX topology differs from the DSS topology. The target
     * node must exist in the synthetic-node bucket.
     *
     * This also supports the case where a wastewater_node with the same
     * identifier exists. The synthetic representation takes precedence for
     * the AGXX topology.
     */
    _synthetic_node_identity := tww_app.fct_effect_identity(
        'agxx_unconnected_node_bwrel',
        'obj_id',
        _agxx_node_id
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _synthetic_node_identity
        )
    );

    /*
     * Assumption:
     * agxx_reach_point uses fk_reach_point as its canonical identity.
     */
    _agxx_reach_point_identity := tww_app.fct_effect_identity(
        'agxx_reach_point',
        'fk_reach_point',
        _reach_point_id
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _agxx_reach_point_identity
        )
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_update(
            _agxx_reach_point_identity,
            'ag64_fk_wastewater_node',
            to_jsonb(
                _agxx_node_id
            )
        )
    );

    RETURN _effects;
END;
$function$;

CREATE OR REPLACE FUNCTION tww_app.fct_agxx_gephaltung_effects(
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

    _reach_id text;

    _reach_point_from_id text;
    _reach_point_to_id text;

    _start_node_id text;
    _end_node_id text;

    _structure_id text;

    _provider_wi text;
    _provider_gep text;
    _measure_id text;

    _reach_identity jsonb;
    _agxx_reach_identity jsonb;
    _agxx_networkelement_identity jsonb;
    _last_modification_identity jsonb;
    _agxx_structure_identity jsonb;
    _channel_identity jsonb;

    _function_hierarchic_code bigint;
    _usage_current_code bigint;
    _usage_planned_code bigint;

    _organisation_identity jsonb;
    _measure_identity jsonb;
BEGIN
    _reach_id := NULLIF(
        btrim(
            _row ->> 't_ili_tid'
        ),
        ''
    );

    /*
     * ------------------------------------------------------------------
     * 1. Value-list mapping checks
     * ------------------------------------------------------------------
     *
     * Successful values produce no effects because the DSS import already
     * populated the canonical attributes. Missing mappings produce an
     * unsatisfied existence requirement for Python to classify.
     */

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'wastewater_structure_structure_condition',
        'value_de',
        _row ->> 'baulicherzustand'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'wastewater_structure_status',
        'value_de',
        NULLIF(
            replace(
                _row ->> 'bauwerkstatus',
                '.in_Betrieb',
                ''
            ),
            ''
        )
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'wastewater_structure_financing',
        'value_de',
        _row ->> 'finanzierung'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'channel_function_hydraulic',
        'value_de',
        _row ->> 'funktionhydraulisch'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'reach_point_elevation_accuracy',
        'value_de',
        _row ->> 'hoehengenauigkeit_von'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'reach_point_elevation_accuracy',
        'value_de',
        _row ->> 'hoehengenauigkeit_nach'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'reach_material',
        'value_de',
        _row ->> 'material'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'pipe_profile_profile_type',
        'value_de',
        _row ->> 'profiltyp'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'reach_relining_kind',
        'value_de',
        _row ->> 'reliner_art'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'reach_relining_construction',
        'value_de',
        _row ->> 'reliner_bautechnik'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'reach_reliner_material',
        'value_de',
        _row ->> 'reliner_material'
    );

    _effects := _effects || tww_app.fct_agxx_check_value_mapping(
        'tww_vl',
        'wastewater_structure_renovation_necessity',
        'value_de',
        _row ->> 'sanierungsbedarf'
    );

    /*
     * ------------------------------------------------------------------
     * 2. Resolve the existing DSS reach context
     * ------------------------------------------------------------------
     *
     * The DSS import is responsible for creating reach, endpoint reach
     * points, structure, channel, and pipe profile.
     *
     * Missing core objects are expressed through enforce_exists. The
     * evaluator then produces a meaningful blocked result.
     */

    _reach_identity := tww_app.fct_effect_identity(
        'reach',
        'obj_id',
        _reach_id
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _reach_identity
        )
    );

    SELECT
        re.fk_reach_point_from,
        re.fk_reach_point_to,
        ne.fk_wastewater_structure
    INTO
        _reach_point_from_id,
        _reach_point_to_id,
        _structure_id
    FROM tww_od.reach AS re
    LEFT JOIN tww_od.wastewater_networkelement AS ne
      ON ne.obj_id = re.obj_id
    WHERE re.obj_id = _reach_id;

    /*
     * ------------------------------------------------------------------
     * 3. AGXX reach extension
     * ------------------------------------------------------------------
     */

    _agxx_reach_identity := tww_app.fct_effect_identity(
        'agxx_reach',
        'fk_reach',
        _reach_id
    );

    _effects := tww_app.fct_effect_append(
        _effects,
        tww_app.fct_effect_enforce_exists(
            _agxx_reach_identity
        )
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'lichte_hoehe_geplant',
        _agxx_reach_identity,
        'ag96_clear_height_planned'
    );

    _effects := tww_app.fct_effect_append_update_if_present(
        _effects,
        _row,
        'lichte_breite_geplant',
        _agxx_reach_identity,
        'ag96_clear_width_planned'
    );

    /*
     * ------------------------------------------------------------------
     * 4. AGXX network-element extension
     * ------------------------------------------------------------------
     */

    _agxx_networkelement_identity := tww_app.fct_effect_identity(
        'agxx_wastewater_networkelement',
        'fk_wastewater_networkelement',
        _reach_id
    );

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
     * ------------------------------------------------------------------
     * 5. AGXX last-modification extension
     * ------------------------------------------------------------------
     */

    _last_modification_identity := tww_app.fct_effect_identity(
        'agxx_last_modification',
        'fk_element',
        _reach_id
    );

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
     * ------------------------------------------------------------------
     * 6. AGXX wastewater-structure extension
     * ------------------------------------------------------------------
     *
     * The DSS import owns the wastewater_structure. The AGXX mapping only
     * persists the measure reference.
     */

/*
 * ------------------------------------------------------------------
 * Channel attributes with AGXX-specific value-list semantics
 * ------------------------------------------------------------------
 *
 * These values must not be skipped merely because channel is DSS-owned.
 *
 * AGXX introduces or renames values that may not be reproduced by the
 * baseline import:
 *
 * - funktionhierarchisch uses channel_function_hierarchic directly;
 * - nutzungsartag_ist uses channel_usage_current_import_rel_agxx;
 * - nutzungsartag_geplant uses
 *   channel_usage_planned_import_rel_agxx.
 *
 * The effect evaluator detects values that are already correct, so emitting
 * the desired values unconditionally is safe.
 */

    IF _structure_id IS NULL THEN
        /*
        * A channel is a wastewater-structure subtype. Without a related
        * wastewater structure there is no valid channel target.
        *
        * Do not raise an SQL exception. Emit an unsatisfied protected-object
        * requirement and let Python create the blocked finding.
        */
        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                tww_app.fct_effect_identity(
                    'wastewater_structure',
                    'obj_id',
                    concat(
                        _reach_id,
                        ':missing-structure'
                    )
                )
            )
        );

    ELSE
        _channel_identity := tww_app.fct_effect_identity(
            'channel',
            'obj_id',
            _structure_id
        );

        _effects := tww_app.fct_effect_append(
            _effects,
            tww_app.fct_effect_enforce_exists(
                _channel_identity
            )
        );

        /*
        * FunktionHierarchisch
        *
        * There is no separate AGXX import relation. The canonical value list
        * itself contains the AGXX extension values, including inactive values.
        */
        IF NULLIF(
            _row ->> 'funktionhierarchisch',
            ''
        ) IS NOT NULL THEN
            _function_hierarchic_code := (
                tww_app.fct_value_list_code(
                    'tww_vl',
                    'channel_function_hierarchic',
                    'value_de',
                    _row ->> 'funktionhierarchisch'
                )
            );

            IF _function_hierarchic_code IS NULL THEN
                /*
                * Placeholder until missing value mappings have a real canonical
                * value-list effect representation.
                */
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_enforce_exists(
                        tww_app.fct_missing_mapping_identity(
                            'channel_function_hierarchic',
                            _row ->> 'funktionhierarchisch'
                        )
                    )
                );

            ELSE
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_update(
                        _channel_identity,
                        'function_hierarchic',
                        to_jsonb(
                            _function_hierarchic_code
                        )
                    )
                );
            END IF;
        END IF;

        /*
        * NutzungsartAG_ist
        *
        * The dedicated import relation is authoritative. This includes the
        * AGXX extension values:
        *
        * - Platzwasser;
        * - Strassenwasser;
        *
        * and the AGXX-specific remapping of the ordinary values.
        */
        IF NULLIF(
            _row ->> 'nutzungsartag_ist',
            ''
        ) IS NOT NULL THEN
            _usage_current_code := (
                tww_app.fct_value_list_code(
                    'tww_vl',
                    'channel_usage_current_import_rel_agxx',
                    'value_de',
                    _row ->> 'nutzungsartag_ist'
                )
            );

            IF _usage_current_code IS NULL THEN
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_enforce_exists(
                        tww_app.fct_missing_mapping_identity(
                            'channel_usage_current_import_rel_agxx',
                            _row ->> 'nutzungsartag_ist'
                        )
                    )
                );

            ELSE
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_update(
                        _channel_identity,
                        'usage_current',
                        to_jsonb(
                            _usage_current_code
                        )
                    )
                );
            END IF;
        END IF;

        /*
        * NutzungsartAG_geplant
        *
        * The dedicated import relation is authoritative. It deliberately maps
        * AGXX text values to the planned-usage canonical codes.
        */
        IF NULLIF(
            _row ->> 'nutzungsartag_geplant',
            ''
        ) IS NOT NULL THEN
            _usage_planned_code := (
                tww_app.fct_value_list_code(
                    'tww_vl',
                    'channel_usage_planned_import_rel_agxx',
                    'value_de',
                    _row ->> 'nutzungsartag_geplant'
                )
            );

            IF _usage_planned_code IS NULL THEN
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_enforce_exists(
                        tww_app.fct_missing_mapping_identity(
                            'channel_usage_planned_import_rel_agxx',
                            _row ->> 'nutzungsartag_geplant'
                        )
                    )
                );

            ELSE
                _effects := tww_app.fct_effect_append(
                    _effects,
                    tww_app.fct_effect_update(
                        _channel_identity,
                        'usage_planned',
                        to_jsonb(
                            _usage_planned_code
                        )
                    )
                );
            END IF;
        END IF;
    END IF;

    IF _row ? 'gepmassnahmeref' THEN
        IF _structure_id IS NULL THEN
            /*
             * Do not throw from SQL. Let Python report that the required
             * protected structure is absent.
             */
            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    tww_app.fct_effect_identity(
                        'wastewater_structure',
                        'obj_id',
                        concat(
                            _reach_id,
                            ':missing-structure'
                        )
                    )
                )
            );
        ELSE
            _agxx_structure_identity := tww_app.fct_effect_identity(
                'agxx_wastewater_structure',
                'fk_wastewater_structure',
                _structure_id
            );

            _effects := tww_app.fct_effect_append(
                _effects,
                tww_app.fct_effect_enforce_exists(
                    _agxx_structure_identity
                )
            );

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
     * ------------------------------------------------------------------
     * 7. AGXX endpoint topology
     * ------------------------------------------------------------------
     *
     * Endpoint references map to synthetic AGXX nodes only when the AGXX
     * topology differs from the existing DSS endpoint relationship.
     */

    _start_node_id := tww_app.fct_agxx_gepknoten_reference_oid(
        _import_schema,
        _row -> 'startknoten'
    );

    _end_node_id := tww_app.fct_agxx_gepknoten_reference_oid(
        _import_schema,
        _row -> 'endknoten'
    );

    _effects := _effects
        || tww_app.fct_agxx_gephaltung_endpoint_effects(
            _reach_point_from_id,
            _start_node_id
        );

    _effects := _effects
        || tww_app.fct_agxx_gephaltung_endpoint_effects(
            _reach_point_to_id,
            _end_node_id
        );

    RETURN _effects;
END;
$function$;
