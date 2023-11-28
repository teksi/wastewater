------ This file is sql code to Export QGEP (Modul VSA-DSS) in English to INTERLIS in German on QQIS
------ Second version using tid_generate and tid_lookup
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 26.11.2016 15:42:44 / update 4.7.2017 od_text -> txt_text dito symbol, t_key_object auskommentiert
BEGIN;
---DELETE FROM vsa_dss_2015_2_d.erhaltungsereignis_abwasserbauwerk;
DELETE FROM vsa_dss_2015_2_d.erhaltungsereignis_abwasserbauwerkassoc;
-- DELETE FROM vsa_dss_2015_2_d.symbol;
DELETE FROM vsa_dss_2015_2_d.abwasserbauwerk_symbol;
-- DELETE FROM vsa_dss_2015_2_d.text;
DELETE FROM vsa_dss_2015_2_d.abwasserbauwerk_text;
DELETE FROM vsa_dss_2015_2_d.haltung_text;
DELETE FROM vsa_dss_2015_2_d.einzugsgebiet_text;
DELETE FROM vsa_dss_2015_2_d.mutation;
DELETE FROM vsa_dss_2015_2_d.grundwasserleiter;
DELETE FROM vsa_dss_2015_2_d.oberflaechengewaesser;
DELETE FROM vsa_dss_2015_2_d.fliessgewaesser;
DELETE FROM vsa_dss_2015_2_d.see;
DELETE FROM vsa_dss_2015_2_d.gewaesserabschnitt;
DELETE FROM vsa_dss_2015_2_d.wasserfassung;
DELETE FROM vsa_dss_2015_2_d.ufer;
DELETE FROM vsa_dss_2015_2_d.gewaessersohle;
DELETE FROM vsa_dss_2015_2_d.gewaessersektor;
DELETE FROM vsa_dss_2015_2_d.organisation;
DELETE FROM vsa_dss_2015_2_d.genossenschaft_korporation;
DELETE FROM vsa_dss_2015_2_d.kanton;
DELETE FROM vsa_dss_2015_2_d.abwasserverband;
DELETE FROM vsa_dss_2015_2_d.gemeinde;
DELETE FROM vsa_dss_2015_2_d.amt;
DELETE FROM vsa_dss_2015_2_d.abwasserreinigungsanlage;
DELETE FROM vsa_dss_2015_2_d.privat;
DELETE FROM vsa_dss_2015_2_d.abwasserbauwerk;
DELETE FROM vsa_dss_2015_2_d.kanal;
DELETE FROM vsa_dss_2015_2_d.normschacht;
DELETE FROM vsa_dss_2015_2_d.einleitstelle;
DELETE FROM vsa_dss_2015_2_d.spezialbauwerk;
DELETE FROM vsa_dss_2015_2_d.versickerungsanlage;
DELETE FROM vsa_dss_2015_2_d.arabauwerk;
DELETE FROM vsa_dss_2015_2_d.erhaltungsereignis;
DELETE FROM vsa_dss_2015_2_d.zone;
DELETE FROM vsa_dss_2015_2_d.planungszone;
DELETE FROM vsa_dss_2015_2_d.versickerungsbereich;
DELETE FROM vsa_dss_2015_2_d.entwaesserungssystem;
DELETE FROM vsa_dss_2015_2_d.gewaesserschutzbereich;
DELETE FROM vsa_dss_2015_2_d.grundwasserschutzareal;
DELETE FROM vsa_dss_2015_2_d.grundwasserschutzzone;
DELETE FROM vsa_dss_2015_2_d.rohrprofil;
DELETE FROM vsa_dss_2015_2_d.araenergienutzung;
DELETE FROM vsa_dss_2015_2_d.abwasserbehandlung;
DELETE FROM vsa_dss_2015_2_d.schlammbehandlung;
DELETE FROM vsa_dss_2015_2_d.steuerungszentrale;
DELETE FROM vsa_dss_2015_2_d.gewaesserverbauung;
DELETE FROM vsa_dss_2015_2_d.furt;
DELETE FROM vsa_dss_2015_2_d.gewaesserabsturz;
DELETE FROM vsa_dss_2015_2_d.schleuse;
DELETE FROM vsa_dss_2015_2_d.durchlass;
DELETE FROM vsa_dss_2015_2_d.geschiebesperre;
DELETE FROM vsa_dss_2015_2_d.gewaesserwehr;
DELETE FROM vsa_dss_2015_2_d.sohlrampe;
DELETE FROM vsa_dss_2015_2_d.fischpass;
DELETE FROM vsa_dss_2015_2_d.badestelle;
DELETE FROM vsa_dss_2015_2_d.hydr_geometrie;
DELETE FROM vsa_dss_2015_2_d.abwassernetzelement;
DELETE FROM vsa_dss_2015_2_d.haltungspunkt;
DELETE FROM vsa_dss_2015_2_d.abwasserknoten;
DELETE FROM vsa_dss_2015_2_d.haltung_alternativverlauf;
DELETE FROM vsa_dss_2015_2_d.haltung;
DELETE FROM vsa_dss_2015_2_d.rohrprofil_geometrie;
DELETE FROM vsa_dss_2015_2_d.hydr_geomrelation;
DELETE FROM vsa_dss_2015_2_d.mechanischevorreinigung;
DELETE FROM vsa_dss_2015_2_d.retentionskoerper;
DELETE FROM vsa_dss_2015_2_d.ueberlaufcharakteristik;
DELETE FROM vsa_dss_2015_2_d.hq_relation;
DELETE FROM vsa_dss_2015_2_d.bauwerksteil;
DELETE FROM vsa_dss_2015_2_d.trockenwetterfallrohr;
DELETE FROM vsa_dss_2015_2_d.einstiegshilfe;
DELETE FROM vsa_dss_2015_2_d.trockenwetterrinne;
DELETE FROM vsa_dss_2015_2_d.deckel;
DELETE FROM vsa_dss_2015_2_d.elektrischeeinrichtung;
DELETE FROM vsa_dss_2015_2_d.elektromechanischeausruestung;
DELETE FROM vsa_dss_2015_2_d.bankett;
DELETE FROM vsa_dss_2015_2_d.anschlussobjekt;
DELETE FROM vsa_dss_2015_2_d.gebaeude;
DELETE FROM vsa_dss_2015_2_d.reservoir;
DELETE FROM vsa_dss_2015_2_d.einzelflaeche;
DELETE FROM vsa_dss_2015_2_d.brunnen;
DELETE FROM vsa_dss_2015_2_d.gefahrenquelle;
DELETE FROM vsa_dss_2015_2_d.unfall;
DELETE FROM vsa_dss_2015_2_d.stoff;
DELETE FROM vsa_dss_2015_2_d.einzugsgebiet;
DELETE FROM vsa_dss_2015_2_d.oberflaechenabflussparameter;
DELETE FROM vsa_dss_2015_2_d.messstelle;
DELETE FROM vsa_dss_2015_2_d.messgeraet;
DELETE FROM vsa_dss_2015_2_d.messreihe;
DELETE FROM vsa_dss_2015_2_d.messresultat;
DELETE FROM vsa_dss_2015_2_d.ueberlauf;
DELETE FROM vsa_dss_2015_2_d.absperr_drosselorgan;
DELETE FROM vsa_dss_2015_2_d.streichwehr;
DELETE FROM vsa_dss_2015_2_d.foerderaggregat;
DELETE FROM vsa_dss_2015_2_d.leapingwehr;
DELETE FROM vsa_dss_2015_2_d.hydr_kennwerte;
DELETE FROM vsa_dss_2015_2_d.rueckstausicherung;
DELETE FROM vsa_dss_2015_2_d.feststoffrueckhalt;
DELETE FROM vsa_dss_2015_2_d.beckenreinigung;
DELETE FROM vsa_dss_2015_2_d.beckenentleerung;
DELETE FROM vsa_dss_2015_2_d.ezg_parameter_allg;
DELETE FROM vsa_dss_2015_2_d.ezg_parameter_mouse1;


