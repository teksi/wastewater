DROP VIEW IF EXISTS tww_app.vw_ford;


--------
-- Subclass: ford
-- Superclass: water_control_structure
--------
CREATE OR REPLACE VIEW tww_app.vw_ford AS

SELECT
   FD.obj_id
   , CS.identifier
   , CS.remark,
CS.situation_geometry
   , CS.fk_dataowner
   , CS.fk_provider
   , CS.last_modification
  , CS.fk_water_course_segment
  FROM tww_od.ford FD
 LEFT JOIN tww_od.water_control_structure CS
 ON CS.obj_id = FD.obj_id;

-----------------------------------
-- ford INSERT
-- Function: vw_ford_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_ford_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','ford')) -- obj_id
           , NEW.identifier
           , NEW.remark
            , NEW.situation_geometry
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_water_course_segment
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.ford (
             obj_id
           )
          VALUES (
            NEW.obj_id -- obj_id
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_ford_ON_INSERT ON tww_od.ford;

CREATE TRIGGER vw_ford_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_ford
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_ford_insert();

-----------------------------------
-- ford UPDATE
-- Rule: vw_ford_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_ford_ON_UPDATE AS ON UPDATE TO tww_app.vw_ford DO INSTEAD (
--------
-- UPDATE tww_od.ford
--  SET
--  WHERE obj_id = OLD.obj_id;
--------

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
-- ford DELETE
-- Rule: vw_ford_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_ford_ON_DELETE AS ON DELETE TO tww_app.vw_ford DO INSTEAD (
  DELETE FROM tww_od.ford WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.water_control_structure WHERE obj_id = OLD.obj_id;
);
