-- function for counting number of object in tables (german classnames)
-- 13.7.2019 sjib / in Bearbeitung 21.10.2020

-- to execute  afterwards
-- SELECT vsa_dss_2015_2_d_3122.count_elements();


CREATE OR REPLACE FUNCTION vsa_dss_2015_2_d_3122.count_elements()
  RETURNS text AS
$BODY$
DECLARE
  table_elements text;
--  table_elements_organisation text;
  list text;
  check_structure_parts integer;
  check_organisations integer;
  check_wastewater_networkelements integer;
  check_wastewater_structures integer;
  structure_parts integer;
  organisations integer;
  wastewater_networkelements integer;
  wastewater_structures integer;

BEGIN

list = 'List of elements in tables: ,';

-- organisation und subklassen

list = list  || 'organisation: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.organisation;
list = list || table_elements || ', ';

-- anzahl einträge bauwerksteil auf structure_parts schreiben
organisations = table_elements::integer;
-- totalanzahl auf check_structure_parts kopieren
check_organisations = organisations;


list = list  || 'amt: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.amt;
list = list || table_elements || ', ';

-- anzahl amt abziehen
check_organisations = check_organisations - table_elements::integer;

list = list  || 'abwasserverband: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.abwasserverband;
list = list || table_elements || ', ';

-- anzahl amt abziehen
check_organisations = check_organisations - table_elements::integer;

list = list  || 'gemeinde: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.gemeinde;
list = list || table_elements || ', ';

-- anzahl gemeinde abziehen
check_organisations = check_organisations - table_elements::integer;

list = list  || 'kanton: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.kanton;
list = list || table_elements || ', ';

-- anzahl kanton abziehen
check_organisations = check_organisations - table_elements::integer;


list = list  || 'genossenschaft_korporation: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.genossenschaft_korporation;
list = list || table_elements || ', ';

-- anzahl genossenschaft_korporation abziehen
check_organisations = check_organisations - table_elements::integer;

list = list  || 'privat: ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.privat;
list = list || table_elements || ', ';

-- anzahl privat abziehen
check_organisations = check_organisations - table_elements::integer;


-- falls null ist gut, sonst
IF check_organisations <> 0 THEN
    list = list || 'ERROR: number of subclass elements of organisations NOT CORRECT in schema vsa_dss_2015_2_d_3122: checksum = ' || check_organisations || ', ';
ELSE
    list = list || ' - OK: number of subclass elements of organisations OK in schema vsa_dss_2015_2_d_3122!' || ', ';
END IF;


-- abwasserbauwerk und subklassen

list = list  || 'abwasserbauwerk (wastewater_structure): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.abwasserbauwerk;
list = list || table_elements || ', ';

-- anzahl einträge bauwerksteil auf structure_parts schreiben
wastewater_structures = table_elements::integer;
-- totalanzahl auf check_structure_parts kopieren
check_wastewater_structures = wastewater_structures;


list = list  || 'abwasserbauwerk_text (wastewater_structure_text): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.abwasserbauwerk_text;
list = list || table_elements || ', ';
list = list  || 'abwasserbauwerk_symbol (wastewater_structure_symbol): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.abwasserbauwerk_symbol;
list = list || table_elements || ', ';

list = list  || 'kanal (channel): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.kanal;
list = list || table_elements || ', ';

-- anzahl kanal abziehen
check_wastewater_structures = check_wastewater_structures - table_elements::integer;

list = list  || 'nomschacht (manhole): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.normschacht;
list = list || table_elements || ', ';

-- anzahl nomschacht abziehen
check_wastewater_structures = check_wastewater_structures - table_elements::integer;


list = list  || 'einleitstelle (discharge_point): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.einleitstelle;
list = list || table_elements || ', ';

-- anzahl einleitstelle abziehen
check_wastewater_structures = check_wastewater_structures - table_elements::integer;


list = list  || 'spezialbauwerk (special_structure): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.spezialbauwerk;
list = list || table_elements || ', ';

-- anzahl spezialbauwerk abziehen
check_wastewater_structures = check_wastewater_structures - table_elements::integer;


