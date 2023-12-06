-- View: tww_app.vw_tww_maintenance_on_wws

-- DROP VIEW tww_app.vw_tww_maintenance_on_wws;

CREATE OR REPLACE VIEW tww_app.vw_tww_maint_evnt_on_wws AS
 SELECT re_m_w.obj_id AS re_m_w_id,
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
    node.situation3d_geometry,
	ws.obj_id AS ws_obj_id,
    ws.identifier AS ws_idenifier,
    ws.status AS ws_status,
	ws.structure_condition AS ws_structure_condition,
	ws.renovation_necessity AS ws_renovation_necessity,
	ws.urgency_figure AS ws_urgency_figure,
    ws.fk_owner AS ws_fk_owner
   FROM tww_od.maintenance_event maint_evnt
     LEFT JOIN tww_od.maintenance maintenance ON maintenance.obj_id=maint_evnt.obj_id
     LEFT JOIN tww_od.re_maintenance_event_wastewater_structure re_m_w ON maint_evnt.obj_id::text = re_m_w.fk_maintenance_event::text
     LEFT JOIN tww_od.wastewater_structure ws ON re_m_w.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_node node ON node.obj_id::text = ne.obj_id::text
   WHERE node.obj_id is not null;


ALTER TABLE tww_app.vw_tww_maint_evnt_on_wws
  OWNER TO tww_sysadmin;
GRANT SELECT ON TABLE tww_app.vw_tww_maint_evnt_on_wws TO tww_viewer;