DELETE FROM vsa_dss_2015_2_d.sia405_symbolpos;
DELETE FROM vsa_dss_2015_2_d.symbolpos;
DELETE FROM vsa_dss_2015_2_d.sia405_textpos;
DELETE FROM vsa_dss_2015_2_d.textpos;

DELETE FROM vsa_dss_2015_2_d.metaattribute;
DELETE FROM vsa_dss_2015_2_d.sia405_baseclass;
DELETE FROM vsa_dss_2015_2_d.baseclass;

-- Sequence: vsa_dss_2015_2_d.t_ili2db_seq
-- DROP SEQUENCE vsa_dss_2015_2_d.t_ili2db_seq;
--CREATE SEQUENCE vsa_dss_2015_2_d.t_ili2db_seq
--  INCREMENT 1
--  MINVALUE 1
--  MAXVALUE 9223372036854775807
--  Start 1
--  CACHE 1;
--ALTER TABLE vsa_dss_2015_2_d.t_ili2db_seq
--  OWNER TO postgres;
-- Table: vsa_dss_2015_2_d.t_key_object

---Keep for backward compatibility for the moment
-- DROP TABLE vsa_dss_2015_2_d.t_key_object;
--CREATE TABLE vsa_dss_2015_2_d.t_key_object
--(
--  t_key character varying(30) NOT NULL,
--  t_lastuniqueid integer NOT NULL,
--  t_lastchange timestamp without time zone NOT NULL,
--  t_createdate timestamp without time zone NOT NULL,
--  t_user character varying(40) NOT NULL,
--  CONSTRAINT t_key_object_pkey PRIMARY KEY (t_key)
--)
--WITH (
--  OIDS = False
--);
--ALTER TABLE vsa_dss_2015_2_d.t_key_object
--  OWNER TO postgres;
--- t_key_object aktualisieren (046 ist schon gelaufen, es gibt einen Datensatz)

