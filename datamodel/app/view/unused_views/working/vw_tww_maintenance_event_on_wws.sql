-- View: tww_app.vw_tww_maintenance_on_wws

-- DROP VIEW tww_app.vw_tww_maintenance_on_wws;

CREATE OR REPLACE VIEW tww_app.vw_tww_maintenance_on_wws
 AS
 SELECT mw.id AS re_m_w_id,
    me.obj_id,
    me.identifier,
    ws.identifier AS ws_idenifier,
    ws.renovation_necessity AS ws_renovation_necessity,
    ws.urgency_figure AS ws_urgency_figure,
    me.cost,
    me.reason,
    me.result,
    me.remark,
    me.base_data,
    me.status,
    me.operator,
    me.time_point,
    mn.kind,
    ws.fk_owner AS ws_fk_owner,
    ws.status AS ws_status,
    me.data_details,
    me.duration,
    me.last_modification,
    me.fk_operating_company,
    node.situation3d_geometry
   FROM tww_od.maintenance_event me
     LEFT JOIN tww_od.maintenance mn ON mn.obj_id::text = me.obj_id::text
     LEFT JOIN tww_od.re_maintenance_event_wastewater_structure mw ON me.obj_id::text = mw.fk_maintenance_event::text
     LEFT JOIN tww_od.wastewater_structure ws ON mw.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_node node ON node.obj_id::text = ws.fk_main_wastewater_node::text
  WHERE node.obj_id IS NOT NULL;

ALTER TABLE tww_app.vw_tww_maintenance_on_wws
    OWNER TO postgres;

-- GRANT ALL ON TABLE tww_app.vw_tww_maintenance_on_wws TO tww_user;
-- GRANT ALL ON TABLE tww_app.vw_tww_maintenance_on_wws TO postgres;
-- GRANT SELECT, REFERENCES, TRIGGER ON TABLE tww_app.vw_tww_maintenance_on_wws TO tww_viewer;

CREATE TRIGGER ft_vw_tww_maintenance_on_wws_on_update
    INSTEAD OF UPDATE
    ON tww_app.vw_tww_maintenance_on_wws
    FOR EACH ROW
    EXECUTE PROCEDURE tww_app.ft_vw_tww_maintenance_on_reach_wws_update();
