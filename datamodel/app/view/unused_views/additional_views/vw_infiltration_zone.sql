DROP VIEW IF EXISTS tww_app.vw_infiltration_zone;


--------
-- Subclass: infiltration_zone
-- Superclass: zone
--------
CREATE OR REPLACE VIEW tww_app.vw_infiltration_zone AS

SELECT
   IZ.obj_id
   , IZ.infiltration_capacity
   , IZ.perimeter_geometry
   , ZO.identifier
   , ZO.remark
   , ZO.fk_dataowner
   , ZO.fk_provider
   , ZO.last_modification
  FROM tww_od.infiltration_zone IZ
 LEFT JOIN tww_od.zone ZO
 ON ZO.obj_id = IZ.obj_id;

-----------------------------------
-- infiltration_zone INSERT
-- Function: vw_infiltration_zone_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_infiltration_zone_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO tww_od.zone (
             obj_id
           , identifier
           , remark
           , fk_dataowner
           , fk_provider
           , last_modification
           )
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','infiltration_zone')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.infiltration_zone (
             obj_id
           , infiltration_capacity
           , perimeter_geometry
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.infiltration_capacity
           , NEW.perimeter_geometry
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_infiltration_zone_ON_INSERT ON tww_od.infiltration_zone;

CREATE TRIGGER vw_infiltration_zone_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_infiltration_zone
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_infiltration_zone_insert();

-----------------------------------
-- infiltration_zone UPDATE
-- Rule: vw_infiltration_zone_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_infiltration_zone_ON_UPDATE AS ON UPDATE TO tww_app.vw_infiltration_zone DO INSTEAD (
UPDATE tww_od.infiltration_zone
  SET
       infiltration_capacity = NEW.infiltration_capacity
     , perimeter_geometry = NEW.perimeter_geometry
  WHERE obj_id = OLD.obj_id;

UPDATE tww_od.zone
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- infiltration_zone DELETE
-- Rule: vw_infiltration_zone_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_infiltration_zone_ON_DELETE AS ON DELETE TO tww_app.vw_infiltration_zone DO INSTEAD (
  DELETE FROM tww_od.infiltration_zone WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.zone WHERE obj_id = OLD.obj_id;
);
