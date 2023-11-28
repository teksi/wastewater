------ This file is sql code to Export QGEP (Modul SIA405Abwasser) in English to INTERLIS in German on QQIS
------ Second version using tid_generate and tid_lookup
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 15.03.2016 14:19:45 / modified 15.8.2019 neue schemata

DELETE FROM sia405_abwasser_2015_2_d.organisation;
DELETE FROM sia405_abwasser_2015_2_d.abwasserbauwerk;
DELETE FROM sia405_abwasser_2015_2_d.kanal;
DELETE FROM sia405_abwasser_2015_2_d.normschacht;
DELETE FROM sia405_abwasser_2015_2_d.einleitstelle;
DELETE FROM sia405_abwasser_2015_2_d.spezialbauwerk;
DELETE FROM sia405_abwasser_2015_2_d.versickerungsanlage;
DELETE FROM sia405_abwasser_2015_2_d.rohrprofil;
DELETE FROM sia405_abwasser_2015_2_d.abwassernetzelement;
DELETE FROM sia405_abwasser_2015_2_d.haltungspunkt;
DELETE FROM sia405_abwasser_2015_2_d.abwasserknoten;
DELETE FROM sia405_abwasser_2015_2_d.haltung;
DELETE FROM sia405_abwasser_2015_2_d.bauwerksteil;
DELETE FROM sia405_abwasser_2015_2_d.trockenwetterfallrohr;
DELETE FROM sia405_abwasser_2015_2_d.einstiegshilfe;
DELETE FROM sia405_abwasser_2015_2_d.trockenwetterrinne;
DELETE FROM sia405_abwasser_2015_2_d.deckel;
DELETE FROM sia405_abwasser_2015_2_d.bankett;

DELETE FROM sia405_abwasser_2015_2_d.metaattribute;
DELETE FROM sia405_abwasser_2015_2_d.sia405_baseclass;
DELETE FROM sia405_abwasser_2015_2_d.baseclass;

--- t_key_object initialisieren

UPDATE sia405_abwasser_2015_2_d.t_key_object SET t_lastuniqueid = 0, t_createdate = current_timestamp, t_user = 'postgres';


-- neu 15.8.2019 falls noch keine Daten drin
-- INSERT INTO sia405_abwasser_2015_2_d.t_ili2db_dataset (t_id, datasetname) VALUES (1, 'qgep.xtf-1');

-- INSERT INTO sia405_abwasser_2015_2_d.t_ili2db_import (t_id, dataset, importdate, importuser, importfile) VALUES (2, 1, current_timestamp, 'postgres', 'qgep.xtf');

-- INSERT INTO sia405_abwasser_2015_2_d.t_ili2db_basket (t_id, dataset, topic, attachmentkey) VALUES (3, 1, 'SIA405_ABWASSER_2015.SIA405_Abwasser', 'qgep.xtf-3');

-- INSERT INTO sia405_abwasser_2015_2_d.t_ili2db_import_basket (t_id, dataset, importdate, importuser, importfile) VALUES (2, 1, current_timestamp, 'postgres', 'qgep.xtf');

--- OK: fk_Attributes
--- OK: JOIN for fk_dataowner / provider
--- in Progress: organisation.fk_part_of data - prepared, but no qgep.table hierarchy and data, dito for all other class - class associations
--- Not tested: if data with reach - reach connection
--- abwasserbauwerk.detailgeometrie and haltung.verlauf commented out as long qgep has not geometry datatypes that allow ARCS



INSERT INTO sia405_abwasser_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT sia405_abwasser_2015_2_d.tid_generate('bauwerksteil', obj_id), 'bauwerksteil', obj_id
FROM qgep_od.structure_part;

INSERT INTO sia405_abwasser_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT sia405_abwasser_2015_2_d.tid_lookup('bauwerksteil', obj_id), obj_id
FROM qgep_od.structure_part;

INSERT INTO sia405_abwasser_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT sia405_abwasser_2015_2_d.tid_generate('haltungspunkt', obj_id), 'haltungspunkt', obj_id
FROM qgep_od.reach_point;

INSERT INTO sia405_abwasser_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT sia405_abwasser_2015_2_d.tid_lookup('haltungspunkt', obj_id), obj_id
FROM qgep_od.reach_point;

INSERT INTO sia405_abwasser_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT sia405_abwasser_2015_2_d.tid_generate('abwassernetzelement', obj_id), 'abwassernetzelement', obj_id
FROM qgep_od.wastewater_networkelement;

INSERT INTO sia405_abwasser_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwassernetzelement', obj_id), obj_id
FROM qgep_od.wastewater_networkelement;

INSERT INTO sia405_abwasser_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT sia405_abwasser_2015_2_d.tid_generate('rohrprofil', obj_id), 'rohrprofil', obj_id
FROM qgep_od.pipe_profile;

INSERT INTO sia405_abwasser_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT sia405_abwasser_2015_2_d.tid_lookup('rohrprofil', obj_id), obj_id
FROM qgep_od.pipe_profile;

INSERT INTO sia405_abwasser_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT sia405_abwasser_2015_2_d.tid_generate('abwasserbauwerk', obj_id), 'abwasserbauwerk', obj_id
FROM qgep_od.wastewater_structure;

INSERT INTO sia405_abwasser_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwasserbauwerk', obj_id), obj_id
FROM qgep_od.wastewater_structure;

INSERT INTO sia405_abwasser_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT sia405_abwasser_2015_2_d.tid_generate('organisation', obj_id), 'organisation', obj_id
FROM qgep_od.organisation;

INSERT INTO sia405_abwasser_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT sia405_abwasser_2015_2_d.tid_lookup('organisation', obj_id), obj_id
FROM qgep_od.organisation;
