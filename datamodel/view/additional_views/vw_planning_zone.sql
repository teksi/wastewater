DROP VIEW IF EXISTS qgep_od.vw_planning_zone;


--------
-- Subclass: planning_zone
-- Superclass: zone
--------
CREATE OR REPLACE VIEW qgep_od.vw_planning_zone AS

SELECT
   PL.obj_id
   , PL.kind
   , PL.perimeter_geometry
   , ZO.identifier
   , ZO.remark
   , ZO.fk_dataowner
   , ZO.fk_provider
   , ZO.last_modification
  FROM qgep_od.planning_zone PL
 LEFT JOIN qgep_od.zone ZO
 ON ZO.obj_id = PL.obj_id;

-----------------------------------
-- planning_zone INSERT
-- Function: vw_planning_zone_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_planning_zone_insert()
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
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','planning_zone')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.planning_zone (
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

-- DROP TRIGGER vw_planning_zone_ON_INSERT ON qgep_od.planning_zone;

CREATE TRIGGER vw_planning_zone_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_planning_zone
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_planning_zone_insert();

-----------------------------------
-- planning_zone UPDATE
-- Rule: vw_planning_zone_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_planning_zone_ON_UPDATE AS ON UPDATE TO qgep_od.vw_planning_zone DO INSTEAD (
UPDATE qgep_od.planning_zone
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
-- planning_zone DELETE
-- Rule: vw_planning_zone_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_planning_zone_ON_DELETE AS ON DELETE TO qgep_od.vw_planning_zone DO INSTEAD (
  DELETE FROM qgep_od.planning_zone WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.zone WHERE obj_id = OLD.obj_id;
);

