-- View: tww_app.vw_tww_maint_evnt_on_reach

-- DROP VIEW tww_app.vw_tww_maint_evnt_on_reach;

CREATE OR REPLACE VIEW tww_app.vw_tww_maint_evnt_on_reach AS
 SELECT 
	re_m_w.obj_id AS re_m_w_id,
    maint_evnt.obj_id,
    maint_evnt.identifier,
    maintenance.kind,
    maint_evnt.remark,
    maint_evnt.status,
    maint_evnt.time_point,
    maint_evnt.base_data,
    maint_evnt.cost,
    maint_evnt.data_details,
    maint_evnt.duration,
    maint_evnt.operator,
    maint_evnt.reason,
    maint_evnt.result,
    maint_evnt.last_modification,
    maint_evnt.fk_operating_company,
	maint_evnt.fk_measure,
	reach.obj_id as re_obj_id,
    reach.progression3d_geometry,
	reach.clear_height as re_clear_height,
    reach.length_effective AS re_length_effective,
    reach.material AS re_material,
    ch.usage_current AS ch_usage_current,
    ch.function_hierarchic AS ch_function_hierarchic,
	ws.obj_id AS ws_obj_id,
    ws.status AS ws_status,
	ws.structure_condition AS ws_structure_condition,
	ws.renovation_necessity AS ws_renovation_necessity,
	ws.urgency_figure AS ws_urgency_figure,
	ws.fk_owner AS ws_fk_owner
   FROM tww_od.maintenance_event maint_evnt
     LEFT JOIN tww_od.maintenance maintenance ON maintenance.obj_id=maint_evnt.obj_id
	 LEFT JOIN tww_od.re_maintenance_event_wastewater_structure re_m_w ON maint_evnt.obj_id::text = re_m_w.fk_maintenance_event::text
     LEFT JOIN tww_od.wastewater_structure ws ON re_m_w.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.reach reach ON reach.obj_id::text = ne.obj_id::text
	 LEFT JOIN tww_od.reach_point rp_from on rp_from.obj_id=reach.fk_reach_point_from
	 LEFT JOIN tww_od.reach_point rp_to on rp_to.obj_id=reach.fk_reach_point_to
	 LEFT JOIN tww_od.wastewater_node wn_from on rp_from.fk_wastewater_networkelement=wn_from.obj_id
	 LEFT JOIN tww_od.wastewater_node wn_to on rp_to.fk_wastewater_networkelement=wn_to.obj_id
  WHERE ch.obj_id IS NOT NULL;
  
ALTER TABLE tww_app.vw_tww_maint_evnt_on_reach
  OWNER TO tww_sysadmin;
GRANT SELECT ON TABLE tww_app.vw_tww_maint_evnt_on_reach TO tww_viewer;
