-- View: qgep_od.vw_qgep_maintenance_on_wws

-- DROP VIEW qgep_od.vw_qgep_maintenance_on_wws;

CREATE OR REPLACE VIEW qgep_od.vw_qgep_maintenance_on_wws AS 
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
    node.situation_geometry,
    ws.identifier AS ws_idenifier,
    ws.status AS ws_status,
    ws.fk_owner AS ws_fk_owner
   FROM qgep_od.maintenance_event maintenance
     LEFT JOIN qgep_od.re_maintenance_event_wastewater_structure re_m_w ON maintenance.obj_id::text = re_m_w.fk_maintenance_event::text
     LEFT JOIN qgep_od.wastewater_structure ws ON re_m_w.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN qgep_od.wastewater_node node ON node.obj_id::text = ne.obj_id::text
   WHERE node.obj_id is not null;
        

ALTER TABLE qgep_od.vw_qgep_maintenance_on_wws
  OWNER TO postgres;
GRANT ALL ON TABLE qgep_od.vw_qgep_maintenance_on_wws TO postgres;
GRANT ALL ON TABLE qgep_od.vw_qgep_maintenance_on_wws TO qgep;
