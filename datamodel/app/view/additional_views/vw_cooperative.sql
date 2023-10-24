DROP VIEW IF EXISTS tww_app.vw_cooperative;


--------
-- Subclass: cooperative
-- Superclass: organisation
--------
CREATE OR REPLACE VIEW tww_app.vw_cooperative AS

SELECT
   CP.obj_id
   , OG.identifier
   , OG.remark
   , OG.uid
   , OG.fk_dataowner
   , OG.fk_provider
   , OG.last_modification
  FROM tww_od.cooperative CP
 LEFT JOIN tww_od.organisation OG
 ON OG.obj_id = CP.obj_id;

-----------------------------------
-- cooperative INSERT
-- Function: vw_cooperative_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_cooperative_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO tww_od.organisation (
             obj_id
           , identifier
           , remark
           , uid
           , fk_dataowner
           , fk_provider
           , last_modification
           )
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','cooperative')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.uid
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.cooperative (
             obj_id
           )
          VALUES (
            NEW.obj_id -- obj_id
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_cooperative_ON_INSERT ON tww_od.cooperative;

CREATE TRIGGER vw_cooperative_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_cooperative
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_cooperative_insert();

-----------------------------------
-- cooperative UPDATE
-- Rule: vw_cooperative_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_cooperative_ON_UPDATE AS ON UPDATE TO tww_app.vw_cooperative DO INSTEAD (
--------
-- UPDATE tww_od.cooperative
--  SET
--  WHERE obj_id = OLD.obj_id;
--------

UPDATE tww_od.organisation
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
     , uid = NEW.uid
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- cooperative DELETE
-- Rule: vw_cooperative_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_cooperative_ON_DELETE AS ON DELETE TO tww_app.vw_cooperative DO INSTEAD (
  DELETE FROM tww_od.cooperative WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.organisation WHERE obj_id = OLD.obj_id;
);

