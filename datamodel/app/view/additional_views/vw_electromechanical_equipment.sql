DROP VIEW IF EXISTS tww_app.vw_electromechanical_equipment;


--------
-- Subclass: electromechanical_equipment
-- Superclass: structure_part
--------
CREATE OR REPLACE VIEW tww_app.vw_electromechanical_equipment AS

SELECT
   EQ.obj_id
   , EQ.gross_costs
   , EQ.kind
   , EQ.year_of_replacement
   , SP.identifier
   , SP.remark
   , SP.renovation_demand
   , SP.fk_dataowner
   , SP.fk_provider
   , SP.last_modification
  , SP.fk_wastewater_structure
  FROM tww_od.electromechanical_equipment EQ
 LEFT JOIN tww_od.structure_part SP
 ON SP.obj_id = EQ.obj_id;

-----------------------------------
-- electromechanical_equipment INSERT
-- Function: vw_electromechanical_equipment_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION tww_app.vw_electromechanical_equipment_insert()
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
     VALUES ( COALESCE(NEW.obj_id,tww_sys.generate_oid('tww_od','electromechanical_equipment')) -- obj_id
           , NEW.identifier
           , NEW.remark
           , NEW.renovation_demand
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_wastewater_structure
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO tww_od.electromechanical_equipment (
             obj_id
           , gross_costs
           , kind
           , year_of_replacement
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.gross_costs
           , NEW.kind
           , NEW.year_of_replacement
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_electromechanical_equipment_ON_INSERT ON tww_od.electromechanical_equipment;

CREATE TRIGGER vw_electromechanical_equipment_ON_INSERT INSTEAD OF INSERT ON tww_app.vw_electromechanical_equipment
  FOR EACH ROW EXECUTE PROCEDURE tww_app.vw_electromechanical_equipment_insert();

-----------------------------------
-- electromechanical_equipment UPDATE
-- Rule: vw_electromechanical_equipment_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_electromechanical_equipment_ON_UPDATE AS ON UPDATE TO tww_app.vw_electromechanical_equipment DO INSTEAD (
UPDATE tww_od.electromechanical_equipment
  SET
       gross_costs = NEW.gross_costs
     , kind = NEW.kind
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
-- electromechanical_equipment DELETE
-- Rule: vw_electromechanical_equipment_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_electromechanical_equipment_ON_DELETE AS ON DELETE TO tww_app.vw_electromechanical_equipment DO INSTEAD (
  DELETE FROM tww_od.electromechanical_equipment WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.structure_part WHERE obj_id = OLD.obj_id;
);
