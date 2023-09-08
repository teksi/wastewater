DROP VIEW IF EXISTS qgep_od.vw_wwtp_structure;

--------
-- Subclass: wwtp_structure
-- Superclass: wastewater_structure
--------
CREATE OR REPLACE VIEW qgep_od.vw_wwtp_structure AS

SELECT
   WT.obj_id
   , WT.kind
   , WS.accessibility
   , WS.contract_section
   , WS.detail_geometry_geometry
   , WS.financing
   , WS.gross_costs
   , WS.identifier
   , WS.inspection_interval
   , WS.location_name
   , WS.records
   , WS.remark
   , WS.renovation_necessity
   , WS.replacement_value
   , WS.rv_base_year
   , WS.rv_construction_type
   , WS.status
   , WS.structure_condition
   , WS.subsidies
   , WS.year_of_construction
   , WS.year_of_replacement
   , WS.fk_dataowner
   , WS.fk_provider
   , WS.last_modification
  , WS.fk_owner
  , WS.fk_operator
  FROM qgep_od.wwtp_structure WT
 LEFT JOIN qgep_od.wastewater_structure WS
 ON WS.obj_id = WT.obj_id;

-----------------------------------
-- wwtp_structure INSERT
-- Function: vw_wwtp_structure_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep_od.vw_wwtp_structure_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep_od.wastewater_structure (
             obj_id
           , accessibility
           , contract_section
           , detail_geometry_geometry
           , financing
           , gross_costs
           , identifier
           , inspection_interval
           , location_name
           , records
           , remark
           , renovation_necessity
           , replacement_value
           , rv_base_year
           , rv_construction_type
           , status
           , structure_condition
           , subsidies
           , year_of_construction
           , year_of_replacement
           , fk_dataowner
           , fk_provider
           , last_modification
           , fk_owner
           , fk_operator
           )
     VALUES ( COALESCE(NEW.obj_id,qgep_sys.generate_oid('qgep_od','wwtp_structure')) -- obj_id
           , NEW.accessibility
           , NEW.contract_section
           , NEW.detail_geometry_geometry
           , NEW.financing
           , NEW.gross_costs
           , NEW.identifier
           , NEW.inspection_interval
           , NEW.location_name
           , NEW.records
           , NEW.remark
           , NEW.renovation_necessity
           , NEW.replacement_value
           , NEW.rv_base_year
           , NEW.rv_construction_type
           , NEW.status
           , NEW.structure_condition
           , NEW.subsidies
           , NEW.year_of_construction
           , NEW.year_of_replacement
           , NEW.fk_dataowner
           , NEW.fk_provider
           , NEW.last_modification
           , NEW.fk_owner
           , NEW.fk_operator
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep_od.wwtp_structure (
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

-- DROP TRIGGER vw_wwtp_structure_ON_INSERT ON qgep_od.wwtp_structure;

CREATE TRIGGER vw_wwtp_structure_ON_INSERT INSTEAD OF INSERT ON qgep_od.vw_wwtp_structure
  FOR EACH ROW EXECUTE PROCEDURE qgep_od.vw_wwtp_structure_insert();

-----------------------------------
-- wwtp_structure UPDATE
-- Rule: vw_wwtp_structure_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_wwtp_structure_ON_UPDATE AS ON UPDATE TO qgep_od.vw_wwtp_structure DO INSTEAD (
UPDATE qgep_od.wwtp_structure
  SET
       kind = NEW.kind
  WHERE obj_id = OLD.obj_id;

UPDATE qgep_od.wastewater_structure
  SET
       accessibility = NEW.accessibility
     , contract_section = NEW.contract_section
     , detail_geometry_geometry = NEW.detail_geometry_geometry
     , financing = NEW.financing
     , gross_costs = NEW.gross_costs
     , identifier = NEW.identifier
     , inspection_interval = NEW.inspection_interval
     , location_name = NEW.location_name
     , records = NEW.records
     , remark = NEW.remark
     , renovation_necessity = NEW.renovation_necessity
     , replacement_value = NEW.replacement_value
     , rv_base_year = NEW.rv_base_year
     , rv_construction_type = NEW.rv_construction_type
     , status = NEW.status
     , structure_condition = NEW.structure_condition
     , subsidies = NEW.subsidies
     , year_of_construction = NEW.year_of_construction
     , year_of_replacement = NEW.year_of_replacement
     , fk_dataowner = NEW.fk_dataowner
     , fk_provider = NEW.fk_provider
     , last_modification = NEW.last_modification
     , fk_owner = NEW.fk_owner
     , fk_operator = NEW.fk_operator
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- wwtp_structure DELETE
-- Rule: vw_wwtp_structure_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_wwtp_structure_ON_DELETE AS ON DELETE TO qgep_od.vw_wwtp_structure DO INSTEAD (
  DELETE FROM qgep_od.wwtp_structure WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.wastewater_structure WHERE obj_id = OLD.obj_id;
);

