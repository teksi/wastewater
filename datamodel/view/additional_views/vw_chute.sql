DROP VIEW IF EXISTS tww_od.vw_chute;


--------
-- Subclass: chute
-- Superclass: water_control_structure
--------
CREATE OR REPLACE VIEW tww_od.vw_chute AS

SELECT
   CE.obj_id
   , CE.kind
   , CE.material
   , CE.vertical_drop
   , CS.identifier
   , CS.remark,
CS.situation_geometry
   , CS.fk_dataowner
   , CS.fk_provider
   , CS.last_modification
  , CS.fk_water_course_segment
  FROM tww_od.chute CE
 LEFT JOIN tww_od.water_control_structure CS
 ON CS.obj_id = CE.obj_id;

-----------------------------------
-- chute INSERT
-- Function: vw_chute_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_od.vw_chute_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','chute')) -- obj_id
           , NEW.identifier
           , NEW.remark
            , NEW.situation_geometry
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_water_course_segment
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.chute (
             obj_id
           , kind
           , material
           , vertical_drop
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.kind
           , NEW.material
           , NEW.vertical_drop
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_chute_ON_INSERT ON tww_od.chute;

CREATE TRIGGER vw_chute_ON_INSERT INSTEAD OF INSERT ON tww_od.vw_chute
  FOR EACH ROW EXECUTE PROCEDURE tww_od.vw_chute_insert();

-----------------------------------
-- chute UPDATE
-- Rule: vw_chute_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_chute_ON_UPDATE AS ON UPDATE TO tww_od.vw_chute DO INSTEAD (
UPDATE tww_od.chute
  SET
       kind = NEW.kind
     , material = NEW.material
     , vertical_drop = NEW.vertical_drop
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
-- chute DELETE
-- Rule: vw_chute_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_chute_ON_DELETE AS ON DELETE TO tww_od.vw_chute DO INSTEAD (
  DELETE FROM tww_od.chute WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.water_control_structure WHERE obj_id = OLD.obj_id;
);

