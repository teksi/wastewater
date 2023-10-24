DROP VIEW IF EXISTS tww_app.vw_river;


--------
-- Subclass: river
-- Superclass: surface_water_bodies
--------
CREATE OR REPLACE VIEW tww_app.vw_river AS

SELECT
   RI.obj_id
   , RI.kind
   , CU.identifier
   , CU.remark
   , CU.fk_dataowner
   , CU.fk_provider
   , CU.last_modification
  FROM tww_od.river RI
 LEFT JOIN tww_od.surface_water_bodies CU
 ON CU.obj_id = RI.obj_id;

-----------------------------------
-- river INSERT
-- Function: vw_river_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_river_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO tww_od.surface_water_bodies (
             obj_id
           , identifier
           , remark
           , fk_dataowner
           , fk_provider
           , last_modification
           )
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','river')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.river (
             obj_id
           , kind
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.kind
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_river_ON_INSERT ON tww_od.river;

CREATE TRIGGER vw_river_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_river
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_river_insert();

-----------------------------------
-- river UPDATE
-- Rule: vw_river_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_river_ON_UPDATE AS ON UPDATE TO tww_app.vw_river DO INSTEAD (
UPDATE tww_od.river
  SET
       kind = NEW.kind
  WHERE obj_id = OLD.obj_id;

UPDATE tww_od.surface_water_bodies
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- river DELETE
-- Rule: vw_river_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_river_ON_DELETE AS ON DELETE TO tww_app.vw_river DO INSTEAD (
  DELETE FROM tww_od.river WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.surface_water_bodies WHERE obj_id = OLD.obj_id;
);

