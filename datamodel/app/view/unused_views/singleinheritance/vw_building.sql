DROP VIEW IF EXISTS tww_app.vw_building;


--------
-- Subclass: building
-- Superclass: connection_object
--------
CREATE OR REPLACE VIEW tww_app.vw_building AS

SELECT
   BU.obj_id
   , BU.house_number
   , BU.location_name
   , BU.perimeter_geometry
   , BU.reference_point_geometry
   , CN.identifier
   , CN.remark
   , CN.sewer_infiltration_water_production
   , CN.fk_dataowner
   , CN.fk_provider
   , CN.last_modification
  , CN.fk_wastewater_networkelement
  , CN.fk_owner
  , CN.fk_operator
  FROM tww_od.building BU
 LEFT JOIN tww_od.connection_object CN
 ON CN.obj_id = BU.obj_id;

-----------------------------------
-- building INSERT
-- Function: vw_building_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_building_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO tww_od.connection_object (
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','building')) -- obj_id
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

INSERT INTO tww_od.building (
             obj_id
           , house_number
           , location_name
           , perimeter_geometry
           , reference_point_geometry
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.house_number
           , NEW.location_name
           , NEW.perimeter_geometry
           , NEW.reference_point_geometry
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_building_ON_INSERT ON tww_od.building;

CREATE TRIGGER vw_building_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_building
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_building_insert();

-----------------------------------
-- building UPDATE
-- Rule: vw_building_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_building_ON_UPDATE AS ON UPDATE TO tww_app.vw_building DO INSTEAD (
UPDATE tww_od.building
  SET
       house_number = NEW.house_number
     , location_name = NEW.location_name
     , perimeter_geometry = NEW.perimeter_geometry
     , reference_point_geometry = NEW.reference_point_geometry
  WHERE obj_id = OLD.obj_id;

UPDATE tww_od.connection_object
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
-- building DELETE
-- Rule: vw_building_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_building_ON_DELETE AS ON DELETE TO tww_app.vw_building DO INSTEAD (
  DELETE FROM tww_od.building WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.connection_object WHERE obj_id = OLD.obj_id;
);
