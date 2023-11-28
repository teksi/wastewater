-- function for counting number of object in tables
-- 13.7.2019 sjib
-- SELECT qgep_od.count_elements();
CREATE OR REPLACE FUNCTION qgep_od.count_elements()
  RETURNS text AS
$BODY$
DECLARE
  table_elements integer;
  list text;
  check_structure_parts integer;
  structure_parts integer;

BEGIN

list = 'List of elements in tables: ';
list = list  || 'organisation: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.organisation;
list = list || table_elements || ', ';
list = list  || 'wastewater_structure: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.wastewater_structure;
list = list || table_elements || ', ';
list = list  || 'wastewater_structure_text: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.wastewater_structure_text;
list = list || table_elements || ', ';
list = list  || 'wastewater_structure_symbol: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.wastewater_structure_symbol;
list = list || table_elements || ', ';
list = list  || 'channel: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.channel;
list = list || table_elements || ', ';
list = list  || 'manhole: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.manhole;
list = list || table_elements || ', ';
list = list  || 'discharge_point: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.discharge_point;
list = list || table_elements || ', ';
list = list  || 'special_structure: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.special_structure;
list = list || table_elements || ', ';
list = list  || 'infiltration_installation: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.infiltration_installation;
list = list || table_elements || ', ';
list = list  || 'pipe_profile: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.pipe_profile;
list = list || table_elements || ', ';
list = list  || 'wastewater_networkelement: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.wastewater_networkelement;
list = list || table_elements || ', ';
list = list  || 'reach_point: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.reach_point;
list = list || table_elements || ', ';
list = list  || 'wastewater_node: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.wastewater_node;
list = list || table_elements || ', ';
list = list  || 'reach: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.reach;
list = list || table_elements || ', ';
list = list  || 'reach_text: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.reach_text;
list = list || table_elements || ', ';
list = list  || 'structure_part: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.structure_part;

structure_parts = table_elements::integer;
check_structure_parts = structure_parts;

list = list || table_elements || ', ';
list = list  || 'dryweather_downspout: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.dryweather_downspout;
list = list || table_elements || ', ';

check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'access_aid: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.access_aid;
list = list || table_elements || ', ';

check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'dryweather_flume: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.dryweather_flume;
list = list || table_elements || ', ';

check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'cover: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.cover;
list = list || table_elements || ', ';

check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'benching: ';
SELECT COUNT(obj_id) INTO table_elements FROM qgep_od.benching;
list = list || table_elements || ', ';

check_structure_parts = check_structure_parts - table_elements::integer;

IF check_structure_parts <> 0 THEN
    list = list || 'number of subclass of structure parts not correct: checksum = ' || check_structure_parts;
ELSE
    list = list || ' - number of subclass elements of structure parts OK!';
END IF;


RETURN list;

END;
$BODY$
  -- 3.2.2017 geändert LANGUAGE plpgsql STABLE
  LANGUAGE plpgsql VOLATILE
  COST 100;
