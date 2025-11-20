CREATE MATERIALIZED VIEW IF NOT EXISTS tww_app.mvw_web_wastewater_structure
AS
   SELECT ws.obj_id,
    ws.identifier,
    ws.location_name,
        CASE
            WHEN ma.obj_id IS NOT NULL THEN 'manhole'::text
            WHEN ss.obj_id IS NOT NULL THEN 'special_structure'::text
            WHEN dp.obj_id IS NOT NULL THEN 'discharge_point'::text
            WHEN ii.obj_id IS NOT NULL THEN 'infiltration_installation'::text
            ELSE 'unknown'::text
        END AS ws_type,
    replace(
      COALESCE(ma_fu.{value_lang}, 
        ss_fu.{value_lang}, 
        ii_knd.{value_lang}, 
        (dot_dp.{name_lang}::text||' ' || dp_rlvnc.{value_lang}::text)::character varying)
      , '_'::text, ' '::text) AS _function,
    own.identifier AS _owner,
    opr.identifier AS _operator,
    replace(ws_st.{value_lang}::text, '_'::text, ' '::text) AS status,
    ws_acc.{value_lang} AS accessibility,
    ws_fin.{value_lang} AS financing,
    ws.inspection_interval,
    ws.last_modification,
    ws.records,
    ws.remark,
    ws_rn.{value_lang} AS renovation_necessity,
    ws_sc.{value_lang} AS structure_condition,
    replace(ws.year_of_construction::character varying::text, '1800'::text, '-'::text) AS year_of_construction,
    main_co.level AS co_level,
    st_force2d(COALESCE(wn.situation3d_geometry, main_co.situation3d_geometry))::geometry(Point,2056) AS situation_geometry,
    COALESCE(ma.dimension1, ii.dimension1) AS dimension1,
    COALESCE(ma.dimension2, ii.dimension2) AS dimension2,
    COALESCE(ss.upper_elevation, dp.upper_elevation) AS upper_elevation,
    wn.backflow_level_current,
    wn.bottom_level,
        CASE
            WHEN ws.identifier = ws.obj_id::text THEN '?'::text
            ELSE ws._label
        END AS _label,
    ws._cover_label,
    ws._bottom_label,
    ws._input_label,
    ws._output_label,
    wn._usage_current AS _channel_usage_current,
    wn._function_hierarchic AS _channel_function_hierarchic
   FROM tww_od.wastewater_structure ws
     LEFT JOIN tww_od.cover main_co ON main_co.obj_id::text = ws.fk_main_cover::text
     LEFT JOIN tww_od.manhole ma ON ma.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.special_structure ss ON ss.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.discharge_point dp ON dp.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.infiltration_installation ii ON ii.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id::text = ws.fk_main_wastewater_node::text
     LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_vl.manhole_function ma_fu ON ma_fu.code = ma.function
     LEFT JOIN tww_vl.special_structure_function ss_fu ON ss_fu.code = ss.function
     LEFT JOIN tww_vl.infiltration_installation_kind ii_knd ON ii_knd.code = ii.kind
     LEFT JOIN tww_vl.discharge_point_relevance dp_rlvnc ON dp_rlvnc.code = dp.relevance
     LEFT JOIN tww_od.organisation own ON own.obj_id::text = ws.fk_owner::text
     LEFT JOIN tww_od.organisation opr ON opr.obj_id::text = ws.fk_operator::text
     LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.code = ws.status
     LEFT JOIN tww_vl.wastewater_structure_accessibility ws_acc ON ws_acc.code = ws.accessibility
     LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.code = ws.financing
     LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.code = ws.renovation_necessity
     LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.code = ws.structure_condition
     LEFT JOIN tww_sys.dictionary_od_table dot_dp on dot_dp.tablename = 'discharge_point'
  WHERE ch.obj_id IS NULL;