list = list  || 'versickerungsanlage (infiltration_installation): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.versickerungsanlage;
list = list || table_elements || ', ';


-- anzahl versickerungsanlage abziehen
check_wastewater_structures = check_wastewater_structures - table_elements::integer;

-- falls null ist gut, sonst
IF check_wastewater_structures <> 0 THEN
    list = list || 'ERROR: number of subclass elements of wastewater_structures NOT CORRECT in schmea vsa_dss_2015_2_d_3122: checksum = ' || check_wastewater_structures || ', ';
ELSE
    list = list || ' OK: number of subclass elements of wastewater_structures OK in schema vsa_dss_2015_2_d_3122!' || ', ';
END IF;


-- rohrprofil
list = list  || 'rohrprofil (pipe_profile): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.rohrprofil;
list = list || table_elements || ', ';



-- abwassernetzelemente und subklassen
list = list  || 'abwassernetzelement (wastewater_networkelement): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.abwassernetzelement;
list = list || table_elements || ', ';

-- anzahl einträge abwassernetzelement auf check_wastewater_networkelements schreiben
wastewater_networkelements = table_elements::integer;
-- totalanzahl auf check_wastewater_networkelements kopieren
check_wastewater_networkelements = wastewater_networkelements;

list = list  || 'abwasserknoten (wastewater_node): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.abwasserknoten;
list = list || table_elements || ', ';

-- anzahl abwasserknoten abziehen
check_wastewater_networkelements = check_wastewater_networkelements - table_elements::integer;


list = list  || 'haltung (reach): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.haltung;
list = list || table_elements || ', ';

-- anzahl haltung abziehen
check_wastewater_networkelements = check_wastewater_networkelements - table_elements::integer;


list = list  || 'haltung_text (reach_text): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.haltung_text;
list = list || table_elements || ', ';

-- falls null ist gut, sonst
IF check_wastewater_networkelements <> 0 THEN
    list = list || 'ERROR: number of subclass elements of wastewater_networkelements NOT CORRECT in schmea vsa_dss_2015_2_d_3122: checksum = ' || check_wastewater_networkelements || ', ';
ELSE
    list = list || ' OK: number of subclass elements of wastewater_networkelements OK in schema vsa_dss_2015_2_d_3122!' || ', ';
END IF;


-- haltungspunkte
list = list  || 'haltungspunkt (reach_point): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.haltungspunkt;
list = list || table_elements || ', ';



-- bauwerksteil und subklassen
list = list  || 'bauwerksteil (structure_part): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.bauwerksteil;
list = list || table_elements || ', ';

-- anzahl einträge bauwerksteil auf structure_parts schreiben
structure_parts = table_elements::integer;
-- totalanzahl auf check_structure_parts kopieren
check_structure_parts = structure_parts;

list = list  || 'trockenwetterfallrohr (dryweather_downspout): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.trockenwetterfallrohr;
list = list || table_elements || ', ';

-- anzahl trockenwetterfallrohr abziehen
check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'einstiegshilfe (access_aid): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.einstiegshilfe;
list = list || table_elements || ', ';

-- anzahl einstiegshilfe abziehen
check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'trockenwetterrinne (dryweather_flume): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.trockenwetterrinne;
list = list || table_elements || ', ';

-- anzahl trockenwetterrinne abziehen
check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'deckel (cover): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.deckel;
list = list || table_elements || ', ';

-- anzahl deckel abziehen
check_structure_parts = check_structure_parts - table_elements::integer;

list = list  || 'bankett (benching): ';
SELECT COUNT(t_id) INTO table_elements FROM vsa_dss_2015_2_d_3122.bankett;
list = list || table_elements || ', ';

-- anzahl bankett abziehen
check_structure_parts = check_structure_parts - table_elements::integer;

-- falls null ist gut, sonst
IF check_structure_parts <> 0 THEN
    list = list || 'ERROR: number of subclass elements of structure parts NOT CORRECT in schmea vsa_dss_2015_2_d_3122: checksum = ' || check_structure_parts || ', ';
ELSE
    list = list || ' OK: number of subclass elements of structure parts OK in schema vsa_dss_2015_2_d_3122!' || ', ';
END IF;




RETURN list;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
