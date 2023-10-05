DROP VIEW IF EXISTS tww_od.vw_solids_retention;


--------
-- Subclass: solids_retention
-- Superclass: structure_part
--------
CREATE OR REPLACE VIEW tww_od.vw_solids_retention AS

SELECT
   SO.obj_id
   , SO.dimensioning_value
   , SO.gross_costs
   , SO.overflow_level
   , SO.type
   , SO.year_of_replacement
   , SP.identifier
   , SP.remark
   , SP.renovation_demand
   , SP.fk_dataowner
   , SP.fk_provider
   , SP.last_modification
  , SP.fk_wastewater_structure
  FROM tww_od.solids_retention SO
 LEFT JOIN tww_od.structure_part SP
 ON SP.obj_id = SO.obj_id;

-----------------------------------
-- solids_retention INSERT
-- Function: vw_solids_retention_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_od.vw_solids_retention_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO tww_od.structure_part (
             obj_id
           , identifier
           , remark
           , renovation_demand
           , fk_dataowner
           , fk_provider
           , last_modification
           , fk_wastewater_structure
           )
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','solids_retention')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.renovation_demand
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_wastewater_structure
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.solids_retention (
             obj_id
           , dimensioning_value
           , gross_costs
           , overflow_level
           , type
           , year_of_replacement
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.dimensioning_value
           , NEW.gross_costs
           , NEW.overflow_level
           , NEW.type
           , NEW.year_of_replacement
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_solids_retention_ON_INSERT ON tww_od.solids_retention;

CREATE TRIGGER vw_solids_retention_ON_INSERT INSTEAD OF INSERT ON tww_od.vw_solids_retention
  FOR EACH ROW EXECUTE PROCEDURE tww_od.vw_solids_retention_insert();

-----------------------------------
-- solids_retention UPDATE
-- Rule: vw_solids_retention_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_solids_retention_ON_UPDATE AS ON UPDATE TO tww_od.vw_solids_retention DO INSTEAD (
UPDATE tww_od.solids_retention
  SET
       dimensioning_value = NEW.dimensioning_value
     , gross_costs = NEW.gross_costs
     , overflow_level = NEW.overflow_level
     , type = NEW.type
     , year_of_replacement = NEW.year_of_replacement
  WHERE obj_id = OLD.obj_id;

UPDATE tww_od.structure_part
  SET
       identifier = NEW.identifier
     , remark = NEW.remark
     , renovation_demand = NEW.renovation_demand
           , fk_dataowner = NEW.fk_dataowner
           , fk_provider = NEW.fk_provider
           , last_modification = NEW.last_modification
     , fk_wastewater_structure = NEW.fk_wastewater_structure
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- solids_retention DELETE
-- Rule: vw_solids_retention_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_solids_retention_ON_DELETE AS ON DELETE TO tww_od.vw_solids_retention DO INSTEAD (
  DELETE FROM tww_od.solids_retention WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.structure_part WHERE obj_id = OLD.obj_id;
);

