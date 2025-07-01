-- FUNCTION: tww_app.ft_vw_tww_maintenance_on_reach_wws_update()

-- DROP FUNCTION tww_app.ft_vw_tww_maintenance_on_reach_wws_update();

CREATE FUNCTION tww_app.ft_vw_tww_maintenance_on_reach_wws_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
UPDATE tww_od.maintenance_event SET
      base_data = NEW.base_data
      , cost = NEW.cost
      , data_details = NEW.data_details
      , duration = NEW.duration
     -- , fk_dataowner = NEW.fk_dataowner
     -- , fk_measure = NEW.fk_measure
      , fk_operating_company = NEW.fk_operating_company
     -- , fk_provider = NEW.fk_provider
      , identifier = NEW.identifier
      , last_modification = NEW.last_modification
      , operator = NEW.operator
      , reason = NEW.reason
      , remark = NEW.remark
      , result = NEW.result
      , status = NEW.status
      , time_point = NEW.time_point
    WHERE obj_id = OLD.obj_id;

UPDATE tww_od.maintenance SET
      obj_id = NEW.obj_id
      , kind = NEW.kind
    WHERE obj_id = OLD.obj_id;
RETURN NEW;
END;
$BODY$;

ALTER FUNCTION tww_app.ft_vw_tww_maintenance_on_reach_wws_update()
    OWNER TO postgres;


-- View: tww_app.vw_tww_maintenance_on_reach

-- DROP VIEW tww_app.vw_tww_maintenance_on_reach;

CREATE OR REPLACE VIEW tww_app.vw_tww_maintenance_on_reach
 AS
 SELECT mw.id AS re_m_w_id,
    me.obj_id,
    me.identifier,
    ws_from.identifier AS ws_from_identifier,
    ws_to.identifier AS ws_to_identifier,
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
    re.length_effective AS re_length_effective,
    re.material AS re_material,
    re.clear_height AS re_clear_height,
    ch.function_hierarchic AS ch_function_hierarchic,
    ch.usage_current AS ch_usage_current,
    ws.status AS ws_status,
    me.data_details,
    me.duration,
    me.last_modification,
    me.fk_operating_company,
    re.progression3d_geometry,
    ws.obj_id AS ws_obj_id,
    re.obj_id AS re_obj_id,
    ws.fk_dataowner AS ws_fk_dataowner
   FROM tww_od.maintenance_event me
     LEFT JOIN tww_od.maintenance mn ON mn.obj_id::text = me.obj_id::text
     LEFT JOIN tww_od.re_maintenance_event_wastewater_structure mw ON me.obj_id::text = mw.fk_maintenance_event::text
     LEFT JOIN tww_od.wastewater_structure ws ON mw.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.reach re ON re.obj_id::text = ne.obj_id::text
     LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
     LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id::text = re.fk_reach_point_to::text
     LEFT JOIN tww_od.wastewater_networkelement ak_from ON ak_from.obj_id::text = rp_from.fk_wastewater_networkelement::text
     LEFT JOIN tww_od.wastewater_networkelement ak_to ON ak_to.obj_id::text = rp_to.fk_wastewater_networkelement::text
     LEFT JOIN tww_od.wastewater_structure ws_from ON ws_from.obj_id::text = ak_from.fk_wastewater_structure::text
     LEFT JOIN tww_od.wastewater_structure ws_to ON ws_to.obj_id::text = ak_to.fk_wastewater_structure::text
  WHERE ch.obj_id IS NOT NULL;

ALTER TABLE tww_app.vw_tww_maintenance_on_reach
  OWNER TO tww_sysadmin;
GRANT SELECT ON TABLE tww_app.vw_tww_maintenance_on_reach TO tww_viewer;
