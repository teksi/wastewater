DROP VIEW IF EXISTS qgep_od.vw_param_ca_general;


--------
-- Subclass: param_ca_general
-- Superclass: surface_runoff_parameters
--------
CREATE OR REPLACE VIEW qgep_od.vw_param_ca_general AS

SELECT
   PC.obj_id
   , PC.dry_wheather_flow
   , PC.flow_path_length
   , PC.flow_path_slope
   , PC.population_equivalent
   , PC.surface_ca
   , SR.evaporation_loss
   , SR.identifier
   , SR.infiltration_loss
   , SR.remark
   , SR.surface_storage
   , SR.wetting_loss
   , SR.fk_dataowner
   , SR.fk_provider
   , SR.last_modification
  , SR.fk_catchment_area
  FROM qgep_od.param_ca_general PC
 LEFT JOIN qgep_od.surface_runoff_parameters SR
 ON SR.obj_id = PC.obj_id;

-----------------------------------
-- param_ca_general INSERT
-- Function: vw_param_ca_general_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_param_ca_general_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep_od.surface_runoff_parameters (
             obj_id
           , evaporation_loss
           , identifier
           , infiltration_loss
           , remark
           , surface_storage
           , wetting_loss
           , fk_dataowner
           , fk_provider
           , last_modification
           , fk_catchment_area
           )
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','param_ca_general')) -- obj_id
           , NEW.evaporation_loss
           , NEW.identifier
           , NEW.infiltration_loss
           , NEW.remark
           , NEW.surface_storage
           , NEW.wetting_loss
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_catchment_area
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.param_ca_general (
             obj_id
           , dry_wheather_flow
           , flow_path_length
           , flow_path_slope
           , population_equivalent
           , surface_ca
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.dry_wheather_flow
           , NEW.flow_path_length
           , NEW.flow_path_slope
           , NEW.population_equivalent
           , NEW.surface_ca
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_param_ca_general_ON_INSERT ON qgep_od.param_ca_general;

CREATE TRIGGER vw_param_ca_general_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_param_ca_general
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_param_ca_general_insert();

-----------------------------------
-- param_ca_general UPDATE
-- Rule: vw_param_ca_general_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_param_ca_general_ON_UPDATE AS ON UPDATE TO qgep_od.vw_param_ca_general DO INSTEAD (
UPDATE qgep_od.param_ca_general
  SET
       dry_wheather_flow = NEW.dry_wheather_flow
     , flow_path_length = NEW.flow_path_length
     , flow_path_slope = NEW.flow_path_slope
     , population_equivalent = NEW.population_equivalent
     , surface_ca = NEW.surface_ca
  WHERE obj_id = OLD.obj_id;

UPDATE qgep_od.surface_runoff_parameters
  SET
       evaporation_loss = NEW.evaporation_loss
     , identifier = NEW.identifier
     , infiltration_loss = NEW.infiltration_loss
     , remark = NEW.remark
     , surface_storage = NEW.surface_storage
     , wetting_loss = NEW.wetting_loss
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
     , fk_catchment_area = NEW.fk_catchment_area
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- param_ca_general DELETE
-- Rule: vw_param_ca_general_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_param_ca_general_ON_DELETE AS ON DELETE TO qgep_od.vw_param_ca_general DO INSTEAD (
  DELETE FROM qgep_od.param_ca_general WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.surface_runoff_parameters WHERE obj_id = OLD.obj_id;
);

