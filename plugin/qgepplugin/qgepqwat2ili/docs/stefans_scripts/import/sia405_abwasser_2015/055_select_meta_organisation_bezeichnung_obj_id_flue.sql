-- 11.7.2919 Stefan Burckhardt
-- run this function before importing data from ili2pg to qgep schema, else you will have problems importing fk_dataowner / fk_provider fields if they are not with a valid obj_id but some form of identifier (e.g. with the Transferdatensatz_VSA_DSS.xtf)

-- set t_key_object to latest sequence of project so that tid (integer) is correct
SELECT abwa_2015neu_3122.t_key_object_seq();

-- set all the matching definitions for missing datenherr / datenlieferant organisations in organisation
-- examples:
-- fuer Hofstetten Flüh

SELECT abwa_2015neu_3122.meta_organisation('Jermann AG', 'ch10m8nuPR000002');

-- SELECT abwa_2015neu_3122.meta_organisation('SBU', 'ch080qwzOG000099', 'privat');
-- SELECT abwa_2015neu_3122.meta_organisation('Kanton Thurgau', 'ch080qwzKT000001', 'kanton');
-- add your own or modify

-- Alle Datenherr / Datenlieferant Einträge korrigieren, wo Wert nicht gleich der Bezeichnung in Klasse Organisation

-- Check with SELECT * FROM abwa_2015neu_3122.sia405_base_lv95_metaattribute

-- Datenherr Text durch enstprechende OBJ_ID ersetzen: ch19pppeMU000001

UPDATE abwa_2015neu_3122.sia405_base_lv95_metaattribute
    SET datenherr = 'ch19pppeMU000001'
  WHERE datenherr = 'Gemeinde Hofstetten Flueh';
