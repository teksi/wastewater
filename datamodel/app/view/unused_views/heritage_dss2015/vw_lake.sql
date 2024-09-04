DROP VIEW IF EXISTS tww_app.vw_lake;


--------
-- Subclass: lake
-- Superclass: surface_water_bodies
--------
CREATE OR REPLACE VIEW tww_app.vw_lake AS

SELECT
   LA.obj_id
   , LA.perimeter_geometry
   , CU.identifier
   , CU.remark
   , CU.fk_dataowner
   , CU.fk_provider
   , CU.last_modification
  FROM tww_od.lake LA
 LEFT JOIN tww_od.surface_water_bodies CU
 ON CU.obj_id = LA.obj_id;

-----------------------------------
-- lake INSERT
-- Function: vw_lake_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_lake_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_app.generate_oid('tww_od','lake')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.lake (
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

-- DROP TRIGGER vw_lake_ON_INSERT ON tww_od.lake;

CREATE TRIGGER vw_lake_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_lake
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_lake_insert();

-----------------------------------
-- lake UPDATE
-- Rule: vw_lake_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_lake_ON_UPDATE AS ON UPDATE TO tww_app.vw_lake DO INSTEAD (
UPDATE tww_od.lake
  SET
     , perimeter_geometry = NEW.perimeter_geometry
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
-- lake DELETE
-- Rule: vw_lake_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_lake_ON_DELETE AS ON DELETE TO tww_app.vw_lake DO INSTEAD (
  DELETE FROM tww_od.lake WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.surface_water_bodies WHERE obj_id = OLD.obj_id;
);
