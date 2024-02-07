------ This file generates the VSA-DSS database (Modul VSA-DSS (2020)) in en on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 13.12.2023 17:33:32
------ with 3D coordinates

---------------------------

CREATE TABLE tww_vl.value_list_base
(
code integer NOT NULL,
vsacode integer NOT NULL,
value_en character varying(100),
value_de character varying(100),
value_fr character varying(100),
value_it character varying(100),
value_ro character varying(100),
abbr_en character varying(3),
abbr_de character varying(3),
abbr_fr character varying(3),
abbr_it character varying(3),
abbr_ro character varying(3),
active boolean,
CONSTRAINT pkey_tww_value_list_code PRIMARY KEY (code)
)
WITH (
   OIDS = False
);
-------
CREATE TABLE tww_od.re_building_group_disposal
(
   id uuid NOT NULL DEFAULT uuid_generate_v4(),
   CONSTRAINT pkey_tww_od_re_building_group_disposal_id PRIMARY KEY (id)
);
COMMENT ON COLUMN tww_od.re_building_group_disposal.id IS 'UUID generated with uuid_generate_v4 see https://www.postgresql.org/docs/16/uuid-ossp.html#UUID-OSSP-FUNCTIONS-SECT';
-------
CREATE TABLE tww_od.re_maintenance_event_wastewater_structure
(
   id uuid NOT NULL DEFAULT uuid_generate_v4(),
   CONSTRAINT pkey_tww_od_re_maintenance_event_wastewater_structure_id PRIMARY KEY (id)
);
COMMENT ON COLUMN tww_od.re_maintenance_event_wastewater_structure.id IS 'UUID generated with uuid_generate_v4 see https://www.postgresql.org/docs/16/uuid-ossp.html#UUID-OSSP-FUNCTIONS-SECT';
-------
CREATE TABLE tww_od.txt_symbol
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_txt_symbol_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_txt_symbol_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.txt_symbol ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','txt_symbol');
COMMENT ON COLUMN tww_od.txt_symbol.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.txt_symbol ADD COLUMN classname text;
 ALTER TABLE tww_od.txt_symbol ADD CONSTRAINT sx_classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.txt_symbol.classname IS 'Name of class that symbol class is related to / Name der Klasse zu der die Symbolklasse gehört / nom de la classe à laquelle appartient la classe de symbole';
 ALTER TABLE tww_od.txt_symbol ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.txt_symbol.plantype IS '';
 ALTER TABLE tww_od.txt_symbol ADD COLUMN symbol_scaling_heigth  decimal(2,1) ;
COMMENT ON COLUMN tww_od.txt_symbol.symbol_scaling_heigth IS '';
 ALTER TABLE tww_od.txt_symbol ADD COLUMN symbol_scaling_width  decimal(2,1) ;
COMMENT ON COLUMN tww_od.txt_symbol.symbol_scaling_width IS '';
 ALTER TABLE tww_od.txt_symbol ADD COLUMN symbolori  decimal(4,1) ;
COMMENT ON COLUMN tww_od.txt_symbol.symbolori IS 'Default: 90 Degree / Default: 90 Grad / Default: 90 degree';
ALTER TABLE tww_od.txt_symbol ADD COLUMN symbolpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_txt_symbol_symbolpos_geometry ON tww_od.txt_symbol USING gist (symbolpos_geometry );
COMMENT ON COLUMN tww_od.txt_symbol.symbolpos_geometry IS '';
 ALTER TABLE tww_od.txt_symbol ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.txt_symbol.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_symbol
BEFORE UPDATE OR INSERT ON
 tww_od.txt_symbol
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.txt_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_txt_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_txt_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.txt_text ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','txt_text');
COMMENT ON COLUMN tww_od.txt_text.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.txt_text ADD COLUMN classname text;
 ALTER TABLE tww_od.txt_text ADD CONSTRAINT tx_classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.txt_text.classname IS 'Name of class that textclass is related to / Name der Klasse zu der die Textklasse gehört / nom de la classe à laquelle appartient la classe de texte';
 ALTER TABLE tww_od.txt_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.txt_text.plantype IS '';
 ALTER TABLE tww_od.txt_text ADD COLUMN remark text;
 ALTER TABLE tww_od.txt_text ADD CONSTRAINT tx_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.txt_text.remark IS 'General remarks';
 ALTER TABLE tww_od.txt_text ADD COLUMN text  text ;
COMMENT ON COLUMN tww_od.txt_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
 ALTER TABLE tww_od.txt_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN tww_od.txt_text.texthali IS '';
 ALTER TABLE tww_od.txt_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN tww_od.txt_text.textori IS '';
ALTER TABLE tww_od.txt_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_txt_text_textpos_geometry ON tww_od.txt_text USING gist (textpos_geometry );
COMMENT ON COLUMN tww_od.txt_text.textpos_geometry IS '';
 ALTER TABLE tww_od.txt_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN tww_od.txt_text.textvali IS '';
 ALTER TABLE tww_od.txt_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.txt_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_text
BEFORE UPDATE OR INSERT ON
 tww_od.txt_text
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.progression_alternative
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_progression_alternative_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_progression_alternative_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.progression_alternative ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','progression_alternative');
COMMENT ON COLUMN tww_od.progression_alternative.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.progression_alternative ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.progression_alternative.plantype IS '';
ALTER TABLE tww_od.progression_alternative ADD COLUMN progression_geometry geometry('COMPOUNDCURVE', :SRID);
CREATE INDEX in_tww_progression_alternative_progression_geometry ON tww_od.progression_alternative USING gist (progression_geometry );
COMMENT ON COLUMN tww_od.progression_alternative.progression_geometry IS 'Start, inflextion and endpoints of a progression alterative for selected scale (e.g. overview map) / Anfangs-, Knick- und Endpunkte des Alternativverlaufs der Leitung im gewählten Plantyp (z.B. Uebersichtsplan) / Points de départ, intermédiaires et d’arrivée de la trace alternative de la conduite dans la type de plan selectionée';
 ALTER TABLE tww_od.progression_alternative ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.progression_alternative.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_progression_alternative
BEFORE UPDATE OR INSERT ON
 tww_od.progression_alternative
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.organisation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_organisation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_organisation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.organisation ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','organisation');
COMMENT ON COLUMN tww_od.organisation.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.organisation ADD COLUMN identifier text;
 ALTER TABLE tww_od.organisation ADD CONSTRAINT og_identifier_length_max_255 CHECK(char_length(identifier)<=255);
COMMENT ON COLUMN tww_od.organisation.identifier IS 'The designation for municipalities is adopted according to the FSO list; for private individuals according to the UID register, if necessary with the addition of the location of the branch if no separate UID exists for it. / Die Bezeichnung für Gemeinden wird gemäss BFS-Liste übernommen; für Private gemäss UID-Register, allenfalls mit Zusatz des Ortes der Filiale, falls keine separate UID dafür besteht. / La désignation pour les communes est reprise selon la liste de l''OFS ; pour les particuliers, selon le registre UID, éventuellement avec l''ajout du lieu de la filiale s''il n''existe pas d''UID séparé pour celle-ci.';
 ALTER TABLE tww_od.organisation ADD COLUMN identifier_short text;
 ALTER TABLE tww_od.organisation ADD CONSTRAINT og_identifier_short_length_max_12 CHECK(char_length(identifier_short)<=12);
COMMENT ON COLUMN tww_od.organisation.identifier_short IS ' / Kurzbezeichnung / désignation abrégée';
 ALTER TABLE tww_od.organisation ADD COLUMN municipality_number  smallint ;
COMMENT ON COLUMN tww_od.organisation.municipality_number IS 'Official number of municipality of federal office for statistics, mandatory for the municipalities. / Offizielle Gemeinde Nummer gemäss Bundesamt für Statistik, bei Gemeinden zwingend, sonst leer lassen. / Numéro officiel de la commune selon l''Office fédéral de la statistique, obligatoire pour les communes. Sinon, laissez vide.';
 ALTER TABLE tww_od.organisation ADD COLUMN organisation_type  integer ;
COMMENT ON COLUMN tww_od.organisation.organisation_type IS 'Type of organisatoin / Art der Organisation / Genre d''organisation';
 ALTER TABLE tww_od.organisation ADD COLUMN remark text;
 ALTER TABLE tww_od.organisation ADD CONSTRAINT og_remark_length_max_255 CHECK(char_length(remark)<=255);
COMMENT ON COLUMN tww_od.organisation.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.organisation ADD COLUMN status  integer ;
COMMENT ON COLUMN tww_od.organisation.status IS 'yyy_Status der Organisation, damit untergegangende Organisationen nicht einfach gelöscht werden müssen und kontrolliert werden kann, ob noch Beziehungen auf untergegangene Organisationen, z.B. bei Gemeindefusion oder Konkurs einer Firma vorhanden sind / Status der Organisation, damit untergegangende Organisationen nicht einfach gelöscht werden müssen und kontrolliert werden kann, ob noch Beziehungen auf untergegangene Organisationen, z.B. bei Gemeindefusion oder Konkurs einer Firma vorhanden sind / Statut de l''organisation, pour que les organisations disparues ne soient pas simplement supprimées et qu''il soit possible de contrôler s''il existe encore des relations avec les organisations disparues, par exemple en cas de fusion de communes ou de faillite d''une société';
 ALTER TABLE tww_od.organisation ADD COLUMN uid text;
 ALTER TABLE tww_od.organisation ADD CONSTRAINT og_uid_length_max_12 CHECK(char_length(uid)<=12);
COMMENT ON COLUMN tww_od.organisation.uid IS 'Reference to the company identification of the Federal Office for Statistics (www.uid.admin.ch), e.g. CHE123456789 / Referenz zur Unternehmensidentifikation des Bundesamts fuer Statistik (www.uid.admin.ch), z.B. CHE123456789 / Référence pour l’identification des entreprises selon l’Office fédéral de la statistique OFS (www.uid.admin.ch), par exemple: CHE123456789';
 ALTER TABLE tww_od.organisation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.organisation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.organisation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.organisation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.organisation ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.organisation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_organisation
BEFORE UPDATE OR INSERT ON
 tww_od.organisation
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.measure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_measure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_measure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.measure ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','measure');
COMMENT ON COLUMN tww_od.measure.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.measure ADD COLUMN category  integer ;
COMMENT ON COLUMN tww_od.measure.category IS 'Category of measure (mandatory) / Massnahmenkategorie (obligatorisch) / Catégorie de la mesure (obligatoire)';
 ALTER TABLE tww_od.measure ADD COLUMN date_entry  timestamp without time zone ;
COMMENT ON COLUMN tww_od.measure.date_entry IS 'Entry date, when the measure was added to the list of measures / Datum, an welchem die Massnahme in die Massnahmenliste aufgenommen wurde / Date d''entrée de la mesure dans le plan d''actions';
 ALTER TABLE tww_od.measure ADD COLUMN description text;
 ALTER TABLE tww_od.measure ADD CONSTRAINT mm_description_length_max_100 CHECK(char_length(description)<=100);
COMMENT ON COLUMN tww_od.measure.description IS '';
 ALTER TABLE tww_od.measure ADD COLUMN identifier text;
 ALTER TABLE tww_od.measure ADD CONSTRAINT mm_identifier_length_max_50 CHECK(char_length(identifier)<=50);
COMMENT ON COLUMN tww_od.measure.identifier IS 'Identifier of the measure. The identification follows certain rules (see Wegleitung GEP-Daten) / Bezeichnung der Massnahme. Die Bezeichnung erfolgt nach bestimmten Regeln (siehe Wegleitung GEP-Daten) / Désignation de la mesure. La désignation suit des règles précises (cf. guide des données PGEE)';
 ALTER TABLE tww_od.measure ADD COLUMN intervention_demand text;
 ALTER TABLE tww_od.measure ADD CONSTRAINT mm_intervention_demand_length_max_255 CHECK(char_length(intervention_demand)<=255);
COMMENT ON COLUMN tww_od.measure.intervention_demand IS 'Short description of need of action / Kurzbeschreibung des Handlungsbedarfs / Description courte du besoin d''intervention';
ALTER TABLE tww_od.measure ADD COLUMN line_geometry geometry('COMPOUNDCURVE', :SRID);
CREATE INDEX in_tww_measure_line_geometry ON tww_od.measure USING gist (line_geometry );
COMMENT ON COLUMN tww_od.measure.line_geometry IS 'yyy_Ermöglicht die Visualisierung einer Massnahme mit einer Linie (optional) / Ermöglicht die Visualisierung einer Massnahme mit einer Linie (optional) / Permet la visualisation d''une mesure à l''aide d''une ligne (optionnelle)';
 ALTER TABLE tww_od.measure ADD COLUMN link text;
 ALTER TABLE tww_od.measure ADD CONSTRAINT mm_link_length_max_255 CHECK(char_length(link)<=255);
COMMENT ON COLUMN tww_od.measure.link IS 'Reference to other measure (identifier)  or works done. Reference to documents, that specify details of the measure, e.g. GEP reports or documents or project papers. / Verweis auf andere Massnahmen (Bezeichnung) oder Arbeiten, Hinweis auf Grundlagen in denen die Massnahmen näher erläutert werden, wie z.B. auf die entsprechenden GEP-Teilprojekte / Référence à d’autres mesures ou travaux, documents explicatifs concernant la mesure, par exemple les projets partiels PGEE ou rapports d’état';
ALTER TABLE tww_od.measure ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_measure_perimeter_geometry ON tww_od.measure USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.measure.perimeter_geometry IS 'Perimeter, for visualisation and geometrical relation (OPTIONAL) / Ermöglicht die Visualisierung einer Massnahme mit einer Fläche (optional) / Pour la visualisation et l’illustration avec une surface (optionelle)';
 ALTER TABLE tww_od.measure ADD COLUMN priority  integer ;
COMMENT ON COLUMN tww_od.measure.priority IS 'Priority of measure / Priorität der Massnahme / Priorité de la mesure.';
 ALTER TABLE tww_od.measure ADD COLUMN remark text;
 ALTER TABLE tww_od.measure ADD CONSTRAINT mm_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.measure.remark IS 'General remarks of project designer or controlling institution / Bemerkungen des Projektverfassers oder der Aufsichtsbehörde / Remarques du gestionnaire du projet ou de l''autorité de surveillance';
 ALTER TABLE tww_od.measure ADD COLUMN status  integer ;
COMMENT ON COLUMN tww_od.measure.status IS 'Disposition state of measure / Status der Massnahme / Etat de la mesure';
ALTER TABLE tww_od.measure ADD COLUMN symbolpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_measure_symbolpos_geometry ON tww_od.measure USING gist (symbolpos_geometry );
COMMENT ON COLUMN tww_od.measure.symbolpos_geometry IS 'For the visualisation (without geometric relation) / Für die Visualisierung (ohne räumlichen Bezug) / Pour la visualisation (sans relation géométrique)';
 ALTER TABLE tww_od.measure ADD COLUMN total_cost  decimal(10,2) ;
COMMENT ON COLUMN tww_od.measure.total_cost IS 'Sum of own and cost of third parties. Eventually they can be listed also seperately. / Summe der Eigenleistung und Kosten Dritter. Allenfalls können diese zusätzlich auch separat ausgewiesen werden / Somme des contributions propres et des coûts de parties tiers. Ils peuvent également être justifiés séparément';
 ALTER TABLE tww_od.measure ADD COLUMN year_implementation_effective  smallint ;
COMMENT ON COLUMN tww_od.measure.year_implementation_effective IS 'Year the measure was actually implemented / Jahr, in dem die Massnahme effektiv umgesetzt wurde / Année à laquelle la mesure a effectivement été mise en œuvre';
 ALTER TABLE tww_od.measure ADD COLUMN year_implementation_planned  smallint ;
COMMENT ON COLUMN tww_od.measure.year_implementation_planned IS 'Planned year of implementation / Jahr bis die Massnahme umgesetzt sein soll / Année à laquelle la mesure devrait être mise en œuvre';
 ALTER TABLE tww_od.measure ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.measure.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.measure ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.measure.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.measure ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.measure.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measure
BEFORE UPDATE OR INSERT ON
 tww_od.measure
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.mutation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_mutation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_mutation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.mutation ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','mutation');
COMMENT ON COLUMN tww_od.mutation.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.mutation ADD COLUMN attribute text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_attribute_length_max_60 CHECK(char_length(attribute)<=60);
COMMENT ON COLUMN tww_od.mutation.attribute IS 'Attribute name of chosen object / Attributname des gewählten Objektes / Nom de l''attribut de l''objet à sélectionner';
 ALTER TABLE tww_od.mutation ADD COLUMN classname text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.mutation.classname IS 'Class name of chosen object / Klassenname des gewählten Objektes / Nom de classe de l''objet à sélectionner';
 ALTER TABLE tww_od.mutation ADD COLUMN date_mutation  timestamp without time zone ;
COMMENT ON COLUMN tww_od.mutation.date_mutation IS 'if changed: Date/Time of changement. If deleted date/time of deleting / Bei geaendert Datum/Zeit der Änderung. Bei gelöscht Datum/Zeit der Löschung / changée: Date/Temps du changement. effacée: Date/Temps de la suppression';
 ALTER TABLE tww_od.mutation ADD COLUMN date_time  timestamp without time zone ;
COMMENT ON COLUMN tww_od.mutation.date_time IS 'Date/Time of collecting data in the field. Else Date/Time of creating data set on the system / Datum/Zeit der Aufnahme im Feld falls vorhanden bei erstellt. Sonst Datum/Uhrzeit der Erstellung auf dem System / Date/temps de la relève, sinon date/temps de création dans le système. Sinon, date/heure de création sur le système';
 ALTER TABLE tww_od.mutation ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.mutation.kind IS '';
 ALTER TABLE tww_od.mutation ADD COLUMN last_value text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_last_value_length_max_255 CHECK(char_length(last_value)<=255);
COMMENT ON COLUMN tww_od.mutation.last_value IS 'last_value changed to text. Only with type=changed and deleted / Letzter Wert umgewandelt in Text. Nur bei ART=geaendert oder geloescht / Dernière valeur modifiée du texte. Seulement avec GENRE = changee ou effacee';
 ALTER TABLE tww_od.mutation ADD COLUMN object text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_object_length_max_16 CHECK(char_length(object)<=16);
COMMENT ON COLUMN tww_od.mutation.object IS 'OID of Object / OID des Objektes / OID de l''objet';
 ALTER TABLE tww_od.mutation ADD COLUMN recorded_by text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_recorded_by_length_max_255 CHECK(char_length(recorded_by)<=255);
COMMENT ON COLUMN tww_od.mutation.recorded_by IS 'Name of person who recorded the dataset / Name des Aufnehmers im Feld / Nom de la personne, qui a relevé les données';
 ALTER TABLE tww_od.mutation ADD COLUMN remark text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.mutation.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.mutation ADD COLUMN system_user text;
 ALTER TABLE tww_od.mutation ADD CONSTRAINT md_system_user_length_max_60 CHECK(char_length(system_user)<=60);
COMMENT ON COLUMN tww_od.mutation.system_user IS 'Name of system user / Name des Systembenutzers / Usager du système informatique';
 ALTER TABLE tww_od.mutation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.mutation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.mutation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.mutation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.mutation ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.mutation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_mutation
BEFORE UPDATE OR INSERT ON
 tww_od.mutation
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.waste_water_treatment_plant
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_waste_water_treatment_plant_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_waste_water_treatment_plant_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.waste_water_treatment_plant ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','waste_water_treatment_plant');
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN area_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_waste_water_treatment_plant_area_geometry ON tww_od.waste_water_treatment_plant USING gist (area_geometry );
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.area_geometry IS 'yyy_Geometrie des Einzugsgebiets der ARA (Zuständigkeitsgebiet) als zusammenhängende Fläche, die sich in der Regel an den Gemeindegrenzen orientiert. Ein Einzugsgebiet setzt sich aus einer oder mehreren Gemeindeflächen oder Teilflächen von Gemeinden zusammen. Matching MGDM 134.5 Einzugsgebiet.Gebiet / Geometrie des Einzugsgebiets der ARA (Zuständigkeitsgebiet) als zusammenhängende Fläche, die sich in der Regel an den Gemeindegrenzen orientiert. Ein Einzugsgebiet setzt sich aus einer oder mehreren Gemeindeflächen oder Teilflächen von Gemeinden zusammen. Matching MGDM 134.5 Einzugsgebiet.Gebiet / Géométrie du bassin versant de la STEP (domaine de compétence) comme surface d’un seul tenant, qui se base généralement sur les frontières communales. Un bassin versant se compose d’une ou de plusieurs surfaces communales ou surfaces partielles communales. Matching MGDM 134.5 Einzugsgebiet.Gebiet';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN bod5  smallint ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.bod5 IS '5 day biochemical oxygen demand measured at a temperatur of 20 degree celsius. YYY / Biochemischer Sauerstoffbedarf nach 5 Tagen Messzeit und bei einer Temperatur vom 20 Grad Celsius. Er stellt den Verbrauch an gelöstem Sauerstoff durch die Lebensvorgänge der im Wasser oder Abwasser enthaltenen Mikroorganismen (Bakterienprotozoen) beim  Abbau organischer Substanzen dar. Der Wert stellt eine wichtige Grösse zur Beurteilung der  aerob abbaufähigen Substanzen dar. Der BSB5 wird in den Einheiten mg/l oder g/m3 angegeben. Ausser dem BSB5 wird der biochemische Sauerstoffbedarf auch an 20 Tagen und mehr bestimmt. Dann spricht man z.B. vom BSB20 usw. Siehe Sapromat, Winklerprobe, Verdünnungsmethode. (arb) / Elle représente la quantité d’oxygène dépensée par les phénomènes d’oxydation chimique, d’une part, et, d’autre part, la dégradation des matières organiques par voie aérobie, nécessaire à la destruction des composés organiques. Elle s’exprime en milligrammes d’O2 consommé par litre d’effluent. Par convention, on retient le résultat de la consommation d’oxygène à 20° C au bout de 5 jours, ce qui donne l’appellation DBO5. (d’après M. Satin, B. Selmi, Guide technique de l’assainissement).';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN cod  smallint ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.cod IS 'Abbreviation for chemical oxygen demand (COD). / Abkürzung für den chemischen Sauerstoffbedarf. Die englische Abkürzung lautet COD. Mit einem starken Oxydationsmittel wird mehr oder weniger erfolgreich versucht, die organischen Verbindungen der Abwasserprobe zu CO2 und H2O zu oxydieren. Als Oxydationsmittel eignen sich Chromverbindungen verschiedener Wertigkeit (z.B. Kalium-Dichromat K2Cr2O7) und Manganverbindungen (z.B. KmnO4), wobei man unter dem CSB im Allgemeinen den chemischen Sauerstoffbedarf nach der Kalium-Dichromat-Methode) versteht. Das Resultat kann als Chromatverbrauch oder Kaliumpermanaganatverbrauch ausgedrückt werden (z.B. mg CrO4 2-/l oder mg KMnO4/l). Im allgemeinen ergibt die Kalium-Dichromat-Methode höhere Werte als mit Kaliumpermanganat. Das Verhältnis des CSB zum BSB5 gilt als Hinweis auf die Abbaubarkeit der organischen Abwasserinhaltsstoffe. Leicht abbaubare häusliche Abwässer haben einen DSB/BSB5-Verhältnis von 1 bis 1,5. Schweres abbaubares, industrielles Abwasser ein Verhältnis von über 2. (arb) / Elle représente la teneur totale de l’eau en matières organiques, qu’elles soient ou non biodégradables. Le principe repose sur la recherche d’un besoin d’oxygène de l’échantillon pour dégrader la matière organique. Mais dans ce cas, l’oxygène est fourni par un oxydant puissant (le bichromate de potassium). La réaction (Afnor T90-101) est pratiquée à chaud (150°C) en présence d’acide sulfurique, et après 2 h on mesure la quantité d’oxydant restant. Là encore, le résultat s’exprime en milligrammes d’O2 par litre d’effluent.  Le rapport entre DCO/DBO5 est d’environ 2 à 2.7 pour une eau usée domestique ; au-delà, il y a vraisemblablement présence d’eaux industrielles résiduaires.';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN elimination_cod  decimal (5,2) ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.elimination_cod IS 'Dimensioning value elimination rate in percent / Dimensionierungswert Eliminationsrate in % / Valeur de dimensionnement, taux d''élimination en %';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN elimination_n  decimal (5,2) ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.elimination_n IS 'Denitrification at at waster water temperature of below 10 degree celsius / Denitrifikation bei einer Abwassertemperatur von > 10 Grad / Dénitrification à une température des eaux supérieure à 10°C';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN elimination_nh4  decimal (5,2) ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.elimination_nh4 IS 'Dimensioning value elimination rate in percent / Dimensionierungswert: Eliminationsrate in % / Valeur de dimensionnement, taux d''élimination en %';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN elimination_p  decimal (5,2) ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.elimination_p IS 'Dimensioning value elimination rate in percent / Dimensionierungswert Eliminationsrate in % / Valeur de dimensionnement, taux d''élimination en %';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN identifier text;
 ALTER TABLE tww_od.waste_water_treatment_plant ADD CONSTRAINT tp_identifier_length_max_255 CHECK(char_length(identifier)<=255);
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.identifier IS 'yyy_Bezeichnung der Abwasserreinigungsanlage gemäss Liste BAFU / Bezeichnung der Abwasserreinigungsanlage gemäss Liste BAFU / Désignation de la STEP selon la liste de l''Office fédéral de l''environnement (OFEV)';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN kind text;
 ALTER TABLE tww_od.waste_water_treatment_plant ADD CONSTRAINT tp_kind_length_max_50 CHECK(char_length(kind)<=50);
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.kind IS '';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN nh4  smallint ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.nh4 IS 'yyy_Dimensioning value Ablauf Vorklärung. NH4 [gNH4/m3] / Dimensionierungswert Ablauf Vorklärung. NH4 [gNH4/m3] / Valeur de dimensionnement, NH4 à la sortie du décanteur primaire. NH4 [gNH4/m3]';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN operator_type  integer ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.operator_type IS 'yyy_Organisationsform der betreibenden Organisation / Organisationsform der betreibenden Organisation / Forme organisationnelle de l’exploitant';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN population_connected  integer ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.population_connected IS ' / VSA-Kennzahl "Anzahl angeschlossene Einwohner" [E], Matching MGDM 134.5 EinwAngeschlossen / Indicateur du VSA « Nombre d’habitants raccordés » [H], Matching MGDM 134.5 EinwAngeschlossen';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN population_total  integer ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.population_total IS ' / VSA-Kennzahl "Anzahl Einwohner Total" [E], Matching MGDM 134.5 EinwAnz / Indicateur du VSA « Nombre total d’habitants » [H], Matching MGDM 134.5 EinwAnz';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN remark text;
 ALTER TABLE tww_od.waste_water_treatment_plant ADD CONSTRAINT tp_remark_length_max_255 CHECK(char_length(remark)<=255);
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_waste_water_treatment_plant_situation_geometry ON tww_od.waste_water_treatment_plant USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.situation_geometry IS 'yyy_Standort der ARA, Mitte des Geländes / Standort der ARA, Mitte des Geländes / Site de la STEP, milieu du site';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN start_year  smallint ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.start_year IS 'Start of operation (year) / Jahr der Inbetriebnahme / Année de la mise en exploitation';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN wwtp_number  integer ;
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.wwtp_number IS 'WWTP Number from Federal Office for the Environment (FOEN) / ARA-Nummer gemäss Bundesamt für Umwelt (BAFU) / Numéro de la STEP selon l''Office fédéral de l''environnement (OFEV)';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.waste_water_treatment_plant ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.waste_water_treatment_plant.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_waste_water_treatment_plant
BEFORE UPDATE OR INSERT ON
 tww_od.waste_water_treatment_plant
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.wastewater_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wastewater_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wastewater_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wastewater_structure ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure');
COMMENT ON COLUMN tww_od.wastewater_structure.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN accessibility  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.accessibility IS 'Possibility of accessibility of a sewage structure for a person (not for a vehicle). / Möglichkeit der Zugänglichkeit eines Abwasserbauwerks für eine Person (nicht für ein Fahrzeug) / Possibilités d’accès à l’ouvrage d’assainissement pour une personne (non pour un véhicule)';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN condition_score  decimal(3,2) ;
COMMENT ON COLUMN tww_od.wastewater_structure.condition_score IS 'The condition score summarizes the overall condition of the wastewater structure under consideration on a scale of 0.00 to 4.00 above. It is derived mathematically from the totality of the individual conditions recorded at a wastewater structure by visual inspection. / Die Zustandsnote spiegelt den baulichen und betrieblichen Zustand eines Abwasserbauwerks als numerischen Wert wider. Sie leitet sich rechnerisch aus der Gesamtheit der an einem Abwasserbauwerk durch optische Inspektion erhobenen Einzelzustände ab. / La note d’état reflète sous forme numérique l’état structurel et fonctionnel d’un ouvrage du réseau d’assainissement. Elle est calculée à partir de l’ensemble des états individuels. relevés par inspection visuelle sur un ouvrage du réseau d’assainissement.';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN contract_section text;
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ws_contract_section_length_max_50 CHECK(char_length(contract_section)<=50);
COMMENT ON COLUMN tww_od.wastewater_structure.contract_section IS 'Number of contract section / Nummer des Bauloses / Numéro du lot de construction';
-- ALTER TABLE tww_od.wastewater_structure ADD COLUMN detail_geometry_geometry geometry('CURVEPOLYGON', :SRID);
-- CREATE INDEX in_tww_wastewater_structure_detail_geometry_geometry ON tww_od.wastewater_structure USING gist (detail_geometry_geometry );
-- COMMENT ON COLUMN tww_od.wastewater_structure.detail_geometry_geometry IS 'Detail geometry especially with special structures. For manhole usually use dimension1 and 2. Also with normed infiltratin structures.  Channels usually do not have a detail_geometry. / Detaillierte Geometrie insbesondere bei Spezialbauwerken. Für Normschächte i.d. R.  Dimension1 und 2 verwenden. Dito bei normierten Versickerungsanlagen.  Kanäle haben normalerweise keine Detailgeometrie. / Géométrie détaillée particulièrement pour un OUVRAGE_SPECIAL. Pour l’attribut CHAMBRE_STANDARD utilisez Dimension1 et 2, de même pour une INSTALLATION_INFILTRATION normée.  Les canalisations n’ont en général pas de géométrie détaillée.';
ALTER TABLE tww_od.wastewater_structure ADD COLUMN detail_geometry3d_geometry geometry('CURVEPOLYGONZ', :SRID);
CREATE INDEX in_tww_wastewater_structure_detail_geometry3d_geometry ON tww_od.wastewater_structure USING gist (detail_geometry3d_geometry );
COMMENT ON COLUMN tww_od.wastewater_structure.detail_geometry3d_geometry IS 'Detail geometry (3D) especially with special structures. For manhole usually use dimension1 and 2. Also with normed infiltratin structures.  Channels usually do not have a detail_geometry. / Detaillierte Geometrie (3D) insbesondere bei Spezialbauwerken. Bei Normschächten mit Dimension1 und 2 arbeiten. Dito bei normierten Versickerungsanlagen. Kanäle haben normalerweise keine Detailgeometrie. / Géométrie détaillée (3D) particulièrement pour un OUVRAGE_SPECIAL. Pour l’attribut CHAMBRE_STANDARD utilisez Dimension1 et 2, de même pour une INSTALLATION_INFILTRATION normée.Les canalisations n’ont en général pas de géométrie détaillée.';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN elevation_determination  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.elevation_determination IS 'Defines the elevation_determination of the detail_geometry3d. / Definiert die Hoehenbestimmung der Detailgeometrie3D. / Définition de la détermination altimétrique de la GEOMETRIE_DETAILLEE3D.';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN financing  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.financing IS ' Method of financing  (Financing based on GschG Art. 60a). / Finanzierungart (Finanzierung gemäss GschG Art. 60a). / Type de financement (financement selon LEaux Art. 60a)';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.wastewater_structure.gross_costs IS 'Gross costs of construction / Brutto Erstellungskosten / Coûts bruts des travaux de construction';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN identifier text;
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ws_identifier_length_max_41 CHECK(char_length(identifier)<=41);
COMMENT ON COLUMN tww_od.wastewater_structure.identifier IS 'Unique designation per data owner / Pro Datenherr eindeutige Bezeichnung / Désignation unique pour chaque maître des données';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN inspection_interval  decimal(4,2) ;
COMMENT ON COLUMN tww_od.wastewater_structure.inspection_interval IS 'yyy_Abstände, in welchen das Abwasserbauwerk inspiziert werden sollte (Jahre) / Abstände, in welchen das Abwasserbauwerk inspiziert werden sollte (Jahre) / Fréquence à laquelle un ouvrage du réseau d‘assainissement devrait subir une inspection (années)';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN location_name text;
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ws_location_name_length_max_50 CHECK(char_length(location_name)<=50);
COMMENT ON COLUMN tww_od.wastewater_structure.location_name IS 'Street name or name of the location of the structure / Strassenname oder Ortsbezeichnung  zum Bauwerk / Nom de la route ou du lieu de l''ouvrage';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN records text;
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ws_records_length_max_255 CHECK(char_length(records)<=255);
COMMENT ON COLUMN tww_od.wastewater_structure.records IS 'yyy_Plan Nr. der Ausführungsdokumentation. Kurzbeschrieb weiterer Akten (Betriebsanleitung vom …, etc.) / Plan Nr. der Ausführungsdokumentation. Kurzbeschrieb weiterer Akten (Betriebsanleitung vom …, etc.) / N° de plan de la documentation d’exécution, description de dossiers, manuels, etc.';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN remark text;
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT ws_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.wastewater_structure.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN renovation_necessity  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.renovation_necessity IS 'yyy_Dringlichkeitsstufen und Zeithorizont für bauliche Massnahmen gemäss VSA-Richtline "Erhaltung von Kanalisationen (2007)" / Dringlichkeitsstufen und Zeithorizont für bauliche Massnahmen gemäss VSA-Richtline "Erhaltung von Kanalisationen (2007)" / 	Degrés d’urgence et délai de réalisation des mesures constructives selon la directive VSA "Maintien des canalisations (2007)"';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN replacement_value  decimal(10,2) ;
COMMENT ON COLUMN tww_od.wastewater_structure.replacement_value IS 'yyy_Wiederbeschaffungswert des Bauwerks. Zusätzlich muss auch das Attribut WBW_Basisjahr erfasst werden / Wiederbeschaffungswert des Bauwerks. Zusätzlich muss auch das Attribut WBW_Basisjahr erfasst werden / Valeur de remplacement de l''OUVRAGE_RESEAU_AS. On à besoin aussi de saisir l''attribut VR_ANNEE_REFERENCE';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN rv_base_year  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure.rv_base_year IS 'yyy_Basisjahr für die Kalkulation des Wiederbeschaffungswerts (siehe auch Wiederbeschaffungswert) / Basisjahr für die Kalkulation des Wiederbeschaffungswerts (siehe auch Attribut Wiederbeschaffungswert) / Année de référence pour le calcul de la valeur de remplacement (cf. valeur de remplacement)';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN rv_construction_type  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.rv_construction_type IS 'yyy_Grobe Einteilung der Bauart des Abwasserbauwerks als Inputwert für die Berechnung des Wiederbeschaffungswerts. / Grobe Einteilung der Bauart des Abwasserbauwerks als Inputwert für die Berechnung des Wiederbeschaffungswerts. / Valeur de remplacement du type de construction';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN status  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.status IS 'Operating and planning status of the structure / Betriebs- bzw. Planungszustand des Bauwerks / Etat de fonctionnement et de planification de l’ouvrage';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN status_survey_year  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure.status_survey_year IS 'yyy_Jahr der letzten Zustandserhebung. Wird für die Erhebung der Kennzahlen GEP gebraucht. Kann mit einer Abfrage von Erhaltungsereignis.Zeitpunkt (jüngstes Ereignis) für Erhaltungsereignis.Art = Untersuchung und Status = ausgefuehrt automatisch abgefüllt werden. / Jahr der letzten Zustandserhebung. Wird für die Erhebung der Kennzahlen GEP gebraucht. Kann mit einer Abfrage von Erhaltungsereignis.Zeitpunkt (jüngstes Ereignis) für Erhaltungsereignis.Art = Untersuchung und Status = ausgefuehrt automatisch abgefüllt werden. / Année du dernier relevé d''état. Utilisé pour le relevé des indicateurs PGEE. Peut être rempli automatiquement par une requête sur EVENEMENT_MAINTENANCE.DATE_HEURE (dernier événement) avec EVENEMENT_MAINTENANCE.GENRE = examen et status = execute .';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN structure_condition  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure.structure_condition IS 'yyy_Zustandsklassen 0 bis 4 gemäss VSA-Richtline "Erhaltung von Kanalisationen". Beschreibung des baulichen Zustands des Abwasserbauwerks. Nicht zu verwechseln mit den Sanierungsstufen, welche die Prioritäten der Massnahmen bezeichnen (Attribut Sanierungsbedarf). / Zustandsklassen 0 bis 4 gemäss VSA-Richtline "Erhaltung von Kanalisationen (2007)". Beschreibung des baulichen Zustands des Abwasserbauwerks. Nicht zu verwechseln mit den Sanierungsstufen, welche die Prioritäten der Massnahmen bezeichnen (Attribut Sanierungsbedarf). / Classes d''état. Description de l''état constructif selon la directive VSA "Maintien des canalisations" (2007). Ne pas confondre avec les degrés de remise en état (attribut NECESSITE_ASSAINIR)';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN subsidies  decimal(10,2) ;
COMMENT ON COLUMN tww_od.wastewater_structure.subsidies IS 'yyy_Staats- und Bundesbeiträge / Staats- und Bundesbeiträge / Contributions des cantons et de la Confédération';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN urgency_figure  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure.urgency_figure IS 'The urgency figure is the numerical measure for the urgency of rehabilitation measures on a wastewater structure and results from the condition assessment taking into account the condition grade as well as other boundary conditions. The urgency number describes the urgency exclusively from the point of view of the structural and operational condition of a wastewater structure. It is therefore independent of urgencies resulting from other requirements. / Die Dringlichkeitszahl ist das numerische Mass für die Dringlichkeit von Sanierungsmassnahmen an einem Abwasserbauwerk und resultiert aus der Zustandsbewertung unter Berücksichtigung der Zustandsnote sowie weiterer Randbedingungen. Die Dringlichkeitszahl beschreibt die Dringlichkeit ausschliesslich unter Gesichtspunkten, die den baulich-betrieblichen Zustand eines Abwasserbauwerks betreffen. Sie ist daher unabhängig von Dringlichkeiten, die sich aus anderen Erfordernissen ergeben. / L’indice d’urgence est un nombre qui indique l’urgence de mesures de réhabilitation d’un ouvrage du réseau d’assainissement. Il découle de l’appréciation de l’état, basé sur la note d’état ainsi que d’autres facteurs d’influence.';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN year_of_construction  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure.year_of_construction IS 'yyy_Jahr der Inbetriebsetzung (Schlussabnahme). Falls unbekannt = 1800 setzen (tiefster Wert des Wertebereiches) / Jahr der Inbetriebsetzung (Schlussabnahme). Falls unbekannt = 1800 setzen (tiefster Wert des Wertebereichs) / Année de mise en service (réception finale)';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure.year_of_replacement IS 'yyy_Jahr, in dem die Lebensdauer des Bauwerks voraussichtlich abläuft / Jahr, in dem die Lebensdauer des Bauwerks voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''ouvrage soit écoulée';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.wastewater_structure.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.wastewater_structure.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.wastewater_structure.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wastewater_structure
BEFORE UPDATE OR INSERT ON
 tww_od.wastewater_structure
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.channel
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_channel_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_channel_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.channel ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','channel');
COMMENT ON COLUMN tww_od.channel.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.channel ADD COLUMN bedding_encasement  integer ;
COMMENT ON COLUMN tww_od.channel.bedding_encasement IS 'yyy_Art und Weise der unmittelbaren Rohrumgebung im Boden: Bettungsschicht (Unterlage der Leitung),  Verdämmung (seitliche Auffüllung), Schutzschicht / Art und Weise der unmittelbaren Rohrumgebung im Boden: Bettungsschicht (Unterlage der Leitung),  Verdämmung (seitliche Auffüllung), Schutzschicht / Lit de pose (assise de la conduite), bourrage latéral (remblai latéral), couche de protection';
 ALTER TABLE tww_od.channel ADD COLUMN connection_type  integer ;
COMMENT ON COLUMN tww_od.channel.connection_type IS 'Types of connection / Verbindungstypen / Types de raccordement';
 ALTER TABLE tww_od.channel ADD COLUMN function_amelioration  integer ;
COMMENT ON COLUMN tww_od.channel.function_amelioration IS 'yyy_Zur Unterscheidung der Funktion einer Leitung bei Meliorationen (Entwässerungen) / Zur Unterscheidung der Funktion einer Leitung bei Meliorationen (Entwässerungen) / Afin de distinguer la fonction d’une conduite d’amélioration foncière (drainage)';
 ALTER TABLE tww_od.channel ADD COLUMN function_hierarchic  integer ;
COMMENT ON COLUMN tww_od.channel.function_hierarchic IS 'yyy_Art des Kanals hinsichtlich der hierarchischen Bedeutung im Entwässerungssystem / Art des Kanals hinsichtlich der hierarchischen  Bedeutung im Entwässerungssystem / Genre de canalisation par rapport à sa fonction hiérarchique dans le système d''évacuation';
-- see end of table CREATE INDEX in_channel_function_hierarchic_usage_current ON tww_od.channel USING btree (function_hierarchic, usage_current);
 ALTER TABLE tww_od.channel ADD COLUMN function_hydraulic  integer ;
COMMENT ON COLUMN tww_od.channel.function_hydraulic IS 'yyy_Art des Kanals hinsichtlich hydraulischer Ausführung / Art des Kanals hinsichtlich hydraulischer Ausführung / Genre de canalisation par rapport à sa fonction hydraulique';
 ALTER TABLE tww_od.channel ADD COLUMN jetting_interval  decimal(4,2) ;
COMMENT ON COLUMN tww_od.channel.jetting_interval IS 'yyy_Abstände in welchen der Kanal gespült werden sollte / Abstände in welchen der Kanal gespült werden sollte / Fréquence à laquelle une canalisation devrait subir un curage (années)';
 ALTER TABLE tww_od.channel ADD COLUMN pipe_length  decimal(7,2) ;
COMMENT ON COLUMN tww_od.channel.pipe_length IS 'yyy_Baulänge der Einzelrohre oder Fugenabstände bei Ortsbetonkanälen / Baulänge der Einzelrohre oder Fugenabstände bei Ortsbetonkanälen / Longueur de chaque tuyau ou distance des joints pour les canalisations en béton coulé sur place';
 ALTER TABLE tww_od.channel ADD COLUMN seepage  integer ;
COMMENT ON COLUMN tww_od.channel.seepage IS 'yyy Beschreibung des oberliegenden Materials bei Saugern / Beschreibung des oberliegenden Materials bei Saugern / Description du matériau de remplissage';
 ALTER TABLE tww_od.channel ADD COLUMN usage_current  integer ;
COMMENT ON COLUMN tww_od.channel.usage_current IS 'yyy_Für Primäre Abwasseranlagen gilt: heute zulässige Nutzung. Für Sekundäre Abwasseranlagen gilt: heute tatsächliche Nutzung / Für primäre Abwasseranlagen gilt: Heute zulässige Nutzung. Für sekundäre Abwasseranlagen gilt: Heute tatsächliche Nutzung / Pour les ouvrages du réseau primaire: utilisation actuelle autorisée pour les ouvrages du réseau secondaire: utilisation actuelle réelle';
 ALTER TABLE tww_od.channel ADD COLUMN usage_planned  integer ;
COMMENT ON COLUMN tww_od.channel.usage_planned IS 'yyy_Durch das Konzept vorgesehene Nutzung (vergleiche auch Nutzungsart_Ist) / Durch das Konzept vorgesehene Nutzung (vergleiche auch Nutzungsart_Ist) / Utilisation prévue par le concept d''assainissement (voir aussi GENRE_UTILISATION_ACTUELLE)';
 CREATE INDEX in_channel_function_hierarchic_usage_current ON tww_od.channel USING btree (function_hierarchic, usage_current);
-------
CREATE TRIGGER
update_last_modified_channel
BEFORE UPDATE OR INSERT ON
 tww_od.channel
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.manhole
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_manhole_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_manhole_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.manhole ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','manhole');
COMMENT ON COLUMN tww_od.manhole.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.manhole ADD COLUMN amphibian_exit  integer ;
COMMENT ON COLUMN tww_od.manhole.amphibian_exit IS 'Structural measures for the exit of amphibians available. / Bauliche Massnahme für den Ausstieg von Amphibien vorhanden. / Des mesures structurelles pour la sortie des amphibiens sont en place.';
 ALTER TABLE tww_od.manhole ADD COLUMN depth  smallint ;
COMMENT ON COLUMN tww_od.manhole.depth IS 'yyy_Function (calculated value) = associated wastewater_node.bottom_level minus cover.level (if bottom_level is not recorded separately, then it is the lower-lying reach_point.level). See also SIA 405 2015 4.3.4. / Funktion (berechneter Wert) = zugehöriger Abwasserknoten.Sohlenkote minus Deckel.Kote (falls Sohlenkote nicht separat erfasst, dann ist es die tiefer liegende Haltungspunkt.Kote). Siehe auch SIA 405 2015 4.3.4. / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER correspondant moins COUVERCLE.COTE (si le radier n’est pas saisi séparément, c’est la POINT_TRONCON.COTE le plus bas). Cf. SIA 405 cahier technique 2015 4.3.4.';
 ALTER TABLE tww_od.manhole ADD COLUMN dimension1  smallint ;
COMMENT ON COLUMN tww_od.manhole.dimension1 IS 'Dimension2 of infiltration installations (largest inside dimension). / Dimension1 des Schachtes (grösstes Innenmass). / Dimension1 de la chambre (plus grande mesure intérieure).';
 ALTER TABLE tww_od.manhole ADD COLUMN dimension2  smallint ;
COMMENT ON COLUMN tww_od.manhole.dimension2 IS 'Dimension2 of manhole (smallest inside dimension). With circle shaped manholes leave dimension2 empty, with ovoid manholes fill it in. With rectangular shaped manholes use detailled_geometry to describe further. / Dimension2 des Schachtes (kleinstes Innenmass). Bei runden Schächten wird Dimension2 leer gelassen, bei ovalen abgefüllt. Für eckige Schächte Detailgeometrie verwenden. / Dimension2 de la chambre (plus petite mesure intérieure)';
 ALTER TABLE tww_od.manhole ADD COLUMN function  integer ;
COMMENT ON COLUMN tww_od.manhole.function IS 'Kind of function / Art der Nutzung / Genre d''utilisation';
 CREATE INDEX in_manhole_function ON tww_od.manhole USING btree (function);
 ALTER TABLE tww_od.manhole ADD COLUMN material  integer ;
COMMENT ON COLUMN tww_od.manhole.material IS 'yyy_Hauptmaterial aus dem das Bauwerk besteht zur groben Klassifizierung. / Hauptmaterial aus dem das Bauwerk besteht zur groben Klassifizierung. / Matériau dont est construit l''ouvrage, pour une classification sommaire';
 ALTER TABLE tww_od.manhole ADD COLUMN possibility_intervention  integer ;
COMMENT ON COLUMN tww_od.manhole.possibility_intervention IS 'Intervention possibility on the wastewater structure for the fire department available. / Interventionsmöglichkeit auf dem Bauwerk für die Wehrdienste vorhanden. / Possibilité d''intervention sur l''ouvrage pour les services du feu (pompiers).';
 ALTER TABLE tww_od.manhole ADD COLUMN surface_inflow  integer ;
COMMENT ON COLUMN tww_od.manhole.surface_inflow IS 'yyy_Zuflussmöglichkeit  von Oberflächenwasser direkt in den Schacht / Zuflussmöglichkeit  von Oberflächenwasser direkt in den Schacht / Arrivée directe d''eaux superficielles dans la chambre';
-------
CREATE TRIGGER
update_last_modified_manhole
BEFORE UPDATE OR INSERT ON
 tww_od.manhole
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.discharge_point
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_discharge_point_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_discharge_point_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.discharge_point ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','discharge_point');
COMMENT ON COLUMN tww_od.discharge_point.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.discharge_point ADD COLUMN depth  smallint ;
COMMENT ON COLUMN tww_od.discharge_point.depth IS 'Function (calculated value) = representative wastewater_node.bottom_level minus associated upper_elevation of the structure if detailed geometry is available, otherwise Function (calculated value) = wastewater_node.bottom_level minus associated cover.level of the structure / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';
 ALTER TABLE tww_od.discharge_point ADD COLUMN highwater_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.discharge_point.highwater_level IS 'yyy_Massgebliche Hochwasserkote der Einleitstelle. Diese ist in der Regel grösser als der Wasserspiegel_Hydraulik. / Massgebliche Hochwasserkote der Einleitstelle. Diese ist in der Regel grösser als der Wasserspiegel_Hydraulik. / Cote de crue déterminante au point de rejet. Diese ist in der Regel grösser als der Wasserspiegel_Hydraulik.';
 ALTER TABLE tww_od.discharge_point ADD COLUMN relevance  integer ;
COMMENT ON COLUMN tww_od.discharge_point.relevance IS 'Relevance of discharge point for water course / Gewässerrelevanz der Einleitstelle / Signifiance pour milieu récepteur';
 ALTER TABLE tww_od.discharge_point ADD COLUMN terrain_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.discharge_point.terrain_level IS 'Terrain level, if there is no cover at the point of discharge (end of channel without structure or structure without cover): Terrain level above the watercourse embankment. The horizontal distance from the recording point to the discharge point must not exceed 5-10m. / Terrainkote, falls kein Deckel vorhanden bei Einleitstelle (Kanalende ohne Bauwerk oder Bauwerk ohne Deckel): Terrainkote oberhalb der Gewässerböschung. Die horizontale Distanz vom Aufnahmepunkt zur Einleitstelle darf max. 5-10m betragen. / Cote terrain s''il n''y a pas de couvercle à l''exutoire (extrémité du canal sans ouvrage ou ouvrage sans couvercle) : Terrain au-dessus de la berge du cours d''eau. La distance horizontale entre le point de relevé et le point de déversement doit être de 5 à 10 m au maximum.';
 ALTER TABLE tww_od.discharge_point ADD COLUMN upper_elevation  decimal(7,3) ;
COMMENT ON COLUMN tww_od.discharge_point.upper_elevation IS 'Highest point of structure (ceiling), outside / Höchster Punkt des Bauwerks (Decke), aussen / Point le plus élevé de l''ouvrage';
 ALTER TABLE tww_od.discharge_point ADD COLUMN water_course_number text;
 ALTER TABLE tww_od.discharge_point ADD CONSTRAINT dp_water_course_number_length_max_25 CHECK(char_length(water_course_number)<=25);
COMMENT ON COLUMN tww_od.discharge_point.water_course_number IS 'Watercourse number according to VECTOR25 watercourse network GWN07 (Federal Office of Topography swisstopo) / Gewässerlaufnummer gemäss VECTOR25 Gewässernetz GWN07 (Bundesamt für Landestopografie swisstopo) / Numéro du cours d’eau selon VECTOR25 Réseau hydrographique GWN07 (Office fédéral de topographie swisstopo)';
 ALTER TABLE tww_od.discharge_point ADD COLUMN water_course_segment_canton text;
 ALTER TABLE tww_od.discharge_point ADD CONSTRAINT dp_water_course_segment_canton_length_max_36 CHECK(char_length(water_course_segment_canton)<=36);
COMMENT ON COLUMN tww_od.discharge_point.water_course_segment_canton IS 'yyy_Designation of the section in the cantonal watercourse network / Bezeichnung des Gewässerabschnittes im Kantonalen Gewässernetz / Désignation du tronçon dans le réseau cantonal des cours d''eau';
 ALTER TABLE tww_od.discharge_point ADD COLUMN waterlevel_hydraulic  decimal(7,3) ;
COMMENT ON COLUMN tww_od.discharge_point.waterlevel_hydraulic IS 'yyy_Wasserspiegelkote für die hydraulische Berechnung (IST-Zustand). Berechneter Wasserspiegel bei der Einleitstelle. Wo nichts anders gefordert, ist der Wasserspiegel bei einem HQ30 einzusetzen. / Wasserspiegelkote für die hydraulische Berechnung (IST-Zustand). Berechneter Wasserspiegel bei der Einleitstelle. Wo nichts anders gefordert, ist der Wasserspiegel bei einem HQ30 einzusetzen. / Niveau d’eau calculé à l’exutoire. Si aucun exigence est demandée, indiquer le niveau d’eau pour un HQ30.';
-------
CREATE TRIGGER
update_last_modified_discharge_point
BEFORE UPDATE OR INSERT ON
 tww_od.discharge_point
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.special_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_special_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_special_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.special_structure ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','special_structure');
COMMENT ON COLUMN tww_od.special_structure.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.special_structure ADD COLUMN amphibian_exit  integer ;
COMMENT ON COLUMN tww_od.special_structure.amphibian_exit IS 'Structural measures for the exit of amphibians available. / Bauliche Massnahme für den Ausstieg von Amphibien vorhanden. / Des mesures structurelles pour la sortie des amphibiens sont en place.';
 ALTER TABLE tww_od.special_structure ADD COLUMN bypass  integer ;
COMMENT ON COLUMN tww_od.special_structure.bypass IS 'yyy_Bypass zur Umleitung des Wassers (z.B. während Unterhalt oder  im Havariefall) / Bypass zur Umleitung des Wassers (z.B. während Unterhalt oder  im Havariefall) / Bypass pour détourner les eaux (par exemple durant des opérations de maintenance ou en cas d’avaries)';
 ALTER TABLE tww_od.special_structure ADD COLUMN depth  smallint ;
COMMENT ON COLUMN tww_od.special_structure.depth IS 'Function (calculated value) = representative wastewater_node.bottom_level minus associated upper_elevation of the structure if detailed geometry is available, otherwise Function (calculated value) = wastewater_node.bottom_level minus associated cover.level of the structure. / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';
 ALTER TABLE tww_od.special_structure ADD COLUMN emergency_overflow  integer ;
COMMENT ON COLUMN tww_od.special_structure.emergency_overflow IS 'zzz_Das Attribut beschreibt, wohin die das Volumen übersteigende Menge abgeleitet wird (v.a. Regenrückhaltebecken / Regenrückhaltekanal). / Das Attribut beschreibt, wohin die das Volumen übersteigende Menge abgeleitet wird (v.a bei Regenrückhaltebecken / Regenrückhaltekanal). / L’attribut décrit vers où le débit déversé s’écoule (surtout bassin d’accumulation / canal d’accumulation)';
 ALTER TABLE tww_od.special_structure ADD COLUMN function  integer ;
COMMENT ON COLUMN tww_od.special_structure.function IS 'Kind of function / Art der Nutzung / Genre d''utilisation';
 CREATE INDEX in_special_structure_function ON tww_od.special_structure USING btree (function);
 ALTER TABLE tww_od.special_structure ADD COLUMN possibility_intervention  integer ;
COMMENT ON COLUMN tww_od.special_structure.possibility_intervention IS 'Intervention possibility on the wastewater structure for the fire department available. / Interventionsmöglichkeit auf dem Bauwerk für die Wehrdienste vorhanden. / Possibilité d''intervention sur l''ouvrage pour les services du feu (pompiers).';
 ALTER TABLE tww_od.special_structure ADD COLUMN stormwater_tank_arrangement  integer ;
COMMENT ON COLUMN tww_od.special_structure.stormwater_tank_arrangement IS 'yyy_Anordnung des Regenbeckens im System, vgl. Kap. 6.2. Modul DB der VSA-Richtlinie Abwasserbewirtschaftung bei Regenwetter. / Anordnung des Regenbeckens im System, vgl. Kap. 6.2. Modul DB der VSA-Richtlinie "Abwasserbewirtschaftung bei Regenwetter". / Disposition du bassin d''eaux pluviales dans le système, voir chap. 6.2 du module DB de la directive «Gestion des eaux urbaines par temps de pluie» du VSA.';
 ALTER TABLE tww_od.special_structure ADD COLUMN upper_elevation  decimal(7,3) ;
COMMENT ON COLUMN tww_od.special_structure.upper_elevation IS 'Highest point of structure (ceiling), outside / Höchster Punkt des Bauwerks (Decke), aussen / Point le plus élevé de la construction';
-------
CREATE TRIGGER
update_last_modified_special_structure
BEFORE UPDATE OR INSERT ON
 tww_od.special_structure
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.infiltration_installation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_infiltration_installation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_infiltration_installation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.infiltration_installation ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','infiltration_installation');
COMMENT ON COLUMN tww_od.infiltration_installation.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN absorption_capacity  decimal(9,3) ;
COMMENT ON COLUMN tww_od.infiltration_installation.absorption_capacity IS 'yyy_Schluckvermögen des Bodens. / Schluckvermögen des Bodens. / Capacité d''absorption du sol';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN defects  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.defects IS 'yyy_Gibt die aktuellen Mängel der Versickerungsanlage an (IST-Zustand). / Gibt die aktuellen Mängel der Versickerungsanlage an (IST-Zustand). / Indique les défauts actuels de l''installation d''infiltration (etat_actuel).';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN depth  smallint ;
COMMENT ON COLUMN tww_od.infiltration_installation.depth IS 'Function (calculated value) = representative wastewater_node.bottom_level minus associated upper_elevation of the structure if detailed geometry is available, otherwise Function (calculated value) = wastewater_node.bottom_level minus associated cover.level of the structure. / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN dimension1  smallint ;
COMMENT ON COLUMN tww_od.infiltration_installation.dimension1 IS 'Dimension1 of infiltration installations (largest inside dimension) if used with norm elements. Else leave empty.. / Dimension1 der Versickerungsanlage (grösstes Innenmass) bei der Verwendung von Normbauteilen. Sonst leer lassen und mit Detailgeometrie beschreiben. / Dimension1 de l’installation d’infiltration (plus grande mesure intérieure) lorsqu’elle est utilisée pour des éléments d’ouvrage normés. Sinon, à laisser libre et prendre la description de la géométrie détaillée.';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN dimension2  smallint ;
COMMENT ON COLUMN tww_od.infiltration_installation.dimension2 IS 'Dimension2 of infiltration installations (smallest inside dimension). With circle shaped installations leave dimension2 empty, with ovoid shaped ones fill it in. With rectangular shaped manholes use detailled_geometry to describe further. / Dimension2 der Versickerungsanlage (kleinstes Innenmass) bei der Verwendung von Normbauteilen. Sonst leer lassen und mit Detailgeometrie beschreiben. / Dimension2 de la chambre (plus petite mesure intérieure). La dimension2 est à saisir pour des chambres ovales et à laisser libre pour des chambres circulaires. Pour les chambres rectangulaires il faut utiliser la géométrie détaillée.';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN distance_to_aquifer  decimal(7,2) ;
COMMENT ON COLUMN tww_od.infiltration_installation.distance_to_aquifer IS 'yyy_Flurabstand (Vertikale Distanz Terrainoberfläche zum Grundwasserleiter). / Flurabstand (Vertikale Distanz Terrainoberfläche zum Grundwasserleiter). / Distance à l''aquifère (distance verticale de la surface du terrain à l''aquifère)';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN effective_area  decimal(8,2) ;
COMMENT ON COLUMN tww_od.infiltration_installation.effective_area IS 'yyy_Für den Abfluss wirksame Fläche / Für den Abfluss wirksame Fläche / Surface qui participe à l''écoulement';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN emergency_overflow  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.emergency_overflow IS 'yyy_Endpunkt allfälliger Verrohrung des Notüberlaufes der Versickerungsanlage / Endpunkt allfälliger Verrohrung des Notüberlaufes der Versickerungsanlage / Point cumulant des conduites du trop plein d''une installation d''infiltration';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN filling_material  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.filling_material IS 'yyy_Beschreibung des oberliegenden Materials bei Sickerschlitzen. Für Modellierung Sickerschlitze siehe Hinweise Titelblatt. / Beschreibung des oberliegenden Materials bei Sickerschlitzen. Für Modellierung Sickerschlitze siehe Hinweise Titelblatt. / Description du matériau de remplissage sur les fentes d''infiltration. Les fentes d''infiltration de sont pas modélisées par des tronçons, mais par des installations d''infiltration (voyez commentaires en couverture)';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.kind IS 'yyy_Arten von Versickerungsmethoden. / Arten von Versickerungsmethoden. / Genre de méthode d''infiltration.';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN labeling  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.labeling IS 'yyy_Kennzeichnung der Schachtdeckel der Anlage als Versickerungsanlage.  Nur bei Anlagen mit Schächten. / Kennzeichnung der Schachtdeckel der Anlage als Versickerungsanlage.  Nur bei Anlagen mit Schächten. / Désignation inscrite du couvercle de l''installation d''infiltration. Uniquement pour des installations avec couvercle';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN seepage_utilization  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.seepage_utilization IS 'Types of water to be infiltrated. / Arten des zu versickernden Wassers. / Genre d''eau à infiltrer';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN upper_elevation  decimal(7,3) ;
COMMENT ON COLUMN tww_od.infiltration_installation.upper_elevation IS 'Highest point of structure (ceiling), outside / Höchster Punkt des Bauwerks (Decke), aussen / Point le plus élevé de la construction';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN vehicle_access  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.vehicle_access IS 'Accessibility for vehicle access (e.g. suction trucks). It refers to the entire infiltration system / pretreatment facilities and can be further specified in the remarks / Zugänglichkeit für Saugwagen. Sie bezieht sich auf die gesamte Versickerungsanlage / Vorbehandlungsanlagen und kann in den Bemerkungen weiter spezifiziert werden / Accessibilité pour des camions de vidange. Se réfère à toute l''installation d''infiltration / de prétraitement et peut être spécifiée sous REMARQUE';
 ALTER TABLE tww_od.infiltration_installation ADD COLUMN watertightness  integer ;
COMMENT ON COLUMN tww_od.infiltration_installation.watertightness IS 'yyy_Wasserdichtheit gegen Oberflächenwasser.  Nur bei Anlagen mit Schächten. / Wasserdichtheit gegen Oberflächenwasser.  Nur bei Anlagen mit Schächten. / Etanchéité contre des eaux superficielles. Uniquement pour des installations avec chambres';
-------
CREATE TRIGGER
update_last_modified_infiltration_installation
BEFORE UPDATE OR INSERT ON
 tww_od.infiltration_installation
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.wwtp_structure
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wwtp_structure_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wwtp_structure_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wwtp_structure ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wwtp_structure');
COMMENT ON COLUMN tww_od.wwtp_structure.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wwtp_structure ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.wwtp_structure.kind IS 'yyy_Art des Beckens oder Verfahrens im ARA Bauwerk / Art des Beckens oder Verfahrens im ARA Bauwerk / Genre de l''l’ouvrage ou genre de traitement dans l''ouvrage STEP';
-------
CREATE TRIGGER
update_last_modified_wwtp_structure
BEFORE UPDATE OR INSERT ON
 tww_od.wwtp_structure
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.maintenance_event
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_maintenance_event_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_maintenance_event_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.maintenance_event ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','maintenance_event');
COMMENT ON COLUMN tww_od.maintenance_event.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN base_data text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_base_data_length_max_50 CHECK(char_length(base_data)<=50);
COMMENT ON COLUMN tww_od.maintenance_event.base_data IS 'e.g. damage protocol. Effectively link document via class file and data_media. / Z.B. Schadensprotokoll. Effektives Dokument via Klasse Datei und Datentraeger verlinken. / par ex. protocole de dommages. Lier le document effectif via la classe FICHIER et SUPPORT_DONNEES.';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN cost  decimal(10,2) ;
COMMENT ON COLUMN tww_od.maintenance_event.cost IS '';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN data_details text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_data_details_length_max_50 CHECK(char_length(data_details)<=50);
COMMENT ON COLUMN tww_od.maintenance_event.data_details IS 'yyy_Ort, wo sich weitere Detailinformationen zum Ereignis finden (z.B. Nr. eines Videobandes) / Ort, wo sich weitere Detailinformationen zum Ereignis finden (z.B. Nr. eines Videobandes) / Lieu où se trouvent les données détaillées (par ex. n° d''une bande vidéo)';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN duration  smallint ;
COMMENT ON COLUMN tww_od.maintenance_event.duration IS 'Duration of event in days / Dauer des Ereignisses in Tagen / Durée de l''événement en jours';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN identifier text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_identifier_length_max_41 CHECK(char_length(identifier)<=41);
COMMENT ON COLUMN tww_od.maintenance_event.identifier IS '';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN operator text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_operator_length_max_50 CHECK(char_length(operator)<=50);
COMMENT ON COLUMN tww_od.maintenance_event.operator IS 'Operator of operating company or administration / Sachbearbeiter Firma oder Verwaltung (kann auch Operateur sein bei Untersuchung) / Responsable de saisie du bureau';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN reason text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_reason_length_max_50 CHECK(char_length(reason)<=50);
COMMENT ON COLUMN tww_od.maintenance_event.reason IS 'yyy_Reason for this event: Folgende standartisierten Textvorgaben sind für VSA-KEK zu wernden: andere, Garantieabnahme, Neubauabnahme, Sanierungsabnahme, Zustandskontrolle / Ursache für das Ereignis. Folgende standardisierten Textvorgaben sind für VSA-KEK zu verwenden: andere, Garantieabnahme, Neubauabnahme, Sanierungsabnahme, Zustandskontrolle / Les spécifications de texte normalisées suivantes doivent être utilisées : autre, réception de garantie, réception d’une nouvelle construction (réception d’ouvrage), réception de mesures correctives, contrôle d’état';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN remark text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.maintenance_event.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN result text;
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT me_result_length_max_255 CHECK(char_length(result)<=255);
COMMENT ON COLUMN tww_od.maintenance_event.result IS 'Result or important comments for this event from the perspective of the editor / Resultat oder wichtige Bemerkungen aus Sicht des Bearbeiters / Résultat ou commentaire importante de l''événement du point de vue de l''éditeur';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN status  integer ;
COMMENT ON COLUMN tww_od.maintenance_event.status IS 'Disposition state of the maintenance event / Phase in der sich das Erhaltungsereignis befindet / Phase dans laquelle se trouve l''événement de maintenance';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN time_point  timestamp without time zone ;
COMMENT ON COLUMN tww_od.maintenance_event.time_point IS 'Date and time of the event / Zeitpunkt des Ereignisses / Date et heure de l''événement';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.maintenance_event.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.maintenance_event.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.maintenance_event ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.maintenance_event.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_maintenance_event
BEFORE UPDATE OR INSERT ON
 tww_od.maintenance_event
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.zone ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','zone');
COMMENT ON COLUMN tww_od.zone.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.zone ADD COLUMN identifier text;
 ALTER TABLE tww_od.zone ADD CONSTRAINT zo_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.zone.identifier IS '';
 ALTER TABLE tww_od.zone ADD COLUMN remark text;
 ALTER TABLE tww_od.zone ADD CONSTRAINT zo_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.zone.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.zone ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.zone.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.zone ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.zone.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.zone ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.zone.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_zone
BEFORE UPDATE OR INSERT ON
 tww_od.zone
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.infiltration_zone
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_infiltration_zone_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_infiltration_zone_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.infiltration_zone ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','infiltration_zone');
COMMENT ON COLUMN tww_od.infiltration_zone.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.infiltration_zone ADD COLUMN infiltration_capacity  integer ;
COMMENT ON COLUMN tww_od.infiltration_zone.infiltration_capacity IS 'yyy_Versickerungsmöglichkeit im Bereich / Versickerungsmöglichkeit im Bereich / Potentiel d''infiltration de la zone';
ALTER TABLE tww_od.infiltration_zone ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_infiltration_zone_perimeter_geometry ON tww_od.infiltration_zone USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.infiltration_zone.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_infiltration_zone
BEFORE UPDATE OR INSERT ON
 tww_od.infiltration_zone
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.zone");

-------
-------
CREATE TABLE tww_od.drainage_system
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_drainage_system_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_drainage_system_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.drainage_system ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','drainage_system');
COMMENT ON COLUMN tww_od.drainage_system.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.drainage_system ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.drainage_system.kind IS 'yyy_Art des Entwässerungssystems in dem ein bestimmtes Gebiet entwässert werden soll (SOLL Zustand)  im groben Überblick für Planung. Wird später auf einzelnem Kanal attributiert. / Art des Entwässerungssystems in dem ein bestimmtes Gebiet entwässert werden soll (SOLL Zustand) im groben Überblick für Planung. Wird später auf einzelnem Kanal attributiert. / Genre de système d''évacuation choisi pour une région déterminée (Etat prévu). Vue d''ensemble grossière pour planification. Sera défini pour chaque canal par la suite.';
ALTER TABLE tww_od.drainage_system ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_drainage_system_perimeter_geometry ON tww_od.drainage_system USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.drainage_system.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_drainage_system
BEFORE UPDATE OR INSERT ON
 tww_od.drainage_system
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.zone");

-------
-------
CREATE TABLE tww_od.pipe_profile
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_pipe_profile_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_pipe_profile_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.pipe_profile ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','pipe_profile');
COMMENT ON COLUMN tww_od.pipe_profile.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN height_width_ratio  decimal(5,2) ;
COMMENT ON COLUMN tww_od.pipe_profile.height_width_ratio IS 'height-width ratio / Verhältnis der Höhe zur Breite / Rapport entre la hauteur et la largeur';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN identifier text;
 ALTER TABLE tww_od.pipe_profile ADD CONSTRAINT pp_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.pipe_profile.identifier IS '';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN profile_type  integer ;
COMMENT ON COLUMN tww_od.pipe_profile.profile_type IS 'Type of profile / Typ des Profils / Type du profil';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN remark text;
 ALTER TABLE tww_od.pipe_profile ADD CONSTRAINT pp_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.pipe_profile.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.pipe_profile.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.pipe_profile.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.pipe_profile ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.pipe_profile.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_pipe_profile
BEFORE UPDATE OR INSERT ON
 tww_od.pipe_profile
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.wwtp_energy_use
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wwtp_energy_use_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wwtp_energy_use_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wwtp_energy_use ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wwtp_energy_use');
COMMENT ON COLUMN tww_od.wwtp_energy_use.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN gas_motor  integer ;
COMMENT ON COLUMN tww_od.wwtp_energy_use.gas_motor IS 'electric power / elektrische Leistung / Puissance électrique';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN heat_pump  integer ;
COMMENT ON COLUMN tww_od.wwtp_energy_use.heat_pump IS 'Energy production based on the heat production on the WWTP / Energienutzung aufgrund des Wärmeanfalls auf der ARA / Utilisation de l''énergie thermique de la STEP';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN identifier text;
 ALTER TABLE tww_od.wwtp_energy_use ADD CONSTRAINT eu_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.wwtp_energy_use.identifier IS '';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN remark text;
 ALTER TABLE tww_od.wwtp_energy_use ADD CONSTRAINT eu_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.wwtp_energy_use.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN turbining  integer ;
COMMENT ON COLUMN tww_od.wwtp_energy_use.turbining IS 'Energy production based on the (bio)gaz production on the WWTP / Energienutzung aufgrund des Gasanfalls auf der ARA / Production d''énergie issue de la production de gaz de la STEP';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.wwtp_energy_use.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.wwtp_energy_use.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.wwtp_energy_use.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wwtp_energy_use
BEFORE UPDATE OR INSERT ON
 tww_od.wwtp_energy_use
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.waste_water_treatment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_waste_water_treatment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_waste_water_treatment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.waste_water_treatment ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','waste_water_treatment');
COMMENT ON COLUMN tww_od.waste_water_treatment.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.waste_water_treatment ADD COLUMN identifier text;
 ALTER TABLE tww_od.waste_water_treatment ADD CONSTRAINT tr_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.waste_water_treatment.identifier IS '';
 ALTER TABLE tww_od.waste_water_treatment ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.waste_water_treatment.kind IS 'Type of wastewater  treatment / Verfahren für die Abwasserbehandlung / Genre de traitement des eaux usées';
 ALTER TABLE tww_od.waste_water_treatment ADD COLUMN remark text;
 ALTER TABLE tww_od.waste_water_treatment ADD CONSTRAINT tr_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.waste_water_treatment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.waste_water_treatment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.waste_water_treatment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.waste_water_treatment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.waste_water_treatment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.waste_water_treatment ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.waste_water_treatment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_waste_water_treatment
BEFORE UPDATE OR INSERT ON
 tww_od.waste_water_treatment
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.sludge_treatment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_sludge_treatment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_sludge_treatment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.sludge_treatment ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','sludge_treatment');
COMMENT ON COLUMN tww_od.sludge_treatment.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN composting  decimal(7,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.composting IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN dehydration  decimal(7,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.dehydration IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN digested_sludge_combustion  decimal(7,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.digested_sludge_combustion IS 'yyy_Dimensioning value der Verbrennungsanlage / Dimensionierungswert der Verbrennungsanlage / Valeur de dimensionnement de l''installation d''incinération';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN drying  decimal(7,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.drying IS 'yyy_Leistung thermische Trocknung / Leistung thermische Trocknung / Puissance du séchage thermique';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN fresh_sludge_combustion  decimal(7,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.fresh_sludge_combustion IS 'yyy_Dimensioning value der Verbrennungsanlage / Dimensionierungswert der Verbrennungsanlage / Valeur de dimensionnement de l''installation d''incinération';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN hygenisation  decimal(7,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.hygenisation IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN identifier text;
 ALTER TABLE tww_od.sludge_treatment ADD CONSTRAINT st_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.sludge_treatment.identifier IS '';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN predensification_of_excess_sludge  decimal(9,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.predensification_of_excess_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN predensification_of_mixed_sludge  decimal(9,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.predensification_of_mixed_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN predensification_of_primary_sludge  decimal(9,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.predensification_of_primary_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN remark text;
 ALTER TABLE tww_od.sludge_treatment ADD CONSTRAINT st_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.sludge_treatment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN stabilisation  integer ;
COMMENT ON COLUMN tww_od.sludge_treatment.stabilisation IS 'yyy_Art der Schlammstabilisierung / Art der Schlammstabilisierung / Type de stabilisation des boues';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN stacking_of_dehydrated_sludge  decimal(9,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.stacking_of_dehydrated_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN stacking_of_liquid_sludge  decimal(9,2) ;
COMMENT ON COLUMN tww_od.sludge_treatment.stacking_of_liquid_sludge IS 'Dimensioning value / Dimensionierungswert / Valeur de dimensionnement';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.sludge_treatment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.sludge_treatment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.sludge_treatment ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.sludge_treatment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_sludge_treatment
BEFORE UPDATE OR INSERT ON
 tww_od.sludge_treatment
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.control_center
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_control_center_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_control_center_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.control_center ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','control_center');
COMMENT ON COLUMN tww_od.control_center.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.control_center ADD COLUMN identifier text;
 ALTER TABLE tww_od.control_center ADD CONSTRAINT cc_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.control_center.identifier IS '';
ALTER TABLE tww_od.control_center ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_control_center_situation_geometry ON tww_od.control_center USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.control_center.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
 ALTER TABLE tww_od.control_center ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.control_center.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.control_center ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.control_center.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.control_center ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.control_center.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_control_center
BEFORE UPDATE OR INSERT ON
 tww_od.control_center
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.hydr_geometry
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_hydr_geometry_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_hydr_geometry_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.hydr_geometry ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','hydr_geometry');
COMMENT ON COLUMN tww_od.hydr_geometry.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN identifier text;
 ALTER TABLE tww_od.hydr_geometry ADD CONSTRAINT hg_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.hydr_geometry.identifier IS '';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN remark text;
 ALTER TABLE tww_od.hydr_geometry ADD CONSTRAINT hg_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.hydr_geometry.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN storage_volume  decimal(9,2) ;
COMMENT ON COLUMN tww_od.hydr_geometry.storage_volume IS 'yyy_Storage content in the basin and in the inlet between the weir crest and the water level at Qan. For stormwater overflow basins in the bypass, the storage capacity at the upstream separating structure or stormwater overflow must be recorded (cf. explanations Contents_catchment section reps. _catchment section). For pumps: Reservoir content in the inlet channel below the water level when the pump is switched on (highest switch-on level for several pumps). / Speicherinhalt im Becken und im Zulauf zwischen Wehrkrone und dem Wasserspiegel bei Qan. Bei Regenbeckenüberlaufbecken im Nebenschluss ist der Stauraum beim vorgelagerten Trennbauwerk bzw. Regenüberlauf zu erfassen (vgl. Erläuterungen Inhalt_Fangteil reps. _Klaerteil). Bei Pumpen: Speicherinhalt im Zulaufkanal unter dem Wasserspiegel beim Einschalten der Pumpe (höchstes Einschaltniveau bei mehreren Pumpen) / Volume de stockage dans un bassin et dans la canalisation d’amenée entre la crête et le niveau d’eau de Qdim (débit conservé). Lors de bassins d’eaux pluviales en connexion latérale, le volume de stockage est à saisir à l’ouvrage de répartition, resp. déversoir d’orage précédant (cf. explications volume utile clarification, resp. volume utile stockage). Pour les pompes, il s’agit du volume de stockage dans la canalisation d’amenée sous le niveau d’eau lorsque la pompe s’enclenche (niveau max d’enclenchement lorsqu’il y a plusieurs pompes). Pour les bassins d’eaux pluviales, à saisir uniquement en connexion directe.';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN usable_capacity_storage  decimal(9,2) ;
COMMENT ON COLUMN tww_od.hydr_geometry.usable_capacity_storage IS 'yyy_Inhalt der Kammer unterhalb der Wehrkrone ohne Stauraum im Zulaufkanal. Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs). / Inhalt der Kammer unterhalb der Wehrkrone ohne Stauraum im Zulaufkanal. Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs) / Volume de la chambre sous la crête, sans volume de stockage de la canalisation d’amenée. Ce dernier est saisi par l’attribut volume de stockage (lors de disposition en connexion directe ceci se fait dans la fiche technique de l’ouvrage principal, lors de connexion latérale, l’attribution se fait dans la fiche technique de l’ouvrage de répartition ou déversoir d’orage précédant).';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN usable_capacity_treatment  decimal(9,2) ;
COMMENT ON COLUMN tww_od.hydr_geometry.usable_capacity_treatment IS 'yyy_Inhalt der Kammer unterhalb der Wehrkrone inkl. Einlaufbereich, Auslaufbereich und Sedimentationsbereich, ohne Stauraum im Zulaufkanal.  Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs) / Inhalt der Kammer unterhalb der Wehrkrone inkl. Einlaufbereich, Auslaufbereich und Sedimentationsbereich, ohne Stauraum im Zulaufkanal. Letzterer wird unter dem Attribut Stauraum erfasst (bei Anordnung im Hauptschluss auf der Stammkarte des Hauptbauwerkes, bei Anordnung im Nebenschluss auf der Stammkarte des vorgelagerten Trennbauwerkes oder Regenüberlaufs) / Volume de la chambre sous la crête, incl. l’entrée, la sortie et la partie de sédimentation, sans volume de stockage de la canalisation d’amenée. Ce dernier est saisi par l’attribut volume de stockage (lors de disposition en connexion directe ceci se fait dans la fiche technique de l’ouvrage principal, lors de connexion latérale, l’attribution se fait dans la fiche technique de l’ouvrage de répartition ou déversoir d’orage précédant).';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN utilisable_capacity  decimal(9,2) ;
COMMENT ON COLUMN tww_od.hydr_geometry.utilisable_capacity IS 'yyy_Inhalt der Kammer unterhalb Notüberlauf oder Bypass (maximal mobilisierbares Volumen, exkl. Stauraum im Zulaufkanal). Bei Regenrückhaltekanälen und Stauraumkanälen im Hauptschluss ist der Nutzinhalt = 0. Es ist nur Stauraum vorhanden, der im entsprechenden Attribut zu erfassen ist. / Inhalt der Kammer unterhalb Notüberlauf oder Bypass (maximal mobilisierbares Volumen, exkl. Stauraum im Zulaufkanal). Bei Regenrückhaltekanälen und Stauraumkanälen im Hauptschluss ist der Nutzinhalt = 0. Es ist nur Stauraum vorhanden, der im entsprechenden Attribut zu erfassen ist. / Volume de la chambre sous la surverse de secours ou bypass (volume mobilisable maximum, hors volume de stockage de la canalisation d’amenée). Pour les canaux d''accumulation disposés en série, le VOLUME_UTILE = 0. Seul le volume de stockage est disponible, à saisir dans l''attribut correspondant.';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN volume_pump_sump  decimal(9,2) ;
COMMENT ON COLUMN tww_od.hydr_geometry.volume_pump_sump IS 'Volume of the pump sump from the bottom to the maximum possible water level (excluding channel storage volume in the inlet channel). / Volumen des Pumpensumpfs von der Sohle bis zur maximal möglichen Wasserspiegellage (ohne Kanalspeichervolumen im Zulaufkanal). / Volume du puisard calculée à partir du radier jusqu’au niveau d’eau maximum possible (sans le volume de stockage de la canalisation d’amenée).';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.hydr_geometry.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.hydr_geometry.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.hydr_geometry ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.hydr_geometry.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hydr_geometry
BEFORE UPDATE OR INSERT ON
 tww_od.hydr_geometry
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.wastewater_networkelement
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wastewater_networkelement_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wastewater_networkelement_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wastewater_networkelement ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_networkelement');
COMMENT ON COLUMN tww_od.wastewater_networkelement.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wastewater_networkelement ADD COLUMN identifier text;
 ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT we_identifier_length_max_41 CHECK(char_length(identifier)<=41);
COMMENT ON COLUMN tww_od.wastewater_networkelement.identifier IS 'yyy_Für (Abwasser)knoten maximal 20 Zeichen, damit Haltungs- bzw. Leitungsbezeichnung aus von und bis Knoten und Bindestrich gebildet werden kann. / Für (Abwasser)knoten maximal 20 Zeichen, damit Haltungs- bzw. Leitungsbezeichnung aus von und bis Knoten und Bindestrich gebildet werden kann. / Maximum 20 caractères pour nœuds / noeud_reseau de façon à pouvoir former une désignation de tronçon respo. conduite avec un nœud de départ et d''arrivée séparés par un trait d''union.';
 ALTER TABLE tww_od.wastewater_networkelement ADD COLUMN remark text;
 ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT we_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.wastewater_networkelement.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.wastewater_networkelement ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.wastewater_networkelement.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.wastewater_networkelement ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.wastewater_networkelement.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.wastewater_networkelement ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.wastewater_networkelement.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_wastewater_networkelement
BEFORE UPDATE OR INSERT ON
 tww_od.wastewater_networkelement
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.reach_point
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_reach_point_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_reach_point_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.reach_point ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach_point');
COMMENT ON COLUMN tww_od.reach_point.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.reach_point ADD COLUMN elevation_accuracy  integer ;
COMMENT ON COLUMN tww_od.reach_point.elevation_accuracy IS 'yyy_Quantifizierung der Genauigkeit der Höhenlage der Kote in Relation zum Höhenfixpunktnetz (z.B. Grundbuchvermessung oder Landesnivellement). / Quantifizierung der Genauigkeit der Höhenlage der Kote in Relation zum Höhenfixpunktnetz (z.B. Grundbuchvermessung oder Landesnivellement). / Plage de précision des coordonnées altimétriques du point de tronçon';
 ALTER TABLE tww_od.reach_point ADD COLUMN identifier text;
 ALTER TABLE tww_od.reach_point ADD CONSTRAINT rp_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.reach_point.identifier IS '';
 ALTER TABLE tww_od.reach_point ADD COLUMN level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.reach_point.level IS 'yyy_Sohlenhöhe des Haltungsendes / Sohlenhöhe des Haltungsendes / Cote du radier de la fin du tronçon';
 ALTER TABLE tww_od.reach_point ADD COLUMN outlet_shape  integer ;
COMMENT ON COLUMN tww_od.reach_point.outlet_shape IS 'Kind of outlet shape / Art des Auslaufs / Types de sortie';
 ALTER TABLE tww_od.reach_point ADD COLUMN pipe_closure  integer ;
COMMENT ON COLUMN tww_od.reach_point.pipe_closure IS 'yyy_Rohrverschluss oder -kappe am Anfang oder Ende der Leitung. Default Wert ist nein. / Rohrverschluss oder -kappe am Anfang oder Ende der Leitung. Default Wert ist nein. / Tuyau bouchonné au début ou fin d''une conduite. La valeur par défaut est non.';
 ALTER TABLE tww_od.reach_point ADD COLUMN position_of_connection  smallint ;
COMMENT ON COLUMN tww_od.reach_point.position_of_connection IS 'yyy_Anschlussstelle bezogen auf Querschnitt im Kanal; in Fliessrichtung  (für Haus- und Strassenanschlüsse) / Anschlussstelle bezogen auf Querschnitt im Kanal; in Fliessrichtung  (für Haus- und Strassenanschlüsse) / Emplacement de raccordement Référence à la section transversale dans le canal dans le sens d’écoulement (pour les raccordements domestiques et de rue).';
 ALTER TABLE tww_od.reach_point ADD COLUMN remark text;
 ALTER TABLE tww_od.reach_point ADD CONSTRAINT rp_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.reach_point.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
--ALTER TABLE tww_od.reach_point ADD COLUMN situation_geometry geometry('POINT', :SRID);
-- CREATE INDEX in_tww_reach_point_situation_geometry ON tww_od.reach_point USING gist (situation_geometry );
-- COMMENT ON COLUMN tww_od.reach_point.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
ALTER TABLE tww_od.reach_point ADD COLUMN situation3d_geometry geometry('POINTZ', :SRID);
CREATE INDEX in_tww_reach_point_situation3d_geometry ON tww_od.reach_point USING gist (situation3d_geometry );
COMMENT ON COLUMN tww_od.reach_point.situation3d_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';

 ALTER TABLE tww_od.reach_point ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.reach_point.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.reach_point ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.reach_point.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.reach_point ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.reach_point.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_reach_point
BEFORE UPDATE OR INSERT ON
 tww_od.reach_point
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.wastewater_node
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wastewater_node_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wastewater_node_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wastewater_node ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_node');
COMMENT ON COLUMN tww_od.wastewater_node.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wastewater_node ADD COLUMN backflow_level_current  decimal(7,3) ;
COMMENT ON COLUMN tww_od.wastewater_node.backflow_level_current IS '1. Relevant backflow level based on the calculation rain (dss)   2. Height below which special measures against backflow are to be taken within the property drainage system. (DIN 4045) / 1. Massgebende Rückstaukote bezogen auf den Berechnungsregen (dss)  2. Höhe, unter der innerhalb der Grundstücksentwässerung besondere Massnahmen gegen Rückstau zu treffen sind. (DIN 4045) / Cote de refoulement déterminante calculée à partir des pluies de projet';
 ALTER TABLE tww_od.wastewater_node ADD COLUMN bottom_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.wastewater_node.bottom_level IS 'yyy_Tiefster Punkt des Knotens. Bei Sonderbauwerken tiefster Punkt des Knotens zu dem die Stammkarte gehört, also in der Regel Auslauf Richtung ARA. / Tiefster Punkt des Knotens. Bei Sonderbauwerken tiefster Punkt des Knotens zu dem die Stammkarte gehört, also in der Regel Auslauf Richtung ARA. / Pour des ouvrages spéciaux, point le plus bas du nœud auquel la fiche technique appartient, généralement la sortie en direction de la STEP.';
 ALTER TABLE tww_od.wastewater_node ADD COLUMN elevation_accuracy  integer ;
COMMENT ON COLUMN tww_od.wastewater_node.elevation_accuracy IS 'yyy_Höhengenauigkeit der Sohlenkote. Bei Neuerfassungen konsistent halten mit Höhengenauigkeit der Haltungspunkte (Ein-/Auslauf). / Höhengenauigkeit der Sohlenkote. Bei Neuerfassungen konsistent halten mit Höhengenauigkeit der Haltungspunkte (Ein-/Auslauf). / Précision altimétrique de la cote du radier. Lors de nouvelles saisies tenir consistent avec la précision altimétrique des points tronçon (entrée/sortie).';
 ALTER TABLE tww_od.wastewater_node ADD COLUMN function_node_amelioration  integer ;
COMMENT ON COLUMN tww_od.wastewater_node.function_node_amelioration IS 'yyy_Bei Abwasserknoten von Meliorationsleitungen zwingend (dient der Plandarstellung); sonst optional (weglassen). / Bei Abwasserknoten von Meliorationsleitungen zwingend (dient der Plandarstellung); sonst optional (weglassen). / Obligatoire pour noeuds de réseau de conduites d''amélioration foncière (sert à la représentation dans un plan) sinon optionnel (laisser vide)';
--ALTER TABLE tww_od.wastewater_node ADD COLUMN situation_geometry geometry('POINT', :SRID);
-- CREATE INDEX in_tww_wastewater_node_situation_geometry ON tww_od.wastewater_node USING gist (situation_geometry );
-- COMMENT ON COLUMN tww_od.wastewater_node.situation_geometry IS 'yyy Situation of node. Decisive reference point for sewer network simulation  (In der Regel Lage des Pickellochs oder Lage des Trockenwetterauslauf) / Lage des Knotens, massgebender Bezugspunkt für die Kanalnetzberechnung. (In der Regel Lage des Pickellochs oder Lage des Trockenwetterauslaufs) / Positionnement du nœud. Point de référence déterminant pour le calcul de réseau de canalisations (en règle générale positionnement du milieu du couvercle ou de la sortie temps sec)';
ALTER TABLE tww_od.wastewater_node ADD COLUMN situation3d_geometry geometry('POINTZ', :SRID);
CREATE INDEX in_tww_wastewater_node_situation3d_geometry ON tww_od.wastewater_node USING gist (situation3d_geometry );
COMMENT ON COLUMN tww_od.wastewater_node.situation3d_geometry IS 'yyy Situation of node. Decisive reference point for sewer network simulation  (In der Regel Lage des Pickellochs oder Lage des Trockenwetterauslauf) / Lage des Knotens, massgebender Bezugspunkt für die Kanalnetzberechnung. (In der Regel Lage des Pickellochs oder Lage des Trockenwetterauslaufs) / Positionnement du nœud. Point de référence déterminant pour le calcul de réseau de canalisations (en règle générale positionnement du milieu du couvercle ou de la sortie temps sec)';

 ALTER TABLE tww_od.wastewater_node ADD COLUMN wwtp_number  integer ;
COMMENT ON COLUMN tww_od.wastewater_node.wwtp_number IS 'yyy_Eindeutige Identifikationsnummer der ARA ((WWTP Number from Federal Office for the Environment (FOEN))., in deren Einzugsgebiet der Knoten liegt. Ist auch abzufüllen, wenn der Knoten nicht an die ARA angeschlossen ist. Die Abgrenzung der ARA-Einzugsgebiete ist im Zweifelsfall mit der kantonalen Fachstelle zu klären. / Eindeutige Identifikationsnummer der ARA (ARA Nummer des BAFU), in deren Einzugsgebiet der Knoten liegt. Ist auch abzufüllen, wenn der Knoten nicht an die ARA angeschlossen ist. Die Abgrenzung der ARA-Einzugsgebiete ist im Zweifelsfall mit der kantonalen Fachstelle zu klären. / Numéro d''identification unique de la STEP (n° STEP de l’OFEV) dans le bassin versant de laquelle se trouve le nœud. A remplir également si le nœud n''est pas raccordé à la STEP. En cas de doute, la délimitation des bassins versants de STEP est à demander auprès de l''autorité cantonale.';
-------
CREATE TRIGGER
update_last_modified_wastewater_node
BEFORE UPDATE OR INSERT ON
 tww_od.wastewater_node
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_networkelement");

-------
-------
CREATE TABLE tww_od.reach
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_reach_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_reach_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.reach ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach');
COMMENT ON COLUMN tww_od.reach.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.reach ADD COLUMN clear_height  integer ;
COMMENT ON COLUMN tww_od.reach.clear_height IS 'Clear height (inside) of profile. Installed liners are not to be considered (-> Reliner_nominal width) / Maximale Innenhöhe des Rohrprofiles. Eingebaute Liner sind nicht zu berücksichtigen -> Reliner_Nennweite). / Hauteur interne maximale du profil du tube. Les revêtements installés ne doivent pas être pris en compte (-> Reliner_largeur nominale.).';
 ALTER TABLE tww_od.reach ADD COLUMN coefficient_of_friction  smallint ;
COMMENT ON COLUMN tww_od.reach.coefficient_of_friction IS 'yyy http://www.linguee.com/english-german/search?source=auto&query=reibungsbeiwert / Hydraulische Kenngrösse zur Beschreibung der Beschaffenheit der Kanalwandung. Beiwert für die Formeln nach Manning-Strickler (K oder kstr) / Constante de rugosité selon Manning-Strickler (K ou kstr)';
 ALTER TABLE tww_od.reach ADD COLUMN elevation_determination  integer ;
COMMENT ON COLUMN tww_od.reach.elevation_determination IS 'Defines the elevation_determination of the reach (progression3D). / Definiert die Hoehenbestimmung einer Haltung (Verlauf3D). / Définition de la détermination altimétrique d''un tronçon (TRACE3D).';
 ALTER TABLE tww_od.reach ADD COLUMN flow_time_dry_weather  decimal(7,0) ;
COMMENT ON COLUMN tww_od.reach.flow_time_dry_weather IS 'Flow time in dry weather (daily mean) / Fliesszeit bei Trockenwetter (Tagesmittel) / Temps d''écoulement par temps sec (moyenne journalière)';
 ALTER TABLE tww_od.reach ADD COLUMN horizontal_positioning  integer ;
COMMENT ON COLUMN tww_od.reach.horizontal_positioning IS 'yyy_Definiert die Lagegenauigkeit der Verlaufspunkte. / Definiert die Lagegenauigkeit der Verlaufspunkte. / Définit la précision de la détermination du tracé.';
 ALTER TABLE tww_od.reach ADD COLUMN hydraulic_load_current  smallint ;
COMMENT ON COLUMN tww_od.reach.hydraulic_load_current IS 'Dimensioning of the discharge divided by the normal discharge capacity of the reach [%]. / Dimensionierungsabfluss geteilt durch Normalabflusskapazität der Leitung [%]. / Débit de dimensionnement divisé par la capacité d''écoulement normale de la conduite [%].';
 ALTER TABLE tww_od.reach ADD COLUMN inside_coating  integer ;
COMMENT ON COLUMN tww_od.reach.inside_coating IS 'yyy_Schutz der Innenwände des Kanals / Schutz der Innenwände des Kanals / Protection de la paroi intérieur de la canalisation';
 ALTER TABLE tww_od.reach ADD COLUMN leak_protection  integer ;
COMMENT ON COLUMN tww_od.reach.leak_protection IS 'Double-walled pipe or other system to prevent leakage into groundwater protection zones. / Doppelwandrohr oder anderes System zum Schutz vor Austritt in Grundwasserschutzzonen. / Tube à double paroi ou autre système destiné à protéger la conduite contre les fuites dans dans des zones de protection des eaux souterraines.';
 ALTER TABLE tww_od.reach ADD COLUMN length_effective  decimal(7,2) ;
COMMENT ON COLUMN tww_od.reach.length_effective IS 'yyy_Tatsächliche schräge Länge (d.h. nicht in horizontale Ebene projiziert)  inklusive Kanalkrümmungen / Tatsächliche schräge Länge (d.h. nicht in horizontale Ebene projiziert)  inklusive Kanalkrümmungen / Longueur effective (non projetée) incluant les parties incurvées';
 ALTER TABLE tww_od.reach ADD COLUMN material  integer ;
COMMENT ON COLUMN tww_od.reach.material IS 'Material of reach / pipe / Rohrmaterial / Matériau du tuyau';
-- ALTER TABLE tww_od.reach ADD COLUMN progression_geometry geometry('COMPOUNDCURVE', :SRID);
-- CREATE INDEX in_tww_reach_progression_geometry ON tww_od.reach USING gist (progression_geometry );
-- COMMENT ON COLUMN tww_od.reach.progression_geometry IS 'Start, inflextion and endpoints of a pipe / Anfangs-, Knick- und Endpunkte der Leitung / Points de départ, intermédiaires et d’arrivée de la conduite.';
ALTER TABLE tww_od.reach ADD COLUMN progression3d_geometry geometry('COMPOUNDCURVEZ', :SRID);
CREATE INDEX in_tww_reach_progression3d_geometry ON tww_od.reach USING gist (progression3d_geometry );
COMMENT ON COLUMN tww_od.reach.progression3d_geometry IS 'Start, inflextion and endpoints of a pipe (3D coordinates) / Anfangs-, Knick- und Endpunkte der Leitung (3D Koordinaten) / Points de départ, intermédiaires et d’arrivée de la conduite (coordonnées 3D)';
 ALTER TABLE tww_od.reach ADD COLUMN reliner_material  integer ;
COMMENT ON COLUMN tww_od.reach.reliner_material IS 'Material of reliner / Material des Reliners / Materiaux du relining';
 ALTER TABLE tww_od.reach ADD COLUMN reliner_nominal_size  integer ;
COMMENT ON COLUMN tww_od.reach.reliner_nominal_size IS 'Clear height with installed liner (= clear height of the original pipe profile minus twice the wall thickness of the liner). / Lichte Höhe mit eingebautem Liner (=Lichte Höhe des ursprünglichen Rohrprofils minus doppelte Wandstärke des Liners). / Hauteur libre avec revêtement installé (= hauteur libre du profilé d''origine du tuyau moins deux fois l''épaisseur de la paroi du revêtement).';
 ALTER TABLE tww_od.reach ADD COLUMN relining_construction  integer ;
COMMENT ON COLUMN tww_od.reach.relining_construction IS 'yyy_Bautechnik für das Relining. Zusätzlich wird der Einbau des Reliners als  Erhaltungsereignis abgebildet: Erhaltungsereignis.Art = Reparatur für Partieller_Liner, sonst Renovierung. / Bautechnik für das Relining. Zusätzlich wird der Einbau des Reliners als  Erhaltungsereignis abgebildet: Erhaltungsereignis.Art = Reparatur für Partieller_Liner, sonst Renovierung. / Relining technique de construction. En addition la construction du reliner doit être modeler comme événement maintenance: Genre = reparation pour liner_partiel, autrement genre = renovation.';
 ALTER TABLE tww_od.reach ADD COLUMN relining_kind  integer ;
COMMENT ON COLUMN tww_od.reach.relining_kind IS 'Kind of relining / Art des Relinings / Genre du relining';
 ALTER TABLE tww_od.reach ADD COLUMN ring_stiffness  smallint ;
COMMENT ON COLUMN tww_od.reach.ring_stiffness IS 'yyy Ringsteifigkeitsklasse - Druckfestigkeit gegen Belastungen von aussen (gemäss ISO 13966 ) / Ringsteifigkeitsklasse - Druckfestigkeit gegen Belastungen von aussen (gemäss ISO 13966 ) / Rigidité annulaire pour des pressions extérieures (selon ISO 13966)';
 ALTER TABLE tww_od.reach ADD COLUMN slope_building_plan  smallint ;
COMMENT ON COLUMN tww_od.reach.slope_building_plan IS 'yyy_Auf dem alten Plan eingezeichnetes Plangefälle [%o]. Nicht kontrolliert im Feld. Kann nicht für die hydraulische Berechnungen übernommen werden. Für Liegenschaftsentwässerung und Meliorationsleitungen. Darstellung als z.B. 3.5%oP auf Plänen. / Auf dem alten Plan eingezeichnetes Plangefälle [%o]. Nicht kontrolliert im Feld. Kann nicht für die hydraulische Berechnungen übernommen werden. Für Liegenschaftsentwässerung und Meliorationsleitungen. Darstellung als z.B. 3.5%oP auf Plänen. / Pente indiquée sur d''anciens plans non contrôlée [%o]. Ne peut pas être reprise pour des calculs hydrauliques. Indication pour des canalisations de biens-fonds ou d''amélioration foncière. Représentation sur de plan: 3.5‰ p';
 ALTER TABLE tww_od.reach ADD COLUMN wall_roughness  decimal(5,2) ;
COMMENT ON COLUMN tww_od.reach.wall_roughness IS 'yyy Hydraulische Kenngrösse zur Beschreibung der Beschaffenheit der Kanalwandung. Beiwert für die Formeln nach Prandtl-Colebrook (ks oder kb) / Hydraulische Kenngrösse zur Beschreibung der Beschaffenheit der Kanalwandung. Beiwert für die Formeln nach Prandtl-Colebrook (ks oder kb) / Coefficient de rugosité d''après Prandtl Colebrook (ks ou kb)';
-------
CREATE TRIGGER
update_last_modified_reach
BEFORE UPDATE OR INSERT ON
 tww_od.reach
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_networkelement");

-------
-------
CREATE TABLE tww_od.profile_geometry
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_profile_geometry_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_profile_geometry_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.profile_geometry ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','profile_geometry');
COMMENT ON COLUMN tww_od.profile_geometry.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.profile_geometry ADD COLUMN sequence  smallint ;
COMMENT ON COLUMN tww_od.profile_geometry.sequence IS 'Sequence of the detail points of geometry definition / Reihenfolge der Detailpunkte der Geometriedefinition / Ordre des points de détail de la définition de la géométrie';
 ALTER TABLE tww_od.profile_geometry ADD COLUMN x  real ;
COMMENT ON COLUMN tww_od.profile_geometry.x IS 'X-coordinate / X-Koordinate / l''abscisse (X)';
 ALTER TABLE tww_od.profile_geometry ADD COLUMN y  real ;
COMMENT ON COLUMN tww_od.profile_geometry.y IS 'Y-coordinate / Y-Koordinate / l''ordonnée (Y)';
 ALTER TABLE tww_od.profile_geometry ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.profile_geometry.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.profile_geometry ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.profile_geometry.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.profile_geometry ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.profile_geometry.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_profile_geometry
BEFORE UPDATE OR INSERT ON
 tww_od.profile_geometry
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.hydr_geom_relation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_hydr_geom_relation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_hydr_geom_relation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.hydr_geom_relation ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','hydr_geom_relation');
COMMENT ON COLUMN tww_od.hydr_geom_relation.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN water_depth  decimal(7,2) ;
COMMENT ON COLUMN tww_od.hydr_geom_relation.water_depth IS 'yyy_Massgebende Wassertiefe / Massgebende Wassertiefe / Profondeur d''eau déterminante';
 ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN water_surface  decimal(8,2) ;
COMMENT ON COLUMN tww_od.hydr_geom_relation.water_surface IS 'yyy_Freie Wasserspiegelfläche; für Speicherfunktionen massgebend / Freie Wasserspiegelfläche; für Speicherfunktionen massgebend / Surface du plan d''eau; déterminant pour les fonctions d''accumulation';
 ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN wet_cross_section_area  decimal(8,2) ;
COMMENT ON COLUMN tww_od.hydr_geom_relation.wet_cross_section_area IS 'yyy_Hydraulisch wirksamer Querschnitt für Verlustberechnungen / Hydraulisch wirksamer Querschnitt für Verlustberechnungen / Section hydrauliquement active pour les calculs des pertes de charge';
 ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.hydr_geom_relation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.hydr_geom_relation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.hydr_geom_relation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hydr_geom_relation
BEFORE UPDATE OR INSERT ON
 tww_od.hydr_geom_relation
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.mechanical_pretreatment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_mechanical_pretreatment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_mechanical_pretreatment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.mechanical_pretreatment ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','mechanical_pretreatment');
COMMENT ON COLUMN tww_od.mechanical_pretreatment.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN identifier text;
 ALTER TABLE tww_od.mechanical_pretreatment ADD CONSTRAINT mt_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.mechanical_pretreatment.identifier IS '';
 ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.mechanical_pretreatment.kind IS 'yyy_Arten der mechanischen Vorreinigung / Behandlung (gemäss VSA Richtlinie "Abwasserentsorgung bei Regenwetter" (2019)) / Arten der mechanischen Vorreinigung / Behandlung (gemäss "Abwasserentsorgung bei Regenwetter" (2019)) / Genre de prétraitement mécanique (selon directive VSA "Gestion des eaux urbaines par temps de pluie" (2019))';
 ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN remark text;
 ALTER TABLE tww_od.mechanical_pretreatment ADD CONSTRAINT mt_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.mechanical_pretreatment.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.mechanical_pretreatment.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.mechanical_pretreatment.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.mechanical_pretreatment.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_mechanical_pretreatment
BEFORE UPDATE OR INSERT ON
 tww_od.mechanical_pretreatment
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.retention_body
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_retention_body_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_retention_body_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.retention_body ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','retention_body');
COMMENT ON COLUMN tww_od.retention_body.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.retention_body ADD COLUMN identifier text;
 ALTER TABLE tww_od.retention_body ADD CONSTRAINT rb_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.retention_body.identifier IS '';
 ALTER TABLE tww_od.retention_body ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.retention_body.kind IS 'Type of retention / Arten der Retention / Genre de rétention';
 ALTER TABLE tww_od.retention_body ADD COLUMN remark text;
 ALTER TABLE tww_od.retention_body ADD CONSTRAINT rb_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.retention_body.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.retention_body ADD COLUMN volume  decimal(9,2) ;
COMMENT ON COLUMN tww_od.retention_body.volume IS 'yyy_Nutzbares Volumen des Retentionskörpers / Nutzbares Volumen des Retentionskörpers / Volume effectif du volume de rétention';
 ALTER TABLE tww_od.retention_body ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.retention_body.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.retention_body ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.retention_body.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.retention_body ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.retention_body.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_retention_body
BEFORE UPDATE OR INSERT ON
 tww_od.retention_body
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.overflow_char
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_overflow_char_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_overflow_char_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.overflow_char ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','overflow_char');
COMMENT ON COLUMN tww_od.overflow_char.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.overflow_char ADD COLUMN identifier text;
 ALTER TABLE tww_od.overflow_char ADD CONSTRAINT oc_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.overflow_char.identifier IS '';
 ALTER TABLE tww_od.overflow_char ADD COLUMN kind_overflow_char  integer ;
COMMENT ON COLUMN tww_od.overflow_char.kind_overflow_char IS 'yyy_Die Kennlinie ist als Q /Q- (bei Bodenöffnungen) oder als H/Q-Tabelle (bei Streichwehren) zu dokumentieren. Bei einer freien Aufteilung muss die Kennlinie nicht dokumentiert werden. Bei Abflussverhältnissen in Einstaubereichen ist die Funktion separat in einer Beilage zu beschreiben. / Die Kennlinie ist als Q /Q- (bei Bodenöffnungen) oder als H/Q-Tabelle (bei Streichwehren) zu dokumentieren. Bei einer freien Aufteilung muss die Kennlinie nicht dokumentiert werden. Bei Abflussverhältnissen in Einstaubereichen ist die Funktion separat in einer Beilage zu beschreiben. / La courbe est à documenter sous forme de rapport Q/Q (Leaping weir) ou H/Q (déversoir latéral). Les conditions d’écoulement dans la chambre d’accumulation sont à fournir en annexe.';
 ALTER TABLE tww_od.overflow_char ADD COLUMN remark text;
 ALTER TABLE tww_od.overflow_char ADD CONSTRAINT oc_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.overflow_char.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.overflow_char ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.overflow_char.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.overflow_char ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.overflow_char.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.overflow_char ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.overflow_char.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_overflow_char
BEFORE UPDATE OR INSERT ON
 tww_od.overflow_char
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.hq_relation
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_hq_relation_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_hq_relation_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.hq_relation ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','hq_relation');
COMMENT ON COLUMN tww_od.hq_relation.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.hq_relation ADD COLUMN altitude  decimal(7,3) ;
COMMENT ON COLUMN tww_od.hq_relation.altitude IS 'yyy_Zum Abfluss (Q2) korrelierender Wasserspiegel (h) / Zum Abfluss (Q2) korrelierender Wasserspiegel (h) / Niveau d''eau correspondant (h) au débit (Q2)';
 ALTER TABLE tww_od.hq_relation ADD COLUMN flow  decimal(9,3) ;
COMMENT ON COLUMN tww_od.hq_relation.flow IS 'Flow (Q2) in direction of WWTP / Abflussmenge (Q2) Richtung ARA / Débit d''eau (Q2) en direction de la STEP';
 ALTER TABLE tww_od.hq_relation ADD COLUMN flow_from  decimal(9,3) ;
COMMENT ON COLUMN tww_od.hq_relation.flow_from IS 'yyy_Zufluss (Q1) / Zufluss (Q1) / Débit d’entrée  (Q1)';
 ALTER TABLE tww_od.hq_relation ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.hq_relation.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.hq_relation ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.hq_relation.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.hq_relation ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.hq_relation.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hq_relation
BEFORE UPDATE OR INSERT ON
 tww_od.hq_relation
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.structure_part
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_structure_part_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_structure_part_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.structure_part ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','structure_part');
COMMENT ON COLUMN tww_od.structure_part.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.structure_part ADD COLUMN identifier text;
 ALTER TABLE tww_od.structure_part ADD CONSTRAINT sp_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.structure_part.identifier IS '';
 ALTER TABLE tww_od.structure_part ADD COLUMN remark text;
 ALTER TABLE tww_od.structure_part ADD CONSTRAINT sp_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.structure_part.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.structure_part ADD COLUMN renovation_demand  integer ;
COMMENT ON COLUMN tww_od.structure_part.renovation_demand IS 'yyy_Zustandsinformation zum structure_part / Zustandsinformation zum Bauwerksteil / Information sur l''état de l''élément de l''ouvrage';
 ALTER TABLE tww_od.structure_part ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.structure_part.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.structure_part ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.structure_part.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.structure_part ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.structure_part.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_structure_part
BEFORE UPDATE OR INSERT ON
 tww_od.structure_part
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.dryweather_downspout
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_dryweather_downspout_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_dryweather_downspout_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.dryweather_downspout ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','dryweather_downspout');
COMMENT ON COLUMN tww_od.dryweather_downspout.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.dryweather_downspout ADD COLUMN diameter  smallint ;
COMMENT ON COLUMN tww_od.dryweather_downspout.diameter IS '';
-------
CREATE TRIGGER
update_last_modified_dryweather_downspout
BEFORE UPDATE OR INSERT ON
 tww_od.dryweather_downspout
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.access_aid
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_access_aid_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_access_aid_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.access_aid ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','access_aid');
COMMENT ON COLUMN tww_od.access_aid.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.access_aid ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.access_aid.kind IS 'yyy_Art des Einstiegs in das Bauwerk / Art des Einstiegs in das Bauwerk / Genre d''accès à l''ouvrage';
-------
CREATE TRIGGER
update_last_modified_access_aid
BEFORE UPDATE OR INSERT ON
 tww_od.access_aid
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.dryweather_flume
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_dryweather_flume_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_dryweather_flume_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.dryweather_flume ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','dryweather_flume');
COMMENT ON COLUMN tww_od.dryweather_flume.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.dryweather_flume ADD COLUMN material  integer ;
COMMENT ON COLUMN tww_od.dryweather_flume.material IS 'yyy_Material der Ausbildung oder Auskleidung der Trockenwetterrinne / Material der Ausbildung oder Auskleidung der Trockenwetterrinne / Matériau de fabrication ou de revêtement de la cunette de débit temps sec';
-------
CREATE TRIGGER
update_last_modified_dryweather_flume
BEFORE UPDATE OR INSERT ON
 tww_od.dryweather_flume
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.cover
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_cover_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_cover_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.cover ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','cover');
COMMENT ON COLUMN tww_od.cover.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.cover ADD COLUMN brand text;
 ALTER TABLE tww_od.cover ADD CONSTRAINT co_brand_length_max_50 CHECK(char_length(brand)<=50);
COMMENT ON COLUMN tww_od.cover.brand IS 'Name of manufacturer / Name der Herstellerfirma / Nom de l''entreprise de fabrication';
 ALTER TABLE tww_od.cover ADD COLUMN cover_shape  integer ;
COMMENT ON COLUMN tww_od.cover.cover_shape IS 'shape of cover / Form des Deckels / Forme du couvercle';
 ALTER TABLE tww_od.cover ADD COLUMN depth  smallint ;
COMMENT ON COLUMN tww_od.cover.depth IS 'Redundant Function attribut depth. Function (calculated value) = associated wastewater_node.bottom_level minus cover.level (if bottom_level is not recorded separately, then it is the lower-lying reach_point.level). / redundantes Funktionsattribut Maechtigkeit. Funktion (berechneter Wert) = zugehöriger Deckel.Kote minus Abwasserknoten.Sohlenkote.(falls die Sohlenkote nicht separat erfasst, dann ist es die tiefer liegende Haltungspunkt.Kote) / Attribut de fonction EPAISSEUR redondant, numérique [mm]. Fonction (valeur calculée) = COUVERCLE.COTE correspondant moins NŒUD_RESEAU.COTE_RADIER (si la cote radier ne peut pas être saisie séparément, prendre la POINT_TRONCON.COTE la plus basse.';
 ALTER TABLE tww_od.cover ADD COLUMN diameter  smallint ;
COMMENT ON COLUMN tww_od.cover.diameter IS 'yyy_Abmessung des Deckels (bei eckigen Deckeln minimale Abmessung) / Abmessung des Deckels (bei eckigen Deckeln minimale Abmessung) / Dimension du couvercle (dimension minimale pour couvercle anguleux)';
 ALTER TABLE tww_od.cover ADD COLUMN fastening  integer ;
COMMENT ON COLUMN tww_od.cover.fastening IS 'yyy_Befestigungsart des Deckels / Befestigungsart des Deckels / Genre de fixation du couvercle';
 ALTER TABLE tww_od.cover ADD COLUMN level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.cover.level IS 'Height of cover / Deckelhöhe / Cote du couvercle';
 ALTER TABLE tww_od.cover ADD COLUMN material  integer ;
COMMENT ON COLUMN tww_od.cover.material IS 'Material of cover / Deckelmaterial / Matériau du couvercle';
 ALTER TABLE tww_od.cover ADD COLUMN positional_accuracy  integer ;
COMMENT ON COLUMN tww_od.cover.positional_accuracy IS 'Quantfication of accuarcy of position of cover (center hole) / Quantifizierung der Genauigkeit der Lage des Deckels (Pickelloch) / Plage de précision des coordonnées planimétriques du couvercle.';
--ALTER TABLE tww_od.cover ADD COLUMN situation_geometry geometry('POINT', :SRID);
-- CREATE INDEX in_tww_cover_situation_geometry ON tww_od.cover USING gist (situation_geometry );
-- COMMENT ON COLUMN tww_od.cover.situation_geometry IS 'Situation of cover (cover hole), National position coordinates (East, North) / Lage des Deckels (Pickelloch) / Positionnement du couvercle (milieu du couvercle)';
ALTER TABLE tww_od.cover ADD COLUMN situation3d_geometry geometry('POINTZ', :SRID);
CREATE INDEX in_tww_cover_situation3d_geometry ON tww_od.cover USING gist (situation3d_geometry );
COMMENT ON COLUMN tww_od.cover.situation3d_geometry IS 'Situation of cover (cover hole), National position coordinates (East, North) / Lage des Deckels (Pickelloch) / Positionnement du couvercle (milieu du couvercle)';

 ALTER TABLE tww_od.cover ADD COLUMN sludge_bucket  integer ;
COMMENT ON COLUMN tww_od.cover.sludge_bucket IS 'yyy_Angabe, ob der Deckel mit einem Schlammeimer versehen ist oder nicht / Angabe, ob der Deckel mit einem Schlammeimer versehen ist oder nicht / Indication si le couvercle est pourvu ou non d''un ramasse-boues';
 ALTER TABLE tww_od.cover ADD COLUMN venting  integer ;
COMMENT ON COLUMN tww_od.cover.venting IS 'venting with wholes for aeration / Deckel mit Lüftungslöchern versehen / Couvercle pourvu de trous d''aération';
-------
CREATE TRIGGER
update_last_modified_cover
BEFORE UPDATE OR INSERT ON
 tww_od.cover
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.electric_equipment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_electric_equipment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_electric_equipment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.electric_equipment ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','electric_equipment');
COMMENT ON COLUMN tww_od.electric_equipment.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.electric_equipment ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.electric_equipment.gross_costs IS 'Gross costs of electrical equipment / Brutto Erstellungskosten der elektrischen Ausrüstung / Coûts bruts des équipements électriques';
 ALTER TABLE tww_od.electric_equipment ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.electric_equipment.kind IS 'yyy_Elektrische Installationen und Geräte / Elektrische Installationen und Geräte / Installations et appareils électriques';
 ALTER TABLE tww_od.electric_equipment ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.electric_equipment.year_of_replacement IS 'yyy_Jahr, in dem die Lebensdauer der elektrischen Einrichtung voraussichtlich ausläuft / Jahr, in dem die Lebensdauer der elektrischen Einrichtung voraussichtlich ausläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_electric_equipment
BEFORE UPDATE OR INSERT ON
 tww_od.electric_equipment
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.electromechanical_equipment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_electromechanical_equipment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_electromechanical_equipment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.electromechanical_equipment ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','electromechanical_equipment');
COMMENT ON COLUMN tww_od.electromechanical_equipment.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.electromechanical_equipment ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.electromechanical_equipment.gross_costs IS 'Gross costs of electromechanical equipment / Brutto Erstellungskosten der elektromechanischen Ausrüstung / Coûts bruts des équipements électromécaniques';
 ALTER TABLE tww_od.electromechanical_equipment ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.electromechanical_equipment.kind IS 'yyy_Elektromechanische Teile eines Bauwerks / Elektromechanische Teile eines Bauwerks / Eléments électromécaniques d''un ouvrage';
 ALTER TABLE tww_od.electromechanical_equipment ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.electromechanical_equipment.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_electromechanical_equipment
BEFORE UPDATE OR INSERT ON
 tww_od.electromechanical_equipment
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.benching
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_benching_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_benching_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.benching ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','benching');
COMMENT ON COLUMN tww_od.benching.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.benching ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.benching.kind IS '';
-------
CREATE TRIGGER
update_last_modified_benching
BEFORE UPDATE OR INSERT ON
 tww_od.benching
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.flushing_nozzle
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_flushing_nozzle_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_flushing_nozzle_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.flushing_nozzle ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','flushing_nozzle');
COMMENT ON COLUMN tww_od.flushing_nozzle.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
ALTER TABLE tww_od.flushing_nozzle ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_flushing_nozzle_situation_geometry ON tww_od.flushing_nozzle USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.flushing_nozzle.situation_geometry IS '';
-------
CREATE TRIGGER
update_last_modified_flushing_nozzle
BEFORE UPDATE OR INSERT ON
 tww_od.flushing_nozzle
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.connection_object
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_connection_object_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_connection_object_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.connection_object ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','connection_object');
COMMENT ON COLUMN tww_od.connection_object.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.connection_object ADD COLUMN identifier text;
 ALTER TABLE tww_od.connection_object ADD CONSTRAINT cn_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.connection_object.identifier IS '';
 ALTER TABLE tww_od.connection_object ADD COLUMN remark text;
 ALTER TABLE tww_od.connection_object ADD CONSTRAINT cn_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.connection_object.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.connection_object ADD COLUMN sewer_infiltration_water_production  decimal(9,3) ;
COMMENT ON COLUMN tww_od.connection_object.sewer_infiltration_water_production IS 'yyy_Durchschnittlicher Fremdwasseranfall für Fremdwasserquellen wie Laufbrunnen oder Reservoirüberlauf / Durchschnittlicher Fremdwasseranfall für Fremdwasserquellen wie Laufbrunnen oder Reservoirüberlauf / Apport moyen d''eaux claires parasites (ECP) par des sources d''ECP, telles que fontaines ou trops-plein de réservoirs';
 ALTER TABLE tww_od.connection_object ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.connection_object.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.connection_object ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.connection_object.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.connection_object ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.connection_object.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_connection_object
BEFORE UPDATE OR INSERT ON
 tww_od.connection_object
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.building
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_building_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_building_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.building ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','building');
COMMENT ON COLUMN tww_od.building.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.building ADD COLUMN house_number text;
 ALTER TABLE tww_od.building ADD CONSTRAINT bu_house_number_length_max_50 CHECK(char_length(house_number)<=50);
COMMENT ON COLUMN tww_od.building.house_number IS 'House number based on cadastral register / Hausnummer gemäss Grundbuch / Numéro de bâtiment selon le registre foncier';
 ALTER TABLE tww_od.building ADD COLUMN location_name text;
 ALTER TABLE tww_od.building ADD CONSTRAINT bu_location_name_length_max_50 CHECK(char_length(location_name)<=50);
COMMENT ON COLUMN tww_od.building.location_name IS 'Street name or name of the location / Strassenname oder Ortsbezeichnung / Nom de la route ou du lieu';
ALTER TABLE tww_od.building ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_building_perimeter_geometry ON tww_od.building USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.building.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
ALTER TABLE tww_od.building ADD COLUMN reference_point_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_building_reference_point_geometry ON tww_od.building USING gist (reference_point_geometry );
COMMENT ON COLUMN tww_od.building.reference_point_geometry IS 'National position coordinates (East, North) (relevant point for e.g. address) / Landeskoordinate Ost/Nord (massgebender Bezugspunkt für z.B. Adressdaten ) / Coordonnées nationales Est/Nord (Point de référence pour la détermination de l''adresse par exemple)';
-------
CREATE TRIGGER
update_last_modified_building
BEFORE UPDATE OR INSERT ON
 tww_od.building
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.connection_object");

-------
-------
CREATE TABLE tww_od.reservoir
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_reservoir_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_reservoir_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.reservoir ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reservoir');
COMMENT ON COLUMN tww_od.reservoir.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.reservoir ADD COLUMN location_name text;
 ALTER TABLE tww_od.reservoir ADD CONSTRAINT rv_location_name_length_max_50 CHECK(char_length(location_name)<=50);
COMMENT ON COLUMN tww_od.reservoir.location_name IS 'Street name or name of the location / Strassenname oder Ortsbezeichnung / Nom de la route ou du lieu';
ALTER TABLE tww_od.reservoir ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_reservoir_situation_geometry ON tww_od.reservoir USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.reservoir.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
-------
CREATE TRIGGER
update_last_modified_reservoir
BEFORE UPDATE OR INSERT ON
 tww_od.reservoir
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.connection_object");

-------
-------
CREATE TABLE tww_od.individual_surface
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_individual_surface_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_individual_surface_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.individual_surface ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','individual_surface');
COMMENT ON COLUMN tww_od.individual_surface.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.individual_surface ADD COLUMN function  integer ;
COMMENT ON COLUMN tww_od.individual_surface.function IS 'Type of usage of surface / Art der Nutzung der Fläche / Genre d''utilisation de la surface';
 ALTER TABLE tww_od.individual_surface ADD COLUMN inclination  smallint ;
COMMENT ON COLUMN tww_od.individual_surface.inclination IS 'yyy_Mittlere Neigung der Oberfläche in Promill / Mittlere Neigung der Oberfläche in Promill / Pente moyenne de la surface en promille';
 ALTER TABLE tww_od.individual_surface ADD COLUMN pavement  integer ;
COMMENT ON COLUMN tww_od.individual_surface.pavement IS 'Type of pavement / Art der Befestigung / Genre de couverture du sol';
ALTER TABLE tww_od.individual_surface ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_individual_surface_perimeter_geometry ON tww_od.individual_surface USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.individual_surface.perimeter_geometry IS 'Boundary points of the perimeter / Begrenzungspunkte der Fläche / Points de délimitation de la surface';
-------
CREATE TRIGGER
update_last_modified_individual_surface
BEFORE UPDATE OR INSERT ON
 tww_od.individual_surface
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.connection_object");

-------
-------
CREATE TABLE tww_od.fountain
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_fountain_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_fountain_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.fountain ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','fountain');
COMMENT ON COLUMN tww_od.fountain.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.fountain ADD COLUMN location_name text;
 ALTER TABLE tww_od.fountain ADD CONSTRAINT fo_location_name_length_max_50 CHECK(char_length(location_name)<=50);
COMMENT ON COLUMN tww_od.fountain.location_name IS 'Street name or name of the location / Strassenname oder Ortsbezeichnung / Nom de la route ou du lieu';
ALTER TABLE tww_od.fountain ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_fountain_situation_geometry ON tww_od.fountain USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.fountain.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
-------
CREATE TRIGGER
update_last_modified_fountain
BEFORE UPDATE OR INSERT ON
 tww_od.fountain
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.connection_object");

-------
-------
CREATE TABLE tww_od.log_card
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_log_card_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_log_card_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.log_card ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','log_card');
COMMENT ON COLUMN tww_od.log_card.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.log_card ADD COLUMN control_remote_control  integer ;
COMMENT ON COLUMN tww_od.log_card.control_remote_control IS 'Control/alarm of the special structure. In contrast to the Control attribute in the VSA-DSS classes overflow and throttle_shut_off_unit, the present attribute refers to the entire control/alarm of the special structure. The value range is meant to be cumulative in the following order: no_control, local_control, transmission_alarm, transmission_measuring_signals, interconnection. / Steuerung/Alarmierung des Sonderbauwerks. Der Wertebereich ist kumulativ in der folgenden Reihenfolge gedacht: Keine_Steuerung, Lokale_Steuerung, Uebermittlung_Alarm, Uebermittlung_Messsignale, Verbundsteuerung. Im Gegensatz zum Attribut Steuerung in den VSA-DSS-Klassen Ueberlauf und Absperr_Drosselorgan bezieht sich das vorliegende Attribut auf die gesamte Steuerung/Alarmierung des Sonderbauwerks. / Commande/alarme de l''ouvrage spécial. La plage de valeurs est censée être cumulative dans l''ordre suivant : aucune_commande, commande_locale, transmission_alarme, transmission_signaux_mesure, commande_combinee. Contrairement à l''attribut COMMANDE dans les classes VSA-SDEE DEVERSOIR et LIMITEUR_DEBIT, cet attribut fait référence à l''ensemble commande/alarme de l''ouvrage spécial.';
 ALTER TABLE tww_od.log_card ADD COLUMN information_source  integer ;
COMMENT ON COLUMN tww_od.log_card.information_source IS 'Categories for information sources / Für die Quellen stehen die angegebenen Möglichkeiten zur Verfügung. / Valeurs à disposition pour les sources d’information sur une liste à choix';
 ALTER TABLE tww_od.log_card ADD COLUMN person_in_charge text;
 ALTER TABLE tww_od.log_card ADD CONSTRAINT lc_person_in_charge_length_max_50 CHECK(char_length(person_in_charge)<=50);
COMMENT ON COLUMN tww_od.log_card.person_in_charge IS 'Person in charge that created the log_card / Sachbearbeiter, der die Stammkarte erstellt hat. / Technicien ayant remplir la fiche technique.';
 ALTER TABLE tww_od.log_card ADD COLUMN remark text;
 ALTER TABLE tww_od.log_card ADD CONSTRAINT lc_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.log_card.remark IS 'If log_card Other insert description here / Falls Stammkarte Uebrige hier Beschrieb einfügen / Si FICHE_TECHNIQUE Autres, insérer ici la description';
 ALTER TABLE tww_od.log_card ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.log_card.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.log_card ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.log_card.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.log_card ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.log_card.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_log_card
BEFORE UPDATE OR INSERT ON
 tww_od.log_card
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.catchment_area
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_catchment_area_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_catchment_area_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.catchment_area ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','catchment_area');
COMMENT ON COLUMN tww_od.catchment_area.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.catchment_area ADD COLUMN direct_discharge_current  integer ;
COMMENT ON COLUMN tww_od.catchment_area.direct_discharge_current IS 'The rain water is currently fully or partially discharged into a water body / Das Niederschlagsabwasser wird ganz oder teilweise über eine SAA-Leitung in ein Gewässer eingeleitet / Les eaux pluviales sont rejetées complètement ou partiellement via une conduite OAS dans un cours d’eau';
 ALTER TABLE tww_od.catchment_area ADD COLUMN direct_discharge_planned  integer ;
COMMENT ON COLUMN tww_od.catchment_area.direct_discharge_planned IS 'The rain water will be discharged fully or partially over a SAA pipe into a water body / Das Niederschlagsabwasser wird in Zukunft ganz oder teilweise über eine SAA-Leitung in ein Gewässer eingeleitet / Les eaux pluviales seront rejetées complètement ou partiellement via une conduite OAS dans un cours d’eau';
 ALTER TABLE tww_od.catchment_area ADD COLUMN discharge_coefficient_rw_current  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.discharge_coefficient_rw_current IS 'yyy_Abflussbeiwert für den Niederschlagsabwasseranschluss im Ist-Zustand / Abflussbeiwert für den Niederschlagsabwasseranschluss im Ist-Zustand / Coefficient de ruissellement pour le raccordement actuel des eaux pluviales';
 ALTER TABLE tww_od.catchment_area ADD COLUMN discharge_coefficient_rw_planned  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.discharge_coefficient_rw_planned IS 'yyy_Abflussbeiwert für den Niederschlagsabwasseranschluss im Planungszustand / Abflussbeiwert für den Niederschlagsabwasseranschluss im Planungszustand / Coefficient de ruissellement prévu pour le raccordement des eaux pluviales';
 ALTER TABLE tww_od.catchment_area ADD COLUMN discharge_coefficient_ww_current  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.discharge_coefficient_ww_current IS 'yy_Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Coefficient de ruissellement pour les raccordements eaux usées et eaux mixtes actuels';
 ALTER TABLE tww_od.catchment_area ADD COLUMN discharge_coefficient_ww_planned  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.discharge_coefficient_ww_planned IS 'yyy_Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Abflussbeiwert für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Coefficient de ruissellement pour le raccordement prévu des eaux usées ou mixtes';
 ALTER TABLE tww_od.catchment_area ADD COLUMN drainage_system_current  integer ;
COMMENT ON COLUMN tww_od.catchment_area.drainage_system_current IS 'yyy_Effektive Entwässerungsart im Ist-Zustand / Effektive Entwässerungsart im Ist-Zustand / Genre d’évacuation des eaux réel à l’état actuel';
 ALTER TABLE tww_od.catchment_area ADD COLUMN drainage_system_planned  integer ;
COMMENT ON COLUMN tww_od.catchment_area.drainage_system_planned IS 'yyy_Entwässerungsart im Planungszustand (nach Umsetzung des Entwässerungskonzepts). Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Entwässerungsart im Planungszustand (nach Umsetzung des Entwässerungskonzepts). Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Genre d’évacuation des eaux à l’état de planification (mise en œuvre du concept d’évacuation). Cet attribut est exigé. Il est obligatoire pour l’examen des demandes de permit de construire';
 ALTER TABLE tww_od.catchment_area ADD COLUMN identifier text;
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT ca_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.catchment_area.identifier IS '';
 ALTER TABLE tww_od.catchment_area ADD COLUMN infiltration_current  integer ;
COMMENT ON COLUMN tww_od.catchment_area.infiltration_current IS 'yyy_Das Niederschlagsabwasser wird ganz oder teilweise einer Versickerungsanlage zugeführt / Das Niederschlagsabwasser wird ganz oder teilweise einer Versickerungsanlage zugeführt / Les eaux pluviales sont amenées complètement ou partiellement à une installation d’infiltration';
 ALTER TABLE tww_od.catchment_area ADD COLUMN infiltration_planned  integer ;
COMMENT ON COLUMN tww_od.catchment_area.infiltration_planned IS 'In the future the rain water will  be completly or partially infiltrated in a infiltration unit. / Das Niederschlagsabwasser wird in Zukunft ganz oder teilweise einer Versickerungsanlage zugeführt / Les eaux pluviales seront amenées complètement ou partiellement à une installation d’infiltration';
ALTER TABLE tww_od.catchment_area ADD COLUMN perimeter_geometry geometry('CURVEPOLYGON', :SRID);
CREATE INDEX in_tww_catchment_area_perimeter_geometry ON tww_od.catchment_area USING gist (perimeter_geometry );
COMMENT ON COLUMN tww_od.catchment_area.perimeter_geometry IS 'Boundary points of the perimeter sub catchment area / Begrenzungspunkte des Teileinzugsgebiets / Points de délimitation du bassin versant partiel';
 ALTER TABLE tww_od.catchment_area ADD COLUMN population_density_current  smallint ;
COMMENT ON COLUMN tww_od.catchment_area.population_density_current IS 'yyy_Dichte der (physischen) Einwohner im Ist-Zustand / Dichte der (physischen) Einwohner im Ist-Zustand / Densité (physique) de la population actuelle';
 ALTER TABLE tww_od.catchment_area ADD COLUMN population_density_planned  smallint ;
COMMENT ON COLUMN tww_od.catchment_area.population_density_planned IS 'yyy_Dichte der (physischen) Einwohner im Planungszustand / Dichte der (physischen) Einwohner im Planungszustand / Densité (physique) de la population prévue';
 ALTER TABLE tww_od.catchment_area ADD COLUMN remark text;
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT ca_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.catchment_area.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.catchment_area ADD COLUMN retention_current  integer ;
COMMENT ON COLUMN tww_od.catchment_area.retention_current IS 'yyy_Das Regen- oder Mischabwasser wird über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Das Regen- oder Mischabwasser wird über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Les eaux pluviales et mixtes sont rejetées de manière régulée dans le réseau des canalisations par un ouvrage de rétention.';
 ALTER TABLE tww_od.catchment_area ADD COLUMN retention_planned  integer ;
COMMENT ON COLUMN tww_od.catchment_area.retention_planned IS 'yyy_Das Regen- oder Mischabwasser wird in Zukunft über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Das Regen- oder Mischabwasser wird in Zukunft über Rückhalteeinrichtungen verzögert ins Kanalnetz eingeleitet. / Les eaux pluviales et mixtes seront rejetées de manière régulée dans le réseau des canalisations par un ouvrage de rétention.';
 ALTER TABLE tww_od.catchment_area ADD COLUMN runoff_limit_current  decimal(4,1) ;
COMMENT ON COLUMN tww_od.catchment_area.runoff_limit_current IS 'yyy_Abflussbegrenzung, falls eine entsprechende Auflage bereits umgesetzt ist. / Abflussbegrenzung, falls eine entsprechende Auflage bereits umgesetzt ist. / Restriction de débit, si une exigence est déjà mise en œuvre';
 ALTER TABLE tww_od.catchment_area ADD COLUMN runoff_limit_planned  decimal(4,1) ;
COMMENT ON COLUMN tww_od.catchment_area.runoff_limit_planned IS 'yyy_Abflussbegrenzung, falls eine entsprechende Auflage aus dem Entwässerungskonzept vorliegt. Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Abflussbegrenzung, falls eine entsprechende Auflage aus dem Entwässerungskonzept vorliegt. Dieses Attribut hat Auflagecharakter. Es ist verbindlich für die Beurteilung von Baugesuchen / Restriction de débit, si une exigence correspondante existe dans le concept d’évacuation des eaux. Cet attribut est une exigence et obligatoire pour l’examen de demandes de permit de construire';
 ALTER TABLE tww_od.catchment_area ADD COLUMN seal_factor_rw_current  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.seal_factor_rw_current IS 'yyy_Befestigungsgrad für den Niederschlagsabwasseranschluss im Ist-Zustand / Befestigungsgrad für den Niederschlagsabwasseranschluss im Ist-Zustand / Taux d''imperméabilisation pour le raccordement eaux pluviales actuel';
 ALTER TABLE tww_od.catchment_area ADD COLUMN seal_factor_rw_planned  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.seal_factor_rw_planned IS 'yyy_Befestigungsgrad für den Niederschlagsabwasseranschluss im Planungszustand / Befestigungsgrad für den Niederschlagsabwasseranschluss im Planungszustand / Taux d''imperméabilisation pour le raccordement eaux pluviales prévu';
 ALTER TABLE tww_od.catchment_area ADD COLUMN seal_factor_ww_current  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.seal_factor_ww_current IS 'yyy_Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Ist-Zustand / Taux d''imperméabilisation pour les raccordements eaux usées et eaux mixtes actuels';
 ALTER TABLE tww_od.catchment_area ADD COLUMN seal_factor_ww_planned  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area.seal_factor_ww_planned IS 'yyy_Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Befestigungsgrad für den Schmutz- oder Mischabwasseranschluss im Planungszustand / Taux d''imperméabilisation pour les raccordements eaux usées et eaux mixtes prévus';
 ALTER TABLE tww_od.catchment_area ADD COLUMN sewer_infiltration_water_production_current  decimal(9,3) ;
COMMENT ON COLUMN tww_od.catchment_area.sewer_infiltration_water_production_current IS 'yyy_Mittlerer Fremdwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Mittlerer Fremdwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Débit  d''eaux claires parasites (ECP) moyen actuel, rejeté dans les canalisation d’eaux usées ou mixtes';
 ALTER TABLE tww_od.catchment_area ADD COLUMN sewer_infiltration_water_production_planned  decimal(9,3) ;
COMMENT ON COLUMN tww_od.catchment_area.sewer_infiltration_water_production_planned IS 'yyy_Mittlerer Fremdwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Mittlerer Fremdwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Débit  d''eaux claires parasites (ECP) moyen prévu, rejeté dans les canalisation d’eaux usées ou mixtes';
 ALTER TABLE tww_od.catchment_area ADD COLUMN surface_area  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area.surface_area IS 'yyy_redundantes Attribut Flaeche, welches die aus dem Perimeter errechnete Flaeche [ha] enthält / Redundantes Attribut Flaeche, welches die aus dem Perimeter errechnete Flaeche [ha] enthält / Attribut redondant indiquant la surface calculée à partir du périmètre en ha';
 ALTER TABLE tww_od.catchment_area ADD COLUMN waste_water_production_current  decimal(9,3) ;
COMMENT ON COLUMN tww_od.catchment_area.waste_water_production_current IS 'yyy_Mittlerer Schmutzabwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Mittlerer Schmutzabwasseranfall, der im Ist-Zustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird / Débit moyen actuel des eaux usées rejetées dans les canalisations d’eaux usées ou d''eaux mixtes';
 ALTER TABLE tww_od.catchment_area ADD COLUMN waste_water_production_planned  decimal(9,3) ;
COMMENT ON COLUMN tww_od.catchment_area.waste_water_production_planned IS 'yyy_Mittlerer Schmutzabwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Mittlerer Schmutzabwasseranfall, der im Planungszustand in die Schmutz- oder Mischabwasserkanalisation eingeleitet wird. / Débit moyen prévu des eaux usées rejetées dans les canalisations d’eaux usées ou d''eaux mixtes.';
 ALTER TABLE tww_od.catchment_area ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.catchment_area.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.catchment_area ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.catchment_area.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.catchment_area ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.catchment_area.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_catchment_area
BEFORE UPDATE OR INSERT ON
 tww_od.catchment_area
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.surface_runoff_parameters
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_surface_runoff_parameters_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_surface_runoff_parameters_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.surface_runoff_parameters ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','surface_runoff_parameters');
COMMENT ON COLUMN tww_od.surface_runoff_parameters.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN evaporation_loss  decimal(4,1) ;
COMMENT ON COLUMN tww_od.surface_runoff_parameters.evaporation_loss IS 'Loss by evaporation / Verlust durch Verdunstung / Pertes par évaporation au sol';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN identifier text;
 ALTER TABLE tww_od.surface_runoff_parameters ADD CONSTRAINT sr_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.surface_runoff_parameters.identifier IS '';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN infiltration_loss  decimal(4,1) ;
COMMENT ON COLUMN tww_od.surface_runoff_parameters.infiltration_loss IS 'Loss by infiltration / Verlust durch Infiltration / Pertes par infiltration';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN remark text;
 ALTER TABLE tww_od.surface_runoff_parameters ADD CONSTRAINT sr_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.surface_runoff_parameters.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN surface_storage  decimal(4,1) ;
COMMENT ON COLUMN tww_od.surface_runoff_parameters.surface_storage IS 'Loss by filing depressions in the surface / Verlust durch Muldenfüllung / Pertes par remplissage de dépressions';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN wetting_loss  decimal(4,1) ;
COMMENT ON COLUMN tww_od.surface_runoff_parameters.wetting_loss IS 'Loss of wetting plantes and surface during rainfall / Verlust durch Haftung des Niederschlages an Pflanzen- und andere Oberfläche / Pertes par rétention des précipitations sur la végétation et autres surfaces';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.surface_runoff_parameters.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.surface_runoff_parameters.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.surface_runoff_parameters.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_surface_runoff_parameters
BEFORE UPDATE OR INSERT ON
 tww_od.surface_runoff_parameters
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.measuring_point
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_measuring_point_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_measuring_point_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.measuring_point ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','measuring_point');
COMMENT ON COLUMN tww_od.measuring_point.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.measuring_point ADD COLUMN damming_device  integer ;
COMMENT ON COLUMN tww_od.measuring_point.damming_device IS '';
 ALTER TABLE tww_od.measuring_point ADD COLUMN identifier text;
 ALTER TABLE tww_od.measuring_point ADD CONSTRAINT mp_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.measuring_point.identifier IS '';
 ALTER TABLE tww_od.measuring_point ADD COLUMN kind text;
 ALTER TABLE tww_od.measuring_point ADD CONSTRAINT mp_kind_length_max_50 CHECK(char_length(kind)<=50);
COMMENT ON COLUMN tww_od.measuring_point.kind IS 'yyy_Art der Untersuchungsstelle ( Regenmessungen, Abflussmessungen, etc.) / Art der Untersuchungsstelle ( Regenmessungen, Abflussmessungen, etc.) / Genre de mesure (mesures de pluviométrie, mesures de débit, etc.)';
 ALTER TABLE tww_od.measuring_point ADD COLUMN purpose  integer ;
COMMENT ON COLUMN tww_od.measuring_point.purpose IS 'Purpose of measurement / Zweck der Messung / Objet de la mesure';
 ALTER TABLE tww_od.measuring_point ADD COLUMN remark text;
 ALTER TABLE tww_od.measuring_point ADD CONSTRAINT mp_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.measuring_point.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
ALTER TABLE tww_od.measuring_point ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_measuring_point_situation_geometry ON tww_od.measuring_point USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.measuring_point.situation_geometry IS 'National position coordinates (East, North) / Landeskoordinate Ost/Nord / Coordonnées nationales Est/Nord';
 ALTER TABLE tww_od.measuring_point ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.measuring_point.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.measuring_point ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.measuring_point.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.measuring_point ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.measuring_point.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measuring_point
BEFORE UPDATE OR INSERT ON
 tww_od.measuring_point
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.measuring_device
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_measuring_device_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_measuring_device_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.measuring_device ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','measuring_device');
COMMENT ON COLUMN tww_od.measuring_device.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.measuring_device ADD COLUMN brand text;
 ALTER TABLE tww_od.measuring_device ADD CONSTRAINT mv_brand_length_max_50 CHECK(char_length(brand)<=50);
COMMENT ON COLUMN tww_od.measuring_device.brand IS 'Brand / Name of producer / Name des Herstellers / Nom du fabricant';
 ALTER TABLE tww_od.measuring_device ADD COLUMN identifier text;
 ALTER TABLE tww_od.measuring_device ADD CONSTRAINT mv_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.measuring_device.identifier IS '';
 ALTER TABLE tww_od.measuring_device ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.measuring_device.kind IS 'Type of measuring device / Typ des Messgerätes / Type de l''appareil de mesure';
 ALTER TABLE tww_od.measuring_device ADD COLUMN remark text;
 ALTER TABLE tww_od.measuring_device ADD CONSTRAINT mv_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.measuring_device.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.measuring_device ADD COLUMN serial_number text;
 ALTER TABLE tww_od.measuring_device ADD CONSTRAINT mv_serial_number_length_max_50 CHECK(char_length(serial_number)<=50);
COMMENT ON COLUMN tww_od.measuring_device.serial_number IS '';
 ALTER TABLE tww_od.measuring_device ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.measuring_device.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.measuring_device ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.measuring_device.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.measuring_device ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.measuring_device.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measuring_device
BEFORE UPDATE OR INSERT ON
 tww_od.measuring_device
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.measurement_series
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_measurement_series_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_measurement_series_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.measurement_series ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','measurement_series');
COMMENT ON COLUMN tww_od.measurement_series.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.measurement_series ADD COLUMN dimension text;
 ALTER TABLE tww_od.measurement_series ADD CONSTRAINT ms_dimension_length_max_50 CHECK(char_length(dimension)<=50);
COMMENT ON COLUMN tww_od.measurement_series.dimension IS 'yyy_Messtypen (Einheit) / Messtypen (Einheit) / Types de mesures';
 ALTER TABLE tww_od.measurement_series ADD COLUMN identifier text;
 ALTER TABLE tww_od.measurement_series ADD CONSTRAINT ms_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.measurement_series.identifier IS '';
 ALTER TABLE tww_od.measurement_series ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.measurement_series.kind IS 'Type of measurment series / Art der Messreihe / Genre de série de mesures';
 ALTER TABLE tww_od.measurement_series ADD COLUMN remark text;
 ALTER TABLE tww_od.measurement_series ADD CONSTRAINT ms_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.measurement_series.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.measurement_series ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.measurement_series.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.measurement_series ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.measurement_series.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.measurement_series ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.measurement_series.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measurement_series
BEFORE UPDATE OR INSERT ON
 tww_od.measurement_series
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.measurement_result
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_measurement_result_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_measurement_result_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.measurement_result ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','measurement_result');
COMMENT ON COLUMN tww_od.measurement_result.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.measurement_result ADD COLUMN identifier text;
 ALTER TABLE tww_od.measurement_result ADD CONSTRAINT mr_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.measurement_result.identifier IS '';
 ALTER TABLE tww_od.measurement_result ADD COLUMN measurement_type  integer ;
COMMENT ON COLUMN tww_od.measurement_result.measurement_type IS 'Type of measurment, e.g. proportional to time or volume / Art der Messung, z.B zeit- oder mengenproportional / Type de mesure, par ex. proportionnel au temps ou au débit';
 ALTER TABLE tww_od.measurement_result ADD COLUMN measuring_duration  decimal(7,0) ;
COMMENT ON COLUMN tww_od.measurement_result.measuring_duration IS 'Duration of measurment in seconds / Dauer der Messung in Sekunden / Durée de la mesure';
 ALTER TABLE tww_od.measurement_result ADD COLUMN remark text;
 ALTER TABLE tww_od.measurement_result ADD CONSTRAINT mr_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.measurement_result.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.measurement_result ADD COLUMN time  timestamp without time zone ;
COMMENT ON COLUMN tww_od.measurement_result.time IS 'Date and time at beginning of measurment / Zeitpunkt des Messbeginns / Date et heure du début de la mesure';
 ALTER TABLE tww_od.measurement_result ADD COLUMN value  real ;
COMMENT ON COLUMN tww_od.measurement_result.value IS 'yyy_Gemessene Grösse / Gemessene Grösse / Valeur mesurée';
 ALTER TABLE tww_od.measurement_result ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.measurement_result.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.measurement_result ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.measurement_result.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.measurement_result ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.measurement_result.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_measurement_result
BEFORE UPDATE OR INSERT ON
 tww_od.measurement_result
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.overflow
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_overflow_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_overflow_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.overflow ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','overflow');
COMMENT ON COLUMN tww_od.overflow.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.overflow ADD COLUMN actuation  integer ;
COMMENT ON COLUMN tww_od.overflow.actuation IS 'Actuation of installation / Antrieb der Einbaute / Entraînement des installations';
 ALTER TABLE tww_od.overflow ADD COLUMN adjustability  integer ;
COMMENT ON COLUMN tww_od.overflow.adjustability IS 'yyy_Möglichkeit zur Verstellung / Möglichkeit zur Verstellung / Possibilité de modifier la position';
 ALTER TABLE tww_od.overflow ADD COLUMN brand text;
 ALTER TABLE tww_od.overflow ADD CONSTRAINT ov_brand_length_max_50 CHECK(char_length(brand)<=50);
COMMENT ON COLUMN tww_od.overflow.brand IS 'Manufacturer of the electro-mechaninc equipment or installation / Hersteller der elektro-mechanischen Ausrüstung oder Einrichtung / Fabricant d''équipement électromécanique ou d''installations';
 ALTER TABLE tww_od.overflow ADD COLUMN control  integer ;
COMMENT ON COLUMN tww_od.overflow.control IS 'yyy_Steuer- und Regelorgan für die Einbaute / Steuer- und Regelorgan für die Einbaute / Dispositifs de commande et de régulation des installations';
 ALTER TABLE tww_od.overflow ADD COLUMN discharge_point text;
 ALTER TABLE tww_od.overflow ADD CONSTRAINT ov_discharge_point_length_max_20 CHECK(char_length(discharge_point)<=20);
COMMENT ON COLUMN tww_od.overflow.discharge_point IS 'Identifier of discharge_point in which the overflow is discharging (redundant attribute with network follow up or result of that). Is only needed if overflow is discharging into a river (directly or via a rainwater drainage). Foreignkey to discharge_point in class catchment_area_totals in extension Stammkarte. / Bezeichnung der Einleitstelle in die der Ueberlauf entlastet (redundantes Attribut zur Netzverfolgung oder Resultat davon). Muss nur erfasst werden, wenn das Abwasser vom Notüberlauf in ein Gewässer eingeleitet wird (direkt oder über eine Niederschlagsabwasserleitung). Verknüpfung mit Fremdschlüssel zu Einleitstelle in Klasse Gesamteinzugsgebiet in Erweiterung Stammkarte. / Désignation de l''exutoire: A indiquer uniquement lorsque l’eau déversée est rejetée dans un cours d’eau (directement ou indirectement via une conduite d’eaux pluviales). Association à l''exutoire dans la classe BASSIN_VERSANT_COMPLET de l''extension fichier technique.';
 ALTER TABLE tww_od.overflow ADD COLUMN function  integer ;
COMMENT ON COLUMN tww_od.overflow.function IS 'yyy_Funktion des Überlaufs charakterisiert durch den Teil des Mischwasserabflusses, der aus einem Überlauf in ein Gewässer oder in ein Abwasserbauwerk abgeleitet wird / Funktion des Überlaufs charakterisiert durch den Teil des Mischwasserabflusses, der aus einem Überlauf in ein Gewässer oder in ein Abwasserbauwerk abgeleitet wird. / Type de déversoir caractérisé par la partie de l''eau mixte déversée depuis le déversoir dans un cours d''eau, un plan d''eau ou un ouvrage_resau_as';
 ALTER TABLE tww_od.overflow ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.overflow.gross_costs IS 'Gross costs / Brutto Erstellungskosten / Coûts bruts de réalisation';
 ALTER TABLE tww_od.overflow ADD COLUMN identifier text;
 ALTER TABLE tww_od.overflow ADD CONSTRAINT ov_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.overflow.identifier IS '';
 ALTER TABLE tww_od.overflow ADD COLUMN qon_dim  decimal(9,3) ;
COMMENT ON COLUMN tww_od.overflow.qon_dim IS 'yyy_Wassermenge, bei welcher der Überlauf gemäss Dimensionierung anspringt / Wassermenge, bei welcher der Überlauf gemäss Dimensionierung anspringt / Débit à partir duquel le déversoir devrait être fonctionnel (selon dimensionnement)';
 ALTER TABLE tww_od.overflow ADD COLUMN remark text;
 ALTER TABLE tww_od.overflow ADD CONSTRAINT ov_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.overflow.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.overflow ADD COLUMN signal_transmission  integer ;
COMMENT ON COLUMN tww_od.overflow.signal_transmission IS 'Signal or data transfer from or to a telecommunication station / Signalübermittlung von und zu einer Fernwirkanlage / Transmission des signaux de et vers une station de télécommande';
 ALTER TABLE tww_od.overflow ADD COLUMN subsidies  decimal(10,2) ;
COMMENT ON COLUMN tww_od.overflow.subsidies IS 'yyy_Staats- und Bundesbeiträge / Staats- und Bundesbeiträge / Contributions des cantons et de la confédération';
 ALTER TABLE tww_od.overflow ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.overflow.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.overflow ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.overflow.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.overflow ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.overflow.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_overflow
BEFORE UPDATE OR INSERT ON
 tww_od.overflow
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.throttle_shut_off_unit
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_throttle_shut_off_unit_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_throttle_shut_off_unit_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.throttle_shut_off_unit ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','throttle_shut_off_unit');
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN actuation  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.actuation IS 'Actuation of the throttle or shut-off unit / Antrieb der Einbaute / Entraînement des installations';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN adjustability  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.adjustability IS 'Possibility to adjust the position / Möglichkeit zur Verstellung / Possibilité de modifier la position';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN control  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.control IS 'Open or closed loop control unit for the installation / Steuer- und Regelorgan für die Einbaute / Dispositifs de commande et de régulation des installations';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN cross_section  decimal(8,2) ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.cross_section IS 'Cross section (geometric area) of throttle or shut-off unit / Geometrischer Drosselquerschnitt: Fgeom / Section géométrique de l''élément régulateur';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN effective_cross_section  decimal(8,2) ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.effective_cross_section IS 'Effective cross section (area) / Wirksamer Drosselquerschnitt : Fid / Section du limiteur hydrauliquement active';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.gross_costs IS 'Gross costs / Brutto Erstellungskosten / Coûts bruts de réalisation';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN identifier text;
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT ts_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.identifier IS '';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.kind IS 'Type of flow control / Art der Durchflussregulierung / Genre de régulation du débit';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN manufacturer text;
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT ts_manufacturer_length_max_50 CHECK(char_length(manufacturer)<=50);
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.manufacturer IS 'Manufacturer of the electro-mechaninc equipment or installation / Hersteller der elektro-mech. Ausrüstung oder Einrichtung / Fabricant d''équipement électromécanique ou d''installations';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN remark text;
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT ts_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN signal_transmission  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.signal_transmission IS 'Signal or data transfer from or to a telecommunication station sending_receiving / Signalübermittlung von und zu einer Fernwirkanlage / Transmission des signaux de et vers une station de télécommande';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN subsidies  decimal(10,2) ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.subsidies IS 'yyy_Staats- und Bundesbeiträge / Staats- und Bundesbeiträge / Contributions des cantons et de la confédération';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN throttle_unit_opening_current  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.throttle_unit_opening_current IS 'yyy_Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine Angabe. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine Angabe. Pumpe: keine Angabe / Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine Angabe. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine Angabe. Pumpe: keine Angabe / Les valeurs suivantes doivent être indiquées: Leaping weir: Longueur ouverture de fond, Cond. d’étranglement : aucune indication, Vanne : hauteur max de l’ouverture (du radier jusqu’au bord inférieur plaque, point le plus bas), Régulateur de débit : aucune indication, Pompe : aucune indication';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN throttle_unit_opening_current_optimized  integer ;
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.throttle_unit_opening_current_optimized IS 'yyy_Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine Angabe. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine Angabe. Pumpe: keine Angabe / Folgende Werte sind anzugeben: Leapingwehr: Schrägdistanz der Blech- resp. Bodenöffnung. Drosselstrecke: keine Angabe. Schieber / Schütz: lichte Höhe der Öffnung (ab Sohle bis UK Schieberplatte, tiefster Punkt). Abflussregulator: keine Angabe. Pumpe: keine Angabe / Les valeurs suivantes doivent être indiquées: Leaping weir: Longueur ouverture de fond, Cond. d’étranglement : aucune indication, Vanne : hauteur max de l’ouverture (du radier jusqu’au bord inférieur plaque, point le plus bas), Régulateur de débit : aucune indication, Pompe : aucune indication';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.throttle_shut_off_unit.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_throttle_shut_off_unit
BEFORE UPDATE OR INSERT ON
 tww_od.throttle_shut_off_unit
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.prank_weir
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_prank_weir_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_prank_weir_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.prank_weir ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','prank_weir');
COMMENT ON COLUMN tww_od.prank_weir.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.prank_weir ADD COLUMN hydraulic_overflow_length  decimal(7,2) ;
COMMENT ON COLUMN tww_od.prank_weir.hydraulic_overflow_length IS 'yyy_Hydraulisch wirksame Wehrlänge / Hydraulisch wirksame Wehrlänge / Longueur du déversoir hydrauliquement active';
 ALTER TABLE tww_od.prank_weir ADD COLUMN level_max  decimal(7,3) ;
COMMENT ON COLUMN tww_od.prank_weir.level_max IS 'yyy_Höhe des höchsten Punktes der Überfallkante / Höhe des höchsten Punktes der Überfallkante / Niveau max. de la crête déversante';
 ALTER TABLE tww_od.prank_weir ADD COLUMN level_min  decimal(7,3) ;
COMMENT ON COLUMN tww_od.prank_weir.level_min IS 'yyy_Höhe des tiefsten Punktes der Überfallkante / Höhe des tiefsten Punktes der Überfallkante / Niveau min. de la crête déversante';
 ALTER TABLE tww_od.prank_weir ADD COLUMN weir_edge  integer ;
COMMENT ON COLUMN tww_od.prank_weir.weir_edge IS 'yyy_Ausbildung der Überfallkante / Ausbildung der Überfallkante / Forme de la crête';
 ALTER TABLE tww_od.prank_weir ADD COLUMN weir_kind  integer ;
COMMENT ON COLUMN tww_od.prank_weir.weir_kind IS 'yyy_Art der Wehrschweille des Streichwehrs / Art der Wehrschwelle des Streichwehrs / Genre de surverse du déversoir latéral';
-------
CREATE TRIGGER
update_last_modified_prank_weir
BEFORE UPDATE OR INSERT ON
 tww_od.prank_weir
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.overflow");

-------
-------
CREATE TABLE tww_od.pump
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_pump_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_pump_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.pump ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','pump');
COMMENT ON COLUMN tww_od.pump.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.pump ADD COLUMN construction_type  integer ;
COMMENT ON COLUMN tww_od.pump.construction_type IS 'Types of pumps / Pumpenarten / Types de pompe';
 ALTER TABLE tww_od.pump ADD COLUMN operating_point  decimal(8,3) ;
COMMENT ON COLUMN tww_od.pump.operating_point IS 'Flow for pumps with fixed operating point / Fördermenge für Pumpen mit fixem Arbeitspunkt / Débit refoulé par la pompe avec point de travail fixe';
 ALTER TABLE tww_od.pump ADD COLUMN placement_of_actuation  integer ;
COMMENT ON COLUMN tww_od.pump.placement_of_actuation IS 'Type of placement of the actuation / Art der Aufstellung des Motors / Genre de montage';
 ALTER TABLE tww_od.pump ADD COLUMN placement_of_pump  integer ;
COMMENT ON COLUMN tww_od.pump.placement_of_pump IS 'Type of placement of the pomp / Art der Aufstellung der Pumpe / Genre de montage de la pompe';
 ALTER TABLE tww_od.pump ADD COLUMN pump_flow_max_single  decimal(9,3) ;
COMMENT ON COLUMN tww_od.pump.pump_flow_max_single IS 'yyy_Maximaler Förderstrom der Pumpen (einzeln als Bauwerkskomponente). Tritt in der Regel bei der minimalen Förderhöhe ein. / Maximaler Förderstrom der Pumpe (einzeln als Bauwerkskomponente). Tritt in der Regel bei der minimalen Förderhöhe ein. / Débit de refoulement maximal des pompes individuelles en tant que composante d’ouvrage. Survient normalement à la hauteur min de refoulement.';
 ALTER TABLE tww_od.pump ADD COLUMN pump_flow_min_single  decimal(9,3) ;
COMMENT ON COLUMN tww_od.pump.pump_flow_min_single IS 'yyy_Minimaler Förderstrom der Pumpe (einzeln als Bauwerkskomponente). Tritt in der Regel bei der maximalen Förderhöhe ein. / Minimaler Förderstrom der Pumpe (einzeln als Bauwerkskomponente). Tritt in der Regel bei der maximalen Förderhöhe ein. / Débit de refoulement maximal de toutes les pompes de l’ouvrage (STAP) ou des pompes individuelles en tant que composante d’ouvrage. Survient normalement à la hauteur min de refoulement.';
 ALTER TABLE tww_od.pump ADD COLUMN start_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.pump.start_level IS 'yyy_Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe eingeschaltet wird (Einschaltkote) / Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe eingeschaltet wird (Einschaltkote) / Cote du niveau d''eau dans le puisard à laquelle s''enclenche la pompe';
 ALTER TABLE tww_od.pump ADD COLUMN stop_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.pump.stop_level IS 'yyy_Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe ausgeschaltet wird (Ausschaltkote) / Kote des Wasserspiegels im Pumpensumpf, bei der die Pumpe ausgeschaltet wird (Ausschaltkote) / Cote du niveau d''eau dans le puisard à laquelle s''arrête la pompe';
-------
CREATE TRIGGER
update_last_modified_pump
BEFORE UPDATE OR INSERT ON
 tww_od.pump
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.overflow");

-------
-------
CREATE TABLE tww_od.leapingweir
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_leapingweir_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_leapingweir_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.leapingweir ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','leapingweir');
COMMENT ON COLUMN tww_od.leapingweir.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.leapingweir ADD COLUMN length  decimal(7,2) ;
COMMENT ON COLUMN tww_od.leapingweir.length IS 'yyy_Maximale Abmessung der Bodenöffnung in Fliessrichtung / Maximale Abmessung der Bodenöffnung in Fliessrichtung / Dimension maximale de l''ouverture de fond parallèlement au courant';
 ALTER TABLE tww_od.leapingweir ADD COLUMN opening_shape  integer ;
COMMENT ON COLUMN tww_od.leapingweir.opening_shape IS 'Shape of opening in the floor / Form der  Bodenöffnung / Forme de l''ouverture de fond';
 ALTER TABLE tww_od.leapingweir ADD COLUMN width  decimal(7,2) ;
COMMENT ON COLUMN tww_od.leapingweir.width IS 'yyy_Maximale Abmessung der Bodenöffnung quer zur Fliessrichtung / Maximale Abmessung der Bodenöffnung quer zur Fliessrichtung / Dimension maximale de l''ouverture de fond perpendiculairement à la direction d''écoulement';
-------
CREATE TRIGGER
update_last_modified_leapingweir
BEFORE UPDATE OR INSERT ON
 tww_od.leapingweir
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.overflow");

-------
-------
CREATE TABLE tww_od.maintenance
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_maintenance_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_maintenance_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.maintenance ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','maintenance');
COMMENT ON COLUMN tww_od.maintenance.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.maintenance ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.maintenance.kind IS 'Type of event / Art des Ereignisses / Genre d''événement';
-------
CREATE TRIGGER
update_last_modified_maintenance
BEFORE UPDATE OR INSERT ON
 tww_od.maintenance
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.maintenance_event");

-------
-------
CREATE TABLE tww_od.bio_ecol_assessment
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_bio_ecol_assessment_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_bio_ecol_assessment_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.bio_ecol_assessment ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','bio_ecol_assessment');
COMMENT ON COLUMN tww_od.bio_ecol_assessment.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN comparison_last  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.comparison_last IS 'yyy_Die Veränderung der Gesamtbeurteilung und eventuelle massgebende veränderte Untersuchungs-resultate gegenüber der letzten Untersuchung müssen dokumentiert werden. / Die Veränderung der Gesamtbeurteilung und eventuelle massgebende veränderte Untersuchungsresultate gegenüber der letzten Untersuchung müssen dokumentiert werden. / Les variations de l’examen générale éco-biologique et des résultats déterminants ayant changés doivent être indiquées par rapport à la dernière inspection.';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN date_last_examen  timestamp without time zone ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.date_last_examen IS 'yyy_Datum der letzten Untersuchung, falls vorhanden. Das Datum der aktuellen Untersuchung wird im Attribut Datum_Untersuchung (VSA-DSS-Mini) bzw. Zeitpunkt (VSA-DSS) erfasst. / Datum der letzten Untersuchung, falls vorhanden. Das Datum der aktuellen Untersuchung wird im Attribut Datum_Untersuchung (VSA-DSS-Mini) bzw. Zeitpunkt (VSA-DSS) erfasst. / Date de l''examen précedent. La date de l’examen actuel est saisie dans l''attribut DATE_EXAMEN (VSA-SDEE-MINI) ou DATE_HEURE (VSA-DSS)';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN impact_auxiliary_indic  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.impact_auxiliary_indic IS 'yyy_Nur für stehende Gewässer / Nur für stehende Gewässer / Uniquement pour eaux stagnantes';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN impact_external_aspect  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.impact_external_aspect IS 'yyy_Resultiert aus dem Vergleich des äusseren Aspekts unterhalb und oberhalb der Einleitstelle / Resultiert aus dem Vergleich des äusseren Aspekts unterhalb und oberhalb der Einleitstelle / Résultat de la comparaison de l''aspect visuel en aval et en amont de l''exutoire';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN impact_macroinvertebrates  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.impact_macroinvertebrates IS 'yyy_Nur für Fliessgewässer. Resultiert aus dem Vergleich der Makroinvertebraten unterhalb und oberhalb der Einleitstelle gemäss dem Modul Gewässeruntersuchung der VSA-Richtlinie Abwasserbewirtschaftung bei Regenwetter. Deshalb nicht zu verwechseln mit den aufgehobenen Attributen Makroinvertebraten_oberhalb, _Einleitung und _unterhalb. / Nur für Fliessgewässer. Resultiert aus dem Vergleich der Makroinvertebraten unterhalb und oberhalb der Einleitstelle gemäss dem Modul Gewässeruntersuchung der VSA-Richtlinie Abwasserbewirtschaftung bei Regenwetter. / Uniquement pour des eaux courantes. Résultat de la comparaison des invertébrés aquatiques en aval et en amont de l''exutoire selon le module Analyse de la qualité des eaux de la directive Gestion des eaux pluviales du VSA. Ne pas confondre avec les attributs INVERTEBREES_EN_AMONT, INVERTEBREES_EXUTOIRE et INVERTEBREES_EN_AVAL.';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN impact_water_plants  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.impact_water_plants IS 'yyy_Nur für stehende Gewässer / Nur für stehende Gewässer / Uniquement pour eaux stagnantes';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN intervention_demand  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.intervention_demand IS 'Need for action resulting from the impairment of the discharge point on the water body, which leads to a measure in the action plan. The attribute is also used to derive the "total impairment" in the MGDM 129.1 of the FOEN, as long as it is still kept there. / Handlungsbedarf resultierend aus der Beeinträchtigung der Einleitstelle auf das Gewässer, der zu einer Massnahme im Massnahmenplan führt. Das Attribut dient auch zur Ableitung der "Gesamtbeeintraechtigung" im MGDM 129.1 des BAFU, solange dieses dort noch geführt wird. / Un besoin d’intervention résulte de l’atteinte du rejet sur les eaux qui mène à une mesure dans le plan d’action du PGEE. L''attribut sert aussi à la détermination de "l''attteinte globale" dans le MGDM 129.1 de l''OFEV si celui-ci est encore géré.';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN io_calculation  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.io_calculation IS 'immission oriented calculation available / Immissionsorientierte Berechnung vorhanden. / calcul de performance de type immission disponible';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN outlet_pipe_clear_height  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.outlet_pipe_clear_height IS 'Maximum internal height of the outlet. Helps to identify the correct discharge point in the field. / Maximale Innenhöhe des Auslaufes. Hilft bei der Identifikation der richtigen Einleitstelle im Feld. / Hauteur intérieure maximale de la sortie. Utile pour identifier le bon exutoire sur le terrain.';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN q347  decimal(8,3) ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.q347 IS 'yyy_Menge aus hydrologischen Jahrbüchern. Fehlt diese Angabe in den Jahrbüchern, ist eine Menge zu bestimmen. / Menge aus hydrologischen Jahrbüchern. Fehlt diese Angabe in den Jahrbüchern, ist eine Menge zu bestimmen. / Valeur issue des annuaires hydrologique de Suisse. Si elle manque, il faut désigner une valeur.';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN relevance_matrix  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.relevance_matrix IS 'yyy_Relevanzmatrix gemäss den Vorgaben in der Richtlinie "Abwasserentsorgung bei Regenwetter", Modul STORM des VSA (2019) / Relevanzmatrix gemäss den Vorgaben in der Richtlinie "Abwasserentsorgung bei Regenwetter", Modul STORM des VSA (2019) / Matrice d’évaluation selon les indications de la directive "Gestion des eaux urbaines par temps de pluie", module STORM du VSA (2019)';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN relevant_slope  smallint ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.relevant_slope IS 'zzz_Relevantes Gefälle [%] bei der Einleitstelle (für STORM Berechnung). Falls unbekannt muss das Gefälle im Feld oder aufgrund von Plangrundlagen bestimmt werden. / Relevantes Gefälle [%] bei der Einleitstelle (für STORM Berechnung). Falls unbekannt muss das Gefälle im Feld oder aufgrund von Plangrundlagen bestimmt werden / Pente déterminante [%] de l’exutoire (pour le calcul STORM). Si inconnue, la pente doit être déterminée sur la base de plans ou par une visite de terrain';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN surface_water_bodies text;
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT bo_surface_water_bodies_length_max_100 CHECK(char_length(surface_water_bodies)<=100);
COMMENT ON COLUMN tww_od.bio_ecol_assessment.surface_water_bodies IS 'Name of surface water body corresponding to cantonal rules / Gewässername gemäss kantonalen Vorgaben / Nom du cours d’eau selon indications cantonales';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN type_water_body  integer ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.type_water_body IS 'based on table 5.1 of STORM module in directive "Abwasserbewirtschaftung bei Regenwetter" of VSA (2019/2021) / gemäss Tabelle 5.1 des Moduls STORM der Richtlinie "Abwasserbewirtschaftung bei Regenwetter" des VSA (2019/2021) / selon table 5.1 du module STORM de la directive "Gestion des eaux urbaines par temps de pluie" (2019/2021)';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN water_specific_discharge_freight_nh4_n_current  smallint ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.water_specific_discharge_freight_nh4_n_current IS 'based on base module chapter 8.4. of directive "Abwasserbewirtschaftung bei Regenwetter" of VSA (2019)" / gemäss Basismodul Kapitel 8.4 der Richtlinie "Abwasserbewirtschaftung bei Regenwetter" des VSA (2019) / Selon module de base chapitre 8.4 de la directive "Gestion des eaux urbaines par temps de pluie" du VSA (2019)';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN water_specific_discharge_freight_nh4_n_current_opt  smallint ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.water_specific_discharge_freight_nh4_n_current_opt IS 'based on base module chapter 8.4. of directive "Abwasserbewirtschaftung bei Regenwetter" of VSA (2019)" / gemäss Basismodul Kapitel 8.4 der Richtlinie "Abwasserbewirtschaftung bei Regenwetter" des VSA (2019) / Selon module de base chapitre 8.4 de la directive "Gestion des eaux urbaines par temps de pluie" du VSA (2019)';
 ALTER TABLE tww_od.bio_ecol_assessment ADD COLUMN water_specific_discharge_freight_nh4_n_planned  smallint ;
COMMENT ON COLUMN tww_od.bio_ecol_assessment.water_specific_discharge_freight_nh4_n_planned IS 'based on base module chapter 8.4. of directive "Abwasserbewirtschaftung bei Regenwetter" of VSA (2019)" / gemäss Basismodul Kapitel 8.4 der Richtlinie "Abwasserbewirtschaftung bei Regenwetter" des VSA (2019) / Selon module de base chapitre 8.4 de la directive "Gestion des eaux urbaines par temps de pluie" du VSA (2019)';
-------
CREATE TRIGGER
update_last_modified_bio_ecol_assessment
BEFORE UPDATE OR INSERT ON
 tww_od.bio_ecol_assessment
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.maintenance_event");

-------
-------
CREATE TABLE tww_od.hydraulic_char_data
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_hydraulic_char_data_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_hydraulic_char_data_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.hydraulic_char_data ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','hydraulic_char_data');
COMMENT ON COLUMN tww_od.hydraulic_char_data.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN aggregate_number  smallint ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.aggregate_number IS 'Number of aggregates / Anzahl Förderaggregate / Nombre d''installations de refoulement';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN delivery_height_geodaetic  decimal(6,2) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.delivery_height_geodaetic IS '';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN identifier text;
 ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT hc_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.hydraulic_char_data.identifier IS '';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN is_overflowing  integer ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.is_overflowing IS 'yyy_Angabe, ob die Entlastung beim Dimensionierungsereignis anspringt / Angabe, ob die Entlastung beim Dimensionierungsereignis anspringt / Indication, si le déversoir déverse lors des événements pour lesquels il a été dimensionné.';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN main_weir_kind  integer ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.main_weir_kind IS 'yyy_Art des Hauptwehrs am Knoten, falls mehrere Überläufe / Art des Hauptwehrs am Knoten, falls mehrere Überläufe / Genre du déversoir principal du noeud concerné s''il y a plusieurs déversoirs.';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN overcharge  smallint ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.overcharge IS 'yyy_Ist: Mehrbelastung der untenliegenden Kanäle beim Dimensionierungsereignis = 100 * (Qab – Qan) / Qan 	[%]. Verhältnis zwischen der abgeleiteten Abwassermengen Richtung ARA beim Anspringen des Entlastungsbauwerkes (Qan) und Qab (Abwassermenge, welche beim Dimensionierungsereignis (z=5) weiter im Kanalnetz Richtung Abwasserreinigungsanlage abgeleitet wird). Beispiel: Qan = 100 l/s, Qab = 150 l/s -> Mehrbelastung = 50%; Ist_optimiert: Optimale Mehrbelastung im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen; geplant: Optimale Mehrbelastung nach der Umsetzung der Massnahmen. / Ist: Mehrbelastung der untenliegenden Kanäle beim Dimensionierungsereignis = 100 * (Qab – Qan) / Qan 	[%]. Verhältnis zwischen der abgeleiteten Abwassermengen Richtung ARA beim Anspringen des Entlastungsbauwerkes (Qan) und Qab (Abwassermenge, welche beim Dimensionierungsereignis (z.B. z=5) weiter im Kanalnetz Richtung Abwasserreinigungsanlage abgeleitet wird). Beispiel: Qan = 100 l/s, Qab = 150 l/s -> Mehrbelastung = 50%; Ist_optimiert: Optimale Mehrbelastung im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen; geplant: Optimale Mehrbelastung nach der Umsetzung der Massnahmen. / Etat actuel: Surcharge des canalisations en aval lors de l''évenement de dimensionnement = 100 * (Qa-Qb)/Qb [%]. Rapport entre la différence du débit acheminé à la STEP lors de l''évenement de dimensionnement (Qa) et au début du déversement (Qb) avec Qb. Exemple: Qb = 100 l/s, Qa = 150 l/s -> surcharge = 50%; état actuel optimisé. Etat actuel optimisé: Surcharge optimisée avant réalisation de mesures (Massnahmen). prévu: Surcharge optimisée après réalisation de mesures (Massnahmen)';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN overflow_duration  decimal(6,1) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.overflow_duration IS 'yyy_Mittlere Überlaufdauer pro Jahr. Bei Ist_Zustand: Berechnung mit geplanten Massnahmen. Bei Ist_optimiert:  Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit geplanten Massnahmen / Mittlere Überlaufdauer pro Jahr. Bei Ist_Zustand: Mittlere Überlaufdauer pro Jahr gemäss Langzeitsimulation oder Messung. Bei Ist_optimiert:  Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit geplanten Massnahmen / Durée moyenne de déversement par an.  Actuel: Durée moyenne de déversement par an selon des simulations à long terme ou des mesures (Messungen). Actuel optimizé: Calcul en mode optimal à l’état actuel avant la réalisation d’éventuelles mesures (Massnahmen). Prévu: Calcul selon les mesures planifiées';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN overflow_freight  integer ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.overflow_freight IS 'Average freight during overflows per year / Mittlere Ueberlaufschmutzfracht pro Jahr / Charge polluante moyenne déversée par année';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN overflow_frequency  decimal(3,1) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.overflow_frequency IS 'yyy_Mittlere Überlaufhäufigkeit pro Jahr. Ist Zustand: Durchschnittliche Überlaufhäufigkeit pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation oder Messungen. Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen / Mittlere Überlaufhäufigkeit pro Jahr. Ist Zustand: Durchschnittliche Überlaufhäufigkeit pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation oder Messungen. Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen / Fréquence moyenne de déversement par an. Fréquence moyenne de déversement par an selon des simulations pour de longs temps de retour (z > 10). Actuel optimizé: Calcul en mode optimal à l’état actuel avant la réalisation d’éventuelles mesures (Massnahmen). Prévu: Calcul après la réalisation d’éventuelles mesures.';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN overflow_volume  decimal(9,2) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.overflow_volume IS 'yyy_Mittlere Überlaufwassermenge pro Jahr. Durchschnittliche Überlaufmenge pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation oder Messungen. Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen. / Mittlere Überlaufwassermenge pro Jahr. Durchschnittliche Überlaufmenge pro Jahr von Entlastungsanlagen gemäss Langzeitsimulation oder Messungen. Ist optimiert: Berechnung mit optimierten Einstellungen im Ist-Zustand vor der Umsetzung von allfälligen weiteren Massnahmen. Planungszustand: Berechnung mit Einstellungen nach der Umsetzung der Massnahmen. / Volume moyen déversé par an. Volume moyen déversé par an selon des simulations pour de longs temps de retour (z > 10). Actuel optimizé: Calcul en mode optimal à l’état actuel avant la réalisation d’éventuelles mesures (Massnahmen). Prévu: Calcul après la réalisation d’éventuelles mesures (Massnahmen).';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN pump_characteristics  integer ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.pump_characteristics IS 'yyy_Bei speziellen Betriebsarten ist die Funktion separat zu dokumentieren und der Stammkarte beizulegen. / Bei speziellen Betriebsarten ist die Funktion separat zu dokumentieren und der Stammkarte beizulegen. / Pour de régime de fonctionnement spéciaux, cette fonction doit être documentée séparément et annexée à la fiche technique';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN pump_flow_max  decimal(9,3) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.pump_flow_max IS 'yyy_Maximaler Förderstrom der Pumpen (gesamtes Bauwerk). Tritt in der Regel bei der minimalen Förderhöhe ein. / Maximaler Förderstrom der Pumpen (gesamtes Bauwerk). Tritt in der Regel bei der minimalen Förderhöhe ein. / Débit de refoulement maximal de toutes les pompes de l’ouvrage. Survient normalement à la hauteur min de refoulement.';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN pump_flow_min  decimal(9,3) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.pump_flow_min IS 'yyy_Minimaler Förderstrom der Pumpen zusammen (gesamtes Bauwerk). Tritt in der Regel bei der maximalen Förderhöhe ein. / Minimaler Förderstrom der Pumpen zusammen (gesamtes Bauwerk). Tritt in der Regel bei der maximalen Förderhöhe ein. / Débit de refoulement minimal de toutes les pompes de l’ouvrage. Survient normalement à la hauteur max de refoulement.';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN q_discharge  decimal(9,3) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.q_discharge IS 'yyy_Qab gemäss GEP / Qab gemäss GEP / Qeff selon PGEE';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN qon  decimal(9,3) ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.qon IS 'yyy_Wassermenge, bei welcher der Überlauf anspringt / Wassermenge, bei welcher der Überlauf anspringt / Débit à partir duquel le déversoir devrait être fonctionnel';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN remark text;
 ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT hc_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.hydraulic_char_data.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN status  integer ;
COMMENT ON COLUMN tww_od.hydraulic_char_data.status IS 'yyy_Planungszustand der Hydraulischen Kennwerte (zwingend). Ueberlaufcharakteristik und Gesamteinzugsgebiet kann für verschiedene Stati gebildet werden und leitet sich aus dem Status der Hydr_Kennwerte ab. / Planungszustand der Hydraulischen Kennwerte (zwingend). Ueberlaufcharakteristik und Gesamteinzugsgebiet kann für verschiedene Stati gebildet werden und leitet sich aus dem Status der Hydr_Kennwerte ab. / Etat prévu des caractéristiques hydrauliques (obligatoire). Les caractéristiques de déversement et le bassin versant global peuvent être représentés à différents états et se laissent déduire à partir de l’attribut PARAMETRES_HYDR';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.hydraulic_char_data.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.hydraulic_char_data.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.hydraulic_char_data.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_hydraulic_char_data
BEFORE UPDATE OR INSERT ON
 tww_od.hydraulic_char_data
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.backflow_prevention
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_backflow_prevention_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_backflow_prevention_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.backflow_prevention ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','backflow_prevention');
COMMENT ON COLUMN tww_od.backflow_prevention.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.backflow_prevention ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.backflow_prevention.gross_costs IS 'Gross costs / Brutto Erstellungskosten / Coûts bruts de réalisation';
 ALTER TABLE tww_od.backflow_prevention ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.backflow_prevention.kind IS 'Ist keine Rückstausicherung vorhanden, wird keine Rueckstausicherung erfasst. /  Ist keine Rückstausicherung vorhanden, wird keine Rueckstausicherung erfasst / En absence de protection, laisser la composante vide';
 ALTER TABLE tww_od.backflow_prevention ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.backflow_prevention.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der Rückstausicherung voraussichtlich abläuft / Jahr in dem die Lebensdauer der Rückstausicherung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_backflow_prevention
BEFORE UPDATE OR INSERT ON
 tww_od.backflow_prevention
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.solids_retention
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_solids_retention_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_solids_retention_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.solids_retention ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','solids_retention');
COMMENT ON COLUMN tww_od.solids_retention.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.solids_retention ADD COLUMN dimensioning_value  decimal(9,3) ;
COMMENT ON COLUMN tww_od.solids_retention.dimensioning_value IS 'yyy_Wassermenge, Dimensionierungswert des Feststoffrückhaltes / Wassermenge, Dimensionierungswert des Feststoffrückhaltes / Volume, débit de dimensionnement';
 ALTER TABLE tww_od.solids_retention ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.solids_retention.gross_costs IS 'Gross costs of electromechanical equipment / Brutto Erstellungskosten der elektromechanischen Ausrüstung für den Feststoffrueckhalt / Coûts bruts des équipements électromécaniques';
 ALTER TABLE tww_od.solids_retention ADD COLUMN overflow_level  decimal(7,3) ;
COMMENT ON COLUMN tww_od.solids_retention.overflow_level IS 'Overflow level of solids retention in in m.a.sl. / Anspringkote Feststoffrückhalt in m.ü.M. / Cote du début du déversement de la retenue de matières solides en m.s.m.';
 ALTER TABLE tww_od.solids_retention ADD COLUMN type  integer ;
COMMENT ON COLUMN tww_od.solids_retention.type IS 'yyy_(Elektromechanische) Teile zum Feststoffrückhalt eines Bauwerks / (Elektromechanische) Teile zum Feststoffrückhalt eines Bauwerks / Eléments (électromécaniques) pour la retenue de matières solides d’un ouvrage';
 ALTER TABLE tww_od.solids_retention ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.solids_retention.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_solids_retention
BEFORE UPDATE OR INSERT ON
 tww_od.solids_retention
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.tank_cleaning
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_tank_cleaning_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_tank_cleaning_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.tank_cleaning ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','tank_cleaning');
COMMENT ON COLUMN tww_od.tank_cleaning.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.tank_cleaning ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.tank_cleaning.gross_costs IS 'Gross costs of electromechanical equipment of tank cleaning / Brutto Erstellungskosten der elektromechanischen Ausrüstung für die Beckenreinigung / Coûts bruts des équipements électromécaniques nettoyage de bassins';
 ALTER TABLE tww_od.tank_cleaning ADD COLUMN type  integer ;
COMMENT ON COLUMN tww_od.tank_cleaning.type IS '';
 ALTER TABLE tww_od.tank_cleaning ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.tank_cleaning.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_tank_cleaning
BEFORE UPDATE OR INSERT ON
 tww_od.tank_cleaning
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.tank_emptying
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_tank_emptying_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_tank_emptying_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.tank_emptying ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','tank_emptying');
COMMENT ON COLUMN tww_od.tank_emptying.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.tank_emptying ADD COLUMN flow  decimal(9,3) ;
COMMENT ON COLUMN tww_od.tank_emptying.flow IS 'yyy_Bei mehreren Pumpen / Schiebern muss die maximale Gesamtmenge erfasst werden. / Bei mehreren Pumpen / Schiebern muss die maximale Gesamtmenge erfasst werden. / Lors de présence de plusieurs pompes/vannes, indiquer le débit total.';
 ALTER TABLE tww_od.tank_emptying ADD COLUMN gross_costs  decimal(10,2) ;
COMMENT ON COLUMN tww_od.tank_emptying.gross_costs IS 'Gross costs of electromechanical equipment of tank emptying / Brutto Erstellungskosten der elektromechanischen Ausrüstung für die Beckenentleerung / Coûts bruts des équipements électromécaniques vidange de bassins';
 ALTER TABLE tww_od.tank_emptying ADD COLUMN type  integer ;
COMMENT ON COLUMN tww_od.tank_emptying.type IS '';
 ALTER TABLE tww_od.tank_emptying ADD COLUMN year_of_replacement  smallint ;
COMMENT ON COLUMN tww_od.tank_emptying.year_of_replacement IS 'yyy_Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Jahr in dem die Lebensdauer der elektromechanischen Ausrüstung voraussichtlich abläuft / Année pour laquelle on prévoit que la durée de vie de l''équipement soit écoulée';
-------
CREATE TRIGGER
update_last_modified_tank_emptying
BEFORE UPDATE OR INSERT ON
 tww_od.tank_emptying
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.structure_part");

-------
-------
CREATE TABLE tww_od.catchment_area_totals
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_catchment_area_totals_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_catchment_area_totals_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.catchment_area_totals ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','catchment_area_totals');
COMMENT ON COLUMN tww_od.catchment_area_totals.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN discharge_freight_nh4_n  integer ;
COMMENT ON COLUMN tww_od.catchment_area_totals.discharge_freight_nh4_n IS 'based on base module chapter 8.5. of directive "Abwasserbewirtschaftung bei Regenwetter" of VSA (2019)" / Gemäss Basismodul Kapitel 8.5 der Richtlinie "Abwasserentsorgung bei Regenwetter" des VSA (2019) / Selon module de base chapitre 8.5 directive "Gestion des eaux urbaines par temps de pluie" du VSA (2019)';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN discharge_proportion_nh4_n  decimal (5,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.discharge_proportion_nh4_n IS 'based on base module chapter 8.5. of directive "Abwasserbewirtschaftung bei Regenwetter" of VSA (2019)" / Gemäss Basismodul Kapitel 8.5 der Richtlinie "Abwasserentsorgung bei Regenwetter" des VSA (2019) / Selon module de base chapitre 8.5 directive "Gestion des eaux urbaines par temps de pluie" du VSA (2019)';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN identifier text;
 ALTER TABLE tww_od.catchment_area_totals ADD CONSTRAINT cm_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.catchment_area_totals.identifier IS '';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN population  integer ;
COMMENT ON COLUMN tww_od.catchment_area_totals.population IS 'Number of inhabitants (population) in the direct catchment area as informative value. Use  im direkten Einzugsgebiet als informativer Wert. Der massgebende Schmutzabwasseranfall ist im gleichnamigen entsprechenden Attribut anzugeben. / Anzahl Einwohner im direkten Einzugsgebiet als informativer Wert. Der massgebende Schmutzabwasseranfall ist im gleichnamigen entsprechenden Attribut anzugeben. / Nombre d''habitants dans le bassin versant direct, valeur à titre indicatif. Le débit d''eaux usées déterminant est spécifié dans l''attribut correspondant.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN population_dim  integer ;
COMMENT ON COLUMN tww_od.catchment_area_totals.population_dim IS 'yyy_Anzahl Einwohner im direkten Einzugsgebiet (Dimensionierung) als informativer Wert. Der massgebende Schmutzabwasseranfall ist im gleichnamigen entsprechenden Attribut anzugeben. / Anzahl Einwohner im direkten Einzugsgebiet (Dimensionierung) als informativer Wert. Der massgebende Schmutzabwasseranfall ist im gleichnamigen entsprechenden Attribut anzugeben. / Nombre d’habitants dans le bassin versant direct (dimensionnement), valeur indicative. Le débit des eaux usées doit être indiqué dans l’attribut du même nom.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN sewer_infiltration_water  decimal(9,3) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.sewer_infiltration_water IS 'yyy_Totaler Fremdwasseranfall beim Bauwerk inkl. aller obenliegenden Gebiete. Angabe Jahresmittelwert (24 Std.-Mittel) in l/s. / Totaler Fremdwasseranfall beim Bauwerk inkl. aller obenliegenden Gebiete. Angabe Jahresmittelwert (24 Std.-Mittel) in l/s. / Débit total d’eaux claires parasites à l’ouvrage, incluant les surfaces en amont. Moyenne annuelle sur 24 h en l/s.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN surface_area  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.surface_area IS 'yyy_Bruttofläche des direkten Einzugsgebietes im Misch- resp. Trennsystem gemäss Abbildung. / Bruttofläche des direkten Einzugsgebietes im Misch- resp. Trennsystem gemäss Abbildung. / Surface brute du bassin versant direct en système unitaire, resp. séparatif, selon illustration.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN surface_dim  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.surface_dim IS 'yyy_Bruttofläche des Einzugsgebiets Dimensionierung. Dieses Einzugsgebiet umfasst in der Regel alle obenliegenden Flächen des Regenbeckenüberlaufbeckens (inkl. denjenigen von Regenüberläufen, Pumpwerken, etc.) oder alle obenliegenden Flächen bis zum nächsten Regenüberlaufbecken. / Bruttofläche des Einzugsgebiets Dimensionierung. Dieses Einzugsgebiet umfasst in der Regel alle obenliegenden Flächen des Regenbeckenüberlaufbeckens (inkl. denjenigen von Regenüberläufen, Pumpwerken, etc.) oder alle obenliegenden Flächen bis zum nächsten Regenüberlaufbecken. / Surface brute du bassin versant de dimensionnement. Lors de la saisie des bassins d’eaux pluviales, il faut également indiquer le bassin versant de dimensionnement. Ce bassin versant contient toutes les surfaces en amont du BEP (incl. en amont les déversoirs d’orage, stations de pompage, etc.) jusqu''au prochain BEP.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN surface_imp  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.surface_imp IS 'yyy_Impermeable suface des direkten Einzugsgebiets im Misch- resp. Trennsystem gemäss Abbildung. Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser ange-schlossene befestigte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Befestigte Fläche des direkten Einzugsgebiets im Misch- resp. Trennsystem gemäss Abbildung. Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser ange-schlossene befestigte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Surface imperméabilisée du bassin versant  direct pour un système unitaire, resp. séparatif selon illustration. Dans un système séparatif, il faut saisir dans la fiche technique la surface réduite raccordée aux eaux usées. Au minimum une surface (imperméabilisée ou réduite) doit être indiquée.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN surface_imp_dim  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.surface_imp_dim IS 'yyy_Befestigte Fläche des Einzugsgebiets Dimensionierung im Misch- resp. Trennsystem (nur Regenüberlaufbecken). Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser angeschlossene befestigte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Befestigte Fläche des Einzugsgebiets Dimensionierung im Misch- resp. Trennsystem (nur Regenüberlaufbecken). Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser angeschlossene befestigte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Surface imperméabilisée du bassin versant de dimensionnement dans le système unitaire, resp. séparatif (BEP uniquement). Dans un système séparatif, il faut saisir dans la fiche technique la surface imperméabilisée raccordée aux eaux usées. Au minimum une surface (imperméabilisée ou réduite) doit être indiquée.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN surface_red  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.surface_red IS 'yyy_Reduzierte Fläche des direkten Einzugsgebiets im Misch- resp. Trennsystem gemäss Abbildung. Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser ange-schlossene reduzierte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Reduzierte Fläche des direkten Einzugsgebiets im Misch- resp. Trennsystem gemäss Abbildung. Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser ange-schlossene reduzierte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Surface réduite du bassin versant direct pour un système unitaire, resp. séparatif selon illustration. Dans un système séparatif, il faut saisir la surface réduite raccordée aux eaux usées. Au minimum une surface (imperméabilisée ou réduite) doit être indiquée.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN surface_red_dim  decimal(8,2) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.surface_red_dim IS 'yyy_Reduzierte Fläche des Einzugsgebiets Dimensionierung im Misch- resp. Trennsystem (nur Regenüberlaufbecken). Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser angeschlossene reduzierte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Reduzierte Fläche des Einzugsgebiets Dimensionierung im Misch- resp. Trennsystem (nur Regenüberlaufbecken). Im Trennsystem ist für die Stammkarte die an das Schmutzabwasser angeschlossene reduzierte Fläche anzugeben. Es muss mindestens eine Fläche (befestigt oder reduziert) angegeben werden. / Surface réduite du bassin versant de dimensionnement dans le système unitaire, resp. séparatif. Dans un système séparatif, il faut saisir la surface réduite raccordée aux eaux usées. Au minimum une surface (imperméabilisée ou réduite) doit être indiquée.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN waste_water_production  decimal(9,3) ;
COMMENT ON COLUMN tww_od.catchment_area_totals.waste_water_production IS 'Total waste water production at construction of all areas above. Yearly average (of 24h average) in l/s. / Totaler Schmutzabwasseranfall beim Bauwerk inkl. aller obenliegenden Gebiete. Angabe Jahresmittelwert (24 Std.-Mittel) in l/s. / Débit total d’eaux usées à l’ouvrage, incluant les surfaces en amont. Moyenne annuelle sur 24 h en l/s.';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.catchment_area_totals.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.catchment_area_totals.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.catchment_area_totals ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.catchment_area_totals.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_catchment_area_totals
BEFORE UPDATE OR INSERT ON
 tww_od.catchment_area_totals
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.param_ca_general
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_param_ca_general_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_param_ca_general_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.param_ca_general ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','param_ca_general');
COMMENT ON COLUMN tww_od.param_ca_general.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.param_ca_general ADD COLUMN dry_wheather_flow  decimal(9,3) ;
COMMENT ON COLUMN tww_od.param_ca_general.dry_wheather_flow IS 'Dry wheather flow / Débit temps sec';
 ALTER TABLE tww_od.param_ca_general ADD COLUMN flow_path_length  decimal(7,2) ;
COMMENT ON COLUMN tww_od.param_ca_general.flow_path_length IS 'Length of flow path / Fliessweglänge / longueur de la ligne d''écoulement';
 ALTER TABLE tww_od.param_ca_general ADD COLUMN flow_path_slope  smallint ;
COMMENT ON COLUMN tww_od.param_ca_general.flow_path_slope IS 'Slope of flow path [%o] / Fliessweggefälle [%o] / Pente de la ligne d''écoulement [%o]';
 ALTER TABLE tww_od.param_ca_general ADD COLUMN population_equivalent  integer ;
COMMENT ON COLUMN tww_od.param_ca_general.population_equivalent IS '';
 ALTER TABLE tww_od.param_ca_general ADD COLUMN surface_ca  decimal(8,2) ;
COMMENT ON COLUMN tww_od.param_ca_general.surface_ca IS 'yyy_Surface bassin versant MOUSE1 / Fläche des Einzugsgebietes für MOUSE1 / Surface bassin versant MOUSE1';
-------
CREATE TRIGGER
update_last_modified_param_ca_general
BEFORE UPDATE OR INSERT ON
 tww_od.param_ca_general
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.surface_runoff_parameters");

-------
-------
CREATE TABLE tww_od.param_ca_mouse1
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_param_ca_mouse1_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_param_ca_mouse1_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.param_ca_mouse1 ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','param_ca_mouse1');
COMMENT ON COLUMN tww_od.param_ca_mouse1.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.param_ca_mouse1 ADD COLUMN dry_wheather_flow  decimal(9,3) ;
COMMENT ON COLUMN tww_od.param_ca_mouse1.dry_wheather_flow IS 'Parameter for calculation of surface runoff for surface runoff modell A1 / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE';
 ALTER TABLE tww_od.param_ca_mouse1 ADD COLUMN flow_path_length  decimal(7,2) ;
COMMENT ON COLUMN tww_od.param_ca_mouse1.flow_path_length IS 'yyy_Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE';
 ALTER TABLE tww_od.param_ca_mouse1 ADD COLUMN flow_path_slope  smallint ;
COMMENT ON COLUMN tww_od.param_ca_mouse1.flow_path_slope IS 'yyy_Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE [%o] / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE [%o] / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE [%o]';
 ALTER TABLE tww_od.param_ca_mouse1 ADD COLUMN population_equivalent  integer ;
COMMENT ON COLUMN tww_od.param_ca_mouse1.population_equivalent IS '';
 ALTER TABLE tww_od.param_ca_mouse1 ADD COLUMN surface_ca_mouse  decimal(8,2) ;
COMMENT ON COLUMN tww_od.param_ca_mouse1.surface_ca_mouse IS 'yyy_Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Parameter zur Bestimmung des Oberflächenabflusses für das Oberflächenabflussmodell A1 von MOUSE / Paramètre pour calculer l''écoulement superficiel selon le modèle A1 de MOUSE';
 ALTER TABLE tww_od.param_ca_mouse1 ADD COLUMN usage text;
 ALTER TABLE tww_od.param_ca_mouse1 ADD CONSTRAINT pm_usage_length_max_50 CHECK(char_length(usage)<=50);
COMMENT ON COLUMN tww_od.param_ca_mouse1.usage IS 'Classification based on surface runoff modell MOUSE 2000/2001 / Klassifikation gemäss Oberflächenabflussmodell von MOUSE 2000/2001 / Classification selon le modèle surface de MOUSE 2000/2001';
-------
CREATE TRIGGER
update_last_modified_param_ca_mouse1
BEFORE UPDATE OR INSERT ON
 tww_od.param_ca_mouse1
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.surface_runoff_parameters");

-------
-------
CREATE TABLE tww_od.disposal
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_disposal_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_disposal_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.disposal ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','disposal');
COMMENT ON COLUMN tww_od.disposal.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.disposal ADD COLUMN disposal_interval_current  decimal(4,2) ;
COMMENT ON COLUMN tww_od.disposal.disposal_interval_current IS 'yyy_Abstände, in welchen das Bauwerk aktuell geleert wird (Jahre) / Abstände, in welchen das Bauwerk aktuell geleert wird (Jahre) / Fréquence à laquelle l''ouvrage subit actuellement une vidange (années)';
 ALTER TABLE tww_od.disposal ADD COLUMN disposal_interval_nominal  decimal(4,2) ;
COMMENT ON COLUMN tww_od.disposal.disposal_interval_nominal IS 'yyy_Abstände, in welchen das Bauwerk geleert werden sollte (Jahre); Vorgabe aus GEP / Abstände, in welchen das Bauwerk geleert werden sollte (Jahre); Vorgabe aus GEP / Fréquence à laquelle l''ouvrage devrait subir un vidange (années); exigence selon PGEE';
 ALTER TABLE tww_od.disposal ADD COLUMN disposal_place_current  integer ;
COMMENT ON COLUMN tww_od.disposal.disposal_place_current IS 'yyy_Ort der Schlammentsorgung im heutigen Zustand / Ort der Schlammentsorgung im heutigen Zustand / Lieu d''élimination des boues en état actuel';
 ALTER TABLE tww_od.disposal ADD COLUMN disposal_place_planned  integer ;
COMMENT ON COLUMN tww_od.disposal.disposal_place_planned IS 'yyy_Ort der Schlammentsorgung im Planungszustand (gemäss GEP) / Ort der Schlammentsorgung im Planungszustand (gemäss GEP) / Lieu d''élimination des boues en état planifié (selon PGEE)';
 ALTER TABLE tww_od.disposal ADD COLUMN volume_pit_without_drain  decimal(9,2) ;
COMMENT ON COLUMN tww_od.disposal.volume_pit_without_drain IS 'yyy_Abflusslose Grube: Stapelraum in m3 / Abflusslose Grube: Stapelraum in m3 / Fosse étanche: volume de stockage en m3';
 ALTER TABLE tww_od.disposal ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.disposal.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.disposal ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.disposal.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.disposal ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.disposal.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_disposal
BEFORE UPDATE OR INSERT ON
 tww_od.disposal
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.building_group
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_building_group_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_building_group_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.building_group ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','building_group');
COMMENT ON COLUMN tww_od.building_group.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.building_group ADD COLUMN camping_area  decimal(8,2) ;
COMMENT ON COLUMN tww_od.building_group.camping_area IS 'Camping: Area of camping in hectars / Camping: Fläche Campingplatz in ha / Camping: surface du camping en ha';
 ALTER TABLE tww_od.building_group ADD COLUMN camping_lodgings  smallint ;
COMMENT ON COLUMN tww_od.building_group.camping_lodgings IS 'Camping: Number of overnight stays per year / Camping: Anzahl Übernachtungen pro Jahr / Camping: nombre de nuitées par an';
 ALTER TABLE tww_od.building_group ADD COLUMN church_seats  smallint ;
COMMENT ON COLUMN tww_od.building_group.church_seats IS 'yyy_Kirche: Anzahl Sitzplätze (ohne Nebenräume) / Kirche: Anzahl Sitzplätze (ohne Nebenräume) / Eglise: nombre de places assises (sans pièces adjacentes)';
 ALTER TABLE tww_od.building_group ADD COLUMN connecting_obligation  integer ;
COMMENT ON COLUMN tww_od.building_group.connecting_obligation IS 'Defines whether the building must be connected to the public sewer system according to Art. 11 GschG and guidelines for wastewater disposal in rural areas. / Definiert, ob das Gebäude anschlusspflichtig an die öffentliche Kanalisation ist gemäss Art. 11 GschG und Leitfaden Abwasserentsorgung im ländlichen Raum / Définit si le bâtiment doit être raccordé aux égouts publics selon LEaux art. 11 et au guide VSA eaux usées en milieu rural.';
 ALTER TABLE tww_od.building_group ADD COLUMN connection_wwtp  integer ;
COMMENT ON COLUMN tww_od.building_group.connection_wwtp IS '';
 ALTER TABLE tww_od.building_group ADD COLUMN craft_employees  smallint ;
COMMENT ON COLUMN tww_od.building_group.craft_employees IS 'yyy_Verwaltungsgebäude, Geschäftshaus, Fabrik (ohne Industrieabwasser): Anzahl Beschäftigte / Verwaltungsgebäude, Geschäftshaus, Fabrik (ohne Industrieabwasser): Anzahl Beschäftigte / Entreprise (sans eaux usées industrielles): nombre d''employés';
 ALTER TABLE tww_od.building_group ADD COLUMN dorm_beds  smallint ;
COMMENT ON COLUMN tww_od.building_group.dorm_beds IS 'Dormatory number of beds / Schlafsaal: Anzahl Betten / Dortoir: nombre de lits';
 ALTER TABLE tww_od.building_group ADD COLUMN dorm_overnight_stays  smallint ;
COMMENT ON COLUMN tww_od.building_group.dorm_overnight_stays IS 'Dormatory overnight stays / Schlafsaal: Anzahl Übernachtungen pro Jahr / Dortoir: nombre de nuitées par an';
 ALTER TABLE tww_od.building_group ADD COLUMN drainage_map  integer ;
COMMENT ON COLUMN tww_od.building_group.drainage_map IS 'yyy_Angabe ob Pläne der Entwässerungsanlagen vorhanden / Angabe ob Pläne der Entwässerungsanlagen vorhanden / Indication si plans des installations d''assainissement existants';
 ALTER TABLE tww_od.building_group ADD COLUMN drinking_water_network  integer ;
COMMENT ON COLUMN tww_od.building_group.drinking_water_network IS 'yyy_Angabe ob Trinkwasseranschluss an öffentliches Netz vorhanden / Angabe ob Trinkwasseranschluss an öffentliches Netz vorhanden / Indication si raccordement au réseau public d''eau potable existant';
 ALTER TABLE tww_od.building_group ADD COLUMN drinking_water_others  integer ;
COMMENT ON COLUMN tww_od.building_group.drinking_water_others IS 'yyy_Andere Trinkwasserversorgung als Netzanschluss (Hauptversorgung oder zusätzlich zum Netzanschluss) / Andere Trinkwasserversorgung als Netzanschluss (Hauptversorgung oder zusätzlich zum Netzanschluss) / Autre alimentation en eau potable que raccordement au réseau (alimentation principale ou supplémentaire au raccordement au réseau)';
 ALTER TABLE tww_od.building_group ADD COLUMN electric_connection  integer ;
COMMENT ON COLUMN tww_od.building_group.electric_connection IS 'yyy_Angabe ob Anschluss an Stromversorgung vorhanden / Angabe ob Anschluss an Stromversorgung vorhanden / Indication si raccordement au réseau électrique existant';
 ALTER TABLE tww_od.building_group ADD COLUMN event_visitors  smallint ;
COMMENT ON COLUMN tww_od.building_group.event_visitors IS 'yyy_Veranstaltung: Anzahl Besucher / Maximale Anzahl Besucher pro Veranstaltung / Nombre maximum de visiteurs par manifestation';
 ALTER TABLE tww_od.building_group ADD COLUMN function  integer ;
COMMENT ON COLUMN tww_od.building_group.function IS 'Kind of building use / Art der Gebäudenutzung / Genre d''affectation des bâtiments';
 ALTER TABLE tww_od.building_group ADD COLUMN gym_area  decimal(8,2) ;
COMMENT ON COLUMN tww_od.building_group.gym_area IS 'yyy_Turnhalle: Hallenfläche in m2 / Turnhalle: Hallenfläche in m2 / Salle de gymnastique: surface de salle en m2';
 ALTER TABLE tww_od.building_group ADD COLUMN holiday_accomodation  smallint ;
COMMENT ON COLUMN tww_od.building_group.holiday_accomodation IS 'yyy_Ausschliesslich Feriennutzung: Anzahl Übernachtungen pro Jahr / Ausschliesslich Feriennutzung: Anzahl Übernachtungen pro Jahr / Uniquement vacances: nombre de nuitées par an';
 ALTER TABLE tww_od.building_group ADD COLUMN hospital_beds  smallint ;
COMMENT ON COLUMN tww_od.building_group.hospital_beds IS 'Hospital, Nursing home: Number of beds / Spital, Pflegeanstalt: Anzahl Betten / Hôpital, EMS: nombre de lits';
 ALTER TABLE tww_od.building_group ADD COLUMN hotel_beds  smallint ;
COMMENT ON COLUMN tww_od.building_group.hotel_beds IS 'Hotel: Number of beds / Hotel: Anzahl Betten / Hôtel: nombre de lits';
 ALTER TABLE tww_od.building_group ADD COLUMN hotel_overnight_stays  smallint ;
COMMENT ON COLUMN tww_od.building_group.hotel_overnight_stays IS 'Hotel: Number of overnight stays per year / Hotel: Anzahl Übernachtungen pro Jahr / Hôtel: nombre de nuitées par an';
 ALTER TABLE tww_od.building_group ADD COLUMN identifier text;
 ALTER TABLE tww_od.building_group ADD CONSTRAINT bg_identifier_length_max_20 CHECK(char_length(identifier)<=20);
COMMENT ON COLUMN tww_od.building_group.identifier IS '';
 ALTER TABLE tww_od.building_group ADD COLUMN movie_theater_seats  smallint ;
COMMENT ON COLUMN tww_od.building_group.movie_theater_seats IS 'Cinema: Number of seats / Kino: Anzahl Sitzplätze / Cinéma: nombre de places assises';
 ALTER TABLE tww_od.building_group ADD COLUMN other_usage_population_equivalent  integer ;
COMMENT ON COLUMN tww_od.building_group.other_usage_population_equivalent IS 'yyy_Einwohnergleichwert für andere Art der Gebäudenutzung / Einwohnergleichwert für andere Art der Gebäudenutzung / Equivalent-habitants d''autre genre d''affectation de bâtiment';
 ALTER TABLE tww_od.building_group ADD COLUMN other_usage_type text;
 ALTER TABLE tww_od.building_group ADD CONSTRAINT bg_other_usage_type_length_max_50 CHECK(char_length(other_usage_type)<=50);
COMMENT ON COLUMN tww_od.building_group.other_usage_type IS 'yyy_Beschreibung für andere Art der Gebäudenutzung / Beschreibung für andere Art der Gebäudenutzung / Description d''autre genre d''affectation de bâtiment';
 ALTER TABLE tww_od.building_group ADD COLUMN population_equivalent  integer ;
COMMENT ON COLUMN tww_od.building_group.population_equivalent IS 'Consists of the number of inhabitants (E) and population equivalents (EGW). See VSA guideline ALR population equivalents A03 / Setzt sich aus der Einwohnerzahl (E) und Einwohnergleichwerten (EGW) zusammen. Siehe VSA Leitfaden ALR Einwohnerwerte A03 / Consiste en un nombre d''habitants (E) et d''équivalents de population (EGW). Voir la directive de la VSA sur les équivalents population EMR A03';
 ALTER TABLE tww_od.building_group ADD COLUMN remark text;
 ALTER TABLE tww_od.building_group ADD CONSTRAINT bg_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.building_group.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.building_group ADD COLUMN renovation_date  timestamp without time zone ;
COMMENT ON COLUMN tww_od.building_group.renovation_date IS '';
 ALTER TABLE tww_od.building_group ADD COLUMN renovation_necessity  integer ;
COMMENT ON COLUMN tww_od.building_group.renovation_necessity IS '';
 ALTER TABLE tww_od.building_group ADD COLUMN restaurant_seats  smallint ;
COMMENT ON COLUMN tww_od.building_group.restaurant_seats IS 'yyy_Stark frequentierte Gaststätte, wie Autobahnraststätte, Berggasthaus, etc.: Anzahl Sitzplätze / Stark frequentierte Gaststätte, wie Autobahnraststätte, Berggasthaus, etc.: Anzahl Sitzplätze / Restaurant très fréquenté, tel que restoroute, restaurant de montage, etc. : nombre de places assises';
 ALTER TABLE tww_od.building_group ADD COLUMN restaurant_seats_hall_garden  smallint ;
COMMENT ON COLUMN tww_od.building_group.restaurant_seats_hall_garden IS 'yyy_Restaurant: Anzahl Sitzplätze Säle und Garten / Restaurant: Anzahl Sitzplätze Säle und Garten / Restaurant: nombre de places salles et terrasses';
 ALTER TABLE tww_od.building_group ADD COLUMN restaurant_seats_permanent  smallint ;
COMMENT ON COLUMN tww_od.building_group.restaurant_seats_permanent IS 'yyy_Restaurant: Anzahl Sitzplätze (ohne Säle und Garten) / Restaurant: Anzahl Sitzplätze (ohne Säle und Garten) / Restaurant: nombre de places sans salles et terrasses';
 ALTER TABLE tww_od.building_group ADD COLUMN restructuring_concept text;
 ALTER TABLE tww_od.building_group ADD CONSTRAINT bg_restructuring_concept_length_max_255 CHECK(char_length(restructuring_concept)<=255);
COMMENT ON COLUMN tww_od.building_group.restructuring_concept IS 'Summary of the concept according to the service offer (GEP sample specification) / Kurzfassung des Konzepts gemäss Leistung Offerte (GEP Musterpflichtenheft) / Version courte du concept en fonction de l''offre de service (Cahier des charges type du PGEE)';
 ALTER TABLE tww_od.building_group ADD COLUMN school_students  smallint ;
COMMENT ON COLUMN tww_od.building_group.school_students IS 'School: Number of pupils / Schule: Anzahl Schüler / Ecole: nombre d''élèves';
ALTER TABLE tww_od.building_group ADD COLUMN situation_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_building_group_situation_geometry ON tww_od.building_group USING gist (situation_geometry );
COMMENT ON COLUMN tww_od.building_group.situation_geometry IS 'Location of the building group (can be taken from data in the Eidg. Gebäude und Wohnungsregister BAU/GWR) / Lage der Gebäudegruppe (kann aus Daten Eidg. Gebäude und Wohnungsregister BAU/GWR übernommen werden) / Localisation du groupe de bâtiments (peut être repris des données du Registre fédéral des bâtiments et des logements (RegBL))';
 ALTER TABLE tww_od.building_group ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.building_group.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.building_group ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.building_group.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.building_group ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.building_group.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_building_group
BEFORE UPDATE OR INSERT ON
 tww_od.building_group
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.building_group_baugwr
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_building_group_baugwr_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_building_group_baugwr_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.building_group_baugwr ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','building_group_baugwr');
COMMENT ON COLUMN tww_od.building_group_baugwr.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.building_group_baugwr ADD COLUMN egid  integer ;
COMMENT ON COLUMN tww_od.building_group_baugwr.egid IS 'yyy_EGID aus BAU/GWR der zur Gebäudegruppe gehörigen Gebäude / EGID aus BAU/GWR der zur Gebäudegruppe gehörigen Gebäude / EGID de BAU/RegBL des bâtiments appartenant au groupe de bâtiments';
 ALTER TABLE tww_od.building_group_baugwr ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.building_group_baugwr.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.building_group_baugwr ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.building_group_baugwr.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.building_group_baugwr ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.building_group_baugwr.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_building_group_baugwr
BEFORE UPDATE OR INSERT ON
 tww_od.building_group_baugwr
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.farm
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_farm_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_farm_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.farm ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','farm');
COMMENT ON COLUMN tww_od.farm.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.farm ADD COLUMN agriculture_arable_surface  decimal(8,2) ;
COMMENT ON COLUMN tww_od.farm.agriculture_arable_surface IS 'Arable agricultural area in ha / Landwirtschaftliche Nutzfläche in ha / Surface agricole utile en ha';
 ALTER TABLE tww_od.farm ADD COLUMN cesspit_comment text;
 ALTER TABLE tww_od.farm ADD CONSTRAINT fa_cesspit_comment_length_max_100 CHECK(char_length(cesspit_comment)<=100);
COMMENT ON COLUMN tww_od.farm.cesspit_comment IS 'Further remarks cesspit volume / Weitere Anmerkungen zur Güllegrube / Remarques additionnel volume fosse à purin';
 ALTER TABLE tww_od.farm ADD COLUMN cesspit_volume  integer ;
COMMENT ON COLUMN tww_od.farm.cesspit_volume IS 'yyy_Klassifizierung, ob das Volumen (teilweise) in einem Fremdbetrieb in der gleichen oder einer anderen Gemeinde vorhanden ist / Klassifizierung, ob das Volumen (teilweise) in einem Fremdbetrieb in der gleichen oder einer anderen Gemeinde vorhanden ist / Classification, si le volume est disponible (même partiellement) dans une exploitation externe dans la même commune ou dans une autre commune';
 ALTER TABLE tww_od.farm ADD COLUMN cesspit_volume_current  decimal(9,2) ;
COMMENT ON COLUMN tww_od.farm.cesspit_volume_current IS 'yyy_Güllegrube: aktuell vorhandenes Volumen in m3 / Güllegrube: aktuell vorhandenes Volumen in m3 / Fosse à purin: volume actuel en m3';
 ALTER TABLE tww_od.farm ADD COLUMN cesspit_volume_nominal  decimal(9,2) ;
COMMENT ON COLUMN tww_od.farm.cesspit_volume_nominal IS 'yyy_Güllegrube: erforderliches Volumen in m3  (Sollzustand); Vorgabe aus GEP / Güllegrube: erforderliches Volumen in m3  (Sollzustand); Vorgabe aus GEP / Fosse à purin: volume requis en m3; exigence selon PGEE';
 ALTER TABLE tww_od.farm ADD COLUMN cesspit_volume_ww_treated  decimal(9,2) ;
COMMENT ON COLUMN tww_od.farm.cesspit_volume_ww_treated IS 'yyy_Güllegrube: erforderliches Volumen in m3, falls häusliches Abwasser separat behandelt würde / Güllegrube: erforderliches Volumen in m3, falls häusliches Abwasser separat behandelt würde / Fosse à purin: volume en m3 requis en cas de traitement séparé des eaux ménagères';
 ALTER TABLE tww_od.farm ADD COLUMN cesspit_year_of_approval  smallint ;
COMMENT ON COLUMN tww_od.farm.cesspit_year_of_approval IS 'yyy_Güllegrube: Bewilligungsjahr / Güllegrube: Bewilligungsjahr / Fosse à purin: année d''autorisation';
 ALTER TABLE tww_od.farm ADD COLUMN conformity  integer ;
COMMENT ON COLUMN tww_od.farm.conformity IS 'Conformity of Einrichtungen (Güllegrube, Mistplatz, etc.) / Konformität der Einrichtungen (Güllegrube, Mistplatz, etc.) / Conformité des installations (fosse à purin, fumière, etc.)';
 ALTER TABLE tww_od.farm ADD COLUMN continuance  integer ;
COMMENT ON COLUMN tww_od.farm.continuance IS 'yyy_Potentieller Fortbestand des Betriebs / Potentieller Fortbestand des Betriebs / Pérennité potentielle de l''exploitation';
 ALTER TABLE tww_od.farm ADD COLUMN continuance_comment text;
 ALTER TABLE tww_od.farm ADD CONSTRAINT fa_continuance_comment_length_max_80 CHECK(char_length(continuance_comment)<=80);
COMMENT ON COLUMN tww_od.farm.continuance_comment IS 'yyy_Bemerkungen zum Fortbestand des Betriebs / Bemerkungen zum Fortbestand des Betriebs / Remarques concernant la pérennité de l''exploitation';
 ALTER TABLE tww_od.farm ADD COLUMN dung_heap_area_current  decimal(8,2) ;
COMMENT ON COLUMN tww_od.farm.dung_heap_area_current IS 'Dung heap: currently available area in m2 / Mistplatz: aktuell vorhandene Fläche in m2 / Fumière: surface actuelle en m2';
 ALTER TABLE tww_od.farm ADD COLUMN dung_heap_area_nominal  decimal(8,2) ;
COMMENT ON COLUMN tww_od.farm.dung_heap_area_nominal IS 'dung heap: required area in m2 (target condition); specification from GEP / Mistplatz: erforderliche Fläche in m2 (Sollzustand); Vorgabe aus GEP / Fumière: surface requise en m2 ; exigence selon PGEE';
 ALTER TABLE tww_od.farm ADD COLUMN remark text;
 ALTER TABLE tww_od.farm ADD CONSTRAINT fa_remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.farm.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE tww_od.farm ADD COLUMN shepherds_hut_comment text;
 ALTER TABLE tww_od.farm ADD CONSTRAINT fa_shepherds_hut_comment_length_max_80 CHECK(char_length(shepherds_hut_comment)<=80);
COMMENT ON COLUMN tww_od.farm.shepherds_hut_comment IS 'yyy_Hirtenhütte: Bemerkung betreffend Abwasserproduktion / Hirtenhütte: Bemerkung betreffend Abwasserproduktion / Rural / remise: remarque concernant production d''eau usée';
 ALTER TABLE tww_od.farm ADD COLUMN shepherds_hut_population_equivalent  integer ;
COMMENT ON COLUMN tww_od.farm.shepherds_hut_population_equivalent IS 'yyy_Hirtenhütte: Einwohnergleichwert / Hirtenhütte: Einwohnergleichwert / Rural / remise: équivalent-habitants';
 ALTER TABLE tww_od.farm ADD COLUMN shepherds_hut_wastewater  integer ;
COMMENT ON COLUMN tww_od.farm.shepherds_hut_wastewater IS 'yyy_Hirtenhütte: Fällt häusliches Abwasser an? / Hirtenhütte: Fällt häusliches Abwasser an? / Rural / remise: production d''eau usée?';
 ALTER TABLE tww_od.farm ADD COLUMN stable_cattle  integer ;
COMMENT ON COLUMN tww_od.farm.stable_cattle IS 'yyy_Stall: Vieh vorhanden? / Stall: Vieh vorhanden? / Etable / écurie: bétail existant?';
 ALTER TABLE tww_od.farm ADD COLUMN stable_cattle_equivalent_other_cattle  decimal(8,2) ;
COMMENT ON COLUMN tww_od.farm.stable_cattle_equivalent_other_cattle IS 'yyy_Stall: Anzahl Tiere in Düngergrossvieheinheiten DGVE (Fremdvieh) fertiliser produced per livestock unit (FLU) / Stall: Anzahl Tiere in Düngergrossvieheinheiten DGVE (Fremdvieh) / Etable / écurie: nombre d''animaux exprimés en unité de gros bétail UGB (bétail "étranger")';
 ALTER TABLE tww_od.farm ADD COLUMN stable_cattle_equivalent_own_cattle  decimal(8,2) ;
COMMENT ON COLUMN tww_od.farm.stable_cattle_equivalent_own_cattle IS 'yyy_Stall: Anzahl Tiere in Düngergrossvieheinheiten DGVE (eigenes Vieh) fertiliser produced per livestock unit (FLU) / Stall: Anzahl Tiere in Düngergrossvieheinheiten DGVE (eigenes Vieh) / Etable / écurie: nombre d''animaux exprimés en unité de gros bétail UGB (propre bétail)';
 ALTER TABLE tww_od.farm ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.farm.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE tww_od.farm ADD COLUMN fk_dataowner varchar(16);
COMMENT ON COLUMN tww_od.farm.fk_dataowner IS 'Foreignkey to Metaattribute dataowner (as an organisation) - this is the person or body who is allowed to delete, change or maintain this object / Metaattribut Datenherr ist diejenige Person oder Stelle, die berechtigt ist, diesen Datensatz zu löschen, zu ändern bzw. zu verwalten / Maître des données gestionnaire de données, qui est la personne ou l''organisation autorisée pour gérer, modifier ou supprimer les données de cette table/classe';
 ALTER TABLE tww_od.farm ADD COLUMN fk_provider varchar(16);
COMMENT ON COLUMN tww_od.farm.fk_provider IS 'Foreignkey to Metaattribute provider (as an organisation) - this is the person or body who delivered the data / Metaattribut Datenlieferant ist diejenige Person oder Stelle, die die Daten geliefert hat / FOURNISSEUR DES DONNEES Organisation qui crée l’enregistrement de ces données ';
-------
CREATE TRIGGER
update_last_modified_farm
BEFORE UPDATE OR INSERT ON
 tww_od.farm
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.small_treatment_plant
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_small_treatment_plant_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_small_treatment_plant_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.small_treatment_plant ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','small_treatment_plant');
COMMENT ON COLUMN tww_od.small_treatment_plant.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.small_treatment_plant ADD COLUMN approval_number text;
 ALTER TABLE tww_od.small_treatment_plant ADD CONSTRAINT sm_approval_number_length_max_50 CHECK(char_length(approval_number)<=50);
COMMENT ON COLUMN tww_od.small_treatment_plant.approval_number IS 'yyy_Bewilligungsnummer der Aufsichtsbehörde / Bewilligungsnummer der Aufsichtsbehörde / Numéro d''autorisation de l''autorité de surveillance';
 ALTER TABLE tww_od.small_treatment_plant ADD COLUMN function  integer ;
COMMENT ON COLUMN tww_od.small_treatment_plant.function IS 'yyy_Art des Verfahrens / Art des Verfahrens / Genre de procédé';
 ALTER TABLE tww_od.small_treatment_plant ADD COLUMN installation_number  integer ;
COMMENT ON COLUMN tww_od.small_treatment_plant.installation_number IS 'yyy_ARA-Nummer gemäss BAFU / ARA-Nummer gemäss BAFU / Numéro de la STEP selon l''OFEV';
 ALTER TABLE tww_od.small_treatment_plant ADD COLUMN remote_monitoring  integer ;
COMMENT ON COLUMN tww_od.small_treatment_plant.remote_monitoring IS '';
-------
CREATE TRIGGER
update_last_modified_small_treatment_plant
BEFORE UPDATE OR INSERT ON
 tww_od.small_treatment_plant
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
-------
CREATE TABLE tww_od.drainless_toilet
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_drainless_toilet_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_drainless_toilet_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.drainless_toilet ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','drainless_toilet');
COMMENT ON COLUMN tww_od.drainless_toilet.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.drainless_toilet ADD COLUMN kind  integer ;
COMMENT ON COLUMN tww_od.drainless_toilet.kind IS '';
-------
CREATE TRIGGER
update_last_modified_drainless_toilet
BEFORE UPDATE OR INSERT ON
 tww_od.drainless_toilet
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified_parent("tww_od.wastewater_structure");

-------
------------ Relationships and Value Tables ----------- ;
ALTER TABLE tww_od.re_building_group_disposal ADD COLUMN fk_building_group varchar(16);
ALTER TABLE tww_od.re_building_group_disposal ADD CONSTRAINT rel_building_group_disposal_building_group FOREIGN KEY (fk_building_group) REFERENCES tww_od.building_group(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.re_building_group_disposal ADD COLUMN fk_disposal varchar(16);
ALTER TABLE tww_od.re_building_group_disposal ADD CONSTRAINT rel_building_group_disposal_disposal FOREIGN KEY (fk_disposal) REFERENCES tww_od.disposal(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.re_maintenance_event_wastewater_structure ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.re_maintenance_event_wastewater_structure ADD CONSTRAINT rel_maintenance_event_wastewater_structure_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tww_od.re_maintenance_event_wastewater_structure ADD COLUMN fk_maintenance_event varchar(16);
ALTER TABLE tww_od.re_maintenance_event_wastewater_structure ADD CONSTRAINT rel_maintenance_event_wastewater_structure_maintenance_event FOREIGN KEY (fk_maintenance_event) REFERENCES tww_od.maintenance_event(obj_id) ON UPDATE CASCADE ON DELETE cascade DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tww_od.txt_symbol ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.txt_symbol ADD CONSTRAINT rel_symbol_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE cascade;
CREATE TABLE tww_vl.symbol_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.symbol_plantype ADD CONSTRAINT pkey_tww_vl_symbol_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7874,7874,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7876,7876,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7877,7877,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7878,7878,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7875,7875,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.txt_symbol ADD CONSTRAINT fkey_vl_symbol_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.symbol_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.txt_text ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.txt_text ADD CONSTRAINT rel_text_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE cascade;
ALTER TABLE tww_od.txt_text ADD COLUMN fk_catchment_area varchar(16);
ALTER TABLE tww_od.txt_text ADD CONSTRAINT rel_text_catchment_area FOREIGN KEY (fk_catchment_area) REFERENCES tww_od.catchment_area(obj_id) ON DELETE cascade;
ALTER TABLE tww_od.txt_text ADD COLUMN fk_reach varchar(16);
ALTER TABLE tww_od.txt_text ADD CONSTRAINT rel_text_reach FOREIGN KEY (fk_reach) REFERENCES tww_od.reach(obj_id) ON DELETE cascade;
CREATE TABLE tww_vl.text_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.text_plantype ADD CONSTRAINT pkey_tww_vl_text_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.txt_text ADD CONSTRAINT fkey_vl_text_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.text_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.text_texthali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.text_texthali ADD CONSTRAINT pkey_tww_vl_text_texthali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.txt_text ADD CONSTRAINT fkey_vl_text_texthali FOREIGN KEY (texthali)
 REFERENCES tww_vl.text_texthali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.text_textvali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.text_textvali ADD CONSTRAINT pkey_tww_vl_text_textvali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.txt_text ADD CONSTRAINT fkey_vl_text_textvali FOREIGN KEY (textvali)
 REFERENCES tww_vl.text_textvali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.progression_alternative ADD COLUMN fk_reach varchar(16);
ALTER TABLE tww_od.progression_alternative ADD CONSTRAINT rel_progression_alternative_reach FOREIGN KEY (fk_reach) REFERENCES tww_od.reach(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.progression_alternative_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.progression_alternative_plantype ADD CONSTRAINT pkey_tww_vl_progression_alternative_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9282,9282,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9285,9285,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9286,9286,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9287,9287,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9284,9284,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.progression_alternative ADD CONSTRAINT fkey_vl_progression_alternative_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.progression_alternative_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.organisation_organisation_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.organisation_organisation_type ADD CONSTRAINT pkey_tww_vl_organisation_organisation_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8608,8608,'waste_water_association','Abwasserverband','association_epuration_eau', 'consorzio_depurazione', 'rrr_Abwasserverband', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8715,8715,'federation','Bund','federation', 'confederazione', 'rrr_Bund', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8604,8604,'municipality','Gemeinde','commune', 'comune', 'municipiul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9319,9319,'municipal_department','Gemeindeabteilung','departement_communal', 'dipartimento_comunale', 'departamentul_municipal', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8610,8610,'cooperative','Genossenschaft_Korporation','cooperative', 'cooperativa_corporazione', 'rrr_Genossenschaft_Korporation', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8605,8605,'canton','Kanton','canton', 'cantone', 'rrr_Kanton', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_organisation_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8606,8606,'private','Privat','prive', 'privato', 'privata', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.organisation ADD CONSTRAINT fkey_vl_organisation_organisation_type FOREIGN KEY (organisation_type)
 REFERENCES tww_vl.organisation_organisation_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.organisation_status () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.organisation_status ADD CONSTRAINT pkey_tww_vl_organisation_status_code PRIMARY KEY (code);
 INSERT INTO tww_vl.organisation_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9047,9047,'activ','aktiv','active', 'attivo', 'rrr_aktiv', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.organisation_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9048,9048,'gone','untergegangen','disparue', 'decaduta', 'rrr_untergegangen', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.organisation ADD CONSTRAINT fkey_vl_organisation_status FOREIGN KEY (status)
 REFERENCES tww_vl.organisation_status (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.measure ADD COLUMN fk_responsible_entity varchar(16);
ALTER TABLE tww_od.measure ADD CONSTRAINT rel_measure_responsible_entity FOREIGN KEY (fk_responsible_entity) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.measure ADD COLUMN fk_responsible_start varchar(16);
ALTER TABLE tww_od.measure ADD CONSTRAINT rel_measure_responsible_start FOREIGN KEY (fk_responsible_start) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.measure_category () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measure_category ADD CONSTRAINT pkey_tww_vl_measure_category_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8649,8649,'runoff_prevention_retention_infiltration','Abflussvermeidung_Retention_Versickerung','limitation_ecoulement_retention_infiltration', 'limitazione_deflusso_ritenzione_infiltrazione', 'rrr_Abflussvermeidung_Retention_Versickerung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4653,4653,'administrative_mesure','administrative_Massnahme','mesure_administrative', 'misura_amministrativa', 'rrr_administrative_Massnahme', 'G', 'G', 'G', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9144,9144,'WWDRA','ALR','EMR', 'smaltimento_acque_zone_rurali', 'rrr_ALR', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5036,5036,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4654,4654,'abolishment','Aufhebung','suppression', 'soppressione', '', 'G', 'G', 'G', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4657,4657,'datamanagement','Datenmanagement','gestion_des_donnees', 'gestione_dati', 'rrr_Datenmanagement', 'D', 'D', 'D', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8706,8706,'maintenance_replacement','Erhaltung_Erneuerung','maintenance_renouvellement', 'manutenzione_rinnovo', 'rrr_Erhaltung_Erneuerung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8648,8648,'maintenance_cleaning','Erhaltung_Reinigung','maintenance_nettoyage', 'manutenzione_pulizia', 'rrr_Erhaltung_Reinigung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8646,8646,'maintenance_renovation_repair','Erhaltung_Renovierung_Reparatur','maintenance_renovation_reparation', 'manutenzione_rinnovo_riparazione', 'rrr_Erhaltung_Renovierung_Reparatur', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8647,8647,'maintenance_unknown','Erhaltung_unbekannt','maintenance_inconnue', 'manutenzione_sconosciuto', 'rrr_Erhaltung_unbekannt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4659,4659,'sewer_infiltration_water_reduction','Fremdwasserreduktion','reduction_ecp', 'riduzione_acque_chiare', 'rrr_Fremdwasserreduktion', '', 'G', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8645,8645,'function_change','Funktionsaenderung','changement_de_fonction', 'modifica_funzione', 'rrr_Funktionsaenderung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4660,4660,'gwdp_elaboration','GEP_Bearbeitung','elaboration_PGEE', 'elaborazione_PGS', 'rrr_GEP_Bearbeitung', '', 'G', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4662,4662,'control_and_surveillance','Kontrolle_und_Ueberwachung','controle_et_surveillence', 'controllo_monitoraggio', 'rrr_Kontrolle_und_Ueberwachung', '', 'G', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8639,8639,'measures_in_water_body','Massnahme_im_Gewaesser','mesure_sur_cours_d_eau', 'intervento_in_corso_d_acqua', 'rrr_Massnahme_im_Gewaesser', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4666,4666,'network_extension','Netzerweiterung','extension_reseau', 'estensione_rete', 'rrr_Netzerweiterung', '', 'G', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8707,8707,'special_construction_customization','Sonderbauwerk_Anpassung','ouvrage_special_adaptation', 'manufatto_speciale_modifica', 'rrr_Sonderbauwerk_Anpassung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8705,8705,'special_construction_new_buildung','Sonderbauwerk_Neubau','ouvrage_special_nouvelle_construction', 'manufatto_speciale_nuova_costruzione', 'rrr_Sonderbauwerk_Neubau', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8650,8650,'incident_prevention','Stoerfallvorsorge','prevention_des_accidents_majeurs', 'prevenzione_incidenti_rilevanti', 'rrr_Stoerfallvorsorge', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_category (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4652,4652,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.measure ADD CONSTRAINT fkey_vl_measure_category FOREIGN KEY (category)
 REFERENCES tww_vl.measure_category (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.measure_priority () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measure_priority ADD CONSTRAINT pkey_tww_vl_measure_priority_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measure_priority (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4759,4759,'M0','M0','M0', 'M0', 'M0', 'M0', 'M0', 'M0', '', '', 'true');
 INSERT INTO tww_vl.measure_priority (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4760,4760,'M1','M1','M1', 'M1', 'M1', 'M1', 'M1', 'M1', '', '', 'true');
 INSERT INTO tww_vl.measure_priority (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4761,4761,'M2','M2','M2', 'M2', 'M2', 'M2', 'M2', 'M2', '', '', 'true');
 INSERT INTO tww_vl.measure_priority (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4762,4762,'M3','M3','M3', 'M3', 'M3', 'M3', 'M3', 'M3', '', '', 'true');
 INSERT INTO tww_vl.measure_priority (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4763,4763,'M4','M4','M4', 'M4', 'M4', 'M4', 'M4', 'M4', '', '', 'true');
 INSERT INTO tww_vl.measure_priority (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5584,5584,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measure ADD CONSTRAINT fkey_vl_measure_priority FOREIGN KEY (priority)
 REFERENCES tww_vl.measure_priority (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.measure_status () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measure_status ADD CONSTRAINT pkey_tww_vl_measure_status_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4764,4764,'completed','erledigt','regle', 'completato', 'rrr_erledigt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4765,4765,'in_preparation','in_Bearbeitung','en_preparation', 'in_allestimento', 'rrr_in_Bearbeitung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4766,4766,'pending','pendent','en_suspens', 'in_attesa', 'rrr_pendent', 'in_', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4767,4767,'suspended','sistiert','supprime', 'sospesa', 'rrr_sistiert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4768,4768,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measure ADD CONSTRAINT fkey_vl_measure_status FOREIGN KEY (status)
 REFERENCES tww_vl.measure_status (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.mutation_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.mutation_kind ADD CONSTRAINT pkey_tww_vl_mutation_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.mutation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5523,5523,'created','erstellt','cree', 'creato', 'creat', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mutation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5582,5582,'changed','geaendert','changee', 'modificato', 'modificat', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mutation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5583,5583,'deleted','geloescht','effacee', 'eliminata', 'eliminate', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.mutation ADD CONSTRAINT fkey_vl_mutation_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.mutation_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.waste_water_treatment_plant_operator_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.waste_water_treatment_plant_operator_type ADD CONSTRAINT pkey_tww_vl_waste_water_treatment_plant_operator_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8986,8986,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8978,8978,'idividual_municipality','Einzelgemeinde','commune_individuelle', 'zzz_Einzelgemeinde', 'rrr_Einzelgemeinde', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8981,8981,'intermunicipal_agency','Interkommunale_Anstalt','etablissement_intercommunal', 'zzz_Interkommunale_Anstalt', 'rrr_Interkommunale_Anstalt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8985,8985,'cantonal_administration','Kantonale_Verwaltung','administration_cantonale', 'zzz_Kantonale_Verwaltung', 'rrr_Kantonale_Verwaltung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8983,8983,'public_private_partnership','Oeffentlich_private_Partnerschaft','partenariat_de_droit_prive', 'zzz_Oeffentlich_private_Partnerschaft', 'rrr_Oeffentlich_private_Partnerschaft', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8982,8982,'public_law_stock_company','Oeffentlich_rechtliche_Aktiengesellschaft','societe_anonyme_de_droit_public', 'zzz_Oeffentlich_rechtliche_Aktiengesellschaft', 'rrr_Oeffentlich_rechtliche_Aktiengesellschaft', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8984,8984,'private_company','Privates_Unternehmen','entreprise_privee', 'zzz_Privates_Unternehmen', 'rrr_Privates_Unternehmen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8980,8980,'domicile_municipality','Sitzgemeinde','commune_d_implantation', 'zzz_Sitzgemeinde', 'rrr_Sitzgemeinde', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_plant_operator_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8979,8979,'special_purpose_association','Zweckverband','groupement', 'zzz_Zweckverband', 'rrr_Zweckverband', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.waste_water_treatment_plant ADD CONSTRAINT fkey_vl_waste_water_treatment_plant_operator_type FOREIGN KEY (operator_type)
 REFERENCES tww_vl.waste_water_treatment_plant_operator_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_owner varchar(16);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_owner FOREIGN KEY (fk_owner) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_operator varchar(16);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_operator FOREIGN KEY (fk_operator) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.wastewater_structure ADD COLUMN fk_main_cover varchar(16);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_wastewater_structure_main_cover FOREIGN KEY (fk_main_cover) REFERENCES tww_od.cover(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.wastewater_structure_accessibility () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_accessibility ADD CONSTRAINT pkey_tww_vl_wastewater_structure_accessibility_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3444,3444,'covered','ueberdeckt','couvert', 'coperto', 'capac', '', 'UED', 'COU', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3447,3447,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3446,3446,'inaccessible','unzugaenglich','inaccessible', 'non_accessibile', 'inaccesibil', '', 'UZG', 'NA', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_accessibility (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3445,3445,'accessible','zugaenglich','accessible', 'accessibile', 'accessibil', '', 'ZG', 'A', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_accessibility FOREIGN KEY (accessibility)
 REFERENCES tww_vl.wastewater_structure_accessibility (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_elevation_determination () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_elevation_determination ADD CONSTRAINT pkey_tww_vl_wastewater_structure_elevation_determination_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9321,9321,'accurate','genau','precise', 'precisa', 'precisa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9323,9323,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9322,9322,'inaccurate','ungenau','imprecise', 'impreciso', 'imprecisa', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_elevation_determination FOREIGN KEY (elevation_determination)
 REFERENCES tww_vl.wastewater_structure_elevation_determination (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_financing () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_financing ADD CONSTRAINT pkey_tww_vl_wastewater_structure_financing_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_financing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5510,5510,'public','oeffentlich','public', 'pubblico', 'publica', 'PU', 'OE', 'PU', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_financing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5511,5511,'private','privat','prive', 'privato', 'privata', 'PR', 'PR', 'PR', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_financing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5512,5512,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', 'U', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_financing FOREIGN KEY (financing)
 REFERENCES tww_vl.wastewater_structure_financing (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_renovation_necessity () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_renovation_necessity ADD CONSTRAINT pkey_tww_vl_wastewater_structure_renovation_necessity_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5370,5370,'urgent','dringend','urgente', 'urgente', 'urgent', 'UR', 'DR', 'UR', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5368,5368,'none','keiner','aucune', 'nessuno', 'niciuna', 'N', 'K', 'AN', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2,2,'short_term','kurzfristig','a_court_terme', 'breve_termine', 'termen_scurt', 'ST', 'KF', 'CT', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9295,9295,'long_term','langfristig','a_long_terme', 'lungo_termine', 'termen_lung', 'LT', 'LF', 'LT', 'LT', 'TL', 'true');
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3,3,'medium_term','mittelfristig','a_moyen_terme', 'medio_termine', 'termen_mediu', '', 'MF', 'MT', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5369,5369,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_renovation_necessity FOREIGN KEY (renovation_necessity)
 REFERENCES tww_vl.wastewater_structure_renovation_necessity (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_rv_construction_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_rv_construction_type ADD CONSTRAINT pkey_tww_vl_wastewater_structure_rv_construction_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4602,4602,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4603,4603,'field','Feld','dans_les_champs', 'campo_aperto', 'in_camp', 'FI', 'FE', 'FE', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4606,4606,'renovation_conduction_excavator','Sanierungsleitung_Bagger','conduite_d_assainissement_retro', 'canalizazzione_risanmento_scavatrice', 'conducte_excavate', 'RCE', 'SBA', 'CAR', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4605,4605,'renovation_conduction_ditch_cutter','Sanierungsleitung_Grabenfraese','conduite_d_assainissement_trancheuse', 'condotta_risanamento_scavafossi', 'conducta_taiere_sant', 'RCD', 'SGF', 'CAT', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4604,4604,'road','Strasse','sous_route', 'strada', 'sub_strada', 'ST', 'ST', 'ST', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_rv_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4601,4601,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_rv_construction_type FOREIGN KEY (rv_construction_type)
 REFERENCES tww_vl.wastewater_structure_rv_construction_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_status () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_status ADD CONSTRAINT pkey_tww_vl_wastewater_structure_status_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3633,3633,'inoperative','ausser_Betrieb','hors_service', 'fuori_servizio', 'rrr_ausser_Betrieb', 'NO', 'AB', 'H', 'FS', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8493,8493,'operational','in_Betrieb','en_service', 'in_funzione', 'functionala', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6530,6530,'operational.tentative','in_Betrieb.provisorisch','en_service.provisoire', 'in_funzione.provvisorio', 'functionala.provizoriu', 'T', 'T', 'P', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6533,6533,'operational.will_be_suspended','in_Betrieb.wird_aufgehoben','en_service.sera_supprime', 'in_funzione.da_eliminare', 'functionala.va_fi_eliminata', '', 'WA', 'SS', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6523,6523,'abanndoned.suspended_not_filled','tot.aufgehoben_nicht_verfuellt','abandonne.supprime_non_demoli', 'abbandonato.eliminato_non_demolito', 'abandonata.eliminare_necompletata', 'SN', 'AN', 'S', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6524,6524,'abanndoned.suspended_unknown','tot.aufgehoben_unbekannt','abandonne.supprime_inconnu', 'abbandonato.eliminato_sconosciuto', 'abandonata.demolare_necunoscuta', 'SU', 'AU', 'AI', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6532,6532,'abanndoned.filled','tot.verfuellt','abandonne.demoli', 'abbandonato.demolito', 'abandonata.eliminata', '', 'V', 'D', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3027,3027,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6526,6526,'other.calculation_alternative','weitere.Berechnungsvariante','autre.variante_de_calcul', 'altro.variante_calcolo', 'alta.varianta_calcul', 'CA', 'B', 'C', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7959,7959,'other.planned','weitere.geplant','autre.planifie', 'altro.previsto', 'rrr_weitere.geplant', '', 'G', 'PL', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6529,6529,'other.project','weitere.Projekt','autre.projet', 'altro.progetto', 'alta.proiect', '', 'N', 'PR', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_status FOREIGN KEY (status)
 REFERENCES tww_vl.wastewater_structure_status (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_structure_condition () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_structure_condition ADD CONSTRAINT pkey_tww_vl_wastewater_structure_structure_condition_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3037,3037,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3363,3363,'Z0','Z0','Z0', 'Z0', 'Z0', '', 'Z0', 'Z0', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3359,3359,'Z1','Z1','Z1', 'Z1', 'Z1', '', 'Z1', 'Z1', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3360,3360,'Z2','Z2','Z2', 'Z2', 'Z2', '', 'Z2', 'Z2', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3361,3361,'Z3','Z3','Z3', 'Z3', 'Z3', '', 'Z3', 'Z3', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_structure_condition (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3362,3362,'Z4','Z4','Z4', 'Z4', 'Z4', '', 'Z4', 'Z4', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT fkey_vl_wastewater_structure_structure_condition FOREIGN KEY (structure_condition)
 REFERENCES tww_vl.wastewater_structure_structure_condition (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.channel ADD CONSTRAINT oorel_od_channel_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.channel_bedding_encasement () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_bedding_encasement ADD CONSTRAINT pkey_tww_vl_channel_bedding_encasement_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5325,5325,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5332,5332,'in_soil','erdverlegt','enterre', 'zzz_erdverlegt', 'pamant', 'IS', 'EV', 'ET', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5328,5328,'in_channel_suspended','in_Kanal_aufgehaengt','suspendu_dans_le_canal', 'zzz_in_Kanal_aufgehaengt', 'suspendat_in_canal', '', 'IKA', 'CS', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5339,5339,'in_channel_concrete_casted','in_Kanal_einbetoniert','betonne_dans_le_canal', 'zzz_in_Kanal_einbetoniert', 'beton_in_canal', '', 'IKB', 'CB', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5331,5331,'in_walk_in_passage','in_Leitungsgang','en_galerie', 'zzz_in_Leitungsgang', 'galerie', '', 'ILG', 'G', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5337,5337,'in_jacking_pipe_concrete','in_Vortriebsrohr_Beton','en_pousse_tube_en_beton', 'zzz_in_Vortriebsrohr_Beton', 'beton_presstube', '', 'IVB', 'TB', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5336,5336,'in_jacking_pipe_steel','in_Vortriebsrohr_Stahl','en_pousse_tube_en_acier', 'zzz_in_Vortriebsrohr_Stahl', 'otel_presstube', '', 'IVS', 'TA', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5335,5335,'sand','Sand','sable', 'zzz_Sand', 'nisip', '', 'SA', 'SA', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5333,5333,'sia_type_1','SIA_Typ1','SIA_type_1', 'SIA_tippo1', 'SIA_tip_1', '', 'B1', 'B1', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5330,5330,'sia_type_2','SIA_Typ2','SIA_type_2', 'SIA_tippo2', 'SIA_tip_2', '', 'B2', 'B2', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5334,5334,'sia_type_3','SIA_Typ3','SIA_type_3', 'SIA_tippo3', 'SIA_tip_3', '', 'B3', 'B3', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5340,5340,'sia_type_4','SIA_Typ4','SIA_type_4', 'SIA_tippo4', 'SIA_tip_4', '', 'B4', 'B4', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5327,5327,'bed_plank','Sohlbrett','radier_en_planches', 'zzz_Sohlbrett', 'pat_de_pamant', '', 'SB', 'RP', '', '', 'true');
 INSERT INTO tww_vl.channel_bedding_encasement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5329,5329,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_bedding_encasement FOREIGN KEY (bedding_encasement)
 REFERENCES tww_vl.channel_bedding_encasement (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_connection_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_connection_type ADD CONSTRAINT pkey_tww_vl_channel_connection_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5341,5341,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (190,190,'electric_welded_sleeves','Elektroschweissmuffen','manchon_electrosoudable', 'zzz_Elektroschweissmuffen', 'manson_electrosudabil', 'EWS', 'EL', 'MSA', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (187,187,'flat_sleeves','Flachmuffen','manchon_plat', 'zzz_Flachmuffen', 'mason_plat', '', 'FM', 'MP', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (193,193,'flange','Flansch','bride', 'zzz_Flansch', 'flansa', '', 'FL', 'B', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (185,185,'bell_shaped_sleeves','Glockenmuffen','emboitement_a_cloche', 'zzz_Glockenmuffen', 'imbinare_tip_clopot', '', 'GL', 'EC', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (192,192,'coupling','Kupplung','raccord', 'zzz_Kupplung', 'racord', '', 'KU', 'R', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (194,194,'screwed_sleeves','Schraubmuffen','manchon_visse', 'zzz_Schraubmuffen', 'manson_insurubat', '', 'SC', 'MV', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (189,189,'butt_welded','spiegelgeschweisst','manchon_soude_au_miroir', 'zzz_spiegelgeschweisst', 'manson_sudat_cap_la_cap', '', 'SP', 'MSM', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (186,186,'beaked_sleeves','Spitzmuffen','emboitement_simple', 'zzz_Spitzmuffen', 'imbinare_simpla', '', 'SM', 'ES', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (191,191,'push_fit_sleeves','Steckmuffen','raccord_a_serrage', 'zzz_Steckmuffen', 'racord_de_prindere', '', 'ST', 'RS', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (188,188,'slip_on_sleeves','Ueberschiebmuffen','manchon_coulissant', 'zzz_Ueberschiebmuffen', 'manson_culisant', '', 'UE', 'MC', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3036,3036,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.channel_connection_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3666,3666,'jacking_pipe_coupling','Vortriebsrohrkupplung','raccord_pour_tube_de_pousse_tube', 'zzz_Vortriebsrohrkupplung', 'racord_prin_presstube', '', 'VK', 'RTD', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_connection_type FOREIGN KEY (connection_type)
 REFERENCES tww_vl.channel_connection_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_function_amelioration () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_function_amelioration ADD CONSTRAINT pkey_tww_vl_channel_function_amelioration_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4582,4582,'main_sewer','Hauptkanal','collecteur_principal', 'zzz_Hauptkanal', 'rrr_Hauptkanal', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4583,4583,'collector_sewer','Sammelkanal','collecteur', 'zzz_Sammelkanal', 'rrr_Sammelkanal', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4584,4584,'suction_pipe','Sauger','drains', 'zzz_Sauger', 'rrr_Sauger', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4585,4585,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_function_amelioration FOREIGN KEY (function_amelioration)
 REFERENCES tww_vl.channel_function_amelioration (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_function_hierarchic () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_function_hierarchic ADD CONSTRAINT pkey_tww_vl_channel_function_hierarchic_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5066,5066,'pwwf.other','PAA.andere','OAP.autre', 'IPS.altro', 'pwwf.alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5068,5068,'pwwf.water_bodies','PAA.Gewaesser','OAP.cours_d_eau', 'IPS.corpo_acqua', 'pwwf.curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5069,5069,'pwwf.main_drain','PAA.Hauptsammelkanal','OAP.collecteur_principal', 'IPS.collettore_principale', 'pwwf.colector_principal', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5070,5070,'pwwf.main_drain_regional','PAA.Hauptsammelkanal_regional','OAP.collecteur_principal_regional', 'IPS.collettore_principale_regionale', 'pwwf.colector_principal_regional', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5064,5064,'pwwf.residential_drainage','PAA.Liegenschaftsentwaesserung','OAP.evacuation_bien_fonds', 'IPS.samltimento_acque_fondi', 'pwwf.evacuare_rezidentiala', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5071,5071,'pwwf.collector_sewer','PAA.Sammelkanal','OAP.collecteur', 'IPS.collettore', 'pwwf.colector', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5062,5062,'pwwf.renovation_conduction','PAA.Sanierungsleitung','OAP.conduite_d_assainissement', 'IPS.condotta_risanamento', 'pwwf.conducta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5072,5072,'pwwf.road_drainage','PAA.Strassenentwaesserung','OAP.evacuation_des_eaux_de_routes', 'IPS.samltimento_acque_stradali', 'pwwf.rigola_drum', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5074,5074,'pwwf.unknown','PAA.unbekannt','OAP.inconnue', 'IPS.sconosciuto', 'pwwf.necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5067,5067,'swwf.other','SAA.andere','OAS.autre', 'ISS.altro', 'swwf.alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5065,5065,'swwf.residential_drainage','SAA.Liegenschaftsentwaesserung','OAS.evacuation_bien_fonds', 'ISS.smaltimento_acque_fondi', 'swwf.evacuare_rezidentiala', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5063,5063,'swwf.renovation_conduction','SAA.Sanierungsleitung','OAS.conduite_d_assainissement', 'ISS.condotta_risanamento', 'swwf.racord', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5073,5073,'swwf.road_drainage','SAA.Strassenentwaesserung','OAS.evacuation_des_eaux_de_routes', 'ISS.smaltimento_acque_strade', 'swwf.evacuare_ape_rigole', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hierarchic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5075,5075,'swwf.unknown','SAA.unbekannt','OAS.inconnue', 'ISS.sconosciuto', 'swwf.necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_function_hierarchic FOREIGN KEY (function_hierarchic)
 REFERENCES tww_vl.channel_function_hierarchic (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_function_hydraulic () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_function_hydraulic ADD CONSTRAINT pkey_tww_vl_channel_function_hydraulic_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5320,5320,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2546,2546,'drainage_transportation_pipe','Drainagetransportleitung','conduite_de_transport_pour_le_drainage', 'condotta_trasporto_drenaggi', 'conducta_transport_dren', 'DTP', 'DT', 'CTD', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (22,22,'restriction_pipe','Drosselleitung','conduite_d_etranglement', 'condotta_strozzamento', 'conducta_redusa', 'RP', 'DR', 'CE', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3610,3610,'inverted_syphon','Duekerleitung','siphon_inverse', 'canalizzazione_sifone', 'sifon_inversat', 'IS', 'DU', 'S', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (367,367,'gravity_pipe','Freispiegelleitung','conduite_a_ecoulement_gravitaire', 'canalizzazione_gravita', 'conducta_gravitationala', '', 'FL', 'CEL', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (23,23,'pump_pressure_pipe','Pumpendruckleitung','conduite_de_refoulement', 'canalizzazione_pompaggio', 'conducta_de_refulare', '', 'DL', 'CR', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (145,145,'seepage_water_drain','Sickerleitung','conduite_de_drainage', 'canalizzazione_drenaggio', 'conducta_drenaj', 'SP', 'SI', 'CI', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (21,21,'retention_pipe','Speicherleitung','conduite_de_retention', 'canalizzazione_ritenzione', 'conducta_de_retentie', '', 'SK', 'CA', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (144,144,'jetting_pipe','Spuelleitung','conduite_de_rincage', 'canalizzazione_spurgo', 'conducta_de_spalare', 'JP', 'SL', 'CC', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5321,5321,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3655,3655,'vacuum_pipe','Vakuumleitung','conduite_sous_vide', 'canalizzazione_sotto_vuoto', 'conducta_vidata', '', 'VL', 'CV', '', '', 'true');
 INSERT INTO tww_vl.channel_function_hydraulic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8662,8662,'infiltration_pipe','Versickerungsleitung','conduite_d_infiltration', 'condotta_d_infiltrazione', 'rrr_Versickerungsleitung', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_function_hydraulic FOREIGN KEY (function_hydraulic)
 REFERENCES tww_vl.channel_function_hydraulic (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_seepage () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_seepage ADD CONSTRAINT pkey_tww_vl_channel_seepage_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_seepage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4793,4793,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_seepage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4794,4794,'wood_chips','Holzschnitzel','copeaux_bois', 'zzz_Holzschnitzel', 'rrr_Holzschnitzel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_seepage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4795,4795,'soakaway_gravel','Sickerkies','gravier', 'zzz_Sickerkies', 'rrr_Sickerkies', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_seepage (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4796,4796,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_seepage FOREIGN KEY (seepage)
 REFERENCES tww_vl.channel_seepage (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_usage_current () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_usage_current ADD CONSTRAINT pkey_tww_vl_channel_usage_current_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5322,5322,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4518,4518,'creek_water','Bachwasser','eaux_cours_d_eau', 'acqua_corso_acqua', 'ape_curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4516,4516,'discharged_combined_wastewater','entlastetes_Mischabwasser','eaux_mixtes_deversees', 'acque_miste_scaricate', 'ape_mixte_deversate', 'DCW', 'EW', 'EUD', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4524,4524,'industrial_wastewater','Industrieabwasser','eaux_industrielles', 'acque_industriali', 'ape_industriale', '', 'CW', 'EUC', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4522,4522,'combined_wastewater','Mischabwasser','eaux_mixtes', 'acque_miste', 'ape_mixte', '', 'MW', 'EUM', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9023,9023,'surface_water','Niederschlagsabwasser','eaux_de_surface', 'acque_piovane', 'apa_meteorica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4514,4514,'clean_wastewater','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EUR', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4526,4526,'wastewater','Schmutzabwasser','eaux_usees', 'acque_luride', 'ape_uzate', '', 'SW', 'EU', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4571,4571,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_usage_current FOREIGN KEY (usage_current)
 REFERENCES tww_vl.channel_usage_current (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.channel_usage_planned () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.channel_usage_planned ADD CONSTRAINT pkey_tww_vl_channel_usage_planned_code PRIMARY KEY (code);
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5323,5323,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4519,4519,'creek_water','Bachwasser','eaux_cours_d_eau', 'acqua_corso_acqua', 'ape_curs_de_apa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4517,4517,'discharged_combined_wastewater','entlastetes_Mischabwasser','eaux_mixtes_deversees', 'acque_miste_scaricate', 'ape_mixte_deversate', 'DCW', 'EW', 'EUD', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4525,4525,'industrial_wastewater','Industrieabwasser','eaux_industrielles', 'acque_industriali', 'ape_industriale', '', 'CW', 'EUC', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4523,4523,'combined_wastewater','Mischabwasser','eaux_mixtes', 'acque_miste', 'ape_mixte', '', 'MW', 'EUM', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9022,9022,'surface_water','Niederschlagsabwasser','eaux_de_surface', 'acque_piovane', 'apa_meteorica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4515,4515,'clean_wastewater','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EUR', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4527,4527,'wastewater','Schmutzabwasser','eaux_usees', 'acque_luride', 'ape_uzate', '', 'SW', 'EU', '', '', 'true');
 INSERT INTO tww_vl.channel_usage_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4569,4569,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.channel ADD CONSTRAINT fkey_vl_channel_usage_planned FOREIGN KEY (usage_planned)
 REFERENCES tww_vl.channel_usage_planned (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.manhole ADD CONSTRAINT oorel_od_manhole_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.manhole_amphibian_exit () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.manhole_amphibian_exit ADD CONSTRAINT pkey_tww_vl_manhole_amphibian_exit_code PRIMARY KEY (code);
 INSERT INTO tww_vl.manhole_amphibian_exit (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9052,9052,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_amphibian_exit (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9053,9053,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_amphibian_exit (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9054,9054,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.manhole ADD CONSTRAINT fkey_vl_manhole_amphibian_exit FOREIGN KEY (amphibian_exit)
 REFERENCES tww_vl.manhole_amphibian_exit (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.manhole_function () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.manhole_function ADD CONSTRAINT pkey_tww_vl_manhole_function_code PRIMARY KEY (code);
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4532,4532,'drop_structure','Absturzbauwerk','ouvrage_de_chute', 'manufatto_caduta', 'instalatie_picurare', 'DS', 'AK', 'OC', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5344,5344,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4533,4533,'venting','Be_Entlueftung','aeration', 'zzz_Be_Entlueftung', 'aerisire', 'VE', 'BE', 'AE', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8702,8702,'treatment_plant','Behandlungsanlage','installation_traitement', 'installazione_di_trattamento', 'rrr_Behandlungsanlage', '', 'BH', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8995,8995,'floor_drain','Bodenablauf','ecoulement_de_sol', 'scarico_a_pavimento', 'rrr_Bodenablauf', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3267,3267,'rain_water_manhole','Dachwasserschacht','chambre_recolte_eaux_toitures', 'pozzetto_acque_tetti', 'camin_vizitare_apa_meteorica', 'RWM', 'DS', 'CRT', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3266,3266,'gully','Einlaufschacht','chambre_avec_grille_d_entree', 'pozzetto_griglia', 'gura_scurgere', 'G', 'ES', 'CG', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3472,3472,'drainage_channel','Entwaesserungsrinne','rigole_de_drainage', 'canaletta_drenaggio', 'rigola', '', 'ER', 'RD', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8828,8828,'drainage_channel_with_mud_bag','Entwaesserungsrinne_mit_Schlammsack','rigole_de_drainage_avec_depotoir', 'zzz_canaletta_drenaggio_mit_Schlammsack', 'rrr_Entwaesserungsrinne_mit_Schlammsack', '', 'ERS', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8601,8601,'grease_separator','Fettabscheider','separateur_de_graisse', 'separatore_di_grasso', 'rrr_Fettabscheider', '', 'FA', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (228,228,'rail_track_gully','Geleiseschacht','evacuation_des_eaux_des_voies_ferrees', 'zzz_Geleiseschacht', 'evacuare_ape_cale_ferata', '', 'GL', 'EVF', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8654,8654,'combined_manhole','Kombischacht','chambre_combine', 'pozzetto_doppio', 'rrr_Kombischacht', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8736,8736,'manhole','Kontroll_Einsteigschacht','chambre_de_visite_ou_d_inspection', 'pozzetto_di_ispezione', 'rrr_Kontroll_Einsteigschacht', '', 'KS', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (1008,1008,'oil_separator','Oelabscheider','separateur_d_hydrocarbures', 'separatore_olii', 'separator_hidrocarburi', 'OS', 'OA', 'SH', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4536,4536,'pump_station','Pumpwerk','station_de_pompage', 'stazione_pompaggio', 'statie_pompare', '', 'PW', 'SP', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5346,5346,'stormwater_overflow','Regenueberlauf','deversoir_d_orage', 'scaricatore_piena', 'preaplin', 'SO', 'RU', 'DO', 'SP', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2742,2742,'slurry_collector','Schlammsammler','depotoir', 'pozzetto_decantazione', 'colector_aluviuni', '', 'SA', 'D', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5347,5347,'floating_material_separator','Schwimmstoffabscheider','separateur_de_materiaux_flottants', 'separatore_materiali_galleggianti', 'separator_materie_flotanta', '', 'SW', 'SMF', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4537,4537,'jetting_manhole','Spuelschacht','chambre_de_chasse', 'pozzetto_lavaggio', 'camin_spalare', '', 'SS', 'CC', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4798,4798,'separating_structure','Trennbauwerk','ouvrage_de_repartition', 'camera_ripartizione', 'separator', '', 'TB', 'OR', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5345,5345,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.manhole_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8703,8703,'pretreatment_plant','Vorbehandlungsanlage','installation_de_pretraitement', 'zzz_Vorbehandlungsanlage', 'rrr_Vorbehandlungsanlage', 'yyy', 'VH', '', '', '', 'true');
 ALTER TABLE tww_od.manhole ADD CONSTRAINT fkey_vl_manhole_function FOREIGN KEY (function)
 REFERENCES tww_vl.manhole_function (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.manhole_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.manhole_material ADD CONSTRAINT pkey_tww_vl_manhole_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4540,4540,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4541,4541,'concrete','Beton','beton', 'calcestruzzo', 'beton', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4542,4542,'plastic','Kunststoff','matiere_plastique', 'zzz_Kunststoff', 'materie_plastica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4543,4543,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.manhole ADD CONSTRAINT fkey_vl_manhole_material FOREIGN KEY (material)
 REFERENCES tww_vl.manhole_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.manhole_possibility_intervention () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.manhole_possibility_intervention ADD CONSTRAINT pkey_tww_vl_manhole_possibility_intervention_code PRIMARY KEY (code);
 INSERT INTO tww_vl.manhole_possibility_intervention (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9056,9056,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_possibility_intervention (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9057,9057,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.manhole_possibility_intervention (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9058,9058,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.manhole ADD CONSTRAINT fkey_vl_manhole_possibility_intervention FOREIGN KEY (possibility_intervention)
 REFERENCES tww_vl.manhole_possibility_intervention (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.manhole_surface_inflow () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.manhole_surface_inflow ADD CONSTRAINT pkey_tww_vl_manhole_surface_inflow_code PRIMARY KEY (code);
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5342,5342,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2741,2741,'none','keiner','aucune', 'nessuno', 'niciunul', '', 'K', 'AN', '', '', 'true');
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2739,2739,'grid','Rost','grille_d_ecoulement', 'zzz_Rost', 'grilaj', '', 'R', 'G', '', '', 'true');
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5343,5343,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.manhole_surface_inflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2740,2740,'intake_from_side','Zulauf_seitlich','arrivee_laterale', 'zzz_Zulauf_seitlich', 'admisie_laterala', '', 'ZS', 'AL', '', '', 'true');
 ALTER TABLE tww_od.manhole ADD CONSTRAINT fkey_vl_manhole_surface_inflow FOREIGN KEY (surface_inflow)
 REFERENCES tww_vl.manhole_surface_inflow (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.discharge_point ADD CONSTRAINT oorel_od_discharge_point_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.discharge_point_relevance () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.discharge_point_relevance ADD CONSTRAINT pkey_tww_vl_discharge_point_relevance_code PRIMARY KEY (code);
 INSERT INTO tww_vl.discharge_point_relevance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5580,5580,'relevant_for_water_course','gewaesserrelevant','pertinent_pour_milieu_recepteur', 'zzz_gewaesserrelevant', 'relevanta_pentru_mediul_receptor', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.discharge_point_relevance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5581,5581,'non_relevant_for_water_course','nicht_gewaesserrelevant','insignifiant_pour_milieu_recepteur', 'zzz_nicht_gewaesserrelevant', 'nerelevanta_pentru_mediul_receptor', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.discharge_point ADD CONSTRAINT fkey_vl_discharge_point_relevance FOREIGN KEY (relevance)
 REFERENCES tww_vl.discharge_point_relevance (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.special_structure ADD CONSTRAINT oorel_od_special_structure_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.special_structure_amphibian_exit () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.special_structure_amphibian_exit ADD CONSTRAINT pkey_tww_vl_special_structure_amphibian_exit_code PRIMARY KEY (code);
 INSERT INTO tww_vl.special_structure_amphibian_exit (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9052,9052,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_amphibian_exit (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9053,9053,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_amphibian_exit (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9054,9054,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_amphibian_exit FOREIGN KEY (amphibian_exit)
 REFERENCES tww_vl.special_structure_amphibian_exit (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.special_structure_bypass () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.special_structure_bypass ADD CONSTRAINT pkey_tww_vl_special_structure_bypass_code PRIMARY KEY (code);
 INSERT INTO tww_vl.special_structure_bypass (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2682,2682,'inexistent','nicht_vorhanden','inexistant', 'non_presente', 'inexistent', '', 'NV', 'IE', '', '', 'true');
 INSERT INTO tww_vl.special_structure_bypass (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3055,3055,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.special_structure_bypass (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2681,2681,'existent','vorhanden','existant', 'presente', 'existent', '', 'V', 'E', '', '', 'true');
 ALTER TABLE tww_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_bypass FOREIGN KEY (bypass)
 REFERENCES tww_vl.special_structure_bypass (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.special_structure_emergency_overflow () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.special_structure_emergency_overflow ADD CONSTRAINT pkey_tww_vl_special_structure_emergency_overflow_code PRIMARY KEY (code);
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5866,5866,'other','andere','autres', 'altro', 'altele', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9075,9075,'in_water_body','in_Gewaesser','dans_cours_d_eau', 'in_corso_d_acqua', 'in_curs_apa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9077,9077,'in_combined_waste_water_drain','in_Mischabwasserkanalisation','dans_canalisation_eaux_mixtes', 'in_canalizzazione_acque_miste', 'in_canalizare_ape_mixte', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9078,9078,'in_rain_waste_water_drain','in_Regenabwasserkanalisation','dans_canalisation_eaux_pluviales', 'in_canalizzazione_acque_meteoriche', 'in_canalizare_apa_meteorica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9079,9079,'in_waste_water_drain','in_Schmutzabwasserkanalisation','dans_canalisation_eaux_usees', 'in_canalizzazione_acque_luride', 'in_canalizare_apa_uzata', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5878,5878,'none','keiner','aucun', 'nessuno', 'niciunul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9076,9076,'surface_discharge','oberflaechlich_ausmuendend','deversement_en_surface', 'con_sbocco_superficiale', 'deversare_la_suprafata', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5867,5867,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_emergency_overflow FOREIGN KEY (emergency_overflow)
 REFERENCES tww_vl.special_structure_emergency_overflow (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.special_structure_function () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.special_structure_function ADD CONSTRAINT pkey_tww_vl_special_structure_function_code PRIMARY KEY (code);
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6397,6397,'pit_without_drain','abflussloseGrube','fosse_etanche', 'fossa_senza_scarico', 'bazin_vidanjabil', '', 'AG', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (245,245,'drop_structure','Absturzbauwerk','ouvrage_de_chute', 'manufatto_caduta', 'instalatie_picurare', 'DS', 'AK', 'OC', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6398,6398,'hydrolizing_tank','Abwasserfaulraum','fosse_digestive', 'camera_fermentazione', 'fosa_hidroliza', '', 'AF', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5371,5371,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (386,386,'venting','Be_Entlueftung','aeration', 'zzz_Be_Entlueftung', 'aerisire', 'VE', 'BE', 'AE', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8704,8704,'treatment_plant','Behandlungsanlage','installation_traitement', 'installazione_di_trattamento', 'rrr_Behandlungsanlage', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3234,3234,'inverse_syphon_chamber','Duekerkammer','chambre_avec_siphon_inverse', 'camera_sifone', 'instalatie_cu_sifon_inversat', 'ISC', 'DK', 'SI', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5091,5091,'syphon_head','Duekeroberhaupt','entree_de_siphon', 'zzz_Duekeroberhaupt', 'cap_sifon', 'SH', 'DO', 'ESI', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6399,6399,'septic_tank_two_chambers','Faulgrube','fosse_septique_2_compartiments', 'zzz_Faulgrube', 'fosa_septica_2_compartimente', '', 'FG', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8600,8600,'grease_separator','Fettabscheider','separateur_de_graisse', 'separatore_di_grasso', 'rrr_Fettabscheider', '', 'FA', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3348,3348,'terrain_depression','Gelaendemulde','depression_de_terrain', 'zzz_Gelaendemulde', 'depresiune_teren', '', 'GM', 'DT', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (336,336,'bedload_trap','Geschiebefang','depotoir_pour_alluvions', 'camera_ritenuta', 'colector_aluviuni', '', 'GF', 'DA', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5494,5494,'cesspit','Guellegrube','fosse_a_purin', 'fossa_liquame', 'hazna', '', 'JG', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8657,8657,'emergency_basin','Havariebecken','bassin_d_avarie', 'bacino_avaria', 'rrr_Havariebecken', '', 'HB', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6478,6478,'septic_tank','Klaergrube','fosse_septique', 'fossa_settica', 'fosa_septica', '', 'KG', 'FD', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9302,9302,'combined_manhole','Kombischacht','chambre_combine', 'pozzetto_doppio', 'rrr_Kombischacht', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8739,8739,'manhole','Kontroll_Einsteigschacht','chambre_de_visite_ou_d_inspection', 'pozzetto_di_ispezione', 'rrr_Kontroll_Einsteigschacht', '', 'KS', 'RV', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2768,2768,'oil_separator','Oelabscheider','separateur_d_hydrocarbures', 'separatore_olii', 'separator_hidrocarburi', '', 'OA', 'SH', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (246,246,'pump_station','Pumpwerk','station_de_pompage', 'stazione_pompaggio', 'statie_pompare', '', 'PW', 'SP', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3673,3673,'stormwater_tank_with_overflow','Regenbecken_Durchlaufbecken','BEP_decantation', 'bacino_chiarificazione', 'bazin_retentie_apa_meteorica_cu_preaplin', '', 'DB', 'BDE', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3674,3674,'stormwater_tank_retaining_first_flush','Regenbecken_Fangbecken','BEP_retention', 'bacino_accumulo', 'bazin_retentie_apa_meteorica_prima_spalare', '', 'FB', 'BRE', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5574,5574,'stormwater_retaining_channel','Regenbecken_Fangkanal','BEP_canal_retention', 'canale_accumulo', 'bazin_retentie', 'TRE', 'FK', 'BCR', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3675,3675,'stormwater_sedimentation_tank','Regenbecken_Regenklaerbecken','BEP_clarification', 'bacino_decantazione_acque_meteoriche', 'bazin_decantare', '', 'RKB', 'BCL', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3676,3676,'stormwater_retention_tank','Regenbecken_Regenrueckhaltebecken','BEP_accumulation', 'bacino_ritenzione', 'bazin_retentie_apa_meteorica', '', 'RRB', 'BAC', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5575,5575,'stormwater_retention_channel','Regenbecken_Regenrueckhaltekanal','BEP_canal_accumulation', 'canale_ritenzione', 'canal_retentie_apa_meteorica', 'TRC', 'RRK', 'BCA', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5576,5576,'stormwater_storage_channel','Regenbecken_Stauraumkanal','BEP_canal_stockage', 'canale_stoccaggio', 'bazin_stocare', 'TSC', 'SRK', 'BCS', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3677,3677,'stormwater_composite_tank','Regenbecken_Verbundbecken','BEP_combine', 'bacino_combinato', 'rrr_Regenbecken_Verbundbecken', '', 'VB', 'BCO', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5372,5372,'stormwater_overflow','Regenueberlauf','deversoir_d_orage', 'scaricatore_piena', 'preaplin', '', 'RU', 'DO', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5373,5373,'floating_material_separator','Schwimmstoffabscheider','separateur_de_materiaux_flottants', 'separatore_materiali_galleggianti', 'separator_materie_flotanta', '', 'SW', 'SMF', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (383,383,'side_access','seitlicherZugang','acces_lateral', 'accesso_laterale', 'acces_lateral', '', 'SZ', 'AL', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (227,227,'jetting_manhole','Spuelschacht','chambre_de_chasse', 'pozzetto_lavaggio', 'camin_spalare', '', 'SS', 'CC', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4799,4799,'separating_structure','Trennbauwerk','ouvrage_de_repartition', 'camera_ripartizione', 'separator', '', 'TS', 'OR', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3008,3008,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9089,9089,'pretreatment_plant','Vorbehandlungsanlage','installation_de_pretraitement', 'zzz_Vorbehandlungsanlage', 'rrr_Vorbehandlungsanlage', '', 'VH', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2745,2745,'vortex_manhole','Wirbelfallschacht','chambre_de_chute_a_vortex', 'camera_caduta_vortice', 'instalatie_picurare_cu_vortex', '', 'WF', 'CT', '', '', 'true');
 ALTER TABLE tww_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_function FOREIGN KEY (function)
 REFERENCES tww_vl.special_structure_function (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.special_structure_possibility_intervention () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.special_structure_possibility_intervention ADD CONSTRAINT pkey_tww_vl_special_structure_possibility_intervention_code PRIMARY KEY (code);
 INSERT INTO tww_vl.special_structure_possibility_intervention (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9056,9056,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_possibility_intervention (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9057,9057,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.special_structure_possibility_intervention (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9058,9058,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_possibility_intervention FOREIGN KEY (possibility_intervention)
 REFERENCES tww_vl.special_structure_possibility_intervention (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.special_structure_stormwater_tank_arrangement () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.special_structure_stormwater_tank_arrangement ADD CONSTRAINT pkey_tww_vl_special_structure_stormwater_tank_arrangement_code PRIMARY KEY (code);
 INSERT INTO tww_vl.special_structure_stormwater_tank_arrangement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4608,4608,'main_connection','Hauptschluss','en_serie', 'in_serie', 'conectare_directa', '', 'HS', 'CD', '', '', 'true');
 INSERT INTO tww_vl.special_structure_stormwater_tank_arrangement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4609,4609,'side_connection','Nebenschluss','en_parallele', 'in_parallelo', 'conectare_laterala', '', 'NS', 'CL', '', '', 'true');
 INSERT INTO tww_vl.special_structure_stormwater_tank_arrangement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4610,4610,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.special_structure ADD CONSTRAINT fkey_vl_special_structure_stormwater_tank_arrangement FOREIGN KEY (stormwater_tank_arrangement)
 REFERENCES tww_vl.special_structure_stormwater_tank_arrangement (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT oorel_od_infiltration_installation_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.infiltration_installation_defects () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_defects ADD CONSTRAINT pkey_tww_vl_infiltration_installation_defects_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_defects (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5361,5361,'none','keine','aucunes', 'nessuno', 'inexistente', '', 'K', 'AN', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_defects (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3276,3276,'marginal','unwesentliche','modestes', 'zzz_unwesentliche', 'modeste', '', 'UW', 'MI', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_defects (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3275,3275,'substantial','wesentliche','importantes', 'zzz_wesentliche', 'importante', '', 'W', 'MA', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_defects FOREIGN KEY (defects)
 REFERENCES tww_vl.infiltration_installation_defects (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_emergency_overflow () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_emergency_overflow ADD CONSTRAINT pkey_tww_vl_infiltration_installation_emergency_overflow_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9069,9069,'other','andere','autre', 'altro', 'rrr_andere', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9074,9074,'in_water_body','in_Gewaesser','dans_cours_d_eau', 'zzz_in_Gewaesser', 'in_curs_apa', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9070,9070,'in_combined_waste_water_drain','in_Mischabwasserkanalisation','dans_canalisation_eaux_mixtes', 'in_canalizzazione_acque_miste', 'in_canalizare_ape_mixte', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9072,9072,'in_rain_waste_water_drain','in_Regenabwasserkanalisation','dans_canalisation_eaux_pluviales', 'in_canalizzazione_acque_meteoriche', 'in_canalizare_apa_meteorica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9073,9073,'in_waste_water_drain','in_Schmutzabwasserkanalisation','dans_canalisation_eaux_usees', 'in_canalizzazione_acque_luride', 'in_canalizare_apa_uzata', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3303,3303,'none','keiner','aucun', 'nessuno', 'inexistent', '', 'K', 'AN', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9071,9071,'surface_discharge','oberflaechlich_ausmuendend','deversement_en_surface', 'zzz_oberflaechlich_ausmuendend', 'deversare_la_suprafata', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_emergency_overflow (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3308,3308,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_emergency_overflow FOREIGN KEY (emergency_overflow)
 REFERENCES tww_vl.infiltration_installation_emergency_overflow (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_filling_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_filling_material ADD CONSTRAINT pkey_tww_vl_infiltration_installation_filling_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4785,4785,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4786,4786,'wood_chips','Holzschnitzel','copeaux_bois', 'zzz_Holzschnitzel', 'rrr_Holzschnitzel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4787,4787,'soakaway_gravel','Sickerkies','gravier', 'zzz_Sickerkies', 'rrr_Sickerkies', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_filling_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4788,4788,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_filling_material FOREIGN KEY (filling_material)
 REFERENCES tww_vl.infiltration_installation_filling_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_kind ADD CONSTRAINT pkey_tww_vl_infiltration_installation_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3282,3282,'with_soil_passage','andere_mit_Bodenpassage','autre_avec_passage_a_travers_sol', 'zzz_altro_mit_Bodenpassage', 'altul_cu_traversare_sol', 'WSP', 'AMB', 'APC', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3285,3285,'without_soil_passage','andere_ohne_Bodenpassage','autre_sans_passage_a_travers_sol', 'zzz_altro_ohne_Bodenpassage', 'altul_fara_traversare_sol', 'WOP', 'AOB', 'ASC', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3279,3279,'surface_infiltration','Flaechenfoermige_Versickerung','infiltration_superficielle_sur_place', 'zzz_Flaechenfoermige_Versickerung', 'infilitratie_de_suprafata', '', 'FV', 'IS', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (277,277,'gravel_formation','Kieskoerper','corps_de_gravier', 'zzz_Kieskoerper', 'formatiune_de_pietris', '', 'KK', 'VG', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3284,3284,'combination_manhole_pipe','Kombination_Schacht_Strang','combinaison_puits_bande', 'zzz_Kombination_Schacht_Strang', 'combinatie_put_conducta', '', 'KOM', 'CPT', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3281,3281,'swale_french_drain_infiltration','MuldenRigolenversickerung','cuvettes_rigoles_filtrantes', 'zzz_MuldenRigolenversickerung', 'cuve_rigole_filtrante', '', 'MRV', 'ICR', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3087,3087,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3280,3280,'percolation_over_the_shoulder','Versickerung_ueber_die_Schulter','infiltration_par_les_bas_cotes', 'zzz_Versickerung_ueber_die_Schulter', 'infilitratie_pe_la_cote_joase', '', 'VUS', 'IDB', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (276,276,'infiltration_basin','Versickerungsbecken','bassin_d_infiltration', 'zzz_Versickerungsbecken', 'bazin_infiltrare', '', 'VB', 'BI', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (278,278,'adsorbing_well','Versickerungsschacht','puits_d_infiltration', 'zzz_Versickerungsschacht', 'put_de_inflitrare', '', 'VS', 'PI', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3283,3283,'infiltration_pipe_sections_gallery','Versickerungsstrang_Galerie','bande_infiltration_galerie', 'zzz_Versickerungsstrang_Galerie', 'conducta_infiltrare_galerie', '', 'VG', 'TIG', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.infiltration_installation_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_labeling () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_labeling ADD CONSTRAINT pkey_tww_vl_infiltration_installation_labeling_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_labeling (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5362,5362,'labeled','beschriftet','signalee', 'zzz_beschriftet', 'marcat', 'L', 'BS', 'SI', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_labeling (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5363,5363,'not_labeled','nichtbeschriftet','non_signalee', 'zzz_nichtbeschriftet', 'nemarcat', '', 'NBS', 'NSI', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_labeling (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5364,5364,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_labeling FOREIGN KEY (labeling)
 REFERENCES tww_vl.infiltration_installation_labeling (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_seepage_utilization () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_seepage_utilization ADD CONSTRAINT pkey_tww_vl_infiltration_installation_seepage_utilization_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_seepage_utilization (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9024,9024,'surface_water','Niederschlagsabwasser','eaux_de_surface', 'acque_piovane', 'apa_meteorica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_seepage_utilization (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (273,273,'clean_water','Reinabwasser','eaux_claires', 'acque_chiare', 'ape_conventional_curate', '', 'KW', 'EC', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_seepage_utilization (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5359,5359,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_seepage_utilization FOREIGN KEY (seepage_utilization)
 REFERENCES tww_vl.infiltration_installation_seepage_utilization (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_vehicle_access () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_vehicle_access ADD CONSTRAINT pkey_tww_vl_infiltration_installation_vehicle_access_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_vehicle_access (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3289,3289,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_vehicle_access (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3288,3288,'inaccessible','unzugaenglich','inaccessible', 'non_accessibile', 'neaccesibil', '', 'ZU', 'IAC', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_vehicle_access (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3287,3287,'accessible','zugaenglich','accessible', 'accessibile', 'accessibil', '', 'Z', 'AC', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_vehicle_access FOREIGN KEY (vehicle_access)
 REFERENCES tww_vl.infiltration_installation_vehicle_access (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.infiltration_installation_watertightness () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_installation_watertightness ADD CONSTRAINT pkey_tww_vl_infiltration_installation_watertightness_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_installation_watertightness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3295,3295,'not_watertight','nichtwasserdicht','non_etanche', 'zzz_nichtwasserdicht', 'neetans', '', 'NWD', 'NE', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_watertightness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5360,5360,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.infiltration_installation_watertightness (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3294,3294,'watertight','wasserdicht','etanche', 'zzz_wasserdicht', 'etans', '', 'WD', 'E', '', '', 'true');
 ALTER TABLE tww_od.infiltration_installation ADD CONSTRAINT fkey_vl_infiltration_installation_watertightness FOREIGN KEY (watertightness)
 REFERENCES tww_vl.infiltration_installation_watertightness (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.wwtp_structure ADD COLUMN fk_waste_water_treatment_plant varchar(16);
ALTER TABLE tww_od.wwtp_structure ADD CONSTRAINT rel_wwtp_structure_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES tww_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.wwtp_structure ADD CONSTRAINT oorel_od_wwtp_structure_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.wwtp_structure_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wwtp_structure_kind ADD CONSTRAINT pkey_tww_vl_wwtp_structure_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (331,331,'sedimentation_basin','Absetzbecken','bassin_de_decantation', 'zzz_Absetzbecken', 'rrr_Absetzbecken', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2974,2974,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (327,327,'aeration_tank','Belebtschlammbecken','bassin_a_boues_activees', 'zzz_Belebtschlammbecken', 'rrr_Belebtschlammbecken', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (329,329,'fixed_bed_reactor','Festbettreaktor','reacteur_a_biomasse_fixee', 'zzz_Festbettreaktor', 'rrr_Festbettreaktor', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (330,330,'submerged_trickling_filter','Tauchtropfkoerper','disque_bacterien_immerge', 'zzz_Tauchtropfkoerper', 'rrr_Tauchtropfkoerper', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (328,328,'trickling_filter','Tropfkoerper','lit_bacterien', 'zzz_Tropfkoerper', 'rrr_Tropfkoerper', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3032,3032,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wwtp_structure_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (326,326,'primary_clarifier','Vorklaerbecken','decanteurs_primaires', 'zzz_Vorklaerbecken', 'rrr_Vorklaerbecken', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wwtp_structure ADD CONSTRAINT fkey_vl_wwtp_structure_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.wwtp_structure_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.maintenance_event ADD COLUMN fk_operating_company varchar(16);
ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT rel_maintenance_event_operating_company FOREIGN KEY (fk_operating_company) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.maintenance_event ADD COLUMN fk_measure varchar(16);
ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT rel_maintenance_event_measure FOREIGN KEY (fk_measure) REFERENCES tww_od.measure(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.maintenance_event_status () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.maintenance_event_status ADD CONSTRAINT pkey_tww_vl_maintenance_event_status_code PRIMARY KEY (code);
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2550,2550,'accomplished','ausgefuehrt','execute', 'eseguito', 'rrr_ausgefuehrt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2549,2549,'planned','geplant','prevu', 'previsto', 'rrr_geplant', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3678,3678,'not_possible','nicht_moeglich','impossible', 'non_possibile', 'rrr_nicht_moeglich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_event_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3047,3047,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT fkey_vl_maintenance_event_status FOREIGN KEY (status)
 REFERENCES tww_vl.maintenance_event_status (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.infiltration_zone ADD CONSTRAINT oorel_od_infiltration_zone_zone FOREIGN KEY (obj_id) REFERENCES tww_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.infiltration_zone_infiltration_capacity () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.infiltration_zone_infiltration_capacity ADD CONSTRAINT pkey_tww_vl_infiltration_zone_infiltration_capacity_code PRIMARY KEY (code);
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (371,371,'good','gut','bonnes', 'zzz_gut', 'rrr_gut', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (374,374,'none','keine','aucune', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (372,372,'moderate','maessig','moyennes', 'zzz_maessig', 'rrr_maessig', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (373,373,'bad','schlecht','mauvaises', 'zzz_schlecht', 'rrr_schlecht', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3073,3073,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2996,2996,'not_allowed','unzulaessig','non_admis', 'zzz_unzulaessig', 'rrr_unzulaessig', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.infiltration_zone ADD CONSTRAINT fkey_vl_infiltration_zone_infiltration_capacity FOREIGN KEY (infiltration_capacity)
 REFERENCES tww_vl.infiltration_zone_infiltration_capacity (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.drainage_system ADD CONSTRAINT oorel_od_drainage_system_zone FOREIGN KEY (obj_id) REFERENCES tww_od.zone(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.drainage_system_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.drainage_system_kind ADD CONSTRAINT pkey_tww_vl_drainage_system_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4783,4783,'amelioration','Melioration','melioration', 'zzz_melizzazione', 'rrr_Melioration', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2722,2722,'mixed_system','Mischsystem','systeme_unitaire', 'sistema_misto', 'rrr_Mischsystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2724,2724,'modified_system','ModifiziertesSystem','systeme_modifie', 'sistema_modificato', 'rrr_ModifiziertesSystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4544,4544,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2723,2723,'separated_system','Trennsystem','systeme_separatif', 'sistema_separato', 'rrr_Trennsystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainage_system_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3060,3060,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.drainage_system ADD CONSTRAINT fkey_vl_drainage_system_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.drainage_system_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.pipe_profile_profile_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.pipe_profile_profile_type ADD CONSTRAINT pkey_tww_vl_pipe_profile_profile_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3351,3351,'egg','Eiprofil','ovoide', 'ovoidale', 'ovoid', 'E', 'E', 'OV', '', '', 'true');
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3350,3350,'circle','Kreisprofil','circulaire', 'cicolare', 'rotund', 'CI', 'K', 'CI', 'CI', 'R', 'true');
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3352,3352,'mouth','Maulprofil','profil_en_voute', 'composto', 'sectiune_cu_bolta', 'M', 'M', 'V', 'C', '', 'true');
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3354,3354,'open','offenes_Profil','profil_ouvert', 'sezione_aperta', 'profil_deschis', 'OP', 'OP', 'PO', 'SA', '', 'true');
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3353,3353,'rectangular','Rechteckprofil','rectangulaire', 'rettangolare', 'dreptunghiular', 'R', 'R', 'R', 'R', 'D', 'true');
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3355,3355,'special','Spezialprofil','profil_special', 'sezione_speciale', 'sectiune_speciala', 'S', 'S', 'PS', 'S', 'S', 'true');
 INSERT INTO tww_vl.pipe_profile_profile_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3357,3357,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', 'U', 'U', 'I', 'S', 'N', 'true');
 ALTER TABLE tww_od.pipe_profile ADD CONSTRAINT fkey_vl_pipe_profile_profile_type FOREIGN KEY (profile_type)
 REFERENCES tww_vl.pipe_profile_profile_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.wwtp_energy_use ADD COLUMN fk_waste_water_treatment_plant varchar(16);
ALTER TABLE tww_od.wwtp_energy_use ADD CONSTRAINT rel_wwtp_energy_use_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES tww_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.waste_water_treatment ADD COLUMN fk_waste_water_treatment_plant varchar(16);
ALTER TABLE tww_od.waste_water_treatment ADD CONSTRAINT rel_waste_water_treatment_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES tww_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.waste_water_treatment_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.waste_water_treatment_kind ADD CONSTRAINT pkey_tww_vl_waste_water_treatment_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3210,3210,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (387,387,'biological','biologisch','biologique', 'zzz_biologisch', 'rrr_biologisch', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (388,388,'chemical','chemisch','chimique', 'zzz_chemisch', 'rrr_chemisch', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (389,389,'filtration','Filtration','filtration', 'zzz_Filtration', 'rrr_Filtration', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (366,366,'mechanical','mechanisch','mecanique', 'zzz_mechanisch', 'rrr_mechanisch', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.waste_water_treatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3076,3076,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.waste_water_treatment ADD CONSTRAINT fkey_vl_waste_water_treatment_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.waste_water_treatment_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.sludge_treatment ADD COLUMN fk_waste_water_treatment_plant varchar(16);
ALTER TABLE tww_od.sludge_treatment ADD CONSTRAINT rel_sludge_treatment_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES tww_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.sludge_treatment_stabilisation () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.sludge_treatment_stabilisation ADD CONSTRAINT pkey_tww_vl_sludge_treatment_stabilisation_code PRIMARY KEY (code);
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (141,141,'aerob_cold','aerobkalt','aerobie_froid', 'zzz_aerobkalt', 'rrr_aerobkalt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (332,332,'aerobthermophil','aerobthermophil','aerobie_thermophile', 'zzz_aerobthermophil', 'rrr_aerobthermophil', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (333,333,'anaerob_cold','anaerobkalt','anaerobie_froid', 'zzz_anaerobkalt', 'rrr_anaerobkalt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (334,334,'anaerob_mesophil','anaerobmesophil','anaerobie_mesophile', 'zzz_anaerobmesophil', 'rrr_anaerobmesophil', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (335,335,'anaerob_thermophil','anaerobthermophil','anaerobie_thermophile', 'zzz_anaerobthermophil', 'rrr_anaerobthermophil', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2994,2994,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.sludge_treatment_stabilisation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3004,3004,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.sludge_treatment ADD CONSTRAINT fkey_vl_sludge_treatment_stabilisation FOREIGN KEY (stabilisation)
 REFERENCES tww_vl.sludge_treatment_stabilisation (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.wastewater_networkelement ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT rel_wastewater_networkelement_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade DEFERRABLE;
ALTER TABLE tww_od.reach_point ADD COLUMN fk_wastewater_networkelement varchar(16);
ALTER TABLE tww_od.reach_point ADD CONSTRAINT rel_reach_point_wastewater_networkelement FOREIGN KEY (fk_wastewater_networkelement) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE;
CREATE TABLE tww_vl.reach_point_elevation_accuracy () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_point_elevation_accuracy ADD CONSTRAINT pkey_tww_vl_reach_point_elevation_accuracy_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3248,3248,'more_than_6cm','groesser_6cm','plusque_6cm', 'piu_6cm', 'mai_mare_6cm', '', 'G06', 'S06', '', '', 'true');
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3245,3245,'plusminus_1cm','plusminus_1cm','plus_moins_1cm', 'piu_meno_1cm', 'plus_minus_1cm', '', 'P01', 'P01', '', '', 'true');
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3246,3246,'plusminus_3cm','plusminus_3cm','plus_moins_3cm', 'piu_meno_3cm', 'plus_minus_3cm', '', 'P03', 'P03', '', '', 'true');
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3247,3247,'plusminus_6cm','plusminus_6cm','plus_moins_6cm', 'piu_meno_6cm', 'plus_minus_6cm', '', 'P06', 'P06', '', '', 'true');
 INSERT INTO tww_vl.reach_point_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5376,5376,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.reach_point ADD CONSTRAINT fkey_vl_reach_point_elevation_accuracy FOREIGN KEY (elevation_accuracy)
 REFERENCES tww_vl.reach_point_elevation_accuracy (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_point_outlet_shape () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_point_outlet_shape ADD CONSTRAINT pkey_tww_vl_reach_point_outlet_shape_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5374,5374,'round_edged','abgerundet','arrondie', 'zzz_abgerundet', 'rotunjita', 'RE', 'AR', 'AR', '', '', 'true');
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (298,298,'orifice','blendenfoermig','en_forme_de_seuil_ou_diaphragme', 'zzz_blendenfoermig', 'orificiu', 'O', 'BF', 'FSD', '', '', 'true');
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3358,3358,'no_cross_section_change','keine_Querschnittsaenderung','pas_de_changement_de_section', 'zzz_keine_Querschnittsaenderung', 'fara_schimbare_sectiune', '', 'KQ', 'PCS', '', '', 'true');
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (286,286,'sharp_edged','scharfkantig','aretes_vives', 'zzz_scharfkantig', 'margini_ascutite', '', 'SK', 'AV', '', '', 'true');
 INSERT INTO tww_vl.reach_point_outlet_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5375,5375,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.reach_point ADD CONSTRAINT fkey_vl_reach_point_outlet_shape FOREIGN KEY (outlet_shape)
 REFERENCES tww_vl.reach_point_outlet_shape (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_point_pipe_closure () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_point_pipe_closure ADD CONSTRAINT pkey_tww_vl_reach_point_pipe_closure_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_point_pipe_closure (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8999,8999,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_point_pipe_closure (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9000,9000,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_point_pipe_closure (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9001,9001,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach_point ADD CONSTRAINT fkey_vl_reach_point_pipe_closure FOREIGN KEY (pipe_closure)
 REFERENCES tww_vl.reach_point_pipe_closure (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.wastewater_node ADD COLUMN fk_hydr_geometry varchar(16);
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT rel_wastewater_node_hydr_geometry FOREIGN KEY (fk_hydr_geometry) REFERENCES tww_od.hydr_geometry(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT oorel_od_wastewater_node_wastewater_networkelement FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_networkelement(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.wastewater_node_elevation_accuracy () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_node_elevation_accuracy ADD CONSTRAINT pkey_tww_vl_wastewater_node_elevation_accuracy_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9061,9061,'more_than_6cm','groesser_6cm','plusque_6cm', 'piu_6cm', 'mai_mare_6cm', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9062,9062,'plusminus_1cm','plusminus_1cm','plus_moins_1cm', 'piu_meno_1cm', 'plus_minus_1cm', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9063,9063,'plusminus_3cm','plusminus_3cm','plus_moins_3cm', 'piu_meno_3cm', 'plus_minus_3cm', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9064,9064,'plusminus_6cm','plusminus_6cm','plus_moins_6cm', 'piu_meno_6cm', 'plus_minus_6cm', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_elevation_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9060,9060,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_elevation_accuracy FOREIGN KEY (elevation_accuracy)
 REFERENCES tww_vl.wastewater_node_elevation_accuracy (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_node_function_node_amelioration () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_node_function_node_amelioration ADD CONSTRAINT pkey_tww_vl_wastewater_node_function_node_amelioration_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4621,4621,'slope_change','Gefaellsbruch','changement_de_pente', 'zzz_Gefaellsbruch', 'rrr_Gefaellsbruch', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9083,9083,'slope_caliber_change','Gefaellsbruch_Kaliberwechsel','changement_de_pente_et_calibre', 'zzz_Gefaellsbruch_Kaliberwechsel', 'rrr_Gefaellsbruch_Kaliberwechsel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4623,4623,'change_of_diameter','Kaliberwechsel','changement_de_calibre', 'zzz_Kaliberwechsel', 'rr_Kaliberwechsel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4622,4622,'standard_manhole','Normschacht','chambre_standard', 'zzz_Normschacht', 'rrr_Normschacht', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9084,9084,'standard_manhole_slope_change','Normschacht_Gefaellsbruch','chambre_standard_changement_de_pente', 'zzz_Normschacht_Gefaellsbruch', 'rrr_Normschacht_Gefaellsbruch', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9086,9086,'standard_manhole_slope_caliber_change','Normschacht_Gefaellsbruch_Kaliberwechsel','chambre_standard_changement_de_pente_et_calibre', 'zzz_Normschacht_Gefaellsbruch_Kaliberwechsel', 'rrr_Normschacht_Gefaellsbruch_Kaliberwechsel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9085,9085,'standard_manhole_caliber_change','Normschacht_Kaliberwechsel','chambre_standard_changement_de_calibre', 'zzz_Normschacht_Kaliberwechsel', 'rrr_Normschacht_Kaliberwechsel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_node_function_node_amelioration (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4620,4620,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_function_node_amelioration FOREIGN KEY (function_node_amelioration)
 REFERENCES tww_vl.wastewater_node_function_node_amelioration (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.reach ADD COLUMN fk_reach_point_from varchar(16);
ALTER TABLE tww_od.reach ADD CONSTRAINT rel_reach_reach_point_from FOREIGN KEY (fk_reach_point_from) REFERENCES tww_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.reach ADD COLUMN fk_reach_point_to varchar(16);
ALTER TABLE tww_od.reach ADD CONSTRAINT rel_reach_reach_point_to FOREIGN KEY (fk_reach_point_to) REFERENCES tww_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.reach ADD COLUMN fk_pipe_profile varchar(16);
ALTER TABLE tww_od.reach ADD CONSTRAINT rel_reach_pipe_profile FOREIGN KEY (fk_pipe_profile) REFERENCES tww_od.pipe_profile(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.reach ADD CONSTRAINT oorel_od_reach_wastewater_networkelement FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_networkelement(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.reach_elevation_determination () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_elevation_determination ADD CONSTRAINT pkey_tww_vl_reach_elevation_determination_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4780,4780,'accurate','genau','precise', 'precisa', 'precisa', '', 'LG', 'P', '', '', 'true');
 INSERT INTO tww_vl.reach_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4778,4778,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.reach_elevation_determination (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4779,4779,'inaccurate','ungenau','imprecise', 'impreciso', 'imprecisa', '', 'LU', 'IP', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_elevation_determination FOREIGN KEY (elevation_determination)
 REFERENCES tww_vl.reach_elevation_determination (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_horizontal_positioning () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_horizontal_positioning ADD CONSTRAINT pkey_tww_vl_reach_horizontal_positioning_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5378,5378,'accurate','genau','precise', 'precisa', 'precisa', '', 'LG', 'P', '', '', 'true');
 INSERT INTO tww_vl.reach_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5379,5379,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.reach_horizontal_positioning (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5380,5380,'inaccurate','ungenau','imprecise', 'impreciso', 'imprecisa', '', 'LU', 'IP', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_horizontal_positioning FOREIGN KEY (horizontal_positioning)
 REFERENCES tww_vl.reach_horizontal_positioning (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_inside_coating () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_inside_coating ADD CONSTRAINT pkey_tww_vl_reach_inside_coating_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5383,5383,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (248,248,'coating','Anstrich_Beschichtung','peinture_revetement', 'zzz_Anstrich_Beschichtung', 'strat_vopsea', 'C', 'B', 'PR', '', '', 'true');
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (250,250,'brick_lining','Kanalklinkerauskleidung','revetement_en_brique', 'zzz_Kanalklinkerauskleidung', 'strat_caramida', '', 'KL', 'RB', '', '', 'true');
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (251,251,'stoneware_lining','Steinzeugauskleidung','revetement_en_gres', 'zzz_Steinzeugauskleidung', 'strat_gresie', '', 'ST', 'RG', '', '', 'true');
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5384,5384,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.reach_inside_coating (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (249,249,'cement_mortar_lining','Zementmoertelauskleidung','revetement_en_mortier_de_ciment', 'zzz_Zementmoertelauskleidung', 'strat_mortar_ciment', '', 'ZM', 'RM', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_inside_coating FOREIGN KEY (inside_coating)
 REFERENCES tww_vl.reach_inside_coating (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_leak_protection () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_leak_protection ADD CONSTRAINT pkey_tww_vl_reach_leak_protection_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_leak_protection (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8710,8710,'inexistent','nicht_vorhanden','inexistant', 'non_presente', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_leak_protection (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8711,8711,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_leak_protection (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8709,8709,'existent','vorhanden','existant', 'presente', 'existent', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_leak_protection FOREIGN KEY (leak_protection)
 REFERENCES tww_vl.reach_leak_protection (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_material ADD CONSTRAINT pkey_tww_vl_reach_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5381,5381,'other','andere','autre', 'altro', 'alta', 'O', 'A', 'AU', 'A', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2754,2754,'asbestos_cement','Asbestzement','amiante_ciment', 'cemento_amianto', 'azbociment', 'AC', 'AZ', 'AC', 'CA', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3638,3638,'concrete_normal','Beton_Normalbeton','beton_normal', 'calcestruzzo_normale', 'beton_normal', 'CN', 'NB', 'BN', 'CN', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3639,3639,'concrete_insitu','Beton_Ortsbeton','beton_coule_sur_place', 'calcestruzzo_gettato_opera', 'beton_turnat_insitu', 'CI', 'OB', 'BCP', 'CGO', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3640,3640,'concrete_presspipe','Beton_Pressrohrbeton','beton_pousse_tube', 'calcestruzzo_spingitubo', 'beton_presstube', 'CP', 'PRB', 'BPT', 'CST', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3641,3641,'concrete_special','Beton_Spezialbeton','beton_special', 'calcestruzzo_speciale', 'beton_special', 'CS', 'SB', 'BS', 'CS', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3256,3256,'concrete_unknown','Beton_unbekannt','beton_inconnu', 'calcestruzzo_sconosciuto', 'beton_necunoscut', 'CU', 'BU', 'BI', 'CSC', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (147,147,'fiber_cement','Faserzement','fibrociment', 'fibrocemento', 'fibrociment', 'FC', 'FZ', 'FC', 'FC', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2755,2755,'bricks','Gebrannte_Steine','terre_cuite', 'ceramica', 'teracota', 'BR', 'SG', 'TC', 'CE', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (148,148,'cast_ductile_iron','Guss_duktil','fonte_ductile', 'ghisa_duttile', 'fonta_ductila', 'ID', 'GD', 'FD', 'GD', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3648,3648,'cast_gray_iron','Guss_Grauguss','fonte_grise', 'ghisa_grigia', 'fonta_cenusie', 'CGI', 'GG', 'FG', 'GG', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5076,5076,'plastic_epoxy_resin','Kunststoff_Epoxydharz','matiere_synthetique_resine_d_epoxy', 'materiale_sintetico_resina_epossidica', 'plastic_rasina_epoxi', 'PER', 'EP', 'EP', 'MSR', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5077,5077,'plastic_highdensity_polyethylene','Kunststoff_Hartpolyethylen','matiere_synthetique_polyethylene_dur', 'materiale_sintetico_polietilene_duro', 'plastic_PEHD', 'HPE', 'HPE', 'PD', 'MSP', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5078,5078,'plastic_polyester_GUP','Kunststoff_Polyester_GUP','matiere_synthetique_polyester_PRV', 'materiale_sintetico_poliestere_GUP', 'plastic_poliester_GUP', 'GUP', 'GUP', 'GUP', 'GUP', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5079,5079,'plastic_polyethylene','Kunststoff_Polyethylen','matiere_synthetique_polyethylene', 'materiale_sintetico_polietilene', 'plastic_PE', 'PE', 'PE', 'PE', 'PE', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5080,5080,'plastic_polypropylene','Kunststoff_Polypropylen','matiere_synthetique_polypropylene', 'materiale_sintetico_polipropilene', 'plastic_polipropilena', 'PP', 'PP', 'PP', 'PP', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5081,5081,'plastic_PVC','Kunststoff_Polyvinilchlorid','matiere_synthetique_PVC', 'materiale_sintetico_PVC', 'plastic_PVC', 'PVC', 'PVC', 'PVC', 'PVC', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5382,5382,'plastic_unknown','Kunststoff_unbekannt','matiere_synthetique_inconnue', 'materiale_sintetico_sconosciuto', 'plastic_necunoscut', 'PU', 'KUU', 'MSI', 'MSC', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (153,153,'steel','Stahl','acier', 'acciaio', 'otel', 'ST', 'ST', 'AC', 'AC', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3654,3654,'steel_stainless','Stahl_rostfrei','acier_inoxydable', 'acciaio_inossidabile', 'inox', 'SST', 'STI', 'ACI', 'ACI', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (154,154,'stoneware','Steinzeug','gres', 'gres', 'gresie', 'SW', 'STZ', 'GR', 'GR', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2761,2761,'clay','Ton','argile', 'argilla', 'argila', 'CL', 'T', 'AR', 'AR', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3016,3016,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', 'U', 'U', 'I', 'SC', '', 'true');
 INSERT INTO tww_vl.reach_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2762,2762,'cement','Zement','ciment', 'cemento', 'ciment', 'C', 'Z', 'C', 'C', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_material FOREIGN KEY (material)
 REFERENCES tww_vl.reach_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_reliner_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_reliner_material ADD CONSTRAINT pkey_tww_vl_reach_reliner_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6459,6459,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6461,6461,'epoxy_resin_glass_fibre_laminate','Epoxidharz_Glasfaserlaminat','resine_epoxy_lamine_en_fibre_de_verre', 'zzz_Epoxidharz_Glasfaserlaminat', 'rasina_epoxi_laminata_in_fibra_de_sticla', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6460,6460,'epoxy_resin_plastic_felt','Epoxidharz_Kunststofffilz','resine_epoxy_feutre_synthetique', 'zzz_Epoxidharz_Kunststofffilz', 'rasina_epoxi_asemanatoare_plastic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6483,6483,'GUP_pipe','GUP_Rohr','tuyau_PRV', 'zzz_GUP_Rohr', 'conducta_PAFS', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6462,6462,'HDPE','HDPE','HDPE', 'HDPE', 'PEHD', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6484,6484,'isocyanate_resin_glass_fibre_laminate','Isocyanatharze_Glasfaserlaminat','isocyanat_resine_lamine_en_fibre_de_verre', 'zzz_Isocynatharze_Glasfaserlaminat', 'izocianat_rasina_laminat_in_fibra_sticla', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6485,6485,'isocyanate_resin_plastic_felt','Isocyanatharze_Kunststofffilz','isocyanat_resine_lamine_feutre_synthetique', 'zzz_Isocynatharze_Kunststofffilz', 'izocianat_rasina_laminat_asemanatoare_plastic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6464,6464,'polyester_resin_glass_fibre_laminate','Polyesterharz_Glasfaserlaminat','resine_de_polyester_lamine_en_fibre_de_verre', 'zzz_Polyesterharz_Glasfaserlaminat', 'rasina_de_poliester_laminata_in_fibra_de_sticla', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6463,6463,'polyester_resin_plastic_felt','Polyesterharz_Kunststofffilz','resine_de_polyester_feutre_synthetique', 'zzz_Polyesterharz_Kunststofffilz', 'rasina_poliester_asemanatare_plastic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6482,6482,'polypropylene','Polypropylen','polypropylene', 'polipropilene', 'polipropilena', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6465,6465,'PVC','Polyvinilchlorid','PVC', 'zzz_Polyvinilchlorid', 'PVC', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6466,6466,'bottom_with_polyester_concret_shell','Sohle_mit_Schale_aus_Polyesterbeton','radier_avec_pellicule_en_beton_polyester', 'zzz_Sohle_mit_Schale_aus_Polyesterbeton', 'radier_cu_pelicula_din_beton_poliester', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6467,6467,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6486,6486,'UP_resin_LED_synthetic_fibre_liner','UP_Harz_LED_Synthesefaserliner','UP_resine_LED_fibre_synthetiques_liner', 'zzz_UP_Harz_LED_Synthesefaserliner', 'rasina_UP_LED_captuseala_fibra_sintetica', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6468,6468,'vinyl_ester_resin_glass_fibre_laminate','Vinylesterharz_Glasfaserlaminat','resine_d_ester_vinylique_lamine_en_fibre_de_verre', 'zzz_Vinylesterharz_Glasfaserlaminat', 'rasina_de_ester_vinil_laminata_in_fibra_de_sticla', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_reliner_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6469,6469,'vinyl_ester_resin_plastic_felt','Vinylesterharz_Kunststofffilz','resine_d_ester_vinylique_feutre_synthetique', 'zzz_Vinylesterharz_Kunststofffilz', 'rasina_de_ester_vinil', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_reliner_material FOREIGN KEY (reliner_material)
 REFERENCES tww_vl.reach_reliner_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_relining_construction () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_relining_construction ADD CONSTRAINT pkey_tww_vl_reach_relining_construction_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6448,6448,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6479,6479,'close_fit_relining','Close_Fit_Relining','close_fit_relining', 'zzz_Close_Fit_Relining', 'reconditionare_close_fit', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6449,6449,'relining_short_tube','Kurzrohrrelining','relining_tube_court', 'zzz_Kurzrohrrelining', 'reconditionare_tub_scurt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6481,6481,'grouted_in_place_lining','Noppenschlauchrelining','Noppenschlauchrelining', 'zzz_Noppenschlauchrelining', 'chituire', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6452,6452,'partial_liner','Partieller_Liner','liner_partiel', 'zzz_Partieller_Liner', 'captuseala_partiala', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6450,6450,'pipe_string_relining','Rohrstrangrelining','chemisage_par_ligne_de_tuyau', 'zzz_Rohrstrangrelining', 'pipe_string_relining', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6451,6451,'hose_relining','Schlauchrelining','chemisage_par_gainage', 'zzz_Schlauchrelining', 'reconditionare_prin_camasuire', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6453,6453,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_construction (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6480,6480,'spiral_lining','Wickelrohrrelining','chemisage_par_tube_spirale', 'zzz_Wickelrohrrelining', 'captusire_prin_tub_spirala', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_relining_construction FOREIGN KEY (relining_construction)
 REFERENCES tww_vl.reach_relining_construction (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_relining_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_relining_kind ADD CONSTRAINT pkey_tww_vl_reach_relining_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_relining_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6455,6455,'full_reach','ganze_Haltung','troncon_entier', 'condotta_intera', 'tronson_intreg', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6456,6456,'partial','partiell','partiellement', 'parziale', 'partial', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_relining_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6457,6457,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach ADD CONSTRAINT fkey_vl_reach_relining_kind FOREIGN KEY (relining_kind)
 REFERENCES tww_vl.reach_relining_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.profile_geometry ADD COLUMN fk_pipe_profile varchar(16);
ALTER TABLE tww_od.profile_geometry ADD CONSTRAINT rel_profile_geometry_pipe_profile FOREIGN KEY (fk_pipe_profile) REFERENCES tww_od.pipe_profile(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.hydr_geom_relation ADD COLUMN fk_hydr_geometry varchar(16);
ALTER TABLE tww_od.hydr_geom_relation ADD CONSTRAINT rel_hydr_geom_relation_hydr_geometry FOREIGN KEY (fk_hydr_geometry) REFERENCES tww_od.hydr_geometry(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.mechanical_pretreatment ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.mechanical_pretreatment ADD CONSTRAINT rel_mechanical_pretreatment_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.mechanical_pretreatment_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.mechanical_pretreatment_kind ADD CONSTRAINT pkey_tww_vl_mechanical_pretreatment_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3317,3317,'filter_bag','Filtersack','percolateur', 'zzz_Filtersack', 'rrr_Filtersack', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3319,3319,'artificial_adsorber','KuenstlicherAdsorber','adsorbeur_artificiel', 'zzz_KuenstlicherAdsorber', 'rrr_KuenstlicherAdsorber', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3318,3318,'swale_french_drain_system','MuldenRigolenSystem','systeme_cuvettes_rigoles', 'zzz_MuldenRigolenSystem', 'rrr_MuldenRigolenSystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3320,3320,'slurry_collector','Schlammsammler','collecteur_de_boue', 'pozzetto_decantazione', 'colector_aluviuni', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3321,3321,'floating_matter_separator','Schwimmstoffabscheider','separateur_materiaux_flottants', 'separatore_materiali_galleggianti', 'separator_materie_flotanta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.mechanical_pretreatment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3322,3322,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.mechanical_pretreatment ADD CONSTRAINT fkey_vl_mechanical_pretreatment_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.mechanical_pretreatment_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.retention_body ADD COLUMN fk_infiltration_installation varchar(16);
ALTER TABLE tww_od.retention_body ADD CONSTRAINT rel_retention_body_infiltration_installation FOREIGN KEY (fk_infiltration_installation) REFERENCES tww_od.infiltration_installation(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.retention_body_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.retention_body_kind ADD CONSTRAINT pkey_tww_vl_retention_body_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2992,2992,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (346,346,'retention_in_habitat','Biotop','retention_dans_bassins_et_depressions', 'zzz_Biotop', 'rrr_Biotop', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (345,345,'roof_retention','Dachretention','retention_sur_toits', 'zzz_Dachretention', 'rrr_Dachretention', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (348,348,'parking_lot','Parkplatz','retention_sur_routes_et_places', 'zzz_Parkplatz', 'rrr_Parkplaetze', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (347,347,'accumulation_channel','Staukanal','retention_dans_canalisations_stockage', 'zzz_Staukanal', 'rrr_Staukanal', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.retention_body_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3031,3031,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.retention_body ADD CONSTRAINT fkey_vl_retention_body_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.retention_body_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.overflow_char_kind_overflow_char () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.overflow_char_kind_overflow_char ADD CONSTRAINT pkey_tww_vl_overflow_char_kind_overflow_char_code PRIMARY KEY (code);
 INSERT INTO tww_vl.overflow_char_kind_overflow_char (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6220,6220,'hq','HQ','HQ', 'HQ', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_char_kind_overflow_char (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6221,6221,'qq','QQ','QQ', 'QQ', 'QQ', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_char_kind_overflow_char (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6228,6228,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.overflow_char ADD CONSTRAINT fkey_vl_overflow_char_kind_overflow_char FOREIGN KEY (kind_overflow_char)
 REFERENCES tww_vl.overflow_char_kind_overflow_char (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.hq_relation ADD COLUMN fk_overflow_char varchar(16);
ALTER TABLE tww_od.hq_relation ADD CONSTRAINT rel_hq_relation_overflow_char FOREIGN KEY (fk_overflow_char) REFERENCES tww_od.overflow_char(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.structure_part ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.structure_part ADD CONSTRAINT rel_structure_part_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE cascade DEFERRABLE;
CREATE TABLE tww_vl.structure_part_renovation_demand () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.structure_part_renovation_demand ADD CONSTRAINT pkey_tww_vl_structure_part_renovation_demand_code PRIMARY KEY (code);
 INSERT INTO tww_vl.structure_part_renovation_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (138,138,'not_necessary','nicht_notwendig','pas_necessaire', 'zzz_nicht_notwendig', 'nenecesare', 'NN', 'NN', 'PN', '', '', 'true');
 INSERT INTO tww_vl.structure_part_renovation_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (137,137,'necessary','notwendig','necessaire', 'zzz_notwendig', 'necesare', 'N', 'N', 'N', '', '', 'true');
 INSERT INTO tww_vl.structure_part_renovation_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5358,5358,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.structure_part ADD CONSTRAINT fkey_vl_structure_part_renovation_demand FOREIGN KEY (renovation_demand)
 REFERENCES tww_vl.structure_part_renovation_demand (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.dryweather_downspout ADD CONSTRAINT oorel_od_dryweather_downspout_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.access_aid ADD CONSTRAINT oorel_od_access_aid_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.access_aid_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.access_aid_kind ADD CONSTRAINT pkey_tww_vl_access_aid_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5357,5357,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (243,243,'pressurized_door','Drucktuere','porte_etanche', 'zzz_Drucktuere', 'usa_presurizata', 'PD', 'D', 'PE', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (92,92,'none','keine','aucun_equipement_d_acces', 'nessuno', 'inexistent', '', 'K', 'AN', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (240,240,'ladder','Leiter','echelle', 'zzz_Leiter', 'scara', '', 'L', 'EC', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (241,241,'step_iron','Steigeisen','echelons', 'zzz_Steigeisen', 'esaloane', '', 'S', 'ECO', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3473,3473,'staircase','Treppe','escalier', 'zzz_Treppe', 'structura_scari', '', 'R', 'ES', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (91,91,'footstep_niches','Trittnischen','marchepieds', 'zzz_Trittnischen', 'trepte', '', 'N', 'N', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3230,3230,'door','Tuere','porte', 'porta', 'usa', '', 'T', 'P', '', '', 'true');
 INSERT INTO tww_vl.access_aid_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3048,3048,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.access_aid ADD CONSTRAINT fkey_vl_access_aid_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.access_aid_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.dryweather_flume ADD CONSTRAINT oorel_od_dryweather_flume_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.dryweather_flume_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.dryweather_flume_material ADD CONSTRAINT pkey_tww_vl_dryweather_flume_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3221,3221,'other','andere','autres', 'altro', 'alta', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (354,354,'combined','kombiniert','combine', 'zzz_kombiniert', 'combinata', '', 'KOM', 'COM', '', '', 'true');
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5356,5356,'plastic','Kunststoff','matiere_synthetique', 'zzz_Kunststoff', 'materie_sintetica', '', 'KU', 'MS', '', '', 'true');
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (238,238,'stoneware','Steinzeug','gres', 'gres', 'gresie', '', 'STZ', 'GR', '', '', 'true');
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3017,3017,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.dryweather_flume_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (237,237,'cement_mortar','Zementmoertel','mortier_de_ciment', 'zzz_Zementmoertel', 'mortar_ciment', '', 'ZM', 'MC', '', '', 'true');
 ALTER TABLE tww_od.dryweather_flume ADD CONSTRAINT fkey_vl_dryweather_flume_material FOREIGN KEY (material)
 REFERENCES tww_vl.dryweather_flume_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.cover ADD CONSTRAINT oorel_od_cover_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.cover_cover_shape () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.cover_cover_shape ADD CONSTRAINT pkey_tww_vl_cover_cover_shape_code PRIMARY KEY (code);
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5353,5353,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3499,3499,'rectangular','eckig','anguleux', 'zzz_eckig', 'dreptunghic', 'R', 'E', 'AX', '', '', 'true');
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3498,3498,'round','rund','rond', 'zzz_rund', 'rotund', '', 'R', 'R', '', '', 'true');
 INSERT INTO tww_vl.cover_cover_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5354,5354,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.cover ADD CONSTRAINT fkey_vl_cover_cover_shape FOREIGN KEY (cover_shape)
 REFERENCES tww_vl.cover_cover_shape (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.cover_fastening () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.cover_fastening ADD CONSTRAINT pkey_tww_vl_cover_fastening_code PRIMARY KEY (code);
 INSERT INTO tww_vl.cover_fastening (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5350,5350,'not_bolted','nicht_verschraubt','non_vissee', 'zzz_nicht_verschraubt', 'neinsurubata', '', 'NVS', 'NVS', '', '', 'true');
 INSERT INTO tww_vl.cover_fastening (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5351,5351,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.cover_fastening (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5352,5352,'bolted','verschraubt','vissee', 'zzz_verschraubt', 'insurubata', '', 'VS', 'VS', '', '', 'true');
 ALTER TABLE tww_od.cover ADD CONSTRAINT fkey_vl_cover_fastening FOREIGN KEY (fastening)
 REFERENCES tww_vl.cover_fastening (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.cover_material () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.cover_material ADD CONSTRAINT pkey_tww_vl_cover_material_code PRIMARY KEY (code);
 INSERT INTO tww_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5355,5355,'other','andere','autre', 'altro', 'altul', 'O', 'A', 'AU', '', '', 'true');
 INSERT INTO tww_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (234,234,'concrete','Beton','beton', 'calcestruzzo', 'beton', 'C', 'B', 'B', '', '', 'true');
 INSERT INTO tww_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (233,233,'cast_iron','Guss','fonte', 'ghisa', 'fonta', '', 'G', 'F', '', '', 'true');
 INSERT INTO tww_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5547,5547,'cast_iron_with_pavement_filling','Guss_mit_Belagsfuellung','fonte_avec_remplissage_enrobe', 'zzz_Guss_mit_Belagsfuellung', 'fonta_cu_umplutura', 'CIP', 'GBL', 'FRE', '', '', 'true');
 INSERT INTO tww_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (235,235,'cast_iron_with_concrete_filling','Guss_mit_Betonfuellung','fonte_avec_remplissage_beton', 'zzz_Guss_mit_Betonfuellung', 'fonta_cu_umplutura_beton', '', 'GBT', 'FRB', '', '', 'true');
 INSERT INTO tww_vl.cover_material (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3015,3015,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.cover ADD CONSTRAINT fkey_vl_cover_material FOREIGN KEY (material)
 REFERENCES tww_vl.cover_material (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.cover_positional_accuracy () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.cover_positional_accuracy ADD CONSTRAINT pkey_tww_vl_cover_positional_accuracy_code PRIMARY KEY (code);
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3243,3243,'more_than_50cm','groesser_50cm','plusque_50cm', 'maggiore_50cm', 'mai_mare_50cm', '', 'G50', 'S50', '', '', 'true');
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3241,3241,'plusminus_10cm','plusminus_10cm','plus_moins_10cm', 'piu_meno_10cm', 'plus_minus_10cm', '', 'P10', 'P10', '', '', 'true');
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3236,3236,'plusminus_3cm','plusminus_3cm','plus_moins_3cm', 'piu_meno_3cm', 'plus_minus_3cm', '', 'P03', 'P03', '', '', 'true');
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3242,3242,'plusminus_50cm','plusminus_50cm','plus_moins_50cm', 'piu_meno_50cm', 'plus_minus_50cm', '', 'P50', 'P50', '', '', 'true');
 INSERT INTO tww_vl.cover_positional_accuracy (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5349,5349,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.cover ADD CONSTRAINT fkey_vl_cover_positional_accuracy FOREIGN KEY (positional_accuracy)
 REFERENCES tww_vl.cover_positional_accuracy (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.cover_sludge_bucket () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.cover_sludge_bucket ADD CONSTRAINT pkey_tww_vl_cover_sludge_bucket_code PRIMARY KEY (code);
 INSERT INTO tww_vl.cover_sludge_bucket (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (423,423,'inexistent','nicht_vorhanden','inexistant', 'non_presente', 'inexistent', '', 'NV', 'IE', '', '', 'true');
 INSERT INTO tww_vl.cover_sludge_bucket (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3066,3066,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 INSERT INTO tww_vl.cover_sludge_bucket (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (422,422,'existent','vorhanden','existant', 'presente', 'existent', '', 'V', 'E', '', '', 'true');
 ALTER TABLE tww_od.cover ADD CONSTRAINT fkey_vl_cover_sludge_bucket FOREIGN KEY (sludge_bucket)
 REFERENCES tww_vl.cover_sludge_bucket (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.cover_venting () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.cover_venting ADD CONSTRAINT pkey_tww_vl_cover_venting_code PRIMARY KEY (code);
 INSERT INTO tww_vl.cover_venting (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (229,229,'vented','entlueftet','aere', 'zzz_entlueftet', 'cu_aerisire', '', 'EL', 'AE', '', '', 'true');
 INSERT INTO tww_vl.cover_venting (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (230,230,'not_vented','nicht_entlueftet','non_aere', 'zzz_nicht_entlueftet', 'fara_aerisire', '', 'NEL', 'NAE', '', '', 'true');
 INSERT INTO tww_vl.cover_venting (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5348,5348,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscut', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.cover ADD CONSTRAINT fkey_vl_cover_venting FOREIGN KEY (venting)
 REFERENCES tww_vl.cover_venting (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.electric_equipment ADD CONSTRAINT oorel_od_electric_equipment_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.electric_equipment_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.electric_equipment_kind ADD CONSTRAINT pkey_tww_vl_electric_equipment_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2980,2980,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (376,376,'illumination','Beleuchtung','eclairage', 'zzz_Beleuchtung', 'rrr_Beleuchtung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3255,3255,'remote_control_system','Fernwirkanlage','installation_de_telecommande', 'zzz_Fernwirkanlage', 'rrr_Fernwirkanlage', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (378,378,'radio_unit','Funk','radio', 'zzz_Funk', 'rrr_Funk', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (377,377,'phone','Telephon','telephone', 'telefono', 'telefon', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electric_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3038,3038,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.electric_equipment ADD CONSTRAINT fkey_vl_electric_equipment_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.electric_equipment_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.electromechanical_equipment ADD CONSTRAINT oorel_od_electromechanical_equipment_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.electromechanical_equipment_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.electromechanical_equipment_kind ADD CONSTRAINT pkey_tww_vl_electromechanical_equipment_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2981,2981,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (380,380,'leakage_water_pump','Leckwasserpumpe','pompe_d_epuisement', 'zzz_Leckwasserpumpe', 'rrr_Leckwasserpumpe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (337,337,'air_dehumidifier','Luftentfeuchter','deshumidificateur', 'zzz_Luftentfeuchter', 'rrr_Luftentfeuchter', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.electromechanical_equipment_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3072,3072,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.electromechanical_equipment ADD CONSTRAINT fkey_vl_electromechanical_equipment_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.electromechanical_equipment_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.benching ADD CONSTRAINT oorel_od_benching_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.benching_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.benching_kind ADD CONSTRAINT pkey_tww_vl_benching_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5319,5319,'other','andere','autre', 'altro', 'alta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (94,94,'double_sided','beidseitig','double', 'zzz_beidseitig', 'dubla', 'DS', 'BB', 'D', '', '', 'true');
 INSERT INTO tww_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (93,93,'one_sided','einseitig','simple', 'zzz_einseitig', 'simpla', 'OS', 'EB', 'S', '', '', 'true');
 INSERT INTO tww_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3231,3231,'none','kein','aucun', 'nessuno', 'niciun', '', 'KB', 'AN', '', '', 'true');
 INSERT INTO tww_vl.benching_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3033,3033,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', 'U', 'I', '', '', 'true');
 ALTER TABLE tww_od.benching ADD CONSTRAINT fkey_vl_benching_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.benching_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.flushing_nozzle ADD CONSTRAINT oorel_od_flushing_nozzle_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.connection_object ADD COLUMN fk_wastewater_networkelement varchar(16);
ALTER TABLE tww_od.connection_object ADD CONSTRAINT rel_connection_object_wastewater_networkelement FOREIGN KEY (fk_wastewater_networkelement) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.building ADD CONSTRAINT oorel_od_building_connection_object FOREIGN KEY (obj_id) REFERENCES tww_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.reservoir ADD CONSTRAINT oorel_od_reservoir_connection_object FOREIGN KEY (obj_id) REFERENCES tww_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.individual_surface ADD CONSTRAINT oorel_od_individual_surface_connection_object FOREIGN KEY (obj_id) REFERENCES tww_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.individual_surface_function () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.individual_surface_function ADD CONSTRAINT pkey_tww_vl_individual_surface_function_code PRIMARY KEY (code);
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2979,2979,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3466,3466,'railway_site','Bahnanlagen','installation_ferroviaire', 'zzz_Bahnanlagen', 'rrr_Bahnanlagen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3461,3461,'roof_industrial_or_commercial_building','DachflaecheIndustrieundGewerbebetriebe','surface_toits_bat_industriels_artisanaux', 'zzz_DachflaecheIndustrieundGewerbebetriebe', 'rrr_DachflaecheIndustrieundGewerbebetriebe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3460,3460,'roof_residential_or_office_building','DachflaecheWohnundBuerogebaeude','surface_toits_imm_habitation_administratifs', 'zzz_DachflaecheWohnundBuerogebaeude', 'rrr_DachflaecheWohnundBuerogebaeude', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3464,3464,'access_or_collecting_road','Erschliessungs_Sammelstrassen','routes_de_desserte_et_collectives', 'zzz_Erschliessungs_Sammelstrassen', 'rrr_Erschliessungs_Sammelstrassen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3467,3467,'parking_lot','Parkplaetze','parkings', 'zzz_Parkplaetze', 'rrr_Parkplaetze', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3462,3462,'transfer_site_or_stockyard','UmschlagundLagerplaetze','places_transbordement_entreposage', 'zzz_UmschlagundLagerplaetze', 'rrr_UmschlagundLagerplaetze', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3029,3029,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3465,3465,'connecting_or_principal_or_major_road','Verbindungs_Hauptverkehrs_Hochleistungsstrassen','routes_de_raccordement_principales_grand_trafic', 'zzz_Verbindungs_Hauptverkehrs_Hochleistungsstrassen', 'rrr_Verbindungs_Hauptverkehrs_Hochleistungsstrassen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3463,3463,'forecourt_and_access_road','VorplaetzeZufahrten','places_devant_entree_acces', 'zzz_VorplaetzeZufahrten', 'rrr_VorplaetzeZufahrten', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.individual_surface ADD CONSTRAINT fkey_vl_individual_surface_function FOREIGN KEY (function)
 REFERENCES tww_vl.individual_surface_function (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.individual_surface_pavement () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.individual_surface_pavement ADD CONSTRAINT pkey_tww_vl_individual_surface_pavement_code PRIMARY KEY (code);
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2978,2978,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2031,2031,'paved','befestigt','impermeabilise', 'zzz_befestigt', 'rrr_befestigt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2032,2032,'forested','bestockt','boise', 'zzz_bestockt', 'rrr_bestockt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2033,2033,'soil_covered','humusiert','couverture_vegetale', 'zzz_humusiert', 'rrr_humusiert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3030,3030,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.individual_surface_pavement (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2034,2034,'barren','vegetationslos','sans_vegetation', 'zzz_vegetationslos', 'rrr_vegetationslos', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.individual_surface ADD CONSTRAINT fkey_vl_individual_surface_pavement FOREIGN KEY (pavement)
 REFERENCES tww_vl.individual_surface_pavement (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.fountain ADD CONSTRAINT oorel_od_fountain_connection_object FOREIGN KEY (obj_id) REFERENCES tww_od.connection_object(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.log_card ADD COLUMN fk_pwwf_wastewater_node varchar(16);
ALTER TABLE tww_od.log_card ADD CONSTRAINT rel_log_card_pwwf_wastewater_node FOREIGN KEY (fk_pwwf_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.log_card ADD COLUMN fk_agency varchar(16);
ALTER TABLE tww_od.log_card ADD CONSTRAINT rel_log_card_agency FOREIGN KEY (fk_agency) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.log_card ADD COLUMN fk_location_municipality varchar(16);
ALTER TABLE tww_od.log_card ADD CONSTRAINT rel_log_card_location_municipality FOREIGN KEY (fk_location_municipality) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.log_card_control_remote_control () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.log_card_control_remote_control ADD CONSTRAINT pkey_tww_vl_log_card_control_remote_control_code PRIMARY KEY (code);
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8532,8532,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8527,8527,'no_control','keine_Steuerung','aucune_commande', 'nessun_comando', 'rrr_keine_Steuerung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8528,8528,'local_control','lokale_Steuerung','commande_locale', 'comando_locale', 'rrr_lokale_Steuerung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8529,8529,'transmission_alarm','Uebermittlung_Alarm','transmission_alarme', 'trasmissione_allarme', 'rrr_Uebermittlung_Alarm', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8530,8530,'transmission_measuring_signals','Uebermittlung_Messsignale','transmission_signaux_mesure', 'trasmissione_segnali_misura', 'rrr_Uebermittlung_Messsignale', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8533,8533,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_control_remote_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8531,8531,'interconnection_control','Verbundsteuerung','commande_combinee', 'comando_composito', 'rrr_Verbundsteuerung', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.log_card ADD CONSTRAINT fkey_vl_log_card_control_remote_control FOREIGN KEY (control_remote_control)
 REFERENCES tww_vl.log_card_control_remote_control (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.log_card_information_source () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.log_card_information_source ADD CONSTRAINT pkey_tww_vl_log_card_information_source_code PRIMARY KEY (code);
 INSERT INTO tww_vl.log_card_information_source (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5601,5601,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_information_source (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5604,5604,'gwdp_wwtp_catchment_area','GEP_ARA_Einzugsgebiet','bassin_versant_STEP', 'PGS_IDA_bacino_imbrifero', 'rrr_GEP_ARA_Einzugsgebiet', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_information_source (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5602,5602,'gwdp_responsible_body','GEP_Traegerschaft','entite_responsable_PGEE', 'PGS_ente_responsabile', 'rrr_GEP_Traegerschaft', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.log_card_information_source (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5603,5603,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.log_card ADD CONSTRAINT fkey_vl_log_card_information_source FOREIGN KEY (information_source)
 REFERENCES tww_vl.log_card_information_source (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_wastewater_networkelement_rw_current varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_rw_current FOREIGN KEY (fk_wastewater_networkelement_rw_current) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_wastewater_networkelement_rw_planned varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_rw_planned FOREIGN KEY (fk_wastewater_networkelement_rw_planned) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_wastewater_networkelement_ww_planned varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_ww_planned FOREIGN KEY (fk_wastewater_networkelement_ww_planned) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_wastewater_networkelement_ww_current varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_wastewater_networkelement_ww_current FOREIGN KEY (fk_wastewater_networkelement_ww_current) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_special_building_rw_planned varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_special_building_rw_planned FOREIGN KEY (fk_special_building_rw_planned) REFERENCES tww_od.log_card(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_special_building_rw_current varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_special_building_rw_current FOREIGN KEY (fk_special_building_rw_current) REFERENCES tww_od.log_card(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_special_building_ww_planned varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_special_building_ww_planned FOREIGN KEY (fk_special_building_ww_planned) REFERENCES tww_od.log_card(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area ADD COLUMN fk_special_building_ww_current varchar(16);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_catchment_area_special_building_ww_current FOREIGN KEY (fk_special_building_ww_current) REFERENCES tww_od.log_card(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.catchment_area_direct_discharge_current () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_direct_discharge_current ADD CONSTRAINT pkey_tww_vl_catchment_area_direct_discharge_current_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_direct_discharge_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5457,5457,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_direct_discharge_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5458,5458,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_direct_discharge_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5463,5463,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_direct_discharge_current FOREIGN KEY (direct_discharge_current)
 REFERENCES tww_vl.catchment_area_direct_discharge_current (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_direct_discharge_planned () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_direct_discharge_planned ADD CONSTRAINT pkey_tww_vl_catchment_area_direct_discharge_planned_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_direct_discharge_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5459,5459,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_direct_discharge_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5460,5460,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_direct_discharge_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5464,5464,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_direct_discharge_planned FOREIGN KEY (direct_discharge_planned)
 REFERENCES tww_vl.catchment_area_direct_discharge_planned (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_drainage_system_current () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_drainage_system_current ADD CONSTRAINT pkey_tww_vl_catchment_area_drainage_system_current_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9068,9068,'drainage_system','Drainagesystem','systeme_de_drainage', 'sistema_di_drenaggio', 'rrr_Drainagesystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5186,5186,'mixed_system','Mischsystem','systeme_unitaire', 'sistema_misto', 'rrr_Mischsystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5188,5188,'modified_system','ModifiziertesSystem','systeme_modifie', 'sistema_modificato', 'rrr_ModifiziertesSystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5185,5185,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5537,5537,'not_drained','nicht_entwaessert','non_evacue', 'non_evacuato', 'rrr_nicht_entwaessert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5187,5187,'separated_system','Trennsystem','systeme_separatif', 'sistema_separato', 'rrr_Trennsystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5189,5189,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8693,8693,'separated_system_in_preparation','vorbereitetes_Trennsystem','systeme_separatif_prepare', 'predisposizione_sistema_separato', 'rrr_vorbereitetes_Trennsystem', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_drainage_system_current FOREIGN KEY (drainage_system_current)
 REFERENCES tww_vl.catchment_area_drainage_system_current (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_drainage_system_planned () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_drainage_system_planned ADD CONSTRAINT pkey_tww_vl_catchment_area_drainage_system_planned_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9067,9067,'drainage_system','Drainagesystem','systeme_de_drainage', 'sistema_di_drenaggio', 'rrr_Drainagesystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5191,5191,'mixed_system','Mischsystem','systeme_unitaire', 'sistema_misto', 'rrr_Mischsystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5193,5193,'modified_system','ModifiziertesSystem','systeme_modifie', 'sistema_modificato', 'rrr_ModifiziertesSystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5194,5194,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5536,5536,'not_drained','nicht_entwaessert','non_evacue', 'non_evacuato', 'rrr_nicht_entwaessert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5192,5192,'separated_system','Trennsystem','systeme_separatif', 'sistema_separato', 'rrr_Trennsystem', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5195,5195,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_drainage_system_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8692,8692,'separated_system_in_preparation','vorbereitetes_Trennsystem','systeme_separatif_prepare', 'predisposizione_sistema_separato', 'rrr_vorbereitetes_Trennsystem', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_drainage_system_planned FOREIGN KEY (drainage_system_planned)
 REFERENCES tww_vl.catchment_area_drainage_system_planned (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_infiltration_current () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_infiltration_current ADD CONSTRAINT pkey_tww_vl_catchment_area_infiltration_current_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_infiltration_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5452,5452,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_infiltration_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5453,5453,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_infiltration_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5165,5165,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_infiltration_current FOREIGN KEY (infiltration_current)
 REFERENCES tww_vl.catchment_area_infiltration_current (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_infiltration_planned () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_infiltration_planned ADD CONSTRAINT pkey_tww_vl_catchment_area_infiltration_planned_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_infiltration_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5461,5461,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_infiltration_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5462,5462,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_infiltration_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5170,5170,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_infiltration_planned FOREIGN KEY (infiltration_planned)
 REFERENCES tww_vl.catchment_area_infiltration_planned (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_retention_current () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_retention_current ADD CONSTRAINT pkey_tww_vl_catchment_area_retention_current_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_retention_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5467,5467,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_retention_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5468,5468,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_retention_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5469,5469,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_retention_current FOREIGN KEY (retention_current)
 REFERENCES tww_vl.catchment_area_retention_current (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_retention_planned () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_retention_planned ADD CONSTRAINT pkey_tww_vl_catchment_area_retention_planned_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_retention_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5470,5470,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_retention_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5471,5471,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_retention_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5472,5472,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area ADD CONSTRAINT fkey_vl_catchment_area_retention_planned FOREIGN KEY (retention_planned)
 REFERENCES tww_vl.catchment_area_retention_planned (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.surface_runoff_parameters ADD COLUMN fk_catchment_area varchar(16);
ALTER TABLE tww_od.surface_runoff_parameters ADD CONSTRAINT rel_surface_runoff_parameters_catchment_area FOREIGN KEY (fk_catchment_area) REFERENCES tww_od.catchment_area(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.measuring_point ADD COLUMN fk_operator varchar(16);
ALTER TABLE tww_od.measuring_point ADD CONSTRAINT rel_measuring_point_operator FOREIGN KEY (fk_operator) REFERENCES tww_od.organisation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.measuring_point ADD COLUMN fk_waste_water_treatment_plant varchar(16);
ALTER TABLE tww_od.measuring_point ADD CONSTRAINT rel_measuring_point_waste_water_treatment_plant FOREIGN KEY (fk_waste_water_treatment_plant) REFERENCES tww_od.waste_water_treatment_plant(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.measuring_point ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.measuring_point ADD CONSTRAINT rel_measuring_point_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.measuring_point_damming_device () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measuring_point_damming_device ADD CONSTRAINT pkey_tww_vl_measuring_point_damming_device_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5720,5720,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5721,5721,'none','keiner','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5722,5722,'overflow_weir','Ueberfallwehr','lame_deversante', 'sfioratore', 'rrr_Ueberfallwehr', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5724,5724,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_damming_device (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5723,5723,'venturi_necking','Venturieinschnuerung','etranglement_venturi', 'restringimento_venturi', 'rrr_Venturieinschnuerung', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measuring_point ADD CONSTRAINT fkey_vl_measuring_point_damming_device FOREIGN KEY (damming_device)
 REFERENCES tww_vl.measuring_point_damming_device (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.measuring_point_purpose () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measuring_point_purpose ADD CONSTRAINT pkey_tww_vl_measuring_point_purpose_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4595,4595,'both','beides','les_deux', 'entrambi', 'rrr_beides', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4593,4593,'cost_sharing','Kostenverteilung','repartition_des_couts', 'ripartizione_costi', 'rrr_Kostenverteilung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4594,4594,'technical_purpose','technischer_Zweck','but_technique', 'scopo_tecnico', 'rrr_technischer_Zweck', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_point_purpose (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4592,4592,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measuring_point ADD CONSTRAINT fkey_vl_measuring_point_purpose FOREIGN KEY (purpose)
 REFERENCES tww_vl.measuring_point_purpose (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.measuring_device ADD COLUMN fk_measuring_point varchar(16);
ALTER TABLE tww_od.measuring_device ADD CONSTRAINT rel_measuring_device_measuring_point FOREIGN KEY (fk_measuring_point) REFERENCES tww_od.measuring_point(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.measuring_device_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measuring_device_kind ADD CONSTRAINT pkey_tww_vl_measuring_device_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5702,5702,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5703,5703,'static_sounding_stick','Drucksonde','sonde_de_pression', 'sensore_pressione', 'rrr_Drucksonde', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5704,5704,'bubbler_system','Lufteinperlung','injection_bulles_d_air', 'insufflazione', 'rrr_Lufteinperlung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5705,5705,'EMF_partly_filled','MID_teilgefuellt','MID_partiellement_rempli', 'MPE_parzialmente_riempito', 'rrr_MID_teilgefuellt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5706,5706,'EMF_filled','MID_vollgefuellt','MID_rempli', 'MPE_riempito', 'rrr_MID_vollgefuellt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5707,5707,'radar','Radar','radar', 'radar', 'radar', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5708,5708,'float','Schwimmer','flotteur', 'galleggiante', 'rrr_Schwimmer', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6322,6322,'ultrasound','Ultraschall','ultrason', 'ultrasuono', 'ultrasunete', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measuring_device_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5709,5709,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measuring_device ADD CONSTRAINT fkey_vl_measuring_device_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.measuring_device_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.measurement_series ADD COLUMN fk_measuring_point varchar(16);
ALTER TABLE tww_od.measurement_series ADD CONSTRAINT rel_measurement_series_measuring_point FOREIGN KEY (fk_measuring_point) REFERENCES tww_od.measuring_point(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.measurement_series ADD COLUMN fk_wastewater_networkelement varchar(16);
ALTER TABLE tww_od.measurement_series ADD CONSTRAINT rel_measurement_series_wastewater_networkelement FOREIGN KEY (fk_wastewater_networkelement) REFERENCES tww_od.wastewater_networkelement(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.measurement_series_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measurement_series_kind ADD CONSTRAINT pkey_tww_vl_measurement_series_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3217,3217,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2646,2646,'continuous','kontinuierlich','continu', 'zzz_kontinuierlich', 'rrr_kontinuierlich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2647,2647,'rain_weather','Regenwetter','temps_de_pluie', 'tempo_pioggia', 'rrr_Regenwetter', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8778,8778,'simulation','Simulation','simulation', 'simulazione', 'rrr_Simulation', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_series_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3053,3053,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measurement_series ADD CONSTRAINT fkey_vl_measurement_series_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.measurement_series_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.measurement_result ADD COLUMN fk_measuring_device varchar(16);
ALTER TABLE tww_od.measurement_result ADD CONSTRAINT rel_measurement_result_measuring_device FOREIGN KEY (fk_measuring_device) REFERENCES tww_od.measuring_device(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.measurement_result ADD COLUMN fk_measurement_series varchar(16);
ALTER TABLE tww_od.measurement_result ADD CONSTRAINT rel_measurement_result_measurement_series FOREIGN KEY (fk_measurement_series) REFERENCES tww_od.measurement_series(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.measurement_result_measurement_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.measurement_result_measurement_type ADD CONSTRAINT pkey_tww_vl_measurement_result_measurement_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5732,5732,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5733,5733,'flow','Durchfluss','debit', 'portata', 'rrr_Durchfluss', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5734,5734,'level','Niveau','niveau', 'livello', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.measurement_result_measurement_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5735,5735,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.measurement_result ADD CONSTRAINT fkey_vl_measurement_result_measurement_type FOREIGN KEY (measurement_type)
 REFERENCES tww_vl.measurement_result_measurement_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.overflow ADD COLUMN fk_wastewater_node varchar(16);
ALTER TABLE tww_od.overflow ADD CONSTRAINT rel_overflow_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE cascade DEFERRABLE;
ALTER TABLE tww_od.overflow ADD COLUMN fk_overflow_to varchar(16);
ALTER TABLE tww_od.overflow ADD CONSTRAINT rel_overflow_overflow_to FOREIGN KEY (fk_overflow_to) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE;
ALTER TABLE tww_od.overflow ADD COLUMN fk_overflow_char varchar(16);
ALTER TABLE tww_od.overflow ADD CONSTRAINT rel_overflow_overflow_char FOREIGN KEY (fk_overflow_char) REFERENCES tww_od.overflow_char(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE;
ALTER TABLE tww_od.overflow ADD COLUMN fk_control_center varchar(16);
ALTER TABLE tww_od.overflow ADD CONSTRAINT rel_overflow_control_center FOREIGN KEY (fk_control_center) REFERENCES tww_od.control_center(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE;
CREATE TABLE tww_vl.overflow_actuation () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.overflow_actuation ADD CONSTRAINT pkey_tww_vl_overflow_actuation_code PRIMARY KEY (code);
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3667,3667,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (301,301,'gaz_engine','Benzinmotor','moteur_a_essence', 'zzz_Benzinmotor', 'motor_benzina', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (302,302,'diesel_engine','Dieselmotor','moteur_diesel', 'zzz_Dieselmotor', 'motor_diesel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (303,303,'electric_engine','Elektromotor','moteur_electrique', 'zzz_Elektromotor', 'motor_electric', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (433,433,'hydraulic','hydraulisch','hydraulique', 'zzz_hydraulisch', 'hidraulic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (300,300,'none','keiner','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (305,305,'manual','manuell','manuel', 'zzz_manuell', 'manual', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (304,304,'pneumatic','pneumatisch','pneumatique', 'zzz_pneumatisch', 'pneumatic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3005,3005,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.overflow ADD CONSTRAINT fkey_vl_overflow_actuation FOREIGN KEY (actuation)
 REFERENCES tww_vl.overflow_actuation (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.overflow_adjustability () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.overflow_adjustability ADD CONSTRAINT pkey_tww_vl_overflow_adjustability_code PRIMARY KEY (code);
 INSERT INTO tww_vl.overflow_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (355,355,'fixed','fest','fixe', 'zzz_fest', 'rrr_fix', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3021,3021,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (356,356,'adjustable','verstellbar','reglable', 'zzz_verstellbar', 'rrr_verstellbar', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.overflow ADD CONSTRAINT fkey_vl_overflow_adjustability FOREIGN KEY (adjustability)
 REFERENCES tww_vl.overflow_adjustability (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.overflow_control () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.overflow_control ADD CONSTRAINT pkey_tww_vl_overflow_control_code PRIMARY KEY (code);
 INSERT INTO tww_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (308,308,'closed_loop_control','geregelt','avec_regulation', 'zzz_geregelt', 'rrr_geregelt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (307,307,'open_loop_control','gesteuert','avec_commande', 'zzz_gesteuert', 'rrr_gesteuert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (306,306,'none','keine','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3028,3028,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.overflow ADD CONSTRAINT fkey_vl_overflow_control FOREIGN KEY (control)
 REFERENCES tww_vl.overflow_control (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.overflow_function () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.overflow_function ADD CONSTRAINT pkey_tww_vl_overflow_function_code PRIMARY KEY (code);
 INSERT INTO tww_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3228,3228,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3384,3384,'internal','intern','interne', 'zzz_intern', 'rrr_intern', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (217,217,'emergency_overflow','Notentlastung','deversoir_de_secours', 'scarico_emergenza', 'rrr_Notentlastung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5544,5544,'stormwater_overflow','Regenueberlauf','deversoir_d_orage', 'scaricatore_piena', 'preaplin', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5546,5546,'internal_overflow','Trennueberlauf','deversoir_interne', 'zzz_Trennueberlauf', 'rrr_Trennueberlauf', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3010,3010,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.overflow ADD CONSTRAINT fkey_vl_overflow_function FOREIGN KEY (function)
 REFERENCES tww_vl.overflow_function (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.overflow_signal_transmission () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.overflow_signal_transmission ADD CONSTRAINT pkey_tww_vl_overflow_signal_transmission_code PRIMARY KEY (code);
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2694,2694,'receiving','empfangen','recevoir', 'zzz_empfangen', 'rrr_empfangen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2693,2693,'sending','senden','emettre', 'zzz_senden', 'rrr_senden', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2695,2695,'sending_receiving','senden_empfangen','emettre_recevoir', 'zzz_senden_empfangen', 'rrr_senden_empfangen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.overflow_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3056,3056,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.overflow ADD CONSTRAINT fkey_vl_overflow_signal_transmission FOREIGN KEY (signal_transmission)
 REFERENCES tww_vl.overflow_signal_transmission (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN fk_wastewater_node varchar(16);
ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT rel_throttle_shut_off_unit_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE cascade;
ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN fk_control_center varchar(16);
ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT rel_throttle_shut_off_unit_control_center FOREIGN KEY (fk_control_center) REFERENCES tww_od.control_center(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.throttle_shut_off_unit ADD COLUMN fk_overflow varchar(16);
ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT rel_throttle_shut_off_unit_overflow FOREIGN KEY (fk_overflow) REFERENCES tww_od.overflow(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.throttle_shut_off_unit_actuation () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.throttle_shut_off_unit_actuation ADD CONSTRAINT pkey_tww_vl_throttle_shut_off_unit_actuation_code PRIMARY KEY (code);
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3213,3213,'other','andere','autres', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3154,3154,'gaz_engine','Benzinmotor','moteur_a_essence', 'zzz_Benzinmotor', 'motor_benzina', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3155,3155,'diesel_engine','Dieselmotor','moteur_diesel', 'zzz_Dieselmotor', 'motor_diesel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3156,3156,'electric_engine','Elektromotor','moteur_electrique', 'zzz_Elektromotor', 'motor_electric', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3152,3152,'hydraulic','hydraulisch','hydraulique', 'zzz_hydraulisch', 'hidraulic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3153,3153,'none','keiner','aucun', 'nessuno', 'niciunul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3157,3157,'manual','manuell','manuel', 'zzz_manuell', 'manual', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3158,3158,'pneumatic','pneumatisch','pneumatique', 'zzz_pneumatisch', 'pneumatic', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3151,3151,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscut', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_actuation FOREIGN KEY (actuation)
 REFERENCES tww_vl.throttle_shut_off_unit_actuation (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.throttle_shut_off_unit_adjustability () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.throttle_shut_off_unit_adjustability ADD CONSTRAINT pkey_tww_vl_throttle_shut_off_unit_adjustability_code PRIMARY KEY (code);
 INSERT INTO tww_vl.throttle_shut_off_unit_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3159,3159,'fixed','fest','fixe', 'zzz_fest', 'rrr_fix', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3161,3161,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_adjustability (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3160,3160,'adjustable','verstellbar','reglable', 'zzz_verstellbar', 'rrr_verstellbar', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_adjustability FOREIGN KEY (adjustability)
 REFERENCES tww_vl.throttle_shut_off_unit_adjustability (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.throttle_shut_off_unit_control () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.throttle_shut_off_unit_control ADD CONSTRAINT pkey_tww_vl_throttle_shut_off_unit_control_code PRIMARY KEY (code);
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3162,3162,'closed_loop_control','geregelt','avec_regulation', 'zzz_geregelt', 'rrr_geregelt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3163,3163,'open_loop_control','gesteuert','avec_commande', 'zzz_gesteuert', 'rrr_gesteuert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3165,3165,'none','keine','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_control (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3164,3164,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_control FOREIGN KEY (control)
 REFERENCES tww_vl.throttle_shut_off_unit_control (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.throttle_shut_off_unit_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.throttle_shut_off_unit_kind ADD CONSTRAINT pkey_tww_vl_throttle_shut_off_unit_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2973,2973,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2746,2746,'orifice','Blende','diaphragme_ou_seuil', 'zzz_Blende', 'diafragma_sau_prag', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2691,2691,'stop_log','Dammbalken','batardeau', 'zzz_Dammbalken', 'rrr_Dammbalken', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (252,252,'throttle_flap','Drosselklappe','clapet_de_limitation', 'zzz_Drosselklappe', 'rrr_Drosselklappe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (135,135,'throttle_valve','Drosselschieber','vanne_de_limitation', 'zzz_Drosselschieber', 'rrr_Drosselschieber', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6490,6490,'throttle_section','Drosselstrecke','conduite_d_etranglement', 'tratta_regolazione', 'rrr_Drosselstrecke', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6491,6491,'leapingweir','Leapingwehr','leaping_weir', 'leaping_weir', 'rrr_Leapingwehr', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6492,6492,'pomp','Pumpe','pompe', 'pompa', 'rrr_Pumpe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2690,2690,'backflow_flap','Rueckstauklappe','clapet_de_non_retour_a_battant', 'clappa_anti_rigurgito', 'clapeta _antirefulare', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2688,2688,'valve','Schieber','vanne', 'saracinesca', 'rrr_Schieber', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (134,134,'tube_throttle','Schlauchdrossel','limiteur_a_membrane', 'zzz_Schlauchdrossel', 'rrr_Schlauchdrossel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2689,2689,'sliding_valve','Schuetze','vanne_ecluse', 'zzz_Schuetze', 'vana_cu?it', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5755,5755,'gate_shield','Stauschild','plaque_de_retenue', 'paratoia_cilindrica', 'rrr_Stauschild', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3046,3046,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (133,133,'whirl_throttle','Wirbeldrossel','limiteur_a_vortex', 'zzz_Wirbeldrossel', 'rrr_Wirbeldrossel', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.throttle_shut_off_unit_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.throttle_shut_off_unit_signal_transmission () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.throttle_shut_off_unit_signal_transmission ADD CONSTRAINT pkey_tww_vl_throttle_shut_off_unit_signal_transmission_code PRIMARY KEY (code);
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3171,3171,'receiving','empfangen','recevoir', 'zzz_empfangen', 'rrr_empfangen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3172,3172,'sending','senden','emettre', 'zzz_senden', 'rrr_senden', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3169,3169,'sending_receiving','senden_empfangen','emettre_recevoir', 'zzz_senden_empfangen', 'rrr_senden_empfangen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.throttle_shut_off_unit_signal_transmission (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3170,3170,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT fkey_vl_throttle_shut_off_unit_signal_transmission FOREIGN KEY (signal_transmission)
 REFERENCES tww_vl.throttle_shut_off_unit_signal_transmission (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.prank_weir ADD CONSTRAINT oorel_od_prank_weir_overflow FOREIGN KEY (obj_id) REFERENCES tww_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.prank_weir_weir_edge () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.prank_weir_weir_edge ADD CONSTRAINT pkey_tww_vl_prank_weir_weir_edge_code PRIMARY KEY (code);
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2995,2995,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (351,351,'rectangular','rechteckig','angulaire', 'zzz_rechteckig', 'rrr_rechteckig', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (350,350,'round','rund','arrondie', 'zzz_rund', 'rotund', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (349,349,'sharp_edged','scharfkantig','arete_vive', 'zzz_scharfkantig', 'margini_ascutite', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.prank_weir_weir_edge (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3014,3014,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.prank_weir ADD CONSTRAINT fkey_vl_prank_weir_weir_edge FOREIGN KEY (weir_edge)
 REFERENCES tww_vl.prank_weir_weir_edge (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.prank_weir_weir_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.prank_weir_weir_kind ADD CONSTRAINT pkey_tww_vl_prank_weir_weir_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.prank_weir_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5772,5772,'raised','hochgezogen','a_seuil_sureleve', 'laterale_alto', 'rrr_hochgezogen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.prank_weir_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5771,5771,'low','niedrig','a_seuil_abaisse', 'laterale_basso', '', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.prank_weir ADD CONSTRAINT fkey_vl_prank_weir_weir_kind FOREIGN KEY (weir_kind)
 REFERENCES tww_vl.prank_weir_weir_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.pump ADD CONSTRAINT oorel_od_pump_overflow FOREIGN KEY (obj_id) REFERENCES tww_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.pump_construction_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.pump_construction_type ADD CONSTRAINT pkey_tww_vl_pump_construction_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2983,2983,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2662,2662,'compressed_air_system','Druckluftanlage','systeme_a_air_comprime', 'impianto_aria_compressa', 'rrr_Druckluftanlage', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (314,314,'piston_pump','Kolbenpumpe','pompe_a_piston', 'pompa_pistoni', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (309,309,'centrifugal_pump','Kreiselpumpe','pompe_centrifuge', 'pompa_centrifuga', 'rrr_Kreiselpumpe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (310,310,'screw_pump','Schneckenpumpe','pompe_a_vis', 'pompa_a_vite', 'rrr_Schneckenpumpe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3082,3082,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_construction_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (2661,2661,'vacuum_system','Vakuumanlage','systeme_a_vide_d_air', 'impinato_a_vuoto_aria', 'rrr_Vakuumanlage', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.pump ADD CONSTRAINT fkey_vl_pump_construction_type FOREIGN KEY (construction_type)
 REFERENCES tww_vl.pump_construction_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.pump_placement_of_actuation () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.pump_placement_of_actuation ADD CONSTRAINT pkey_tww_vl_pump_placement_of_actuation_code PRIMARY KEY (code);
 INSERT INTO tww_vl.pump_placement_of_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (318,318,'wet','nass','immerge', 'zzz_nass', 'rrr_nass', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_placement_of_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (311,311,'dry','trocken','non_submersible', 'zzz_trocken', 'rrr_trocken', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_placement_of_actuation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3070,3070,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.pump ADD CONSTRAINT fkey_vl_pump_placement_of_actuation FOREIGN KEY (placement_of_actuation)
 REFERENCES tww_vl.pump_placement_of_actuation (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.pump_placement_of_pump () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.pump_placement_of_pump ADD CONSTRAINT pkey_tww_vl_pump_placement_of_pump_code PRIMARY KEY (code);
 INSERT INTO tww_vl.pump_placement_of_pump (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (362,362,'horizontal','horizontal','horizontal', 'zzz_horizontal', 'rrr_horizontal', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_placement_of_pump (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3071,3071,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.pump_placement_of_pump (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (363,363,'vertical','vertikal','vertical', 'zzz_vertikal', 'rrr_vertikal', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.pump ADD CONSTRAINT fkey_vl_pump_placement_of_pump FOREIGN KEY (placement_of_pump)
 REFERENCES tww_vl.pump_placement_of_pump (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.leapingweir ADD CONSTRAINT oorel_od_leapingweir_overflow FOREIGN KEY (obj_id) REFERENCES tww_od.overflow(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.leapingweir_opening_shape () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.leapingweir_opening_shape ADD CONSTRAINT pkey_tww_vl_leapingweir_opening_shape_code PRIMARY KEY (code);
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3581,3581,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3582,3582,'circle','Kreis','circulaire', 'zzz_Kreis', 'rrr_Kreis', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3585,3585,'parable','Parabel','parabolique', 'zzz_Parabel', 'rrr_Parabel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3583,3583,'rectangular','Rechteck','rectangulaire', 'zzz_Rechteck', 'rrr_Rechteck', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.leapingweir_opening_shape (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (3584,3584,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.leapingweir ADD CONSTRAINT fkey_vl_leapingweir_opening_shape FOREIGN KEY (opening_shape)
 REFERENCES tww_vl.leapingweir_opening_shape (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.maintenance ADD CONSTRAINT oorel_od_maintenance_maintenance_event FOREIGN KEY (obj_id) REFERENCES tww_od.maintenance_event(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.maintenance_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.maintenance_kind ADD CONSTRAINT pkey_tww_vl_maintenance_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9308,9308,'other','andere','autre', 'altro', 'altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9309,9309,'cleaning','Reinigung','nettoyage', 'pulizia', 'rrr_Reinigung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9310,9310,'restoration_replacement','Sanierung_Erneuerung','rehabilitation_renouvellement', 'risanamento_sostituzione', 'rrr_Sanierung_Erneuerung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9311,9311,'restoration_renovation','Sanierung_Renovierung','rehabilitation_renovation', 'risanamento_rinnovamento', 'rrr_Sanierung_Renovierung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9312,9312,'restoration_repair','Sanierung_Reparatur','rehabilitation_reparation', 'risanamento_riparazione', 'rrr_Sanierung_Reparatur', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9313,9313,'restoration_unknown','Sanierung_unbekannt','rehabilitation_inconnue', 'risanamento_sconosciuto', 'rrr_Sanierung_unbekannt', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9314,9314,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.maintenance_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9315,9315,'examination','Untersuchung','examen', 'zzz_Untersuchung', 'rrr_Untersuchung', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.maintenance ADD CONSTRAINT fkey_vl_maintenance_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.maintenance_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT oorel_od_bio_ecol_assessment_maintenance_event FOREIGN KEY (obj_id) REFERENCES tww_od.maintenance_event(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.bio_ecol_assessment_comparison_last () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_comparison_last ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_comparison_last_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5896,5896,'equal','gleich','egal', 'uguale', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6328,6328,'no_comparison_possible','kein_Vergleich_moeglich','aucune_comparaison_possible', 'confronto_non_possibile', 'rrr_kein_Vergleich_moeglich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8572,8572,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6271,6271,'unclear','unklar','pas_clair', 'non_chiaro', 'rrr_unklar', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6269,6269,'improvement','Verbesserung','amelioration', 'miglioramento', 'rrrr_Verbesserung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_comparison_last (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6270,6270,'worsening','Verschlechterung','deterioration', 'peggioramento', 'rrr_Verschlechterung', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_comparison_last FOREIGN KEY (comparison_last)
 REFERENCES tww_vl.bio_ecol_assessment_comparison_last (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_impact_auxiliary_indic () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_impact_auxiliary_indic ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_impact_auxiliary_indic_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8687,8687,'big','gross','elevee', 'grande', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8685,8685,'none_or_small','kein_klein','aucune_petite', 'nessuno_piccolo', 'rrr_kein_klein', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8689,8689,'no_conclusion_possible','keine_Aussage_moeglich','aucun_avis_possible', 'giudizio_non_possibile', 'rrr_keine_Aussage_moeglich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8686,8686,'moderate','mittel','moyen', 'medio', 'rrr_mittel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8690,8690,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8688,8688,'unclear','unklar','pas_clair', 'non_chiaro', 'rrr_unklar', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_impact_auxiliary_indic FOREIGN KEY (impact_auxiliary_indic)
 REFERENCES tww_vl.bio_ecol_assessment_impact_auxiliary_indic (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_impact_external_aspect () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_impact_external_aspect ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_impact_external_aspect_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8666,8666,'big','gross','elevee', 'grande', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8664,8664,'none','kein','aucun', 'nessuno', 'niciun', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8668,8668,'no_conclusion_possible','keine_Aussage_moeglich','aucun_avis_possible', 'giudizio_non_possibile', 'rrr_keine_Aussage_moeglich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8665,8665,'small_medium','klein_mittel','faible_moyenne', 'medio_piccolo', 'rrr_klein_mittel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8669,8669,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_external_aspect (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8667,8667,'unclear','unklar','pas_clair', 'non_chiaro', 'rrr_unklar', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_impact_external_aspect FOREIGN KEY (impact_external_aspect)
 REFERENCES tww_vl.bio_ecol_assessment_impact_external_aspect (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_impact_macroinvertebrates () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_impact_macroinvertebrates ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_impact_macroinvertebrates_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8673,8673,'big','gross','elevee', 'grande', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8671,8671,'none_or_small','kein_klein','aucune_petite', 'nessuno_piccolo', 'rrr_kein_klein', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8675,8675,'no_conclusion_possible','keine_Aussage_moeglich','aucun_avis_possible', 'giudizio_non_possibile', 'rrr_keine_Aussage_moeglich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8672,8672,'moderate','mittel','moyen', 'medio', 'rrr_mittel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8676,8676,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8674,8674,'unclear','unklar','pas_clair', 'non_chiaro', 'rrr_unklar', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_impact_macroinvertebrates FOREIGN KEY (impact_macroinvertebrates)
 REFERENCES tww_vl.bio_ecol_assessment_impact_macroinvertebrates (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_impact_water_plants () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_impact_water_plants ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_impact_water_plants_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8680,8680,'big','gross','elevee', 'grande', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8678,8678,'none_or_small','kein_klein','aucune_petite', 'nessuno_piccolo', 'rrr_kein_klein', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8682,8682,'no_conclusion_possible','keine_Aussage_moeglich','aucun_avis_possible', 'giudizio_non_possibile', 'rrr_keine_Aussage_moeglich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8679,8679,'moderate','mittel','moyen', 'medio', 'rrr_mittel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8683,8683,'unknown','unbekannt','inconnue', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_impact_water_plants (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8681,8681,'unclear','unklar','pas_clair', 'non_chiaro', 'rrr_unklar', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_impact_water_plants FOREIGN KEY (impact_water_plants)
 REFERENCES tww_vl.bio_ecol_assessment_impact_water_plants (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_intervention_demand () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_intervention_demand ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_intervention_demand_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5945,5945,'yes_short_term','ja_kurzfristig','oui_a_court_terme', 'si_corto_termine', 'rrr_ja_kurzfristig', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6272,6272,'yes_long_term','ja_laengerfristig','oui_a_long_terme', 'si_lungo_termine', 'rrr_ja_laengerfristig', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8695,8695,'no_conclusion_possible','keine_Aussage_moeglich','aucun_avis_possible', 'giudizio_non_possibile', 'nicio_declaratie_posibila', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5944,5944,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_intervention_demand (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9093,9093,'clarify_status','Status_klaeren','clarifier_statut', 'chiarire_stato', 'rrr_Status_klaeren', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_intervention_demand FOREIGN KEY (intervention_demand)
 REFERENCES tww_vl.bio_ecol_assessment_intervention_demand (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_io_calculation () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_io_calculation ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_io_calculation_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_io_calculation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5953,5953,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_io_calculation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5952,5952,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_io_calculation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5954,5954,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_io_calculation FOREIGN KEY (io_calculation)
 REFERENCES tww_vl.bio_ecol_assessment_io_calculation (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_relevance_matrix () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_relevance_matrix ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_relevance_matrix_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_relevance_matrix (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5949,5949,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_relevance_matrix (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5948,5948,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_relevance_matrix (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5950,5950,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_relevance_matrix FOREIGN KEY (relevance_matrix)
 REFERENCES tww_vl.bio_ecol_assessment_relevance_matrix (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.bio_ecol_assessment_type_water_body () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.bio_ecol_assessment_type_water_body ADD CONSTRAINT pkey_tww_vl_bio_ecol_assessment_type_water_body_code PRIMARY KEY (code);
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8492,8492,'river_backwater','Fluss_Stau','retention', 'corso_d_acqua_di_accummulo', 'rrr_Fluss_Stau', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5884,5884,'large_river','Groesseres_Fliessgewaesser','gros_cours_d_eau', 'grosso_fiume', 'rrr_Groesseres_Fliessgewaesser', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5883,5883,'large_midland_creek','Grosser_Mittellandbach','gros_ruisseau_du_Plateau', 'grande_corso_d_acqua_dell_altopiano', 'rrr_Grosser_Mittellandbach', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5885,5885,'large_prealps_creek','Grosser_Voralpenbach','gros_ruisseau_des_Prealpes', 'grande_corso_d_acqua_prealpino', 'rrr_Grosser_Voralpenbach', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8491,8491,'very_large_river','Grosses_Fliessgewaesser','tres_gros_cours_d_eau', 'fiume_molto_grande', 'rrr_Grosses_Fliessgewaesser', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5886,5886,'small_midland_creek','Kleiner_Mittellandbach','petit_ruisseau_du_Plateau', 'piccolo_corso_d_acqua_dell_altopiano', 'rrr_Kleiner_Mittellandbach', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5887,5887,'small_prealps_creek','Kleiner_Voralpenbach','petit_ruisseau_des_Prealpes', 'piccolo_corso_d_acqua_prealpino', 'rrr_Kleiner_Voralpenbach', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5888,5888,'spring_waters','Quellgewaesser','region_de_source', 'acque_sorgive', 'rrr_Quellgewaesser', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9149,9149,'lake','See','lac', 'lago', 'rrr_See', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.bio_ecol_assessment_type_water_body (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5890,5890,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.bio_ecol_assessment ADD CONSTRAINT fkey_vl_bio_ecol_assessment_type_water_body FOREIGN KEY (type_water_body)
 REFERENCES tww_vl.bio_ecol_assessment_type_water_body (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN fk_wastewater_node varchar(16);
ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT rel_hydraulic_char_data_wastewater_node FOREIGN KEY (fk_wastewater_node) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN fk_overflow_char varchar(16);
ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT rel_hydraulic_char_data_overflow_char FOREIGN KEY (fk_overflow_char) REFERENCES tww_od.overflow_char(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.hydraulic_char_data ADD COLUMN fk_primary_direction varchar(16);
ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT rel_hydraulic_char_data_primary_direction FOREIGN KEY (fk_primary_direction) REFERENCES tww_od.wastewater_node(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.hydraulic_char_data_is_overflowing () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.hydraulic_char_data_is_overflowing ADD CONSTRAINT pkey_tww_vl_hydraulic_char_data_is_overflowing_code PRIMARY KEY (code);
 INSERT INTO tww_vl.hydraulic_char_data_is_overflowing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5774,5774,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_is_overflowing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5775,5775,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_is_overflowing (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5778,5778,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_is_overflowing FOREIGN KEY (is_overflowing)
 REFERENCES tww_vl.hydraulic_char_data_is_overflowing (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.hydraulic_char_data_main_weir_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.hydraulic_char_data_main_weir_kind ADD CONSTRAINT pkey_tww_vl_hydraulic_char_data_main_weir_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.hydraulic_char_data_main_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6422,6422,'leapingweir','Leapingwehr','LEAPING_WEIR', 'leaping_weir', 'rrr_Leapingwehr', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_main_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6420,6420,'prank_weir_raised','Streichwehr_hochgezogen','deversoir_lateral_a_seuil_sureleve', 'stramazzo_laterale_alto', 'rrr_Streichwehr_hochgezogen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_main_weir_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6421,6421,'prank_weir_low','Streichwehr_niedrig','deversoir_lateral_a_seuil_abaisse', 'stamazzo_laterale_basso', 'rrr_Streichwehr_niedrig', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_main_weir_kind FOREIGN KEY (main_weir_kind)
 REFERENCES tww_vl.hydraulic_char_data_main_weir_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.hydraulic_char_data_pump_characteristics () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.hydraulic_char_data_pump_characteristics ADD CONSTRAINT pkey_tww_vl_hydraulic_char_data_pump_characteristics_code PRIMARY KEY (code);
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6374,6374,'alternating','alternierend','alterne', 'alternato', 'rrr_alternierend', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6375,6375,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6376,6376,'single','einzeln','individuel', 'singolo', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6377,6377,'parallel','parallel','parallele', 'parallelo', 'rrr_parallel', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_pump_characteristics (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6378,6378,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_pump_characteristics FOREIGN KEY (pump_characteristics)
 REFERENCES tww_vl.hydraulic_char_data_pump_characteristics (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.hydraulic_char_data_status () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.hydraulic_char_data_status ADD CONSTRAINT pkey_tww_vl_hydraulic_char_data_status_code PRIMARY KEY (code);
 INSERT INTO tww_vl.hydraulic_char_data_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6371,6371,'planned','geplant','prevu', 'pianificato', 'rrr_geplant', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6372,6372,'current','Ist','actuel', 'attuale', 'rrr_Ist', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.hydraulic_char_data_status (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6373,6373,'current_optimized','Ist_optimiert','actuel_opt', 'attuale_ottimizzato', 'rrr_Ist_optimiert', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT fkey_vl_hydraulic_char_data_status FOREIGN KEY (status)
 REFERENCES tww_vl.hydraulic_char_data_status (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.backflow_prevention ADD COLUMN fk_throttle_shut_off_unit varchar(16);
ALTER TABLE tww_od.backflow_prevention ADD CONSTRAINT rel_backflow_prevention_throttle_shut_off_unit FOREIGN KEY (fk_throttle_shut_off_unit) REFERENCES tww_od.throttle_shut_off_unit(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.backflow_prevention ADD COLUMN fk_pump varchar(16);
ALTER TABLE tww_od.backflow_prevention ADD CONSTRAINT rel_backflow_prevention_pump FOREIGN KEY (fk_pump) REFERENCES tww_od.pump(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.backflow_prevention ADD CONSTRAINT oorel_od_backflow_prevention_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.backflow_prevention_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.backflow_prevention_kind ADD CONSTRAINT pkey_tww_vl_backflow_prevention_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5760,5760,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5759,5759,'pump','Pumpe','pompe', 'pompa', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5757,5757,'backflow_flap','Rueckstauklappe','clapet_de_non_retour_a_battant', 'clappa_anti_rigurgito', 'clapeta _antirefulare', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5758,5758,'gate_shield','Stauschild','plaque_de_retenue', 'paratoia_cilindrica', 'rrr_Stauschild', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.backflow_prevention_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8636,8636,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.backflow_prevention ADD CONSTRAINT fkey_vl_backflow_prevention_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.backflow_prevention_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.solids_retention ADD CONSTRAINT oorel_od_solids_retention_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.solids_retention_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.solids_retention_type ADD CONSTRAINT pkey_tww_vl_solids_retention_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5664,5664,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8624,8624,'brush_rakes','Buerstenrechen','degrilleur_a_brosses', 'Ranghinatori_a_spazzola', 'rrr_Buerstenrechen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5665,5665,'fine_screen','Feinrechen','grille_fine', 'griglia_fine', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5666,5666,'coarse_screen','Grobrechen','grille_grossiere', 'griglia_grossa', 'rrr_Grobrechen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5667,5667,'sieve','Sieb','tamis', 'filtro', 'rrr_Sieb', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8625,8625,'gate_shield','Stauschild','plaque_de_retenue', 'paratoia_cilindrica', 'rrr_Stauschild', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5668,5668,'scumboard','Tauchwand','paroi_plongeante', 'parete_sommersa', 'rrr_Tauchwand', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.solids_retention_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5669,5669,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.solids_retention ADD CONSTRAINT fkey_vl_solids_retention_type FOREIGN KEY (type)
 REFERENCES tww_vl.solids_retention_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.tank_cleaning ADD CONSTRAINT oorel_od_tank_cleaning_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.tank_cleaning_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.tank_cleaning_type ADD CONSTRAINT pkey_tww_vl_tank_cleaning_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5621,5621,'airjet','Air_Jet','aeration_et_brassage', 'airjet', 'rrr_Air_Jet', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5620,5620,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8621,8621,'scraper_installation','Raeumereinrichtung','dispositif_de_curage', 'zzz_Raeumereinrichtung', 'rrr_Raeumereinrichtung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8622,8622,'agitator','Ruehrwerk','agitateur', 'agitatore', 'rrr_Ruehrwerk', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8623,8623,'meandered_gutter','Schlaengelrinne','cunette_courbe', 'cunetta_curva', 'rrr_Schlaengelrinne', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5623,5623,'surge_flushing','Schwallspuelung','rincage_en_cascade', 'lavaggio_getto', 'rrr_Schwallspülung', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5624,5624,'tipping_bucket','Spuelkippe','bac_de_rincage', 'benna_ribaltabile', 'rrr_Spuelkippe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_cleaning_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8626,8626,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.tank_cleaning ADD CONSTRAINT fkey_vl_tank_cleaning_type FOREIGN KEY (type)
 REFERENCES tww_vl.tank_cleaning_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.tank_emptying ADD COLUMN fk_throttle_shut_off_unit varchar(16);
ALTER TABLE tww_od.tank_emptying ADD CONSTRAINT rel_tank_emptying_throttle_shut_off_unit FOREIGN KEY (fk_throttle_shut_off_unit) REFERENCES tww_od.throttle_shut_off_unit(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.tank_emptying ADD COLUMN fk_overflow varchar(16);
ALTER TABLE tww_od.tank_emptying ADD CONSTRAINT rel_tank_emptying_overflow FOREIGN KEY (fk_overflow) REFERENCES tww_od.pump(obj_id) ON UPDATE CASCADE ON DELETE set null DEFERRABLE;
ALTER TABLE tww_od.tank_emptying ADD CONSTRAINT oorel_od_tank_emptying_structure_part FOREIGN KEY (obj_id) REFERENCES tww_od.structure_part(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.tank_emptying_type () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.tank_emptying_type ADD CONSTRAINT pkey_tww_vl_tank_emptying_type_code PRIMARY KEY (code);
 INSERT INTO tww_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5626,5626,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8638,8638,'gravitation','Gravitation','gravitation', 'gravitazione', 'rrr_Gravitation', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5628,5628,'pump','Pumpe','pompe', 'pompa', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5629,5629,'valve','Schieber','vanne', 'saracinesca', 'rrr_Schieber', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.tank_emptying_type (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8637,8637,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.tank_emptying ADD CONSTRAINT fkey_vl_tank_emptying_type FOREIGN KEY (type)
 REFERENCES tww_vl.tank_emptying_type (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.catchment_area_totals ADD COLUMN fk_discharge_point varchar(16);
ALTER TABLE tww_od.catchment_area_totals ADD CONSTRAINT rel_catchment_area_totals_discharge_point FOREIGN KEY (fk_discharge_point) REFERENCES tww_od.discharge_point(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.catchment_area_totals ADD COLUMN fk_hydraulic_char_data varchar(16);
ALTER TABLE tww_od.catchment_area_totals ADD CONSTRAINT rel_catchment_area_totals_hydraulic_char_data FOREIGN KEY (fk_hydraulic_char_data) REFERENCES tww_od.hydraulic_char_data(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.param_ca_general ADD CONSTRAINT oorel_od_param_ca_general_surface_runoff_parameters FOREIGN KEY (obj_id) REFERENCES tww_od.surface_runoff_parameters(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.param_ca_mouse1 ADD CONSTRAINT oorel_od_param_ca_mouse1_surface_runoff_parameters FOREIGN KEY (obj_id) REFERENCES tww_od.surface_runoff_parameters(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE tww_od.disposal ADD COLUMN fk_infiltration_installation varchar(16);
ALTER TABLE tww_od.disposal ADD CONSTRAINT rel_disposal_infiltration_installation FOREIGN KEY (fk_infiltration_installation) REFERENCES tww_od.infiltration_installation(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.disposal ADD COLUMN fk_discharge_point varchar(16);
ALTER TABLE tww_od.disposal ADD CONSTRAINT rel_disposal_discharge_point FOREIGN KEY (fk_discharge_point) REFERENCES tww_od.discharge_point(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.disposal ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.disposal ADD CONSTRAINT rel_disposal_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.disposal_disposal_place_current () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.disposal_disposal_place_current ADD CONSTRAINT pkey_tww_vl_disposal_disposal_place_current_code PRIMARY KEY (code);
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4949,4949,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4946,4946,'liquid_manure_application','Guelleaustrag','epandage', 'zzz_Guelleaustrag', 'rrr_Guelleaustrag', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6474,6474,'none','keiner','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4947,4947,'public_sewer','oeffentlicheKanalisation','canalisation_publique', 'zzz_oeffentlicheKanalisation', 'rrr_oeffentlicheKanalisation', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4945,4945,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_current (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4948,4948,'central_WWTP','zentraleARA','STEP_centrale', 'zzz_zentraleARA', 'rrr_zentraleARA', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.disposal ADD CONSTRAINT fkey_vl_disposal_disposal_place_current FOREIGN KEY (disposal_place_current)
 REFERENCES tww_vl.disposal_disposal_place_current (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.disposal_disposal_place_planned () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.disposal_disposal_place_planned ADD CONSTRAINT pkey_tww_vl_disposal_disposal_place_planned_code PRIMARY KEY (code);
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4954,4954,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4951,4951,'liquid_manure_application','Guelleaustrag','epandage', 'zzz_Guelleaustrag', 'rrr_Guelleaustrag', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6400,6400,'none','keiner','aucun', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4952,4952,'public_sewer','oeffentlicheKanalisation','canalisation_publique', 'zzz_oeffentlicheKanalisation', 'rrr_oeffentlicheKanalisation', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4950,4950,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.disposal_disposal_place_planned (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4953,4953,'central_WWTP','zentraleARA','STEP_centrale', 'zzz_zentraleARA', 'rrr_zentraleARA', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.disposal ADD CONSTRAINT fkey_vl_disposal_disposal_place_planned FOREIGN KEY (disposal_place_planned)
 REFERENCES tww_vl.disposal_disposal_place_planned (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.building_group ADD COLUMN fk_disposal varchar(16);
ALTER TABLE tww_od.building_group ADD CONSTRAINT rel_building_group_disposal FOREIGN KEY (fk_disposal) REFERENCES tww_od.disposal(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.building_group ADD COLUMN fk_measure varchar(16);
ALTER TABLE tww_od.building_group ADD CONSTRAINT rel_building_group_measure FOREIGN KEY (fk_measure) REFERENCES tww_od.measure(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE tww_vl.building_group_connecting_obligation () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_connecting_obligation ADD CONSTRAINT pkey_tww_vl_building_group_connecting_obligation_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_connecting_obligation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5484,5484,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_connecting_obligation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5485,5485,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_connecting_obligation (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5486,5486,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_connecting_obligation FOREIGN KEY (connecting_obligation)
 REFERENCES tww_vl.building_group_connecting_obligation (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_connection_wwtp () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_connection_wwtp ADD CONSTRAINT pkey_tww_vl_building_group_connection_wwtp_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_connection_wwtp (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5095,5095,'connected','angeschlossen','raccorde', 'zzz_angeschlossen', 'rrr_angeschlossen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_connection_wwtp (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5096,5096,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_connection_wwtp (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5097,5097,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_connection_wwtp FOREIGN KEY (connection_wwtp)
 REFERENCES tww_vl.building_group_connection_wwtp (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_drainage_map () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_drainage_map ADD CONSTRAINT pkey_tww_vl_building_group_drainage_map_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_drainage_map (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4840,4840,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drainage_map (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4841,4841,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drainage_map (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4839,4839,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_drainage_map FOREIGN KEY (drainage_map)
 REFERENCES tww_vl.building_group_drainage_map (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_drinking_water_network () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_drinking_water_network ADD CONSTRAINT pkey_tww_vl_building_group_drinking_water_network_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_drinking_water_network (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4826,4826,'connected','angeschlossen','raccorde', 'zzz_angeschlossen', 'rrr_angeschlossen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drinking_water_network (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4827,4827,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drinking_water_network (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4825,4825,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_drinking_water_network FOREIGN KEY (drinking_water_network)
 REFERENCES tww_vl.building_group_drinking_water_network (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_drinking_water_others () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_drinking_water_others ADD CONSTRAINT pkey_tww_vl_building_group_drinking_water_others_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4833,4833,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4830,4830,'none','keine','aucune', 'nessuno', 'inexistent', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4831,4831,'source','Quelle','source', 'zzz_Quelle', 'rrr_Quelle', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4829,4829,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_drinking_water_others (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4832,4832,'cistern','Zisterne','citerne', 'zzz_Zisterne', 'rrr_Zisterne', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_drinking_water_others FOREIGN KEY (drinking_water_others)
 REFERENCES tww_vl.building_group_drinking_water_others (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_electric_connection () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_electric_connection ADD CONSTRAINT pkey_tww_vl_building_group_electric_connection_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_electric_connection (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4836,4836,'connected','angeschlossen','raccorde', 'zzz_angeschlossen', 'rrr_angeschlossen', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_electric_connection (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4837,4837,'not_connected','nicht_angeschlossen','non_raccorde', 'non_collegato', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_electric_connection (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4835,4835,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_electric_connection FOREIGN KEY (electric_connection)
 REFERENCES tww_vl.building_group_electric_connection (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_function () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_function ADD CONSTRAINT pkey_tww_vl_building_group_function_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4823,4823,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4820,4820,'holiday_building','Feriengebaeude','uniquement_vacances', 'zzz_Feriengebaeude', 'rrr_Feriengebaeude', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4821,4821,'industry_craft','IndustrieGewerbe','entreprise', 'zzz_IndustrieGewerbe', 'rrr_IndustrieGewerbe', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4822,4822,'farm','Landwirtschaftsbetrieb','exploitation_agricole', 'zzz_Landwirtschaftsbetrieb', 'rrr_Landwirtschaftsbetrieb', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4818,4818,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4819,4819,'residential_building','Wohngebaeude','uniquement_habitation', 'zzz_Wohngebaeude', 'rrr_Wohngebaeude', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_function FOREIGN KEY (function)
 REFERENCES tww_vl.building_group_function (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.building_group_renovation_necessity () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_renovation_necessity ADD CONSTRAINT pkey_tww_vl_building_group_renovation_necessity_code PRIMARY KEY (code);
 INSERT INTO tww_vl.building_group_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8797,8797,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8798,8798,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.building_group_renovation_necessity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8799,8799,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_renovation_necessity FOREIGN KEY (renovation_necessity)
 REFERENCES tww_vl.building_group_renovation_necessity (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.building_group_baugwr ADD COLUMN fk_building_group varchar(16);
ALTER TABLE tww_od.building_group_baugwr ADD CONSTRAINT rel_building_group_baugwr_building_group FOREIGN KEY (fk_building_group) REFERENCES tww_od.building_group(obj_id) ON UPDATE CASCADE ON DELETE set null;
ALTER TABLE tww_od.farm ADD COLUMN fk_building_group varchar(16);
ALTER TABLE tww_od.farm ADD CONSTRAINT rel_farm_building_group FOREIGN KEY (fk_building_group) REFERENCES tww_od.building_group(obj_id) ON UPDATE CASCADE ON DELETE cascade;
CREATE TABLE tww_vl.farm_cesspit_volume () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.farm_cesspit_volume ADD CONSTRAINT pkey_tww_vl_farm_cesspit_volume_code PRIMARY KEY (code);
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5490,5490,'own_and_third_part_operation','Eigen_und_Fremdbetrieb','exploitation_propre_et_externe', 'zzz_Eigen_und_Fremdbetrieb', 'rrr_Eigen_und_Fremdbetrieb', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5488,5488,'own_operation','Eigenbetrieb','exploitation_propre', 'zzz_Eigenbetrieb', 'rrr_Eigenbetrieb', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5489,5489,'third_party_operation','Fremdbetrieb','exploitation_externe', 'zzz_Fremdbetrieb', 'rrr_Fremdbetrieb', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_cesspit_volume (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5491,5491,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.farm ADD CONSTRAINT fkey_vl_farm_cesspit_volume FOREIGN KEY (cesspit_volume)
 REFERENCES tww_vl.farm_cesspit_volume (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.farm_conformity () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.farm_conformity ADD CONSTRAINT pkey_tww_vl_farm_conformity_code PRIMARY KEY (code);
 INSERT INTO tww_vl.farm_conformity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4896,4896,'conform','konform','conforme', 'zzz_konform', 'rrr_konform', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_conformity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4898,4898,'restoration_postponed','Sanierung_aufgeschoben','differee', 'zzz_Sanierung_aufgeschoben', 'rrr_Sanierung_aufgeschoben', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_conformity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4897,4897,'restoration_pending','Sanierung_bevorstehend','imminente', 'zzz_Sanierung_bevorstehend', 'rrr_Sanierung_bevorstehend', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_conformity (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4895,4895,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.farm ADD CONSTRAINT fkey_vl_farm_conformity FOREIGN KEY (conformity)
 REFERENCES tww_vl.farm_conformity (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.farm_continuance () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.farm_continuance ADD CONSTRAINT pkey_tww_vl_farm_continuance_code PRIMARY KEY (code);
 INSERT INTO tww_vl.farm_continuance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4890,4890,'not_defined','nicht_definiert','non_definie', 'zzz_nicht_definiert', 'rrr_nicht_definiert', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_continuance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4892,4892,'improble','unwahrscheinlich','improbable', 'zzz_unwahrscheinlich', 'rrr_unwahrscheinlich', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_continuance (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4891,4891,'probable','wahrscheinlich','probable', 'zzz_wahrscheinlich', 'rrr_wahrscheinlich', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.farm ADD CONSTRAINT fkey_vl_farm_continuance FOREIGN KEY (continuance)
 REFERENCES tww_vl.farm_continuance (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.farm_shepherds_hut_wastewater () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.farm_shepherds_hut_wastewater ADD CONSTRAINT pkey_tww_vl_farm_shepherds_hut_wastewater_code PRIMARY KEY (code);
 INSERT INTO tww_vl.farm_shepherds_hut_wastewater (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4869,4869,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_shepherds_hut_wastewater (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4870,4870,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_shepherds_hut_wastewater (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4871,4871,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.farm ADD CONSTRAINT fkey_vl_farm_shepherds_hut_wastewater FOREIGN KEY (shepherds_hut_wastewater)
 REFERENCES tww_vl.farm_shepherds_hut_wastewater (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.farm_stable_cattle () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.farm_stable_cattle ADD CONSTRAINT pkey_tww_vl_farm_stable_cattle_code PRIMARY KEY (code);
 INSERT INTO tww_vl.farm_stable_cattle (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4875,4875,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_stable_cattle (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4876,4876,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.farm_stable_cattle (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (4877,4877,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.farm ADD CONSTRAINT fkey_vl_farm_stable_cattle FOREIGN KEY (stable_cattle)
 REFERENCES tww_vl.farm_stable_cattle (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.small_treatment_plant ADD CONSTRAINT oorel_od_small_treatment_plant_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.small_treatment_plant_function () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.small_treatment_plant_function ADD CONSTRAINT pkey_tww_vl_small_treatment_plant_function_code PRIMARY KEY (code);
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5013,5013,'other','andere','autres', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5014,5014,'activated_sludge_process','Belebtschlammverfahren','boues_activees', 'zzz_Belebtschlammverfahren', 'rrr_Belebtschlammverfahren', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5022,5022,'bed_process','Bettverfahren','lit_bacterien', 'zzz_Bettverfahren', 'rrr_Bettverfahren', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5023,5023,'membran_bioreactor','Membranbioreaktor','reacteur_a_biomasse_fixee', 'zzz_Membranbioreaktor', 'rrr_Membranbioreaktor', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5020,5020,'constructed_wetland','Pflanzenklaeranlage','filtration_par_plantes', 'zzz_Pflanzenklaeranlage', '', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5019,5019,'sandfilter','Sandfilter','filtre_a_sable', 'zzz_Sandfilter', 'rrr_Sandfilter', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5015,5015,'sequencing_batch_reactor','SequencingBatchReactor','charge_sequentielle_SBR', 'zzz_SequencingBatchReactor', 'rrr_SequencingBatchReactor', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5016,5016,'immersion_trickle_filter','Tauchkoerper','disques_biologiques', 'zzz_Tauchkoerper', 'rrr_Tauchkoerper', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_function (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (5021,5021,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.small_treatment_plant ADD CONSTRAINT fkey_vl_small_treatment_plant_function FOREIGN KEY (function)
 REFERENCES tww_vl.small_treatment_plant_function (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.small_treatment_plant_remote_monitoring () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.small_treatment_plant_remote_monitoring ADD CONSTRAINT pkey_tww_vl_small_treatment_plant_remote_monitoring_code PRIMARY KEY (code);
 INSERT INTO tww_vl.small_treatment_plant_remote_monitoring (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6414,6414,'yes','ja','oui', 'si', 'da', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_remote_monitoring (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6415,6415,'no','nein','non', 'no', 'nu', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.small_treatment_plant_remote_monitoring (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6416,6416,'unknown','unbekannt','inconnu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.small_treatment_plant ADD CONSTRAINT fkey_vl_small_treatment_plant_remote_monitoring FOREIGN KEY (remote_monitoring)
 REFERENCES tww_vl.small_treatment_plant_remote_monitoring (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE tww_od.drainless_toilet ADD CONSTRAINT oorel_od_drainless_toilet_wastewater_structure FOREIGN KEY (obj_id) REFERENCES tww_od.wastewater_structure(obj_id) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE tww_vl.drainless_toilet_kind () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.drainless_toilet_kind ADD CONSTRAINT pkey_tww_vl_drainless_toilet_kind_code PRIMARY KEY (code);
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6411,6411,'other','andere','autre', 'altro', 'rrr_altul', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6408,6408,'chemical_toilet','chemischeToilette','toilette_chimique', 'toilette_chimica', 'rrr_chemischeToilette', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6410,6410,'compost_toilet','Komposttoilette','toilette_a_compost', 'toilette_compostante', 'rrr_Komposttoilette', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6412,6412,'unknown','unbekannt','inconu', 'sconosciuto', 'necunoscuta', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.drainless_toilet_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (6409,6409,'incinerating_toilet','Verbrennungstoilette','toilette_d_incineration', 'toilette_inceneriscono', 'rrr_Verbrennungstoilette', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.drainless_toilet ADD CONSTRAINT fkey_vl_drainless_toilet_kind FOREIGN KEY (kind)
 REFERENCES tww_vl.drainless_toilet_kind (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;

------------ Text and Symbol Tables ----------- ;
-------
CREATE TABLE tww_od.wastewater_structure_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wastewater_structure_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wastewater_structure_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wastewater_structure_text ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure_text');
COMMENT ON COLUMN tww_od.wastewater_structure_text.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN classname text;
 ALTER TABLE tww_od.wastewater_structure_text ADD CONSTRAINT _classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.wastewater_structure_text.classname IS 'Name of class that textclass is related to / Name der Klasse zu der die Textklasse gehört / nom de la classe à laquelle appartient la classe de texte';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure_text.plantype IS '';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN remark text;
 ALTER TABLE tww_od.wastewater_structure_text ADD CONSTRAINT _remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.wastewater_structure_text.remark IS 'General remarks';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN text  text ;
COMMENT ON COLUMN tww_od.wastewater_structure_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure_text.texthali IS '';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN tww_od.wastewater_structure_text.textori IS '';
ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_wastewater_structure_text_textpos_geometry ON tww_od.wastewater_structure_text USING gist (textpos_geometry );
COMMENT ON COLUMN tww_od.wastewater_structure_text.textpos_geometry IS '';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN tww_od.wastewater_structure_text.textvali IS '';
 ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.wastewater_structure_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_wastewater_structure_text
BEFORE UPDATE OR INSERT ON
 tww_od.wastewater_structure_text
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.reach_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_reach_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_reach_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.reach_text ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach_text');
COMMENT ON COLUMN tww_od.reach_text.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.reach_text ADD COLUMN classname text;
 ALTER TABLE tww_od.reach_text ADD CONSTRAINT _classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.reach_text.classname IS 'Name of class that textclass is related to / Name der Klasse zu der die Textklasse gehört / nom de la classe à laquelle appartient la classe de texte';
 ALTER TABLE tww_od.reach_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.reach_text.plantype IS '';
 ALTER TABLE tww_od.reach_text ADD COLUMN remark text;
 ALTER TABLE tww_od.reach_text ADD CONSTRAINT _remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.reach_text.remark IS 'General remarks';
 ALTER TABLE tww_od.reach_text ADD COLUMN text  text ;
COMMENT ON COLUMN tww_od.reach_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
 ALTER TABLE tww_od.reach_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN tww_od.reach_text.texthali IS '';
 ALTER TABLE tww_od.reach_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN tww_od.reach_text.textori IS '';
ALTER TABLE tww_od.reach_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_reach_text_textpos_geometry ON tww_od.reach_text USING gist (textpos_geometry );
COMMENT ON COLUMN tww_od.reach_text.textpos_geometry IS '';
 ALTER TABLE tww_od.reach_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN tww_od.reach_text.textvali IS '';
 ALTER TABLE tww_od.reach_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.reach_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_reach_text
BEFORE UPDATE OR INSERT ON
 tww_od.reach_text
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.catchment_area_text
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_catchment_area_text_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_catchment_area_text_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.catchment_area_text ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','catchment_area_text');
COMMENT ON COLUMN tww_od.catchment_area_text.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN classname text;
 ALTER TABLE tww_od.catchment_area_text ADD CONSTRAINT _classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.catchment_area_text.classname IS 'Name of class that textclass is related to / Name der Klasse zu der die Textklasse gehört / nom de la classe à laquelle appartient la classe de texte';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.catchment_area_text.plantype IS '';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN remark text;
 ALTER TABLE tww_od.catchment_area_text ADD CONSTRAINT _remark_length_max_80 CHECK(char_length(remark)<=80);
COMMENT ON COLUMN tww_od.catchment_area_text.remark IS 'General remarks';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN text  text ;
COMMENT ON COLUMN tww_od.catchment_area_text.text IS 'yyy_Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / Aus Attributwerten zusammengesetzter Wert, mehrzeilig möglich / valeur calculée à partir d’attributs, plusieurs lignes possible';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN texthali  smallint ;
COMMENT ON COLUMN tww_od.catchment_area_text.texthali IS '';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN textori  decimal(4,1) ;
COMMENT ON COLUMN tww_od.catchment_area_text.textori IS '';
ALTER TABLE tww_od.catchment_area_text ADD COLUMN textpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_catchment_area_text_textpos_geometry ON tww_od.catchment_area_text USING gist (textpos_geometry );
COMMENT ON COLUMN tww_od.catchment_area_text.textpos_geometry IS '';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN textvali  smallint ;
COMMENT ON COLUMN tww_od.catchment_area_text.textvali IS '';
 ALTER TABLE tww_od.catchment_area_text ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.catchment_area_text.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_catchment_area_text
BEFORE UPDATE OR INSERT ON
 tww_od.catchment_area_text
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------
-------
CREATE TABLE tww_od.wastewater_structure_symbol
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_wastewater_structure_symbol_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_wastewater_structure_symbol_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.wastewater_structure_symbol ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','wastewater_structure_symbol');
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN classname text;
 ALTER TABLE tww_od.wastewater_structure_symbol ADD CONSTRAINT _classname_length_max_50 CHECK(char_length(classname)<=50);
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.classname IS 'Name of class that symbol class is related to / Name der Klasse zu der die Symbolklasse gehört / nom de la classe à laquelle appartient la classe de symbole';
 ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.plantype IS '';
 ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN symbol_scaling_heigth  decimal(2,1) ;
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.symbol_scaling_heigth IS '';
 ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN symbol_scaling_width  decimal(2,1) ;
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.symbol_scaling_width IS '';
 ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN symbolori  decimal(4,1) ;
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.symbolori IS 'Default: 90 Degree / Default: 90 Grad / Default: 90 degree';
ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN symbolpos_geometry geometry('POINT', :SRID);
CREATE INDEX in_tww_wastewater_structure_symbol_symbolpos_geometry ON tww_od.wastewater_structure_symbol USING gist (symbolpos_geometry );
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.symbolpos_geometry IS '';
 ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.wastewater_structure_symbol.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_wastewater_structure_symbol
BEFORE UPDATE OR INSERT ON
 tww_od.wastewater_structure_symbol
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------

------------ Text and Symbol Tables Relationships ----------- ;
ALTER TABLE tww_od.wastewater_structure_text ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.wastewater_structure_text ADD CONSTRAINT rel_wastewater_structure_text_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE tww_od.reach_text ADD COLUMN fk_reach varchar(16);
ALTER TABLE tww_od.reach_text ADD CONSTRAINT rel_reach_text_reach FOREIGN KEY (fk_reach) REFERENCES tww_od.reach(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE tww_od.catchment_area_text ADD COLUMN fk_catchment_area varchar(16);
ALTER TABLE tww_od.catchment_area_text ADD CONSTRAINT rel_catchment_area_text_catchment_area FOREIGN KEY (fk_catchment_area) REFERENCES tww_od.catchment_area(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE tww_od.wastewater_structure_symbol ADD COLUMN fk_wastewater_structure varchar(16);
ALTER TABLE tww_od.wastewater_structure_symbol ADD CONSTRAINT rel_wastewater_structure_symbol_wastewater_structure FOREIGN KEY (fk_wastewater_structure) REFERENCES tww_od.wastewater_structure(obj_id) ON UPDATE CASCADE ON DELETE CASCADE;

------------ Text and Symbol Tables Values ----------- ;
CREATE TABLE tww_vl.wastewater_structure_text_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_text_plantype ADD CONSTRAINT pkey_tww_vl_wastewater_structure_text_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure_text ADD CONSTRAINT fkey_vl_wastewater_structure_text_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.wastewater_structure_text_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_text_texthali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_text_texthali ADD CONSTRAINT pkey_tww_vl_wastewater_structure_text_texthali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure_text ADD CONSTRAINT fkey_vl_wastewater_structure_text_texthali FOREIGN KEY (texthali)
 REFERENCES tww_vl.wastewater_structure_text_texthali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_text_textvali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_text_textvali ADD CONSTRAINT pkey_tww_vl_wastewater_structure_text_textvali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure_text ADD CONSTRAINT fkey_vl_wastewater_structure_text_textvali FOREIGN KEY (textvali)
 REFERENCES tww_vl.wastewater_structure_text_textvali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_text_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_text_plantype ADD CONSTRAINT pkey_tww_vl_reach_text_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach_text ADD CONSTRAINT fkey_vl_reach_text_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.reach_text_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_text_texthali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_text_texthali ADD CONSTRAINT pkey_tww_vl_reach_text_texthali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach_text ADD CONSTRAINT fkey_vl_reach_text_texthali FOREIGN KEY (texthali)
 REFERENCES tww_vl.reach_text_texthali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.reach_text_textvali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_text_textvali ADD CONSTRAINT pkey_tww_vl_reach_text_textvali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach_text ADD CONSTRAINT fkey_vl_reach_text_textvali FOREIGN KEY (textvali)
 REFERENCES tww_vl.reach_text_textvali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_text_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_text_plantype ADD CONSTRAINT pkey_tww_vl_catchment_area_text_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7844,7844,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7846,7846,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7847,7847,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7848,7848,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7845,7845,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area_text ADD CONSTRAINT fkey_vl_catchment_area_text_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.catchment_area_text_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_text_texthali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_text_texthali ADD CONSTRAINT pkey_tww_vl_catchment_area_text_texthali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7850,7850,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7851,7851,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_texthali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7852,7852,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area_text ADD CONSTRAINT fkey_vl_catchment_area_text_texthali FOREIGN KEY (texthali)
 REFERENCES tww_vl.catchment_area_text_texthali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.catchment_area_text_textvali () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.catchment_area_text_textvali ADD CONSTRAINT pkey_tww_vl_catchment_area_text_textvali_code PRIMARY KEY (code);
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7853,7853,'0','0','0', '0', '0', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7854,7854,'1','1','1', '1', '1', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7855,7855,'2','2','2', '2', '2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7856,7856,'3','3','3', '3', '3', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.catchment_area_text_textvali (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7857,7857,'4','4','4', '4', '4', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.catchment_area_text ADD CONSTRAINT fkey_vl_catchment_area_text_textvali FOREIGN KEY (textvali)
 REFERENCES tww_vl.catchment_area_text_textvali (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE tww_vl.wastewater_structure_symbol_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_structure_symbol_plantype ADD CONSTRAINT pkey_tww_vl_wastewater_structure_symbol_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7874,7874,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7876,7876,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7877,7877,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7878,7878,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.wastewater_structure_symbol_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (7875,7875,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.wastewater_structure_symbol ADD CONSTRAINT fkey_vl_wastewater_structure_symbol_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.wastewater_structure_symbol_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;

------------ Reach Progression Alternative Table ----------- ;
-------
CREATE TABLE tww_od.reach_progression_alternative
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_tww_od_reach_progression_alternative_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE tww_od.seq_reach_progression_alternative_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE tww_od.reach_progression_alternative ALTER COLUMN obj_id SET DEFAULT tww_sys.generate_oid('tww_od','reach_progression_alternative');
COMMENT ON COLUMN tww_od.reach_progression_alternative.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix), see www.interlis.ch';
 ALTER TABLE tww_od.reach_progression_alternative ADD COLUMN plantype  integer ;
COMMENT ON COLUMN tww_od.reach_progression_alternative.plantype IS '';
ALTER TABLE tww_od.reach_progression_alternative ADD COLUMN progression_geometry geometry('COMPOUNDCURVE', :SRID);
CREATE INDEX in_tww_reach_progression_alternative_progression_geometry ON tww_od.reach_progression_alternative USING gist (progression_geometry );
COMMENT ON COLUMN tww_od.reach_progression_alternative.progression_geometry IS 'Start, inflextion and endpoints of a progression alterative for selected scale (e.g. overview map) / Anfangs-, Knick- und Endpunkte des Alternativverlaufs der Leitung im gewählten Plantyp (z.B. Uebersichtsplan) / Points de départ, intermédiaires et d’arrivée de la trace alternative de la conduite dans la type de plan selectionée';
 ALTER TABLE tww_od.reach_progression_alternative ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN tww_od.reach_progression_alternative.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
-------
CREATE TRIGGER
update_last_modified_reach_progression_alternative
BEFORE UPDATE OR INSERT ON
 tww_od.reach_progression_alternative
FOR EACH ROW EXECUTE PROCEDURE
 tww_sys.update_last_modified();

-------

------------ Reach Progression Alternative Relationships ----------- ;
------------ already exists

------------ Reach Progression Alternative Table Values ----------- ;
CREATE TABLE tww_vl.reach_progression_alternative_plantype () INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.reach_progression_alternative_plantype ADD CONSTRAINT pkey_tww_vl_reach_progression_alternative_plantype_code PRIMARY KEY (code);
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9282,9282,'pipeline_registry','Leitungskataster','cadastre_des_conduites_souterraines', 'catasto_delle_canalizzazioni', 'rrr_Leitungskataster', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9285,9285,'overviewmap.om10','Uebersichtsplan.UeP10','plan_d_ensemble.pe10', 'piano_di_insieme.pi10', 'rrr_Uebersichtsplan.UeP10', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9286,9286,'overviewmap.om2','Uebersichtsplan.UeP2','plan_d_ensemble.pe2', 'piano_di_insieme.pi2', 'rrr_Uebersichtsplan.UeP2', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9287,9287,'overviewmap.om5','Uebersichtsplan.UeP5','plan_d_ensemble.pe5', 'piano_di_insieme.pi5', 'rrr_Uebersichtsplan.UeP5', '', '', '', '', '', 'true');
 INSERT INTO tww_vl.reach_progression_alternative_plantype (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9284,9284,'network_plan','Werkplan','plan_de_reseau', 'zzz_Werkplan', 'rrr_Werkplan', '', '', '', '', '', 'true');
 ALTER TABLE tww_od.reach_progression_alternative ADD CONSTRAINT fkey_vl_reach_progression_alternative_plantype FOREIGN KEY (plantype)
 REFERENCES tww_vl.reach_progression_alternative_plantype (code) MATCH SIMPLE
 ON UPDATE RESTRICT ON DELETE RESTRICT;

--------- Relations to class organisation for dataowner and provider (new 3.11.2014);

ALTER TABLE tww_od.organisation ADD CONSTRAINT rel_od_organisation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.organisation ADD CONSTRAINT rel_od_organisation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measure ADD CONSTRAINT rel_od_measure_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measure ADD CONSTRAINT rel_od_measure_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.mutation ADD CONSTRAINT rel_od_mutation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.mutation ADD CONSTRAINT rel_od_mutation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.waste_water_treatment_plant ADD CONSTRAINT rel_od_waste_water_treatment_plant_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.waste_water_treatment_plant ADD CONSTRAINT rel_od_waste_water_treatment_plant_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_od_wastewater_structure_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.wastewater_structure ADD CONSTRAINT rel_od_wastewater_structure_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT rel_od_maintenance_event_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.maintenance_event ADD CONSTRAINT rel_od_maintenance_event_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.zone ADD CONSTRAINT rel_od_zone_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.zone ADD CONSTRAINT rel_od_zone_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.pipe_profile ADD CONSTRAINT rel_od_pipe_profile_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.pipe_profile ADD CONSTRAINT rel_od_pipe_profile_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.wwtp_energy_use ADD CONSTRAINT rel_od_wwtp_energy_use_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.wwtp_energy_use ADD CONSTRAINT rel_od_wwtp_energy_use_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.waste_water_treatment ADD CONSTRAINT rel_od_waste_water_treatment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.waste_water_treatment ADD CONSTRAINT rel_od_waste_water_treatment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.sludge_treatment ADD CONSTRAINT rel_od_sludge_treatment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.sludge_treatment ADD CONSTRAINT rel_od_sludge_treatment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.control_center ADD CONSTRAINT rel_od_control_center_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.control_center ADD CONSTRAINT rel_od_control_center_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hydr_geometry ADD CONSTRAINT rel_od_hydr_geometry_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hydr_geometry ADD CONSTRAINT rel_od_hydr_geometry_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT rel_od_wastewater_networkelement_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.wastewater_networkelement ADD CONSTRAINT rel_od_wastewater_networkelement_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.reach_point ADD CONSTRAINT rel_od_reach_point_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.reach_point ADD CONSTRAINT rel_od_reach_point_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.profile_geometry ADD CONSTRAINT rel_od_profile_geometry_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.profile_geometry ADD CONSTRAINT rel_od_profile_geometry_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hydr_geom_relation ADD CONSTRAINT rel_od_hydr_geom_relation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hydr_geom_relation ADD CONSTRAINT rel_od_hydr_geom_relation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.mechanical_pretreatment ADD CONSTRAINT rel_od_mechanical_pretreatment_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.mechanical_pretreatment ADD CONSTRAINT rel_od_mechanical_pretreatment_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.retention_body ADD CONSTRAINT rel_od_retention_body_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.retention_body ADD CONSTRAINT rel_od_retention_body_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.overflow_char ADD CONSTRAINT rel_od_overflow_char_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.overflow_char ADD CONSTRAINT rel_od_overflow_char_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hq_relation ADD CONSTRAINT rel_od_hq_relation_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hq_relation ADD CONSTRAINT rel_od_hq_relation_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.structure_part ADD CONSTRAINT rel_od_structure_part_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.structure_part ADD CONSTRAINT rel_od_structure_part_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.connection_object ADD CONSTRAINT rel_od_connection_object_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.connection_object ADD CONSTRAINT rel_od_connection_object_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.log_card ADD CONSTRAINT rel_od_log_card_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.log_card ADD CONSTRAINT rel_od_log_card_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_od_catchment_area_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.catchment_area ADD CONSTRAINT rel_od_catchment_area_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.surface_runoff_parameters ADD CONSTRAINT rel_od_surface_runoff_parameters_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.surface_runoff_parameters ADD CONSTRAINT rel_od_surface_runoff_parameters_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measuring_point ADD CONSTRAINT rel_od_measuring_point_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measuring_point ADD CONSTRAINT rel_od_measuring_point_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measuring_device ADD CONSTRAINT rel_od_measuring_device_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measuring_device ADD CONSTRAINT rel_od_measuring_device_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measurement_series ADD CONSTRAINT rel_od_measurement_series_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measurement_series ADD CONSTRAINT rel_od_measurement_series_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measurement_result ADD CONSTRAINT rel_od_measurement_result_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.measurement_result ADD CONSTRAINT rel_od_measurement_result_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.overflow ADD CONSTRAINT rel_od_overflow_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.overflow ADD CONSTRAINT rel_od_overflow_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT rel_od_throttle_shut_off_unit_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.throttle_shut_off_unit ADD CONSTRAINT rel_od_throttle_shut_off_unit_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT rel_od_hydraulic_char_data_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.hydraulic_char_data ADD CONSTRAINT rel_od_hydraulic_char_data_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.catchment_area_totals ADD CONSTRAINT rel_od_catchment_area_totals_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.catchment_area_totals ADD CONSTRAINT rel_od_catchment_area_totals_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.disposal ADD CONSTRAINT rel_od_disposal_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.disposal ADD CONSTRAINT rel_od_disposal_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.building_group ADD CONSTRAINT rel_od_building_group_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.building_group ADD CONSTRAINT rel_od_building_group_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.building_group_baugwr ADD CONSTRAINT rel_od_building_group_baugwr_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.building_group_baugwr ADD CONSTRAINT rel_od_building_group_baugwr_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.farm ADD CONSTRAINT rel_od_farm_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES tww_od.organisation(obj_id);
ALTER TABLE tww_od.farm ADD CONSTRAINT rel_od_farm_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES tww_od.organisation(obj_id);

------ Indexes on identifiers

 CREATE UNIQUE INDEX in_od_organisation_identifier ON tww_od.organisation USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measure_identifier ON tww_od.measure USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_waste_water_treatment_plant_identifier ON tww_od.waste_water_treatment_plant USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_wastewater_structure_identifier ON tww_od.wastewater_structure USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_maintenance_event_identifier ON tww_od.maintenance_event USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_zone_identifier ON tww_od.zone USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_pipe_profile_identifier ON tww_od.pipe_profile USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_wwtp_energy_use_identifier ON tww_od.wwtp_energy_use USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_waste_water_treatment_identifier ON tww_od.waste_water_treatment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_sludge_treatment_identifier ON tww_od.sludge_treatment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_control_center_identifier ON tww_od.control_center USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_hydr_geometry_identifier ON tww_od.hydr_geometry USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_wastewater_networkelement_identifier ON tww_od.wastewater_networkelement USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_reach_point_identifier ON tww_od.reach_point USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_mechanical_pretreatment_identifier ON tww_od.mechanical_pretreatment USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_retention_body_identifier ON tww_od.retention_body USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_overflow_char_identifier ON tww_od.overflow_char USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_structure_part_identifier ON tww_od.structure_part USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_connection_object_identifier ON tww_od.connection_object USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_catchment_area_identifier ON tww_od.catchment_area USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_surface_runoff_parameters_identifier ON tww_od.surface_runoff_parameters USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measuring_point_identifier ON tww_od.measuring_point USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measuring_device_identifier ON tww_od.measuring_device USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measurement_series_identifier ON tww_od.measurement_series USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_measurement_result_identifier ON tww_od.measurement_result USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_overflow_identifier ON tww_od.overflow USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_throttle_shut_off_unit_identifier ON tww_od.throttle_shut_off_unit USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_hydraulic_char_data_identifier ON tww_od.hydraulic_char_data USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_catchment_area_totals_identifier ON tww_od.catchment_area_totals USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_building_group_identifier ON tww_od.building_group USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
