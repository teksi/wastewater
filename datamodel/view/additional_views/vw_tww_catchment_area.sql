CREATE OR REPLACE VIEW qgep_od.vw_qgep_catchment_area AS

SELECT
  CA.obj_id,
  direct_discharge_current,
  direct_discharge_planned,
  discharge_coefficient_rw_current,
  discharge_coefficient_rw_planned,
  discharge_coefficient_ww_current,
  discharge_coefficient_ww_planned,
  drainage_system_current,
  drainage_system_planned,
  CA.identifier,
  infiltration_current,
  infiltration_planned,
  perimeter_geometry,
  population_density_current,
  population_density_planned,
  CA.remark,
  retention_current,
  retention_planned,
  runoff_limit_current,
  runoff_limit_planned,
  seal_factor_rw_current,
  seal_factor_rw_planned,
  seal_factor_ww_current,
  seal_factor_ww_planned,
  sewer_infiltration_water_production_current,
  sewer_infiltration_water_production_planned,
  surface_area,
  waste_water_production_current,
  waste_water_production_planned,
  CA.last_modification,
  CA.fk_dataowner,
  CA.fk_provider,
  fk_wastewater_networkelement_rw_current,
  fk_wastewater_networkelement_rw_planned,
  fk_wastewater_networkelement_ww_planned,
  fk_wastewater_networkelement_ww_current,
  NE_rw_current.identifier AS rw_current_identifier,
  NE_rw_planned.identifier AS rw_planned_identifier,
  NE_ww_planned.identifier AS ww_planned_identifier,
  NE_ww_current.identifier AS ww_current_identifier
  FROM qgep_od.catchment_area CA
LEFT JOIN qgep_od.wastewater_networkelement NE_rw_current
 ON CA.fk_wastewater_networkelement_rw_current = NE_rw_current.obj_id
LEFT JOIN qgep_od.wastewater_networkelement NE_rw_planned
 ON CA.fk_wastewater_networkelement_rw_planned = NE_rw_planned.obj_id
LEFT JOIN qgep_od.wastewater_networkelement NE_ww_planned
 ON CA.fk_wastewater_networkelement_ww_planned = NE_ww_planned.obj_id
LEFT JOIN qgep_od.wastewater_networkelement NE_ww_current
 ON CA.fk_wastewater_networkelement_ww_current = NE_ww_current.obj_id;


-----------------------------------
-- catchment_area INSERT
-- Function: vw_qgep_catchment_area_insert()
-----------------------------------


CREATE OR REPLACE FUNCTION qgep_od.vw_qgep_catchment_area_insert()
  RETURNS trigger AS
$BODY$
BEGIN
INSERT INTO qgep_od.catchment_area(
   obj_id
  , direct_discharge_current
  , direct_discharge_planned
  , discharge_coefficient_rw_current
  , discharge_coefficient_rw_planned
  , discharge_coefficient_ww_current
  , discharge_coefficient_ww_planned
  , drainage_system_current
  , drainage_system_planned
  , identifier
  , infiltration_current
  , infiltration_planned
  , perimeter_geometry
  , population_density_current
  , population_density_planned
  , remark
  , retention_current
  , retention_planned
  , runoff_limit_current
  , runoff_limit_planned
  , seal_factor_rw_current
  , seal_factor_rw_planned
  , seal_factor_ww_current
  , seal_factor_ww_planned
  , sewer_infiltration_water_production_current
  , sewer_infiltration_water_production_planned
  , surface_area
  , waste_water_production_current
  , waste_water_production_planned
  , last_modification
  , fk_dataowner
  , fk_provider
  , fk_wastewater_networkelement_rw_current
  , fk_wastewater_networkelement_rw_planned
  , fk_wastewater_networkelement_ww_planned
  , fk_wastewater_networkelement_ww_current)
