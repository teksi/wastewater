DROP VIEW IF EXISTS qgep_od.vw_drainage_system;


--------
-- Subclass: drainage_system
-- Superclass: zone
--------
CREATE OR REPLACE VIEW qgep_od.vw_drainage_system AS

SELECT
   DS.obj_id
   , DS.kind
   , DS.perimeter_geometry
   , ZO.identifier
   , ZO.remark
   , ZO.fk_dataowner
   , ZO.fk_provider
   , ZO.last_modification
  FROM qgep_od.drainage_system DS
 LEFT JOIN qgep_od.zone ZO
 ON ZO.obj_id = DS.obj_id;

-----------------------------------
-- drainage_system INSERT
-- Function: vw_drainage_system_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_drainage_system_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep_od.zone (
             obj_id
           , identifier
           , remark
           , fk_dataowner
           , fk_provider
           , last_modification
           )
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','drainage_system')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.drainage_system (
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

-- DROP TRIGGER vw_drainage_system_ON_INSERT ON qgep_od.drainage_system;

CREATE TRIGGER vw_drainage_system_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_drainage_system
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_drainage_system_insert();

-----------------------------------
-- drainage_system UPDATE
-- Rule: vw_drainage_system_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_drainage_system_ON_UPDATE AS ON UPDATE TO qgep_od.vw_drainage_system DO INSTEAD (
UPDATE qgep_od.drainage_system
  SET
       kind = NEW.kind
     , perimeter_geometry = NEW.perimeter_geometry
  WHERE obj_id = OLD.obj_id;

UPDATE qgep_od.zone
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

CREATE OR REPLACE RULE vw_drainage_system_ON_DELETE AS ON DELETE TO qgep_od.vw_drainage_system DO INSTEAD (
  DELETE FROM qgep_od.drainage_system WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.zone WHERE obj_id = OLD.obj_id;
);