-- INSERT INTO vsa_dss_2015_2_d.t_key_object (t_key, t_lastuniqueid, t_lastchange,  t_createdate, t_user) VALUES ( 't_id',   0, current_timestamp, current_timestamp,  'postgres');
UPDATE vsa_dss_2015_2_d.t_key_object SET t_lastuniqueid = 4, t_createdate = current_timestamp, t_user = 'postgres';

--- sequence ist schon initialisiert
--- t_ili2db_dataset initialisieren

-- 26.11.2016 korrigiert
--UPDATE vsa_dss_2015_2_d.t_ili2db_dataset SET t_id = 1, datasetname = 'vsa_dss_2015_d_340_qgepexport';
INSERT INTO vsa_dss_2015_2_d.t_ili2db_dataset (t_id, datasetname) VALUES ( 1, 'vsa_dss_2015_d_304_qgepexport');

--- t_ili2db_import initialisieren
INSERT INTO vsa_dss_2015_2_d.t_ili2db_import (t_id, dataset, importdate,  importuser, importfile) VALUES ( 2, 1, current_timestamp, 'postgres', 'qgepexport.xtf');

--- t_ili2db_basket initialisieren
INSERT INTO vsa_dss_2015_2_d.t_ili2db_basket (t_id, dataset, topic, t_ili_tid, attachmentkey) VALUES ( 3, 1, 'DSS_2015.Siedlungsentwaesserung', 'xBASKET1', 'qgepexport.xtf-3');

--- t_ili2db_import_basket initialisieren
INSERT INTO vsa_dss_2015_2_d.t_ili2db_import_basket (t_id, import, basket,  objectcount, start_t_id, end_t_id) VALUES ( 4, 2, 3, 0, 3, 3);


