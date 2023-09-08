DROP VIEW IF EXISTS qgep_od.vw_ground_water_protection_perimeter;


--------
-- Subclass: ground_water_protection_perimeter
-- Superclass: zone
--------
CREATE OR REPLACE VIEW qgep_od.vw_ground_water_protection_perimeter AS

SELECT
   GP.obj_id
   , GP.perimeter_geometry
   , ZO.identifier
   , ZO.remark
   , ZO.fk_dataowner
   , ZO.fk_provider
   , ZO.last_modification
  FROM qgep_od.ground_water_protection_perimeter GP
 LEFT JOIN qgep_od.zone ZO
 ON ZO.obj_id = GP.obj_id;

-----------------------------------
-- ground_water_protection_perimeter INSERT
-- Function: vw_ground_water_protection_perimeter_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_ground_water_protection_perimeter_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep_od.zone (
             obj_id
           , identifier
           , remark
           , fk_dataowner
           , fk_provider
           , last_modification
           )
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','ground_water_protection_perimeter')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.ground_water_protection_perimeter (
             obj_id
           , perimeter_geometry
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.perimeter_geometry
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_ground_water_protection_perimeter_ON_INSERT ON qgep_od.ground_water_protection_perimeter;

CREATE TRIGGER vw_ground_water_protection_perimeter_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_ground_water_protection_perimeter
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_ground_water_protection_perimeter_insert();

-----------------------------------
-- ground_water_protection_perimeter UPDATE
-- Rule: vw_ground_water_protection_perimeter_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_ground_water_protection_perimeter_ON_UPDATE AS ON UPDATE TO qgep_od.vw_ground_water_protection_perimeter DO INSTEAD (
UPDATE qgep_od.ground_water_protection_perimeter
  SET
     , perimeter_geometry = NEW.perimeter_geometry
  WHERE obj_id = OLD.obj_id;

UPDATE qgep_od.zone
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- ground_water_protection_perimeter DELETE
-- Rule: vw_ground_water_protection_perimeter_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_ground_water_protection_perimeter_ON_DELETE AS ON DELETE TO qgep_od.vw_ground_water_protection_perimeter DO INSTEAD (
  DELETE FROM qgep_od.ground_water_protection_perimeter WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.zone WHERE obj_id = OLD.obj_id;
);

