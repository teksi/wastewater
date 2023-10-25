DROP VIEW IF EXISTS tww_od.vw_dam;


--------
-- Subclass: dam
-- Superclass: water_control_structure
--------
CREATE OR REPLACE VIEW tww_od.vw_dam AS

SELECT
   DA.obj_id
   , DA.kind
   , DA.vertical_drop
   , CS.identifier
   , CS.remark,
CS.situation_geometry
   , CS.fk_dataowner
   , CS.fk_provider
   , CS.last_modification
  , CS.fk_water_course_segment
  FROM tww_od.dam DA
 LEFT JOIN tww_od.water_control_structure CS
 ON CS.obj_id = DA.obj_id;

-----------------------------------
-- dam INSERT
-- Function: vw_dam_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_od.vw_dam_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','dam')) -- obj_id
           , NEW.identifier
           , NEW.remark
            , NEW.situation_geometry
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_water_course_segment
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.dam (
             obj_id
           , kind
           , vertical_drop
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.kind
           , NEW.vertical_drop
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_dam_ON_INSERT ON tww_od.dam;

CREATE TRIGGER vw_dam_ON_INSERT INSTEAD OF INSERT ON tww_od.vw_dam
  FOR EACH ROW EXECUTE PROCEDURE tww_od.vw_dam_insert();

-----------------------------------
-- dam UPDATE
-- Rule: vw_dam_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_dam_ON_UPDATE AS ON UPDATE TO tww_od.vw_dam DO INSTEAD (
UPDATE tww_od.dam
  SET
       kind = NEW.kind
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
-- dam DELETE
-- Rule: vw_dam_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_dam_ON_DELETE AS ON DELETE TO tww_od.vw_dam DO INSTEAD (
  DELETE FROM tww_od.dam WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.water_control_structure WHERE obj_id = OLD.obj_id;
);

