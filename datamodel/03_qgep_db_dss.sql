------ This file generates the VSA-DSS database (Modul VSA-DSS) in en on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 03.07.2017 21:26:28
BEGIN;
------ CREATE SCHEMA qgep;

------ LAST MODIFIED -----
CREATE FUNCTION qgep_sys.update_last_modified() RETURNS trigger AS $$
BEGIN
 NEW.last_modification := TIMEOFDAY();

 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION qgep_sys.update_last_modified_parent() RETURNS trigger AS $$
DECLARE
 table_name TEXT;
BEGIN
 table_name = TG_ARGV[0];

 EXECUTE '
 UPDATE ' || table_name || '
 SET last_modification = TIMEOFDAY()::timestamp
 WHERE obj_id = ''' || NEW.obj_id || '''
';
 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
---------------------------

CREATE TABLE qgep_sys.value_list_base
(
code integer NOT NULL,
vsacode integer NOT NULL,
value_en character varying(50),
value_de character varying(50),
value_fr character varying(50),
value_it character varying(60),
value_ro character varying(50),
abbr_en character varying(3),
abbr_de character varying(3),
abbr_fr character varying(3),
abbr_it character varying(3),
abbr_ro character varying(3),
active boolean,
CONSTRAINT pkey_qgep_value_list_code PRIMARY KEY (code)
)
WITH (
   OIDS = False
);
-------
CREATE TABLE qgep_od.re_maintenance_event_wastewater_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_re_maintenance_event_wastewater_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_re_maintenance_event_wastewater_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','re_maintenance_event_wastewater_structure');
COMMENT ON COLUMN qgep_od.re_maintenance_event_wastewater_structure.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
-------
CREATE TABLE qgep_od.txt_symbol
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_txt_symbol_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_txt_symbol_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.txt_symbol ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','txt_symbol');
COMMENT ON COLUMN qgep_od.txt_symbol.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN classname  varchar(50) ;
COMMENT ON COLUMN qgep_od.txt_symbol.classname IS 'Name of class that textclass is related to / Name der Klasse zu der die Textklasse gehört / xxx_Name der Klasse zu der die Textklasse gehört';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN plantype  integer ;
COMMENT ON COLUMN qgep_od.txt_symbol.plantype IS '';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN symbol_scaling_heigth  decimal(2,1) ;
COMMENT ON COLUMN qgep_od.txt_symbol.symbol_scaling_heigth IS '';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN symbol_scaling_width  decimal(2,1) ;
COMMENT ON COLUMN qgep_od.txt_symbol.symbol_scaling_width IS '';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN symbolori  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.txt_symbol.symbolori IS '';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN symbolpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_txt_symbol_symbolpos_geometry ON qgep_od.txt_symbol USING gist (symbolpos_geometry );
COMMENT ON COLUMN qgep_od.txt_symbol.symbolpos_geometry IS '';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.txt_symbol.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.txt_symbol.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.txt_symbol ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.txt_symbol.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_symbol
BEFORE UPDATE OR INSERT ON
 qgep_od.txt_symbol
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.txt_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_txt_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_txt_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.txt_text ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','txt_text');
COMMENT ON COLUMN qgep_od.txt_text.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.txt_text ADD COLUMN classname  varchar(50) ;
COMMENT ON COLUMN qgep_od.txt_text.classname IS 'Name of class that textclass is related to / Name der Klasse zu der die Textklasse gehört / xxx_Name der Klasse zu der die Textklasse gehört';
ALTER TABLE qgep_od.txt_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN qgep_od.txt_text.plantype IS '';
ALTER TABLE qgep_od.txt_text ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.txt_text.remark IS 'General remarks';
ALTER TABLE qgep_od.txt_text ADD COLUMN text  text ;
COMMENT ON COLUMN qgep_od.txt_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
ALTER TABLE qgep_od.txt_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN qgep_od.txt_text.texthali IS '';
ALTER TABLE qgep_od.txt_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.txt_text.textori IS '';
ALTER TABLE qgep_od.txt_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_txt_text_textpos_geometry ON qgep_od.txt_text USING gist (textpos_geometry );
COMMENT ON COLUMN qgep_od.txt_text.textpos_geometry IS '';
ALTER TABLE qgep_od.txt_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN qgep_od.txt_text.textvali IS '';
ALTER TABLE qgep_od.txt_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.txt_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_text
BEFORE UPDATE OR INSERT ON
 qgep_od.txt_text
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.mutation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_mutation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_mutation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.mutation ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','mutation');
COMMENT ON COLUMN qgep_od.mutation.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.mutation ADD COLUMN attribute  varchar(50) ;
COMMENT ON COLUMN qgep_od.mutation.attribute IS 'Attribute name of chosen object / Attributname des gewählten Objektes / Nom de l''attribut de l''objet à sélectionner';
ALTER TABLE qgep_od.mutation ADD COLUMN classname  varchar(50) ;
COMMENT ON COLUMN qgep_od.mutation.classname IS 'Class name of chosen object / Klassenname des gewählten Objektes / Nom de classe de l''objet à sélectionner';
ALTER TABLE qgep_od.mutation ADD COLUMN date_mutation  timestamp without time zone ;
COMMENT ON COLUMN qgep_od.mutation.date_mutation IS 'if changed: Date/Time of changement. If deleted date/time of deleting / Bei geaendert Datum/Zeit der Änderung. Bei gelöscht Datum/Zeit der Löschung / changée: Date/Temps du changement. effacée: Date/Temps de la suppression';
ALTER TABLE qgep_od.mutation ADD COLUMN date_time  timestamp without time zone ;
COMMENT ON COLUMN qgep_od.mutation.date_time IS 'Date/Time of collecting data in the field. Else Date/Time of creating data set on the system / Datum/Zeit der Aufnahme im Feld falls vorhanden bei erstellt. Sonst Datum/Uhrzeit der Erstellung auf dem System / Date/temps de la relève, sinon date/temps de création dans le système';
ALTER TABLE qgep_od.mutation ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.mutation.kind IS '';
ALTER TABLE qgep_od.mutation ADD COLUMN last_value  varchar(100) ;
COMMENT ON COLUMN qgep_od.mutation.last_value IS 'last_value changed to text. Only with type=changed and deleted / Letzter Wert umgewandelt in Text. Nur bei ART=geaendert oder geloescht / Dernière valeur modifiée du texte. Seulement avec GENRE = changee ou effacee';
ALTER TABLE qgep_od.mutation ADD COLUMN object  varchar(20) ;
COMMENT ON COLUMN qgep_od.mutation.object IS 'OBJ_ID of Object / OBJ_ID des Objektes / OBJ_ID de l''objet';
ALTER TABLE qgep_od.mutation ADD COLUMN recorded_by  varchar(80) ;
COMMENT ON COLUMN qgep_od.mutation.recorded_by IS 'Name of person who recorded the dataset / Name des Aufnehmers im Feld / Nom de la personne, qui a relevé les données';
ALTER TABLE qgep_od.mutation ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.mutation.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.mutation ADD COLUMN system_user  varchar(20) ;
COMMENT ON COLUMN qgep_od.mutation.system_user IS 'Name of system user / Name des Systembenutzers / Usager du système informatique';
ALTER TABLE qgep_od.mutation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.mutation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.mutation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.mutation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.mutation ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.mutation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_mutation
BEFORE UPDATE OR INSERT ON
 qgep_od.mutation
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.aquifier
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_aquifier_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_aquifier_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.aquifier ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','aquifier');
COMMENT ON COLUMN qgep_od.aquifier.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.aquifier ADD COLUMN average_groundwater_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.aquifier.average_groundwater_level IS 'Average level of groundwater table / Höhe des mittleren Grundwasserspiegels / Niveau moyen de la nappe';
ALTER TABLE qgep_od.aquifier ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.aquifier.identifier IS '';
ALTER TABLE qgep_od.aquifier ADD COLUMN maximal_groundwater_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.aquifier.maximal_groundwater_level IS 'Maximal level of ground water table / Maximale Lage des Grundwasserspiegels / Niveau maximal de la nappe';
ALTER TABLE qgep_od.aquifier ADD COLUMN minimal_groundwater_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.aquifier.minimal_groundwater_level IS 'Minimal level of groundwater table / Minimale Lage des Grundwasserspiegels / Niveau minimal de la nappe';
ALTER TABLE qgep_od.aquifier ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_aquifier_perimeter_geometry ON qgep_od.aquifier USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.aquifier.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
ALTER TABLE qgep_od.aquifier ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.aquifier.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.aquifier ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.aquifier.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.aquifier ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.aquifier.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.aquifier ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.aquifier.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_aquifier
BEFORE UPDATE OR INSERT ON
 qgep_od.aquifier
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.surface_water_bodies
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_surface_water_bodies_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_surface_water_bodies_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.surface_water_bodies ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','surface_water_bodies');
COMMENT ON COLUMN qgep_od.surface_water_bodies.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.surface_water_bodies ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.surface_water_bodies.identifier IS '';
ALTER TABLE qgep_od.surface_water_bodies ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.surface_water_bodies.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.surface_water_bodies ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.surface_water_bodies.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.surface_water_bodies ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.surface_water_bodies.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.surface_water_bodies ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.surface_water_bodies.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_surface_water_bodies
BEFORE UPDATE OR INSERT ON
 qgep_od.surface_water_bodies
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.river
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_river_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_river_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.river ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','river');
COMMENT ON COLUMN qgep_od.river.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.river ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.river.kind IS 'yyy_Art des Fliessgewässers. Klassifizierung nach GEWISS / Art des Fliessgewässers. Klassifizierung nach GEWISS / Type de cours d''eau. Classification selon GEWISS';
-------
CREATE TRIGGER
update_last_modified_river
BEFORE UPDATE OR INSERT ON
 qgep_od.river
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.surface_water_bodies");

-------
-------
CREATE TABLE qgep_od.lake
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_lake_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_lake_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.lake ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','lake');
COMMENT ON COLUMN qgep_od.lake.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.lake ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_lake_perimeter_geometry ON qgep_od.lake USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.lake.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_lake
BEFORE UPDATE OR INSERT ON
 qgep_od.lake
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.surface_water_bodies");

-------
-------
CREATE TABLE qgep_od.water_course_segment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_water_course_segment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_water_course_segment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.water_course_segment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','water_course_segment');
COMMENT ON COLUMN qgep_od.water_course_segment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN algae_growth  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.algae_growth IS 'Coverage with algae / Bewuchs mit Algen / Couverture végétale par des algues';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN altitudinal_zone  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.altitudinal_zone IS 'Alltiduinal zone of a water course / Höhenstufentypen eines Gewässers / Type d''étage d''altitude des cours d''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN bed_with  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.water_course_segment.bed_with IS 'Average bed with / mittlere Sohlenbreite / Largeur moyenne du lit';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN dead_wood  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.dead_wood IS 'Accumulations of dead wood in water course section / Ansammlungen von Totholz im Gewässerabschnitt / Amas de bois mort dans le cours d''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN depth_variability  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.depth_variability IS 'Variability of depth of water course / Variabilität der Gewässertiefe / Variabilité de la profondeur d''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN discharge_regime  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.discharge_regime IS 'yyy_Grad der antropogenen Beeinflussung des charakteristischen Ganges des Abflusses. / Grad der antropogenen Beeinflussung des charakteristischen Ganges des Abflusses. / Degré d''intervention anthropogène sur le régime hydraulique';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN ecom_classification  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.ecom_classification IS 'Summary attribut of ecomorphological classification of level F / Summenattribut aus der ökomorphologischen Klassifizierung nach Stufe F / Attribut issu de la classification écomorphologique du niveau R';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN from_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_water_course_segment_from_geometry ON qgep_od.water_course_segment USING gist (from_geometry );
COMMENT ON COLUMN qgep_od.water_course_segment.from_geometry IS 'Position of segment start point in water course / Lage des Abschnittanfangs  im Gewässerverlauf / Situation du début du tronçon';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.water_course_segment.identifier IS '';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.kind IS '';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN length_profile  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.length_profile IS 'Character of length profile / Charakterisierung des Gewässerlängsprofil / Caractérisation du profil en long';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN macrophyte_coverage  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.macrophyte_coverage IS 'Coverage with macrophytes / Bewuchs mit Makrophyten / Couverture végétale par des macrophytes (végétation aquatique (macroscopique))';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.water_course_segment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN section_morphology  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.section_morphology IS 'yyy_Linienführung eines Gewässerabschnittes / Linienführung eines Gewässerabschnittes / Tracé d''un cours d''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN size  smallint ;
COMMENT ON COLUMN qgep_od.water_course_segment.size IS 'Classification by Strahler / Ordnungszahl nach Strahler / Classification selon Strahler';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN slope  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.slope IS 'Average slope of water course segment / Mittleres Gefälle des Gewässerabschnittes / Pente moyenne du fond du tronçon cours d''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN to_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_water_course_segment_to_geometry ON qgep_od.water_course_segment USING gist (to_geometry );
COMMENT ON COLUMN qgep_od.water_course_segment.to_geometry IS 'Position of segment end point in water course / Lage Abschnitt-Ende im Gewässerverlauf / Situation de la fin du tronçon';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN utilisation  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.utilisation IS 'Primary utilisation of water course segment / Primäre Nutzung des Gewässerabschnittes / Utilisation primaire du tronçon de cours d''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN water_hardness  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.water_hardness IS 'Chemical water hardness / Chemische Wasserhärte / Dureté chimique de l''eau';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN width_variability  integer ;
COMMENT ON COLUMN qgep_od.water_course_segment.width_variability IS 'yyy_Breitenvariabilität des Wasserspiegels bei niedrigem bis mittlerem Abfluss / Breitenvariabilität des Wasserspiegels bei niedrigem bis mittlerem Abfluss / Variabilité de la largeur du lit mouillé par basses et moyennes eaux';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.water_course_segment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.water_course_segment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.water_course_segment ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.water_course_segment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_water_course_segment
BEFORE UPDATE OR INSERT ON
 qgep_od.water_course_segment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.water_catchment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_water_catchment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_water_catchment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.water_catchment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','water_catchment');
COMMENT ON COLUMN qgep_od.water_catchment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.water_catchment ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.water_catchment.identifier IS '';
ALTER TABLE qgep_od.water_catchment ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.water_catchment.kind IS 'Type of water catchment / Art der Trinkwasserfassung / Genre de prise d''eau';
ALTER TABLE qgep_od.water_catchment ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.water_catchment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.water_catchment ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_water_catchment_situation_geometry ON qgep_od.water_catchment USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.water_catchment.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.water_catchment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.water_catchment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.water_catchment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.water_catchment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.water_catchment ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.water_catchment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_water_catchment
BEFORE UPDATE OR INSERT ON
 qgep_od.water_catchment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.river_bank
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_river_bank_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_river_bank_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.river_bank ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','river_bank');
COMMENT ON COLUMN qgep_od.river_bank.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.river_bank ADD COLUMN control_grade_of_river  integer ;
COMMENT ON COLUMN qgep_od.river_bank.control_grade_of_river IS 'yyy_Flächenhafter Verbauungsgrad des Böschungsfusses in %. Aufteilung in Klassen. / Flächenhafter Verbauungsgrad des Böschungsfusses in %. Aufteilung in Klassen. / Degré d''aménagement du pied du talus du cours d''eau';
ALTER TABLE qgep_od.river_bank ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.river_bank.identifier IS '';
ALTER TABLE qgep_od.river_bank ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.river_bank.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.river_bank ADD COLUMN river_control_type  integer ;
COMMENT ON COLUMN qgep_od.river_bank.river_control_type IS 'yyy_Verbauungsart des Böschungsfusses / Verbauungsart des Böschungsfusses / Genre d''aménagement du pied de la berge du cours d''eau';
ALTER TABLE qgep_od.river_bank ADD COLUMN shores  integer ;
COMMENT ON COLUMN qgep_od.river_bank.shores IS 'yyy_Beschaffenheit des Bereiches oberhalb des Böschungsfusses / Beschaffenheit des Bereiches oberhalb des Böschungsfusses / Nature de la zone en dessus du pied de la berge du cours d''eau';
ALTER TABLE qgep_od.river_bank ADD COLUMN side  integer ;
COMMENT ON COLUMN qgep_od.river_bank.side IS 'yyy_Linke oder rechte Uferseite in Fliessrichtung / Linke oder rechte Uferseite in Fliessrichtung / Berges sur le côté gauche ou droite du cours d''eau par rapport au sens d''écoulement';
ALTER TABLE qgep_od.river_bank ADD COLUMN utilisation_of_shore_surroundings  integer ;
COMMENT ON COLUMN qgep_od.river_bank.utilisation_of_shore_surroundings IS 'yyy_Nutzung des Gewässerumlandes / Nutzung des Gewässerumlandes / Utilisation du sol des environs';
ALTER TABLE qgep_od.river_bank ADD COLUMN vegetation  integer ;
COMMENT ON COLUMN qgep_od.river_bank.vegetation IS '';
ALTER TABLE qgep_od.river_bank ADD COLUMN width  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.river_bank.width IS 'yyy_Breite des Bereiches oberhalb des Böschungsfusses bis zum Gebiet mit "intensiver Landnutzung" / Breite des Bereiches oberhalb des Böschungsfusses bis zum Gebiet mit "intensiver Landnutzung" / Distance horizontale de la zone comprise entre le pied de la berge et la zone d''utilisation intensive du sol';
ALTER TABLE qgep_od.river_bank ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.river_bank.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.river_bank ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.river_bank.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.river_bank ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.river_bank.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_river_bank
BEFORE UPDATE OR INSERT ON
 qgep_od.river_bank
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.river_bed
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_river_bed_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_river_bed_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.river_bed ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','river_bed');
COMMENT ON COLUMN qgep_od.river_bed.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.river_bed ADD COLUMN control_grade_of_river  integer ;
COMMENT ON COLUMN qgep_od.river_bed.control_grade_of_river IS 'yyy_Flächenhafter Verbauungsgrad der Gewässersohle in %. Aufteilung in Klassen. / Flächenhafter Verbauungsgrad der Gewässersohle in %. Aufteilung in Klassen. / Pourcentage de la surface avec aménagement du fond du lit. Classification';
ALTER TABLE qgep_od.river_bed ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.river_bed.identifier IS '';
ALTER TABLE qgep_od.river_bed ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.river_bed.kind IS 'type of bed / Sohlentyp / Type de fond';
ALTER TABLE qgep_od.river_bed ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.river_bed.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.river_bed ADD COLUMN river_control_type  integer ;
COMMENT ON COLUMN qgep_od.river_bed.river_control_type IS 'Type of river control / Art des Sohlenverbaus / Genre d''aménagement du fond';
ALTER TABLE qgep_od.river_bed ADD COLUMN width  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.river_bed.width IS 'yyy_Bei Hochwasser umgelagerter Bereich (frei von höheren Wasserpflanzen) / Bei Hochwasser umgelagerter Bereich (frei von höheren Wasserpflanzen) / Zone de charriage par hautes eaux (absence de plantes aquatiques supérieures)';
ALTER TABLE qgep_od.river_bed ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.river_bed.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.river_bed ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.river_bed.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.river_bed ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.river_bed.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_river_bed
BEFORE UPDATE OR INSERT ON
 qgep_od.river_bed
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.sector_water_body
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_sector_water_body_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_sector_water_body_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.sector_water_body ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','sector_water_body');
COMMENT ON COLUMN qgep_od.sector_water_body.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN code_bwg  varchar(50) ;
COMMENT ON COLUMN qgep_od.sector_water_body.code_bwg IS 'Code as published by the Federal Office for Water and Geology (FOWG) / Code gemäss Format des Bundesamtes für Wasser und Geologie (BWG) / Code selon le format de l''Office fédéral des eaux et de la géologie (OFEG)';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.sector_water_body.identifier IS 'yyy_Eindeutiger Name des Sektors, ID des Bundesamtes für Wasserwirtschaft  und Geologie (BWG, früher BWW) falls Sektor von diesem bezogen wurde. / Eindeutiger Name des Sektors, ID des Bundesamtes für Wasserwirtschaft  und Geologie (BWG, früher BWW) falls Sektor von diesem bezogen wurde. / Nom univoque du secteur, identificateur de l''office fédéral des eaux et de la géologie (OFEG, anciennement OFEE) si existant';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.sector_water_body.kind IS 'Shore or water course line. Important to distinguish lake traversals and waterbodies / Ufer oder Gewässerlinie. Zur Unterscheidung der Seesektoren wichtig. / Rives ou limites d''eau. Permet la différenciation des différents secteurs d''un lac ou cours d''eau';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN km_down  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.sector_water_body.km_down IS 'yyy_Adresskilometer beim Sektorende (nur definieren, falls es sich um den letzten Sektor handelt oder ein Sprung in der Adresskilometrierung von einem Sektor zum nächsten  existiert) / Adresskilometer beim Sektorende (nur definieren, falls es sich um den letzten Sektor handelt oder ein Sprung in der Adresskilometrierung von einem Sektor zum nächsten  existiert) / Kilomètre de la fin du secteur (à définir uniquement s''il s''agit du dernier secteur ou lors d''un saut dans le kilométrage d''un secteur à un autre)';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN km_up  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.sector_water_body.km_up IS 'yyy_Adresskilometer beim Sektorbeginn / Adresskilometer beim Sektorbeginn / Kilomètre du début du secteur';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN progression_geometry geometry('COMPOUNDCURVE', :SRID);
CREATE INDEX in_qgep_od_sector_water_body_progression_geometry ON qgep_od.sector_water_body USING gist (progression_geometry );
COMMENT ON COLUMN qgep_od.sector_water_body.progression_geometry IS 'yyy_Reihenfolge von Punkten die den Verlauf eines Gewässersektors beschreiben / Reihenfolge von Punkten die den Verlauf eines Gewässersektors beschreiben / Suite de points qui décrivent le tracé d''un secteur d''un cours d''eau';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN ref_length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sector_water_body.ref_length IS 'yyy_Basislänge in Zusammenhang mit der Gewässerkilometrierung (siehe GEWISS - SYSEAU) / Basislänge in Zusammenhang mit der Gewässerkilometrierung (siehe GEWISS - SYSEAU) / Longueur de référence pour ce kilométrage des cours d''eau (voir GEWISS - SYSEAU)';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.sector_water_body.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.sector_water_body.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.sector_water_body.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.sector_water_body ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.sector_water_body.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_sector_water_body
BEFORE UPDATE OR INSERT ON
 qgep_od.sector_water_body
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.organisation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_organisation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_organisation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.organisation ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','organisation');
COMMENT ON COLUMN qgep_od.organisation.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.organisation ADD COLUMN identifier  varchar(80) ;
COMMENT ON COLUMN qgep_od.organisation.identifier IS 'It is suggested to use real names, e.g. Sample_Community and not only Community. Or "Waste Water Association WWTP Example" and not only Waste Water Association because there will be multiple objects / Es wird empfohlen reale Namen zu nehmen, z.B. Mustergemeinde und nicht Gemeinde. Oder Abwasserverband ARA Muster und nicht nur Abwasserverband, da es sonst Probleme gibt bei der Zusammenführung der Daten. / Utilisez les noms réels, par ex. commune "exemple" et pas seulement commune. Ou "Association pour l''épuration des eaux usées STEP XXX" et pas seulement  Association pour l''épuration des eaux usées. Sinon vous risquer des problèmes en réunissant les données de différentes communes.';
ALTER TABLE qgep_od.organisation ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.organisation.remark IS 'yyy Fehler bei Zuordnung / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.organisation ADD COLUMN uid  varchar(12) ;
COMMENT ON COLUMN qgep_od.organisation.uid IS 'yyyReferenz zur Unternehmensidentifikation des Bundesamts fuer Statistik (www.uid.admin.ch), e.g. z.B. CHE123456789 / Referenz zur Unternehmensidentifikation des Bundesamts fuer Statistik (www.uid.admin.ch), z.B. CHE123456789 / Référence pour l’identification des entreprises selon l’Office fédéral de la statistique OFS (www.uid.admin.ch), par exemple: CHE123456789';
ALTER TABLE qgep_od.organisation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.organisation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.organisation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.organisation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.organisation ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.organisation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_organisation
BEFORE UPDATE OR INSERT ON
 qgep_od.organisation
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.cooperative
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_cooperative_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_cooperative_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.cooperative ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','cooperative');
COMMENT ON COLUMN qgep_od.cooperative.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
-------
CREATE TRIGGER
update_last_modified_cooperative
BEFORE UPDATE OR INSERT ON
 qgep_od.cooperative
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.canton
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_canton_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_canton_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.canton ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','canton');
COMMENT ON COLUMN qgep_od.canton.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.canton ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_canton_perimeter_geometry ON qgep_od.canton USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.canton.perimeter_geometry IS 'Border of canton / Kantonsgrenze / Limites cantonales';
-------
CREATE TRIGGER
update_last_modified_canton
BEFORE UPDATE OR INSERT ON
 qgep_od.canton
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.waste_water_association
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_waste_water_association_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_waste_water_association_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.waste_water_association ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','waste_water_association');
COMMENT ON COLUMN qgep_od.waste_water_association.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
-------
CREATE TRIGGER
update_last_modified_waste_water_association
BEFORE UPDATE OR INSERT ON
 qgep_od.waste_water_association
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.municipality
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_municipality_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_municipality_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.municipality ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','municipality');
COMMENT ON COLUMN qgep_od.municipality.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.municipality ADD COLUMN altitude  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.municipality.altitude IS 'Average altitude of settlement area / Mittlere Höhe des Siedlungsgebietes / Altitude moyenne de l''agglomération';
ALTER TABLE qgep_od.municipality ADD COLUMN gwdp_year  smallint ;
COMMENT ON COLUMN qgep_od.municipality.gwdp_year IS 'Year of legal validity of General Water Drainage Planning (GWDP) / Rechtsgültiges GEP aus dem Jahr / PGEE en vigueur depuis';
ALTER TABLE qgep_od.municipality ADD COLUMN municipality_number  smallint ;
COMMENT ON COLUMN qgep_od.municipality.municipality_number IS 'Official number of federal office for statistics / Offizielle Nummer gemäss Bundesamt für Statistik / Numéro officiel de la commune selon l''Office fédéral de la statistique';
ALTER TABLE qgep_od.municipality ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_municipality_perimeter_geometry ON qgep_od.municipality USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.municipality.perimeter_geometry IS 'Border of the municipality / Gemeindegrenze / Limites communales';
ALTER TABLE qgep_od.municipality ADD COLUMN population  integer ;
COMMENT ON COLUMN qgep_od.municipality.population IS 'Permanent opulation (based on statistics of the municipality) / Ständige Einwohner (laut Einwohnerkontrolle der Gemeinde) / Habitants permanents (selon le contrôle des habitants de la commune)';
ALTER TABLE qgep_od.municipality ADD COLUMN total_surface  decimal(10,4) ;
COMMENT ON COLUMN qgep_od.municipality.total_surface IS 'Total surface without lakes / Fläche ohne Seeanteil / Surface sans partie de lac';
-------
CREATE TRIGGER
update_last_modified_municipality
BEFORE UPDATE OR INSERT ON
 qgep_od.municipality
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.administrative_office
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_administrative_office_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_administrative_office_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.administrative_office ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','administrative_office');
COMMENT ON COLUMN qgep_od.administrative_office.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
-------
CREATE TRIGGER
update_last_modified_administrative_office
BEFORE UPDATE OR INSERT ON
 qgep_od.administrative_office
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.waste_water_treatment_plant
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_waste_water_treatment_plant_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_waste_water_treatment_plant_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.waste_water_treatment_plant ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','waste_water_treatment_plant');
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN bod5  smallint ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.bod5 IS '5 day biochemical oxygen demand measured at a temperatur of 20 degree celsius. YYY / Biochemischer Sauerstoffbedarf nach 5 Tagen Messzeit und bei einer Temperatur vom 20 Grad Celsius. Er stellt den Verbrauch an gelöstem Sauerstoff durch die Lebensvorgänge der im Wasser oder Abwasser enthaltenen Mikroorganismen (Bakterienprotozoen) beim  Abbau organischer Substanzen dar. Der Wert stellt eine wichtige Grösse zur Beurteilung der  aerob abbaufähigen Substanzen dar. Der BSB5 wird in den Einheiten mg/l oder g/m3 angegeben. Ausser dem BSB5 wird der biochemische Sauerstoffbedarf auch an 20 Tagen und mehr bestimmt. Dann spricht man z.B. vom BSB20 usw. Siehe Sapromat, Winklerprobe, Verdünnungsmethode. (arb) / Elle représente la quantité d’oxygène dépensée par les phénomènes d’oxydation chimique, d’une part, et, d’autre part, la dégradation des matières organiques par voie aérobie, nécessaire à la destruction des composés organiques. Elle s’exprime en milligrammes d’O2 consommé par litre d’effluent. Par convention, on retient le résultat de la consommation d’oxygène à 20° C au bout de 5 jours, ce qui donne l’appellation DBO5. (d’après M. Satin, B. Selmi, Guide technique de l’assainissement).';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN cod  smallint ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.cod IS 'Abbreviation for chemical oxygen demand (COD). / Abkürzung für den chemischen Sauerstoffbedarf. Die englische Abkürzung lautet COD. Mit einem starken Oxydationsmittel wird mehr oder weniger erfolgreich versucht, die organischen Verbindungen der Abwasserprobe zu CO2 und H2O zu oxydieren. Als Oxydationsmittel eignen sich Chromverbindungen verschiedener Wertigkeit (z.B. Kalium-Dichromat K2Cr2O7) und Manganverbindungen (z.B. KmnO4), wobei man unter dem CSB im Allgemeinen den chemischen Sauerstoffbedarf nach der Kalium-Dichromat-Methode) versteht. Das Resultat kann als Chromatverbrauch oder Kaliumpermanaganatverbrauch ausgedrückt werden (z.B. mg CrO4 2-/l oder mg KMnO4/l). Im allgemeinen ergibt die Kalium-Dichromat-Methode höhere Werte als mit Kaliumpermanganat. Das Verhältnis des CSB zum BSB5 gilt als Hinweis auf die Abbaubarkeit der organischen Abwasserinhaltsstoffe. Leicht abbaubare häusliche Abwässer haben einen DSB/BSB5-Verhältnis von 1 bis 1,5. Schweres abbaubares, industrielles Abwasser ein Verhältnis von über 2. (arb) / Elle représente la teneur totale de l’eau en matières organiques, qu’elles soient ou non biodégradables. Le principe repose sur la recherche d’un besoin d’oxygène de l’échantillon pour dégrader la matière organique. Mais dans ce cas, l’oxygène est fourni par un oxydant puissant (le bichromate de potassium). La réaction (Afnor T90-101) est pratiquée à chaud (150°C) en présence d’acide sulfurique, et après 2 h on mesure la quantité d’oxydant restant. Là encore, le résultat s’exprime en milligrammes d’O2 par litre d’effluent.  Le rapport entre DCO/DBO5 est d’environ 2 à 2.7 pour une eau usée domestique ; au-delà, il y a vraisemblablement présence d’eaux industrielles résiduaires.';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN elimination_cod  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.elimination_cod IS 'Dimensioning value elimination rate in percent / Dimensionierungswert Eliminationsrate in % / Valeur de dimensionnement, taux d''élimination en %';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN elimination_n  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.elimination_n IS 'Denitrification at at waster water temperature of below 10 degree celsius / Denitrifikation bei einer Abwassertemperatur von > 10 Grad / Dénitrification à une température des eaux supérieure à 10°C';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN elimination_nh4  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.elimination_nh4 IS 'Dimensioning value elimination rate in percent / Dimensionierungswert: Eliminationsrate in % / Valeur de dimensionnement, taux d''élimination en %';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN elimination_p  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.elimination_p IS 'Dimensioning value elimination rate in percent / Dimensionierungswert Eliminationsrate in % / Valeur de dimensionnement, taux d''élimination en %';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN installation_number  integer ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.installation_number IS 'WWTP Number from Federal Office for the Environment (FOEN) / ARA-Nummer gemäss Bundesamt für Umwelt (BAFU) / Numéro de la STEP selon l''Office fédéral de l''environnement (OFEV)';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN kind  varchar(50) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.kind IS '';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN nh4  smallint ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.nh4 IS 'yyy_Dimensioning value Ablauf Vorklärung. NH4 [gNH4/m3] / Dimensionierungswert Ablauf Vorklärung. NH4 [gNH4/m3] / Valeur de dimensionnement, NH4 à la sortie du décanteur primaire. NH4 [gNH4/m3]';
ALTER TABLE qgep_od.waste_water_treatment_plant ADD COLUMN start_year  smallint ;
COMMENT ON COLUMN qgep_od.waste_water_treatment_plant.start_year IS 'Start of operation (year) / Jahr der Inbetriebnahme / Année de la mise en exploitation';
-------
CREATE TRIGGER
update_last_modified_waste_water_treatment_plant
BEFORE UPDATE OR INSERT ON
 qgep_od.waste_water_treatment_plant
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.private
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_private_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_private_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.private ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','private');
COMMENT ON COLUMN qgep_od.private.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.private ADD COLUMN kind  varchar(50) ;
COMMENT ON COLUMN qgep_od.private.kind IS '';
-------
CREATE TRIGGER
update_last_modified_private
BEFORE UPDATE OR INSERT ON
 qgep_od.private
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.organisation");

-------
-------
CREATE TABLE qgep_od.wastewater_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wastewater_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wastewater_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wastewater_structure ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wastewater_structure');
COMMENT ON COLUMN qgep_od.wastewater_structure.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN accessibility  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure.accessibility IS 'yyy_Möglichkeit der Zugänglichkeit ins Innere eines Abwasserbauwerks für eine Person (nicht für ein Fahrzeug) / Möglichkeit der Zugänglichkeit ins Innere eines Abwasserbauwerks für eine Person (nicht für ein Fahrzeug) / Possibilités d’accès à l’ouvrage d’assainissement pour une personne (non pour un véhicule)';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN contract_section  varchar(50) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.contract_section IS 'Number of contract section / Nummer des Bauloses / Numéro du lot de construction';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN detail_geometry_geometry geometry('CURVEPOLYGONZ', :SRID);
CREATE INDEX in_qgep_od_wastewater_structure_detail_geometry_geometry ON qgep_od.wastewater_structure USING gist (detail_geometry_geometry );
COMMENT ON COLUMN qgep_od.wastewater_structure.detail_geometry_geometry IS 'Detail geometry especially with special structures. For manhole usually use dimension1 and 2. Also with normed infiltratin structures.  Channels usually do not have a detail_geometry. / Detaillierte Geometrie insbesondere bei Spezialbauwerken. Für Normschächte i.d. R.  Dimension1 und 2 verwenden. Dito bei normierten Versickerungsanlagen.  Kanäle haben normalerweise keine Detailgeometrie. / Géométrie détaillée particulièrement pour un OUVRAGE_SPECIAL. Pour l’attribut CHAMBRE_STANDARD utilisez Dimension1 et 2, de même pour une INSTALLATION_INFILTRATION normée.  Les canalisations n’ont en général pas de géométrie détaillée.';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN financing  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure.financing IS ' Method of financing  (Financing based on GschG Art. 60a). / Finanzierungart (Finanzierung gemäss GschG Art. 60a). / Type de financement (financement selon LEaux Art. 60a)';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.gross_costs IS 'Gross costs of construction / Brutto Erstellungskosten / Coûts bruts des travaux de construction';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.identifier IS 'yyy_Pro Datenherr eindeutige Bezeichnung / Pro Datenherr eindeutige Bezeichnung / Désignation unique pour chaque maître des données';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN inspection_interval  decimal(4,2) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.inspection_interval IS 'yyy_Abstände, in welchen das Abwasserbauwerk inspiziert werden sollte (Jahre) / Abstände, in welchen das Abwasserbauwerk inspiziert werden sollte (Jahre) / Fréquence à laquelle un ouvrage du réseau d‘assainissement devrait subir une inspection (années)';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN location_name  varchar(50) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.location_name IS 'Street name or name of the location of the structure / Strassenname oder Ortsbezeichnung  zum Bauwerk / Nom de la route ou du lieu de l''ouvrage';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN records  varchar(255) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.records IS 'yyy_Plan Nr. der Ausführungsdokumentation. Kurzbeschrieb weiterer Akten (Betriebsanleitung vom …, etc.) / Plan Nr. der Ausführungsdokumentation. Kurzbeschrieb weiterer Akten (Betriebsanleitung vom …, etc.) / N° de plan de la documentation d’exécution, description de dossiers, manuels, etc.';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN renovation_necessity  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure.renovation_necessity IS 'yyy_Dringlichkeitsstufen und Zeithorizont für bauliche Massnahmen gemäss VSA-Richtline "Erhaltung von Kanalisationen" / Dringlichkeitsstufen und Zeithorizont für bauliche Massnahmen gemäss VSA-Richtline "Erhaltung von Kanalisationen" / 	Degrés d’urgence et délai de réalisation des mesures constructives selon la directive VSA "Maintien des canalisations"';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN replacement_value  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.replacement_value IS 'yyy_Wiederbeschaffungswert des Bauwerks. Zusätzlich muss auch das Attribut WBW_Basisjahr erfasst werden / Wiederbeschaffungswert des Bauwerks. Zusätzlich muss auch das Attribut WBW_Basisjahr erfasst werden / Valeur de remplacement de l''OUVRAGE_RESEAU_AS. On à besoin aussi de saisir l''attribut VR_ANNEE_REFERENCE';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN rv_base_year  smallint ;
COMMENT ON COLUMN qgep_od.wastewater_structure.rv_base_year IS 'yyy_Basisjahr für die Kalkulation des Wiederbeschaffungswerts (siehe auch Wiederbeschaffungswert) / Basisjahr für die Kalkulation des Wiederbeschaffungswerts (siehe auch Attribut Wiederbeschaffungswert) / Année de référence pour le calcul de la valeur de remplacement (cf. valeur de remplacement)';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN rv_construction_type  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure.rv_construction_type IS 'yyy_Grobe Einteilung der Bauart des Abwasserbauwerks als Inputwert für die Berechnung des Wiederbeschaffungswerts. / Grobe Einteilung der Bauart des Abwasserbauwerks als Inputwert für die Berechnung des Wiederbeschaffungswerts. / Valeur de remplacement du type de construction';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN status  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure.status IS 'Operating and planning status of the structure / Betriebs- bzw. Planungszustand des Bauwerks / Etat de fonctionnement et de planification de l’ouvrage';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN structure_condition  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure.structure_condition IS 'yyy_Zustandsklassen. Beschreibung des baulichen Zustands des Kanals. Nicht zu verwechseln mit den Sanierungsstufen, welche die Prioritäten der Massnahmen bezeichnen (Attribut Sanierungsbedarf). / Zustandsklassen 0 bis 4 gemäss VSA-Richtline "Erhaltung von Kanalisationen". Beschreibung des baulichen Zustands des Abwasserbauwerks. Nicht zu verwechseln mit den Sanierungsstufen, welche die Prioritäten der Massnahmen bezeichnen (Attribut Sanierungsbedarf). / Classes d''état. Description de l''état constructif selon la directive VSA "Maintien des canalisations" (2007/2009). Ne pas confondre avec les degrés de remise en état (attribut NECESSITE_ASSAINIR)';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN subsidies  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.wastewater_structure.subsidies IS 'yyy_Staats- und Bundesbeiträge / Staats- und Bundesbeiträge / Contributions des cantons et de la Confédération';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN year_of_construction  smallint ;
COMMENT ON COLUMN qgep_od.wastewater_structure.year_of_construction IS 'yyy_Jahr der Inbetriebsetzung (Schlussabnahme). Falls unbekannt = 1800 setzen (tiefster Wert des Wertebereiches) / Jahr der Inbetriebsetzung (Schlussabnahme). Falls unbekannt = 1800 setzen (tiefster Wert des Wertebereichs) / Année de mise en service (réception finale)';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.wastewater_structure.year_of_replacement IS 'yyy_Jahr, in dem die Lebensdauer des Bauwerks voraussichtlich abläuft / Jahr, in dem die Lebensdauer des Bauwerks voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''ouvrage soit écoulée';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.wastewater_structure.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.wastewater_structure.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.wastewater_structure.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wastewater_structure
BEFORE UPDATE OR INSERT ON
 qgep_od.wastewater_structure
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.channel
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_channel_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_channel_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.channel ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','channel');
COMMENT ON COLUMN qgep_od.channel.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.channel ADD COLUMN bedding_encasement  integer ;
COMMENT ON COLUMN qgep_od.channel.bedding_encasement IS 'yyy_Art und Weise der unmittelbaren Rohrumgebung im Boden: Bettungsschicht (Unterlage der Leitung),  Verdämmung (seitliche Auffüllung), Schutzschicht / Art und Weise der unmittelbaren Rohrumgebung im Boden: Bettungsschicht (Unterlage der Leitung),  Verdämmung (seitliche Auffüllung), Schutzschicht / Lit de pose (assise de la conduite), bourrage latéral (remblai latéral), couche de protection';
ALTER TABLE qgep_od.channel ADD COLUMN connection_type  integer ;
COMMENT ON COLUMN qgep_od.channel.connection_type IS 'Types of connection / Verbindungstypen / Types de raccordement';
ALTER TABLE qgep_od.channel ADD COLUMN function_hierarchic  integer ;
COMMENT ON COLUMN qgep_od.channel.function_hierarchic IS 'yyy_Art des Kanals hinsichtlich Bedeutung im Entwässerungssystem / Art des Kanals hinsichtlich Bedeutung im Entwässerungssystem / Genre de canalisation par rapport à sa fonction dans le système d''évacuation';
-- see end of table CREATE INDEX in_od_channel_function_hierarchic_usage_current ON qgep_od.channel USING btree (function_hierarchic, usage_current);
ALTER TABLE qgep_od.channel ADD COLUMN function_hydraulic  integer ;
COMMENT ON COLUMN qgep_od.channel.function_hydraulic IS 'yyy_Art des Kanals hinsichtlich hydraulischer Ausführung / Art des Kanals hinsichtlich hydraulischer Ausführung / Genre de canalisation par rapport à sa fonction hydraulique';
ALTER TABLE qgep_od.channel ADD COLUMN jetting_interval  decimal(4,2) ;
COMMENT ON COLUMN qgep_od.channel.jetting_interval IS 'yyy_Abstände in welchen der Kanal gespült werden sollte / Abstände in welchen der Kanal gespült werden sollte / Fréquence à laquelle une canalisation devrait subir un curage (années)';
ALTER TABLE qgep_od.channel ADD COLUMN pipe_length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.channel.pipe_length IS 'yyy_Baulänge der Einzelrohre oder Fugenabstände bei Ortsbetonkanälen / Baulänge der Einzelrohre oder Fugenabstände bei Ortsbetonkanälen / Longueur de chaque tuyau ou distance des joints pour les canalisations en béton coulé sur place';
ALTER TABLE qgep_od.channel ADD COLUMN usage_current  integer ;
COMMENT ON COLUMN qgep_od.channel.usage_current IS 'yyy_Für Primäre Abwasseranlagen gilt: heute zulässige Nutzung. Für Sekundäre Abwasseranlagen gilt: heute tatsächliche Nutzung / Für primäre Abwasseranlagen gilt: Heute zulässige Nutzung. Für sekundäre Abwasseranlagen gilt: Heute tatsächliche Nutzung / Pour les ouvrages du réseau primaire: utilisation actuelle autorisée pour les ouvrages du réseau secondaire: utilisation actuelle réelle';
ALTER TABLE qgep_od.channel ADD COLUMN usage_planned  integer ;
COMMENT ON COLUMN qgep_od.channel.usage_planned IS 'yyy_Durch das Konzept vorgesehene Nutzung (vergleiche auch Nutzungsart_Ist) / Durch das Konzept vorgesehene Nutzung (vergleiche auch Nutzungsart_Ist) / Utilisation prévue par le concept d''assainissement (voir aussi GENRE_UTILISATION_ACTUELLE)';
 CREATE INDEX in_od_channel_function_hierarchic_usage_current ON qgep_od.channel USING btree (function_hierarchic, usage_current);
-------
CREATE TRIGGER
update_last_modified_channel
BEFORE UPDATE OR INSERT ON
 qgep_od.channel
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_structure");

-------
-------
CREATE TABLE qgep_od.manhole
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_manhole_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_manhole_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.manhole ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','manhole');
COMMENT ON COLUMN qgep_od.manhole.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.manhole ADD COLUMN depth  smallint ;
COMMENT ON COLUMN qgep_od.manhole.depth IS 'yyy_Funktion (berechneter Wert) = zugehöriger Abwasserknoten.Sohlenkote minus Deckel.Kote (falls Sohlenkote nicht separat erfasst, dann ist es die tiefer liegende Haltungspunkt.Kote). Siehe auch SIA 405 2015 4.3.4. / Funktion (berechneter Wert) = zugehöriger Abwasserknoten.Sohlenkote minus Deckel.Kote (falls Sohlenkote nicht separat erfasst, dann ist es die tiefer liegende Haltungspunkt.Kote). Siehe auch SIA 405 2015 4.3.4. / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER correspondant moins COUVERCLE.COTE (si le radier n’est pas saisi séparément, c’est la POINT_TRONCON.COTE le plus bas). Cf. SIA 405 cahier technique 2015 4.3.4.';
ALTER TABLE qgep_od.manhole ADD COLUMN dimension1  smallint ;
COMMENT ON COLUMN qgep_od.manhole.dimension1 IS 'Dimension2 of infiltration installations (largest inside dimension). / Dimension1 des Schachtes (grösstes Innenmass). / Dimension1 de la chambre (plus grande mesure intérieure).';
ALTER TABLE qgep_od.manhole ADD COLUMN dimension2  smallint ;
COMMENT ON COLUMN qgep_od.manhole.dimension2 IS 'Dimension2 of manhole (smallest inside dimension). With circle shaped manholes leave dimension2 empty, with ovoid manholes fill it in. With rectangular shaped manholes use detailled_geometry to describe further. / Dimension2 des Schachtes (kleinstes Innenmass). Bei runden Schächten wird Dimension2 leer gelassen, bei ovalen abgefüllt. Für eckige Schächte Detailgeometrie verwenden. / Dimension2 de la chambre (plus petite mesure intérieure)';
ALTER TABLE qgep_od.manhole ADD COLUMN function  integer ;
COMMENT ON COLUMN qgep_od.manhole.function IS 'Kind of function / Art der Nutzung / Genre d''utilisation';
 CREATE INDEX in_od_manhole_function ON qgep_od.manhole USING btree (function);
ALTER TABLE qgep_od.manhole ADD COLUMN material  integer ;
COMMENT ON COLUMN qgep_od.manhole.material IS 'yyy_Hauptmaterial aus dem das Bauwerk besteht zur groben Klassifizierung. / Hauptmaterial aus dem das Bauwerk besteht zur groben Klassifizierung. / Matériau dont est construit l''ouvrage, pour une classification sommaire';
ALTER TABLE qgep_od.manhole ADD COLUMN surface_inflow  integer ;
COMMENT ON COLUMN qgep_od.manhole.surface_inflow IS 'yyy_Zuflussmöglichkeit  von Oberflächenwasser direkt in den Schacht / Zuflussmöglichkeit  von Oberflächenwasser direkt in den Schacht / Arrivée directe d''eaux superficielles dans la chambre';
-------
CREATE TRIGGER
update_last_modified_manhole
BEFORE UPDATE OR INSERT ON
 qgep_od.manhole
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_structure");

-------
-------
CREATE TABLE qgep_od.discharge_point
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_discharge_point_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_discharge_point_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.discharge_point ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','discharge_point');
COMMENT ON COLUMN qgep_od.discharge_point.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.discharge_point ADD COLUMN depth  smallint ;
COMMENT ON COLUMN qgep_od.discharge_point.depth IS 'yyy_Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';
ALTER TABLE qgep_od.discharge_point ADD COLUMN highwater_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.discharge_point.highwater_level IS 'yyy_Massgebliche Hochwasserkote der Einleitstelle. Diese ist in der Regel grösser als der Wasserspiegel_Hydraulik. / Massgebliche Hochwasserkote der Einleitstelle. Diese ist in der Regel grösser als der Wasserspiegel_Hydraulik. / Cote de crue déterminante au point de rejet. Diese ist in der Regel grösser als der Wasserspiegel_Hydraulik.';
ALTER TABLE qgep_od.discharge_point ADD COLUMN relevance  integer ;
COMMENT ON COLUMN qgep_od.discharge_point.relevance IS 'Relevance of discharge point for water course / Gewässerrelevanz der Einleitstelle / Il est conseillé d’utiliser des noms réels, tels qSignifiance pour milieu récepteur';
ALTER TABLE qgep_od.discharge_point ADD COLUMN terrain_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.discharge_point.terrain_level IS 'Terrain level if there is no cover at the discharge point (structure), e.g. just pipe ending / Terrainkote, falls kein Deckel vorhanden bei Einleitstelle (Kanalende ohne Bauwerk oder Bauwerk ohne Deckel) / Cote terrain s''il n''y a pas de couvercle à l''exutoire par example seulement fin du conduite';
ALTER TABLE qgep_od.discharge_point ADD COLUMN upper_elevation  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.discharge_point.upper_elevation IS 'Highest point of structure (ceiling), outside / Höchster Punkt des Bauwerks (Decke), aussen / Point le plus élevé de l''ouvrage';
ALTER TABLE qgep_od.discharge_point ADD COLUMN waterlevel_hydraulic  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.discharge_point.waterlevel_hydraulic IS 'yyy_Wasserspiegelkote für die hydraulische Berechnung (IST-Zustand). Berechneter Wasserspiegel bei der Einleitstelle. Wo nichts anders gefordert, ist der Wasserspiegel bei einem HQ30 einzusetzen. / Wasserspiegelkote für die hydraulische Berechnung (IST-Zustand). Berechneter Wasserspiegel bei der Einleitstelle. Wo nichts anders gefordert, ist der Wasserspiegel bei einem HQ30 einzusetzen. / Niveau d’eau calculé à l’exutoire. Si aucun exigence est demandée, indiquer le niveau d’eau pour un HQ30.';
-------
CREATE TRIGGER
update_last_modified_discharge_point
BEFORE UPDATE OR INSERT ON
 qgep_od.discharge_point
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_structure");

-------
-------
CREATE TABLE qgep_od.special_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_special_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_special_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.special_structure ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','special_structure');
COMMENT ON COLUMN qgep_od.special_structure.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.special_structure ADD COLUMN bypass  integer ;
COMMENT ON COLUMN qgep_od.special_structure.bypass IS 'yyy_Bypass zur Umleitung des Wassers (z.B. während Unterhalt oder  im Havariefall) / Bypass zur Umleitung des Wassers (z.B. während Unterhalt oder  im Havariefall) / Bypass pour détourner les eaux (par exemple durant des opérations de maintenance ou en cas d’avaries)';
ALTER TABLE qgep_od.special_structure ADD COLUMN depth  smallint ;
COMMENT ON COLUMN qgep_od.special_structure.depth IS 'yyy_Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';
ALTER TABLE qgep_od.special_structure ADD COLUMN emergency_spillway  integer ;
COMMENT ON COLUMN qgep_od.special_structure.emergency_spillway IS 'zzz_Das Attribut beschreibt, wohin die das Volumen übersteigende Menge abgeleitet wird (bei Regenrückhaltebecken / Regenrückhaltekanal). / Das Attribut beschreibt, wohin die das Volumen übersteigende Menge abgeleitet wird (bei Regenrückhaltebecken / Regenrückhaltekanal). / L’attribut décrit vers où le débit déversé s’écoule. (bassin d’accumulation / canal d’accumulation)';
ALTER TABLE qgep_od.special_structure ADD COLUMN function  integer ;
COMMENT ON COLUMN qgep_od.special_structure.function IS 'Kind of function / Art der Nutzung / Genre d''utilisation';
 CREATE INDEX in_od_special_structure_function ON qgep_od.special_structure USING btree (function);
ALTER TABLE qgep_od.special_structure ADD COLUMN stormwater_tank_arrangement  integer ;
COMMENT ON COLUMN qgep_od.special_structure.stormwater_tank_arrangement IS 'yyy_Anordnung des Regenbeckens im System. Zusätzlich zu erfassen falls Spezialbauwerk.Funktion = Regenbecken_* / Anordnung des Regenbeckens im System. Zusätzlich zu erfassen falls Spezialbauwerk.Funktion = Regenbecken_* / Disposition d''un bassin d''eaux pluviales dans le réseau d''assainissement. Attribut additionnel pour les valeurs BEP_* de OUVRAGE_SPECIAL.FONCTION.';
ALTER TABLE qgep_od.special_structure ADD COLUMN upper_elevation  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.special_structure.upper_elevation IS 'Highest point of structure (ceiling), outside / Höchster Punkt des Bauwerks (Decke), aussen / Point le plus élevé de la construction';
-------
CREATE TRIGGER
update_last_modified_special_structure
BEFORE UPDATE OR INSERT ON
 qgep_od.special_structure
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_structure");

-------
-------
CREATE TABLE qgep_od.infiltration_installation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_infiltration_installation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_infiltration_installation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.infiltration_installation ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','infiltration_installation');
COMMENT ON COLUMN qgep_od.infiltration_installation.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN absorption_capacity  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.infiltration_installation.absorption_capacity IS 'yyy_Schluckvermögen des Bodens. / Schluckvermögen des Bodens. / Capacité d''absorption du sol';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN defects  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.defects IS 'yyy_Gibt die aktuellen Mängel der Versickerungsanlage an (IST-Zustand). / Gibt die aktuellen Mängel der Versickerungsanlage an (IST-Zustand). / Indique les défauts actuels de l''installation d''infiltration (etat_actuel).';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN depth  smallint ;
COMMENT ON COLUMN qgep_od.infiltration_installation.depth IS 'yyy_Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN dimension1  smallint ;
COMMENT ON COLUMN qgep_od.infiltration_installation.dimension1 IS 'Dimension1 of infiltration installations (largest inside dimension) if used with norm elements. Else leave empty.. / Dimension1 der Versickerungsanlage (grösstes Innenmass) bei der Verwendung von Normbauteilen. Sonst leer lassen und mit Detailgeometrie beschreiben. / Dimension1 de l’installation d’infiltration (plus grande mesure intérieure) lorsqu’elle est utilisée pour des éléments d’ouvrage normés. Sinon, à laisser libre et prendre la description de la géométrie détaillée.';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN dimension2  smallint ;
COMMENT ON COLUMN qgep_od.infiltration_installation.dimension2 IS 'Dimension2 of infiltration installations (smallest inside dimension). With circle shaped installations leave dimension2 empty, with ovoid shaped ones fill it in. With rectangular shaped manholes use detailled_geometry to describe further. / Dimension2 der Versickerungsanlage (kleinstes Innenmass) bei der Verwendung von Normbauteilen. Sonst leer lassen und mit Detailgeometrie beschreiben. / Dimension2 de la chambre (plus petite mesure intérieure). La dimension2 est à saisir pour des chambres ovales et à laisser libre pour des chambres circulaires. Pour les chambres rectangulaires il faut utiliser la géométrie détaillée.';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN distance_to_aquifer  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.infiltration_installation.distance_to_aquifer IS 'yyy_Flurabstand (Vertikale Distanz Terrainoberfläche zum Grundwasserleiter). / Flurabstand (Vertikale Distanz Terrainoberfläche zum Grundwasserleiter). / Distance à l''aquifère (distance verticale de la surface du terrain à l''aquifère)';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN effective_area  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.infiltration_installation.effective_area IS 'yyy_Für den Abfluss wirksame Fläche / Für den Abfluss wirksame Fläche / Surface qui participe à l''écoulement';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN emergency_spillway  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.emergency_spillway IS 'yyy_Endpunkt allfälliger Verrohrung des Notüberlaufes der Versickerungsanlage / Endpunkt allfälliger Verrohrung des Notüberlaufes der Versickerungsanlage / Point cumulant des conduites du trop plein d''une installation d''infiltration';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.kind IS 'yyy_Arten von Versickerungsmethoden. / Arten von Versickerungsmethoden. / Genre de méthode d''infiltration.';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN labeling  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.labeling IS 'yyy_Kennzeichnung der Schachtdeckel der Anlage als Versickerungsanlage.  Nur bei Anlagen mit Schächten. / Kennzeichnung der Schachtdeckel der Anlage als Versickerungsanlage.  Nur bei Anlagen mit Schächten. / Désignation inscrite du couvercle de l''installation d''infiltration. Uniquement pour des installations avec couvercle';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN seepage_utilization  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.seepage_utilization IS 'yyy_Arten des zu versickernden Wassers. / Arten des zu versickernden Wassers. / Genre d''eau à infiltrer';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN upper_elevation  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.infiltration_installation.upper_elevation IS 'Highest point of structure (ceiling), outside / Höchster Punkt des Bauwerks (Decke), aussen / Point le plus élevé de la construction';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN vehicle_access  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.vehicle_access IS 'yyy_Zugänglichkeit für Saugwagen. Sie bezieht sich auf die gesamte Versickerungsanlage / Vorbehandlungsanlagen und kann in den Bemerkungen weiter spezifiziert werden / Zugänglichkeit für Saugwagen. Sie bezieht sich auf die gesamte Versickerungsanlage / Vorbehandlungsanlagen und kann in den Bemerkungen weiter spezifiziert werden / Accessibilité pour des camions de vidange. Se réfère à toute l''installation d''infiltration / de prétraitement et peut être spécifiée sous REMARQUE';
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN watertightness  integer ;
COMMENT ON COLUMN qgep_od.infiltration_installation.watertightness IS 'yyy_Wasserdichtheit gegen Oberflächenwasser.  Nur bei Anlagen mit Schächten. / Wasserdichtheit gegen Oberflächenwasser.  Nur bei Anlagen mit Schächten. / Etanchéité contre des eaux superficielles. Uniquement pour des installations avec chambres';
-------
CREATE TRIGGER
update_last_modified_infiltration_installation
BEFORE UPDATE OR INSERT ON
 qgep_od.infiltration_installation
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_structure");

-------
-------
CREATE TABLE qgep_od.wwtp_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wwtp_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wwtp_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wwtp_structure ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wwtp_structure');
COMMENT ON COLUMN qgep_od.wwtp_structure.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wwtp_structure ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.wwtp_structure.kind IS 'yyy_Art des Beckens oder Verfahrens im ARA Bauwerk / Art des Beckens oder Verfahrens im ARA Bauwerk / Genre de l''l’ouvrage ou genre de traitement dans l''ouvrage STEP';
-------
CREATE TRIGGER
update_last_modified_wwtp_structure
BEFORE UPDATE OR INSERT ON
 qgep_od.wwtp_structure
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_structure");

-------
-------
CREATE TABLE qgep_od.maintenance_event
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_maintenance_event_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_maintenance_event_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.maintenance_event ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','maintenance_event');
COMMENT ON COLUMN qgep_od.maintenance_event.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN base_data text;
COMMENT ON COLUMN qgep_od.maintenance_event.base_data IS 'e.g. damage protocol / Z.B. Schadensprotokoll / par ex. protocole de dommages';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN cost  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.maintenance_event.cost IS '';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN data_details  varchar(50) ;
COMMENT ON COLUMN qgep_od.maintenance_event.data_details IS 'yyy_Ort, wo sich weitere Detailinformationen zum Ereignis finden (z.B. Nr. eines Videobandes) / Ort, wo sich weitere Detailinformationen zum Ereignis finden (z.B. Nr. eines Videobandes) / Lieu où se trouvent les données détaillées (par ex. n° d''une bande vidéo)';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN duration  smallint ;
COMMENT ON COLUMN qgep_od.maintenance_event.duration IS 'Duration of event in days / Dauer des Ereignisses in Tagen / Durée de l''événement en jours';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN identifier  varchar(41) ;
COMMENT ON COLUMN qgep_od.maintenance_event.identifier IS '';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.maintenance_event.kind IS 'Type of event / Art des Ereignisses / Genre d''événement';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN operator  varchar(50) ;
COMMENT ON COLUMN qgep_od.maintenance_event.operator IS 'Operator of operating company or administration / Sachbearbeiter Firma oder Verwaltung (kann auch Operateur sein bei Untersuchung) / Responsable de saisie du bureau';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN reason  varchar(50) ;
COMMENT ON COLUMN qgep_od.maintenance_event.reason IS 'Reason for this event / Ursache für das Ereignis / Cause de l''événement';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.maintenance_event.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN result  varchar(255) ;
COMMENT ON COLUMN qgep_od.maintenance_event.result IS 'Result or important comments for this event / Resultat oder wichtige Bemerkungen aus Sicht des Bearbeiters / Résultat ou commentaire importante de l''événement';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN status  integer ;
COMMENT ON COLUMN qgep_od.maintenance_event.status IS 'Disposition state of the maintenance event / Phase in der sich das Erhaltungsereignis befindet / Phase dans laquelle se trouve l''événement de maintenance';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN time_point  timestamp without time zone ;
COMMENT ON COLUMN qgep_od.maintenance_event.time_point IS 'Date and time of the event / Zeitpunkt des Ereignisses / Date et heure de l''événement';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.maintenance_event.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.maintenance_event.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.maintenance_event ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.maintenance_event.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_maintenance_event
BEFORE UPDATE OR INSERT ON
 qgep_od.maintenance_event
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.zone ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','zone');
COMMENT ON COLUMN qgep_od.zone.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.zone ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.zone.identifier IS '';
ALTER TABLE qgep_od.zone ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.zone.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.zone ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.zone.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.zone ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.zone.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.zone ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.zone.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_zone
BEFORE UPDATE OR INSERT ON
 qgep_od.zone
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.planning_zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_planning_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_planning_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.planning_zone ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','planning_zone');
COMMENT ON COLUMN qgep_od.planning_zone.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.planning_zone ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.planning_zone.kind IS 'Type of planning zone / Art der Bauzone / Genre de zones à bâtir';
ALTER TABLE qgep_od.planning_zone ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_planning_zone_perimeter_geometry ON qgep_od.planning_zone USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.planning_zone.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_planning_zone
BEFORE UPDATE OR INSERT ON
 qgep_od.planning_zone
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------
-------
CREATE TABLE qgep_od.infiltration_zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_infiltration_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_infiltration_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.infiltration_zone ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','infiltration_zone');
COMMENT ON COLUMN qgep_od.infiltration_zone.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.infiltration_zone ADD COLUMN infiltration_capacity  integer ;
COMMENT ON COLUMN qgep_od.infiltration_zone.infiltration_capacity IS 'yyy_Versickerungsmöglichkeit im Bereich / Versickerungsmöglichkeit im Bereich / Potentiel d''infiltration de la zone';
ALTER TABLE qgep_od.infiltration_zone ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_infiltration_zone_perimeter_geometry ON qgep_od.infiltration_zone USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.infiltration_zone.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_infiltration_zone
BEFORE UPDATE OR INSERT ON
 qgep_od.infiltration_zone
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------
-------
CREATE TABLE qgep_od.drainage_system
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_drainage_system_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_drainage_system_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.drainage_system ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','drainage_system');
COMMENT ON COLUMN qgep_od.drainage_system.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.drainage_system ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.drainage_system.kind IS 'yyy_Art des Entwässerungssystems in dem ein bestimmtes Gebiet entwässert werden soll (SOLL Zustand) / Art des Entwässerungssystems in dem ein bestimmtes Gebiet entwässert werden soll (SOLL Zustand) / Genre de système d''évacuation choisi pour une région déterminée (Etat prévu)';
ALTER TABLE qgep_od.drainage_system ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_drainage_system_perimeter_geometry ON qgep_od.drainage_system USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.drainage_system.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_drainage_system
BEFORE UPDATE OR INSERT ON
 qgep_od.drainage_system
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------
-------
CREATE TABLE qgep_od.water_body_protection_sector
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_water_body_protection_sector_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_water_body_protection_sector_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.water_body_protection_sector ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','water_body_protection_sector');
COMMENT ON COLUMN qgep_od.water_body_protection_sector.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.water_body_protection_sector ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.water_body_protection_sector.kind IS 'yyy_Art des Schutzbereiches für  oberflächliches Gewässer und Grundwasser bezüglich Gefährdung / Art des Schutzbereiches für  oberflächliches Gewässer und Grundwasser bezüglich Gefährdung / Type de zones de protection des eaux superficielles et souterraines';
ALTER TABLE qgep_od.water_body_protection_sector ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_water_body_protection_sector_perimeter_geometry ON qgep_od.water_body_protection_sector USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.water_body_protection_sector.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_water_body_protection_sector
BEFORE UPDATE OR INSERT ON
 qgep_od.water_body_protection_sector
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------
-------
CREATE TABLE qgep_od.ground_water_protection_perimeter
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_ground_water_protection_perimeter_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_ground_water_protection_perimeter_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.ground_water_protection_perimeter ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','ground_water_protection_perimeter');
COMMENT ON COLUMN qgep_od.ground_water_protection_perimeter.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.ground_water_protection_perimeter ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_ground_water_protection_perimeter_perimeter_geometry ON qgep_od.ground_water_protection_perimeter USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.ground_water_protection_perimeter.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_ground_water_protection_perimeter
BEFORE UPDATE OR INSERT ON
 qgep_od.ground_water_protection_perimeter
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------
-------
CREATE TABLE qgep_od.groundwater_protection_zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_groundwater_protection_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_groundwater_protection_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.groundwater_protection_zone ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','groundwater_protection_zone');
COMMENT ON COLUMN qgep_od.groundwater_protection_zone.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.groundwater_protection_zone ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.groundwater_protection_zone.kind IS 'yyy_Zonenarten. Grundwasserschutzzonen bestehen aus dem Fassungsbereich (Zone S1), der Engeren Schutzzone (Zone S2) und der Weiteren Schutzzone (Zone S3). / Zonenarten. Grundwasserschutzzonen bestehen aus dem Fassungsbereich (Zone S1), der Engeren Schutzzone (Zone S2) und der Weiteren Schutzzone (Zone S3). / Genre de zones';
ALTER TABLE qgep_od.groundwater_protection_zone ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_groundwater_protection_zone_perimeter_geometry ON qgep_od.groundwater_protection_zone USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.groundwater_protection_zone.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_groundwater_protection_zone
BEFORE UPDATE OR INSERT ON
 qgep_od.groundwater_protection_zone
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.zone");

-------
-------
CREATE TABLE qgep_od.pipe_profile
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_pipe_profile_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_pipe_profile_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.pipe_profile ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','pipe_profile');
COMMENT ON COLUMN qgep_od.pipe_profile.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN height_width_ratio  decimal(5,2) ;
COMMENT ON COLUMN qgep_od.pipe_profile.height_width_ratio IS 'height-width ratio / Verhältnis der Höhe zur Breite / Rapport entre la hauteur et la largeur';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.pipe_profile.identifier IS '';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN profile_type  integer ;
COMMENT ON COLUMN qgep_od.pipe_profile.profile_type IS 'Type of profile / Typ des Profils / Type du profil';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.pipe_profile.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.pipe_profile.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.pipe_profile.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.pipe_profile ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.pipe_profile.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_pipe_profile
BEFORE UPDATE OR INSERT ON
 qgep_od.pipe_profile
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.wwtp_energy_use
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wwtp_energy_use_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wwtp_energy_use_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wwtp_energy_use ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wwtp_energy_use');
COMMENT ON COLUMN qgep_od.wwtp_energy_use.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN gas_motor  integer ;
COMMENT ON COLUMN qgep_od.wwtp_energy_use.gas_motor IS 'electric power / elektrische Leistung / Puissance électrique';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN heat_pump  integer ;
COMMENT ON COLUMN qgep_od.wwtp_energy_use.heat_pump IS 'Energy production based on the heat production on the WWTP / Energienutzung aufgrund des Wärmeanfalls auf der ARA / Utilisation de l''énergie thermique de la STEP';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.wwtp_energy_use.identifier IS '';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.wwtp_energy_use.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN turbining  integer ;
COMMENT ON COLUMN qgep_od.wwtp_energy_use.turbining IS 'Energy production based on the (bio)gaz production on the WWTP / Energienutzung aufgrund des Gasanfalls auf der ARA / Production d''énergie issue de la production de gaz de la STEP';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.wwtp_energy_use.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.wwtp_energy_use.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.wwtp_energy_use.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wwtp_energy_use
BEFORE UPDATE OR INSERT ON
 qgep_od.wwtp_energy_use
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.waste_water_treatment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_waste_water_treatment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_waste_water_treatment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.waste_water_treatment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','waste_water_treatment');
COMMENT ON COLUMN qgep_od.waste_water_treatment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment.identifier IS '';
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.waste_water_treatment.kind IS 'Type of wastewater  treatment / Verfahren für die Abwasserbehandlung / Genre de traitement des eaux usées';
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.waste_water_treatment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.waste_water_treatment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.waste_water_treatment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.waste_water_treatment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_waste_water_treatment
BEFORE UPDATE OR INSERT ON
 qgep_od.waste_water_treatment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.sludge_treatment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_sludge_treatment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_sludge_treatment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.sludge_treatment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','sludge_treatment');
COMMENT ON COLUMN qgep_od.sludge_treatment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN composting  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.composting IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN dehydration  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.dehydration IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN digested_sludge_combustion  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.digested_sludge_combustion IS 'yyy_Dimensioning value der Verbrennungsanlage / Dimensionierungswert der Verbrennungsanlage / Valeur de dimensionnement de l''installation d''incinération';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN drying  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.drying IS 'yyy_Leistung thermische Trocknung / Leistung thermische Trocknung / Puissance du séchage thermique';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN fresh_sludge_combustion  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.fresh_sludge_combustion IS 'yyy_Dimensioning value der Verbrennungsanlage / Dimensionierungswert der Verbrennungsanlage / Valeur de dimensionnement de l''installation d''incinération';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN hygenisation  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.hygenisation IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.identifier IS '';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN predensification_of_excess_sludge  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.predensification_of_excess_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN predensification_of_mixed_sludge  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.predensification_of_mixed_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN predensification_of_primary_sludge  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.predensification_of_primary_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN stabilisation  integer ;
COMMENT ON COLUMN qgep_od.sludge_treatment.stabilisation IS 'yyy_Art der Schlammstabilisierung / Art der Schlammstabilisierung / Type de stabilisation des boues';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN stacking_of_dehydrated_sludge  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.stacking_of_dehydrated_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN stacking_of_liquid_sludge  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.sludge_treatment.stacking_of_liquid_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.sludge_treatment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.sludge_treatment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.sludge_treatment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_sludge_treatment
BEFORE UPDATE OR INSERT ON
 qgep_od.sludge_treatment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.control_center
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_control_center_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_control_center_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.control_center ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','control_center');
COMMENT ON COLUMN qgep_od.control_center.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.control_center ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.control_center.identifier IS '';
ALTER TABLE qgep_od.control_center ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_control_center_situation_geometry ON qgep_od.control_center USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.control_center.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.control_center ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.control_center.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.control_center ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.control_center.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.control_center ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.control_center.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_control_center
BEFORE UPDATE OR INSERT ON
 qgep_od.control_center
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.water_control_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_water_control_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_water_control_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.water_control_structure ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','water_control_structure');
COMMENT ON COLUMN qgep_od.water_control_structure.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.water_control_structure ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.water_control_structure.identifier IS '';
ALTER TABLE qgep_od.water_control_structure ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.water_control_structure.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.water_control_structure ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_water_control_structure_situation_geometry ON qgep_od.water_control_structure USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.water_control_structure.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.water_control_structure ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.water_control_structure.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.water_control_structure ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.water_control_structure.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.water_control_structure ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.water_control_structure.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_water_control_structure
BEFORE UPDATE OR INSERT ON
 qgep_od.water_control_structure
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.ford
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_ford_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_ford_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.ford ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','ford');
COMMENT ON COLUMN qgep_od.ford.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
-------
CREATE TRIGGER
update_last_modified_ford
BEFORE UPDATE OR INSERT ON
 qgep_od.ford
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.chute
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_chute_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_chute_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.chute ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','chute');
COMMENT ON COLUMN qgep_od.chute.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.chute ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.chute.kind IS 'Type of chute / Art des Absturzes / Type de seuil';
ALTER TABLE qgep_od.chute ADD COLUMN material  integer ;
COMMENT ON COLUMN qgep_od.chute.material IS 'Construction material of chute / Material aus welchem der Absturz besteht / Matériau de construction du seuil';
ALTER TABLE qgep_od.chute ADD COLUMN vertical_drop  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.chute.vertical_drop IS 'Vertical difference of water level before and after chute / Differenz des Wasserspiegels vor und nach dem Absturz / Différence de la hauteur du plan d''eau avant et après la chute';
-------
CREATE TRIGGER
update_last_modified_chute
BEFORE UPDATE OR INSERT ON
 qgep_od.chute
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.lock
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_lock_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_lock_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.lock ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','lock');
COMMENT ON COLUMN qgep_od.lock.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.lock ADD COLUMN vertical_drop  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.lock.vertical_drop IS 'yyy_Vertical difference of water level before and after Schleuse / Differenz im Wasserspiegel oberhalb und unterhalb der Schleuse / Différence des plans d''eau entre l''amont et l''aval de l''écluse';
-------
CREATE TRIGGER
update_last_modified_lock
BEFORE UPDATE OR INSERT ON
 qgep_od.lock
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.passage
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_passage_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_passage_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.passage ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','passage');
COMMENT ON COLUMN qgep_od.passage.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
-------
CREATE TRIGGER
update_last_modified_passage
BEFORE UPDATE OR INSERT ON
 qgep_od.passage
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.blocking_debris
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_blocking_debris_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_blocking_debris_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.blocking_debris ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','blocking_debris');
COMMENT ON COLUMN qgep_od.blocking_debris.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.blocking_debris ADD COLUMN vertical_drop  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.blocking_debris.vertical_drop IS 'yyy_Vertical difference of water level before and after Sperre / Differenz des Wasserspiegels vor und nach der Sperre / Différence de la hauteur du plan d''eau avant et après le barrage';
-------
CREATE TRIGGER
update_last_modified_blocking_debris
BEFORE UPDATE OR INSERT ON
 qgep_od.blocking_debris
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.dam
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_dam_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_dam_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.dam ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','dam');
COMMENT ON COLUMN qgep_od.dam.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.dam ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.dam.kind IS 'Type of dam or weir / Art des Wehres / Genre d''ouvrage de retenue';
ALTER TABLE qgep_od.dam ADD COLUMN vertical_drop  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.dam.vertical_drop IS 'Vertical difference of water level before and after chute / Differenz des Wasserspiegels vor und nach dem Absturz / Différence de la hauteur du plan d''eau avant et après la chute';
-------
CREATE TRIGGER
update_last_modified_dam
BEFORE UPDATE OR INSERT ON
 qgep_od.dam
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.rock_ramp
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_rock_ramp_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_rock_ramp_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.rock_ramp ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','rock_ramp');
COMMENT ON COLUMN qgep_od.rock_ramp.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.rock_ramp ADD COLUMN stabilisation  integer ;
COMMENT ON COLUMN qgep_od.rock_ramp.stabilisation IS 'Type of stabilisation of rock ramp / Befestigungsart der Sohlrampe / Genre de consolidation de la rampe';
ALTER TABLE qgep_od.rock_ramp ADD COLUMN vertical_drop  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.rock_ramp.vertical_drop IS 'Vertical difference of water level before and after chute / Differenz des Wasserspiegels vor und nach dem Absturz / Différence de la hauteur du plan d''eau avant et après la chute';
-------
CREATE TRIGGER
update_last_modified_rock_ramp
BEFORE UPDATE OR INSERT ON
 qgep_od.rock_ramp
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.water_control_structure");

-------
-------
CREATE TABLE qgep_od.fish_pass
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_fish_pass_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_fish_pass_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.fish_pass ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','fish_pass');
COMMENT ON COLUMN qgep_od.fish_pass.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.fish_pass ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.fish_pass.identifier IS '';
ALTER TABLE qgep_od.fish_pass ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.fish_pass.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.fish_pass ADD COLUMN vertical_drop  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.fish_pass.vertical_drop IS 'Vertical difference of water level before and after fishpass / Differenz des Wasserspiegels vor und nach dem Fischpass / Différence de la hauteur du plan d''eau avant et après l''échelle à poisson';
ALTER TABLE qgep_od.fish_pass ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.fish_pass.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.fish_pass ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.fish_pass.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.fish_pass ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.fish_pass.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_fish_pass
BEFORE UPDATE OR INSERT ON
 qgep_od.fish_pass
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.bathing_area
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_bathing_area_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_bathing_area_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.bathing_area ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','bathing_area');
COMMENT ON COLUMN qgep_od.bathing_area.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.bathing_area ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.bathing_area.identifier IS '';
ALTER TABLE qgep_od.bathing_area ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.bathing_area.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.bathing_area ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_bathing_area_situation_geometry ON qgep_od.bathing_area USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.bathing_area.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.bathing_area ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.bathing_area.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.bathing_area ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.bathing_area.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.bathing_area ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.bathing_area.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_bathing_area
BEFORE UPDATE OR INSERT ON
 qgep_od.bathing_area
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.hydr_geometry
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_hydr_geometry_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_hydr_geometry_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.hydr_geometry ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','hydr_geometry');
COMMENT ON COLUMN qgep_od.hydr_geometry.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.identifier IS '';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN storage_volume  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.storage_volume IS 'yyy_Speicherinhalt im Becken und im Zulauf zwischen Wehrkrone und dem Wasserspiegel bei Qan. Bei Regenbeckenüberlaufbecken im Nebenschluss ist der Stauraum beim vorgelagerten Trennbauwerk bzw. Regenüberlauf zu erfassen (vgl. Erläuterungen Inhalt_Fangteil reps. _Klaerteil). Bei Pumpen: Speicherinhalt im Zulaufkanal unter dem Wasserspiegel beim Einschalten der Pumpe (höchstes Einschaltniveau bei mehreren Pumpen) / Speicherinhalt im Becken und im Zulauf zwischen Wehrkrone und dem Wasserspiegel bei Qan. Bei Regenbeckenüberlaufbecken im Nebenschluss ist der Stauraum beim vorgelagerten Trennbauwerk bzw. Regenüberlauf zu erfassen (vgl. Erläuterungen Inhalt_Fangteil reps. _Klaerteil). Bei Pumpen: Speicherinhalt im Zulaufkanal unter dem Wasserspiegel beim Einschalten der Pumpe (höchstes Einschaltniveau bei mehreren Pumpen) / Volume de stockage dans un bassin et dans la canalisation d’amenée entre la crête et le niveau d’eau de Qdim (débit conservé). Lors de bassins d’eaux pluviales en connexion latérale, le volume de stockage est à saisir à l’ouvrage de répartition, resp. déversoir d’orage précédant (cf. explications volume utile clarification, resp. volume utile stockage). Pour les pompes, il s’agit du volume de stockage dans la canalisation d’amenée sous le niveau d’eau lorsque la pompe s’enclenche (niveau max d’enclenchement lorsqu’il y a plusieurs pompes). Pour les bassins d’eaux pluviales, à saisir uniquement en connexion directe.';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN usable_capacity_storage  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.usable_capacity_storage IS 'yyy_Inhalt der Kammer unterhalb der Wehrkrone ohne Stauraum im Zulaufkanal. Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs). / Inhalt der Kammer unterhalb der Wehrkrone ohne Stauraum im Zulaufkanal. Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs) / Volume de la chambre sous la crête, sans volume de stockage de la canalisation d’amenée. Ce dernier est saisi par l’attribut volume de stockage (lors de disposition en connexion directe ceci se fait dans la fiche technique de l’ouvrage principal, lors de connexion latérale, l’attribution se fait dans la fiche technique de l’ouvrage de répartition ou déversoir d’orage précédant).';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN usable_capacity_treatment  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.usable_capacity_treatment IS 'yyy_Inhalt der Kammer unterhalb der Wehrkrone inkl. Einlaufbereich, Auslaufbereich und Sedimentationsbereich, ohne Stauraum im Zulaufkanal.  Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs) / Inhalt der Kammer unterhalb der Wehrkrone inkl. Einlaufbereich, Auslaufbereich und Sedimentationsbereich, ohne Stauraum im Zulaufkanal. Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs) / Volume de la chambre sous la crête, incl. l’entrée, la sortie et la partie de sédimentation, sans volume de stockage de la canalisation d’amenée. Ce dernier est saisi par l’attribut volume de stockage (lors de disposition en connexion directe ceci se fait dans la fiche technique de l’ouvrage principal, lors de connexion latérale, l’attribution se fait dans la fiche technique de l’ouvrage de répartition ou déversoir d’orage précédant).';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN utilisable_capacity  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.utilisable_capacity IS 'yyy_Inhalt der Kammer unterhalb Notüberlauf oder Bypass (maximal mobilisierbares Volumen, inkl. Stauraum im Zulaufkanal). Für RRB und RRK. Für RÜB Nutzinhalt_Fangteil und Nutzinhalt_Klaerteil benutzen. Zusätzlich auch Stauraum erfassen. / Inhalt der Kammer unterhalb Notüberlauf oder Bypass (maximal mobilisierbares Volumen, inkl. Stauraum im Zulaufkanal). Für RRB und RRK. Für RÜB Nutzinhalt_Fangteil und Nutzinhalt_Klaerteil benutzen. Zusätzlich auch Stauraum erfassen. / Pour les bassins et canalisations d’accumulation : Volume de la chambre sous la surverse de secours ou bypass (volume mobilisable maximum, incl. le volume de stockage de la canalisation d’amenée). Pour les BEP il s’agit du VOLUME_UTILE_STOCKAGE et du VOLUME_UTILE_CLARIFICATION. Il faut également saisir le VOLUME_DE_STOCKAGE.';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN volume_pump_sump  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.hydr_geometry.volume_pump_sump IS 'yyy_Volumen des Pumpensumpfs von der Sohle bis zur maximal möglichen Wasserspiegellage (inkl. Kanalspeichervolumen im Zulaufkanal). / Volumen des Pumpensumpfs von der Sohle bis zur maximal möglichen Wasserspiegellage (inkl. Kanalspeichervolumen im Zulaufkanal). / Volume du puisard calculée à partir du radier jusqu’au niveau d’eau maximum possible (incl. le volume de stockage de la canalisation d’amenée).';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.hydr_geometry.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.hydr_geometry.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.hydr_geometry ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.hydr_geometry.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hydr_geometry
BEFORE UPDATE OR INSERT ON
 qgep_od.hydr_geometry
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.wastewater_networkelement
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wastewater_networkelement_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wastewater_networkelement_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wastewater_networkelement ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wastewater_networkelement');
COMMENT ON COLUMN qgep_od.wastewater_networkelement.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wastewater_networkelement ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.wastewater_networkelement.identifier IS '';
ALTER TABLE qgep_od.wastewater_networkelement ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.wastewater_networkelement.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.wastewater_networkelement ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.wastewater_networkelement.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.wastewater_networkelement ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.wastewater_networkelement.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.wastewater_networkelement ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.wastewater_networkelement.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wastewater_networkelement
BEFORE UPDATE OR INSERT ON
 qgep_od.wastewater_networkelement
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.reach_point
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_reach_point_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_reach_point_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.reach_point ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','reach_point');
COMMENT ON COLUMN qgep_od.reach_point.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.reach_point ADD COLUMN elevation_accuracy  integer ;
COMMENT ON COLUMN qgep_od.reach_point.elevation_accuracy IS 'yyy_Quantifizierung der Genauigkeit der Höhenlage der Kote in Relation zum Höhenfixpunktnetz (z.B. Grundbuchvermessung oder Landesnivellement). / Quantifizierung der Genauigkeit der Höhenlage der Kote in Relation zum Höhenfixpunktnetz (z.B. Grundbuchvermessung oder Landesnivellement). / Plage de précision des coordonnées altimétriques du point de tronçon';
ALTER TABLE qgep_od.reach_point ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.reach_point.identifier IS '';
ALTER TABLE qgep_od.reach_point ADD COLUMN level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.reach_point.level IS 'yyy_Sohlenhöhe des Haltungsendes / Sohlenhöhe des Haltungsendes / Cote du radier de la fin du tronçon';
ALTER TABLE qgep_od.reach_point ADD COLUMN outlet_shape  integer ;
COMMENT ON COLUMN qgep_od.reach_point.outlet_shape IS 'Kind of outlet shape / Art des Auslaufs / Types de sortie';
ALTER TABLE qgep_od.reach_point ADD COLUMN position_of_connection  smallint ;
COMMENT ON COLUMN qgep_od.reach_point.position_of_connection IS 'yyy_Anschlussstelle bezogen auf Querschnitt im Kanal; in Fliessrichtung  (für Haus- und Strassenanschlüsse) / Anschlussstelle bezogen auf Querschnitt im Kanal; in Fliessrichtung  (für Haus- und Strassenanschlüsse) / Emplacement de raccordement Référence à la section transversale dans le canal dans le sens d’écoulement (pour les raccordements domestiques et de rue).';
ALTER TABLE qgep_od.reach_point ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.reach_point.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.reach_point ADD COLUMN situation_geometry geometry('POINTZ', :SRID) NOT NULL;
CREATE INDEX in_qgep_od_reach_point_situation_geometry ON qgep_od.reach_point USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.reach_point.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.reach_point ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.reach_point.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.reach_point ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.reach_point.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.reach_point ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.reach_point.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_reach_point
BEFORE UPDATE OR INSERT ON
 qgep_od.reach_point
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.wastewater_node
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wastewater_node_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wastewater_node_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wastewater_node ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wastewater_node');
COMMENT ON COLUMN qgep_od.wastewater_node.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wastewater_node ADD COLUMN backflow_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.wastewater_node.backflow_level IS 'yyy_1. Massgebende Rückstaukote bezogen auf den Berechnungsregen (dss)  2. Höhe, unter der innerhalb der Grundstücksentwässerung besondere Massnahmen gegen Rückstau zu treffen sind. (DIN 4045) / 1. Massgebende Rückstaukote bezogen auf den Berechnungsregen (dss)  2. Höhe, unter der innerhalb der Grundstücksentwässerung besondere Massnahmen gegen Rückstau zu treffen sind. (DIN 4045) / Cote de refoulement déterminante calculée à partir des pluies de projet';
ALTER TABLE qgep_od.wastewater_node ADD COLUMN bottom_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.wastewater_node.bottom_level IS 'yyy_Tiefster Punkt des Abwasserbauwerks / Tiefster Punkt des Abwasserbauwerks / Point le plus bas du noeud';
ALTER TABLE qgep_od.wastewater_node ADD COLUMN situation_geometry geometry('POINTZ', :SRID) NOT NULL;
CREATE INDEX in_qgep_od_wastewater_node_situation_geometry ON qgep_od.wastewater_node USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.wastewater_node.situation_geometry IS 'yyy Situation of node. Decisive reference point for sewer network simulation  (In der Regel Lage des Pickellochs oder Lage des Trockenwetterauslauf) / Lage des Knotens, massgebender Bezugspunkt für die Kanalnetzberechnung. (In der Regel Lage des Pickellochs oder Lage des Trockenwetterauslaufs) / Positionnement du nœud. Point de référence déterminant pour le calcul de réseau de canalisations (en règle générale positionnement du milieu du couvercle ou de la sortie temps sec)';
-------
CREATE TRIGGER
update_last_modified_wastewater_node
BEFORE UPDATE OR INSERT ON
 qgep_od.wastewater_node
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_networkelement");

-------
-------
CREATE TABLE qgep_od.reach
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_reach_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_reach_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.reach ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','reach');
COMMENT ON COLUMN qgep_od.reach.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.reach ADD COLUMN clear_height  integer ;
COMMENT ON COLUMN qgep_od.reach.clear_height IS 'Maximal height (inside) of profile / Maximale Innenhöhe des Kanalprofiles / Hauteur intérieure maximale du profil';
ALTER TABLE qgep_od.reach ADD COLUMN coefficient_of_friction  smallint ;
COMMENT ON COLUMN qgep_od.reach.coefficient_of_friction IS 'yyy http://www.linguee.com/english-german/search?source=auto&query=reibungsbeiwert / Hydraulische Kenngrösse zur Beschreibung der Beschaffenheit der Kanalwandung. Beiwert für die Formeln nach Manning-Strickler (K oder kstr) / Constante de rugosité selon Manning-Strickler (K ou kstr)';
ALTER TABLE qgep_od.reach ADD COLUMN elevation_determination  integer ;
COMMENT ON COLUMN qgep_od.reach.elevation_determination IS 'yyy_Definiert die Hoehenbestimmung einer Haltung. / Definiert die Hoehenbestimmung einer Haltung. / Définition de la détermination altimétrique d''un tronçon.';
ALTER TABLE qgep_od.reach ADD COLUMN horizontal_positioning  integer ;
COMMENT ON COLUMN qgep_od.reach.horizontal_positioning IS 'yyy_Definiert die Lagegenauigkeit der Verlaufspunkte. / Definiert die Lagegenauigkeit der Verlaufspunkte. / Définit la précision de la détermination du tracé.';
ALTER TABLE qgep_od.reach ADD COLUMN inside_coating  integer ;
COMMENT ON COLUMN qgep_od.reach.inside_coating IS 'yyy_Schutz der Innenwände des Kanals / Schutz der Innenwände des Kanals / Protection de la paroi intérieur de la canalisation';
ALTER TABLE qgep_od.reach ADD COLUMN length_effective  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.reach.length_effective IS 'yyy_Tatsächliche schräge Länge (d.h. nicht in horizontale Ebene projiziert)  inklusive Kanalkrümmungen / Tatsächliche schräge Länge (d.h. nicht in horizontale Ebene projiziert)  inklusive Kanalkrümmungen / Longueur effective (non projetée) incluant les parties incurvées';
ALTER TABLE qgep_od.reach ADD COLUMN material  integer ;
COMMENT ON COLUMN qgep_od.reach.material IS 'Material of reach / pipe / Rohrmaterial / Matériau du tuyau';
ALTER TABLE qgep_od.reach ADD COLUMN progression_geometry geometry('COMPOUNDCURVEZ', :SRID) NOT NULL;
CREATE INDEX in_qgep_od_reach_progression_geometry ON qgep_od.reach USING gist (progression_geometry );
COMMENT ON COLUMN qgep_od.reach.progression_geometry IS 'Start, inflextion and endpoints of a pipe / Anfangs-, Knick- und Endpunkte der Leitung / Points de départ, intermédiaires et d’arrivée de la conduite.';
ALTER TABLE qgep_od.reach ADD COLUMN reliner_material  integer ;
COMMENT ON COLUMN qgep_od.reach.reliner_material IS 'Material of reliner / Material des Reliners / Materiaux du relining';
ALTER TABLE qgep_od.reach ADD COLUMN reliner_nominal_size  integer ;
COMMENT ON COLUMN qgep_od.reach.reliner_nominal_size IS 'yyy_Profilhöhe des Inliners (innen). Beim Export in Hydrauliksoftware müsste dieser Wert statt Haltung.Lichte_Hoehe übernommen werden um korrekt zu simulieren. / Profilhöhe des Inliners (innen). Beim Export in Hydrauliksoftware müsste dieser Wert statt Haltung.Lichte_Hoehe übernommen werden um korrekt zu simulieren. / Hauteur intérieure maximale du profil de l''inliner. A l''export dans le software hydraulique il faut utiliser cette attribut au lieu de HAUTEUR_MAX_PROFIL';
ALTER TABLE qgep_od.reach ADD COLUMN relining_construction  integer ;
COMMENT ON COLUMN qgep_od.reach.relining_construction IS 'yyy_Bautechnik für das Relining. Zusätzlich wird der Einbau des Reliners als  Erhaltungsereignis abgebildet: Erhaltungsereignis.Art = Reparatur für Partieller_Liner, sonst Renovierung. / Bautechnik für das Relining. Zusätzlich wird der Einbau des Reliners als  Erhaltungsereignis abgebildet: Erhaltungsereignis.Art = Reparatur für Partieller_Liner, sonst Renovierung. / Relining technique de construction. En addition la construction du reliner doit être modeler comme événement maintenance: Genre = reparation pour liner_partiel, autrement genre = renovation.';
ALTER TABLE qgep_od.reach ADD COLUMN relining_kind  integer ;
COMMENT ON COLUMN qgep_od.reach.relining_kind IS 'Kind of relining / Art des Relinings / Genre du relining';
ALTER TABLE qgep_od.reach ADD COLUMN ring_stiffness  smallint ;
COMMENT ON COLUMN qgep_od.reach.ring_stiffness IS 'yyy Ringsteifigkeitsklasse - Druckfestigkeit gegen Belastungen von aussen (gemäss ISO 13966 ) / Ringsteifigkeitsklasse - Druckfestigkeit gegen Belastungen von aussen (gemäss ISO 13966 ) / Rigidité annulaire pour des pressions extérieures (selon ISO 13966)';
ALTER TABLE qgep_od.reach ADD COLUMN slope_building_plan  smallint ;
COMMENT ON COLUMN qgep_od.reach.slope_building_plan IS 'yyy_Auf dem alten Plan eingezeichnetes Plangefälle [%o]. Nicht kontrolliert im Feld. Kann nicht für die hydraulische Berechnungen übernommen werden. Für Liegenschaftsentwässerung und Meliorationsleitungen. Darstellung als z.B. 3.5%oP auf Plänen. / Auf dem alten Plan eingezeichnetes Plangefälle [%o]. Nicht kontrolliert im Feld. Kann nicht für die hydraulische Berechnungen übernommen werden. Für Liegenschaftsentwässerung und Meliorationsleitungen. Darstellung als z.B. 3.5%oP auf Plänen. / Pente indiquée sur d''anciens plans non contrôlée [%o]. Ne peut pas être reprise pour des calculs hydrauliques. Indication pour des canalisations de biens-fonds ou d''amélioration foncière. Représentation sur de plan: 3.5‰ p';
ALTER TABLE qgep_od.reach ADD COLUMN wall_roughness  decimal(5,2) ;
COMMENT ON COLUMN qgep_od.reach.wall_roughness IS 'yyy Hydraulische Kenngrösse zur Beschreibung der Beschaffenheit der Kanalwandung. Beiwert für die Formeln nach Prandtl-Colebrook (ks oder kb) / Hydraulische Kenngrösse zur Beschreibung der Beschaffenheit der Kanalwandung. Beiwert für die Formeln nach Prandtl-Colebrook (ks oder kb) / Coefficient de rugosité d''après Prandtl Colebrook (ks ou kb)';

-------
CREATE TRIGGER
update_last_modified_reach
BEFORE UPDATE OR INSERT ON
 qgep_od.reach
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.wastewater_networkelement");

-------
-------
CREATE TABLE qgep_od.profile_geometry
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_profile_geometry_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_profile_geometry_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.profile_geometry ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','profile_geometry');
COMMENT ON COLUMN qgep_od.profile_geometry.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.profile_geometry ADD COLUMN position  smallint ;
COMMENT ON COLUMN qgep_od.profile_geometry.position IS 'yyy_Position der Detailpunkte der Geometrie / Position der Detailpunkte der Geometrie / Position des points d''appui de la géométrie';
ALTER TABLE qgep_od.profile_geometry ADD COLUMN x  real ;
COMMENT ON COLUMN qgep_od.profile_geometry.x IS 'x';
ALTER TABLE qgep_od.profile_geometry ADD COLUMN y  real ;
COMMENT ON COLUMN qgep_od.profile_geometry.y IS 'y';
ALTER TABLE qgep_od.profile_geometry ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.profile_geometry.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.profile_geometry ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.profile_geometry.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.profile_geometry ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.profile_geometry.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_profile_geometry
BEFORE UPDATE OR INSERT ON
 qgep_od.profile_geometry
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.hydr_geom_relation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_hydr_geom_relation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_hydr_geom_relation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.hydr_geom_relation ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','hydr_geom_relation');
COMMENT ON COLUMN qgep_od.hydr_geom_relation.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN water_depth  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.hydr_geom_relation.water_depth IS 'yyy_Massgebende Wassertiefe / Massgebende Wassertiefe / Profondeur d''eau déterminante';
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN water_surface  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.hydr_geom_relation.water_surface IS 'yyy_Freie Wasserspiegelfläche; für Speicherfunktionen massgebend / Freie Wasserspiegelfläche; für Speicherfunktionen massgebend / Surface du plan d''eau; déterminant pour les fonctions d''accumulation';
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN wet_cross_section_area  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.hydr_geom_relation.wet_cross_section_area IS 'yyy_Hydraulisch wirksamer Querschnitt für Verlustberechnungen / Hydraulisch wirksamer Querschnitt für Verlustberechnungen / Section hydrauliquement active pour les calculs des pertes de charge';
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.hydr_geom_relation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.hydr_geom_relation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.hydr_geom_relation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hydr_geom_relation
BEFORE UPDATE OR INSERT ON
 qgep_od.hydr_geom_relation
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.mechanical_pretreatment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_mechanical_pretreatment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_mechanical_pretreatment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.mechanical_pretreatment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','mechanical_pretreatment');
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.identifier IS '';
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.kind IS 'yyy_Arten der mechanischen Vorreinigung / Behandlung (gemäss VSA Richtlinie Regenwasserentsorgung (2002)) / Arten der mechanischen Vorreinigung / Behandlung (gemäss VSA Richtlinie Regenwasserentsorgung (2002)) / Genre de pré-épuration mécanique (selon directive VSA "Evacuation des eaux pluviales, édition 2002)';
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.mechanical_pretreatment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_mechanical_pretreatment
BEFORE UPDATE OR INSERT ON
 qgep_od.mechanical_pretreatment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.retention_body
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_retention_body_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_retention_body_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.retention_body ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','retention_body');
COMMENT ON COLUMN qgep_od.retention_body.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.retention_body ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.retention_body.identifier IS '';
ALTER TABLE qgep_od.retention_body ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.retention_body.kind IS 'Type of retention / Arten der Retention / Genre de rétention';
ALTER TABLE qgep_od.retention_body ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.retention_body.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.retention_body ADD COLUMN volume  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.retention_body.volume IS 'yyy_Nutzbares Volumen des Retentionskörpers / Nutzbares Volumen des Retentionskörpers / Volume effectif du volume de rétention';
ALTER TABLE qgep_od.retention_body ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.retention_body.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.retention_body ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.retention_body.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.retention_body ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.retention_body.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_retention_body
BEFORE UPDATE OR INSERT ON
 qgep_od.retention_body
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.overflow_char
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_overflow_char_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_overflow_char_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.overflow_char ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','overflow_char');
COMMENT ON COLUMN qgep_od.overflow_char.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.overflow_char ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.overflow_char.identifier IS '';
ALTER TABLE qgep_od.overflow_char ADD COLUMN kind_overflow_characteristic  integer ;
COMMENT ON COLUMN qgep_od.overflow_char.kind_overflow_characteristic IS 'yyy_Die Kennlinie ist als Q /Q- (bei Bodenöffnungen) oder als H/Q-Tabelle (bei Streichwehren) zu dokumentieren. Bei einer freien Aufteilung muss die Kennlinie nicht dokumentiert werden. Bei Abflussverhältnissen in Einstaubereichen ist die Funktion separat in einer Beilage zu beschreiben. / Die Kennlinie ist als Q /Q- (bei Bodenöffnungen) oder als H/Q-Tabelle (bei Streichwehren) zu dokumentieren. Bei einer freien Aufteilung muss die Kennlinie nicht dokumentiert werden. Bei Abflussverhältnissen in Einstaubereichen ist die Funktion separat in einer Beilage zu beschreiben. / La courbe est à documenter sous forme de rapport Q/Q (Leaping weir) ou H/Q (déversoir latéral). Les conditions d’écoulement dans la chambre d’accumulation sont à fournir en annexe.';
ALTER TABLE qgep_od.overflow_char ADD COLUMN overflow_characteristic_digital  integer ;
COMMENT ON COLUMN qgep_od.overflow_char.overflow_characteristic_digital IS 'yyy_Falls Kennlinie_digital = ja müssen die Attribute für die Q-Q oder H-Q Beziehung  in Ueberlaufcharakteristik ausgefüllt sein in HQ_Relation. / Falls Kennlinie_digital = ja müssen die Attribute für die Q-Q oder H-Q Beziehung in HQ_Relation ausgefüllt sein. / Si courbe de fonctionnement numérique = oui, les attributs pour les relations Q-Q et H-Q doivent être saisis dans la classe RELATION_HQ.';
ALTER TABLE qgep_od.overflow_char ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.overflow_char.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.overflow_char ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.overflow_char.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.overflow_char ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.overflow_char.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.overflow_char ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.overflow_char.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_overflow_char
BEFORE UPDATE OR INSERT ON
 qgep_od.overflow_char
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.hq_relation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_hq_relation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_hq_relation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.hq_relation ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','hq_relation');
COMMENT ON COLUMN qgep_od.hq_relation.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.hq_relation ADD COLUMN altitude  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.hq_relation.altitude IS 'yyy_Zum Abfluss (Q2) korrelierender Wasserspiegel (h) / Zum Abfluss (Q2) korrelierender Wasserspiegel (h) / Niveau d''eau correspondant (h) au débit (Q2)';
ALTER TABLE qgep_od.hq_relation ADD COLUMN flow  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.hq_relation.flow IS 'Flow (Q2) in direction of WWTP / Abflussmenge (Q2) Richtung ARA / Débit d''eau (Q2) en direction de la STEP';
ALTER TABLE qgep_od.hq_relation ADD COLUMN flow_from  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.hq_relation.flow_from IS 'yyy_Zufluss (Q1) / Zufluss (Q1) / Débit d’entrée  (Q1)';
ALTER TABLE qgep_od.hq_relation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.hq_relation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.hq_relation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.hq_relation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.hq_relation ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.hq_relation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hq_relation
BEFORE UPDATE OR INSERT ON
 qgep_od.hq_relation
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.structure_part
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_structure_part_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_structure_part_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.structure_part ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','structure_part');
COMMENT ON COLUMN qgep_od.structure_part.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.structure_part ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.structure_part.identifier IS '';
ALTER TABLE qgep_od.structure_part ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.structure_part.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.structure_part ADD COLUMN renovation_demand  integer ;
COMMENT ON COLUMN qgep_od.structure_part.renovation_demand IS 'yyy_Zustandsinformation zum structure_part / Zustandsinformation zum Bauwerksteil / Information sur l''état de l''élément de l''ouvrage';
ALTER TABLE qgep_od.structure_part ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.structure_part.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.structure_part ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.structure_part.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.structure_part ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.structure_part.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_structure_part
BEFORE UPDATE OR INSERT ON
 qgep_od.structure_part
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.dryweather_downspout
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_dryweather_downspout_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_dryweather_downspout_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.dryweather_downspout ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','dryweather_downspout');
COMMENT ON COLUMN qgep_od.dryweather_downspout.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.dryweather_downspout ADD COLUMN diameter  smallint ;
COMMENT ON COLUMN qgep_od.dryweather_downspout.diameter IS 'yyy_Abmessung des Deckels (bei eckigen Deckeln minimale Abmessung) / Abmessung des Deckels (bei eckigen Deckeln minimale Abmessung) / Dimension du couvercle (dimension minimale pour couvercle anguleux)';
-------
CREATE TRIGGER
update_last_modified_dryweather_downspout
BEFORE UPDATE OR INSERT ON
 qgep_od.dryweather_downspout
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.access_aid
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_access_aid_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_access_aid_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.access_aid ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','access_aid');
COMMENT ON COLUMN qgep_od.access_aid.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.access_aid ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.access_aid.kind IS 'yyy_Art des Einstiegs in das Bauwerk / Art des Einstiegs in das Bauwerk / Genre d''accès à l''ouvrage';
-------
CREATE TRIGGER
update_last_modified_access_aid
BEFORE UPDATE OR INSERT ON
 qgep_od.access_aid
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.dryweather_flume
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_dryweather_flume_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_dryweather_flume_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.dryweather_flume ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','dryweather_flume');
COMMENT ON COLUMN qgep_od.dryweather_flume.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.dryweather_flume ADD COLUMN material  integer ;
COMMENT ON COLUMN qgep_od.dryweather_flume.material IS 'yyy_Material der Ausbildung oder Auskleidung der Trockenwetterrinne / Material der Ausbildung oder Auskleidung der Trockenwetterrinne / Matériau de fabrication ou de revêtement de la cunette de débit temps sec';
-------
CREATE TRIGGER
update_last_modified_dryweather_flume
BEFORE UPDATE OR INSERT ON
 qgep_od.dryweather_flume
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.cover
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_cover_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_cover_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.cover ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','cover');
COMMENT ON COLUMN qgep_od.cover.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.cover ADD COLUMN brand  varchar(50) ;
COMMENT ON COLUMN qgep_od.cover.brand IS 'Name of manufacturer / Name der Herstellerfirma / Nom de l''entreprise de fabrication';
ALTER TABLE qgep_od.cover ADD COLUMN cover_shape  integer ;
COMMENT ON COLUMN qgep_od.cover.cover_shape IS 'shape of cover / Form des Deckels / Forme du couvercle';
ALTER TABLE qgep_od.cover ADD COLUMN depth  smallint ;
COMMENT ON COLUMN qgep_od.cover.depth IS 'yyy_redundantes Funktionsattribut Maechtigkeit. Numerisch [mm]. Funktion (berechneter Wert) = zugehöriger Deckel.Kote minus Abwasserknoten.Sohlenkote.(falls die Sohlenkote nicht separat erfasst, dann ist es die tiefer liegende Hal-tungspunkt.Kote) / redundantes Funktionsattribut Maechtigkeit. Numerisch [mm]. Funktion (berechneter Wert) = zugehöriger Deckel.Kote minus Abwasserknoten.Sohlenkote.(falls die Sohlenkote nicht separat erfasst, dann ist es die tiefer liegende Haltungspunkt.Kote) / Attribut de fonction EPAISSEUR redondant, numérique [mm]. Fonction (valeur calculée) = COUVERCLE.COTE correspondant moins NŒUD_RESEAU.COTE_RADIER (si la cote radier ne peut pas être saisie séparément, prendre la POINT_TRONCON.COTE la plus basse.';
ALTER TABLE qgep_od.cover ADD COLUMN diameter  smallint ;
COMMENT ON COLUMN qgep_od.cover.diameter IS 'yyy_Abmessung des Deckels (bei eckigen Deckeln minimale Abmessung) / Abmessung des Deckels (bei eckigen Deckeln minimale Abmessung) / Dimension du couvercle (dimension minimale pour couvercle anguleux)';
ALTER TABLE qgep_od.cover ADD COLUMN fastening  integer ;
COMMENT ON COLUMN qgep_od.cover.fastening IS 'yyy_Befestigungsart des Deckels / Befestigungsart des Deckels / Genre de fixation du couvercle';
ALTER TABLE qgep_od.cover ADD COLUMN level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.cover.level IS 'Height of cover / Deckelhöhe / Cote du couvercle';
ALTER TABLE qgep_od.cover ADD COLUMN material  integer ;
COMMENT ON COLUMN qgep_od.cover.material IS 'Material of cover / Deckelmaterial / Matériau du couvercle';
ALTER TABLE qgep_od.cover ADD COLUMN positional_accuracy  integer ;
COMMENT ON COLUMN qgep_od.cover.positional_accuracy IS 'Quantfication of accuarcy of position of cover (center hole) / Quantifizierung der Genauigkeit der Lage des Deckels (Pickelloch) / Plage de précision des coordonnées planimétriques du couvercle.';
ALTER TABLE qgep_od.cover ADD COLUMN situation_geometry geometry('POINTZ', :SRID) NOT NULL;
CREATE INDEX in_qgep_od_cover_situation_geometry ON qgep_od.cover USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.cover.situation_geometry IS 'Situation of cover (cover hole), National position coordinates (East, North) / Lage des Deckels (Pickelloch) / Positionnement du couvercle (milieu du couvercle)';
ALTER TABLE qgep_od.cover ADD COLUMN sludge_bucket  integer ;
COMMENT ON COLUMN qgep_od.cover.sludge_bucket IS 'yyy_Angabe, ob der Deckel mit einem Schlammeimer versehen ist oder nicht / Angabe, ob der Deckel mit einem Schlammeimer versehen ist oder nicht / Indication si le couvercle est pourvu ou non d''un ramasse-boues';
ALTER TABLE qgep_od.cover ADD COLUMN venting  integer ;
COMMENT ON COLUMN qgep_od.cover.venting IS 'venting with wholes for aeration / Deckel mit Lüftungslöchern versehen / Couvercle pourvu de trous d''aération';
-------
CREATE TRIGGER
update_last_modified_cover
BEFORE UPDATE OR INSERT ON
 qgep_od.cover
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.electric_equipment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_electric_equipment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_electric_equipment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.electric_equipment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','electric_equipment');
COMMENT ON COLUMN qgep_od.electric_equipment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.electric_equipment ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.electric_equipment.gross_costs IS 'Gross costs of electromechanical equipment / Brutto Erstellungskosten der elektromechanischen Ausrüstung / Coûts bruts des équipements électromécaniques';
ALTER TABLE qgep_od.electric_equipment ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.electric_equipment.kind IS 'yyy_Elektrische Installationen und Geräte / Elektrische Installationen und Geräte / Installations et appareils électriques';
ALTER TABLE qgep_od.electric_equipment ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.electric_equipment.year_of_replacement IS 'yyy_Jahr, in dem die Lebensdauer der elektrischen Einrichtung voraussichtlich ausläuft / Jahr, in dem die Lebensdauer der elektrischen Einrichtung voraussichtlich ausläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_electric_equipment
BEFORE UPDATE OR INSERT ON
 qgep_od.electric_equipment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.electromechanical_equipment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_electromechanical_equipment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_electromechanical_equipment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.electromechanical_equipment ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','electromechanical_equipment');
COMMENT ON COLUMN qgep_od.electromechanical_equipment.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.electromechanical_equipment ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.electromechanical_equipment.gross_costs IS 'Gross costs of electromechanical equipment / Brutto Erstellungskosten der elektromechanischen Ausrüstung / Coûts bruts des équipements électromécaniques';
ALTER TABLE qgep_od.electromechanical_equipment ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.electromechanical_equipment.kind IS 'yyy_Elektromechanische Teile eines Bauwerks / Elektromechanische Teile eines Bauwerks / Eléments électromécaniques d''un ouvrage';
ALTER TABLE qgep_od.electromechanical_equipment ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.electromechanical_equipment.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_electromechanical_equipment
BEFORE UPDATE OR INSERT ON
 qgep_od.electromechanical_equipment
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.benching
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_benching_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_benching_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.benching ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','benching');
COMMENT ON COLUMN qgep_od.benching.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.benching ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.benching.kind IS '';
-------
CREATE TRIGGER
update_last_modified_benching
BEFORE UPDATE OR INSERT ON
 qgep_od.benching
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.connection_object
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_connection_object_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_connection_object_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.connection_object ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','connection_object');
COMMENT ON COLUMN qgep_od.connection_object.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.connection_object ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.connection_object.identifier IS '';
ALTER TABLE qgep_od.connection_object ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.connection_object.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.connection_object ADD COLUMN sewer_infiltration_water_production  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.connection_object.sewer_infiltration_water_production IS 'yyy_Durchschnittlicher Fremdwasseranfall für Fremdwasserquellen wie Laufbrunnen oder Reservoirüberlauf / Durchschnittlicher Fremdwasseranfall für Fremdwasserquellen wie Laufbrunnen oder Reservoirüberlauf / Apport moyen d''eaux claires parasites (ECP) par des sources d''ECP, telles que fontaines ou trops-plein de réservoirs';
ALTER TABLE qgep_od.connection_object ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.connection_object.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.connection_object ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.connection_object.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.connection_object ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.connection_object.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_connection_object
BEFORE UPDATE OR INSERT ON
 qgep_od.connection_object
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.building
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_building_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_building_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.building ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','building');
COMMENT ON COLUMN qgep_od.building.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.building ADD COLUMN house_number  varchar(50) ;
COMMENT ON COLUMN qgep_od.building.house_number IS 'House number based on cadastral register / Hausnummer gemäss Grundbuch / Numéro de bâtiment selon le registre foncier';
ALTER TABLE qgep_od.building ADD COLUMN location_name  varchar(50) ;
COMMENT ON COLUMN qgep_od.building.location_name IS 'Street name or name of the location / Strassenname oder Ortsbezeichnung / Nom de la route ou du lieu';
ALTER TABLE qgep_od.building ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_building_perimeter_geometry ON qgep_od.building USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.building.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
ALTER TABLE qgep_od.building ADD COLUMN reference_point_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_building_reference_point_geometry ON qgep_od.building USING gist (reference_point_geometry );
COMMENT ON COLUMN qgep_od.building.reference_point_geometry IS 'National position coordinates (East, North) (relevant point for e.g. address) / Landeskoordinate Ost/Nord (massgebender Bezugspunkt für z.B. Adressdaten ) / Coordonnées nationales Est/Nord (Point de référence pour la détermination de l''adresse par exemple)';
-------
CREATE TRIGGER
update_last_modified_building
BEFORE UPDATE OR INSERT ON
 qgep_od.building
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.connection_object");

-------
-------
CREATE TABLE qgep_od.reservoir
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_reservoir_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_reservoir_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.reservoir ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','reservoir');
COMMENT ON COLUMN qgep_od.reservoir.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.reservoir ADD COLUMN location_name  varchar(50) ;
COMMENT ON COLUMN qgep_od.reservoir.location_name IS 'Street name or name of the location / Strassenname oder Ortsbezeichnung / Nom de la route ou du lieu';
ALTER TABLE qgep_od.reservoir ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_reservoir_situation_geometry ON qgep_od.reservoir USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.reservoir.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
-------
CREATE TRIGGER
update_last_modified_reservoir
BEFORE UPDATE OR INSERT ON
 qgep_od.reservoir
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.connection_object");

-------
-------
CREATE TABLE qgep_od.individual_surface
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_individual_surface_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_individual_surface_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.individual_surface ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','individual_surface');
COMMENT ON COLUMN qgep_od.individual_surface.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.individual_surface ADD COLUMN function  integer ;
COMMENT ON COLUMN qgep_od.individual_surface.function IS 'Type of usage of surface / Art der Nutzung der Fläche / Genre d''utilisation de la surface';
ALTER TABLE qgep_od.individual_surface ADD COLUMN inclination  smallint ;
COMMENT ON COLUMN qgep_od.individual_surface.inclination IS 'yyy_Mittlere Neigung der Oberfläche in Promill / Mittlere Neigung der Oberfläche in Promill / Pente moyenne de la surface en promille';
ALTER TABLE qgep_od.individual_surface ADD COLUMN pavement  integer ;
COMMENT ON COLUMN qgep_od.individual_surface.pavement IS 'Type of pavement / Art der Befestigung / Genre de couverture du sol';
ALTER TABLE qgep_od.individual_surface ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_individual_surface_perimeter_geometry ON qgep_od.individual_surface USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.individual_surface.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_individual_surface
BEFORE UPDATE OR INSERT ON
 qgep_od.individual_surface
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.connection_object");

-------
-------
CREATE TABLE qgep_od.fountain
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_fountain_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_fountain_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.fountain ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','fountain');
COMMENT ON COLUMN qgep_od.fountain.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.fountain ADD COLUMN location_name  varchar(50) ;
COMMENT ON COLUMN qgep_od.fountain.location_name IS 'Street name or name of the location / Strassenname oder Ortsbezeichnung / Nom de la route ou du lieu';
ALTER TABLE qgep_od.fountain ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_fountain_situation_geometry ON qgep_od.fountain USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.fountain.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
-------
CREATE TRIGGER
update_last_modified_fountain
BEFORE UPDATE OR INSERT ON
 qgep_od.fountain
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.connection_object");

-------
-------
CREATE TABLE qgep_od.hazard_source
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_hazard_source_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_hazard_source_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.hazard_source ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','hazard_source');
COMMENT ON COLUMN qgep_od.hazard_source.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.hazard_source ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.hazard_source.identifier IS '';
ALTER TABLE qgep_od.hazard_source ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.hazard_source.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.hazard_source ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_hazard_source_situation_geometry ON qgep_od.hazard_source USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.hazard_source.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.hazard_source ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.hazard_source.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.hazard_source ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.hazard_source.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.hazard_source ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.hazard_source.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hazard_source
BEFORE UPDATE OR INSERT ON
 qgep_od.hazard_source
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.accident
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_accident_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_accident_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.accident ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','accident');
COMMENT ON COLUMN qgep_od.accident.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.accident ADD COLUMN date  timestamp without time zone ;
COMMENT ON COLUMN qgep_od.accident.date IS 'Date of accident / Datum des Ereignisses / Date de l''événement';
ALTER TABLE qgep_od.accident ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.accident.identifier IS '';
ALTER TABLE qgep_od.accident ADD COLUMN place  varchar(50) ;
COMMENT ON COLUMN qgep_od.accident.place IS 'Adress of the location of accident / Adresse der Unfallstelle / Adresse du lieu de l''accident';
ALTER TABLE qgep_od.accident ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.accident.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.accident ADD COLUMN responsible  varchar(50) ;
COMMENT ON COLUMN qgep_od.accident.responsible IS 'Name of the responsible of the accident / Name Adresse des Verursachers / Nom et adresse de l''auteur';
ALTER TABLE qgep_od.accident ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_accident_situation_geometry ON qgep_od.accident USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.accident.situation_geometry IS 'National position coordinates (North, East) of accident / Landeskoordinate Ost/Nord des Unfallortes / Coordonnées nationales Est/Nord du lieu d''accident';
ALTER TABLE qgep_od.accident ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.accident.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.accident ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.accident.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.accident ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.accident.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_accident
BEFORE UPDATE OR INSERT ON
 qgep_od.accident
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.substance
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_substance_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_substance_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.substance ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','substance');
COMMENT ON COLUMN qgep_od.substance.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.substance ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.substance.identifier IS '';
ALTER TABLE qgep_od.substance ADD COLUMN kind  varchar(50) ;
COMMENT ON COLUMN qgep_od.substance.kind IS 'yyy_Liste der wassergefährdenden Stoffe / Liste der wassergefährdenden Stoffe / Liste des substances de nature à polluer les eaux';
ALTER TABLE qgep_od.substance ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.substance.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.substance ADD COLUMN stockage  varchar(50) ;
COMMENT ON COLUMN qgep_od.substance.stockage IS 'yyy_Art der Lagerung der abwassergefährdenden Stoffe / Art der Lagerung der abwassergefährdenden Stoffe / Genre de stockage des substances dangereuses';
ALTER TABLE qgep_od.substance ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.substance.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.substance ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.substance.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.substance ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.substance.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_substance
BEFORE UPDATE OR INSERT ON
 qgep_od.substance
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.catchment_area
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_catchment_area_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_catchment_area_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.catchment_area ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','catchment_area');
COMMENT ON COLUMN qgep_od.catchment_area.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.catchment_area ADD COLUMN direct_discharge_current  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.direct_discharge_current IS 'The rain water is currently fully or partially discharged into a water body / Das Regenabwasser wird ganz oder teilweise über eine SAA-Leitung in ein Gewässer eingeleitet / Les eaux pluviales sont rejetées complètement ou partiellement via une conduite OAS dans un cours d’eau';
ALTER TABLE qgep_od.catchment_area ADD COLUMN direct_discharge_planned  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.direct_discharge_planned IS 'The rain water will be discharged fully or partially over a SAA pipe into a water body / Das Regenabwasser wird in Zukunft ganz oder teilweise über eine SAA-Leitung in ein Gewässer eingeleitet / Les eaux pluviales seront rejetées complètement ou partiellement via une conduite OAS dans un cours d’eau';
ALTER TABLE qgep_od.catchment_area ADD COLUMN discharge_coefficient_rw_current  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.discharge_coefficient_rw_current IS 'yyy_Abflussbeiwert für den Regenabwasseranschluss im Ist-Zustand / Abflussbeiwert für den Regenabwasseranschluss im Ist-Zustand / Coefficient de ruissellement pour le raccordement actuel des eaux pluviales';
ALTER TABLE qgep_od.catchment_area ADD COLUMN discharge_coefficient_rw_planned  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.discharge_coefficient_rw_planned IS 'yyy_Abflussbeiwert für den Regenabwasseranschluss im Planungszustand / Abflussbeiwert für den Regenabwasseranschluss im Planungszustand / Coefficient de ruissellement prévu pour le raccordement des eaux pluviales';
ALTER TABLE qgep_od.catchment_area ADD COLUMN discharge_coefficient_ww_current  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.discharge_coefficient_ww_current IS 'yy_Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Coefficient de ruissellement pour les raccordements eaux usées et eaux mixtes actuels';
ALTER TABLE qgep_od.catchment_area ADD COLUMN discharge_coefficient_ww_planned  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.discharge_coefficient_ww_planned IS 'yyy_Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Coefficient de ruissellement pour le raccordement prévu des eaux usées ou mixtes';
ALTER TABLE qgep_od.catchment_area ADD COLUMN drainage_system_current  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.drainage_system_current IS 'yyy_Effektive Entwässerungsart im Ist-Zustand / Effektive Entwässerungsart im Ist-Zustand / Genre d’évacuation des eaux réel à l’état actuel';
ALTER TABLE qgep_od.catchment_area ADD COLUMN drainage_system_planned  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.drainage_system_planned IS 'yyy_Entwässerungsart im Planungszustand (nach Umsetzung des Entwässerungskonzepts). Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Entwässerungsart im Planungszustand (nach Umsetzung des Entwässerungskonzepts). Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Genre d’évacuation des eaux à l’état de planification (mise en œuvre du concept d’évacuation). Cet attribut est exigé. Il est obligatoire pour l’examen des demandes de permit de construire';
ALTER TABLE qgep_od.catchment_area ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.catchment_area.identifier IS '';
ALTER TABLE qgep_od.catchment_area ADD COLUMN infiltration_current  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.infiltration_current IS 'yyy_Das Regenabwasser wird ganz oder teilweise einer Versickerungsanlage zugeführt / Das Regenabwasser wird ganz oder teilweise einer Versickerungsanlage zugeführt / Les eaux pluviales sont amenées complètement ou partiellement à une installation d’infiltration';
ALTER TABLE qgep_od.catchment_area ADD COLUMN infiltration_planned  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.infiltration_planned IS 'In the future the rain water will  be completly or partially infiltrated in a infiltration unit. / Das Regenabwasser wird in Zukunft ganz oder teilweise einer Versickerungsanlage zugeführt / Les eaux pluviales seront amenées complètement ou partiellement à une installation d’infiltration';
ALTER TABLE qgep_od.catchment_area ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_qgep_od_catchment_area_perimeter_geometry ON qgep_od.catchment_area USING gist (perimeter_geometry );
COMMENT ON COLUMN qgep_od.catchment_area.perimeter_geometry IS 'Boundary points of the perimeter sub catchement area / Begrenzungspunkte des Teileinzugsgebiets / Points de délimitation du bassin versant partiel';
ALTER TABLE qgep_od.catchment_area ADD COLUMN population_density_current  smallint ;
COMMENT ON COLUMN qgep_od.catchment_area.population_density_current IS 'yyy_Dichte der (physischen) Einwohner im Ist-Zustand / Dichte der (physischen) Einwohner im Ist-Zustand / Densité (physique) de la population actuelle';
ALTER TABLE qgep_od.catchment_area ADD COLUMN population_density_planned  smallint ;
COMMENT ON COLUMN qgep_od.catchment_area.population_density_planned IS 'yyy_Dichte der (physischen) Einwohner im Planungszustand / Dichte der (physischen) Einwohner im Planungszustand / Densité (physique) de la population prévue';
ALTER TABLE qgep_od.catchment_area ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.catchment_area.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.catchment_area ADD COLUMN retention_current  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.retention_current IS 'yyy_Das Regen- oder Mischabwasser wird über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Das Regen- oder Mischabwasser wird über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Les eaux pluviales et mixtes sont rejetées de manière régulée dans le réseau des canalisations par un ouvrage de rétention.';
ALTER TABLE qgep_od.catchment_area ADD COLUMN retention_planned  integer ;
COMMENT ON COLUMN qgep_od.catchment_area.retention_planned IS 'yyy_Das Regen- oder Mischabwasser wird in Zukunft über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Das Regen- oder Mischabwasser wird in Zukunft über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Les eaux pluviales et mixtes seront rejetées de manière régulée dans le réseau des canalisations par un ouvrage de rétention.';
ALTER TABLE qgep_od.catchment_area ADD COLUMN runoff_limit_current  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.catchment_area.runoff_limit_current IS 'yyy_Abflussbegrenzung, falls eine entsprechende Auflage bereits umgesetzt ist. / Abflussbegrenzung, falls eine entsprechende Auflage bereits umgesetzt ist. / Restriction de débit, si une exigence est déjà mise en œuvre';
ALTER TABLE qgep_od.catchment_area ADD COLUMN runoff_limit_planned  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.catchment_area.runoff_limit_planned IS 'yyy_Abflussbegrenzung, falls eine entsprechende Auflage aus dem Entwässerungskonzept vorliegt. Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Abflussbegrenzung, falls eine entsprechende Auflage aus dem Entwässerungskonzept vorliegt. Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Restriction de débit, si une exigence correspondante existe dans le concept d’évacuation des eaux. Cet attribut est une exigence et obligatoire pour l’examen de demandes de permit de construire';
ALTER TABLE qgep_od.catchment_area ADD COLUMN seal_factor_rw_current  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.seal_factor_rw_current IS 'yyy_Befestigungsgrad für den Regenabwasseranschluss im Ist-Zustand / Befestigungsgrad für den Regenabwasseranschluss im Ist-Zustand / Taux d''imperméabilisation pour le raccordement eaux pluviales actuel';
ALTER TABLE qgep_od.catchment_area ADD COLUMN seal_factor_rw_planned  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.seal_factor_rw_planned IS 'yyy_Befestigungsgrad für den Regenabwasseranschluss im Planungszustand / Befestigungsgrad für den Regenabwasseranschluss im Planungszustand / Taux d''imperméabilisation pour le raccordement eaux pluviales prévu';
ALTER TABLE qgep_od.catchment_area ADD COLUMN seal_factor_ww_current  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.seal_factor_ww_current IS 'yyy_Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Taux d''imperméabilisation pour les raccordements eaux usées et eaux mixtes actuels';
ALTER TABLE qgep_od.catchment_area ADD COLUMN seal_factor_ww_planned  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.catchment_area.seal_factor_ww_planned IS 'yyy_Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Taux d''imperméabilisation pour les raccordements eaux usées et eaux mixtes prévus';
ALTER TABLE qgep_od.catchment_area ADD COLUMN sewer_infiltration_water_production_current  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.catchment_area.sewer_infiltration_water_production_current IS 'yyy_Mittlerer Fremdwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Mittlerer Fremdwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Débit  d''eaux claires parasites (ECP) moyen actuel, rejeté dans les canalisation d’eaux usées ou mixtes';
ALTER TABLE qgep_od.catchment_area ADD COLUMN sewer_infiltration_water_production_planned  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.catchment_area.sewer_infiltration_water_production_planned IS 'yyy_Mittlerer Fremdwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Mittlerer Fremdwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Débit  d''eaux claires parasites (ECP) moyen prévu, rejeté dans les canalisation d’eaux usées ou mixtes';
ALTER TABLE qgep_od.catchment_area ADD COLUMN surface_area  decimal(10,4) ;
COMMENT ON COLUMN qgep_od.catchment_area.surface_area IS 'yyy_redundantes Attribut Flaeche, welches die aus dem Perimeter errechnete Flaeche [ha] enthält / Redundantes Attribut Flaeche, welches die aus dem Perimeter errechnete Flaeche [ha] enthält / Attribut redondant indiquant la surface calculée à partir du périmètre en ha';
ALTER TABLE qgep_od.catchment_area ADD COLUMN waste_water_production_current  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.catchment_area.waste_water_production_current IS 'yyy_Mittlerer Schmutzabwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Mittlerer Schmutzabwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Débit moyen actuel des eaux usées rejetées dans les canalisations d’eaux usées ou d''eaux mixtes';
ALTER TABLE qgep_od.catchment_area ADD COLUMN waste_water_production_planned  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.catchment_area.waste_water_production_planned IS 'yyy_Mittlerer Schmutzabwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Mittlerer Schmutzabwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Débit moyen prévu des eaux usées rejetées dans les canalisations d’eaux usées ou d''eaux mixtes.';
ALTER TABLE qgep_od.catchment_area ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.catchment_area.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.catchment_area ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.catchment_area.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.catchment_area ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.catchment_area.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_catchment_area
BEFORE UPDATE OR INSERT ON
 qgep_od.catchment_area
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.surface_runoff_parameters
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_surface_runoff_parameters_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_surface_runoff_parameters_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.surface_runoff_parameters ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','surface_runoff_parameters');
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN evaporation_loss  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.evaporation_loss IS 'Loss by evaporation / Verlust durch Verdunstung / Pertes par évaporation au sol';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.identifier IS '';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN infiltration_loss  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.infiltration_loss IS 'Loss by infiltration / Verlust durch Infiltration / Pertes par infiltration';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN surface_storage  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.surface_storage IS 'Loss by filing depressions in the surface / Verlust durch Muldenfüllung / Pertes par remplissage de dépressions';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN wetting_loss  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.wetting_loss IS 'Loss of wetting plantes and surface during rainfall / Verlust durch Haftung des Niederschlages an Pflanzen- und andere Oberfläche / Pertes par rétention des précipitations sur la végétation et autres surfaces';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.surface_runoff_parameters.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_surface_runoff_parameters
BEFORE UPDATE OR INSERT ON
 qgep_od.surface_runoff_parameters
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.measuring_point
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_measuring_point_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_measuring_point_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.measuring_point ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','measuring_point');
COMMENT ON COLUMN qgep_od.measuring_point.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.measuring_point ADD COLUMN damming_device  integer ;
COMMENT ON COLUMN qgep_od.measuring_point.damming_device IS '';
ALTER TABLE qgep_od.measuring_point ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.measuring_point.identifier IS '';
ALTER TABLE qgep_od.measuring_point ADD COLUMN kind  varchar(50) ;
COMMENT ON COLUMN qgep_od.measuring_point.kind IS 'yyy_Art der Untersuchungsstelle ( Regenmessungen, Abflussmessungen, etc.) / Art der Untersuchungsstelle ( Regenmessungen, Abflussmessungen, etc.) / Genre de mesure (mesures de pluviométrie, mesures de débit, etc.)';
ALTER TABLE qgep_od.measuring_point ADD COLUMN purpose  integer ;
COMMENT ON COLUMN qgep_od.measuring_point.purpose IS 'Purpose of measurement / Zweck der Messung / Objet de la mesure';
ALTER TABLE qgep_od.measuring_point ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.measuring_point.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.measuring_point ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_measuring_point_situation_geometry ON qgep_od.measuring_point USING gist (situation_geometry );
COMMENT ON COLUMN qgep_od.measuring_point.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE qgep_od.measuring_point ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.measuring_point.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.measuring_point ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.measuring_point.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.measuring_point ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.measuring_point.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measuring_point
BEFORE UPDATE OR INSERT ON
 qgep_od.measuring_point
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.measuring_device
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_measuring_device_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_measuring_device_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.measuring_device ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','measuring_device');
COMMENT ON COLUMN qgep_od.measuring_device.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.measuring_device ADD COLUMN brand  varchar(50) ;
COMMENT ON COLUMN qgep_od.measuring_device.brand IS 'Brand / Name of producer / Name des Herstellers / Nom du fabricant';
ALTER TABLE qgep_od.measuring_device ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.measuring_device.identifier IS '';
ALTER TABLE qgep_od.measuring_device ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.measuring_device.kind IS 'Type of measuring device / Typ des Messgerätes / Type de l''appareil de mesure';
ALTER TABLE qgep_od.measuring_device ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.measuring_device.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.measuring_device ADD COLUMN serial_number  varchar(50) ;
COMMENT ON COLUMN qgep_od.measuring_device.serial_number IS '';
ALTER TABLE qgep_od.measuring_device ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.measuring_device.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.measuring_device ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.measuring_device.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.measuring_device ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.measuring_device.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measuring_device
BEFORE UPDATE OR INSERT ON
 qgep_od.measuring_device
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.measurement_series
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_measurement_series_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_measurement_series_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.measurement_series ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','measurement_series');
COMMENT ON COLUMN qgep_od.measurement_series.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.measurement_series ADD COLUMN dimension  varchar(50) ;
COMMENT ON COLUMN qgep_od.measurement_series.dimension IS 'yyy_Messtypen (Einheit) / Messtypen (Einheit) / Types de mesures';
ALTER TABLE qgep_od.measurement_series ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.measurement_series.identifier IS '';
ALTER TABLE qgep_od.measurement_series ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.measurement_series.kind IS 'Type of measurment series / Art der Messreihe / Genre de série de mesures';
ALTER TABLE qgep_od.measurement_series ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.measurement_series.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.measurement_series ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.measurement_series.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.measurement_series ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.measurement_series.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.measurement_series ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.measurement_series.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measurement_series
BEFORE UPDATE OR INSERT ON
 qgep_od.measurement_series
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.measurement_result
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_measurement_result_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_measurement_result_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.measurement_result ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','measurement_result');
COMMENT ON COLUMN qgep_od.measurement_result.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.measurement_result ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.measurement_result.identifier IS '';
ALTER TABLE qgep_od.measurement_result ADD COLUMN measurement_type  integer ;
COMMENT ON COLUMN qgep_od.measurement_result.measurement_type IS 'Type of measurment, e.g. proportional to time or volume / Art der Messung, z.B zeit- oder mengenproportional / Type de mesure, par ex. proportionnel au temps ou au débit';
ALTER TABLE qgep_od.measurement_result ADD COLUMN measuring_duration  decimal(7,0) ;
COMMENT ON COLUMN qgep_od.measurement_result.measuring_duration IS 'Duration of measurment in seconds / Dauer der Messung in Sekunden / Durée de la mesure';
ALTER TABLE qgep_od.measurement_result ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.measurement_result.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.measurement_result ADD COLUMN time  timestamp without time zone ;
COMMENT ON COLUMN qgep_od.measurement_result.time IS 'Date and time at beginning of measurment / Zeitpunkt des Messbeginns / Date et heure du début de la mesure';
ALTER TABLE qgep_od.measurement_result ADD COLUMN value  real ;
COMMENT ON COLUMN qgep_od.measurement_result.value IS 'yyy_Gemessene Grösse / Gemessene Grösse / Valeur mesurée';
ALTER TABLE qgep_od.measurement_result ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.measurement_result.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.measurement_result ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.measurement_result.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.measurement_result ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.measurement_result.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measurement_result
BEFORE UPDATE OR INSERT ON
 qgep_od.measurement_result
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.overflow
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_overflow_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_overflow_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.overflow ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','overflow');
COMMENT ON COLUMN qgep_od.overflow.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.overflow ADD COLUMN actuation  integer ;
COMMENT ON COLUMN qgep_od.overflow.actuation IS 'Actuation of installation / Antrieb der Einbaute / Entraînement des installations';
ALTER TABLE qgep_od.overflow ADD COLUMN adjustability  integer ;
COMMENT ON COLUMN qgep_od.overflow.adjustability IS 'yyy_Möglichkeit zur Verstellung / Möglichkeit zur Verstellung / Possibilité de modifier la position';
ALTER TABLE qgep_od.overflow ADD COLUMN brand  varchar(50) ;
COMMENT ON COLUMN qgep_od.overflow.brand IS 'Manufacturer of the electro-mechaninc equipment or installation / Hersteller der elektro-mechanischen Ausrüstung oder Einrichtung / Fabricant d''équipement électromécanique ou d''installations';
ALTER TABLE qgep_od.overflow ADD COLUMN control  integer ;
COMMENT ON COLUMN qgep_od.overflow.control IS 'yyy_Steuer- und Regelorgan für die Einbaute / Steuer- und Regelorgan für die Einbaute / Dispositifs de commande et de régulation des installations';
ALTER TABLE qgep_od.overflow ADD COLUMN discharge_point  varchar(20) ;
COMMENT ON COLUMN qgep_od.overflow.discharge_point IS 'Identifier of discharge_point in which the overflow is discharging (redundant attribute with network follow up or result of that). Is only needed if overflow is discharging into a river (directly or via a rainwater drainage). Foreignkey to discharge_point in class catchement_area_totals in extension Stammkarte. / Bezeichnung der Einleitstelle in die der Ueberlauf entlastet (redundantes Attribut zur Netzverfolgung oder Resultat davon). Muss nur erfasst werden, wenn das Abwasser vom Notüberlauf in ein Gewässer eingeleitet wird (direkt oder über eine Regenabwasserleitung). Verknüpfung mit Fremdschlüssel zu Einleitstelle in Klasse Gesamteinzugsgebiet in Erweiterung Stammkarte. / Désignation de l''exutoire: A indiquer uniquement lorsque l’eau déversée est rejetée dans un cours d’eau (directement ou indirectement via une conduite d’eaux pluviales). Association à l''exutoire dans la classe BASSIN_VERSANT_COMPLET de l''extension fichier technique.';
ALTER TABLE qgep_od.overflow ADD COLUMN function  integer ;
COMMENT ON COLUMN qgep_od.overflow.function IS 'yyy_Teil des Mischwasserabflusses, der aus einem Überlauf in einen Vorfluter oder in ein Abwasserbauwerk abgeleitet wird / Teil des Mischwasserabflusses, der aus einem Überlauf in einen Vorfluter oder in ein Abwasserbauwerk abgeleitet wird / Type de déversoir';
ALTER TABLE qgep_od.overflow ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.overflow.gross_costs IS 'Gross costs / Brutto Erstellungskosten / Coûts bruts de réalisation';
ALTER TABLE qgep_od.overflow ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.overflow.identifier IS '';
ALTER TABLE qgep_od.overflow ADD COLUMN qon_dim  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.overflow.qon_dim IS 'yyy_Wassermenge, bei welcher der Überlauf gemäss Dimensionierung anspringt / Wassermenge, bei welcher der Überlauf gemäss Dimensionierung anspringt / Débit à partir duquel le déversoir devrait être fonctionnel (selon dimensionnement)';
ALTER TABLE qgep_od.overflow ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.overflow.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.overflow ADD COLUMN signal_transmission  integer ;
COMMENT ON COLUMN qgep_od.overflow.signal_transmission IS 'Signal or data transfer from or to a telecommunication station / Signalübermittlung von und zu einer Fernwirkanlage / Transmission des signaux de et vers une station de télécommande';
ALTER TABLE qgep_od.overflow ADD COLUMN subsidies  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.overflow.subsidies IS 'yyy_Staats- und Bundesbeiträge / Staats- und Bundesbeiträge / Contributions des cantons et de la confédération';
ALTER TABLE qgep_od.overflow ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.overflow.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.overflow ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.overflow.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.overflow ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.overflow.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_overflow
BEFORE UPDATE OR INSERT ON
 qgep_od.overflow
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.throttle_shut_off_unit
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_throttle_shut_off_unit_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_throttle_shut_off_unit_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.throttle_shut_off_unit ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','throttle_shut_off_unit');
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN actuation  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.actuation IS 'Actuation of the throttle or shut-off unit / Antrieb der Einbaute / Entraînement des installations';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN adjustability  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.adjustability IS 'Possibility to adjust the position / Möglichkeit zur Verstellung / Possibilité de modifier la position';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN control  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.control IS 'Open or closed loop control unit for the installation / Steuer- und Regelorgan für die Einbaute / Dispositifs de commande et de régulation des installations';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN cross_section  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.cross_section IS 'Cross section (geometric area) of throttle or shut-off unit / Geometrischer Drosselquerschnitt: Fgeom / Section géométrique de l''élément régulateur';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN effective_cross_section  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.effective_cross_section IS 'Effective cross section (area) / Wirksamer Drosselquerschnitt : Fid / Section du limiteur hydrauliquement active';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.gross_costs IS 'Gross costs / Brutto Erstellungskosten / Coûts bruts de réalisation';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.identifier IS '';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.kind IS 'Type of flow control / Art der Durchflussregulierung / Genre de régulation du débit';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN manufacturer  varchar(50) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.manufacturer IS 'Manufacturer of the electro-mechaninc equipment or installation / Hersteller der elektro-mech. Ausrüstung oder Einrichtung / Fabricant d''équipement électromécanique ou d''installations';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN signal_transmission  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.signal_transmission IS 'Signal or data transfer from or to a telecommunication station sending_receiving / Signalübermittlung von und zu einer Fernwirkanlage / Transmission des signaux de et vers une station de télécommande';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN subsidies  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.subsidies IS 'yyy_Staats- und Bundesbeiträge / Staats- und Bundesbeiträge / Contributions des cantons et de la confédération';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN throttle_unit_opening_current  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.throttle_unit_opening_current IS 'yyy_Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine zusätzlichen Angaben. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine zusätzlichen Angaben. Pumpe: zusätzlich in Stammkarte Pumpwerk erfassen / Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine zusätzlichen Angaben. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine zusätzlichen Angaben. Pumpe: zusätzlich in Stammkarte Pumpwerk erfassen / Les valeurs suivantes doivent être indiquées: Leaping weir: Longueur ouverture de fond, Cond. d’étranglement : aucune indication suppl., Vanne : hauteur max de l’ouverture (du radier jusqu’au bord inférieur plaque, point le plus bas), Régulateur de débit : aucune indication suppl., Pompe : saisir fiche technique STAP';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN throttle_unit_opening_current_optimized  integer ;
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.throttle_unit_opening_current_optimized IS 'yyy_Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine zusätzlichen Angaben. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine zusätzlichen Angaben. Pumpe: zusätzlich in Stammkarte Pumpwerk erfassen / Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine zusätzlichen Angaben. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine zusätzlichen Angaben. Pumpe: zusätzlich in Stammkarte Pumpwerk erfassen / Les valeurs suivantes doivent être indiquées: Leaping weir: Longueur ouverture de fond, Cond. d’étranglement : aucune indication suppl., Vanne : hauteur max de l’ouverture (du radier jusqu’au bord inférieur plaque, point le plus bas), Régulateur de débit : aucune indication suppl., Pompe : saisir fiche technique STAP';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.throttle_shut_off_unit.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_throttle_shut_off_unit
BEFORE UPDATE OR INSERT ON
 qgep_od.throttle_shut_off_unit
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.prank_weir
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_prank_weir_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_prank_weir_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.prank_weir ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','prank_weir');
COMMENT ON COLUMN qgep_od.prank_weir.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.prank_weir ADD COLUMN hydraulic_overflow_length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.prank_weir.hydraulic_overflow_length IS 'yyy_Hydraulisch wirksame Wehrlänge / Hydraulisch wirksame Wehrlänge / Longueur du déversoir hydrauliquement active';
ALTER TABLE qgep_od.prank_weir ADD COLUMN level_max  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.prank_weir.level_max IS 'yyy_Höhe des höchsten Punktes der Überfallkante / Höhe des höchsten Punktes der Überfallkante / Niveau max. de la crête déversante';
ALTER TABLE qgep_od.prank_weir ADD COLUMN level_min  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.prank_weir.level_min IS 'yyy_Höhe des tiefsten Punktes der Überfallkante / Höhe des tiefsten Punktes der Überfallkante / Niveau min. de la crête déversante';
ALTER TABLE qgep_od.prank_weir ADD COLUMN weir_edge  integer ;
COMMENT ON COLUMN qgep_od.prank_weir.weir_edge IS 'yyy_Ausbildung der Überfallkante / Ausbildung der Überfallkante / Forme de la crête';
ALTER TABLE qgep_od.prank_weir ADD COLUMN weir_kind  integer ;
COMMENT ON COLUMN qgep_od.prank_weir.weir_kind IS 'yyy_Art der Wehrschweille des Streichwehrs / Art der Wehrschwelle des Streichwehrs / Genre de surverse du déversoir latéral';
-------
CREATE TRIGGER
update_last_modified_prank_weir
BEFORE UPDATE OR INSERT ON
 qgep_od.prank_weir
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.overflow");

-------
-------
CREATE TABLE qgep_od.pump
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_pump_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_pump_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.pump ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','pump');
COMMENT ON COLUMN qgep_od.pump.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.pump ADD COLUMN construction_type  integer ;
COMMENT ON COLUMN qgep_od.pump.construction_type IS 'Types of pumps / Pumpenarten / Types de pompe';
ALTER TABLE qgep_od.pump ADD COLUMN operating_point  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.pump.operating_point IS 'Flow for pumps with fixed operating point / Fördermenge für Pumpen mit fixem Arbeitspunkt / Débit refoulé par la pompe avec point de travail fixe';
ALTER TABLE qgep_od.pump ADD COLUMN placement_of_actuation  integer ;
COMMENT ON COLUMN qgep_od.pump.placement_of_actuation IS 'Type of placement of the actuation / Art der Aufstellung des Motors / Genre de montage';
ALTER TABLE qgep_od.pump ADD COLUMN placement_of_pump  integer ;
COMMENT ON COLUMN qgep_od.pump.placement_of_pump IS 'Type of placement of the pomp / Art der Aufstellung der Pumpe / Genre de montage de la pompe';
ALTER TABLE qgep_od.pump ADD COLUMN pump_flow_max_single  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.pump.pump_flow_max_single IS 'yyy_Maximaler Förderstrom der Pumpen (einzeln als Bauwerkskomponente). Tritt in der Regel bei der minimalen Förderhöhe ein. / Maximaler Förderstrom der Pumpe (einzeln als Bauwerkskomponente). Tritt in der Regel bei der minimalen Förderhöhe ein. / Débit de refoulement maximal des pompes individuelles en tant que composante d’ouvrage. Survient normalement à la hauteur min de refoulement.';
ALTER TABLE qgep_od.pump ADD COLUMN pump_flow_min_single  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.pump.pump_flow_min_single IS 'yyy_Minimaler Förderstrom der Pumpe (einzeln als Bauwerkskomponente). Tritt in der Regel bei der maximalen Förderhöhe ein. / Minimaler Förderstrom der Pumpe (einzeln als Bauwerkskomponente). Tritt in der Regel bei der maximalen Förderhöhe ein. / Débit de refoulement maximal de toutes les pompes de l’ouvrage (STAP) ou des pompes individuelles en tant que composante d’ouvrage. Survient normalement à la hauteur min de refoulement.';
ALTER TABLE qgep_od.pump ADD COLUMN start_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.pump.start_level IS 'yyy_Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe eingeschaltet wird (Einschaltkote) / Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe eingeschaltet wird (Einschaltkote) / Cote du niveau d''eau dans le puisard à laquelle s''enclenche la pompe';
ALTER TABLE qgep_od.pump ADD COLUMN stop_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.pump.stop_level IS 'yyy_Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe ausgeschaltet wird (Ausschaltkote) / Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe ausgeschaltet wird (Ausschaltkote) / Cote du niveau d''eau dans le puisard à laquelle s''arrête la pompe';
ALTER TABLE qgep_od.pump ADD COLUMN usage_current  integer ;
COMMENT ON COLUMN qgep_od.pump.usage_current IS 'yyy_Nutzungsart_Ist des gepumpten Abwassers. / Nutzungsart_Ist des gepumpten Abwassers. / Genre d''utilisation actuel de l''eau usée pompée';
-------
CREATE TRIGGER
update_last_modified_pump
BEFORE UPDATE OR INSERT ON
 qgep_od.pump
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.overflow");

-------
-------
CREATE TABLE qgep_od.leapingweir
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_leapingweir_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_leapingweir_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.leapingweir ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','leapingweir');
COMMENT ON COLUMN qgep_od.leapingweir.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.leapingweir ADD COLUMN length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.leapingweir.length IS 'yyy_Maximale Abmessung der Bodenöffnung in Fliessrichtung / Maximale Abmessung der Bodenöffnung in Fliessrichtung / Dimension maximale de l''ouverture de fond parallèlement au courant';
ALTER TABLE qgep_od.leapingweir ADD COLUMN opening_shape  integer ;
COMMENT ON COLUMN qgep_od.leapingweir.opening_shape IS 'Shape of opening in the floor / Form der  Bodenöffnung / Forme de l''ouverture de fond';
ALTER TABLE qgep_od.leapingweir ADD COLUMN width  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.leapingweir.width IS 'yyy_Maximale Abmessung der Bodenöffnung quer zur Fliessrichtung / Maximale Abmessung der Bodenöffnung quer zur Fliessrichtung / Dimension maximale de l''ouverture de fond perpendiculairement à la direction d''écoulement';
-------
CREATE TRIGGER
update_last_modified_leapingweir
BEFORE UPDATE OR INSERT ON
 qgep_od.leapingweir
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.overflow");

-------
-------
CREATE TABLE qgep_od.hydraulic_char_data
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_hydraulic_char_data_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_hydraulic_char_data_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.hydraulic_char_data ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','hydraulic_char_data');
COMMENT ON COLUMN qgep_od.hydraulic_char_data.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN aggregate_number  smallint ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.aggregate_number IS '';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN delivery_height_geodaetic  decimal(6,2) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.delivery_height_geodaetic IS '';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN identifier  varchar(20) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.identifier IS '';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN is_overflowing  integer ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.is_overflowing IS 'yyy_Angabe, ob die Entlastung beim Dimensionierungsereignis anspringt / Angabe, ob die Entlastung beim Dimensionierungsereignis anspringt / Indication, si le déversoir déverse lors des événements pour lesquels il a été dimensionné.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN main_weir_kind  integer ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.main_weir_kind IS 'yyy_Art des Hauptwehrs am Knoten, falls mehrere Überläufe / Art des Hauptwehrs am Knoten, falls mehrere Überläufe / Genre du déversoir principal du noeud concerné s''il y a plusieurs déversoirs.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN overcharge  decimal (5,2) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.overcharge IS 'yyy_Optimale Mehrbelastung nach der Umsetzung der Massnahmen. / Ist: Mehrbelastung der untenliegenden Kanäle beim Dimensionierungsereignis = 100 * (Qab – Qan) / Qan 	[%]. Verhältnis zwischen der abgeleiteten Abwassermengen Richtung ARA beim Anspringen des Entlastungsbauwerkes (Qan) und Qab (Abwassermenge, welche beim Dimensionierungsereignis (z=5) weiter im Kanalnetz Richtung Abwasserreinigungsanlage abgeleitet wird). Beispiel: Qan = 100 l/s, Qab = 150 l/s -> Mehrbelastung = 50%; Ist_optimiert: Optimale Mehrbelastung im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen; geplant: Optimale Mehrbelastung nach der Umsetzung der Massnahmen. / Etat actuel: Surcharge optimale à l’état actuel avant la réalisation d’éventuelles mesures;  actuel optimisé: Surcharge optimale à l’état actuel avant la réalisation d’éventuelles mesures; prévu: Optimale Mehrbelastung nach der Umsetzung der Massnahmen.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN overflow_duration  decimal(6,1) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.overflow_duration IS 'yyy_Mittlere Überlaufdauer pro Jahr. Bei Ist_Zustand: Berechnung mit geplanten Massnahmen. Bei Ist_optimiert:  Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit geplanten Massnahmen / Mittlere Überlaufdauer pro Jahr. Bei Ist_Zustand: Berechnung mit geplanten Massnahmen. Bei Ist_optimiert:  Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit geplanten Massnahmen / Durée moyenne de déversement par an.  Actuel: Durée moyenne de déversement par an selon des simulations pour de longs temps de retour (z > 10). Actuel optimizé: Calcul en mode optimal à l’état actuel avant la réalisation d’éventuelles mesures. Prévu: Calcul selon les mesures planifiées';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN overflow_freight  integer ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.overflow_freight IS 'yyy_Mittlere Ueberlaufschmutzfracht pro Jahr / Mittlere Ueberlaufschmutzfracht pro Jahr / Charge polluante moyenne déversée par année';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN overflow_frequency  decimal(3,1) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.overflow_frequency IS 'yyy_Mittlere Überlaufhäufigkeit pro Jahr. Ist Zustand: Durchschnittliche Überlaufhäufigkeit pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation (Dauer mindestens 10 Jahre). Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen / Mittlere Überlaufhäufigkeit pro Jahr. Ist Zustand: Durchschnittliche Überlaufhäufigkeit pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation (Dauer mindestens 10 Jahre). Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen / Fréquence moyenne de déversement par an. Fréquence moyenne de déversement par an selon des simulations pour de longs temps de retour (z > 10). Actuel optimizé: Calcul en mode optimal à l’état actuel avant la réalisation d’éventuelles mesures. Prévu: Calcul après la réalisation d’éventuelles mesures.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN overflow_volume  decimal(9,2) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.overflow_volume IS 'yyy_Mittlere Überlaufwassermenge pro Jahr. Durchschnittliche Überlaufmenge pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation (Dauer mindestens 10 Jahre). Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen / Mittlere Überlaufwassermenge pro Jahr. Durchschnittliche Überlaufmenge pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation (Dauer mindestens 10 Jahre). Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen / Volume moyen déversé par an. Volume moyen déversé par an selon des simulations pour de longs temps de retour (z > 10). Actuel optimizé: Calcul en mode optimal à l’état actuel avant la réalisation d’éventuelles mesures. Prévu: Calcul après la réalisation d’éventuelles mesures.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN pump_characteristics  integer ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.pump_characteristics IS 'yyy_Bei speziellen Betriebsarten ist die Funktion separat zu dokumentieren und der Stammkarte beizulegen. / Bei speziellen Betriebsarten ist die Funktion separat zu dokumentieren und der Stammkarte beizulegen. / Pour de régime de fonctionnement spéciaux, cette fonction doit être documentée séparément et annexée à la fiche technique';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN pump_flow_max  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.pump_flow_max IS 'yyy_Maximaler Förderstrom der Pumpen (gesamtes Bauwerk). Tritt in der Regel bei der minimalen Förderhöhe ein. / Maximaler Förderstrom der Pumpen (gesamtes Bauwerk). Tritt in der Regel bei der minimalen Förderhöhe ein. / Débit de refoulement maximal de toutes les pompes de l’ouvrage. Survient normalement à la hauteur min de refoulement.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN pump_flow_min  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.pump_flow_min IS 'yyy_Minimaler Förderstrom der Pumpen zusammen (gesamtes Bauwerk). Tritt in der Regel bei der maximalen Förderhöhe ein. / Minimaler Förderstrom der Pumpen zusammen (gesamtes Bauwerk). Tritt in der Regel bei der maximalen Förderhöhe ein. / Débit de refoulement minimal de toutes les pompes de l’ouvrage. Survient normalement à la hauteur max de refoulement.';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN pump_usage_current  integer ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.pump_usage_current IS 'yyy_Nutzungsart_Ist des gepumpten Abwassers. / Nutzungsart_Ist des gepumpten Abwassers. / Genre d''utilisation actuel de l''eau usée pompée';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN q_discharge  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.q_discharge IS 'yyy_Qab gemäss GEP / Qab gemäss GEP / Qeff selon PGEE';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN qon  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.qon IS 'yyy_Wassermenge, bei welcher der Überlauf anspringt / Wassermenge, bei welcher der Überlauf anspringt / Débit à partir duquel le déversoir devrait être fonctionnel';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN status  integer ;
COMMENT ON COLUMN qgep_od.hydraulic_char_data.status IS 'yyy_Planungszustand der Hydraulischen Kennwerte (zwingend). Ueberlaufcharakteristik und Gesamteinzugsgebiet kann für verschiedene Stati gebildet werden und leitet sich aus dem Status der Hydr_Kennwerte ab. / Planungszustand der Hydraulischen Kennwerte (zwingend). Ueberlaufcharakteristik und Gesamteinzugsgebiet kann für verschiedene Stati gebildet werden und leitet sich aus dem Status der Hydr_Kennwerte ab. / Etat prévu des caractéristiques hydrauliques (obligatoire). Les caractéristiques de déversement et le bassin versant global peuvent être représentés à différents états et se laissent déduire à partir de l’attribut PARAMETRES_HYDR';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.hydraulic_char_data.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.hydraulic_char_data.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.hydraulic_char_data.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hydraulic_char_data
BEFORE UPDATE OR INSERT ON
 qgep_od.hydraulic_char_data
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.backflow_prevention
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_backflow_prevention_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_backflow_prevention_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.backflow_prevention ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','backflow_prevention');
COMMENT ON COLUMN qgep_od.backflow_prevention.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.backflow_prevention ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.backflow_prevention.gross_costs IS 'Gross costs / Brutto Erstellungskosten / Coûts bruts de réalisation';
ALTER TABLE qgep_od.backflow_prevention ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.backflow_prevention.kind IS 'Ist keine Rückstausicherung vorhanden, wird keine Rueckstausicherung erfasst. /  Ist keine Rückstausicherung vorhanden, wird keine Rueckstausicherung erfasst / En absence de protection, laisser la composante vide';
ALTER TABLE qgep_od.backflow_prevention ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.backflow_prevention.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der Rückstausicherung voraussichtlich abläuft / Jahr in dem die Lebensdauer der Rückstausicherung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_backflow_prevention
BEFORE UPDATE OR INSERT ON
 qgep_od.backflow_prevention
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.solids_retention
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_solids_retention_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_solids_retention_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.solids_retention ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','solids_retention');
COMMENT ON COLUMN qgep_od.solids_retention.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.solids_retention ADD COLUMN dimensioning_value  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.solids_retention.dimensioning_value IS 'yyy_Wassermenge, Dimensionierungswert des Feststoffrückhaltes / Wassermenge, Dimensionierungswert des Feststoffrückhaltes / Volume, débit de dimensionnement';
ALTER TABLE qgep_od.solids_retention ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.solids_retention.gross_costs IS 'Gross costs of electromechanical equipment / Brutto Erstellungskosten der elektromechnischen Ausrüstung für die Beckenentleerung / Coûts bruts des équipements électromécaniques';
ALTER TABLE qgep_od.solids_retention ADD COLUMN overflow_level  decimal(7,3) ;
COMMENT ON COLUMN qgep_od.solids_retention.overflow_level IS 'Overflow level of solids retention in in m.a.sl. / Anspringkote Feststoffrückhalt in m.ü.M. / Cote du début du déversement de la retenue de matières solides en m.s.m.';
ALTER TABLE qgep_od.solids_retention ADD COLUMN type  integer ;
COMMENT ON COLUMN qgep_od.solids_retention.type IS 'yyy_(Elektromechanische) Teile zum Feststoffrückhalt eines Bauwerks / (Elektromechanische) Teile zum Feststoffrückhalt eines Bauwerks / Eléments (électromécaniques) pour la retenue de matières solides d’un ouvrage';
ALTER TABLE qgep_od.solids_retention ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.solids_retention.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_solids_retention
BEFORE UPDATE OR INSERT ON
 qgep_od.solids_retention
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.tank_cleaning
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_tank_cleaning_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_tank_cleaning_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.tank_cleaning ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','tank_cleaning');
COMMENT ON COLUMN qgep_od.tank_cleaning.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.tank_cleaning ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.tank_cleaning.gross_costs IS 'Gross costs of electromechanical equipment of tank cleaning / Brutto Erstellungskosten der elektromechnischen Ausrüstung für die Beckenreinigung / Coûts bruts des équipements électromécaniques nettoyage de bassins';
ALTER TABLE qgep_od.tank_cleaning ADD COLUMN type  integer ;
COMMENT ON COLUMN qgep_od.tank_cleaning.type IS '';
ALTER TABLE qgep_od.tank_cleaning ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.tank_cleaning.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_tank_cleaning
BEFORE UPDATE OR INSERT ON
 qgep_od.tank_cleaning
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.tank_emptying
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_tank_emptying_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_tank_emptying_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.tank_emptying ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','tank_emptying');
COMMENT ON COLUMN qgep_od.tank_emptying.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.tank_emptying ADD COLUMN flow  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.tank_emptying.flow IS 'yyy_Bei mehreren Pumpen / Schiebern muss die maximale Gesamtmenge erfasst werden. / Bei mehreren Pumpen / Schiebern muss die maximale Gesamtmenge erfasst werden. / Lors de présence de plusieurs pompes/vannes, indiquer le débit total.';
ALTER TABLE qgep_od.tank_emptying ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN qgep_od.tank_emptying.gross_costs IS 'Gross costs of electromechanical equipment of tank emptying / Brutto Erstellungskosten der elektromechnischen Ausrüstung für die Beckenentleerung / Coûts bruts des équipements électromécaniques vidange de bassins';
ALTER TABLE qgep_od.tank_emptying ADD COLUMN type  integer ;
COMMENT ON COLUMN qgep_od.tank_emptying.type IS '';
ALTER TABLE qgep_od.tank_emptying ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN qgep_od.tank_emptying.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_tank_emptying
BEFORE UPDATE OR INSERT ON
 qgep_od.tank_emptying
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.structure_part");

-------
-------
CREATE TABLE qgep_od.param_ca_general
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_param_ca_general_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_param_ca_general_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.param_ca_general ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','param_ca_general');
COMMENT ON COLUMN qgep_od.param_ca_general.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.param_ca_general ADD COLUMN dry_wheather_flow  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.param_ca_general.dry_wheather_flow IS 'Dry wheather flow / Débit temps sec';
ALTER TABLE qgep_od.param_ca_general ADD COLUMN flow_path_length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.param_ca_general.flow_path_length IS 'Length of flow path / Fliessweglänge / longueur de la ligne d''écoulement';
ALTER TABLE qgep_od.param_ca_general ADD COLUMN flow_path_slope  smallint ;
COMMENT ON COLUMN qgep_od.param_ca_general.flow_path_slope IS 'Slope of flow path [%o] / Fliessweggefälle [%o] / Pente de la ligne d''écoulement [%o]';
ALTER TABLE qgep_od.param_ca_general ADD COLUMN population_equivalent  integer ;
COMMENT ON COLUMN qgep_od.param_ca_general.population_equivalent IS '';
ALTER TABLE qgep_od.param_ca_general ADD COLUMN surface_ca  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.param_ca_general.surface_ca IS 'yyy_Surface bassin versant MOUSE1 / Fläche des Einzugsgebietes für MOUSE1 / Surface bassin versant MOUSE1';
-------
CREATE TRIGGER
update_last_modified_param_ca_general
BEFORE UPDATE OR INSERT ON
 qgep_od.param_ca_general
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.surface_runoff_parameters");

-------
-------
CREATE TABLE qgep_od.param_ca_mouse1
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_param_ca_mouse1_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_param_ca_mouse1_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.param_ca_mouse1 ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','param_ca_mouse1');
COMMENT ON COLUMN qgep_od.param_ca_mouse1.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.param_ca_mouse1 ADD COLUMN dry_wheather_flow  decimal(9,3) ;
COMMENT ON COLUMN qgep_od.param_ca_mouse1.dry_wheather_flow IS 'Parameter for calculation of surface runoff for surface runoff modell A1 / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE';
ALTER TABLE qgep_od.param_ca_mouse1 ADD COLUMN flow_path_length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.param_ca_mouse1.flow_path_length IS 'yyy_Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE';
ALTER TABLE qgep_od.param_ca_mouse1 ADD COLUMN flow_path_slope  smallint ;
COMMENT ON COLUMN qgep_od.param_ca_mouse1.flow_path_slope IS 'yyy_Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE [%o] / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE [%o] / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE [%o]';
ALTER TABLE qgep_od.param_ca_mouse1 ADD COLUMN population_equivalent  integer ;
COMMENT ON COLUMN qgep_od.param_ca_mouse1.population_equivalent IS '';
ALTER TABLE qgep_od.param_ca_mouse1 ADD COLUMN surface_ca_mouse  decimal(8,2) ;
COMMENT ON COLUMN qgep_od.param_ca_mouse1.surface_ca_mouse IS 'yyy_Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE';
ALTER TABLE qgep_od.param_ca_mouse1 ADD COLUMN usage  varchar(50) ;
COMMENT ON COLUMN qgep_od.param_ca_mouse1.usage IS 'Classification based on surface runoff modell MOUSE 2000/2001 / Klassifikation gemäss Oberflächenabflussmodell von MOUSE 2000/2001 / Classification selon le modèle surface de MOUSE 2000/2001';
-------
CREATE TRIGGER
update_last_modified_param_ca_mouse1
BEFORE UPDATE OR INSERT ON
 qgep_od.param_ca_mouse1
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.surface_runoff_parameters");

-------
------------ Relationships and Value Tables ----------- ;
ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD CONSTRAINT rel_maintenance_event_wastewater_structure_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD COLUMN fk_maintenance_event varchar (16);
ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD CONSTRAINT rel_maintenance_event_wastewater_structure_maintenance_event FOREIGN KEY (fk_maintenance_event) REFERENCES qgep_od.maintenance_event(obj_id) ON UPDATE CASCADE ON DELETE cascade;
--ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD COLUMN fk_wastewater_structure varchar (16);
--ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD CONSTRAINT rel_maintenance_event_wastewater_structure_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade;
--ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD COLUMN fk_maintenance_event varchar (16);
--ALTER TABLE qgep_od.re_maintenance_event_wastewater_structure ADD CONSTRAINT rel_maintenance_event_wastewater_structure_maintenance_event FOREIGN KEY (fk_maintenance_event) REFERENCES qgep_od.maintenance_event(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.symbol_plantype () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.symbol_plantype ADD CONSTRAINT pkey_qgep_vl_symbol_plantype_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7874,7874,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7876,7876,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7877,7877,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7878,7878,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7875,7875,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.txt_symbol ADD CONSTRAINT fkey_vl_symbol_plantype FOREIGN KEY (plantype)
 REFERENCES qgep_vl.symbol_plantype (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.txt_symbol ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.txt_symbol ADD CONSTRAINT rel_symbol_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE cascade;
CREATE TABLE qgep_vl.text_plantype () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.text_plantype ADD CONSTRAINT pkey_qgep_vl_text_plantype_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', '', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.txt_text ADD CONSTRAINT fkey_vl_text_plantype FOREIGN KEY (plantype)
 REFERENCES qgep_vl.text_plantype (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.text_texthali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.text_texthali ADD CONSTRAINT pkey_qgep_vl_text_texthali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.txt_text ADD CONSTRAINT fkey_vl_text_texthali FOREIGN KEY (texthali)
 REFERENCES qgep_vl.text_texthali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.text_textvali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.text_textvali ADD CONSTRAINT pkey_qgep_vl_text_textvali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.txt_text ADD CONSTRAINT fkey_vl_text_textvali FOREIGN KEY (textvali)
 REFERENCES qgep_vl.text_textvali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.txt_text ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.txt_text ADD CONSTRAINT rel_text_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE cascade;
ALTER TABLE qgep_od.txt_text ADD COLUMN fk_catchment_area varchar (16);
ALTER TABLE qgep_od.txt_text ADD CONSTRAINT rel_text_catchment_area FOREIGN KEY (fk_catchment_area) REFERENCES qgep_od.catchment_area(obj_id) ON DELETE cascade;
ALTER TABLE qgep_od.txt_text ADD COLUMN fk_reach varchar (16);
ALTER TABLE qgep_od.txt_text ADD CONSTRAINT rel_text_reach FOREIGN KEY (fk_reach) REFERENCES qgep_od.reach(obj_id) ON DELETE cascade;
CREATE TABLE qgep_vl.mutation_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.mutation_kind ADD CONSTRAINT pkey_qgep_vl_mutation_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.mutation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5523,5523,'created','erstellt','cree', 'zzz_erstellt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mutation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5582,5582,'changed','geaendert','changee', 'zzz_geaendert', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mutation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5583,5583,'deleted','geloescht','effacee', 'zzz_geloescht', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.mutation ADD CONSTRAINT fkey_vl_mutation_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.mutation_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.river ADD CONSTRAINT oorel_od_river_surface_water_bodies FOREIGN KEY (obj_id) REFERENCES qgep_od.surface_water_bodies(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.river_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_kind ADD CONSTRAINT pkey_qgep_vl_river_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3397,3397,'englacial_river','Gletscherbach','ruisseau_de_glacier', 'zzz_Gletscherbach', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3399,3399,'moor_creek','Moorbach','ruisseau_de_tourbiere', 'zzz_Moorbach', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3398,3398,'lake_outflow','Seeausfluss','effluent_d_un_lac', 'zzz_Seeausfluss', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3396,3396,'travertine_river','Travertinbach','ruisseau_sur_fond_tufcalcaire', 'zzz_Travertinbach', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3400,3400,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river ADD CONSTRAINT fkey_vl_river_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.river_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.lake ADD CONSTRAINT oorel_od_lake_surface_water_bodies FOREIGN KEY (obj_id) REFERENCES qgep_od.surface_water_bodies(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.water_course_segment_algae_growth () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_algae_growth ADD CONSTRAINT pkey_qgep_vl_water_course_segment_algae_growth_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_algae_growth (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2623,2623,'none_or_marginal','kein_gering','absent_faible', 'zzz_kein_gering', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_algae_growth (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2624,2624,'moderate_to_strong','maessig_stark','moyen_fort', 'zzz_maessig_stark', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_algae_growth (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2625,2625,'excessive_rampant','uebermaessig_wuchernd','tres_fort_proliferation', 'zzz_uebermaessig_wuchernd', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_algae_growth (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3050,3050,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_algae_growth FOREIGN KEY (algae_growth)
 REFERENCES qgep_vl.water_course_segment_algae_growth (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_altitudinal_zone () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_altitudinal_zone ADD CONSTRAINT pkey_qgep_vl_water_course_segment_altitudinal_zone_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_altitudinal_zone (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (320,320,'alpine','alpin','alpin', 'zzz_alpin', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_altitudinal_zone (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (294,294,'foothill_zone','kollin','des_collines', 'zzz_kollin', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_altitudinal_zone (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (295,295,'montane','montan','montagnard', 'zzz_montan', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_altitudinal_zone (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (319,319,'subalpine','subalpin','subalpin', 'zzz_subalpin', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_altitudinal_zone (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3020,3020,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_altitudinal_zone FOREIGN KEY (altitudinal_zone)
 REFERENCES qgep_vl.water_course_segment_altitudinal_zone (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_dead_wood () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_dead_wood ADD CONSTRAINT pkey_qgep_vl_water_course_segment_dead_wood_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_dead_wood (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2629,2629,'accumulations','Ansammlungen','amas', 'zzz_Ansammlungen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_dead_wood (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2631,2631,'none_or_sporadic','kein_vereinzelt','absent_localise', 'zzz_kein_vereinzelt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_dead_wood (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3052,3052,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_dead_wood (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2630,2630,'scattered','zerstreut','dissemine', 'zzz_zerstreut', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_dead_wood FOREIGN KEY (dead_wood)
 REFERENCES qgep_vl.water_course_segment_dead_wood (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_depth_variability () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_depth_variability ADD CONSTRAINT pkey_qgep_vl_water_course_segment_depth_variability_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_depth_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2617,2617,'pronounced','ausgepraegt','prononcee', 'zzz_ausgepraegt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_depth_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2619,2619,'none','keine','aucune', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_depth_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2618,2618,'moderate','maessig','moyenne', 'zzz_maessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_depth_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3049,3049,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_depth_variability FOREIGN KEY (depth_variability)
 REFERENCES qgep_vl.water_course_segment_depth_variability (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_discharge_regime () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_discharge_regime ADD CONSTRAINT pkey_qgep_vl_water_course_segment_discharge_regime_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_discharge_regime (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (297,297,'compromised','beeintraechtigt','modifie', 'zzz_beeintraechtigt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_discharge_regime (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (428,428,'artificial','kuenstlich','artificiel', 'zzz_kuenstlich', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_discharge_regime (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (427,427,'hardly_natural','naturfern','peu_naturel', 'zzz_naturfern', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_discharge_regime (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (296,296,'close_to_natural','naturnah','presque_naturel', 'zzz_naturnah', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_discharge_regime (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3091,3091,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_discharge_regime FOREIGN KEY (discharge_regime)
 REFERENCES qgep_vl.water_course_segment_discharge_regime (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_ecom_classification () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_ecom_classification ADD CONSTRAINT pkey_qgep_vl_water_course_segment_ecom_classification_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_ecom_classification (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3496,3496,'covered','eingedolt','mis_sous_terre', 'zzz_eingedolt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_ecom_classification (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3495,3495,'artificial','kuenstlich_naturfremd','artificiel_peu_naturel', 'zzz_kuenstlich_naturfremd', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_ecom_classification (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3492,3492,'natural_or_seminatural','natuerlich_naturnah','naturel_presque_naturel', 'zzz_natuerlich_naturnah', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_ecom_classification (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3491,3491,'not_classified','nicht_klassiert','pas_classifie', 'zzz_nicht_klassiert', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_ecom_classification (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3494,3494,'heavily_compromised','stark_beeintraechtigt','fortement_modifie', 'zzz_stark_beeintraechtigt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_ecom_classification (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3493,3493,'partially_compromised','wenig_beeintraechtigt','peu_modifie', 'zzz_wenig_beeintraechtigt', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_ecom_classification FOREIGN KEY (ecom_classification)
 REFERENCES qgep_vl.water_course_segment_ecom_classification (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_kind ADD CONSTRAINT pkey_qgep_vl_water_course_segment_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2710,2710,'covered','eingedolt','mis_sous_terre', 'zzz_eingedolt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2709,2709,'open','offen','ouvert', 'zzz_offen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3058,3058,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.water_course_segment_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_length_profile () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_length_profile ADD CONSTRAINT pkey_qgep_vl_water_course_segment_length_profile_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_length_profile (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (97,97,'downwelling','kaskadenartig','avec_des_cascades', 'zzz_kaskadenartig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_length_profile (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3602,3602,'rapids_or_potholes','Schnellen_Kolke','avec_rapides_marmites', 'zzz_Schnellen_Kolke', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_length_profile (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (99,99,'continuous','stetig','continu', 'zzz_stetig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_length_profile (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3035,3035,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_length_profile FOREIGN KEY (length_profile)
 REFERENCES qgep_vl.water_course_segment_length_profile (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_macrophyte_coverage () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_macrophyte_coverage ADD CONSTRAINT pkey_qgep_vl_water_course_segment_macrophyte_coverage_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_macrophyte_coverage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2626,2626,'none_or_marginal','kein_gering','absent_faible', 'zzz_kein_gering', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_macrophyte_coverage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2627,2627,'moderate_to_strong','maessig_stark','moyen_fort', 'zzz_maessig_stark', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_macrophyte_coverage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2628,2628,'excessive_rampant','uebermaessig_wuchernd','tres_fort_proliferation', 'zzz_uebermaessig_wuchernd', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_macrophyte_coverage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3051,3051,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_macrophyte_coverage FOREIGN KEY (macrophyte_coverage)
 REFERENCES qgep_vl.water_course_segment_macrophyte_coverage (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_section_morphology () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_section_morphology ADD CONSTRAINT pkey_qgep_vl_water_course_segment_section_morphology_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_section_morphology (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4575,4575,'straight','gerade','rectiligne', 'zzz_gerade', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_section_morphology (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4580,4580,'moderately_bent','leichtbogig','legerement_incurve', 'zzz_leichtbogig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_section_morphology (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4579,4579,'meandering','maeandrierend','en_meandres', 'zzz_maeandrierend', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_section_morphology (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4578,4578,'heavily_bent','starkbogig','fortement_incurve', 'zzz_starkbogig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_section_morphology (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4576,4576,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_section_morphology FOREIGN KEY (section_morphology)
 REFERENCES qgep_vl.water_course_segment_section_morphology (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_slope () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_slope ADD CONSTRAINT pkey_qgep_vl_water_course_segment_slope_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_slope (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (291,291,'shallow_dipping','flach','plat', 'piano', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_slope (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (292,292,'moderate_slope','mittel','moyen', 'medio', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_slope (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (293,293,'steep','steil','raide', 'ripido', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_slope (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3019,3019,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_slope FOREIGN KEY (slope)
 REFERENCES qgep_vl.water_course_segment_slope (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_utilisation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_utilisation ADD CONSTRAINT pkey_qgep_vl_water_course_segment_utilisation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_utilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (384,384,'recreation','Erholung','detente', 'zzz_Erholung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_utilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (429,429,'fishing','Fischerei','peche', 'zzz_Fischerei', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_utilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (385,385,'dam','Stauanlage','installation_de_retenue', 'zzz_Stauanlage', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_utilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3039,3039,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_utilisation FOREIGN KEY (utilisation)
 REFERENCES qgep_vl.water_course_segment_utilisation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_water_hardness () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_water_hardness ADD CONSTRAINT pkey_qgep_vl_water_course_segment_water_hardness_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_water_hardness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (321,321,'limestone','Kalk','calcaire', 'zzz_Kalk', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_water_hardness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (322,322,'silicate','Silikat','silicieuse', 'zzz_Silikat', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_water_hardness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3024,3024,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_water_hardness FOREIGN KEY (water_hardness)
 REFERENCES qgep_vl.water_course_segment_water_hardness (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.water_course_segment_width_variability () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_course_segment_width_variability ADD CONSTRAINT pkey_qgep_vl_water_course_segment_width_variability_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_course_segment_width_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (176,176,'pronounced','ausgepraegt','prononcee', 'zzz_ausgepraegt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_width_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (177,177,'limited','eingeschraenkt','limitee', 'zzz_eingeschraenkt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_width_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (178,178,'none','keine','nulle', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_course_segment_width_variability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3078,3078,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT fkey_vl_water_course_segment_width_variability FOREIGN KEY (width_variability)
 REFERENCES qgep_vl.water_course_segment_width_variability (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.water_course_segment ADD COLUMN fk_watercourse varchar (16);
ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT rel_water_course_segment_watercourse FOREIGN KEY (fk_watercourse) REFERENCES qgep_od.river(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.water_catchment_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_catchment_kind ADD CONSTRAINT pkey_qgep_vl_water_catchment_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_catchment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (24,24,'process_water','Brauchwasser','eau_industrielle', 'zzz_Brauchwasser', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_catchment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (25,25,'drinking_water','Trinkwasser','eau_potable', 'zzz_Trinkwasser', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_catchment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3075,3075,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_catchment ADD CONSTRAINT fkey_vl_water_catchment_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.water_catchment_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.water_catchment ADD COLUMN fk_aquifier varchar (16);
ALTER TABLE qgep_od.water_catchment ADD CONSTRAINT rel_water_catchment_aquifier FOREIGN KEY (fk_aquifier) REFERENCES qgep_od.aquifier(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.water_catchment ADD COLUMN fk_chute varchar (16);
ALTER TABLE qgep_od.water_catchment ADD CONSTRAINT rel_water_catchment_chute FOREIGN KEY (fk_chute) REFERENCES qgep_od.surface_water_bodies(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.river_bank_control_grade_of_river () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bank_control_grade_of_river ADD CONSTRAINT pkey_qgep_vl_river_bank_control_grade_of_river_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (341,341,'none','keine','nul', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2612,2612,'moderate','maessig','moyen', 'zzz_maessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2613,2613,'strong','stark','fort', 'zzz_stark', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2614,2614,'predominantly','ueberwiegend','preponderant', 'zzz_ueberwiegend', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3026,3026,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2611,2611,'sporadic','vereinzelt','localise', 'zzz_vereinzelt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2615,2615,'complete','vollstaendig','total', 'zzz_vollstaendig', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bank ADD CONSTRAINT fkey_vl_river_bank_control_grade_of_river FOREIGN KEY (control_grade_of_river)
 REFERENCES qgep_vl.river_bank_control_grade_of_river (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bank_river_control_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bank_river_control_type ADD CONSTRAINT pkey_qgep_vl_river_bank_river_control_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3489,3489,'other_impermeable','andere_dicht','autres_impermeables', 'zzz_altri_dicht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3486,3486,'concrete_chequer_brick_impermeable','Betongitterstein_dicht','brique_perforee_en_beton_impermeable', 'zzz_Betongitterstein_dicht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3485,3485,'wood_permeable','Holz_durchlaessig','bois_permeable', 'zzz_Holz_durchlaessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3482,3482,'no_control_structure','keine_Verbauung','aucun_amenagement', 'zzz_keine_Verbauung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3483,3483,'living_control_structure_permeable','Lebendverbau_durchlaessig','materiau_vegetal_permeable', 'zzz_Lebendverbau_durchlaessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3488,3488,'wall_impermeable','Mauer_dicht','mur_impermeable', 'zzz_Mauer_dicht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3487,3487,'natural_stone_impermeable','Naturstein_dicht','pierre_naturelle_impermeable', 'zzz_Naturstein_dicht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3484,3484,'loose_natural_stone_permeable','Naturstein_locker_durchlaessig','pierre_naturelle_lache', 'zzz_Naturstein_locker_durchlaessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3080,3080,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bank ADD CONSTRAINT fkey_vl_river_bank_river_control_type FOREIGN KEY (river_control_type)
 REFERENCES qgep_vl.river_bank_river_control_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bank_shores () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bank_shores ADD CONSTRAINT pkey_qgep_vl_river_bank_shores_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bank_shores (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (404,404,'inappropriate_to_river','gewaesserfremd','atypique_d_un_cours_d_eau', 'zzz_gewaesserfremd', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_shores (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (403,403,'appropriate_to_river','gewaessergerecht','typique_d_un_cours_d_eau', 'zzz_gewaessergerecht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_shores (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (405,405,'artificial','kuenstlich','artificielle', 'zzz_kuenstlich', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_shores (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3081,3081,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bank ADD CONSTRAINT fkey_vl_river_bank_shores FOREIGN KEY (shores)
 REFERENCES qgep_vl.river_bank_shores (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bank_side () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bank_side ADD CONSTRAINT pkey_qgep_vl_river_bank_side_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bank_side (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (420,420,'left','links','gauche', 'zzz_links', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_side (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (421,421,'right','rechts','droite', 'zzz_rechts', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_side (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3065,3065,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bank ADD CONSTRAINT fkey_vl_river_bank_side FOREIGN KEY (side)
 REFERENCES qgep_vl.river_bank_side (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bank_utilisation_of_shore_surroundings () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bank_utilisation_of_shore_surroundings ADD CONSTRAINT pkey_qgep_vl_river_bank_utilisation_of_shore_surroundings_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bank_utilisation_of_shore_surroundings (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (424,424,'developed_area','Bebauungen','constructions', 'zzz_Bebauungen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_utilisation_of_shore_surroundings (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (425,425,'grassland','Gruenland','espaces_verts', 'zzz_Gruenland', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_utilisation_of_shore_surroundings (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3068,3068,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_utilisation_of_shore_surroundings (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (426,426,'forest','Wald','foret', 'zzz_Wald', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bank ADD CONSTRAINT fkey_vl_river_bank_utilisation_of_shore_surroundings FOREIGN KEY (utilisation_of_shore_surroundings)
 REFERENCES qgep_vl.river_bank_utilisation_of_shore_surroundings (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bank_vegetation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bank_vegetation ADD CONSTRAINT pkey_qgep_vl_river_bank_vegetation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bank_vegetation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (325,325,'missing','fehlend','absente', 'zzz_fehlend', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_vegetation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (323,323,'typical_for_habitat','standorttypisch','typique_du_lieu', 'zzz_standorttypisch', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_vegetation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (324,324,'atypical_for_habitat','standortuntypisch','non_typique_du_lieu', 'zzz_standortuntypisch', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bank_vegetation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3025,3025,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bank ADD CONSTRAINT fkey_vl_river_bank_vegetation FOREIGN KEY (vegetation)
 REFERENCES qgep_vl.river_bank_vegetation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.river_bank ADD COLUMN fk_water_course_segment varchar (16);
ALTER TABLE qgep_od.river_bank ADD CONSTRAINT rel_river_bank_water_course_segment FOREIGN KEY (fk_water_course_segment) REFERENCES qgep_od.water_course_segment(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.river_bed_control_grade_of_river () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bed_control_grade_of_river ADD CONSTRAINT pkey_qgep_vl_river_bed_control_grade_of_river_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (142,142,'none','keine','nul', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2607,2607,'moderate','maessig','moyen', 'zzz_maessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2608,2608,'heavily','stark','fort', 'zzz_stark', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2609,2609,'predominantly','ueberwiegend','preponderant', 'zzz_ueberwiegend', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3085,3085,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2606,2606,'sporadic','vereinzelt','localise', 'zzz_vereinzelt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_control_grade_of_river (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2610,2610,'complete','vollstaendig','total', 'zzz_vollstaendig', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bed ADD CONSTRAINT fkey_vl_river_bed_control_grade_of_river FOREIGN KEY (control_grade_of_river)
 REFERENCES qgep_vl.river_bed_control_grade_of_river (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bed_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bed_kind ADD CONSTRAINT pkey_qgep_vl_river_bed_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bed_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (290,290,'hard','hart','dur', 'zzz_hart', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3089,3089,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (289,289,'soft','weich','tendre', 'zzz_weich', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bed ADD CONSTRAINT fkey_vl_river_bed_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.river_bed_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.river_bed_river_control_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.river_bed_river_control_type ADD CONSTRAINT pkey_qgep_vl_river_bed_river_control_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.river_bed_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3481,3481,'other_impermeable','andere_dicht','autres_impermeables', 'zzz_altri_dicht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (338,338,'concrete_chequer_brick','Betongittersteine','briques_perforees_en_beton', 'zzz_Betongittersteine', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3479,3479,'wood','Holz','bois', 'zzz_Holz', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3477,3477,'no_control_structure','keine_Verbauung','aucun_amenagement', 'zzz_keine_Verbauung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3478,3478,'rock_fill_or_loose_boulders','Steinschuettung_Blockwurf','pierres_naturelles', 'zzz_Steinschuettung_Blockwurf', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.river_bed_river_control_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3079,3079,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.river_bed ADD CONSTRAINT fkey_vl_river_bed_river_control_type FOREIGN KEY (river_control_type)
 REFERENCES qgep_vl.river_bed_river_control_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.river_bed ADD COLUMN fk_water_course_segment varchar (16);
ALTER TABLE qgep_od.river_bed ADD CONSTRAINT rel_river_bed_water_course_segment FOREIGN KEY (fk_water_course_segment) REFERENCES qgep_od.water_course_segment(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.sector_water_body_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.sector_water_body_kind ADD CONSTRAINT pkey_qgep_vl_sector_water_body_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.sector_water_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2657,2657,'waterbody','Gewaesser','lac_ou_cours_d_eau', 'zzz_Gewaesser', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sector_water_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2729,2729,'parallel_section','ParallelerAbschnitt','troncon_parallele', 'zzz_ParallelerAbschnitt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sector_water_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2728,2728,'lake_traversal','Seetraverse','element_traversant_un_lac', 'zzz_Seetraverse', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sector_water_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2656,2656,'shore','Ufer','rives', 'zzz_Ufer', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sector_water_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3054,3054,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.sector_water_body ADD CONSTRAINT fkey_vl_sector_water_body_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.sector_water_body_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.sector_water_body ADD COLUMN fk_chute varchar (16);
ALTER TABLE qgep_od.sector_water_body ADD CONSTRAINT rel_sector_water_body_chute FOREIGN KEY (fk_chute) REFERENCES qgep_od.surface_water_bodies(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.cooperative ADD CONSTRAINT oorel_od_cooperative_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.canton ADD CONSTRAINT oorel_od_canton_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.waste_water_association ADD CONSTRAINT oorel_od_waste_water_association_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.municipality ADD CONSTRAINT oorel_od_municipality_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.administrative_office ADD CONSTRAINT oorel_od_administrative_office_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.waste_water_treatment_plant ADD CONSTRAINT oorel_od_waste_water_treatment_plant_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.private ADD CONSTRAINT oorel_od_private_organisation FOREIGN KEY (obj_id) REFERENCES qgep_od.organisation(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.wastewater_structure_accessibility () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_accessibility ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_accessibility_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3444,3444,'covered','ueberdeckt','couvert', 'coperto', 'capac', '', 'UED', 'CO', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3447,3447,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3446,3446,'inaccessible','unzugaenglich','inaccessible', 'non_accessibile', 'inaccesibil', '', 'UZG', 'NA', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3445,3445,'accessible','zugaenglich','accessible', 'accessibile', 'accessibil', '', 'ZG', 'A', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_accessibility FOREIGN KEY (accessibility)
 REFERENCES qgep_vl.wastewater_structure_accessibility (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_financing () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_financing ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_financing_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_financing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5510,5510,'public','oeffentlich','public', 'pubblico', 'publica', 'PU', 'OE', 'PU', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_financing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5511,5511,'private','privat','prive', 'privato', 'privata', 'PR', 'PR', 'PR', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_financing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5512,5512,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', 'U', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_financing FOREIGN KEY (financing)
 REFERENCES qgep_vl.wastewater_structure_financing (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_renovation_necessity () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_renovation_necessity ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_renovation_necessity_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5370,5370,'urgent','dringend','urgente', 'urgente', 'urgent', 'UR', 'DR', 'UR', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5368,5368,'none','keiner','aucune', 'nessuno', 'niciuna', 'N', 'K', 'AN', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2,2,'short_term','kurzfristig','a_court_terme', 'breve_termine', 'termen_scurt', 'ST', 'KF', 'CT', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4,4,'long_term','langfristig','a_long_terme', 'lungo_termine', 'termen_lung', 'LT', 'LF', 'LT', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3,3,'medium_term','mittelfristig','a_moyen_terme', 'medio_termine', 'termen_mediu', '', 'MF', 'MT', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5369,5369,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_renovation_necessity FOREIGN KEY (renovation_necessity)
 REFERENCES qgep_vl.wastewater_structure_renovation_necessity (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_rv_construction_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_rv_construction_type ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_rv_construction_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4602,4602,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4603,4603,'field','Feld','dans_les_champs', 'campo_aperto', 'in_camp', 'FI', 'FE', 'FE', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4606,4606,'renovation_conduction_excavator','Sanierungsleitung_Bagger','conduite_d_assainissement_retro', 'canalizazzione_risanmento_scavatrice', 'conducte_excavate', 'RCE', 'SBA', 'CAR', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4605,4605,'renovation_conduction_ditch_cutter','Sanierungsleitung_Grabenfraese','conduite_d_assainissement_trancheuse', 'condotta_risanamento_scavafossi', 'conducta_taiere_sant', 'RCD', 'SGF', 'CAT', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4604,4604,'road','Strasse','sous_route', 'strada', 'sub_strada', 'ST', 'ST', 'ST', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4601,4601,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_rv_construction_type FOREIGN KEY (rv_construction_type)
 REFERENCES qgep_vl.wastewater_structure_rv_construction_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_status () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_status ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_status_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3633,3633,'inoperative','ausser_Betrieb','hors_service', 'fuori_servizio', 'rrr_ausser_Betrieb', 'NO', 'AB', 'H', 'FS', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8493,8493,'operational','in_Betrieb','en_service', 'in_funzione', 'functionala', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6530,6530,'operational.tentative','in_Betrieb.provisorisch','en_service.provisoire', 'in_funzione.provvisorio', 'functionala.provizoriu', 'T', 'T', 'P', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6533,6533,'operational.will_be_suspended','in_Betrieb.wird_aufgehoben','en_service.sera_supprime', 'in_funzione.da_eliminare', 'functionala.va_fi_eliminata', '', 'WA', 'SS', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6523,6523,'abanndoned.suspended_not_filled','tot.aufgehoben_nicht_verfuellt','abandonne.supprime_non_demoli', 'abbandonato.eliminato_non_demolito', 'abandonata.eliminare_necompletata', 'SN', 'AN', 'S', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6524,6524,'abanndoned.suspended_unknown','tot.aufgehoben_unbekannt','abandonne.supprime_inconnu', 'abbandonato.eliminato_sconosciuto', 'abandonata.demolare_necunoscuta', 'SU', 'AU', 'AI', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6532,6532,'abanndoned.filled','tot.verfuellt','abandonne.demoli', 'abbandonato.demolito', 'abandonata.eliminata', '', 'V', 'D', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3027,3027,'unknown','unbekannt','inconnu', 'sconosciuto', 'rrr_unbekannt', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6526,6526,'other.calculation_alternative','weitere.Berechnungsvariante','autre.variante_de_calcul', 'altri.variante_calcolo', 'alta.varianta_calcul', 'CA', 'B', 'C', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7959,7959,'other.planned','weitere.geplant','autre.planifie', 'altri.previsto', 'rrr_weitere.geplant', '', 'G', 'PL', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6529,6529,'other.project','weitere.Projekt','autre.projet', 'altri.progetto', 'alta.proiect', '', 'N', 'PR', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_status FOREIGN KEY (status)
 REFERENCES qgep_vl.wastewater_structure_status (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_structure_condition () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_structure_condition ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_structure_condition_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3037,3037,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3363,3363,'Z0','Z0','Z0', 'Z0', 'Z0', '', 'Z0', 'Z0', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3359,3359,'Z1','Z1','Z1', 'Z1', 'Z1', '', 'Z1', 'Z1', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3360,3360,'Z2','Z2','Z2', 'Z2', 'Z2', '', 'Z2', 'Z2', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3361,3361,'Z3','Z3','Z3', 'Z3', 'Z3', '', 'Z3', 'Z3', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3362,3362,'Z4','Z4','Z4', 'Z4', '', '', 'Z4', 'Z4', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_structure_condition FOREIGN KEY (structure_condition)
 REFERENCES qgep_vl.wastewater_structure_structure_condition (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN fk_owner varchar (16);
ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_owner FOREIGN KEY (fk_owner) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.wastewater_structure ADD COLUMN fk_operator varchar (16);
ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_operator FOREIGN KEY (fk_operator) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.channel ADD CONSTRAINT oorel_od_channel_wastewater_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.channel_bedding_encasement () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.channel_bedding_encasement ADD CONSTRAINT pkey_qgep_vl_channel_bedding_encasement_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5325,5325,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5332,5332,'in_soil','erdverlegt','enterre', 'zzz_erdverlegt', 'pamant', 'IS', 'EV', 'ET', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5328,5328,'in_channel_suspended','in_Kanal_aufgehaengt','suspendu_dans_le_canal', 'zzz_in_Kanal_aufgehaengt', 'suspendat_in_canal', '', 'IKA', 'CS', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5339,5339,'in_channel_concrete_casted','in_Kanal_einbetoniert','betonne_dans_le_canal', 'zzz_in_Kanal_einbetoniert', 'beton_in_canal', '', 'IKB', 'CB', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5331,5331,'in_walk_in_passage','in_Leitungsgang','en_galerie', 'zzz_in_Leitungsgang', 'galerie', '', 'ILG', 'G', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5337,5337,'in_jacking_pipe_concrete','in_Vortriebsrohr_Beton','en_pousse_tube_en_beton', 'zzz_in_Vortriebsrohr_Beton', 'beton_presstube', '', 'IVB', 'TB', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5336,5336,'in_jacking_pipe_steel','in_Vortriebsrohr_Stahl','en_pousse_tube_en_acier', 'zzz_in_Vortriebsrohr_Stahl', 'otel_presstube', '', 'IVS', 'TA', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5335,5335,'sand','Sand','sable', 'zzz_Sand', 'nisip', '', 'SA', 'SA', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5333,5333,'sia_type_1','SIA_Typ1','SIA_type_1', 'SIA_tippo1', 'SIA_tip_1', '', 'B1', 'B1', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5330,5330,'sia_type_2','SIA_Typ2','SIA_type_2', 'SIA_tippo2', 'SIA_tip_2', '', 'B2', 'B2', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5334,5334,'sia_type_3','SIA_Typ3','SIA_type_3', 'SIA_tippo3', 'SIA_tip_3', '', 'B3', 'B3', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5340,5340,'sia_type_4','SIA_Typ4','SIA_type_4', 'SIA_tippo4', 'SIA_tip_4', '', 'B4', 'B4', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5327,5327,'bed_plank','Sohlbrett','radier_en_planches', 'zzz_Sohlbrett', 'pat_de_pamant', '', 'SB', 'RP', '', '', 'true');
 INSERT INTO qgep_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5329,5329,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.channel ADD CONSTRAINT fkey_vl_channel_bedding_encasement FOREIGN KEY (bedding_encasement)
 REFERENCES qgep_vl.channel_bedding_encasement (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.channel_connection_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.channel_connection_type ADD CONSTRAINT pkey_qgep_vl_channel_connection_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5341,5341,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (190,190,'electric_welded_sleeves','Elektroschweissmuffen','manchon_electrosoudable', 'zzz_Elektroschweissmuffen', 'manson_electrosudabil', 'EWS', 'EL', 'MSA', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (187,187,'flat_sleeves','Flachmuffen','manchon_plat', 'zzz_Flachmuffen', 'mason_plat', '', 'FM', 'MP', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (193,193,'flange','Flansch','bride', 'zzz_Flansch', 'flansa', '', 'FL', 'B', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (185,185,'bell_shaped_sleeves','Glockenmuffen','emboitement_a_cloche', 'zzz_Glockenmuffen', 'imbinare_tip_clopot', '', 'GL', 'EC', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (192,192,'coupling','Kupplung','raccord', 'zzz_Kupplung', 'racord', '', 'KU', 'R', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (194,194,'screwed_sleeves','Schraubmuffen','manchon_visse', 'zzz_Schraubmuffen', 'manson_insurubat', '', 'SC', 'MV', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (189,189,'butt_welded','spiegelgeschweisst','manchon_soude_au_miroir', 'zzz_spiegelgeschweisst', 'manson_sudat_cap_la_cap', '', 'SP', 'MSM', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (186,186,'beaked_sleeves','Spitzmuffen','emboitement_simple', 'zzz_Spitzmuffen', 'imbinare_simpla', '', 'SM', 'ES', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (191,191,'push_fit_sleeves','Steckmuffen','raccord_a_serrage', 'zzz_Steckmuffen', 'racord_de_prindere', '', 'ST', 'RS', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (188,188,'slip_on_sleeves','Ueberschiebmuffen','manchon_coulissant', 'zzz_Ueberschiebmuffen', 'manson_culisant', '', 'UE', 'MC', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3036,3036,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3666,3666,'jacking_pipe_coupling','Vortriebsrohrkupplung','raccord_pour_tube_de_pousse_tube', 'zzz_Vortriebsrohrkupplung', 'racord_prin_presstube', '', 'VK', 'RTD', '', '', 'true');
 ALTER TABLE qgep_od.channel ADD CONSTRAINT fkey_vl_channel_connection_type FOREIGN KEY (connection_type)
 REFERENCES qgep_vl.channel_connection_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.channel_function_hierarchic () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.channel_function_hierarchic ADD CONSTRAINT pkey_qgep_vl_channel_function_hierarchic_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5066,5066,'pwwf.other','PAA.andere','OAP.autre', 'IPS.altro', 'pwwf.alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5068,5068,'pwwf.water_bodies','PAA.Gewaesser','OAP.cours_d_eau', 'IPS.corpo_acqua', 'pwwf.curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5069,5069,'pwwf.main_drain','PAA.Hauptsammelkanal','OAP.collecteur_principal', 'IPS.collettore_principale', 'pwwf.colector_principal', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5070,5070,'pwwf.main_drain_regional','PAA.Hauptsammelkanal_regional','OAP.collecteur_principal_regional', 'IPS.collettore_principale_regionale', 'pwwf.colector_principal_regional', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5064,5064,'pwwf.residential_drainage','PAA.Liegenschaftsentwaesserung','OAP.evacuation_bien_fonds', 'IPS.samltimento_acque_fondi', 'pwwf.evacuare_rezidentiala', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5071,5071,'pwwf.collector_sewer','PAA.Sammelkanal','OAP.collecteur', 'IPS.collettore', 'pwwf.colector', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5062,5062,'pwwf.renovation_conduction','PAA.Sanierungsleitung','OAP.conduite_d_assainissement', 'IPS.condotta_risanamento', 'pwwf.conducta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5072,5072,'pwwf.road_drainage','PAA.Strassenentwaesserung','OAP.evacuation_des_eaux_de_routes', 'IPS.samltimento_acque_stradali', 'pwwf.rigola_drum', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5074,5074,'pwwf.unknown','PAA.unbekannt','OAP.inconnue', 'IPS.sconosciuto', 'pwwf.necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5067,5067,'swwf.other','SAA.andere','OAS.autre', 'ISS.altro', 'swwf.alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5065,5065,'swwf.residential_drainage','SAA.Liegenschaftsentwaesserung','OAS.evacuation_bien_fonds', 'ISS.smaltimento_acque_fondi', 'swwf.evacuare_rezidentiala', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5063,5063,'swwf.renovation_conduction','SAA.Sanierungsleitung','OAS.conduite_d_assainissement', 'ISS.condotta_risanamento', 'swwf.racord', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5073,5073,'swwf.road_drainage','SAA.Strassenentwaesserung','OAS.evacuation_des_eaux_de_routes', 'ISS.smaltimento_acque_strade', 'swwf.evacuare_ape_rigole', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5075,5075,'swwf.unknown','SAA.unbekannt','OAS.inconnue', 'ISS.sconosciuto', 'swwf.necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.channel ADD CONSTRAINT fkey_vl_channel_function_hierarchic FOREIGN KEY (function_hierarchic)
 REFERENCES qgep_vl.channel_function_hierarchic (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.channel_function_hydraulic () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.channel_function_hydraulic ADD CONSTRAINT pkey_qgep_vl_channel_function_hydraulic_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5320,5320,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2546,2546,'drainage_transportation_pipe','Drainagetransportleitung','conduite_de_transport_pour_le_drainage', 'condotta_trasporto_drenaggi', 'conducta_transport_dren', 'DTP', 'DT', 'CTD', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (22,22,'restriction_pipe','Drosselleitung','conduite_d_etranglement', 'condotta_strozzamento', 'conducta_redusa', 'RP', 'DR', 'CE', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3610,3610,'inverted_syphon','Duekerleitung','siphon_inverse', 'canalizzazione_sifone', 'sifon_inversat', 'IS', 'DU', 'S', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (367,367,'gravity_pipe','Freispiegelleitung','conduite_a_ecoulement_gravitaire', 'canalizzazione_gravita', 'conducta_gravitationala', '', 'FL', 'CEL', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (23,23,'pump_pressure_pipe','Pumpendruckleitung','conduite_de_refoulement', 'canalizzazione_pompaggio', 'conducta_de_refulare', '', 'DL', 'CR', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (145,145,'seepage_water_drain','Sickerleitung','conduite_de_drainage', 'canalizzazione_drenaggio', 'conducta_drenaj', 'SP', 'SI', 'CI', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (21,21,'retention_pipe','Speicherleitung','conduite_de_retention', 'canalizzazione_ritenzione', 'conducta_de_retentie', '', 'SK', 'CA', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (144,144,'jetting_pipe','Spuelleitung','conduite_de_rincage', 'canalizzazione_spurgo', 'conducta_de_spalare', 'JP', 'SL', 'CC', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5321,5321,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3655,3655,'vacuum_pipe','Vakuumleitung','conduite_sous_vide', 'canalizzazione_sotto_vuoto', 'conducta_vidata', '', 'VL', 'CV', '', '', 'true');
 ALTER TABLE qgep_od.channel ADD CONSTRAINT fkey_vl_channel_function_hydraulic FOREIGN KEY (function_hydraulic)
 REFERENCES qgep_vl.channel_function_hydraulic (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.channel_usage_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.channel_usage_current ADD CONSTRAINT pkey_qgep_vl_channel_usage_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5322,5322,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4518,4518,'creek_water','Bachwasser','eaux_cours_d_eau', 'acqua_corso_acqua', 'ape_curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4516,4516,'discharged_combined_wastewater','entlastetes_Mischabwasser','eaux_mixtes_deversees', 'acque_miste_scaricate', 'ape_mixte_deversate', 'DCW', 'EW', 'EUD', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4524,4524,'industrial_wastewater','Industrieabwasser','eaux_industrielles', 'acque_industriali', 'ape_industriale', '', 'CW', 'EUC', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4522,4522,'combined_wastewater','Mischabwasser','eaux_mixtes', 'acque_miste', 'ape_mixte', '', 'MW', 'EUM', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4520,4520,'rain_wastewater','Regenabwasser','eaux_pluviales', 'acque_meteoriche', 'apa_meteorica', '', 'RW', 'EUP', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4514,4514,'clean_wastewater','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EUR', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4526,4526,'wastewater','Schmutzabwasser','eaux_usees', 'acque_luride', 'ape_uzate', '', 'SW', 'EU', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4571,4571,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.channel ADD CONSTRAINT fkey_vl_channel_usage_current FOREIGN KEY (usage_current)
 REFERENCES qgep_vl.channel_usage_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.channel_usage_planned () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.channel_usage_planned ADD CONSTRAINT pkey_qgep_vl_channel_usage_planned_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5323,5323,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4519,4519,'creek_water','Bachwasser','eaux_cours_d_eau', 'acqua_corso_acqua', 'ape_curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4517,4517,'discharged_combined_wastewater','entlastetes_Mischabwasser','eaux_mixtes_deversees', 'acque_miste_scaricate', 'ape_mixte_deversate', 'DCW', 'EW', 'EUD', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4525,4525,'industrial_wastewater','Industrieabwasser','eaux_industrielles', 'acque_industriali', 'ape_industriale', '', 'CW', 'EUC', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4523,4523,'combined_wastewater','Mischabwasser','eaux_mixtes', 'acque_miste', 'ape_mixte', '', 'MW', 'EUM', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4521,4521,'rain_wastewater','Regenabwasser','eaux_pluviales', 'acque_meteoriche', 'apa_meteorica', '', 'RW', 'EUP', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4515,4515,'clean_wastewater','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EUR', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4527,4527,'wastewater','Schmutzabwasser','eaux_usees', 'acque_luride', 'ape_uzate', '', 'SW', 'EU', '', '', 'true');
 INSERT INTO qgep_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4569,4569,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.channel ADD CONSTRAINT fkey_vl_channel_usage_planned FOREIGN KEY (usage_planned)
 REFERENCES qgep_vl.channel_usage_planned (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.manhole ADD CONSTRAINT oorel_od_manhole_wastewater_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.manhole_function () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.manhole_function ADD CONSTRAINT pkey_qgep_vl_manhole_function_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4532,4532,'drop_structure','Absturzbauwerk','ouvrage_de_chute', 'manufatto_caduta', 'instalatie_picurare', 'DS', 'AK', 'OC', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5344,5344,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4533,4533,'venting','Be_Entlueftung','aeration', 'zzz_Be_Entlueftung', 'aerisire', 'VE', 'BE', 'AE', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3267,3267,'rain_water_manhole','Dachwasserschacht','chambre_recolte_eaux_toitures', 'zzz_Dachwasserschacht', 'camin_vizitare_apa_meteorica', 'RWM', 'DS', 'CRT', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3266,3266,'gully','Einlaufschacht','chambre_avec_grille_d_entree', 'zzz_Einlaufschacht', 'gura_scurgere', 'G', 'ES', 'CG', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3472,3472,'drainage_channel','Entwaesserungsrinne','rigole_de_drainage', 'canaletta_drenaggio', 'rigola', '', 'ER', 'RD', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (228,228,'rail_track_gully','Geleiseschacht','evacuation_des_eaux_des_voies_ferrees', 'zzz_Geleiseschacht', 'evacuare_ape_cale_ferata', '', 'GL', 'EVF', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (204,204,'manhole','Kontrollschacht','regard_de_visite', 'pozzetto_ispezione', 'camin_vizitare', '', 'KS', 'CC', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (1008,1008,'oil_separator','Oelabscheider','separateur_d_hydrocarbures', 'separatore_olii', 'separator_hidrocarburi', 'OS', 'OA', 'SH', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4536,4536,'pump_station','Pumpwerk','station_de_pompage', 'stazione_pompaggio', 'statie_pompare', '', 'PW', 'SP', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5346,5346,'stormwater_overflow','Regenueberlauf','deversoir_d_orage', 'scaricatore_piena', 'preaplin', '', 'HE', 'DO', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2742,2742,'slurry_collector','Schlammsammler','depotoir', 'pozzetto_decantazione', 'colector_aluviuni', '', 'SA', 'D', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5347,5347,'floating_material_separator','Schwimmstoffabscheider','separateur_de_materiaux_flottants', 'separatore_materiali_galleggianti', 'separator_materie_flotanta', '', 'SW', 'SMF', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4537,4537,'jetting_manhole','Spuelschacht','chambre_de_chasse', 'pozzetto_lavaggio', 'camin_spalare', '', 'SS', 'CC', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4798,4798,'separating_structure','Trennbauwerk','ouvrage_de_repartition', 'camera_ripartizione', 'separator', '', 'TB', 'OR', '', '', 'true');
 INSERT INTO qgep_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5345,5345,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.manhole ADD CONSTRAINT fkey_vl_manhole_function FOREIGN KEY (function)
 REFERENCES qgep_vl.manhole_function (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.manhole_material () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.manhole_material ADD CONSTRAINT pkey_qgep_vl_manhole_material_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4540,4540,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4541,4541,'concrete','Beton','beton', 'zzz_Beton', 'beton', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4542,4542,'plastic','Kunststoff','matiere_plastique', 'zzz_Kunststoff', 'materie_plastica', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4543,4543,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.manhole ADD CONSTRAINT fkey_vl_manhole_material FOREIGN KEY (material)
 REFERENCES qgep_vl.manhole_material (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.manhole_surface_inflow () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.manhole_surface_inflow ADD CONSTRAINT pkey_qgep_vl_manhole_surface_inflow_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5342,5342,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2741,2741,'none','keiner','aucune', 'nessuno', 'niciunul', '', 'K', 'AN', '', '', 'true');
 INSERT INTO qgep_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2739,2739,'grid','Rost','grille_d_ecoulement', 'zzz_Rost', 'grilaj', '', 'R', 'G', '', '', 'true');
 INSERT INTO qgep_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5343,5343,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2740,2740,'intake_from_side','Zulauf_seitlich','arrivee_laterale', 'zzz_Zulauf_seitlich', 'admisie_laterala', '', 'ZS', 'AL', '', '', 'true');
 ALTER TABLE qgep_od.manhole ADD CONSTRAINT fkey_vl_manhole_surface_inflow FOREIGN KEY (surface_inflow)
 REFERENCES qgep_vl.manhole_surface_inflow (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.discharge_point ADD CONSTRAINT oorel_od_discharge_point_wastewater_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.discharge_point_relevance () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.discharge_point_relevance ADD CONSTRAINT pkey_qgep_vl_discharge_point_relevance_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.discharge_point_relevance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5580,5580,'relevant_for_water_course','gewaesserrelevant','pertinent_pour_milieu_recepteur', 'zzz_gewaesserrelevant', 'relevanta_pentru_mediul_receptor', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.discharge_point_relevance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5581,5581,'non_relevant_for_water_course','nicht_gewaesserrelevant','insignifiant_pour_milieu_recepteur', 'zzz_nicht_gewaesserrelevant', 'nerelevanta_pentru_mediul_receptor', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.discharge_point ADD CONSTRAINT fkey_vl_discharge_point_relevance FOREIGN KEY (relevance)
 REFERENCES qgep_vl.discharge_point_relevance (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.discharge_point ADD COLUMN fk_sector_water_body varchar (16);
ALTER TABLE qgep_od.discharge_point ADD CONSTRAINT rel_discharge_point_sector_water_body FOREIGN KEY (fk_sector_water_body) REFERENCES qgep_od.sector_water_body(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.special_structure ADD CONSTRAINT oorel_od_special_structure_wastewater_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.special_structure_bypass () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.special_structure_bypass ADD CONSTRAINT pkey_qgep_vl_special_structure_bypass_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.special_structure_bypass (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2682,2682,'inexistent','nicht_vorhanden','inexistant', 'zzz_nicht_vorhanden', 'inexistent', '', 'NV', 'IE', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_bypass (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3055,3055,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_bypass (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2681,2681,'existent','vorhanden','existant', 'zzz_vorhanden', 'existent', '', 'V', 'E', '', '', 'true');
 ALTER TABLE qgep_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_bypass FOREIGN KEY (bypass)
 REFERENCES qgep_vl.special_structure_bypass (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.special_structure_emergency_spillway () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.special_structure_emergency_spillway ADD CONSTRAINT pkey_qgep_vl_special_structure_emergency_spillway_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.special_structure_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5866,5866,'other','andere','autres', 'altri', 'altele', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5864,5864,'in_combined_waste_water_drain','inMischabwasserkanalisation','dans_canalisation_eaux_mixtes', 'in_canalizzazione_acque_miste', 'in_canalizare_apa_mixta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5865,5865,'in_rain_waste_water_drain','inRegenabwasserkanalisation','dans_canalisation_eaux_pluviales', 'in_canalizzazione_acque_meteoriche', 'in_canalizare_apa_meteorica', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5863,5863,'in_waste_water_drain','inSchmutzabwasserkanalisation','dans_canalisation_eaux_usees', 'in_canalizzazione_acque_luride', 'in_canalizare_apa_uzata', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5878,5878,'none','keiner','aucun', 'nessuno', 'niciunul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5867,5867,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_emergency_spillway FOREIGN KEY (emergency_spillway)
 REFERENCES qgep_vl.special_structure_emergency_spillway (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.special_structure_function () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.special_structure_function ADD CONSTRAINT pkey_qgep_vl_special_structure_function_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6397,6397,'pit_without_drain','abflussloseGrube','fosse_etanche', 'zzz_abflussloseGrube', 'bazin_vidanjabil', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (245,245,'drop_structure','Absturzbauwerk','ouvrage_de_chute', 'manufatto_caduta', 'instalatie_picurare', 'DS', 'AK', 'OC', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6398,6398,'hydrolizing_tank','Abwasserfaulraum','fosse_digestive', 'zzz_Abwasserfaulraum', 'fosa_hidroliza', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5371,5371,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (386,386,'venting','Be_Entlueftung','aeration', 'zzz_Be_Entlueftung', 'aerisire', 'VE', 'BE', 'AE', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3234,3234,'inverse_syphon_chamber','Duekerkammer','chambre_avec_siphon_inverse', 'zzz_Duekerkammer', 'instalatie_cu_sifon_inversat', 'ISC', 'DK', 'SI', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5091,5091,'syphon_head','Duekeroberhaupt','entree_de_siphon', 'zzz_Duekeroberhaupt', 'cap_sifon', 'SH', 'DO', 'ESI', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6399,6399,'septic_tank_two_chambers','Faulgrube','fosse_septique', 'zzz_Faulgrube', 'fosa_septica_2_compartimente', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3348,3348,'terrain_depression','Gelaendemulde','depression_de_terrain', 'zzz_Gelaendemulde', 'depresiune_teren', '', 'GM', 'DT', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (336,336,'bolders_bedload_catchement_dam','Geschiebefang','depotoir_pour_alluvions', 'camera_ritenuta', 'colector_aluviuni', '', 'GF', 'DA', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5494,5494,'cesspit','Guellegrube','fosse_a_purin', 'zzz_Guellegrube', 'hazna', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6478,6478,'septic_tank','Klaergrube','fosse_de_decantation', 'fossa_settica', 'fosa_septica', '', 'KG', 'FD', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2998,2998,'manhole','Kontrollschacht','regard_de_visite', 'pozzetto_ispezione', 'camin_vizitare', '', 'KS', 'RV', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2768,2768,'oil_separator','Oelabscheider','separateur_d_hydrocarbures', 'separatore_olii', 'separator_hidrocarburi', '', 'OA', 'SH', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (246,246,'pump_station','Pumpwerk','station_de_pompage', 'stazione_pompaggio', 'statie_pompare', '', 'PW', 'SP', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3673,3673,'stormwater_tank_with_overflow','Regenbecken_Durchlaufbecken','BEP_decantation', 'zzz_Regenbecken_Durchlaufbecken', 'bazin_retentie_apa_meteorica_cu_preaplin', '', 'DB', 'BDE', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3674,3674,'stormwater_tank_retaining_first_flush','Regenbecken_Fangbecken','BEP_retention', 'bacino_accumulo', 'bazin_retentie_apa_meteorica_prima_spalare', '', 'FB', 'BRE', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5574,5574,'stormwater_retaining_channel','Regenbecken_Fangkanal','BEP_canal_retention', 'canale_accumulo', 'bazin_retentie', 'TRE', 'FK', 'BCR', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3675,3675,'stormwater_sedimentation_tank','Regenbecken_Regenklaerbecken','BEP_clarification', 'bacino_decantazione_acque_meteoriche', 'bazin_decantare', '', 'RKB', 'BCL', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3676,3676,'stormwater_retention_tank','Regenbecken_Regenrueckhaltebecken','BEP_accumulation', 'bacino_ritenzione', 'bazin_retentie_apa_meteorica', '', 'RRB', 'BAC', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5575,5575,'stormwater_retention_channel','Regenbecken_Regenrueckhaltekanal','BEP_canal_accumulation', 'canale_ritenzione', 'canal_retentie_apa_meteorica', 'TRC', 'RRK', 'BCA', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5576,5576,'stormwater_storage_channel','Regenbecken_Stauraumkanal','BEP_canal_stockage', 'canale_stoccaggio', 'bazin_stocare', 'TSC', 'SRK', 'BCS', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3677,3677,'stormwater_composite_tank','Regenbecken_Verbundbecken','BEP_combine', 'bacino_combinato', '', '', 'VB', 'BCO', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5372,5372,'stormwater_overflow','Regenueberlauf','deversoir_d_orage', 'scaricatore_piena', 'preaplin', '', 'RU', 'DO', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5373,5373,'floating_material_separator','Schwimmstoffabscheider','separateur_de_materiaux_flottants', 'separatore_materiali_galleggianti', 'separator_materie_flotanta', '', 'SW', 'SMF', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (383,383,'side_access','seitlicherZugang','acces_lateral', 'zzz_seitlicherZugang', 'acces_lateral', '', 'SZ', 'AL', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (227,227,'jetting_manhole','Spuelschacht','chambre_de_chasse', 'pozzetto_lavaggio', 'camin_spalare', '', 'SS', 'CC', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4799,4799,'separating_structure','Trennbauwerk','ouvrage_de_repartition', 'camera_ripartizione', 'separator', '', 'TB', 'OR', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3008,3008,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2745,2745,'vortex_manhole','Wirbelfallschacht','chambre_de_chute_a_vortex', 'zzz_Wirbelfallschacht', 'instalatie_picurare_cu_vortex', '', 'WF', 'CT', '', '', 'true');
 ALTER TABLE qgep_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_function FOREIGN KEY (function)
 REFERENCES qgep_vl.special_structure_function (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.special_structure_stormwater_tank_arrangement () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.special_structure_stormwater_tank_arrangement ADD CONSTRAINT pkey_qgep_vl_special_structure_stormwater_tank_arrangement_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.special_structure_stormwater_tank_arrangement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4608,4608,'main_connection','Hauptschluss','connexion_directe', 'in_serie', 'conectare_directa', '', 'HS', 'CD', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_stormwater_tank_arrangement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4609,4609,'side_connection','Nebenschluss','connexion_laterale', 'in_parallelo', 'conectare_laterala', '', 'NS', 'CL', '', '', 'true');
 INSERT INTO qgep_vl.special_structure_stormwater_tank_arrangement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4610,4610,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_stormwater_tank_arrangement FOREIGN KEY (stormwater_tank_arrangement)
 REFERENCES qgep_vl.special_structure_stormwater_tank_arrangement (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT oorel_od_infiltration_installation_wastewater_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.infiltration_installation_defects () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_defects ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_defects_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_defects (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5361,5361,'none','keine','aucunes', 'nessuno', 'inexistente', '', 'K', 'AN', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_defects (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3276,3276,'marginal','unwesentliche','modestes', 'zzz_unwesentliche', 'modeste', '', 'UW', 'MI', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_defects (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3275,3275,'substantial','wesentliche','importantes', 'zzz_wesentliche', 'importante', '', 'W', 'MA', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_defects FOREIGN KEY (defects)
 REFERENCES qgep_vl.infiltration_installation_defects (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.infiltration_installation_emergency_spillway () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_emergency_spillway ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_emergency_spillway_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5365,5365,'in_combined_waste_water_drain','inMischwasserkanalisation','dans_canalisation_eaux_mixtes', 'zzz_inMischwasserkanalisation', 'in_canalizare_ape_mixte', '', 'IMK', 'CEM', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3307,3307,'in_rain_waste_water_drain','inRegenwasserkanalisation','dans_canalisation_eaux_pluviales', 'zzz_inRegenwasserkanalisation', 'in_canalizare_apa_meteorica', '', 'IRK', 'CEP', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3304,3304,'in_water_body','inVorfluter','au_cours_d_eau_recepteur', 'zzz_inVorfluter', 'in_curs_apa', '', 'IV', 'CE', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3303,3303,'none','keiner','aucun', 'nessuno', 'inexistent', '', 'K', 'AN', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3305,3305,'surface_discharge','oberflaechlichausmuendend','deversement_en_surface', 'zzz_oberflaechlichausmuendend', 'deversare_la_suprafata', '', 'OA', 'DS', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_emergency_spillway (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3308,3308,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_emergency_spillway FOREIGN KEY (emergency_spillway)
 REFERENCES qgep_vl.infiltration_installation_emergency_spillway (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.infiltration_installation_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_kind ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3282,3282,'with_soil_passage','andere_mit_Bodenpassage','autre_avec_passage_a_travers_sol', 'zzz_altri_mit_Bodenpassage', 'altul_cu_traversare_sol', 'WSP', 'AMB', 'APC', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3285,3285,'without_soil_passage','andere_ohne_Bodenpassage','autre_sans_passage_a_travers_sol', 'zzz_altri_ohne_Bodenpassage', 'altul_fara_traversare_sol', 'WOP', 'AOB', 'ASC', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3279,3279,'surface_infiltration','Flaechenfoermige_Versickerung','infiltration_superficielle_sur_place', 'zzz_Flaechenfoermige_Versickerung', 'infilitratie_de_suprafata', '', 'FV', 'IS', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (277,277,'gravel_formation','Kieskoerper','corps_de_gravier', 'zzz_Kieskoerper', 'formatiune_de_pietris', '', 'KK', 'VG', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3284,3284,'combination_manhole_pipe','Kombination_Schacht_Strang','combinaison_puits_bande', 'zzz_Kombination_Schacht_Strang', 'combinatie_put_conducta', '', 'KOM', 'CPT', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3281,3281,'swale_french_drain_infiltration','MuldenRigolenversickerung','cuvettes_rigoles_filtrantes', 'zzz_MuldenRigolenversickerung', 'cuve_rigole_filtrante', '', 'MRV', 'ICR', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3087,3087,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3280,3280,'percolation_over_the_shoulder','Versickerung_ueber_die_Schulter','infiltration_par_les_bas_cotes', 'zzz_Versickerung_ueber_die_Schulter', 'infilitratie_pe_la_cote_joase', '', 'VUS', 'IDB', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (276,276,'infiltration_basin','Versickerungsbecken','bassin_d_infiltration', 'zzz_Versickerungsbecken', 'bazin_infiltrare', '', 'VB', 'BI', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (278,278,'adsorbing_well','Versickerungsschacht','puits_d_infiltration', 'zzz_Versickerungsschacht', 'put_de_inflitrare', '', 'VS', 'PI', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3283,3283,'infiltration_pipe_sections_gallery','Versickerungsstrang_Galerie','bande_infiltration_galerie', 'zzz_Versickerungsstrang_Galerie', 'conducta_infiltrare_galerie', '', 'VG', 'TIG', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.infiltration_installation_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.infiltration_installation_labeling () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_labeling ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_labeling_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_labeling (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5362,5362,'labeled','beschriftet','signalee', 'zzz_beschriftet', 'marcat', 'L', 'BS', 'SI', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_labeling (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5363,5363,'not_labeled','nichtbeschriftet','non_signalee', 'zzz_nichtbeschriftet', 'nemarcat', '', 'NBS', 'NSI', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_labeling (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5364,5364,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_labeling FOREIGN KEY (labeling)
 REFERENCES qgep_vl.infiltration_installation_labeling (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.infiltration_installation_seepage_utilization () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_seepage_utilization ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_seepage_utilization_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_seepage_utilization (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (274,274,'rain_water','Regenabwasser','eaux_pluviales', 'acque_meteoriche', 'ape_pluviale', '', 'RW', 'EP', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_seepage_utilization (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (273,273,'clean_water','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EC', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_seepage_utilization (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5359,5359,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_seepage_utilization FOREIGN KEY (seepage_utilization)
 REFERENCES qgep_vl.infiltration_installation_seepage_utilization (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.infiltration_installation_vehicle_access () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_vehicle_access ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_vehicle_access_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_vehicle_access (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3289,3289,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_vehicle_access (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3288,3288,'inaccessible','unzugaenglich','inaccessible', 'non_accessibile', 'neaccesibil', '', 'ZU', 'IAC', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_vehicle_access (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3287,3287,'accessible','zugaenglich','accessible', 'accessibile', 'accessibil', '', 'Z', 'AC', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_vehicle_access FOREIGN KEY (vehicle_access)
 REFERENCES qgep_vl.infiltration_installation_vehicle_access (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.infiltration_installation_watertightness () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_installation_watertightness ADD CONSTRAINT pkey_qgep_vl_infiltration_installation_watertightness_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_installation_watertightness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3295,3295,'not_watertight','nichtwasserdicht','non_etanche', 'zzz_nichtwasserdicht', 'neetans', '', 'NWD', 'NE', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_watertightness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5360,5360,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_installation_watertightness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3294,3294,'watertight','wasserdicht','etanche', 'zzz_wasserdicht', 'etans', '', 'WD', 'E', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_watertightness FOREIGN KEY (watertightness)
 REFERENCES qgep_vl.infiltration_installation_watertightness (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.infiltration_installation ADD COLUMN fk_aquifier varchar (16);
ALTER TABLE qgep_od.infiltration_installation ADD CONSTRAINT rel_infiltration_installation_aquifier FOREIGN KEY (fk_aquifier) REFERENCES qgep_od.aquifier(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.wwtp_structure ADD CONSTRAINT oorel_od_wwtp_structure_wastewater_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.wwtp_structure_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wwtp_structure_kind ADD CONSTRAINT pkey_qgep_vl_wwtp_structure_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (331,331,'sedimentation_basin','Absetzbecken','bassin_de_decantation', 'zzz_Absetzbecken', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2974,2974,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (327,327,'aeration_tank','Belebtschlammbecken','bassin_a_boues_activees', 'zzz_Belebtschlammbecken', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (329,329,'fixed_bed_reactor','Festbettreaktor','reacteur_a_biomasse_fixee', 'zzz_Festbettreaktor', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (330,330,'submerged_trickling_filter','Tauchtropfkoerper','disque_bacterien_immerge', 'zzz_Tauchtropfkoerper', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (328,328,'trickling_filter','Tropfkoerper','lit_bacterien', 'zzz_Tropfkoerper', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3032,3032,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (326,326,'primary_clarifier','Vorklaerbecken','decanteurs_primaires', 'zzz_Vorklaerbecken', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.wwtp_structure ADD CONSTRAINT fkey_vl_wwtp_structure_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.wwtp_structure_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.maintenance_event_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.maintenance_event_kind ADD CONSTRAINT pkey_qgep_vl_maintenance_event_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2982,2982,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (120,120,'replacement','Erneuerung','renouvellement', 'zzz_Erneuerung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (28,28,'cleaning','Reinigung','nettoyage', 'zzz_Reinigung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4529,4529,'renovation','Renovierung','renovation', 'zzz_Renovierung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4528,4528,'repair','Reparatur','reparation', 'zzz_Reparatur', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4530,4530,'restoration','Sanierung','rehabilitation', 'zzz_Sanierung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3045,3045,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4564,4564,'examination','Untersuchung','examen', 'zzz_Untersuchung', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.maintenance_event ADD CONSTRAINT fkey_vl_maintenance_event_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.maintenance_event_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.maintenance_event_status () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.maintenance_event_status ADD CONSTRAINT pkey_qgep_vl_maintenance_event_status_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2550,2550,'accomplished','ausgefuehrt','execute', 'zzz_ausgefuehrt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2549,2549,'planned','geplant','prevu', 'previsto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3678,3678,'not_possible','nicht_moeglich','impossible', 'zzz_nicht_moeglich', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3047,3047,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.maintenance_event ADD CONSTRAINT fkey_vl_maintenance_event_status FOREIGN KEY (status)
 REFERENCES qgep_vl.maintenance_event_status (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.maintenance_event ADD COLUMN fk_operating_company varchar (16);
ALTER TABLE qgep_od.maintenance_event ADD CONSTRAINT rel_maintenance_event_operating_company FOREIGN KEY (fk_operating_company) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.planning_zone ADD CONSTRAINT oorel_od_planning_zone_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.planning_zone_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.planning_zone_kind ADD CONSTRAINT pkey_qgep_vl_planning_zone_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2990,2990,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (31,31,'commercial_zone','Gewerbezone','zone_artisanale', 'zzz_Gewerbezone', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (32,32,'industrial_zone','Industriezone','zone_industrielle', 'zzz_Industriezone', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (30,30,'agricultural_zone','Landwirtschaftszone','zone_agricole', 'zzz_Landwirtschaftszone', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3077,3077,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.planning_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (29,29,'residential_zone','Wohnzone','zone_d_habitations', 'zzz_Wohnzone', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.planning_zone ADD CONSTRAINT fkey_vl_planning_zone_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.planning_zone_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.infiltration_zone ADD CONSTRAINT oorel_od_infiltration_zone_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.infiltration_zone_infiltration_capacity () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.infiltration_zone_infiltration_capacity ADD CONSTRAINT pkey_qgep_vl_infiltration_zone_infiltration_capacity_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (371,371,'good','gut','bonnes', 'zzz_gut', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (374,374,'none','keine','aucune', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (372,372,'moderate','maessig','moyennes', 'zzz_maessig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (373,373,'bad','schlecht','mauvaises', 'zzz_schlecht', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3073,3073,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2996,2996,'not_allowed','unzulaessig','non_admis', 'zzz_unzulaessig', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.infiltration_zone ADD CONSTRAINT fkey_vl_infiltration_zone_infiltration_capacity FOREIGN KEY (infiltration_capacity)
 REFERENCES qgep_vl.infiltration_zone_infiltration_capacity (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.drainage_system ADD CONSTRAINT oorel_od_drainage_system_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.drainage_system_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.drainage_system_kind ADD CONSTRAINT pkey_qgep_vl_drainage_system_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4783,4783,'amelioration','Melioration','melioration', 'zzz_Melioration', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2722,2722,'mixed_system','Mischsystem','systeme_unitaire', 'sistema_misto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2724,2724,'modified_system','ModifiziertesSystem','systeme_modifie', 'sistema_modificato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4544,4544,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2723,2723,'separated_system','Trennsystem','systeme_separatif', 'sistema_separato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3060,3060,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.drainage_system ADD CONSTRAINT fkey_vl_drainage_system_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.drainage_system_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.water_body_protection_sector ADD CONSTRAINT oorel_od_water_body_protection_sector_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.water_body_protection_sector_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.water_body_protection_sector_kind ADD CONSTRAINT pkey_qgep_vl_water_body_protection_sector_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (430,430,'A','A','A', 'A', 'A', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3652,3652,'Ao','Ao','Ao', 'zzz_Ao', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3649,3649,'Au','Au','Au', 'zzz_Au', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (431,431,'B','B','B', 'B', 'B', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (432,432,'C','C','C', 'C', 'C', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3069,3069,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3651,3651,'Zo','Zo','Zo', 'zzz_Zo', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.water_body_protection_sector_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3650,3650,'Zu','Zu','Zu', 'zzz_Zu', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.water_body_protection_sector ADD CONSTRAINT fkey_vl_water_body_protection_sector_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.water_body_protection_sector_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.ground_water_protection_perimeter ADD CONSTRAINT oorel_od_ground_water_protection_perimeter_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.groundwater_protection_zone ADD CONSTRAINT oorel_od_groundwater_protection_zone_zone FOREIGN KEY (obj_id) REFERENCES qgep_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.groundwater_protection_zone_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.groundwater_protection_zone_kind ADD CONSTRAINT pkey_qgep_vl_groundwater_protection_zone_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.groundwater_protection_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (440,440,'S1','S1','S1', 'S1', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.groundwater_protection_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (441,441,'S2','S2','S2', 'S2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.groundwater_protection_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (442,442,'S3','S3','S3', 'S3', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.groundwater_protection_zone_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3040,3040,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.groundwater_protection_zone ADD CONSTRAINT fkey_vl_groundwater_protection_zone_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.groundwater_protection_zone_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.pipe_profile_profile_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.pipe_profile_profile_type ADD CONSTRAINT pkey_qgep_vl_pipe_profile_profile_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3351,3351,'egg','Eiprofil','ovoide', 'ovoidale', 'ovoid', 'E', 'E', 'OV', '', '', 'true');
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3350,3350,'circle','Kreisprofil','circulaire', 'cicolare', 'rotund', 'CI', 'K', 'CI', 'CI', 'R', 'true');
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3352,3352,'mouth','Maulprofil','profil_en_voute', 'composto', 'sectiune_cu_bolta', 'M', 'M', 'V', 'C', '', 'true');
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3354,3354,'open','offenes_Profil','profil_ouvert', 'sezione_aperta', 'profil_deschis', 'OP', 'OP', 'PO', 'SA', '', 'true');
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3353,3353,'rectangular','Rechteckprofil','rectangulaire', 'rettangolare', 'dreptunghiular', 'R', 'R', 'R', 'R', 'D', 'true');
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3355,3355,'special','Spezialprofil','profil_special', 'sezione_speciale', 'sectiune_speciala', 'S', 'S', 'PS', 'S', 'S', 'true');
 INSERT INTO qgep_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3357,3357,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', 'U', 'U', 'I', 'S', 'N', 'true');
 ALTER TABLE qgep_od.pipe_profile ADD CONSTRAINT fkey_vl_pipe_profile_profile_type FOREIGN KEY (profile_type)
 REFERENCES qgep_vl.pipe_profile_profile_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.wwtp_energy_use ADD COLUMN fk_waste_water_treatment_plant varchar (16);
ALTER TABLE qgep_od.wwtp_energy_use ADD CONSTRAINT rel_wwtp_energy_use_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES qgep_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.waste_water_treatment_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.waste_water_treatment_kind ADD CONSTRAINT pkey_qgep_vl_waste_water_treatment_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3210,3210,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (387,387,'biological','biologisch','biologique', 'zzz_biologisch', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (388,388,'chemical','chemisch','chimique', 'zzz_chemisch', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (389,389,'filtration','Filtration','filtration', 'zzz_Filtration', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (366,366,'mechanical','mechanisch','mecanique', 'zzz_mechanisch', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3076,3076,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.waste_water_treatment ADD CONSTRAINT fkey_vl_waste_water_treatment_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.waste_water_treatment_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.waste_water_treatment ADD COLUMN fk_waste_water_treatment_plant varchar (16);
ALTER TABLE qgep_od.waste_water_treatment ADD CONSTRAINT rel_waste_water_treatment_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES qgep_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.sludge_treatment_stabilisation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.sludge_treatment_stabilisation ADD CONSTRAINT pkey_qgep_vl_sludge_treatment_stabilisation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (141,141,'aerob_cold','aerobkalt','aerobie_froid', 'zzz_aerobkalt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (332,332,'aerobthermophil','aerobthermophil','aerobie_thermophile', 'zzz_aerobthermophil', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (333,333,'anaerob_cold','anaerobkalt','anaerobie_froid', 'zzz_anaerobkalt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (334,334,'anaerob_mesophil','anaerobmesophil','anaerobie_mesophile', 'zzz_anaerobmesophil', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (335,335,'anaerob_thermophil','anaerobthermophil','anaerobie_thermophile', 'zzz_anaerobthermophil', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2994,2994,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3004,3004,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.sludge_treatment ADD CONSTRAINT fkey_vl_sludge_treatment_stabilisation FOREIGN KEY (stabilisation)
 REFERENCES qgep_vl.sludge_treatment_stabilisation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.sludge_treatment ADD COLUMN fk_waste_water_treatment_plant varchar (16);
ALTER TABLE qgep_od.sludge_treatment ADD CONSTRAINT rel_sludge_treatment_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES qgep_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.water_control_structure ADD COLUMN fk_water_course_segment varchar (16);
ALTER TABLE qgep_od.water_control_structure ADD CONSTRAINT rel_water_control_structure_water_course_segment FOREIGN KEY (fk_water_course_segment) REFERENCES qgep_od.water_course_segment(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.ford ADD CONSTRAINT oorel_od_ford_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.chute ADD CONSTRAINT oorel_od_chute_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.chute_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.chute_kind ADD CONSTRAINT pkey_qgep_vl_chute_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.chute_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3591,3591,'artificial','kuenstlich','artificiel', 'zzz_kuenstlich', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3592,3592,'natural','natuerlich','naturel', 'zzz_natuerlich', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3593,3593,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.chute ADD CONSTRAINT fkey_vl_chute_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.chute_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.chute_material () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.chute_material ADD CONSTRAINT pkey_qgep_vl_chute_material_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.chute_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2633,2633,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (409,409,'concrete_or_rock_pavement','Beton_Steinpflaesterung','beton_pavage_de_pierres', 'zzz_Beton_Steinpflaesterung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (411,411,'rocks_or_boulders','Fels_Steinbloecke','rocher_blocs_de_rocher', 'zzz_Fels_Steinbloecke', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (408,408,'wood','Holz','bois', 'zzz_Holz', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (410,410,'natural_none','natuerlich_kein','naturel_aucun', 'zzz_natuerlich_kein', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.chute_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3061,3061,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.chute ADD CONSTRAINT fkey_vl_chute_material FOREIGN KEY (material)
 REFERENCES qgep_vl.chute_material (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.lock ADD CONSTRAINT oorel_od_lock_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.passage ADD CONSTRAINT oorel_od_passage_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.blocking_debris ADD CONSTRAINT oorel_od_blocking_debris_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.dam ADD CONSTRAINT oorel_od_dam_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.dam_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.dam_kind ADD CONSTRAINT pkey_qgep_vl_dam_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.dam_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (416,416,'retaining_weir','Stauwehr','digue_reservoir', 'zzz_Stauwehr', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.dam_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (417,417,'spillway','Streichwehr','deversoir_lateral', 'sfioratore_laterale', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.dam_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (419,419,'dam','Talsperre','barrage', 'zzz_Talsperre', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.dam_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (418,418,'tyrolean_weir','Tirolerwehr','prise_tyrolienne', 'zzz_Tirolerwehr', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.dam_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3064,3064,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.dam ADD CONSTRAINT fkey_vl_dam_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.dam_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.rock_ramp ADD CONSTRAINT oorel_od_rock_ramp_water_control_structure FOREIGN KEY (obj_id) REFERENCES qgep_od.water_control_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.rock_ramp_stabilisation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.rock_ramp_stabilisation ADD CONSTRAINT pkey_qgep_vl_rock_ramp_stabilisation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2635,2635,'other_smooth','andere_glatt','autres_lisse', 'zzz_altri_glatt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2634,2634,'other_rough','andere_rauh','autres_rugueux', 'zzz_altri_rauh', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (415,415,'concrete_channel','Betonrinne','lit_en_beton', 'zzz_Betonrinne', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (412,412,'rocks_or_boulders','Blockwurf','enrochement', 'zzz_Blockwurf', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (413,413,'paved','gepflaestert','pavement', 'zzz_gepflaestert', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (414,414,'wooden_beam','Holzbalken','poutres_en_bois', 'zzz_Holzbalken', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.rock_ramp_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3063,3063,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.rock_ramp ADD CONSTRAINT fkey_vl_rock_ramp_stabilisation FOREIGN KEY (stabilisation)
 REFERENCES qgep_vl.rock_ramp_stabilisation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.fish_pass ADD COLUMN fk_water_control_structure varchar (16);
ALTER TABLE qgep_od.fish_pass ADD CONSTRAINT rel_fish_pass_water_control_structure FOREIGN KEY (fk_water_control_structure) REFERENCES qgep_od.water_control_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.bathing_area ADD COLUMN fk_chute varchar (16);
ALTER TABLE qgep_od.bathing_area ADD CONSTRAINT rel_bathing_area_chute FOREIGN KEY (fk_chute) REFERENCES qgep_od.surface_water_bodies(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.wastewater_networkelement ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.wastewater_networkelement ADD CONSTRAINT rel_wastewater_networkelement_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.reach_point_elevation_accuracy () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_point_elevation_accuracy ADD CONSTRAINT pkey_qgep_vl_reach_point_elevation_accuracy_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3248,3248,'more_than_6cm','groesser_6cm','plusque_6cm', 'piu_6cm', 'mai_mare_6cm', '', 'G06', 'S06', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3245,3245,'plusminus_1cm','plusminus_1cm','plus_moins_1cm', 'piu_meno_1cm', 'plus_minus_1cm', '', 'P01', 'P01', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3246,3246,'plusminus_3cm','plusminus_3cm','plus_moins_3cm', 'piu_meno_3cm', 'plus_minus_3cm', '', 'P03', 'P03', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3247,3247,'plusminus_6cm','plusminus_6cm','plus_moins_6cm', 'piu_meno_6cm', 'plus_minus_6cm', '', 'P06', 'P06', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5376,5376,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.reach_point ADD CONSTRAINT fkey_vl_reach_point_elevation_accuracy FOREIGN KEY (elevation_accuracy)
 REFERENCES qgep_vl.reach_point_elevation_accuracy (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_point_outlet_shape () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_point_outlet_shape ADD CONSTRAINT pkey_qgep_vl_reach_point_outlet_shape_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5374,5374,'round_edged','abgerundet','arrondie', 'zzz_abgerundet', 'rotunjita', 'RE', 'AR', 'AR', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (298,298,'orifice','blendenfoermig','en_forme_de_seuil_ou_diaphragme', 'zzz_blendenfoermig', 'orificiu', 'O', 'BF', 'FSD', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3358,3358,'no_cross_section_change','keine_Querschnittsaenderung','pas_de_changement_de_section', 'zzz_keine_Querschnittsaenderung', 'fara_schimbare_sectiune', '', 'KQ', 'PCS', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (286,286,'sharp_edged','scharfkantig','aretes_vives', 'zzz_scharfkantig', 'margini_ascutite', '', 'SK', 'AV', '', '', 'true');
 INSERT INTO qgep_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5375,5375,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.reach_point ADD CONSTRAINT fkey_vl_reach_point_outlet_shape FOREIGN KEY (outlet_shape)
 REFERENCES qgep_vl.reach_point_outlet_shape (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.reach_point ADD COLUMN fk_wastewater_networkelement varchar (16);
ALTER TABLE qgep_od.reach_point ADD CONSTRAINT rel_reach_point_wastewater_networkelement FOREIGN KEY (fk_wastewater_networkelement) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE qgep_od.wastewater_node ADD CONSTRAINT oorel_od_wastewater_node_wastewater_networkelement FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.wastewater_node ADD COLUMN fk_hydr_geometry varchar (16);
ALTER TABLE qgep_od.wastewater_node ADD CONSTRAINT rel_wastewater_node_hydr_geometry FOREIGN KEY (fk_hydr_geometry) REFERENCES qgep_od.hydr_geometry(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.reach ADD CONSTRAINT oorel_od_reach_wastewater_networkelement FOREIGN KEY (obj_id) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.reach_elevation_determination () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_elevation_determination ADD CONSTRAINT pkey_qgep_vl_reach_elevation_determination_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4780,4780,'accurate','genau','precise', 'precisa', 'precisa', '', 'LG', 'P', '', '', 'true');
 INSERT INTO qgep_vl.reach_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4778,4778,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.reach_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4779,4779,'inaccurate','ungenau','imprecise', 'impreciso', 'imprecisa', '', 'LU', 'IP', '', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_elevation_determination FOREIGN KEY (elevation_determination)
 REFERENCES qgep_vl.reach_elevation_determination (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_horizontal_positioning () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_horizontal_positioning ADD CONSTRAINT pkey_qgep_vl_reach_horizontal_positioning_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5378,5378,'accurate','genau','precise', 'precisa', 'precisa', '', 'LG', 'P', '', '', 'true');
 INSERT INTO qgep_vl.reach_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5379,5379,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.reach_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5380,5380,'inaccurate','ungenau','imprecise', 'impreciso', 'imprecisa', '', 'LU', 'IP', '', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_horizontal_positioning FOREIGN KEY (horizontal_positioning)
 REFERENCES qgep_vl.reach_horizontal_positioning (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_inside_coating () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_inside_coating ADD CONSTRAINT pkey_qgep_vl_reach_inside_coating_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5383,5383,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (248,248,'coating','Anstrich_Beschichtung','peinture_revetement', 'zzz_Anstrich_Beschichtung', 'strat_vopsea', 'C', 'B', 'PR', '', '', 'true');
 INSERT INTO qgep_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (250,250,'brick_lining','Kanalklinkerauskleidung','revetement_en_brique', 'zzz_Kanalklinkerauskleidung', 'strat_caramida', '', 'KL', 'RB', '', '', 'true');
 INSERT INTO qgep_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (251,251,'stoneware_lining','Steinzeugauskleidung','revetement_en_gres', 'zzz_Steinzeugauskleidung', 'strat_gresie', '', 'ST', 'RG', '', '', 'true');
 INSERT INTO qgep_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5384,5384,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (249,249,'cement_mortar_lining','Zementmoertelauskleidung','revetement_en_mortier_de_ciment', 'zzz_Zementmoertelauskleidung', 'strat_mortar_ciment', '', 'ZM', 'RM', '', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_inside_coating FOREIGN KEY (inside_coating)
 REFERENCES qgep_vl.reach_inside_coating (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_material () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_material ADD CONSTRAINT pkey_qgep_vl_reach_material_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5381,5381,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', 'A', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2754,2754,'asbestos_cement','Asbestzement','amiante_ciment', 'cemento_amianto', 'azbociment', 'AC', 'AZ', 'AC', 'CA', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3638,3638,'concrete_normal','Beton_Normalbeton','beton_normal', 'calcestruzzo_normale', 'beton_normal', 'CN', 'NB', 'BN', 'CN', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3639,3639,'concrete_insitu','Beton_Ortsbeton','beton_coule_sur_place', 'calcestruzzo_gettato_opera', 'beton_turnat_insitu', 'CI', 'OB', 'BCP', 'CGO', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3640,3640,'concrete_presspipe','Beton_Pressrohrbeton','beton_pousse_tube', 'calcestruzzo_spingitubo', 'beton_presstube', 'CP', 'PRB', 'BPT', 'CST', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3641,3641,'concrete_special','Beton_Spezialbeton','beton_special', 'calcestruzzo_speciale', 'beton_special', 'CS', 'SB', 'BS', 'CS', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3256,3256,'concrete_unknown','Beton_unbekannt','beton_inconnu', 'calcestruzzo_sconosciuto', 'beton_necunoscut', 'CU', 'BU', 'BI', 'CSC', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (147,147,'fiber_cement','Faserzement','fibrociment', 'fibrocemento', 'fibrociment', 'FC', 'FZ', 'FC', 'FC', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2755,2755,'bricks','Gebrannte_Steine','terre_cuite', 'ceramica', 'teracota', 'BR', 'SG', 'TC', 'CE', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (148,148,'cast_ductile_iron','Guss_duktil','fonte_ductile', 'ghisa_duttile', 'fonta_ductila', 'ID', 'GD', 'FD', 'GD', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3648,3648,'cast_gray_iron','Guss_Grauguss','fonte_grise', 'ghisa_grigia', 'fonta_cenusie', 'CGI', 'GG', 'FG', 'GG', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5076,5076,'plastic_epoxy_resin','Kunststoff_Epoxydharz','matiere_synthetique_resine_d_epoxy', 'materiale_sintetico_resina_epossidica', 'plastic_rasina_epoxi', 'PER', 'EP', 'EP', 'MSR', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5077,5077,'plastic_highdensity_polyethylene','Kunststoff_Hartpolyethylen','matiere_synthetique_polyethylene_dur', 'materiale_sintetico_polietilene_duro', 'plastic_PEHD', 'HPE', 'HPE', 'PD', 'MSP', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5078,5078,'plastic_polyester_GUP','Kunststoff_Polyester_GUP','matiere_synthetique_polyester_GUP', 'materiale_sintetico_poliestere_GUP', 'plastic_poliester_GUP', 'GUP', 'GUP', 'GUP', 'GUP', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5079,5079,'plastic_polyethylene','Kunststoff_Polyethylen','matiere_synthetique_polyethylene', 'materiale_sintetico_polietilene', 'plastic_PE', 'PE', 'PE', 'PE', 'PE', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5080,5080,'plastic_polypropylene','Kunststoff_Polypropylen','matiere_synthetique_polypropylene', 'materiale_sintetico_polipropilene', 'plastic_polipropilena', 'PP', 'PP', 'PP', 'PP', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5081,5081,'plastic_PVC','Kunststoff_Polyvinilchlorid','matiere_synthetique_PVC', 'materiale_sintetico_PVC', 'plastic_PVC', 'PVC', 'PVC', 'PVC', 'PVC', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5382,5382,'plastic_unknown','Kunststoff_unbekannt','matiere_synthetique_inconnue', 'materiale_sintetico_sconosciuto', 'plastic_necunoscut', 'PU', 'KUU', 'MSI', 'MSC', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (153,153,'steel','Stahl','acier', 'acciaio', 'otel', 'ST', 'ST', 'AC', 'AC', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3654,3654,'steel_stainless','Stahl_rostfrei','acier_inoxydable', 'acciaio_inossidabile', 'inox', 'SST', 'STI', 'ACI', 'ACI', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (154,154,'stoneware','Steinzeug','gres', 'gres', 'gresie', 'SW', 'STZ', 'GR', 'GR', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2761,2761,'clay','Ton','argile', 'argilla', 'argila', 'CL', 'T', 'AR', 'AR', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3016,3016,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', 'U', 'U', 'I', 'SC', '', 'true');
 INSERT INTO qgep_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2762,2762,'cement','Zement','ciment', 'cemento', 'ciment', 'C', 'Z', 'C', 'C', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_material FOREIGN KEY (material)
 REFERENCES qgep_vl.reach_material (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_reliner_material () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_reliner_material ADD CONSTRAINT pkey_qgep_vl_reach_reliner_material_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6459,6459,'other','andere','autre', 'zzz_andere', 'altul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6461,6461,'epoxy_resin_glass_fibre_laminate','Epoxidharz_Glasfaserlaminat','resine_epoxy_lamine_en_fibre_de_verre', 'zzz_Epoxidharz_Glasfaserlaminat', 'rasina_epoxi_laminata_in_fibra_de_sticla', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6460,6460,'epoxy_resin_plastic_felt','Epoxidharz_Kunststofffilz','resine_epoxy_feutre_synthetique', 'zzz_Epoxidharz_Kunststofffilz', 'rasina_epoxi_asemanatoare_plastic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6483,6483,'GUP_pipe','GUP_Rohr','tuyau_PRV', 'zzz_GUP_Rohr', 'conducta_PAFS', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6462,6462,'HDPE','HDPE','HDPE', 'HDPE', 'PEHD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6484,6484,'isocyanate_resin_glass_fibre_laminate','Isocyanatharze_Glasfaserlaminat','isocyanat_resine_lamine_en_fibre_de_verre', 'zzz_Isocynatharze_Glasfaserlaminat', 'izocianat_rasina_laminat_in_fibra_sticla', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6485,6485,'isocyanate_resin_plastic_felt','Isocyanatharze_Kunststofffilz','isocyanat_resine_lamine_feutre_synthetique', 'zzz_Isocynatharze_Kunststofffilz', 'izocianat_rasina_laminat_asemanatoare_plastic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6464,6464,'polyester_resin_glass_fibre_laminate','Polyesterharz_Glasfaserlaminat','resine_de_polyester_lamine_en_fibre_de_verre', 'zzz_Polyesterharz_Glasfaserlaminat', 'rasina_de_poliester_laminata_in_fibra_de_sticla', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6463,6463,'polyester_resin_plastic_felt','Polyesterharz_Kunststofffilz','resine_de_polyester_feutre_synthetique', 'zzz_Polyesterharz_Kunststofffilz', 'rasina_poliester_asemanatare_plastic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6482,6482,'polypropylene','Polypropylen','polypropylene', 'polipropilene', 'polipropilena', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6465,6465,'PVC','Polyvinilchlorid','PVC', 'zzz_Polyvinilchlorid', 'PVC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6466,6466,'bottom_with_polyester_concret_shell','Sohle_mit_Schale_aus_Polyesterbeton','radier_avec_pellicule_en_beton_polyester', 'zzz_Sohle_mit_Schale_aus_Polyesterbeton', 'radier_cu_pelicula_din_beton_poliester', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6467,6467,'unknown','unbekannt','inconnu', 'zzz_unbekannt', 'necunoscut', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6486,6486,'UP_resin_LED_synthetic_fibre_liner','UP_Harz_LED_Synthesefaserliner','UP_resine_LED_fibre_synthetiques_liner', 'zzz_UP_Harz_LED_Synthesefaserliner', 'rasina_UP_LED_captuseala_fibra_sintetica', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6468,6468,'vinyl_ester_resin_glass_fibre_laminate','Vinylesterharz_Glasfaserlaminat','resine_d_ester_vinylique_lamine_en_fibre_de_verre', 'zzz_Vinylesterharz_Glasfaserlaminat', 'rasina_de_ester_vinil_laminata_in_fibra_de_sticla', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6469,6469,'vinyl_ester_resin_plastic_felt','Vinylesterharz_Kunststofffilz','resine_d_ester_vinylique_feutre_synthetique', 'zzz_Vinylesterharz_Kunststofffilz', 'rasina_de_ester_vinil', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_reliner_material FOREIGN KEY (reliner_material)
 REFERENCES qgep_vl.reach_reliner_material (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_relining_construction () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_relining_construction ADD CONSTRAINT pkey_qgep_vl_reach_relining_construction_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6448,6448,'other','andere','autre', 'zzz_andere', 'alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6479,6479,'close_fit_relining','Close_Fit_Relining','close_fit_relining', 'zzz_Close_Fit_Relining', 'reconditionare_close_fit', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6449,6449,'relining_short_tube','Kurzrohrrelining','relining_tube_court', 'zzz_Kurzrohrrelining', 'reconditionare_tub_scurt', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6481,6481,'grouted_in_place_lining','Noppenschlauchrelining','Noppenschlauchrelining', 'zzz_Noppenschlauchrelining', 'chituire', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6452,6452,'partial_liner','Partieller_Liner','liner_partiel', 'zzz_Partieller_Liner', 'captuseala_partiala', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6450,6450,'pipe_string_relining','Rohrstrangrelining','chemisage_par_ligne_de_tuyau', 'zzz_Rohrstrangrelining', 'pipe_string_relining', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6451,6451,'hose_relining','Schlauchrelining','chemisage_par_gainage', 'zzz_Schlauchrelining', 'reconditionare_prin_camasuire', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6453,6453,'unknown','unbekannt','inconnu', 'zzz_unbekannt', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6480,6480,'spiral_lining','Wickelrohrrelining','chemisage_par_tube_spirale', 'zzz_Wickelrohrrelining', 'captusire_prin_tub_spirala', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_relining_construction FOREIGN KEY (relining_construction)
 REFERENCES qgep_vl.reach_relining_construction (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_relining_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_relining_kind ADD CONSTRAINT pkey_qgep_vl_reach_relining_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_relining_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6455,6455,'full_reach','ganze_Haltung','troncon_entier', 'zzz_ganze_Haltung', 'tronson_intreg', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6456,6456,'partial','partiell','partiellement', 'zzz_partiell', 'partial', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_relining_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6457,6457,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.reach ADD CONSTRAINT fkey_vl_reach_relining_kind FOREIGN KEY (relining_kind)
 REFERENCES qgep_vl.reach_relining_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.reach ADD COLUMN fk_reach_point_from varchar (16);
ALTER TABLE qgep_od.reach ADD CONSTRAINT rel_reach_reach_point_from FOREIGN KEY (fk_reach_point_from) REFERENCES qgep_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.reach ADD COLUMN fk_reach_point_to varchar (16);
ALTER TABLE qgep_od.reach ADD CONSTRAINT rel_reach_reach_point_to FOREIGN KEY (fk_reach_point_to) REFERENCES qgep_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.reach ADD COLUMN fk_pipe_profile varchar (16);
ALTER TABLE qgep_od.reach ADD CONSTRAINT rel_reach_pipe_profile FOREIGN KEY (fk_pipe_profile) REFERENCES qgep_od.pipe_profile(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.profile_geometry ADD COLUMN fk_pipe_profile varchar (16);
ALTER TABLE qgep_od.profile_geometry ADD CONSTRAINT rel_profile_geometry_pipe_profile FOREIGN KEY (fk_pipe_profile) REFERENCES qgep_od.pipe_profile(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.hydr_geom_relation ADD COLUMN fk_hydr_geometry varchar (16);
ALTER TABLE qgep_od.hydr_geom_relation ADD CONSTRAINT rel_hydr_geom_relation_hydr_geometry FOREIGN KEY (fk_hydr_geometry) REFERENCES qgep_od.hydr_geometry(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.mechanical_pretreatment_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.mechanical_pretreatment_kind ADD CONSTRAINT pkey_qgep_vl_mechanical_pretreatment_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3317,3317,'filter_bag','Filtersack','percolateur', 'zzz_Filtersack', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3319,3319,'artificial_adsorber','KuenstlicherAdsorber','adsorbeur_artificiel', 'zzz_KuenstlicherAdsorber', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3318,3318,'swale_french_drain_system','MuldenRigolenSystem','systeme_cuvettes_rigoles', 'zzz_MuldenRigolenSystem', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3320,3320,'slurry_collector','Schlammsammler','collecteur_de_boue', 'pozzetto_decantazione', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3321,3321,'floating_matter_separator','Schwimmstoffabscheider','separateur_materiaux_flottants', 'separatore_materiali_galleggianti', 'separator_materie_flotanta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3322,3322,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.mechanical_pretreatment ADD CONSTRAINT fkey_vl_mechanical_pretreatment_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.mechanical_pretreatment_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN fk_infiltration_installation varchar (16);
ALTER TABLE qgep_od.mechanical_pretreatment ADD CONSTRAINT rel_mechanical_pretreatment_infiltration_installation FOREIGN KEY (fk_infiltration_installation) REFERENCES qgep_od.infiltration_installation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.mechanical_pretreatment ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.mechanical_pretreatment ADD CONSTRAINT rel_mechanical_pretreatment_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.retention_body_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.retention_body_kind ADD CONSTRAINT pkey_qgep_vl_retention_body_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2992,2992,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (346,346,'retention_in_habitat','Biotop','retention_dans_bassins_et_depressions', 'zzz_Biotop', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (345,345,'roof_retention','Dachretention','retention_sur_toits', 'zzz_Dachretention', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (348,348,'parking_lot','Parkplatz','retention_sur_routes_et_places', 'zzz_Parkplatz', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (347,347,'accumulation_channel','Staukanal','retention_dans_canalisations_stockage', 'zzz_Staukanal', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3031,3031,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.retention_body ADD CONSTRAINT fkey_vl_retention_body_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.retention_body_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.retention_body ADD COLUMN fk_infiltration_installation varchar (16);
ALTER TABLE qgep_od.retention_body ADD CONSTRAINT rel_retention_body_infiltration_installation FOREIGN KEY (fk_infiltration_installation) REFERENCES qgep_od.infiltration_installation(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.overflow_char_kind_overflow_characteristic () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_char_kind_overflow_characteristic ADD CONSTRAINT pkey_qgep_vl_overflow_char_kind_overflow_characteristic_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_char_kind_overflow_characteristic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6220,6220,'hq','HQ','HQ', 'HQ', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_char_kind_overflow_characteristic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6221,6221,'qq','QQ','QQ', 'QQ', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_char_kind_overflow_characteristic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6228,6228,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow_char ADD CONSTRAINT fkey_vl_overflow_char_kind_overflow_characteristic FOREIGN KEY (kind_overflow_characteristic)
 REFERENCES qgep_vl.overflow_char_kind_overflow_characteristic (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.overflow_char_overflow_characteristic_digital () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_char_overflow_characteristic_digital ADD CONSTRAINT pkey_qgep_vl_overflow_char_overflow_characteristic_digital_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_char_overflow_characteristic_digital (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6223,6223,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_char_overflow_characteristic_digital (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6224,6224,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_char_overflow_characteristic_digital (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6225,6225,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow_char ADD CONSTRAINT fkey_vl_overflow_char_overflow_characteristic_digital FOREIGN KEY (overflow_characteristic_digital)
 REFERENCES qgep_vl.overflow_char_overflow_characteristic_digital (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.hq_relation ADD COLUMN fk_overflow_characteristic varchar (16);
ALTER TABLE qgep_od.hq_relation ADD CONSTRAINT rel_hq_relation_overflow_characteristic FOREIGN KEY (fk_overflow_characteristic) REFERENCES qgep_od.overflow_char(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.structure_part_renovation_demand () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.structure_part_renovation_demand ADD CONSTRAINT pkey_qgep_vl_structure_part_renovation_demand_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.structure_part_renovation_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (138,138,'not_necessary','nicht_notwendig','pas_necessaire', 'zzz_nicht_notwendig', 'nenecesare', 'NN', 'NN', 'PN', '', '', 'true');
 INSERT INTO qgep_vl.structure_part_renovation_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (137,137,'necessary','notwendig','necessaire', 'zzz_notwendig', 'necesare', 'N', 'N', 'N', '', '', 'true');
 INSERT INTO qgep_vl.structure_part_renovation_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5358,5358,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.structure_part ADD CONSTRAINT fkey_vl_structure_part_renovation_demand FOREIGN KEY (renovation_demand)
 REFERENCES qgep_vl.structure_part_renovation_demand (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.structure_part ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.structure_part ADD CONSTRAINT rel_structure_part_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE qgep_od.dryweather_downspout ADD CONSTRAINT oorel_od_dryweather_downspout_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.access_aid ADD CONSTRAINT oorel_od_access_aid_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.access_aid_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.access_aid_kind ADD CONSTRAINT pkey_qgep_vl_access_aid_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5357,5357,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (243,243,'pressurized_door','Drucktuere','porte_etanche', 'zzz_Drucktuere', 'usa_presurizata', 'PD', 'D', 'PE', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (92,92,'none','keine','aucun_equipement_d_acces', 'nessuno', 'inexistent', '', 'K', 'AN', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (240,240,'ladder','Leiter','echelle', 'zzz_Leiter', 'scara', '', 'L', 'EC', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (241,241,'step_iron','Steigeisen','echelons', 'zzz_Steigeisen', 'esaloane', '', 'S', 'ECO', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3473,3473,'staircase','Treppe','escalier', 'zzz_Treppe', 'structura_scari', '', 'R', 'ES', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (91,91,'footstep_niches','Trittnischen','marchepieds', 'zzz_Trittnischen', 'trepte', '', 'N', 'N', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3230,3230,'door','Tuere','porte', 'porta', 'usa', '', 'T', 'P', '', '', 'true');
 INSERT INTO qgep_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3048,3048,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.access_aid ADD CONSTRAINT fkey_vl_access_aid_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.access_aid_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.dryweather_flume ADD CONSTRAINT oorel_od_dryweather_flume_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.dryweather_flume_material () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.dryweather_flume_material ADD CONSTRAINT pkey_qgep_vl_dryweather_flume_material_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3221,3221,'other','andere','autres', 'altri', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (354,354,'combined','kombiniert','combine', 'zzz_kombiniert', 'combinata', '', 'KOM', 'COM', '', '', 'true');
 INSERT INTO qgep_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5356,5356,'plastic','Kunststoff','matiere_synthetique', 'zzz_Kunststoff', 'materie_sintetica', '', 'KU', 'MS', '', '', 'true');
 INSERT INTO qgep_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (238,238,'stoneware','Steinzeug','gres', 'gres', 'gresie', '', 'STZ', 'GR', '', '', 'true');
 INSERT INTO qgep_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3017,3017,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (237,237,'cement_mortar','Zementmoertel','mortier_de_ciment', 'zzz_Zementmoertel', 'mortar_ciment', '', 'ZM', 'MC', '', '', 'true');
 ALTER TABLE qgep_od.dryweather_flume ADD CONSTRAINT fkey_vl_dryweather_flume_material FOREIGN KEY (material)
 REFERENCES qgep_vl.dryweather_flume_material (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.cover ADD CONSTRAINT oorel_od_cover_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.cover_cover_shape () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.cover_cover_shape ADD CONSTRAINT pkey_qgep_vl_cover_cover_shape_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5353,5353,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3499,3499,'rectangular','eckig','anguleux', 'zzz_eckig', 'dreptunghic', 'R', 'E', 'AX', '', '', 'true');
 INSERT INTO qgep_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3498,3498,'round','rund','rond', 'zzz_rund', 'rotund', '', 'R', 'R', '', '', 'true');
 INSERT INTO qgep_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5354,5354,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.cover ADD CONSTRAINT fkey_vl_cover_cover_shape FOREIGN KEY (cover_shape)
 REFERENCES qgep_vl.cover_cover_shape (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.cover_fastening () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.cover_fastening ADD CONSTRAINT pkey_qgep_vl_cover_fastening_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.cover_fastening (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5350,5350,'not_bolted','nicht_verschraubt','non_vissee', 'zzz_nicht_verschraubt', 'neinsurubata', '', 'NVS', 'NVS', '', '', 'true');
 INSERT INTO qgep_vl.cover_fastening (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5351,5351,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.cover_fastening (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5352,5352,'bolted','verschraubt','vissee', 'zzz_verschraubt', 'insurubata', '', 'VS', 'VS', '', '', 'true');
 ALTER TABLE qgep_od.cover ADD CONSTRAINT fkey_vl_cover_fastening FOREIGN KEY (fastening)
 REFERENCES qgep_vl.cover_fastening (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.cover_material () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.cover_material ADD CONSTRAINT pkey_qgep_vl_cover_material_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5355,5355,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO qgep_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (234,234,'concrete','Beton','beton', 'zzz_Beton', 'beton', 'C', 'B', 'B', '', '', 'true');
 INSERT INTO qgep_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (233,233,'cast_iron','Guss','fonte', 'zzz_Guss', 'fonta', '', 'G', 'F', '', '', 'true');
 INSERT INTO qgep_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5547,5547,'cast_iron_with_pavement_filling','Guss_mit_Belagsfuellung','fonte_avec_remplissage_en_robe', 'zzz_Guss_mit_Belagsfuellung', 'fonta_cu_umplutura', 'CIP', 'GBL', 'FRE', '', '', 'true');
 INSERT INTO qgep_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (235,235,'cast_iron_with_concrete_filling','Guss_mit_Betonfuellung','fonte_avec_remplissage_en_beton', 'zzz_Guss_mit_Betonfuellung', 'fonta_cu_umplutura_beton', '', 'GBT', 'FRB', '', '', 'true');
 INSERT INTO qgep_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3015,3015,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.cover ADD CONSTRAINT fkey_vl_cover_material FOREIGN KEY (material)
 REFERENCES qgep_vl.cover_material (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.cover_positional_accuracy () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.cover_positional_accuracy ADD CONSTRAINT pkey_qgep_vl_cover_positional_accuracy_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3243,3243,'more_than_50cm','groesser_50cm','plusque_50cm', 'maggiore_50cm', 'mai_mare_50cm', '', 'G50', 'S50', '', '', 'true');
 INSERT INTO qgep_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3241,3241,'plusminus_10cm','plusminus_10cm','plus_moins_10cm', 'piu_meno_10cm', 'plus_minus_10cm', '', 'P10', 'P10', '', '', 'true');
 INSERT INTO qgep_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3236,3236,'plusminus_3cm','plusminus_3cm','plus_moins_3cm', 'piu_meno_3cm', 'plus_minus_3cm', '', 'P03', 'P03', '', '', 'true');
 INSERT INTO qgep_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3242,3242,'plusminus_50cm','plusminus_50cm','plus_moins_50cm', 'piu_meno_50cm', 'plus_minus_50cm', '', 'P50', 'P50', '', '', 'true');
 INSERT INTO qgep_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5349,5349,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.cover ADD CONSTRAINT fkey_vl_cover_positional_accuracy FOREIGN KEY (positional_accuracy)
 REFERENCES qgep_vl.cover_positional_accuracy (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.cover_sludge_bucket () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.cover_sludge_bucket ADD CONSTRAINT pkey_qgep_vl_cover_sludge_bucket_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.cover_sludge_bucket (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (423,423,'inexistent','nicht_vorhanden','inexistant', 'zzz_nicht_vorhanden', 'inexistent', '', 'NV', 'IE', '', '', 'true');
 INSERT INTO qgep_vl.cover_sludge_bucket (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3066,3066,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO qgep_vl.cover_sludge_bucket (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (422,422,'existent','vorhanden','existant', 'zzz_vorhanden', 'existent', '', 'V', 'E', '', '', 'true');
 ALTER TABLE qgep_od.cover ADD CONSTRAINT fkey_vl_cover_sludge_bucket FOREIGN KEY (sludge_bucket)
 REFERENCES qgep_vl.cover_sludge_bucket (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.cover_venting () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.cover_venting ADD CONSTRAINT pkey_qgep_vl_cover_venting_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.cover_venting (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (229,229,'vented','entlueftet','aere', 'zzz_entlueftet', 'cu_aerisire', '', 'EL', 'AE', '', '', 'true');
 INSERT INTO qgep_vl.cover_venting (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (230,230,'not_vented','nicht_entlueftet','non_aere', 'zzz_nicht_entlueftet', 'fara_aerisire', '', 'NEL', 'NAE', '', '', 'true');
 INSERT INTO qgep_vl.cover_venting (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5348,5348,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.cover ADD CONSTRAINT fkey_vl_cover_venting FOREIGN KEY (venting)
 REFERENCES qgep_vl.cover_venting (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.electric_equipment ADD CONSTRAINT oorel_od_electric_equipment_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.electric_equipment_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.electric_equipment_kind ADD CONSTRAINT pkey_qgep_vl_electric_equipment_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2980,2980,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (376,376,'illumination','Beleuchtung','eclairage', 'zzz_Beleuchtung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3255,3255,'remote_control_system','Fernwirkanlage','installation_de_telecommande', 'zzz_Fernwirkanlage', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (378,378,'radio_unit','Funk','radio', 'zzz_Funk', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (377,377,'phone','Telephon','telephone', 'telefono', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3038,3038,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.electric_equipment ADD CONSTRAINT fkey_vl_electric_equipment_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.electric_equipment_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.electromechanical_equipment ADD CONSTRAINT oorel_od_electromechanical_equipment_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.electromechanical_equipment_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.electromechanical_equipment_kind ADD CONSTRAINT pkey_qgep_vl_electromechanical_equipment_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2981,2981,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (380,380,'leakage_water_pump','Leckwasserpumpe','pompe_d_epuisement', 'zzz_Leckwasserpumpe', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (337,337,'air_dehumidifier','Luftentfeuchter','deshumidificateur', 'zzz_Luftentfeuchter', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (381,381,'scraper_installation','Raeumeinrichtung','dispositif_de_curage', 'zzz_Raeumeinrichtung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3072,3072,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.electromechanical_equipment ADD CONSTRAINT fkey_vl_electromechanical_equipment_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.electromechanical_equipment_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.benching ADD CONSTRAINT oorel_od_benching_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.benching_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.benching_kind ADD CONSTRAINT pkey_qgep_vl_benching_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5319,5319,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (94,94,'double_sided','beidseitig','double', 'zzz_beidseitig', 'dubla', 'DS', 'BB', 'D', '', '', 'true');
 INSERT INTO qgep_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (93,93,'one_sided','einseitig','simple', 'zzz_einseitig', 'simpla', 'OS', 'EB', 'S', '', '', 'true');
 INSERT INTO qgep_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3231,3231,'none','kein','aucun', 'nessuno', 'niciun', '', 'KB', 'AN', '', '', 'true');
 INSERT INTO qgep_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3033,3033,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE qgep_od.benching ADD CONSTRAINT fkey_vl_benching_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.benching_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.connection_object ADD COLUMN fk_wastewater_networkelement varchar (16);
ALTER TABLE qgep_od.connection_object ADD CONSTRAINT rel_connection_object_wastewater_networkelement FOREIGN KEY (fk_wastewater_networkelement) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.connection_object ADD COLUMN fk_owner varchar (16);
ALTER TABLE qgep_od.connection_object ADD CONSTRAINT rel_connection_object_owner FOREIGN KEY (fk_owner) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.connection_object ADD COLUMN fk_operator varchar (16);
ALTER TABLE qgep_od.connection_object ADD CONSTRAINT rel_connection_object_operator FOREIGN KEY (fk_operator) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.building ADD CONSTRAINT oorel_od_building_connection_object FOREIGN KEY (obj_id) REFERENCES qgep_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.reservoir ADD CONSTRAINT oorel_od_reservoir_connection_object FOREIGN KEY (obj_id) REFERENCES qgep_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.individual_surface ADD CONSTRAINT oorel_od_individual_surface_connection_object FOREIGN KEY (obj_id) REFERENCES qgep_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.individual_surface_function () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.individual_surface_function ADD CONSTRAINT pkey_qgep_vl_individual_surface_function_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2979,2979,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3466,3466,'railway_site','Bahnanlagen','installation_ferroviaire', 'zzz_Bahnanlagen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3461,3461,'roof_industrial_or_commercial_building','DachflaecheIndustrieundGewerbebetriebe','surface_toits_bat_industriels_artisanaux', 'zzz_DachflaecheIndustrieundGewerbebetriebe', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3460,3460,'roof_residential_or_office_building','DachflaecheWohnundBuerogebaeude','surface_toits_imm_habitation_administratifs', 'zzz_DachflaecheWohnundBuerogebaeude', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3464,3464,'access_or_collecting_road','Erschliessungs_Sammelstrassen','routes_de_desserte_et_collectives', 'zzz_Erschliessungs_Sammelstrassen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3467,3467,'parking_lot','Parkplaetze','parkings', 'zzz_Parkplaetze', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3462,3462,'transfer_site_or_stockyard','UmschlagundLagerplaetze','places_transbordement_entreposage', 'zzz_UmschlagundLagerplaetze', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3029,3029,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3465,3465,'connecting_or_principal_or_major_road','Verbindungs_Hauptverkehrs_Hochleistungsstrassen','routes_de_raccordement_principales_grand_trafic', '', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3463,3463,'forecourt_and_access_road','VorplaetzeZufahrten','places_devant_entree_acces', 'zzz_VorplaetzeZufahrten', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.individual_surface ADD CONSTRAINT fkey_vl_individual_surface_function FOREIGN KEY (function)
 REFERENCES qgep_vl.individual_surface_function (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.individual_surface_pavement () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.individual_surface_pavement ADD CONSTRAINT pkey_qgep_vl_individual_surface_pavement_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2978,2978,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2031,2031,'paved','befestigt','impermeabilise', 'zzz_befestigt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2032,2032,'forested','bestockt','boise', 'zzz_bestockt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2033,2033,'soil_covered','humusiert','couverture_vegetale', 'zzz_humusiert', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3030,3030,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2034,2034,'barren','vegetationslos','sans_vegetation', 'zzz_vegetationslos', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.individual_surface ADD CONSTRAINT fkey_vl_individual_surface_pavement FOREIGN KEY (pavement)
 REFERENCES qgep_vl.individual_surface_pavement (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.fountain ADD CONSTRAINT oorel_od_fountain_connection_object FOREIGN KEY (obj_id) REFERENCES qgep_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.hazard_source ADD COLUMN fk_connection_object varchar (16);
ALTER TABLE qgep_od.hazard_source ADD CONSTRAINT rel_hazard_source_connection_object FOREIGN KEY (fk_connection_object) REFERENCES qgep_od.connection_object(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.hazard_source ADD COLUMN fk_owner varchar (16);
ALTER TABLE qgep_od.hazard_source ADD CONSTRAINT rel_hazard_source_owner FOREIGN KEY (fk_owner) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.accident ADD COLUMN fk_hazard_source varchar (16);
ALTER TABLE qgep_od.accident ADD CONSTRAINT rel_accident_hazard_source FOREIGN KEY (fk_hazard_source) REFERENCES qgep_od.hazard_source(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.substance ADD COLUMN fk_hazard_source varchar (16);
ALTER TABLE qgep_od.substance ADD CONSTRAINT rel_substance_hazard_source FOREIGN KEY (fk_hazard_source) REFERENCES qgep_od.hazard_source(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.catchment_area_direct_discharge_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_direct_discharge_current ADD CONSTRAINT pkey_qgep_vl_catchment_area_direct_discharge_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_direct_discharge_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5457,5457,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_direct_discharge_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5458,5458,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_direct_discharge_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5463,5463,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_direct_discharge_current FOREIGN KEY (direct_discharge_current)
 REFERENCES qgep_vl.catchment_area_direct_discharge_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_direct_discharge_planned () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_direct_discharge_planned ADD CONSTRAINT pkey_qgep_vl_catchment_area_direct_discharge_planned_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_direct_discharge_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5459,5459,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_direct_discharge_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5460,5460,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_direct_discharge_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5464,5464,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_direct_discharge_planned FOREIGN KEY (direct_discharge_planned)
 REFERENCES qgep_vl.catchment_area_direct_discharge_planned (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_drainage_system_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_drainage_system_current ADD CONSTRAINT pkey_qgep_vl_catchment_area_drainage_system_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5186,5186,'mixed_system','Mischsystem','systeme_unitaire', 'sistema_misto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5188,5188,'modified_system','ModifiziertesSystem','systeme_modifie', 'sistema_modificato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5185,5185,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5537,5537,'not_drained','nicht_entwaessert','non_evacue', 'non_evacuato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5187,5187,'separated_system','Trennsystem','systeme_separatif', 'sistema_separato', 'rrr_Trennsystem', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5189,5189,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_drainage_system_current FOREIGN KEY (drainage_system_current)
 REFERENCES qgep_vl.catchment_area_drainage_system_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_drainage_system_planned () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_drainage_system_planned ADD CONSTRAINT pkey_qgep_vl_catchment_area_drainage_system_planned_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5191,5191,'mixed_system','Mischsystem','systeme_unitaire', 'sistema_misto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5193,5193,'modified_system','ModifiziertesSystem','systeme_modifie', 'sistema_modificato', 'rrr_ModifiziertesSystem', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5194,5194,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5536,5536,'not_drained','nicht_entwaessert','non_evacue', 'non_evacuato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5192,5192,'separated_system','Trennsystem','systeme_separatif', 'sistema_separato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5195,5195,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_drainage_system_planned FOREIGN KEY (drainage_system_planned)
 REFERENCES qgep_vl.catchment_area_drainage_system_planned (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_infiltration_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_infiltration_current ADD CONSTRAINT pkey_qgep_vl_catchment_area_infiltration_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_infiltration_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5452,5452,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_infiltration_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5453,5453,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_infiltration_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5165,5165,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_infiltration_current FOREIGN KEY (infiltration_current)
 REFERENCES qgep_vl.catchment_area_infiltration_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_infiltration_planned () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_infiltration_planned ADD CONSTRAINT pkey_qgep_vl_catchment_area_infiltration_planned_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_infiltration_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5461,5461,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_infiltration_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5462,5462,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_infiltration_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5170,5170,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_infiltration_planned FOREIGN KEY (infiltration_planned)
 REFERENCES qgep_vl.catchment_area_infiltration_planned (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_retention_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_retention_current ADD CONSTRAINT pkey_qgep_vl_catchment_area_retention_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_retention_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5467,5467,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_retention_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5468,5468,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_retention_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5469,5469,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_retention_current FOREIGN KEY (retention_current)
 REFERENCES qgep_vl.catchment_area_retention_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_retention_planned () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_retention_planned ADD CONSTRAINT pkey_qgep_vl_catchment_area_retention_planned_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_retention_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5470,5470,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_retention_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5471,5471,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_retention_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5472,5472,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_retention_planned FOREIGN KEY (retention_planned)
 REFERENCES qgep_vl.catchment_area_retention_planned (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.catchment_area ADD COLUMN fk_wastewater_networkelement_rw_current varchar (16);
ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_rw_current FOREIGN KEY (fk_wastewater_networkelement_rw_current) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.catchment_area ADD COLUMN fk_wastewater_networkelement_rw_planned varchar (16);
ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_rw_planned FOREIGN KEY (fk_wastewater_networkelement_rw_planned) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.catchment_area ADD COLUMN fk_wastewater_networkelement_ww_planned varchar (16);
ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_ww_planned FOREIGN KEY (fk_wastewater_networkelement_ww_planned) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.catchment_area ADD COLUMN fk_wastewater_networkelement_ww_current varchar (16);
ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_ww_current FOREIGN KEY (fk_wastewater_networkelement_ww_current) REFERENCES qgep_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.surface_runoff_parameters ADD COLUMN fk_catchment_area varchar (16);
ALTER TABLE qgep_od.surface_runoff_parameters ADD CONSTRAINT rel_surface_runoff_parameters_catchment_area FOREIGN KEY (fk_catchment_area) REFERENCES qgep_od.catchment_area(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.measuring_point_damming_device () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.measuring_point_damming_device ADD CONSTRAINT pkey_qgep_vl_measuring_point_damming_device_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5720,5720,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5721,5721,'none','keiner','aucun', 'nessuno', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5722,5722,'overflow_weir','Ueberfallwehr','lame_deversante', 'sfioratore', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5724,5724,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5723,5723,'venturi_necking','Venturieinschnuerung','etranglement_venturi', 'zzz_Venturieinschnuerung', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT fkey_vl_measuring_point_damming_device FOREIGN KEY (damming_device)
 REFERENCES qgep_vl.measuring_point_damming_device (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.measuring_point_purpose () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.measuring_point_purpose ADD CONSTRAINT pkey_qgep_vl_measuring_point_purpose_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4595,4595,'both','beides','les_deux', 'entrambi', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4593,4593,'cost_sharing','Kostenverteilung','repartition_des_couts', 'ripartizione_costi', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4594,4594,'technical_purpose','technischer_Zweck','but_technique', 'scopo_tecnico', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4592,4592,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT fkey_vl_measuring_point_purpose FOREIGN KEY (purpose)
 REFERENCES qgep_vl.measuring_point_purpose (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.measuring_point ADD COLUMN fk_operator varchar (16);
ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT rel_measuring_point_operator FOREIGN KEY (fk_operator) REFERENCES qgep_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.measuring_point ADD COLUMN fk_waste_water_treatment_plant varchar (16);
ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT rel_measuring_point_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES qgep_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.measuring_point ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT rel_measuring_point_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.measuring_point ADD COLUMN fk_water_course_segment varchar (16);
ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT rel_measuring_point_water_course_segment FOREIGN KEY (fk_water_course_segment) REFERENCES qgep_od.water_course_segment(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.measuring_device_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.measuring_device_kind ADD CONSTRAINT pkey_qgep_vl_measuring_device_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5702,5702,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5703,5703,'static_sounding_stick','Drucksonde','sonde_de_pression', 'sensore_pressione', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5704,5704,'bubbler_system','Lufteinperlung','injection_bulles_d_air', 'insufflazione', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5705,5705,'EMF_partly_filled','MID_teilgefuellt','MID_partiellement_rempli', 'DEM_riempimento_parziale', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5706,5706,'EMF_filled','MID_vollgefuellt','MID_rempli', 'DEM_riempimento_pieno', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5707,5707,'radar','Radar','radar', 'radar', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5708,5708,'float','Schwimmer','flotteur', 'galleggiante', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6322,6322,'ultrasound','Ultraschall','ultrason', 'zzz_Ultraschall', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5709,5709,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.measuring_device ADD CONSTRAINT fkey_vl_measuring_device_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.measuring_device_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.measuring_device ADD COLUMN fk_measuring_point varchar (16);
ALTER TABLE qgep_od.measuring_device ADD CONSTRAINT rel_measuring_device_measuring_point FOREIGN KEY (fk_measuring_point) REFERENCES qgep_od.measuring_point(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.measurement_series_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.measurement_series_kind ADD CONSTRAINT pkey_qgep_vl_measurement_series_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3217,3217,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2646,2646,'continuous','kontinuierlich','continu', 'zzz_kontinuierlich', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2647,2647,'rain_weather','Regenwetter','temps_de_pluie', 'tempo_pioggia', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3053,3053,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.measurement_series ADD CONSTRAINT fkey_vl_measurement_series_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.measurement_series_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.measurement_series ADD COLUMN fk_measuring_point varchar (16);
ALTER TABLE qgep_od.measurement_series ADD CONSTRAINT rel_measurement_series_measuring_point FOREIGN KEY (fk_measuring_point) REFERENCES qgep_od.measuring_point(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.measurement_result_measurement_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.measurement_result_measurement_type ADD CONSTRAINT pkey_qgep_vl_measurement_result_measurement_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5732,5732,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5733,5733,'flow','Durchfluss','debit', 'zzz_Durchfluss', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5734,5734,'level','Niveau','niveau', 'livello', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5735,5735,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.measurement_result ADD CONSTRAINT fkey_vl_measurement_result_measurement_type FOREIGN KEY (measurement_type)
 REFERENCES qgep_vl.measurement_result_measurement_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.measurement_result ADD COLUMN fk_measuring_device varchar (16);
ALTER TABLE qgep_od.measurement_result ADD CONSTRAINT rel_measurement_result_measuring_device FOREIGN KEY (fk_measuring_device) REFERENCES qgep_od.measuring_device(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.measurement_result ADD COLUMN fk_measurement_series varchar (16);
ALTER TABLE qgep_od.measurement_result ADD CONSTRAINT rel_measurement_result_measurement_series FOREIGN KEY (fk_measurement_series) REFERENCES qgep_od.measurement_series(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE qgep_vl.overflow_actuation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_actuation ADD CONSTRAINT pkey_qgep_vl_overflow_actuation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3667,3667,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (301,301,'gaz_engine','Benzinmotor','moteur_a_essence', 'zzz_Benzinmotor', 'motor_benzina', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (302,302,'diesel_engine','Dieselmotor','moteur_diesel', 'zzz_Dieselmotor', 'motor_diesel', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (303,303,'electric_engine','Elektromotor','moteur_electrique', 'zzz_Elektromotor', 'motor_electric', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (433,433,'hydraulic','hydraulisch','hydraulique', 'zzz_hydraulisch', 'hidraulic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (300,300,'none','keiner','aucun', 'nessuno', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (305,305,'manual','manuell','manuel', 'zzz_manuell', 'manual', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (304,304,'pneumatic','pneumatisch','pneumatique', 'zzz_pneumatisch', 'pneumatic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3005,3005,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow ADD CONSTRAINT fkey_vl_overflow_actuation FOREIGN KEY (actuation)
 REFERENCES qgep_vl.overflow_actuation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.overflow_adjustability () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_adjustability ADD CONSTRAINT pkey_qgep_vl_overflow_adjustability_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (355,355,'fixed','fest','fixe', 'zzz_fest', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3021,3021,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (356,356,'adjustable','verstellbar','reglable', 'zzz_verstellbar', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow ADD CONSTRAINT fkey_vl_overflow_adjustability FOREIGN KEY (adjustability)
 REFERENCES qgep_vl.overflow_adjustability (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.overflow_control () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_control ADD CONSTRAINT pkey_qgep_vl_overflow_control_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (308,308,'closed_loop_control','geregelt','avec_regulation', 'zzz_geregelt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (307,307,'open_loop_control','gesteuert','avec_commande', 'zzz_gesteuert', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (306,306,'none','keine','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3028,3028,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow ADD CONSTRAINT fkey_vl_overflow_control FOREIGN KEY (control)
 REFERENCES qgep_vl.overflow_control (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.overflow_function () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_function ADD CONSTRAINT pkey_qgep_vl_overflow_function_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3228,3228,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3384,3384,'internal','intern','interne', 'zzz_intern', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (217,217,'emergency_overflow','Notentlastung','deversoir_de_secours', 'zzz_Notentlastung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5544,5544,'stormwater_overflow','Regenueberlauf','deversoir_d_orage', 'scaricatore_piena', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5546,5546,'internal_overflow','Trennueberlauf','deversoir_interne', 'zzz_Trennueberlauf', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3010,3010,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow ADD CONSTRAINT fkey_vl_overflow_function FOREIGN KEY (function)
 REFERENCES qgep_vl.overflow_function (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.overflow_signal_transmission () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.overflow_signal_transmission ADD CONSTRAINT pkey_qgep_vl_overflow_signal_transmission_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2694,2694,'receiving','empfangen','recevoir', 'zzz_empfangen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2693,2693,'sending','senden','emettre', 'zzz_senden', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2695,2695,'sending_receiving','senden_empfangen','emettre_recevoir', 'zzz_senden_empfangen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3056,3056,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.overflow ADD CONSTRAINT fkey_vl_overflow_signal_transmission FOREIGN KEY (signal_transmission)
 REFERENCES qgep_vl.overflow_signal_transmission (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.overflow ADD COLUMN fk_wastewater_node varchar (16);
ALTER TABLE qgep_od.overflow ADD CONSTRAINT rel_overflow_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES qgep_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.overflow ADD COLUMN fk_overflow_to varchar (16);
ALTER TABLE qgep_od.overflow ADD CONSTRAINT rel_overflow_overflow_to FOREIGN KEY (fk_overflow_to) REFERENCES qgep_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.overflow ADD COLUMN fk_overflow_characteristic varchar (16);
ALTER TABLE qgep_od.overflow ADD CONSTRAINT rel_overflow_overflow_characteristic FOREIGN KEY (fk_overflow_characteristic) REFERENCES qgep_od.overflow_char(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.overflow ADD COLUMN fk_control_center varchar (16);
ALTER TABLE qgep_od.overflow ADD CONSTRAINT rel_overflow_control_center FOREIGN KEY (fk_control_center) REFERENCES qgep_od.control_center(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.throttle_shut_off_unit_actuation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.throttle_shut_off_unit_actuation ADD CONSTRAINT pkey_qgep_vl_throttle_shut_off_unit_actuation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3213,3213,'other','andere','autres', 'altri', 'altul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3154,3154,'gaz_engine','Benzinmotor','moteur_a_essence', 'zzz_Benzinmotor', 'motor_benzina', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3155,3155,'diesel_engine','Dieselmotor','moteur_diesel', 'zzz_Dieselmotor', 'motor_diesel', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3156,3156,'electric_engine','Elektromotor','moteur_electrique', 'zzz_Elektromotor', 'motor_electric', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3152,3152,'hydraulic','hydraulisch','hydraulique', 'zzz_hydraulisch', 'hidraulic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3153,3153,'none','keiner','aucun', 'nessuno', 'niciunul', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3157,3157,'manual','manuell','manuel', 'zzz_manuell', 'manual', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3158,3158,'pneumatic','pneumatisch','pneumatique', 'zzz_pneumatisch', 'pneumatic', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3151,3151,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_actuation FOREIGN KEY (actuation)
 REFERENCES qgep_vl.throttle_shut_off_unit_actuation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.throttle_shut_off_unit_adjustability () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.throttle_shut_off_unit_adjustability ADD CONSTRAINT pkey_qgep_vl_throttle_shut_off_unit_adjustability_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.throttle_shut_off_unit_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3159,3159,'fixed','fest','fixe', 'zzz_fest', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3161,3161,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3160,3160,'adjustable','verstellbar','reglable', 'zzz_verstellbar', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_adjustability FOREIGN KEY (adjustability)
 REFERENCES qgep_vl.throttle_shut_off_unit_adjustability (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.throttle_shut_off_unit_control () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.throttle_shut_off_unit_control ADD CONSTRAINT pkey_qgep_vl_throttle_shut_off_unit_control_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3162,3162,'closed_loop_control','geregelt','avec_regulation', 'zzz_geregelt', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3163,3163,'open_loop_control','gesteuert','avec_commande', 'zzz_gesteuert', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3165,3165,'none','keine','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3164,3164,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_control FOREIGN KEY (control)
 REFERENCES qgep_vl.throttle_shut_off_unit_control (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.throttle_shut_off_unit_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.throttle_shut_off_unit_kind ADD CONSTRAINT pkey_qgep_vl_throttle_shut_off_unit_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2973,2973,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2746,2746,'orifice','Blende','diaphragme_ou_seuil', 'zzz_Blende', 'diafragma_sau_prag', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2691,2691,'stop_log','Dammbalken','batardeau', 'zzz_Dammbalken', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (252,252,'throttle_flap','Drosselklappe','clapet_de_limitation', 'zzz_Drosselklappe', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (135,135,'throttle_valve','Drosselschieber','vanne_de_limitation', 'zzz_Drosselschieber', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6490,6490,'throttle_section','Drosselstrecke','conduite_d_etranglement', 'zzz_Drosselstrecke', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6491,6491,'leapingweir','Leapingwehr','leaping_weir', 'zzz_Leapingwehr', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6492,6492,'pomp','Pumpe','pompe', 'zzz_Pumpe', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2690,2690,'backflow_flap','Rueckstauklappe','clapet_de_non_retour_a_battant', 'zzz_Rueckstauklappe', 'clapeta _antirefulare', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2688,2688,'valve','Schieber','vanne', 'zzz_Schieber', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (134,134,'tube_throttle','Schlauchdrossel','limiteur_a_membrane', 'zzz_Schlauchdrossel', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2689,2689,'sliding_valve','Schuetze','vanne_ecluse', 'zzz_Schuetze', 'vana_cu?it', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5755,5755,'gate_shield','Stauschild','plaque_de_retenue', 'paratoia_cilindrica', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3046,3046,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (133,133,'whirl_throttle','Wirbeldrossel','limiteur_a_vortex', 'zzz_Wirbeldrossel', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.throttle_shut_off_unit_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.throttle_shut_off_unit_signal_transmission () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.throttle_shut_off_unit_signal_transmission ADD CONSTRAINT pkey_qgep_vl_throttle_shut_off_unit_signal_transmission_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3171,3171,'receiving','empfangen','recevoir', 'zzz_empfangen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3172,3172,'sending','senden','emettre', 'zzz_senden', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3169,3169,'sending_receiving','senden_empfangen','emettre_recevoir', 'zzz_senden_empfangen', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3170,3170,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_signal_transmission FOREIGN KEY (signal_transmission)
 REFERENCES qgep_vl.throttle_shut_off_unit_signal_transmission (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN fk_wastewater_node varchar (16);
ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT rel_throttle_shut_off_unit_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES qgep_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN fk_control_center varchar (16);
ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT rel_throttle_shut_off_unit_control_center FOREIGN KEY (fk_control_center) REFERENCES qgep_od.control_center(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.throttle_shut_off_unit ADD COLUMN fk_overflow varchar (16);
ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT rel_throttle_shut_off_unit_overflow FOREIGN KEY (fk_overflow) REFERENCES qgep_od.overflow(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.prank_weir ADD CONSTRAINT oorel_od_prank_weir_overflow FOREIGN KEY (obj_id) REFERENCES qgep_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.prank_weir_weir_edge () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.prank_weir_weir_edge ADD CONSTRAINT pkey_qgep_vl_prank_weir_weir_edge_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2995,2995,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (351,351,'rectangular','rechteckig','angulaire', 'zzz_rechteckig', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (350,350,'round','rund','arrondie', 'zzz_rund', 'rotund', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (349,349,'sharp_edged','scharfkantig','arete_vive', 'zzz_scharfkantig', 'margini_ascutite', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3014,3014,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.prank_weir ADD CONSTRAINT fkey_vl_prank_weir_weir_edge FOREIGN KEY (weir_edge)
 REFERENCES qgep_vl.prank_weir_weir_edge (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.prank_weir_weir_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.prank_weir_weir_kind ADD CONSTRAINT pkey_qgep_vl_prank_weir_weir_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.prank_weir_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5772,5772,'raised','hochgezogen','a_seuil_sureleve', 'laterale_alto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.prank_weir_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5771,5771,'low','niedrig','a_seuil_abaisse', 'laterale_basso', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.prank_weir ADD CONSTRAINT fkey_vl_prank_weir_weir_kind FOREIGN KEY (weir_kind)
 REFERENCES qgep_vl.prank_weir_weir_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.pump ADD CONSTRAINT oorel_od_pump_overflow FOREIGN KEY (obj_id) REFERENCES qgep_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.pump_construction_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.pump_construction_type ADD CONSTRAINT pkey_qgep_vl_pump_contruction_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2983,2983,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2662,2662,'compressed_air_system','Druckluftanlage','systeme_a_air_comprime', 'impianto_aria_compressa', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (314,314,'piston_pump','Kolbenpumpe','pompe_a_piston', 'pompa_pistoni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (309,309,'centrifugal_pump','Kreiselpumpe','pompe_centrifuge', 'pompa_centrifuga', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (310,310,'screw_pump','Schneckenpumpe','pompe_a_vis', 'pompa_a_vite', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3082,3082,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2661,2661,'vacuum_system','Vakuumanlage','systeme_a_vide_d_air', 'impinato_a_vuoto_aria', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.pump ADD CONSTRAINT fkey_vl_pump_construction_type FOREIGN KEY (construction_type)
 REFERENCES qgep_vl.pump_construction_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.pump_placement_of_actuation () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.pump_placement_of_actuation ADD CONSTRAINT pkey_qgep_vl_pump_placement_of_actuation_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.pump_placement_of_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (318,318,'wet','nass','immerge', 'zzz_nass', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_placement_of_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (311,311,'dry','trocken','non_submersible', 'zzz_trocken', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_placement_of_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3070,3070,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.pump ADD CONSTRAINT fkey_vl_pump_placement_of_actuation FOREIGN KEY (placement_of_actuation)
 REFERENCES qgep_vl.pump_placement_of_actuation (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.pump_placement_of_pump () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.pump_placement_of_pump ADD CONSTRAINT pkey_qgep_vl_pump_placement_of_pump_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.pump_placement_of_pump (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (362,362,'horizontal','horizontal','horizontal', 'zzz_horizontal', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_placement_of_pump (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3071,3071,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_placement_of_pump (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (363,363,'vertical','vertikal','vertical', 'zzz_vertikal', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.pump ADD CONSTRAINT fkey_vl_pump_placement_of_pump FOREIGN KEY (placement_of_pump)
 REFERENCES qgep_vl.pump_placement_of_pump (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.pump_usage_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.pump_usage_current ADD CONSTRAINT pkey_qgep_vl_pump_usage_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6325,6325,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6202,6202,'creek_water','Bachwasser','eaux_cours_d_eau', 'acqua_corso_acqua', 'ape_curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6203,6203,'discharged_combined_wastewater','entlastetes_Mischabwasser','eaux_mixtes_deversees', 'acque_miste_scaricate', 'ape_mixte_deversate', 'DCW', 'EW', 'EUD', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6204,6204,'industrial_wastewater','Industrieabwasser','eaux_industrielles', 'acque_industriali', 'ape_industriale', '', 'CW', 'EUC', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6201,6201,'combined_wastewater','Mischabwasser','eaux_mixtes', 'acque_miste', 'ape_mixte', '', 'MW', 'EUM', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6205,6205,'rain_wastewater','Regenabwasser','eaux_pluviales', 'acque_meteoriche', 'apa_meteorica', '', 'RW', 'EUP', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6200,6200,'clean_wastewater','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EUR', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6206,6206,'wastewater','Schmutzabwasser','eaux_usees', 'acque_luride', '', '', 'SW', 'EU', '', '', 'true');
 INSERT INTO qgep_vl.pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6326,6326,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.pump ADD CONSTRAINT fkey_vl_pump_usage_current FOREIGN KEY (usage_current)
 REFERENCES qgep_vl.pump_usage_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.leapingweir ADD CONSTRAINT oorel_od_leapingweir_overflow FOREIGN KEY (obj_id) REFERENCES qgep_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.leapingweir_opening_shape () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.leapingweir_opening_shape ADD CONSTRAINT pkey_qgep_vl_leapingweir_opening_shape_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3581,3581,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3582,3582,'circle','Kreis','circulaire', 'zzz_Kreis', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3585,3585,'parable','Parabel','parabolique', 'zzz_Parabel', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3583,3583,'rectangular','Rechteck','rectangulaire', 'zzz_Rechteck', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3584,3584,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.leapingweir ADD CONSTRAINT fkey_vl_leapingweir_opening_shape FOREIGN KEY (opening_shape)
 REFERENCES qgep_vl.leapingweir_opening_shape (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.hydraulic_char_data_is_overflowing () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.hydraulic_char_data_is_overflowing ADD CONSTRAINT pkey_qgep_vl_hydraulic_char_data_is_overflowing_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.hydraulic_char_data_is_overflowing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5774,5774,'yes','ja','oui', 'si', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_is_overflowing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5775,5775,'no','nein','non', 'no', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_is_overflowing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5778,5778,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_is_overflowing FOREIGN KEY (is_overflowing)
 REFERENCES qgep_vl.hydraulic_char_data_is_overflowing (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.hydraulic_char_data_main_weir_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.hydraulic_char_data_main_weir_kind ADD CONSTRAINT pkey_qgep_vl_hydraulic_char_data_main_weir_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.hydraulic_char_data_main_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6422,6422,'leapingweir','Leapingwehr','LEAPING_WEIR', 'zzz_Leapingwehr', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_main_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6420,6420,'spillway_raised','Streichwehr_hochgezogen','deversoir_lateral_a_seuil_sureleve', 'stramazzo_laterale_alto', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_main_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6421,6421,'spillway_low','Streichwehr_niedrig','deversoir_lateral_a_seuil_abaisse', 'stamazzo_laterale_basso', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_main_weir_kind FOREIGN KEY (main_weir_kind)
 REFERENCES qgep_vl.hydraulic_char_data_main_weir_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.hydraulic_char_data_pump_characteristics () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.hydraulic_char_data_pump_characteristics ADD CONSTRAINT pkey_qgep_vl_hydraulic_char_data_pump_characteristics_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6374,6374,'alternating','alternierend','alterne', 'alternato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6375,6375,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6376,6376,'single','einzeln','individuel', 'singolo', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6377,6377,'parallel','parallel','parallele', 'parallelo', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6378,6378,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_pump_characteristics FOREIGN KEY (pump_characteristics)
 REFERENCES qgep_vl.hydraulic_char_data_pump_characteristics (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.hydraulic_char_data_pump_usage_current () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.hydraulic_char_data_pump_usage_current ADD CONSTRAINT pkey_qgep_vl_hydraulic_char_data_pump_usage_current_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6361,6361,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6362,6362,'creek_water','Bachwasser','eaux_cours_d_eau', 'acqua_corso_acqua', 'ape_curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6363,6363,'discharged_combined_wastewater','entlastetes_Mischabwasser','eaux_mixtes_deversees', 'acque_miste_scaricate', 'ape_mixte_deversate', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6364,6364,'industrial_wastewater','Industrieabwasser','eaux_industrielles', 'acque_industriali', 'ape_industriale', '', 'CW', 'EUC', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6365,6365,'combined_wastewater','Mischabwasser','eaux_mixtes', 'acque_miste', 'ape_mixte', '', 'MW', 'EUM', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6366,6366,'rain_wastewater','Regenabwasser','eaux_pluviales', 'acque_meteoriche', 'apa_meteorica', '', 'RW', 'EUP', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6367,6367,'clean_wastewater','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EUR', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6368,6368,'wastewater','Schmutzabwasser','eaux_usees', 'acque_luride', '', '', 'SW', 'EU', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_pump_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6369,6369,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_pump_usage_current FOREIGN KEY (pump_usage_current)
 REFERENCES qgep_vl.hydraulic_char_data_pump_usage_current (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.hydraulic_char_data_status () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.hydraulic_char_data_status ADD CONSTRAINT pkey_qgep_vl_hydraulic_char_data_status_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.hydraulic_char_data_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6371,6371,'planned','geplant','prevu', 'pianificato', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6372,6372,'current','Ist','actuel', 'attuale', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.hydraulic_char_data_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6373,6373,'current_optimized','Ist_optimiert','actuel_opt', 'attuale_ottimizzato', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_status FOREIGN KEY (status)
 REFERENCES qgep_vl.hydraulic_char_data_status (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN fk_wastewater_node varchar (16);
ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT rel_hydraulic_char_data_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES qgep_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.hydraulic_char_data ADD COLUMN fk_overflow_characteristic varchar (16);
ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT rel_hydraulic_char_data_overflow_characteristic FOREIGN KEY (fk_overflow_characteristic) REFERENCES qgep_od.overflow_char(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.backflow_prevention ADD CONSTRAINT oorel_od_backflow_prevention_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.backflow_prevention_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.backflow_prevention_kind ADD CONSTRAINT pkey_qgep_vl_backflow_prevention_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5760,5760,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5759,5759,'pump','Pumpe','pompe', 'pompa', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5757,5757,'backflow_flap','Rueckstauklappe','clapet_de_non_retour_a_battant', 'zzz_Rueckstauklappe', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5758,5758,'gate_shield','Stauschild','plaque_de_retenue', 'paratoia_cilindrica', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.backflow_prevention ADD CONSTRAINT fkey_vl_backflow_prevention_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.backflow_prevention_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.backflow_prevention ADD COLUMN fk_throttle_shut_off_unit varchar (16);
ALTER TABLE qgep_od.backflow_prevention ADD CONSTRAINT rel_backflow_prevention_throttle_shut_off_unit FOREIGN KEY (fk_throttle_shut_off_unit) REFERENCES qgep_od.throttle_shut_off_unit(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.backflow_prevention ADD COLUMN fk_pump varchar (16);
ALTER TABLE qgep_od.backflow_prevention ADD CONSTRAINT rel_backflow_prevention_pump FOREIGN KEY (fk_pump) REFERENCES qgep_od.pump(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.solids_retention ADD CONSTRAINT oorel_od_solids_retention_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.solids_retention_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.solids_retention_type ADD CONSTRAINT pkey_qgep_vl_solids_retention_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5664,5664,'other','andere','autres', 'altri', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5665,5665,'fine_screen','Feinrechen','grille_fine', 'griglia_fine', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5666,5666,'coarse_screen','Grobrechen','grille_grossiere', 'griglia_grossa', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5667,5667,'sieve','Sieb','tamis', 'filtro', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5668,5668,'scumboard','Tauchwand','paroi_plongeante', 'parete_sommersa', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5669,5669,'unknown','unbekannt','inconnu', 'sconosciuto', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.solids_retention ADD CONSTRAINT fkey_vl_solids_retention_type FOREIGN KEY (type)
 REFERENCES qgep_vl.solids_retention_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.tank_cleaning ADD CONSTRAINT oorel_od_tank_cleaning_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.tank_cleaning_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.tank_cleaning_type ADD CONSTRAINT pkey_qgep_vl_tank_cleaning_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5621,5621,'airjet','Air_Jet','aeration_et_brassage', 'airjet', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5620,5620,'other','andere','autre', 'altro', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5622,5622,'none','keine','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5623,5623,'surge_flushing','Schwallspuelung','rincage_en_cascade', 'zzz_Schwallspülung', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5624,5624,'tipping_bucket','Spuelkippe','bac_de_rincage', 'zzz_Spuelkippe', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.tank_cleaning ADD CONSTRAINT fkey_vl_tank_cleaning_type FOREIGN KEY (type)
 REFERENCES qgep_vl.tank_cleaning_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.tank_emptying ADD CONSTRAINT oorel_od_tank_emptying_structure_part FOREIGN KEY (obj_id) REFERENCES qgep_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE qgep_vl.tank_emptying_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.tank_emptying_type ADD CONSTRAINT pkey_qgep_vl_tank_emptying_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5626,5626,'other','andere','autre', 'altro', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5627,5627,'none','keine','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5628,5628,'pump','Pumpe','pompe', 'pompa', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5629,5629,'valve','Schieber','vanne', 'zzz_Schieber', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.tank_emptying ADD CONSTRAINT fkey_vl_tank_emptying_type FOREIGN KEY (type)
 REFERENCES qgep_vl.tank_emptying_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.tank_emptying ADD COLUMN fk_throttle_shut_off_unit varchar (16);
ALTER TABLE qgep_od.tank_emptying ADD CONSTRAINT rel_tank_emptying_throttle_shut_off_unit FOREIGN KEY (fk_throttle_shut_off_unit) REFERENCES qgep_od.throttle_shut_off_unit(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.tank_emptying ADD COLUMN fk_overflow varchar (16);
ALTER TABLE qgep_od.tank_emptying ADD CONSTRAINT rel_tank_emptying_overflow FOREIGN KEY (fk_overflow) REFERENCES qgep_od.pump(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE qgep_od.param_ca_general ADD CONSTRAINT oorel_od_param_ca_general_surface_runoff_parameters FOREIGN KEY (obj_id) REFERENCES qgep_od.surface_runoff_parameters(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE qgep_od.param_ca_mouse1 ADD CONSTRAINT oorel_od_param_ca_mouse1_surface_runoff_parameters FOREIGN KEY (obj_id) REFERENCES qgep_od.surface_runoff_parameters(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;

------------ Text and Symbol Tables ----------- ;
-------
CREATE TABLE qgep_od.wastewater_structure_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wastewater_structure_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wastewater_structure_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wastewater_structure_text ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wastewater_structure_text');
COMMENT ON COLUMN qgep_od.wastewater_structure_text.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure_text.plantype IS '';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.wastewater_structure_text.remark IS 'General remarks';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN text  text ;
COMMENT ON COLUMN qgep_od.wastewater_structure_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN qgep_od.wastewater_structure_text.texthali IS '';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.wastewater_structure_text.textori IS '';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_wastewater_structure_text_textpos_geometry ON qgep_od.wastewater_structure_text USING gist (textpos_geometry );
COMMENT ON COLUMN qgep_od.wastewater_structure_text.textpos_geometry IS '';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN qgep_od.wastewater_structure_text.textvali IS '';
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.wastewater_structure_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_wastewater_structure_text
BEFORE UPDATE OR INSERT ON
 qgep_od.wastewater_structure_text
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.reach_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_reach_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_reach_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.reach_text ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','reach_text');
COMMENT ON COLUMN qgep_od.reach_text.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.reach_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN qgep_od.reach_text.plantype IS '';
ALTER TABLE qgep_od.reach_text ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.reach_text.remark IS 'General remarks';
ALTER TABLE qgep_od.reach_text ADD COLUMN text  text ;
COMMENT ON COLUMN qgep_od.reach_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
ALTER TABLE qgep_od.reach_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN qgep_od.reach_text.texthali IS '';
ALTER TABLE qgep_od.reach_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.reach_text.textori IS '';
ALTER TABLE qgep_od.reach_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_reach_text_textpos_geometry ON qgep_od.reach_text USING gist (textpos_geometry );
COMMENT ON COLUMN qgep_od.reach_text.textpos_geometry IS '';
ALTER TABLE qgep_od.reach_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN qgep_od.reach_text.textvali IS '';
ALTER TABLE qgep_od.reach_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.reach_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_reach_text
BEFORE UPDATE OR INSERT ON
 qgep_od.reach_text
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.catchment_area_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_catchment_area_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_catchment_area_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.catchment_area_text ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','catchment_area_text');
COMMENT ON COLUMN qgep_od.catchment_area_text.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN qgep_od.catchment_area_text.plantype IS '';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.catchment_area_text.remark IS 'General remarks';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN text  text ;
COMMENT ON COLUMN qgep_od.catchment_area_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN qgep_od.catchment_area_text.texthali IS '';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.catchment_area_text.textori IS '';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_catchment_area_text_textpos_geometry ON qgep_od.catchment_area_text USING gist (textpos_geometry );
COMMENT ON COLUMN qgep_od.catchment_area_text.textpos_geometry IS '';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN qgep_od.catchment_area_text.textvali IS '';
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.catchment_area_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_catchment_area_text
BEFORE UPDATE OR INSERT ON
 qgep_od.catchment_area_text
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.wastewater_structure_symbol
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_wastewater_structure_symbol_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_wastewater_structure_symbol_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.wastewater_structure_symbol ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','wastewater_structure_symbol');
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.obj_id IS '[primary_key] INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN plantype  integer ;
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.plantype IS '';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN symbol_scaling_heigth  decimal(2,1) ;
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.symbol_scaling_heigth IS '';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN symbol_scaling_width  decimal(2,1) ;
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.symbol_scaling_width IS '';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN symbolori  decimal(4,1) ;
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.symbolori IS '';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN symbolpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_qgep_od_wastewater_structure_symbol_symbolpos_geometry ON qgep_od.wastewater_structure_symbol USING gist (symbolpos_geometry );
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.symbolpos_geometry IS '';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN fk_provider varchar (16);
COMMENT ON COLUMN qgep_od.wastewater_structure_symbol.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wastewater_structure_symbol
BEFORE UPDATE OR INSERT ON
 qgep_od.wastewater_structure_symbol
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();
-------

------------ Text and Symbol Tables Relationships ----------- ;
ALTER TABLE qgep_od.wastewater_structure_text ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.wastewater_structure_text ADD CONSTRAINT rel_wastewater_structure_text_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE qgep_od.reach_text ADD COLUMN fk_reach varchar (16);
ALTER TABLE qgep_od.reach_text ADD CONSTRAINT rel_reach_text_reach FOREIGN KEY (fk_reach) REFERENCES qgep_od.reach(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE qgep_od.catchment_area_text ADD COLUMN fk_catchment_area varchar (16);
ALTER TABLE qgep_od.catchment_area_text ADD CONSTRAINT rel_catchment_area_text_catchment_area FOREIGN KEY (fk_catchment_area) REFERENCES qgep_od.catchment_area(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE qgep_od.wastewater_structure_symbol ADD COLUMN fk_wastewater_structure varchar (16);
ALTER TABLE qgep_od.wastewater_structure_symbol ADD CONSTRAINT rel_wastewater_structure_symbol_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES qgep_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;

------------ Text and Symbol Tables Values ----------- ;
CREATE TABLE qgep_vl.wastewater_structure_text_plantype () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_text_plantype ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_text_plantype_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', '', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure_text ADD CONSTRAINT fkey_vl_wastewater_structure_text_plantype FOREIGN KEY (plantype)
 REFERENCES qgep_vl.wastewater_structure_text_plantype (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_text_texthali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_text_texthali ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_text_texthali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure_text ADD CONSTRAINT fkey_vl_wastewater_structure_text_texthali FOREIGN KEY (texthali)
 REFERENCES qgep_vl.wastewater_structure_text_texthali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_text_textvali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_text_textvali ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_text_textvali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure_text ADD CONSTRAINT fkey_vl_wastewater_structure_text_textvali FOREIGN KEY (textvali)
 REFERENCES qgep_vl.wastewater_structure_text_textvali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_text_plantype () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_text_plantype ADD CONSTRAINT pkey_qgep_vl_reach_text_plantype_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', '', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.reach_text ADD CONSTRAINT fkey_vl_reach_text_plantype FOREIGN KEY (plantype)
 REFERENCES qgep_vl.reach_text_plantype (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_text_texthali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_text_texthali ADD CONSTRAINT pkey_qgep_vl_reach_text_texthali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.reach_text ADD CONSTRAINT fkey_vl_reach_text_texthali FOREIGN KEY (texthali)
 REFERENCES qgep_vl.reach_text_texthali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.reach_text_textvali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.reach_text_textvali ADD CONSTRAINT pkey_qgep_vl_reach_text_textvali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.reach_text ADD CONSTRAINT fkey_vl_reach_text_textvali FOREIGN KEY (textvali)
 REFERENCES qgep_vl.reach_text_textvali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_text_plantype () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_text_plantype ADD CONSTRAINT pkey_qgep_vl_catchment_area_text_plantype_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', '', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area_text ADD CONSTRAINT fkey_vl_catchment_area_text_plantype FOREIGN KEY (plantype)
 REFERENCES qgep_vl.catchment_area_text_plantype (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_text_texthali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_text_texthali ADD CONSTRAINT pkey_qgep_vl_catchment_area_text_texthali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area_text ADD CONSTRAINT fkey_vl_catchment_area_text_texthali FOREIGN KEY (texthali)
 REFERENCES qgep_vl.catchment_area_text_texthali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.catchment_area_text_textvali () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.catchment_area_text_textvali ADD CONSTRAINT pkey_qgep_vl_catchment_area_text_textvali_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.catchment_area_text ADD CONSTRAINT fkey_vl_catchment_area_text_textvali FOREIGN KEY (textvali)
 REFERENCES qgep_vl.catchment_area_text_textvali (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.wastewater_structure_symbol_plantype () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.wastewater_structure_symbol_plantype ADD CONSTRAINT pkey_qgep_vl_wastewater_structure_symbol_plantype_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7874,7874,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7876,7876,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7877,7877,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7878,7878,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', '', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7875,7875,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', '', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.wastewater_structure_symbol ADD CONSTRAINT fkey_vl_wastewater_structure_symbol_plantype FOREIGN KEY (plantype)
 REFERENCES qgep_vl.wastewater_structure_symbol_plantype (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
--------- Relations to class organisation for dataowner and provider (new 3.11.2014);

ALTER TABLE qgep_od.txt_symbol ADD CONSTRAINT rel_txt_symbol_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.txt_symbol ADD CONSTRAINT rel_txt_symbol_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.mutation ADD CONSTRAINT rel_od_mutation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.mutation ADD CONSTRAINT rel_od_mutation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.aquifier ADD CONSTRAINT rel_od_aquifier_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.aquifier ADD CONSTRAINT rel_od_aquifier_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.surface_water_bodies ADD CONSTRAINT rel_od_surface_water_bodies_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.surface_water_bodies ADD CONSTRAINT rel_od_surface_water_bodies_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT rel_od_water_course_segment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.water_course_segment ADD CONSTRAINT rel_od_water_course_segment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.water_catchment ADD CONSTRAINT rel_od_water_catchment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.water_catchment ADD CONSTRAINT rel_od_water_catchment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.river_bank ADD CONSTRAINT rel_od_river_bank_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.river_bank ADD CONSTRAINT rel_od_river_bank_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.river_bed ADD CONSTRAINT rel_od_river_bed_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.river_bed ADD CONSTRAINT rel_od_river_bed_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.sector_water_body ADD CONSTRAINT rel_od_sector_water_body_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.sector_water_body ADD CONSTRAINT rel_od_sector_water_body_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.organisation ADD CONSTRAINT rel_od_organisation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.organisation ADD CONSTRAINT rel_od_organisation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT rel_od_wastewater_structure_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wastewater_structure ADD CONSTRAINT rel_od_wastewater_structure_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.maintenance_event ADD CONSTRAINT rel_od_maintenance_event_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.maintenance_event ADD CONSTRAINT rel_od_maintenance_event_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.zone ADD CONSTRAINT rel_od_zone_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.zone ADD CONSTRAINT rel_od_zone_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.pipe_profile ADD CONSTRAINT rel_od_pipe_profile_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.pipe_profile ADD CONSTRAINT rel_od_pipe_profile_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wwtp_energy_use ADD CONSTRAINT rel_od_wwtp_energy_use_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wwtp_energy_use ADD CONSTRAINT rel_od_wwtp_energy_use_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.waste_water_treatment ADD CONSTRAINT rel_od_waste_water_treatment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.waste_water_treatment ADD CONSTRAINT rel_od_waste_water_treatment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.sludge_treatment ADD CONSTRAINT rel_od_sludge_treatment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.sludge_treatment ADD CONSTRAINT rel_od_sludge_treatment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.control_center ADD CONSTRAINT rel_od_control_center_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.control_center ADD CONSTRAINT rel_od_control_center_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.water_control_structure ADD CONSTRAINT rel_od_water_control_structure_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.water_control_structure ADD CONSTRAINT rel_od_water_control_structure_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.fish_pass ADD CONSTRAINT rel_od_fish_pass_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.fish_pass ADD CONSTRAINT rel_od_fish_pass_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.bathing_area ADD CONSTRAINT rel_od_bathing_area_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.bathing_area ADD CONSTRAINT rel_od_bathing_area_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hydr_geometry ADD CONSTRAINT rel_od_hydr_geometry_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hydr_geometry ADD CONSTRAINT rel_od_hydr_geometry_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wastewater_networkelement ADD CONSTRAINT rel_od_wastewater_networkelement_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wastewater_networkelement ADD CONSTRAINT rel_od_wastewater_networkelement_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.reach_point ADD CONSTRAINT rel_od_reach_point_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.reach_point ADD CONSTRAINT rel_od_reach_point_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.profile_geometry ADD CONSTRAINT rel_od_profile_geometry_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.profile_geometry ADD CONSTRAINT rel_od_profile_geometry_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hydr_geom_relation ADD CONSTRAINT rel_od_hydr_geom_relation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hydr_geom_relation ADD CONSTRAINT rel_od_hydr_geom_relation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.mechanical_pretreatment ADD CONSTRAINT rel_od_mechanical_pretreatment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.mechanical_pretreatment ADD CONSTRAINT rel_od_mechanical_pretreatment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.retention_body ADD CONSTRAINT rel_od_retention_body_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.retention_body ADD CONSTRAINT rel_od_retention_body_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.overflow_char ADD CONSTRAINT rel_od_overflow_char_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.overflow_char ADD CONSTRAINT rel_od_overflow_char_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hq_relation ADD CONSTRAINT rel_od_hq_relation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hq_relation ADD CONSTRAINT rel_od_hq_relation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.structure_part ADD CONSTRAINT rel_od_structure_part_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.structure_part ADD CONSTRAINT rel_od_structure_part_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.connection_object ADD CONSTRAINT rel_od_connection_object_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.connection_object ADD CONSTRAINT rel_od_connection_object_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hazard_source ADD CONSTRAINT rel_od_hazard_source_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hazard_source ADD CONSTRAINT rel_od_hazard_source_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.accident ADD CONSTRAINT rel_od_accident_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.accident ADD CONSTRAINT rel_od_accident_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.substance ADD CONSTRAINT rel_od_substance_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.substance ADD CONSTRAINT rel_od_substance_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT rel_od_catchment_area_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.catchment_area ADD CONSTRAINT rel_od_catchment_area_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.surface_runoff_parameters ADD CONSTRAINT rel_od_surface_runoff_parameters_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.surface_runoff_parameters ADD CONSTRAINT rel_od_surface_runoff_parameters_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT rel_od_measuring_point_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measuring_point ADD CONSTRAINT rel_od_measuring_point_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measuring_device ADD CONSTRAINT rel_od_measuring_device_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measuring_device ADD CONSTRAINT rel_od_measuring_device_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measurement_series ADD CONSTRAINT rel_od_measurement_series_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measurement_series ADD CONSTRAINT rel_od_measurement_series_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measurement_result ADD CONSTRAINT rel_od_measurement_result_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.measurement_result ADD CONSTRAINT rel_od_measurement_result_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.overflow ADD CONSTRAINT rel_od_overflow_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.overflow ADD CONSTRAINT rel_od_overflow_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT rel_od_throttle_shut_off_unit_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.throttle_shut_off_unit ADD CONSTRAINT rel_od_throttle_shut_off_unit_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT rel_od_hydraulic_char_data_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.hydraulic_char_data ADD CONSTRAINT rel_od_hydraulic_char_data_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wastewater_structure_symbol ADD CONSTRAINT rel_od_wastewater_structure_symbol_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.wastewater_structure_symbol ADD CONSTRAINT rel_od_wastewater_structure_symbol_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);

------ Indexes on identifiers

 CREATE UNIQUE INDEX in_od_aquifier_identifier ON qgep_od.aquifier USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_surface_water_bodies_identifier ON qgep_od.surface_water_bodies USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_water_course_segment_identifier ON qgep_od.water_course_segment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_water_catchment_identifier ON qgep_od.water_catchment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_river_bank_identifier ON qgep_od.river_bank USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_river_bed_identifier ON qgep_od.river_bed USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_sector_water_body_identifier ON qgep_od.sector_water_body USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_organisation_identifier ON qgep_od.organisation USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_wastewater_structure_identifier ON qgep_od.wastewater_structure USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_maintenance_event_identifier ON qgep_od.maintenance_event USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_zone_identifier ON qgep_od.zone USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_pipe_profile_identifier ON qgep_od.pipe_profile USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_wwtp_energy_use_identifier ON qgep_od.wwtp_energy_use USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_waste_water_treatment_identifier ON qgep_od.waste_water_treatment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_sludge_treatment_identifier ON qgep_od.sludge_treatment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_control_center_identifier ON qgep_od.control_center USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_water_control_structure_identifier ON qgep_od.water_control_structure USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_fish_pass_identifier ON qgep_od.fish_pass USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_bathing_area_identifier ON qgep_od.bathing_area USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_hydr_geometry_identifier ON qgep_od.hydr_geometry USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_wastewater_networkelement_identifier ON qgep_od.wastewater_networkelement USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_reach_point_identifier ON qgep_od.reach_point USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_mechanical_pretreatment_identifier ON qgep_od.mechanical_pretreatment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_retention_body_identifier ON qgep_od.retention_body USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_overflow_char_identifier ON qgep_od.overflow_char USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_structure_part_identifier ON qgep_od.structure_part USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_connection_object_identifier ON qgep_od.connection_object USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_hazard_source_identifier ON qgep_od.hazard_source USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_accident_identifier ON qgep_od.accident USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_substance_identifier ON qgep_od.substance USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_catchment_area_identifier ON qgep_od.catchment_area USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_surface_runoff_parameters_identifier ON qgep_od.surface_runoff_parameters USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measuring_point_identifier ON qgep_od.measuring_point USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measuring_device_identifier ON qgep_od.measuring_device USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measurement_series_identifier ON qgep_od.measurement_series USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measurement_result_identifier ON qgep_od.measurement_result USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_overflow_identifier ON qgep_od.overflow USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_throttle_shut_off_unit_identifier ON qgep_od.throttle_shut_off_unit USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_hydraulic_char_data_identifier ON qgep_od.hydraulic_char_data USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);

COMMIT;
