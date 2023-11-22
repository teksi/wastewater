DROP VIEW IF EXISTS tww_app.vw_groundwater_protection_zone;


--------
-- Subclass: groundwater_protection_zone
-- Superclass: zone
--------
CREATE OR REPLACE VIEW tww_app.vw_groundwater_protection_zone AS

SELECT
   GZ.obj_id
   , GZ.kind
   , GZ.perimeter_geometry
   , ZO.identifier
   , ZO.remark
   , ZO.fk_dataowner
   , ZO.fk_provider
   , ZO.last_modification
  FROM tww_od.groundwater_protection_zone GZ
 LEFT JOIN tww_od.zone ZO
 ON ZO.obj_id = GZ.obj_id;

-----------------------------------
-- groundwater_protection_zone INSERT
-- Function: vw_groundwater_protection_zone_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_groundwater_protection_zone_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','groundwater_protection_zone')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.groundwater_protection_zone (
             obj_id
           , kind
           , perimeter_geometry
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.kind
           , NEW.perimeter_geometry
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_groundwater_protection_zone_ON_INSERT ON tww_od.groundwater_protection_zone;

CREATE TRIGGER vw_groundwater_protection_zone_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_groundwater_protection_zone
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_groundwater_protection_zone_insert();

-----------------------------------
-- groundwater_protection_zone UPDATE
-- Rule: vw_groundwater_protection_zone_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_groundwater_protection_zone_ON_UPDATE AS ON UPDATE TO tww_app.vw_groundwater_protection_zone DO INSTEAD (
UPDATE tww_od.groundwater_protection_zone
  SET
       kind = NEW.kind
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
-- groundwater_protection_zone DELETE
-- Rule: vw_groundwater_protection_zone_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_groundwater_protection_zone_ON_DELETE AS ON DELETE TO tww_app.vw_groundwater_protection_zone DO INSTEAD (
  DELETE FROM tww_od.groundwater_protection_zone WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.zone WHERE obj_id = OLD.obj_id;
);
