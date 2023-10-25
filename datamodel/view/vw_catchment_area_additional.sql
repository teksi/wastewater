-- View: qgep_od.vw_catchment_area_additional

-- DROP VIEW qgep_od.vw_catchment_area_additional;

CREATE OR REPLACE VIEW qgep_od.vw_catchment_area_additional AS
 SELECT ca.obj_id,
    ca.fk_wastewater_networkelement_rw_current::text = ca.fk_wastewater_networkelement_ww_current::text AS current_ww_is_rw,
    ca.fk_wastewater_networkelement_rw_planned::text = ca.fk_wastewater_networkelement_ww_planned::text AS planned_ww_is_rw,
	  ca.fk_wastewater_networkelement_ww_planned::text = ca.fk_wastewater_networkelement_ww_current::text AS ww_planned_is_current,
    ca.fk_wastewater_networkelement_rw_planned::text = ca.fk_wastewater_networkelement_rw_current::text AS rw_planned_is_current
   
   FROM qgep_od.catchment_area ca;