VALUES (
    COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','catchment_area'))
  , NEW.direct_discharge_current
  , NEW.direct_discharge_planned=NEW.NEW.direct_discharge_planned
  , NEW.discharge_coefficient_rw_current
  , NEW.discharge_coefficient_rw_planned
  , NEW.discharge_coefficient_ww_current
  , NEW.discharge_coefficient_ww_planned
  , NEW.drainage_system_current
  , NEW.drainage_system_planned
  , NEW.identifier
  , NEW.infiltration_current
  , NEW.infiltration_planned
  , NEW.perimeter_geometry
  , NEW.population_density_current
  , NEW.population_density_planned
  , NEW.remark
  , NEW.retention_current
  , NEW.retention_planned
  , NEW.runoff_limit_current
  , NEW.runoff_limit_planned
  , NEW.seal_factor_rw_current
  , NEW.seal_factor_rw_planned
  , NEW.seal_factor_ww_current
  , NEW.seal_factor_ww_planned
  , NEW.sewer_infiltration_water_production_current
  , NEW.sewer_infiltration_water_production_planned
  , NEW.surface_area
  , NEW.waste_water_production_current
  , NEW.waste_water_production_planned
  , NEW.last_modification
  , NEW.fk_dataowner
  , NEW.fk_provider
  , NEW.fk_wastewater_networkelement_rw_current
  , NEW.fk_wastewater_networkelement_rw_planned
  , NEW.fk_wastewater_networkelement_ww_planned
  , NEW.fk_wastewater_networkelement_ww_current
)
RETURNING obj_id INTO NEW.obj_id;
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


-- DROP TRIGGER vw_qgep_catchment_area_ON_INSERT ON qgep_od.catchment_area;

CREATE TRIGGER vw_qgep_catchment_area_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_qgep_catchment_area
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_qgep_catchment_area_insert();


-----------------------------------
-- catchment_area UPDATE
-- Function: vw_qgep_catchment_area_ON_UPDATE()
-----------------------------------


CREATE OR REPLACE RULE vw_qgep_catchment_area_ON_UPDATE AS ON UPDATE TO qgep_od.vw_qgep_catchment_area DO INSTEAD (
UPDATE qgep_od.catchment_area
  SET
    direct_discharge_current=NEW.direct_discharge_current
  , direct_discharge_planned=NEW.direct_discharge_planned
  , discharge_coefficient_rw_current=NEW.discharge_coefficient_rw_current
  , discharge_coefficient_rw_planned=NEW.discharge_coefficient_rw_planned
  , discharge_coefficient_ww_current=NEW.discharge_coefficient_ww_current
  , discharge_coefficient_ww_planned=NEW.discharge_coefficient_ww_planned
  , drainage_system_current=NEW.drainage_system_current
  , drainage_system_planned=NEW.drainage_system_planned
  , identifier=NEW.identifier
  , infiltration_current=NEW.infiltration_current
  , infiltration_planned=NEW.infiltration_planned
  , perimeter_geometry=NEW.perimeter_geometry
  , population_density_current=NEW.population_density_current
  , population_density_planned=NEW.population_density_planned
  , remark=NEW.remark
  , retention_current=NEW.retention_current
  , retention_planned=NEW.retention_planned
  , runoff_limit_current=NEW.runoff_limit_current
  , runoff_limit_planned=NEW.runoff_limit_planned
  , seal_factor_rw_current=NEW.seal_factor_rw_current
  , seal_factor_rw_planned=NEW.seal_factor_rw_planned
  , seal_factor_ww_current=NEW.seal_factor_ww_current
  , seal_factor_ww_planned=NEW.seal_factor_ww_planned
  , sewer_infiltration_water_production_current=NEW.sewer_infiltration_water_production_current
  , sewer_infiltration_water_production_planned=NEW.sewer_infiltration_water_production_planned
  , surface_area=NEW.surface_area
  , waste_water_production_current=NEW.waste_water_production_current
  , waste_water_production_planned=NEW.waste_water_production_planned
  , last_modification=NEW.last_modification
  , fk_dataowner=NEW.fk_dataowner
  , fk_provider=NEW.fk_provider
  , fk_wastewater_networkelement_rw_current=NEW.fk_wastewater_networkelement_rw_current
  , fk_wastewater_networkelement_rw_planned=NEW.fk_wastewater_networkelement_rw_planned
  , fk_wastewater_networkelement_ww_planned=NEW.fk_wastewater_networkelement_ww_planned
  , fk_wastewater_networkelement_ww_current=NEW.fk_wastewater_networkelement_ww_current

  WHERE obj_id=OLD.obj_id;
);


-----------------------------------
-- catchment_area DELETE
-- Rule: vw_qgep_catchment_area_ON_DELETE ()
-----------------------------------


CREATE OR REPLACE RULE vw_qgep_catchment_area_ON_DELETE AS ON DELETE TO qgep_od.vw_qgep_catchment_area DO
INSTEAD (
  DELETE FROM qgep_od.catchment_area WHERE obj_id = OLD.obj_id;
);