--- OK: fk_Attributes
--- OK: JOIN for fk_dataowner / provider
--- in Progress: organisation.fk_part_of data - prepared, but no qgep.table hierarchy and data, dito for all other class - class associations
--- Not tested: if data with reach - reach connection
--- TO DO: create dataset, create import and create_import_basket data

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('hydr_kennwerte', obj_id), 'hydr_kennwerte', obj_id
FROM qgep_od.hydraulic_characteristic_data;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_kennwerte', obj_id), obj_id
FROM qgep_od.hydraulic_characteristic_data;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('absperr_drosselorgan', obj_id), 'absperr_drosselorgan', obj_id
FROM qgep_od.throttle_shut_off_unit;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('absperr_drosselorgan', obj_id), obj_id
FROM qgep_od.throttle_shut_off_unit;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('ueberlauf', obj_id), 'ueberlauf', obj_id
FROM qgep_od.overflow;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('ueberlauf', obj_id), obj_id
FROM qgep_od.overflow;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('messresultat', obj_id), 'messresultat', obj_id
FROM qgep_od.measurement_result;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('messresultat', obj_id), obj_id
FROM qgep_od.measurement_result;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('messreihe', obj_id), 'messreihe', obj_id
FROM qgep_od.measurement_series;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('messreihe', obj_id), obj_id
FROM qgep_od.measurement_series;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('messgeraet', obj_id), 'messgeraet', obj_id
FROM qgep_od.measuring_device;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('messgeraet', obj_id), obj_id
FROM qgep_od.measuring_device;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('messstelle', obj_id), 'messstelle', obj_id
FROM qgep_od.measuring_point;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('messstelle', obj_id), obj_id
FROM qgep_od.measuring_point;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('oberflaechenabflussparameter', obj_id), 'oberflaechenabflussparameter', obj_id
FROM qgep_od.surface_runoff_parameters;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('oberflaechenabflussparameter', obj_id), obj_id
FROM qgep_od.surface_runoff_parameters;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('einzugsgebiet', obj_id), 'einzugsgebiet', obj_id
FROM qgep_od.catchment_area;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('einzugsgebiet', obj_id), obj_id
FROM qgep_od.catchment_area;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('stoff', obj_id), 'stoff', obj_id
FROM qgep_od.substance;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('stoff', obj_id), obj_id
FROM qgep_od.substance;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('unfall', obj_id), 'unfall', obj_id
FROM qgep_od.accident;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('unfall', obj_id), obj_id
FROM qgep_od.accident;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('gefahrenquelle', obj_id), 'gefahrenquelle', obj_id
FROM qgep_od.hazard_source;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('gefahrenquelle', obj_id), obj_id
FROM qgep_od.hazard_source;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('anschlussobjekt', obj_id), 'anschlussobjekt', obj_id
FROM qgep_od.connection_object;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('anschlussobjekt', obj_id), obj_id
FROM qgep_od.connection_object;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('bauwerksteil', obj_id), 'bauwerksteil', obj_id
FROM qgep_od.structure_part;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('bauwerksteil', obj_id), obj_id
FROM qgep_od.structure_part;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('hq_relation', obj_id), 'hq_relation', obj_id
FROM qgep_od.hq_relation;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('hq_relation', obj_id), obj_id
FROM qgep_od.hq_relation;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('ueberlaufcharakteristik', obj_id), 'ueberlaufcharakteristik', obj_id
FROM qgep_od.overflow_characteristic;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('ueberlaufcharakteristik', obj_id), obj_id
FROM qgep_od.overflow_characteristic;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('retentionskoerper', obj_id), 'retentionskoerper', obj_id
FROM qgep_od.retention_body;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('retentionskoerper', obj_id), obj_id
FROM qgep_od.retention_body;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('mechanischevorreinigung', obj_id), 'mechanischevorreinigung', obj_id
FROM qgep_od.mechanical_pretreatment;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('mechanischevorreinigung', obj_id), obj_id
FROM qgep_od.mechanical_pretreatment;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('hydr_geomrelation', obj_id), 'hydr_geomrelation', obj_id
FROM qgep_od.hydr_geom_relation;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_geomrelation', obj_id), obj_id
FROM qgep_od.hydr_geom_relation;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('rohrprofil_geometrie', obj_id), 'rohrprofil_geometrie', obj_id
FROM qgep_od.profile_geometry;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('rohrprofil_geometrie', obj_id), obj_id
FROM qgep_od.profile_geometry;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('haltungspunkt', obj_id), 'haltungspunkt', obj_id
FROM qgep_od.reach_point;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('haltungspunkt', obj_id), obj_id
FROM qgep_od.reach_point;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('abwassernetzelement', obj_id), 'abwassernetzelement', obj_id
FROM qgep_od.wastewater_networkelement;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('abwassernetzelement', obj_id), obj_id
FROM qgep_od.wastewater_networkelement;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('hydr_geometrie', obj_id), 'hydr_geometrie', obj_id
FROM qgep_od.hydr_geometry;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_geometrie', obj_id), obj_id
FROM qgep_od.hydr_geometry;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('badestelle', obj_id), 'badestelle', obj_id
FROM qgep_od.bathing_area;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('badestelle', obj_id), obj_id
FROM qgep_od.bathing_area;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('fischpass', obj_id), 'fischpass', obj_id
FROM qgep_od.fish_pass;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('fischpass', obj_id), obj_id
FROM qgep_od.fish_pass;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('gewaesserverbauung', obj_id), 'gewaesserverbauung', obj_id
FROM qgep_od.water_control_structure;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserverbauung', obj_id), obj_id
FROM qgep_od.water_control_structure;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('steuerungszentrale', obj_id), 'steuerungszentrale', obj_id
FROM qgep_od.control_center;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('steuerungszentrale', obj_id), obj_id
FROM qgep_od.control_center;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('schlammbehandlung', obj_id), 'schlammbehandlung', obj_id
FROM qgep_od.sludge_treatment;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('schlammbehandlung', obj_id), obj_id
FROM qgep_od.sludge_treatment;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('abwasserbehandlung', obj_id), 'abwasserbehandlung', obj_id
FROM qgep_od.waste_water_treatment;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserbehandlung', obj_id), obj_id
FROM qgep_od.waste_water_treatment;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('araenergienutzung', obj_id), 'araenergienutzung', obj_id
FROM qgep_od.wwtp_energy_use;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('araenergienutzung', obj_id), obj_id
FROM qgep_od.wwtp_energy_use;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('rohrprofil', obj_id), 'rohrprofil', obj_id
FROM qgep_od.pipe_profile;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('rohrprofil', obj_id), obj_id
FROM qgep_od.pipe_profile;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('zone', obj_id), 'zone', obj_id
FROM qgep_od.zone;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('zone', obj_id), obj_id
FROM qgep_od.zone;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('erhaltungsereignis', obj_id), 'erhaltungsereignis', obj_id
FROM qgep_od.maintenance_event;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis', obj_id), obj_id
FROM qgep_od.maintenance_event;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('abwasserbauwerk', obj_id), 'abwasserbauwerk', obj_id
FROM qgep_od.wastewater_structure;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserbauwerk', obj_id), obj_id
FROM qgep_od.wastewater_structure;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('organisation', obj_id), 'organisation', obj_id
FROM qgep_od.organisation;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('organisation', obj_id), obj_id
FROM qgep_od.organisation;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('gewaessersektor', obj_id), 'gewaessersektor', obj_id
FROM qgep_od.sector_water_body;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaessersektor', obj_id), obj_id
FROM qgep_od.sector_water_body;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('gewaessersohle', obj_id), 'gewaessersohle', obj_id
FROM qgep_od.river_bed;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaessersohle', obj_id), obj_id
FROM qgep_od.river_bed;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('ufer', obj_id), 'ufer', obj_id
FROM qgep_od.river_bank;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('ufer', obj_id), obj_id
FROM qgep_od.river_bank;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('wasserfassung', obj_id), 'wasserfassung', obj_id
FROM qgep_od.water_catchment;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('wasserfassung', obj_id), obj_id
FROM qgep_od.water_catchment;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('gewaesserabschnitt', obj_id), 'gewaesserabschnitt', obj_id
FROM qgep_od.water_course_segment;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserabschnitt', obj_id), obj_id
FROM qgep_od.water_course_segment;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('oberflaechengewaesser', obj_id), 'oberflaechengewaesser', obj_id
FROM qgep_od.surface_water_bodies;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('oberflaechengewaesser', obj_id), obj_id
FROM qgep_od.surface_water_bodies;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('grundwasserleiter', obj_id), 'grundwasserleiter', obj_id
FROM qgep_od.aquifier;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('grundwasserleiter', obj_id), obj_id
FROM qgep_od.aquifier;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('mutation', obj_id), 'mutation', obj_id
FROM qgep_od.mutation;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('mutation', obj_id), obj_id
FROM qgep_od.mutation;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('text', obj_id), 'text', obj_id
FROM qgep_od.txt_text;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('text', obj_id), obj_id
FROM qgep_od.txt_text;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('symbol', obj_id), 'symbol', obj_id
FROM qgep_od.txt_symbol;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('symbol', obj_id), obj_id
FROM qgep_od.txt_symbol;

INSERT INTO vsa_dss_2015_2_d.baseclass
(
t_id, t_type, t_ili_tid)
SELECT vsa_dss_2015_2_d.tid_generate('erhaltungsereignis_abwasserbauwerk', obj_id), 'erhaltungsereignis_abwasserbauwerk', obj_id
FROM qgep_od.re_maintenance_event_wastewater_structure;

INSERT INTO vsa_dss_2015_2_d.sia405_baseclass
(
t_id, obj_id)
SELECT vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis_abwasserbauwerk', obj_id), obj_id
FROM qgep_od.re_maintenance_event_wastewater_structure;


COMMIT;
