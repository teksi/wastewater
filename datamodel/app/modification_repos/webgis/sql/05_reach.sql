CREATE MATERIALIZED VIEW IF NOT EXISTS tww_app.mvw_web_reach
AS
  SELECT re.obj_id,
    re.clear_height,
    re_mat.{value_lang} AS material,
    ch_uc.{value_lang} AS usage_current,
    ch_hi.{value_lang} AS function_hierarchic,
    replace(ws_stts.{value_lang}::text, '_'::text, ' '::text)::character varying(50) AS status,
    own.identifier AS owner,
    ch_hy.{value_lang} AS function_hydraulic,
    ch_up.{value_lang} AS usage_planned,
        CASE
            WHEN pp.height_width_ratio IS NOT NULL THEN round(re.clear_height::numeric / pp.height_width_ratio)::smallint::integer
            ELSE re.clear_height
        END AS width,
        CASE
            WHEN rp_from.level > 0::numeric AND rp_to.level > 0::numeric THEN round((rp_from.level - rp_to.level) / st_length(re.progression3d_geometry)::numeric * 1000::numeric, 1)
            ELSE NULL::numeric
        END AS _slope_per_mill,
    re_ed.{value_lang} AS elevation_determination,
    re_hp.{value_lang} AS horizontal_positioning,
    re.progression3d_geometry,
    re_rl_knd.{value_lang} AS relining_kind,
    ws_acc.{value_lang} AS accessibility,
    ws_fin.{value_lang} AS financing,
    ws.identifier,
    ws.inspection_interval,
    ws_rn.{value_lang} AS renovation_necessity,
    ws_sc.{value_lang} AS structure_condition,
    replace(ws.year_of_construction::text, '1800', '-') AS year_of_construction,
    rp_from_ea.{value_lang} AS rp_from_elevation_accuracy,
    rp_from.level AS rp_from_level,
    rp_to_ea.{value_lang} AS rp_to_elevation_accuracy,
    rp_to.level AS rp_to_level,
    ch.usage_current AS ch_usage_current,
    ch.usage_planned AS ch_usage_planned,
    ch.function_hierarchic AS ch_function_hierarchic,
    ws.structure_condition AS ws_structure_condition,
    ws.status AS _status,
    ws.obj_id AS ws_obj_id,
    re_mat.{abbr_lang} AS material_abbr
   FROM tww_od.reach re
     LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
     LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id::text = re.fk_reach_point_to::text
     LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id::text = re.obj_id::text
     LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.pipe_profile pp ON re.fk_pipe_profile::text = pp.obj_id::text
     LEFT JOIN tww_vl.channel_usage_current ch_uc ON ch_uc.code = ch.usage_current
     LEFT JOIN tww_vl.channel_usage_planned ch_up ON ch_up.code = ch.usage_planned
     LEFT JOIN tww_vl.channel_function_hierarchic ch_hi ON ch_hi.code = ch.function_hierarchic
     LEFT JOIN tww_vl.channel_function_hydraulic ch_hy ON ch_hy.code = ch.function_hydraulic
     LEFT JOIN tww_vl.reach_material re_mat ON re_mat.code = re.material
     LEFT JOIN tww_vl.reach_elevation_determination re_ed ON re_ed.code = re.elevation_determination
     LEFT JOIN tww_vl.reach_horizontal_positioning re_hp ON re_hp.code = re.horizontal_positioning
     LEFT JOIN tww_vl.reach_relining_kind re_rl_knd ON re_rl_knd.code = re.relining_kind
     LEFT JOIN tww_od.organisation own ON own.obj_id::text = ws.fk_owner::text
     LEFT JOIN tww_vl.wastewater_structure_status ws_stts ON ws_stts.code = ws.status
     LEFT JOIN tww_vl.wastewater_structure_accessibility ws_acc ON ws_acc.code = ws.accessibility
     LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.code = ws.financing
     LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.code = ws.renovation_necessity
     LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.code = ws.structure_condition
     LEFT JOIN tww_vl.reach_point_elevation_accuracy rp_to_ea ON rp_to_ea.code = rp_to.elevation_accuracy
     LEFT JOIN tww_vl.reach_point_elevation_accuracy rp_from_ea ON rp_from_ea.code = rp_from.elevation_accuracy;