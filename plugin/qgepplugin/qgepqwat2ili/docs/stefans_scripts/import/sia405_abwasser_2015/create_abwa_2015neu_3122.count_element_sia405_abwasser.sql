-- function for counting number of object in tables (german classnames)
-- 13.7.2019 sjib
-- SELECT abwa_2015neu_3122.count_elements();
CREATE OR REPLACE FUNCTION abwa_2015neu_3122.count_elements()
  RETURNS text AS
$BODY$
DECLARE
  table_elements text;
  list text;

BEGIN

list = 'List of elements in tables: ';
list = list  || 'organisation: ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.organisation;
list = list || table_elements || ', ';
list = list  || 'abwasserbauwerk (wastewater_structure): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.abwasserbauwerk;
list = list || table_elements || ', ';
list = list  || 'abwasserbauwerk_text (wastewater_structure_text): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.abwasserbauwerk_text;
list = list || table_elements || ', ';
list = list  || 'abwasserbauwerk_symbol (wastewater_structure_symbol): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.abwasserbauwerk_symbol;
list = list || table_elements || ', ';
list = list  || 'kanal (channel): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.kanal;
list = list || table_elements || ', ';
list = list  || 'nomschacht (manhole): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.normschacht;
list = list || table_elements || ', ';
list = list  || 'einleitstelle (discharge_point): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.einleitstelle;
list = list || table_elements || ', ';
list = list  || 'spezialbauwerk (special_structure): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.spezialbauwerk;
list = list || table_elements || ', ';
list = list  || 'versickerungsanlage (infiltration_installation): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.versickerungsanlage;
list = list || table_elements || ', ';
list = list  || 'rohrprofil (pipe_profile): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.rohrprofil;
list = list || table_elements || ', ';
list = list  || 'abwassernetzelement (wastewater_networkelement): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.abwassernetzelement;
list = list || table_elements || ', ';
list = list  || 'haltungspunkt (reach_point): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.haltungspunkt;
list = list || table_elements || ', ';
list = list  || 'abwasserknoten (wastewater_node): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.abwasserknoten;
list = list || table_elements || ', ';
list = list  || 'haltung (reach): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.haltung;
list = list || table_elements || ', ';
list = list  || 'haltung_text (reach_text): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.haltung_text;
list = list || table_elements || ', ';
list = list  || 'bauwerksteil (structure_part): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.bauwerksteil;
list = list || table_elements || ', ';
list = list  || 'trockenwetterfallrohr (dryweather_downspout): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.trockenwetterfallrohr;
list = list || table_elements || ', ';
list = list  || 'einstiegshilfe (access_aid): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.einstiegshilfe;
list = list || table_elements || ', ';
list = list  || 'trockenwetterrinne (dryweather_flume): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.trockenwetterrinne;
list = list || table_elements || ', ';
list = list  || 'deckel (cover): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.deckel;
list = list || table_elements || ', ';
list = list  || 'bankett (benching): ';
SELECT COUNT(t_id) INTO table_elements FROM abwa_2015neu_3122.bankett;
list = list || table_elements || ', ';

RETURN list;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
