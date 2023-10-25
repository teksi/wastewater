DROP VIEW IF EXISTS qgep_od.vw_fountain;


--------
-- Subclass: fountain
-- Superclass: connection_object
--------
CREATE OR REPLACE VIEW qgep_od.vw_fountain AS

SELECT
   FO.obj_id
   , FO.location_name
   , FO.situation_geometry
   , CN.identifier
   , CN.remark
   , CN.sewer_infiltration_water_production
   , CN.fk_dataowner
   , CN.fk_provider
   , CN.last_modification
  , CN.fk_wastewater_networkelement
  , CN.fk_owner
  , CN.fk_operator
  FROM qgep_od.fountain FO
 LEFT JOIN qgep_od.connection_object CN
 ON CN.obj_id = FO.obj_id;

-----------------------------------
-- fountain INSERT
-- Function: vw_fountain_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_fountain_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep_od.connection_object (
             obj_id
           , identifier
           , remark
           , sewer_infiltration_water_production
           , fk_dataowner
           , fk_provider
           , last_modification
           , fk_wastewater_networkelement
           , fk_owner
           , fk_operator
           )
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','fountain')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.sewer_infiltration_water_production
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_wastewater_networkelement
           , NEW.fk_owner
           , NEW.fk_operator
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.fountain (
             obj_id
           , location_name
           , situation_geometry
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.location_name
           , NEW.situation_geometry
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_fountain_ON_INSERT ON qgep_od.fountain;

CREATE TRIGGER vw_fountain_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_fountain
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_fountain_insert();

-----------------------------------
-- fountain UPDATE
-- Rule: vw_fountain_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_fountain_ON_UPDATE AS ON UPDATE TO qgep_od.vw_fountain DO INSTEAD (
UPDATE qgep_od.fountain
  SET
       location_name = NEW.location_name
     , situation_geometry = NEW.situation_geometry
  WHERE obj_id = OLD.obj_id;

UPDATE qgep_od.connection_object
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
     , sewer_infiltration_water_production = NEW.sewer_infiltration_water_production
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
     , fk_wastewater_networkelement = NEW.fk_wastewater_networkelement
     , fk_owner = NEW.fk_owner
     , fk_operator = NEW.fk_operator
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- fountain DELETE
-- Rule: vw_fountain_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_fountain_ON_DELETE AS ON DELETE TO qgep_od.vw_fountain DO INSTEAD (
  DELETE FROM qgep_od.fountain WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.connection_object WHERE obj_id = OLD.obj_id;
);

