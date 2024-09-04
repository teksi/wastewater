DROP VIEW IF EXISTS tww_app.vw_tank_emptying;


--------
-- Subclass: tank_emptying
-- Superclass: structure_part
--------
CREATE OR REPLACE VIEW tww_app.vw_tank_emptying AS

SELECT
   TE.obj_id
   , TE.flow
   , TE.gross_costs
   , TE.type
   , TE.year_of_replacement
   , SP.identifier
   , SP.remark
   , SP.renovation_demand
   , SP.fk_dataowner
   , SP.fk_provider
   , SP.last_modification
  , SP.fk_wastewater_structure
  FROM tww_od.tank_emptying TE
 LEFT JOIN tww_od.structure_part SP
 ON SP.obj_id = TE.obj_id;

-----------------------------------
-- tank_emptying INSERT
-- Function: vw_tank_emptying_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_tank_emptying_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_app.generate_oid('tww_od','tank_emptying')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.renovation_demand
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_wastewater_structure
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.tank_emptying (
             obj_id
           , flow
           , gross_costs
           , type
           , year_of_replacement
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.flow
           , NEW.gross_costs
           , NEW.type
           , NEW.year_of_replacement
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_tank_emptying_ON_INSERT ON tww_od.tank_emptying;

CREATE TRIGGER vw_tank_emptying_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_tank_emptying
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_tank_emptying_insert();

-----------------------------------
-- tank_emptying UPDATE
-- Rule: vw_tank_emptying_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_tank_emptying_ON_UPDATE AS ON UPDATE TO tww_app.vw_tank_emptying DO INSTEAD (
UPDATE tww_od.tank_emptying
  SET
       flow = NEW.flow
     , gross_costs = NEW.gross_costs
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
-- tank_emptying DELETE
-- Rule: vw_tank_emptying_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_tank_emptying_ON_DELETE AS ON DELETE TO tww_app.vw_tank_emptying DO INSTEAD (
  DELETE FROM tww_od.tank_emptying WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.structure_part WHERE obj_id = OLD.obj_id;
);
