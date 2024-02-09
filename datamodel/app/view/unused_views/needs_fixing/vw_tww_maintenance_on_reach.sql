-- View: tww_app.vw_tww_maintenance_on_reach

-- DROP VIEW tww_app.vw_tww_maintenance_on_reach;

CREATE OR REPLACE VIEW tww_app.vw_tww_maintenance_on_reach AS
 SELECT re_m_w.obj_id AS re_m_w_id,
    maintenance.obj_id,
    maintenance.identifier,
    maintenance.kind,
    maintenance.remark,
    maintenance.status,
    maintenance.time_point,
    maintenance.base_data,
    maintenance.cost,
    maintenance.data_details,
    maintenance.duration,
    maintenance.operator,
    maintenance.reason,
    maintenance.result,
    maintenance.last_modification,
    maintenance.fk_operating_company,
    reach.progression3d_geometry,
    reach.length_effective AS re_length_effective,
    reach.material AS re_material,
    ch.usage_current AS ch_usage_current,
    ch.function_hierarchic AS ch_function_hierarchic,
    ws.status AS ws_status,
    ws.fk_owner AS ws_fk_owner
   FROM tww_od.maintenance_event maintenance
     LEFT JOIN tww_od.re_maintenance_event_wastewater_structure re_m_w ON maintenance.obj_id::text = re_m_w.fk_maintenance_event::text
     LEFT JOIN tww_od.wastewater_structure ws ON re_m_w.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.reach reach ON reach.obj_id::text = ne.obj_id::text
  WHERE ch.obj_id IS NOT NULL;
