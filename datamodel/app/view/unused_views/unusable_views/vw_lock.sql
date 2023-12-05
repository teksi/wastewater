DROP VIEW IF EXISTS tww_app.vw_lock;


--------
-- Subclass: lock
-- Superclass: water_control_structure
--------
CREATE OR REPLACE VIEW tww_app.vw_lock AS

SELECT
   LO.obj_id
   , LO.vertical_drop
   , CS.identifier
   , CS.remark,
CS.situation_geometry
   , CS.fk_dataowner
   , CS.fk_provider
   , CS.last_modification
  , CS.fk_water_course_segment
  FROM tww_od.lock LO
 LEFT JOIN tww_od.water_control_structure CS
 ON CS.obj_id = LO.obj_id;

-----------------------------------
-- lock INSERT
-- Function: vw_lock_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_lock_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO tww_od.water_control_structure (
             obj_id
           , identifier
           , remark
            , situation_geometry
           , fk_dataowner
           , fk_provider
           , last_modification
           , fk_water_course_segment
           )
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','lock')) -- obj_id
           , NEW.identifier
           , NEW.remark
            , NEW.situation_geometry
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_water_course_segment
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.lock (
             obj_id
           , vertical_drop
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.vertical_drop
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_lock_ON_INSERT ON tww_od.lock;

CREATE TRIGGER vw_lock_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_lock
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_lock_insert();

-----------------------------------
-- lock UPDATE
-- Rule: vw_lock_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_lock_ON_UPDATE AS ON UPDATE TO tww_app.vw_lock DO INSTEAD (
UPDATE tww_od.lock
  SET
       vertical_drop = NEW.vertical_drop
  WHERE obj_id = OLD.obj_id;

UPDATE tww_od.water_control_structure
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
      , situation_geometry = NEW.situation_geometry
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
     , fk_water_course_segment = NEW.fk_water_course_segment
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- lock DELETE
-- Rule: vw_lock_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_lock_ON_DELETE AS ON DELETE TO tww_app.vw_lock DO INSTEAD (
  DELETE FROM tww_od.lock WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.water_control_structure WHERE obj_id = OLD.obj_id;
);
