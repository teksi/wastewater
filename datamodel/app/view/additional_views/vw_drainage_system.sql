DROP VIEW IF EXISTS tww_app.vw_drainage_system;


--------
-- Subclass: drainage_system
-- Superclass: zone
--------
CREATE OR REPLACE VIEW tww_app.vw_drainage_system AS

SELECT
   DS.obj_id
   , DS.kind
   , DS.perimeter_geometry
   , ZO.identifier
   , ZO.remark
   , ZO.fk_dataowner
   , ZO.fk_provider
   , ZO.last_modification
  FROM tww_od.drainage_system DS
 LEFT JOIN tww_od.zone ZO
 ON ZO.obj_id = DS.obj_id;

-----------------------------------
-- drainage_system INSERT
-- Function: vw_drainage_system_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_drainage_system_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','drainage_system')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.drainage_system (
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

-- DROP TRIGGER vw_drainage_system_ON_INSERT ON tww_od.drainage_system;

CREATE TRIGGER vw_drainage_system_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_drainage_system
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_drainage_system_insert();

-----------------------------------
-- drainage_system UPDATE
-- Rule: vw_drainage_system_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_drainage_system_ON_UPDATE AS ON UPDATE TO tww_app.vw_drainage_system DO INSTEAD (
UPDATE tww_od.drainage_system
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
-- drainage_system DELETE
-- Rule: vw_drainage_system_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_drainage_system_ON_DELETE AS ON DELETE TO tww_app.vw_drainage_system DO INSTEAD (
  DELETE FROM tww_od.drainage_system WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.zone WHERE obj_id = OLD.obj_id;
);
