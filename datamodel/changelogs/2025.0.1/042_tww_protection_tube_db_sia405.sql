------ This file generates the postgres database (Modul schutzrohr (based on SIA405_SCHUTZROHR_3D_2015_LV95 (Version 18.04.2018) in en for QQIS
------ Rename classes for integration in specific TEKSI module based on this convention: https://github.com/orgs/teksi/discussions/100#discussioncomment-9058690
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 28.10.2024 20:55:20
------ with 3D coordinates

-------
CREATE TABLE tww_od.sia405pt_protection_tube
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_sia405pt_protection_tube_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_sia405pt_protection_tube_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN name_number text;
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT _name_number_length_max_40 CHECK(char_length(name_number)<=40);
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.name_number IS '';
-- ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN geometry_geometry geometry('COMPOUNDCURVE', {SRID});
-- CREATE INDEX in_tww_sia405pt_protection_tube_geometry_geometry ON tww_od.sia405pt_protection_tube USING gist (geometry_geometry );
-- COMMENT ON COLUMN tww_od.sia405pt_protection_tube.geometry_geometry IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN material  integer ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.material IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN nominal_diameter text;
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT _nominal_diameter_length_max_10 CHECK(char_length(nominal_diameter)<=10);
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.nominal_diameter IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN outside_diameter  smallint ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.outside_diameter IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN lenght  smallint ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.lenght IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN installation_year  smallint ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.installation_year IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN horizontal_positioning  integer ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.horizontal_positioning IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN status  integer ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.status IS 'Operating and planning status of the structure / Betriebs- bzw. Planungszustand des Bauwerks / Etat de fonctionnement et de planification de l’ouvrage';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN sur_plus_cover  decimal(4,1) ;
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.sur_plus_cover IS 'yyy_mittlerer Wert eines Objektes / mittlerer Wert eines Objektes / xxx_mittlerer Wert eines Objektes';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN condition text;
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT _condition_length_max_30 CHECK(char_length(condition)<=30);
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.condition IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN remark text;
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT _remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN geometry3d_geometry geometry('COMPOUNDCURVEZ', {SRID});
CREATE INDEX in_tww_sia405pt_protection_tube_geometry3d_geometry ON tww_od.sia405pt_protection_tube USING gist (geometry3d_geometry );
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.geometry3d_geometry IS '';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.sia405pt_protection_tube.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
------------ Relationships and Value Tables ----------- ;
ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN fk_owner varchar(16);
ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT rel_sia405pt_protection_tube_owner FOREIGN KEY (fk_owner) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE tww_od.sia405pt_protection_tube ADD COLUMN fk_channel varchar(16);
ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT rel_sia405pt_protection_tube_channel FOREIGN KEY (fk_channel) REFERENCES tww_od.channel(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE tww_vl.sia405pt_protection_tube_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.sia405pt_protection_tube_material ADD CONSTRAINT pkey_tww_vl_sia405pt_protection_tube_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9438,9438,'concrete','Beton','beton', 'calcestruzzo', 'beton', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9437,9437,'cast_iron.gray_iron','Guss.Grauguss','fonte.fonte_grise', 'ghisa.ghisa_grigia', 'fonta.fonta_cenusie', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9436,9436,'cast_iron.ductile_cast','Guss.Guss_duktil','fonte.fonte_ductil', 'ghisa.ghisa_duttile', 'fonta.fonta_ductila', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9433,9433,'plastic.polyethylene','Kunststoff.Polyethylen','matiere_synthetique.polyethylene', 'materiale_sintetico.polietilene', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9434,9434,'plastic.PVC','Kunststoff.Polyvinylchlorid','matiere_synthetique.chlorure_de_polyvinyle', 'materiale_sintetico.polivinilcloruro', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9435,9435,'steel','Stahl','acier', 'acciaio', 'otel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9432,9432,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT fkey_vl_sia405pt_protection_tube_material FOREIGN KEY (material)
 REFERENCES tww_vl.sia405pt_protection_tube_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.sia405pt_protection_tube_horizontal_positioning () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.sia405pt_protection_tube_horizontal_positioning ADD CONSTRAINT pkey_tww_vl_sia405pt_protection_tube_horizontal_positioning_code PRIMARY KEY (code);
 INSERT INTO tww_vl.sia405pt_protection_tube_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9443,9443,'accurate','genau','precis', 'precisa', 'precisa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9444,9444,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9445,9445,'inaccurate','ungenau','imprecis', 'impreciso', 'imprecisa', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT fkey_vl_sia405pt_protection_tube_horizontal_positioning FOREIGN KEY (horizontal_positioning)
 REFERENCES tww_vl.sia405pt_protection_tube_horizontal_positioning (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.sia405pt_protection_tube_status () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.sia405pt_protection_tube_status ADD CONSTRAINT pkey_tww_vl_sia405pt_protection_tube_status_code PRIMARY KEY (code);
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9446,9446,'inoperative','ausser_Betrieb','hors_service', 'fuori_servizio', 'rrr_ausser_Betrieb', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9447,9447,'inoperative.reserve','ausser_Betrieb.Reserve','hors_service.en_reserve', 'fuori_servizio.riserva', 'rrr_ausser_Betrieb.Reserve', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9448,9448,'operational','in_Betrieb','en_service', 'in_funzione', 'functionala', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9449,9449,'operational.tentative','in_Betrieb.provisorisch','en_service.provisoire', 'in_funzione.provvisorio', 'functionala.provizoriu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9450,9450,'others','weitere','', '', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9451,9451,'other.calculation_alternative','weitere.Berechnungsvariante','autre.variante_de_calcule', 'altro.variante_calcolo', 'alta.varianta_calcul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9452,9452,'other.planned','weitere.geplant','autre.planifie', 'altro.previsto', 'rrr_weitere.geplant', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9453,9453,'other.project','weitere.Projekt','autre.projet', 'altro.progetto', 'alta.proiect', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT fkey_vl_sia405pt_protection_tube_status FOREIGN KEY (status)
 REFERENCES tww_vl.sia405pt_protection_tube_status (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
--------- Relations to class organisation for dataowner and provider (new 3.11.2014);

ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT rel_od_sia405pt_protection_tube_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id) DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tww_od.sia405pt_protection_tube ADD CONSTRAINT rel_od_sia405pt_protection_tube_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id) DEFERRABLE INITIALLY DEFERRED;

------ Indexes on identifiers

 CREATE UNIQUE INDEX in_od_sia405pt_protection_tube_name_number ON tww_od.sia405pt_protection_tube USING btree (name_number ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
