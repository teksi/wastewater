DROP VIEW IF EXISTS qgep_od.vw_lake;


--------
-- Subclass: lake
-- Superclass: surface_water_bodies
--------
CREATE OR REPLACE VIEW qgep_od.vw_lake AS

SELECT
   LA.obj_id
   , LA.perimeter_geometry
   , CU.identifier
   , CU.remark
   , CU.fk_dataowner
   , CU.fk_provider
   , CU.last_modification
  FROM qgep_od.lake LA
 LEFT JOIN qgep_od.surface_water_bodies CU
 ON CU.obj_id = LA.obj_id;

-----------------------------------
-- lake INSERT
-- Function: vw_lake_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_lake_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep_od.surface_water_bodies (
             obj_id
           , identifier
           , remark
           , fk_dataowner
           , fk_provider
           , last_modification
           )
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','lake')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.lake (
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

-- DROP TRIGGER vw_lake_ON_INSERT ON qgep_od.lake;

CREATE TRIGGER vw_lake_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_lake
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_lake_insert();

-----------------------------------
-- lake UPDATE
-- Rule: vw_lake_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_lake_ON_UPDATE AS ON UPDATE TO qgep_od.vw_lake DO INSTEAD (
UPDATE qgep_od.lake
  SET
     , perimeter_geometry = NEW.perimeter_geometry
  WHERE obj_id = OLD.obj_id;

UPDATE qgep_od.surface_water_bodies
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

CREATE OR REPLACE RULE vw_lake_ON_DELETE AS ON DELETE TO qgep_od.vw_lake DO INSTEAD (
  DELETE FROM qgep_od.lake WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.surface_water_bodies WHERE obj_id = OLD.obj_id;
);

