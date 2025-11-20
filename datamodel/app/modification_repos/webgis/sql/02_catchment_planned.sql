CREATE MATERIALIZED VIEW IF NOT EXISTS tww_app.mvw_web_catchment_area_planned
AS
 SELECT ca.obj_id,
    ca.identifier,
    ca.surface_area,
    ca.perimeter_geometry,
    dd.{value_lang} AS direct_discharge,
    ds.{value_lang} AS drainage_system,
    inf.{value_lang} AS infiltration,
    ret.{value_lang} AS retention,
    ca.population_density_planned AS population_density,
    ca.runoff_limit_planned AS runoff_limit,
    ca.sewer_infiltration_water_production_planned AS sewer_infiltration_water_production,
    ne_rw.identifier AS wastewater_structure_rw,
    ca.discharge_coefficient_rw_planned AS discharge_coefficient_rw,
    ca.seal_factor_rw_planned AS seal_factor_rw,
    ne_ww.identifier AS wastewater_structure_ww,
    ca.discharge_coefficient_ww_planned AS discharge_coefficient_ww,
    ca.seal_factor_ww_planned AS seal_factor_ww,
    ca.last_modification,
    ca.remark,
    ca.drainage_system_planned AS drainage_system_num,
    ds_chk.value_en::text = ds.value_en::text AS changed_ds
   FROM tww_od.catchment_area ca
     LEFT JOIN tww_vl.catchment_area_direct_discharge_planned dd ON dd.code = ca.direct_discharge_planned
     LEFT JOIN tww_vl.catchment_area_drainage_system_planned ds ON ds.code = ca.drainage_system_planned
     LEFT JOIN tww_vl.catchment_area_infiltration_planned inf ON inf.code = ca.infiltration_planned
     LEFT JOIN tww_vl.catchment_area_retention_planned ret ON ret.code = ca.retention_planned
     LEFT JOIN tww_od.wastewater_networkelement ne_rw ON ca.fk_wastewater_networkelement_rw_planned::text = ne_rw.obj_id::text
     LEFT JOIN tww_od.wastewater_networkelement ne_ww ON ca.fk_wastewater_networkelement_ww_planned::text = ne_ww.obj_id::text
WITH DATA;