DROP VIEW IF EXISTS tww_app.vw_tank_cleaning;


--------
-- Subclass: tank_cleaning
-- Superclass: structure_part
--------
CREATE OR REPLACE VIEW tww_app.vw_tank_cleaning AS

SELECT
   TC.obj_id
   , TC.gross_costs
   , TC.type
   , TC.year_of_replacement
   , SP.identifier
   , SP.remark
   , SP.renovation_demand
   , SP.fk_dataowner
   , SP.fk_provider
   , SP.last_modification
  , SP.fk_wastewater_structure
  FROM tww_od.tank_cleaning TC
 LEFT JOIN tww_od.structure_part SP
 ON SP.obj_id = TC.obj_id;

-----------------------------------
-- tank_cleaning INSERT
-- Function: vw_tank_cleaning_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_tank_cleaning_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','tank_cleaning')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.renovation_demand
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_wastewater_structure
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.tank_cleaning (
             obj_id
           , gross_costs
           , type
           , year_of_replacement
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.gross_costs
           , NEW.type
           , NEW.year_of_replacement
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_tank_cleaning_ON_INSERT ON tww_od.tank_cleaning;

CREATE TRIGGER vw_tank_cleaning_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_tank_cleaning
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_tank_cleaning_insert();

-----------------------------------
-- tank_cleaning UPDATE
-- Rule: vw_tank_cleaning_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_tank_cleaning_ON_UPDATE AS ON UPDATE TO tww_app.vw_tank_cleaning DO INSTEAD (
UPDATE tww_od.tank_cleaning
  SET
       gross_costs = NEW.gross_costs
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
-- tank_cleaning DELETE
-- Rule: vw_tank_cleaning_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_tank_cleaning_ON_DELETE AS ON DELETE TO tww_app.vw_tank_cleaning DO INSTEAD (
  DELETE FROM tww_od.tank_cleaning WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.structure_part WHERE obj_id = OLD.obj_id;
);
