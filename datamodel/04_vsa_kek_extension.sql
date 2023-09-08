------ This file generates the VSA-DSS database (Modul VSA-KEK) in en on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 26.04.2016 20:47:41

---- 27.4.2016 qgep_od.examination ADD COLUMN operator commented out, duplicate allready in maintenance_event

BEGIN;
------ CREATE SCHEMA qgep;
--- CREATE FUNCTION qgep_sys.update_last_modified() exists already
--- CREATE TABLE qgep_sys.value_list_base exists already
-------
CREATE TABLE qgep_od.examination
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_examination_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_examination_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.examination ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','examination');
COMMENT ON COLUMN qgep_od.examination.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
 ALTER TABLE qgep_od.examination ADD COLUMN equipment  varchar(50) ;
COMMENT ON COLUMN qgep_od.examination.equipment IS 'Name of used camera / Eingesetztes Aufnahmegeräte (Kamera) / Appareil de prise de vues (caméra) employé';
 ALTER TABLE qgep_od.examination ADD COLUMN from_point_identifier  varchar(41) ;
COMMENT ON COLUMN qgep_od.examination.from_point_identifier IS 'yyy_Bezeichnung des "von Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Foreign key Haltungspunkt, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. Bei Schachtuntersuchungen bleibt dieser Wert leer. / Bezeichnung des "von Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Fremdschlüssel Haltungspunkt, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. Bei Schachtuntersuchungen bleibt dieser Wert leer. / point (chambre ou nœud) auquel l’inspection termine. Désignation du « point départ » d’une inspection comme elle figure sur le plan. Elle sert d’alternative à la clé externe POINT_TRONCON, lorsque la topologie n’est pas encore définie (saisie initiale). La DESIGNATION_POINT_DE sera utilisée ultérieurement par l’hydraulicien pour la construction de la topologie du réseau. Cette valeur reste vide lors d’inspections de chambres.';
 ALTER TABLE qgep_od.examination ADD COLUMN inspected_length  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.examination.inspected_length IS 'yyy_Total untersuchte Länge in Metern mit zwei Nachkommastellen / Total untersuchte Länge in Metern mit zwei Nachkommastellen / Longueur totale examinée en mètres avec deux chiffres après la virgule';
-- ALTER TABLE qgep_od.examination ADD COLUMN operator  varchar(50) ;
-- COMMENT ON COLUMN qgep_od.examination.operator IS 'name of operator / Name des Operateurs / Nom de l’opérateur';
 ALTER TABLE qgep_od.examination ADD COLUMN recording_type  integer ;
COMMENT ON COLUMN qgep_od.examination.recording_type IS 'yyy_Aufnahmetechnik, beschreibt die Art der Aufnahme / Aufnahmetechnik, beschreibt die Art der Aufnahme / Technique de prise de vues, décrit le type de prise de vues';
 ALTER TABLE qgep_od.examination ADD COLUMN to_point_identifier  varchar(41) ;
COMMENT ON COLUMN qgep_od.examination.to_point_identifier IS 'yyy_Bezeichnung des "bis Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Foreign key Abwasserbauwerk, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. / Bezeichnung des "bis Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Fremdschlüssel Abwasserbauwerk, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. / point (chambre ou noeud) d’où l’inspection commence. Désignation du « point d’arrivée » d’une inspection comme elle figure sur le plan. Elle sert d’alternative à la clé externe OUVRAGE_RESEAU_AS lorsque la topologie n’est pas encore définie (saisie initiale). La DESIGNATION_POINT_DE sera utilisée ultérieurement par l’hydraulicien pour la construction de la topologie du réseau.';
 ALTER TABLE qgep_od.examination ADD COLUMN vehicle  varchar(50) ;
COMMENT ON COLUMN qgep_od.examination.vehicle IS 'yyy_Eingesetztes Inspektionsfahrzeug / Eingesetztes Inspektionsfahrzeug / Véhicule d’inspection employé';
 ALTER TABLE qgep_od.examination ADD COLUMN videonumber  varchar(41) ;
COMMENT ON COLUMN qgep_od.examination.videonumber IS 'yyy_Bei Videobändern steht hier die Bandnummer (z.B. 1/99). Bei elektronischen Datenträgern ist dies die Datenträgerbezeichnung (z.B. SG001). Falls pro Untersuchung eine einzelne Datei zur Verfügung steht, dann wird diese aus der Klasse Datei referenziert und dieses Attribut kann leer gelassen werden. / Bei Videobändern steht hier die Bandnummer (z.B. 1/99). Bei elektronischen Datenträgern ist dies die Datenträgerbezeichnung (z.B. SG001). Falls pro Untersuchung eine einzelne Datei zur Verfügung steht, dann wird diese aus der Klasse Datei referenziert und dieses Attribut kann leer gelassen werden. / Pour les bandes vidéo figure ici le numéro de la bande (p. ex. 1/99) et, pour les supports de don-nées électroniques, sa désignation (p. ex. SG001). S’il n’existe qu’un fichier par examen, ce fichier est référencé par la classe Fichier et cet attribut peut être laissé vide';
 ALTER TABLE qgep_od.examination ADD COLUMN weather  integer ;
COMMENT ON COLUMN qgep_od.examination.weather IS 'Wheather conditions during inspection / Wetterverhältnisse während der Inspektion / Conditions météorologiques pendant l’inspection';
-------
CREATE TRIGGER
update_last_modified_examination
BEFORE UPDATE OR INSERT ON
 qgep_od.examination
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.maintenance_event");

-------
-------
CREATE TABLE qgep_od.damage
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_damage_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_damage_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.damage ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','damage');
COMMENT ON COLUMN qgep_od.damage.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
 ALTER TABLE qgep_od.damage ADD COLUMN comments  varchar(100) ;
COMMENT ON COLUMN qgep_od.damage.comments IS 'yyy_Freie Bemerkungen zu einer Feststellung / Freie Bemerkungen zu einer Feststellung / Remarques libres concernant une observation';
 ALTER TABLE qgep_od.damage ADD COLUMN connection  integer ;
COMMENT ON COLUMN qgep_od.damage.connection IS 'yyy_Kennzeichen für eine Feststellung an einer Rohrverbindung (2.1.7). bzw. bei zwei aneinandergrenzenden Schachtelementen gemäss (3.1.7). Entspricht in SN EN 13508 ja = "A", nein = leer / Kennzeichen für eine Feststellung an einer Rohrverbindung (2.1.7). bzw. bei zwei aneinandergrenzenden Schachtelementen gemäss (3.1.7). Entspricht in SN EN 13508 ja = "A", nein = leer / Indication d’une observation au niveau d’un assemblage (2.1.7) ou Observation entre deux éléments de regard de visite adjacents (3.1.7). Correspond dans la SN EN 13508 à oui = « A », non = vide';
 ALTER TABLE qgep_od.damage ADD COLUMN damage_begin  smallint ;
COMMENT ON COLUMN qgep_od.damage.damage_begin IS 'yyy_Lage am Umfang: Beginn des Schadens. Werte und Vorgehen sind unter Absatz 2.1.6 bzw. 3.1.6 genau beschrieben. / Lage am Umfang: Beginn des Schadens. Werte und Vorgehen sind unter Absatz 2.1.6 bzw. 3.1.6 genau beschrieben. / Emplacement circonférentiel: Début du dommage. Valeurs et procédure sont décrites en détail dans le paragraphe 2.1.6 resp. 3.1.6.';
 ALTER TABLE qgep_od.damage ADD COLUMN damage_end  smallint ;
COMMENT ON COLUMN qgep_od.damage.damage_end IS 'yyy_Lage am Umfang: Ende des Schadens. Werte und Vorgehen sind unter Absatz 2.1.6 bzw. 3.1.6 genau beschrieben. / Lage am Umfang: Ende des Schadens. Werte und Vorgehen sind unter Absatz 2.1.6 bzw. 3.1.6 genau beschrieben. / Emplacement circonférentiel: Fin du dommage. Valeurs et procédure sont décrites en détail dans le paragraphe 2.1.6. resp. 3.1.6.';
 ALTER TABLE qgep_od.damage ADD COLUMN damage_reach  varchar(3) ;
COMMENT ON COLUMN qgep_od.damage.damage_reach IS 'yyy_Codes für den Anfang und das Ende eines Streckenschadens. Genaue Angaben unter 2.1.2 resp. 3.1.2 / Codes für den Anfang und das Ende eines Streckenschadens. Genaue Angaben unter 2.1.2 resp. 3.1.2';
 ALTER TABLE qgep_od.damage ADD COLUMN distance  decimal(7,2) ;
COMMENT ON COLUMN qgep_od.damage.distance IS 'yyy_Länge von Rohranfang bis zur Feststellung bzw. Länge ab Oberkante Deckel (siehe Richtlinie Absatz 2.1.1 bzw. 3.1.1.) in m mit zwei Nachkommastellen / Länge von Rohranfang bis zur Feststellung bzw. Länge ab Oberkante Deckel (siehe Richtlinie Absatz 2.1.1 bzw. 3.1.1.) in m mit zwei Nachkommastellen / Longueur entre le début de la canalisation resp. longueur entre le bord supérieur du couvercle et l’observation (cf. paragraphe 2.1.1 resp. 3.1.1.) en m avec deux chiffres après la virgule.';
 ALTER TABLE qgep_od.damage ADD COLUMN quantification1  integer ;
COMMENT ON COLUMN qgep_od.damage.quantification1 IS 'yyy_Quantifizierung 1 gemäss SN EN 13508-2. Zulässige Eingaben sind in Kapitel 2.3 - 2.6 beschrieben / Quantifizierung 1 gemäss SN EN 13508-2. Zulässige Eingaben sind in Kapitel 2.3 - 2.6 bzw.  3.1.5 beschrieben / Quantification 1 selon la SN EN 13508-2. Les entrées autorisées sont décrites dans les chapitres 2.3 - 2.6 reps. 3.1.5';
 ALTER TABLE qgep_od.damage ADD COLUMN quantification2  integer ;
COMMENT ON COLUMN qgep_od.damage.quantification2 IS 'yyy_Quantifizierung 2 gemäss SN EN 13508-2. Zulässige Eingaben sind in Kapitel 2.3 - 2.6 bzw. 3.1.5 beschrieben / Quantifizierung 2 gemäss SN EN 13508-2. Zulässige Eingaben sind in Kapitel 2.3 - 2.6 bzw. 3.1.5 beschrieben / Quantification 2 selon la SN EN 13508. Les entrées autorisées sont décrites dans le chapitre 2.3 - 2.6. resp. 3.1.5.';
 ALTER TABLE qgep_od.damage ADD COLUMN single_damage_class  integer ;
COMMENT ON COLUMN qgep_od.damage.single_damage_class IS 'yyy_Definiert die Schadensklasse eines Einzelschadens. Die Einteilung in die Zustandsklassen erfolgt aufgrund des Schadenbilds und des Schadensausmasses. Dabei kann ein Abwasserbauwerk direkt einer Klasse zugeteilt werden oder zuerst jeder Schaden einzeln klassifiziert werden. (Am Schluss bestimmt dann z.B. der schwerste Einzelschaden die Klassifizierung des gesamten Kanals (Abwasserbauwerk.BaulicherZustand)). / Definiert die Schadensklasse eines Einzelschadens. Die Einteilung in die Zustandsklassen erfolgt aufgrund des Schadenbilds und des Schadensausmasses. Dabei kann ein Abwasserbauwerk direkt einer Klasse zugeteilt werden oder zuerst jeder Schaden einzeln klassifiziert werden. (Am Schluss bestimmt dann z.B. der schwerste Einzelschaden die Klassifizierung des gesamten Kanals (Abwasserbauwerk.BaulicherZustand)). / Définit la classe de dommages d’un dommage unique. La répartition en classes d’état s’effectue sur la base de la nature et de l’étendue des dommages. Un ouvrage d''assainissement peut être classé directement ou chaque dommage peut d’abord être classé séparément. (A la fin, le dommage le plus important détermine le classement de l’ensemble de la canalisation (OUVRAGE_RESEAU_AS.ETAT_CONSTRUCTIF).';
 ALTER TABLE qgep_od.damage ADD COLUMN video_counter  varchar(11) ;
COMMENT ON COLUMN qgep_od.damage.video_counter IS 'yyy_Zählerstand auf einem analogen Videoband oder in einer digitalen Videodatei, in Echtzeit / Zählerstand auf einem analogen Videoband oder in einer digitalen Videodatei, in Echtzeit';
 ALTER TABLE qgep_od.damage ADD COLUMN view_parameters  varchar(200) ;
COMMENT ON COLUMN qgep_od.damage.view_parameters IS 'yyy_Spezielle Ansichtsparameter für die Positionierung innerhalb einer Filmdatei für Scanner- oder digitale Videotechnik / Spezielle Ansichtsparameter für die Positionierung innerhalb einer Filmdatei für Scanner- oder digitale Videotechnik / Paramètres de projection spéciaux pour le positionnement à l’intérieur d’un fichier de film pour la technique vidéo scanner ou numérique.';
 ALTER TABLE qgep_od.damage ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.damage.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE qgep_od.damage ADD COLUMN fk_dataowner varchar(16);
 ALTER TABLE qgep_od.damage ADD COLUMN fk_provider varchar (16);
-------
CREATE TRIGGER
update_last_modified_damage
BEFORE UPDATE OR INSERT ON
 qgep_od.damage
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.damage_channel
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_damage_channel_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_damage_channel_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.damage_channel ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','damage_channel');
COMMENT ON COLUMN qgep_od.damage_channel.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
 ALTER TABLE qgep_od.damage_channel ADD COLUMN channel_damage_code  integer ;
COMMENT ON COLUMN qgep_od.damage_channel.channel_damage_code IS 'yyy_Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 2 der Richtlinie "Schadencodierung" abschliessend aufgeführt. / Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 2 der Richtlinie "Schadencodierung" abschliessend aufgeführt. / Domaine de valeur prédéfini: Code valide sur la base de la SN EN 13508-2. Tous les codes valides sont mentionnés dans le chapitre 2 de la directive.';
-------
CREATE TRIGGER
update_last_modified_damage_channel
BEFORE UPDATE OR INSERT ON
 qgep_od.damage_channel
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.damage");

-------
-------
CREATE TABLE qgep_od.damage_manhole
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_damage_manhole_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_damage_manhole_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.damage_manhole ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','damage_manhole');
COMMENT ON COLUMN qgep_od.damage_manhole.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
 ALTER TABLE qgep_od.damage_manhole ADD COLUMN manhole_damage_code  integer ;
COMMENT ON COLUMN qgep_od.damage_manhole.manhole_damage_code IS 'yyy_Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 3 der Richtlinie "Schadencodierung" abschliessend aufgeführt. / Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 3 der Richtlinie "Schadencodierung" abschliessend aufgeführt. / Domaine de valeur prédéfini: Code valide sur la base de la SN EN 13508-2. Tous les codes valides sont mentionnés dans le chapitre 3 de la directive.';
 ALTER TABLE qgep_od.damage_manhole ADD COLUMN manhole_shaft_area  integer ;
COMMENT ON COLUMN qgep_od.damage_manhole.manhole_shaft_area IS 'yyy_Bereich in dem eine Feststellung auftritt. Die Werte sind unter 3.1.9 abschliessend beschrieben. / Bereich in dem eine Feststellung auftritt. Die Werte sind unter 3.1.9 abschliessend beschrieben. / Domaine où une observation est faite. Les valeurs sont décrites dans 3.1.9.';
-------
CREATE TRIGGER
update_last_modified_damage_manhole
BEFORE UPDATE OR INSERT ON
 qgep_od.damage_manhole
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified_parent("qgep_od.damage");

-------
-------
CREATE TABLE qgep_od.data_media
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_data_media_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_data_media_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.data_media ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','data_media');
COMMENT ON COLUMN qgep_od.data_media.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
 ALTER TABLE qgep_od.data_media ADD COLUMN identifier  varchar(40) ;
COMMENT ON COLUMN qgep_od.data_media.identifier IS 'yyy_Name des Datenträgers. Bei elektronischen Datenträgern normalerweise das Volume-Label. Bei einem Server der Servername. Bei analogen Videobändern die Bandnummer. / Name des Datenträgers. Bei elektronischen Datenträgern normalerweise das Volume-Label. Bei einem Server der Servername. Bei analogen Videobändern die Bandnummer. / Nom du support de données. Pour les supports de données électroniques, normalement le label volume. Pour un serveur, le nom du serveur. Pour des bandes vidéo analogiques, les numéros de bandes.';
 ALTER TABLE qgep_od.data_media ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.data_media.kind IS 'yyy_Beschreibt die Art des Datenträgers / Beschreibt die Art des Datenträgers / Décrit le genre de support de données';
 ALTER TABLE qgep_od.data_media ADD COLUMN location  varchar(50) ;
COMMENT ON COLUMN qgep_od.data_media.location IS 'Where is the / Wo befindet sich der Datenträger / Où se trouve le support de données';
 ALTER TABLE qgep_od.data_media ADD COLUMN path  varchar(100) ;
COMMENT ON COLUMN qgep_od.data_media.path IS 'yyy_Zugriffspfad zum Datenträger. z.B. DVD-Laufwerk -> D: , Server -> \\server\videos, Harddisk -> c:\videos . Kann auch eine URL sein. Bei einem analogen Videoband leer / Zugriffspfad zum Datenträger. z.B. DVD-Laufwerk -> D: , Server -> \\server\videos, Harddisk -> c:\videos . Kann auch eine URL sein. Bei einem analogen Videoband leer / Chemin d’accès au support de données, p. ex. lecteur DVD -> D: , - serveur -> \\ server\videos , disque dur -> c:\videos , Peut aussi être une URL. Pour une bande vidéo analogique: vide';
 ALTER TABLE qgep_od.data_media ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.data_media.remark IS 'General remarks / Bemerkungen zum Datenträger / Remarques concernant le support de données';
 ALTER TABLE qgep_od.data_media ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.data_media.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE qgep_od.data_media ADD COLUMN fk_dataowner varchar(16);
 ALTER TABLE qgep_od.data_media ADD COLUMN fk_provider varchar (16);
-------
CREATE TRIGGER
update_last_modified_data_media
BEFORE UPDATE OR INSERT ON
 qgep_od.data_media
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
-------
CREATE TABLE qgep_od.file
(
   obj_id varchar(16) NOT NULL,
   CONSTRAINT pkey_qgep_od_file_obj_id PRIMARY KEY (obj_id)
)
WITH (
   OIDS = False
);
CREATE SEQUENCE qgep_od.seq_file_oid INCREMENT 1 MINVALUE 0 MAXVALUE 999999 START 0;
 ALTER TABLE qgep_od.file ALTER COLUMN obj_id SET DEFAULT qgep_sys.generate_oid('qgep_od','file');
COMMENT ON COLUMN qgep_od.file.obj_id IS 'INTERLIS STANDARD OID (with Postfix/Präfix) or UUOID, see www.interlis.ch';
 ALTER TABLE qgep_od.file ADD COLUMN class  integer ;
COMMENT ON COLUMN qgep_od.file.class IS 'yyy_Gibt an, zu welcher Klasse des VSA-DSS-Datenmodells die Datei gehört. Grundsätzlich alle Klassen möglich. Im Rahmen der Kanalfernsehaufnahmen hauptsächlich Kanal, Normschachtschaden, Kanalschaden und Untersuchung. / Gibt an, zu welcher Klasse des VSA-DSS-Datenmodells die Datei gehört. Grundsätzlich alle Klassen möglich. Im Rahmen der Kanalfernsehaufnahmen hauptsächlich Kanal, Normschachtschaden, Kanalschaden und Untersuchung. / Indique à quelle classe du modèle de données de VSA-SDEE appartient le fichier. Toutes les classes sont possible. Surtout CANALISATION, DOMMAGE_CHAMBRE_STANDARD, DOMMAGE_CANALISATION, INSPECTION.';
 ALTER TABLE qgep_od.file ADD COLUMN identifier  varchar(40) ;
COMMENT ON COLUMN qgep_od.file.identifier IS 'yyy_Name der Datei mit Dateiendung. Z.B video_01.mpg oder haltung_01.ipf / Name der Datei mit Dateiendung. Z.B video_01.mpg oder haltung_01.ipf / Nom du fichier avec terminaison du fichier. P. ex. video_01.mpg ou canalisation_01.ipf';
 ALTER TABLE qgep_od.file ADD COLUMN kind  integer ;
COMMENT ON COLUMN qgep_od.file.kind IS 'yyy_Beschreibt die Art der Datei. Für analoge Videos auf Bändern ist der Typ "Video" einzusetzen. Die Bezeichnung wird dann gleich gesetzt wie die Bezeichnung des Videobandes. / Beschreibt die Art der Datei. Für analoge Videos auf Bändern ist der Typ "Video" einzusetzen. Die Bezeichnung wird dann gleich gesetzt wie die Bezeichnung des Videobandes. / Décrit le type de fichier. Pour les vidéos analo-giques sur bandes, le type « vidéo » doit être entré. La désignation sera ensuite la même que celle de la bande vidéo.';
 ALTER TABLE qgep_od.file ADD COLUMN object  varchar(41) ;
COMMENT ON COLUMN qgep_od.file.object IS 'yyy_Objekt-ID (OBJ_ID) des Datensatzes zu dem die Datei gehört / Objekt-ID (OBJ_ID) des Datensatzes zu dem die Datei gehört / Identification de l’ensemble de données auquel le fichier appartient (OBJ_ID)';
 ALTER TABLE qgep_od.file ADD COLUMN path_relative varchar(200) ;
COMMENT ON COLUMN qgep_od.file.path_relative IS 'yyy_Zusätzlicher Relativer Pfad, wo die Datei auf dem Datenträger zu finden ist. Z.B. DVD_01. / Zusätzlicher Relativer Pfad, wo die Datei auf dem Datenträger zu finden ist. Z.B. DVD_01. / Accès relatif supplémentaire à l’emplacement du fichier sur le support de données. P. ex. DVD_01';
 ALTER TABLE qgep_od.file ADD COLUMN remark  varchar(80) ;
COMMENT ON COLUMN qgep_od.file.remark IS 'General remarks / Allgemeine Bemerkungen / Remarques générales';
 ALTER TABLE qgep_od.file ADD COLUMN last_modification TIMESTAMP without time zone DEFAULT now();
COMMENT ON COLUMN qgep_od.file.last_modification IS 'Last modification / Letzte_Aenderung / Derniere_modification: INTERLIS_1_DATE';
 ALTER TABLE qgep_od.file ADD COLUMN fk_dataowner varchar(16);
 ALTER TABLE qgep_od.file ADD COLUMN fk_provider varchar (16);
-------
CREATE TRIGGER
update_last_modified_file
BEFORE UPDATE OR INSERT ON
 qgep_od.file
FOR EACH ROW EXECUTE PROCEDURE
 qgep_sys.update_last_modified();

-------
------------ Relationships and Value Tables ----------- ;
ALTER TABLE qgep_od.examination ADD CONSTRAINT oorel_od_examination_maintenance_event FOREIGN KEY (obj_id) REFERENCES qgep_od.maintenance_event(obj_id) ON DELETE cascade;
CREATE TABLE qgep_vl.examination_recording_type () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.examination_recording_type ADD CONSTRAINT pkey_qgep_vl_examination_recording_type_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3681,3681,'other','andere','autre', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3682,3682,'field_visit','Begehung','parcours', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3683,3683,'deformation_measurement','Deformationsmessung','mesure_deformation', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3684,3684,'leak_test','Dichtheitspruefung','examen_etancheite', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3685,3685,'georadar','Georadar','georadar', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3686,3686,'channel_TV','Kanalfernsehen','camera_canalisations', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_recording_type (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3687,3687,'unknown','unbekannt','inconnu', '', '', '', 'true');
 ALTER TABLE qgep_od.examination ADD CONSTRAINT fkey_vl_examination_recording_type FOREIGN KEY (recording_type)
 REFERENCES qgep_vl.examination_recording_type (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.examination_weather () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.examination_weather ADD CONSTRAINT pkey_qgep_vl_examination_weather_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.examination_weather (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3699,3699,'covered_rainy','bedeckt_regnerisch','couvert_pluvieux', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_weather (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3700,3700,'drizzle','Nieselregen','bruine', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_weather (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3701,3701,'rain','Regen','pluie', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_weather (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3702,3702,'snowfall','Schneefall','chute_neige', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_weather (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3703,3703,'nice_dry','schoen_trocken','beau_sec', '', '', '', 'true');
 INSERT INTO qgep_vl.examination_weather (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3704,3704,'unknown','unbekannt','inconnu', '', '', '', 'true');
 ALTER TABLE qgep_od.examination ADD CONSTRAINT fkey_vl_examination_weather FOREIGN KEY (weather)
 REFERENCES qgep_vl.examination_weather (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.examination ADD COLUMN fk_reach_point varchar (16);
ALTER TABLE qgep_od.examination ADD CONSTRAINT rel_examination_reach_point FOREIGN KEY (fk_reach_point) REFERENCES qgep_od.reach_point(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.damage_connection () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.damage_connection ADD CONSTRAINT pkey_qgep_vl_damage_connection_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.damage_connection (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (8498,8498,'yes','ja','oui', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_connection (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (8499,8499,'no','nein','non', '', '', '', 'true');
 ALTER TABLE qgep_od.damage ADD CONSTRAINT fkey_vl_damage_connection FOREIGN KEY (connection)
 REFERENCES qgep_vl.damage_connection (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.damage_single_damage_class () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.damage_single_damage_class ADD CONSTRAINT pkey_qgep_vl_damage_single_damage_class_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.damage_single_damage_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3707,3707,'EZ0','EZ0','EZ0', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_single_damage_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3708,3708,'EZ1','EZ1','EZ1', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_single_damage_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3709,3709,'EZ2','EZ2','EZ2', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_single_damage_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3710,3710,'EZ3','EZ3','EZ3', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_single_damage_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3711,3711,'EZ4','EZ4','EZ4', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_single_damage_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4561,4561,'unknown','unbekannt','inconnu', '', '', '', 'true');
 ALTER TABLE qgep_od.damage ADD CONSTRAINT fkey_vl_damage_single_damage_class FOREIGN KEY (single_damage_class)
 REFERENCES qgep_vl.damage_single_damage_class (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.damage_channel ADD CONSTRAINT oorel_od_damage_channel_damage FOREIGN KEY (obj_id) REFERENCES qgep_od.damage(obj_id) ON DELETE cascade;
CREATE TABLE qgep_vl.damage_channel_channel_damage_code () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.damage_channel_channel_damage_code ADD CONSTRAINT pkey_qgep_vl_damage_channel_channel_damage_code_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4103,4103,'AECXA','AECXA','AECXA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4104,4104,'AECXB','AECXB','AECXB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4105,4105,'AECXC','AECXC','AECXC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4106,4106,'AECXD','AECXD','AECXD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4107,4107,'AECXE','AECXE','AECXE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4108,4108,'AECXF','AECXF','AECXF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4109,4109,'AECXG','AECXG','AECXG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4110,4110,'AECXH','AECXH','AECXH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4111,4111,'AEDXA','AEDXA','AEDXA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4112,4112,'AEDXB','AEDXB','AEDXB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4113,4113,'AEDXC','AEDXC','AEDXC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4114,4114,'AEDXD','AEDXD','AEDXD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4115,4115,'AEDXE','AEDXE','AEDXE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4116,4116,'AEDXF','AEDXF','AEDXF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4117,4117,'AEDXG','AEDXG','AEDXG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4118,4118,'AEDXH','AEDXH','AEDXH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4119,4119,'AEDXI','AEDXI','AEDXI', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4120,4120,'AEDXJ','AEDXJ','AEDXJ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4121,4121,'AEDXK','AEDXK','AEDXK', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4122,4122,'AEDXL','AEDXL','AEDXL', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4123,4123,'AEDXM','AEDXM','AEDXM', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4124,4124,'AEDXN','AEDXN','AEDXN', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4125,4125,'AEDXO','AEDXO','AEDXO', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4126,4126,'AEDXP','AEDXP','AEDXP', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4127,4127,'AEDXQ','AEDXQ','AEDXQ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4128,4128,'AEDXR','AEDXR','AEDXR', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4129,4129,'AEDXS','AEDXS','AEDXS', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4130,4130,'AEDXT','AEDXT','AEDXT', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4131,4131,'AEDXU','AEDXU','AEDXU', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4132,4132,'AEDXV','AEDXV','AEDXV', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4133,4133,'AEDXW','AEDXW','AEDXW', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4134,4134,'AEDXX','AEDXX','AEDXX', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4135,4135,'AEF','AEF','AEF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3900,3900,'BAAA','BAAA','BAAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3901,3901,'BAAB','BAAB','BAAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3902,3902,'BABAA','BABAA','BABAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3903,3903,'BABAB','BABAB','BABAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3904,3904,'BABAC','BABAC','BABAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3905,3905,'BABAD','BABAD','BABAD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3906,3906,'BABBA','BABBA','BABBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3907,3907,'BABBB','BABBB','BABBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3908,3908,'BABBC','BABBC','BABBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3909,3909,'BABBD','BABBD','BABBD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3910,3910,'BABCA','BABCA','BABCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3911,3911,'BABCB','BABCB','BABCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3912,3912,'BABCC','BABCC','BABCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3913,3913,'BABCD','BABCD','BABCD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3914,3914,'BACA','BACA','BACA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3915,3915,'BACB','BACB','BACB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3916,3916,'BACC','BACC','BACC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3917,3917,'BADA','BADA','BADA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3918,3918,'BADB','BADB','BADB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3919,3919,'BADC','BADC','BADC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3920,3920,'BADD','BADD','BADD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3921,3921,'BAE','BAE','BAE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3922,3922,'BAFAA','BAFAA','BAFAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3923,3923,'BAFAB','BAFAB','BAFAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3924,3924,'BAFAC','BAFAC','BAFAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3925,3925,'BAFAD','BAFAD','BAFAD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3926,3926,'BAFAE','BAFAE','BAFAE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3927,3927,'BAFBA','BAFBA','BAFBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3928,3928,'BAFBE','BAFBE','BAFBE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3929,3929,'BAFCA','BAFCA','BAFCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3930,3930,'BAFCB','BAFCB','BAFCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3931,3931,'BAFCC','BAFCC','BAFCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3932,3932,'BAFCD','BAFCD','BAFCD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3933,3933,'BAFCE','BAFCE','BAFCE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3934,3934,'BAFDA','BAFDA','BAFDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3935,3935,'BAFDB','BAFDB','BAFDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3936,3936,'BAFDC','BAFDC','BAFDC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3937,3937,'BAFDD','BAFDD','BAFDD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3938,3938,'BAFDE','BAFDE','BAFDE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3939,3939,'BAFEA','BAFEA','BAFEA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3940,3940,'BAFEB','BAFEB','BAFEB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3941,3941,'BAFEC','BAFEC','BAFEC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3942,3942,'BAFED','BAFED','BAFED', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3943,3943,'BAFEE','BAFEE','BAFEE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3944,3944,'BAFFA','BAFFA','BAFFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3945,3945,'BAFFB','BAFFB','BAFFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3946,3946,'BAFFC','BAFFC','BAFFC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3947,3947,'BAFFD','BAFFD','BAFFD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3948,3948,'BAFFE','BAFFE','BAFFE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3949,3949,'BAFGA','BAFGA','BAFGA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3950,3950,'BAFGB','BAFGB','BAFGB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3951,3951,'BAFGC','BAFGC','BAFGC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3952,3952,'BAFGD','BAFGD','BAFGD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3953,3953,'BAFGE','BAFGE','BAFGE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3954,3954,'BAFHB','BAFHB','BAFHB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3955,3955,'BAFHC','BAFHC','BAFHC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3956,3956,'BAFHD','BAFHD','BAFHD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3957,3957,'BAFHE','BAFHE','BAFHE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3958,3958,'BAFIA','BAFIA','BAFIA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3959,3959,'BAFIB','BAFIB','BAFIB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3960,3960,'BAFIC','BAFIC','BAFIC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3961,3961,'BAFID','BAFID','BAFID', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3962,3962,'BAFIE','BAFIE','BAFIE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3963,3963,'BAFJB','BAFJB','BAFJB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3964,3964,'BAFJC','BAFJC','BAFJC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3965,3965,'BAFJD','BAFJD','BAFJD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3966,3966,'BAFJE','BAFJE','BAFJE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3967,3967,'BAFZA','BAFZA','BAFZA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3968,3968,'BAFZB','BAFZB','BAFZB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3969,3969,'BAFZC','BAFZC','BAFZC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3970,3970,'BAFZD','BAFZD','BAFZD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3971,3971,'BAFZE','BAFZE','BAFZE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3972,3972,'BAGA','BAGA','BAGA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3973,3973,'BAHA','BAHA','BAHA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3974,3974,'BAHB','BAHB','BAHB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3975,3975,'BAHC','BAHC','BAHC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3976,3976,'BAHD','BAHD','BAHD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3977,3977,'BAHE','BAHE','BAHE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3978,3978,'BAHZ','BAHZ','BAHZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3979,3979,'BAIAA','BAIAA','BAIAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3980,3980,'BAIAB','BAIAB','BAIAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3981,3981,'BAIAC','BAIAC','BAIAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3982,3982,'BAIAD','BAIAD','BAIAD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3983,3983,'BAIZ','BAIZ','BAIZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3984,3984,'BAJA','BAJA','BAJA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3985,3985,'BAJB','BAJB','BAJB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3986,3986,'BAJC','BAJC','BAJC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3987,3987,'BAKA','BAKA','BAKA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3988,3988,'BAKB','BAKB','BAKB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3989,3989,'BAKC','BAKC','BAKC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3990,3990,'BAKDA','BAKDA','BAKDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3991,3991,'BAKDB','BAKDB','BAKDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3992,3992,'BAKDC','BAKDC','BAKDC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3993,3993,'BAKE','BAKE','BAKE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3994,3994,'BAKZ','BAKZ','BAKZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3995,3995,'BALA','BALA','BALA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3996,3996,'BALB','BALB','BALB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3997,3997,'BALZ','BALZ','BALZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3998,3998,'BAMA','BAMA','BAMA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3999,3999,'BAMB','BAMB','BAMB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4000,4000,'BAMC','BAMC','BAMC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4001,4001,'BAN','BAN','BAN', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4002,4002,'BAO','BAO','BAO', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4003,4003,'BAP','BAP','BAP', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4004,4004,'BBAA','BBAA','BBAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4005,4005,'BBAB','BBAB','BBAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4006,4006,'BBAC','BBAC','BBAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4007,4007,'BBBA','BBBA','BBBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4008,4008,'BBBB','BBBB','BBBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4009,4009,'BBBC','BBBC','BBBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4010,4010,'BBBZ','BBBZ','BBBZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4011,4011,'BBCA','BBCA','BBCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4012,4012,'BBCB','BBCB','BBCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4013,4013,'BBCC','BBCC','BBCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4014,4014,'BBCZ','BBCZ','BBCZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4015,4015,'BBDA','BBDA','BBDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4016,4016,'BBDB','BBDB','BBDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4017,4017,'BBDC','BBDC','BBDC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4018,4018,'BBDD','BBDD','BBDD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4019,4019,'BBDZ','BBDZ','BBDZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4020,4020,'BBEA','BBEA','BBEA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4021,4021,'BBEB','BBEB','BBEB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4022,4022,'BBEC','BBEC','BBEC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4023,4023,'BBED','BBED','BBED', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4024,4024,'BBEE','BBEE','BBEE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4025,4025,'BBEF','BBEF','BBEF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4026,4026,'BBEG','BBEG','BBEG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4027,4027,'BBEH','BBEH','BBEH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4028,4028,'BBEZ','BBEZ','BBEZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4029,4029,'BBFA','BBFA','BBFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4030,4030,'BBFB','BBFB','BBFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4031,4031,'BBFC','BBFC','BBFC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4032,4032,'BBFD','BBFD','BBFD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4033,4033,'BBG','BBG','BBG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4034,4034,'BBHAA','BBHAA','BBHAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4035,4035,'BBHAB','BBHAB','BBHAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4036,4036,'BBHAC','BBHAC','BBHAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4037,4037,'BBHAZ','BBHAZ','BBHAZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4038,4038,'BBHBA','BBHBA','BBHBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4039,4039,'BBHBB','BBHBB','BBHBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4040,4040,'BBHBC','BBHBC','BBHBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4041,4041,'BBHBZ','BBHBZ','BBHBZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4042,4042,'BBHZA','BBHZA','BBHZA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4043,4043,'BBHZB','BBHZB','BBHZB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4044,4044,'BBHZC','BBHZC','BBHZC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4045,4045,'BBHZZ','BBHZZ','BBHZZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4046,4046,'BCAAA','BCAAA','BCAAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4047,4047,'BCAAB','BCAAB','BCAAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4048,4048,'BCABA','BCABA','BCABA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4049,4049,'BCABB','BCABB','BCABB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4050,4050,'BCACA','BCACA','BCACA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4051,4051,'BCACB','BCACB','BCACB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4052,4052,'BCADA','BCADA','BCADA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4053,4053,'BCADB','BCADB','BCADB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4054,4054,'BCAEA','BCAEA','BCAEA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4055,4055,'BCAEB','BCAEB','BCAEB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4056,4056,'BCAFA','BCAFA','BCAFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4057,4057,'BCAFB','BCAFB','BCAFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4058,4058,'BCAGA','BCAGA','BCAGA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4059,4059,'BCAGB','BCAGB','BCAGB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4060,4060,'BCAZA','BCAZA','BCAZA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4061,4061,'BCAZB','BCAZB','BCAZB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4062,4062,'BCBA','BCBA','BCBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4063,4063,'BCBB','BCBB','BCBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4064,4064,'BCBC','BCBC','BCBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4065,4065,'BCBD','BCBD','BCBD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4066,4066,'BCBE','BCBE','BCBE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4067,4067,'BCBZ','BCBZ','BCBZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4068,4068,'BCCAA','BCCAA','BCCAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4069,4069,'BCCAB','BCCAB','BCCAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4070,4070,'BCCAY','BCCAY','BCCAY', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4071,4071,'BCCBA','BCCBA','BCCBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4072,4072,'BCCBB','BCCBB','BCCBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4073,4073,'BCCBY','BCCBY','BCCBY', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4074,4074,'BCCYA','BCCYA','BCCYA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4075,4075,'BCCYB','BCCYB','BCCYB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4076,4076,'BCD','BCD','BCD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4077,4077,'BCE','BCE','BCE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4078,4078,'BDA','BDA','BDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4079,4079,'BDB','BDB','BDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4136,4136,'BDBA','BDBA','BDBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4137,4137,'BDBB','BDBB','BDBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4138,4138,'BDBC','BDBC','BDBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4139,4139,'BDBD','BDBD','BDBD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4140,4140,'BDBE','BDBE','BDBE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4141,4141,'BDBF','BDBF','BDBF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4142,4142,'BDBG','BDBG','BDBG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4143,4143,'BDBH','BDBH','BDBH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4144,4144,'BDBI','BDBI','BDBI', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4145,4145,'BDBJ','BDBJ','BDBJ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4146,4146,'BDBK','BDBK','BDBK', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4147,4147,'BDBL','BDBL','BDBL', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4080,4080,'BDCA','BDCA','BDCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4081,4081,'BDCB','BDCB','BDCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4082,4082,'BDCC','BDCC','BDCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4083,4083,'BDCZ','BDCZ','BDCZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4084,4084,'BDDA','BDDA','BDDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4085,4085,'BDDB','BDDB','BDDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4086,4086,'BDEAA','BDEAA','BDEAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4087,4087,'BDEAB','BDEAB','BDEAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4088,4088,'BDEAC','BDEAC','BDEAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4089,4089,'BDEBA','BDEBA','BDEBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4090,4090,'BDEBB','BDEBB','BDEBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4091,4091,'BDEBC','BDEBC','BDEBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4092,4092,'BDEYA','BDEYA','BDEYA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4093,4093,'BDEYB','BDEYB','BDEYB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4094,4094,'BDEYY','BDEYY','BDEYY', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4095,4095,'BDFA','BDFA','BDFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4096,4096,'BDFB','BDFB','BDFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4097,4097,'BDFC','BDFC','BDFC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4098,4098,'BDFZ','BDFZ','BDFZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4099,4099,'BDGA','BDGA','BDGA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4100,4100,'BDGB','BDGB','BDGB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4101,4101,'BDGC','BDGC','BDGC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4102,4102,'BDGZ','BDGZ','BDGZ', '', '', '', 'true');
-- 1.5.6.8_kek_add_vl_damage_channel_channel_damage_code_add_new_values
-- adding new codes to code lists
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8834,8834,'BABAE','BABAE','BABAE', 'BABAE', 'BABAE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8835,8835,'BABBE','BABBE','BABBE', 'BABBE', 'BABBE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8836,8836,'BABCE','BABCE','BABCE', 'BABCE', 'BABCE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8837,8837,'BAFAZ','BAFAZ','BAFAZ', 'BAFAZ', 'BAFAZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8838,8838,'BAFBZ','BAFBZ','BAFBZ', 'BAFBZ', 'BAFBZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8839,8839,'BAFCZ','BAFCZ','BAFCZ', 'BAFCZ', 'BAFCZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8840,8840,'BAFDZ','BAFDZ','BAFDZ', 'BAFDZ', 'BAFDZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8841,8841,'BAFEZ','BAFEZ','BAFEZ', 'BAFEZ', 'BAFEZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8842,8842,'BAFFZ','BAFFZ','BAFFZ', 'BAFFZ', 'BAFFZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8843,8843,'BAFGZ','BAFGZ','BAFGZ', 'BAFGZ', 'BAFGZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8844,8844,'BAFIZ','BAFIZ','BAFIZ', 'BAFIZ', 'BAFIZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8845,8845,'BAFJZ','BAFJZ','BAFJZ', 'BAFJZ', 'BAFJZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8846,8846,'BAFKA','BAFKA','BAFKA', 'BAFKA', 'BAFKA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8847,8847,'BAFKE','BAFKE','BAFKE', 'BAFKE', 'BAFKE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8848,8848,'BAFKZ','BAFKZ','BAFKZ', 'BAFKZ', 'BAFKZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8849,8849,'BAFZZ','BAFZZ','BAFZZ', 'BAFZZ', 'BAFZZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8850,8850,'BAKDD','BAKDD','BAKDD', 'BAKDD', 'BAKDD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8851,8851,'BAKF','BAKF','BAKF', 'BAKF', 'BAKF', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8852,8852,'BAKG','BAKG','BAKG', 'BAKG', 'BAKG', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8853,8853,'BAKH','BAKH','BAKH', 'BAKH', 'BAKH', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8854,8854,'BAKI','BAKI','BAKI', 'BAKI', 'BAKI', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8855,8855,'BAKJ','BAKJ','BAKJ', 'BAKJ', 'BAKJ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8856,8856,'BAKK','BAKK','BAKK', 'BAKK', 'BAKK', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8857,8857,'BAKL','BAKL','BAKL', 'BAKL', 'BAKL', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8858,8858,'BAKM','BAKM','BAKM', 'BAKM', 'BAKM', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8859,8859,'BAKN','BAKN','BAKN', 'BAKN', 'BAKN', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8860,8860,'BALC','BALC','BALC', 'BALC', 'BALC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8861,8861,'BALD','BALD','BALD', 'BALD', 'BALD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8862,8862,'BALE','BALE','BALE', 'BALE', 'BALE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8863,8863,'BALF','BALF','BALF', 'BALF', 'BALF', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8864,8864,'BALGA','BALGA','BALGA', 'BALGA', 'BALGA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8865,8865,'BALGB','BALGB','BALGB', 'BALGB', 'BALGB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8866,8866,'BALGC','BALGC','BALGC', 'BALGC', 'BALGC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8867,8867,'BALGD','BALGD','BALGD', 'BALGD', 'BALGD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8868,8868,'BCBF','BCBF','BCBF', 'BCBF', 'BCBF', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8869,8869,'BCBG','BCBG','BCBG', 'BCBG', 'BCBG', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8870,8870,'BCDXP','BCDXP','BCDXP', 'BCDXP', 'BCDXP', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8871,8871,'BCEXP','BCEXP','BCEXP', 'BCEXP', 'BCEXP', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8872,8872,'BDBM','BDBM','BDBM', 'BDBM', 'BDBM', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8873,8873,'BDCAA','BDCAA','BDCAA', 'BDCAA', 'BDCAA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8874,8874,'BDCAB','BDCAB','BDCAB', 'BDCAB', 'BDCAB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8875,8875,'BDCAC','BDCAC','BDCAC', 'BDCAC', 'BDCAC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8876,8876,'BDCAD','BDCAD','BDCAD', 'BDCAD', 'BDCAD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8877,8877,'BDCAE','BDCAE','BDCAE', 'BDCAE', 'BDCAE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8878,8878,'BDCAZ','BDCAZ','BDCAZ', 'BDCAZ', 'BDCAZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8879,8879,'BDCBA','BDCBA','BDCBA', 'BDCBA', 'BDCBA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8880,8880,'BDCBB','BDCBB','BDCBB', 'BDCBB', 'BDCBB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8881,8881,'BDCBC','BDCBC','BDCBC', 'BDCBC', 'BDCBC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8882,8882,'BDCBD','BDCBD','BDCBD', 'BDCBD', 'BDCBD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8883,8883,'BDCBE','BDCBE','BDCBE', 'BDCBE', 'BDCBE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8884,8884,'BDCBZ','BDCBZ','BDCBZ', 'BDCBZ', 'BDCBZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8885,8885,'BDCCA','BDCCA','BDCCA', 'BDCCA', 'BDCCA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8886,8886,'BDCCB','BDCCB','BDCCB', 'BDCCB', 'BDCCB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8887,8887,'BDCCC','BDCCC','BDCCC', 'BDCCC', 'BDCCC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8888,8888,'BDCCD','BDCCD','BDCCD', 'BDCCD', 'BDCCD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8889,8889,'BDCCE','BDCCE','BDCCE', 'BDCCE', 'BDCCE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8890,8890,'BDCCZ','BDCCZ','BDCCZ', 'BDCCZ', 'BDCCZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8891,8891,'BDCZA','BDCZA','BDCZA', 'BDCZA', 'BDCZA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8892,8892,'BDCZB','BDCZB','BDCZB', 'BDCZB', 'BDCZB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8893,8893,'BDCZC','BDCZC','BDCZC', 'BDCZC', 'BDCZC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8894,8894,'BDCZD','BDCZD','BDCZD', 'BDCZD', 'BDCZD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8895,8895,'BDCZE','BDCZE','BDCZE', 'BDCZE', 'BDCZE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8896,8896,'BDCZZ','BDCZZ','BDCZZ', 'BDCZZ', 'BDCZZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8897,8897,'BDDC','BDDC','BDDC', 'BDDC', 'BDDC', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8898,8898,'BDDD','BDDD','BDDD', 'BDDD', 'BDDD', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8899,8899,'BDDE','BDDE','BDDE', 'BDDE', 'BDDE', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8900,8900,'BDECA','BDECA','BDECA', 'BDECA', 'BDECA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8901,8901,'BDECB','BDECB','BDECB', 'BDECB', 'BDECB', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8902,8902,'BDECC','BDECC','BDECC', 'BDECC', 'BDECC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8903,8903,'BDEDA','BDEDA','BDEDA', 'BDEDA', 'BDEDA', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8904,8904,'BDEDB','BDEDB','BDEDB', 'BDEDB', 'BDEDB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8905,8905,'BDEDC','BDEDC','BDEDC', 'BDEDC', 'BDEDC', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8906,8906,'BDEEA','BDEEA','BDEEA', 'BDEEA', 'BDEEA', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8907,8907,'BDEEB','BDEEB','BDEEB', 'BDEEB', 'BDEEB', '', '', '', '', '', 'true'); 
 INSERT INTO qgep_vl.damage_channel_channel_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8908,8908,'BDEEC','BDEEC','BDEEC', 'BDEEC', 'BDEEC', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.damage_channel ADD CONSTRAINT fkey_vl_damage_channel_channel_damage_code FOREIGN KEY (channel_damage_code)
 REFERENCES qgep_vl.damage_channel_channel_damage_code (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.damage_manhole ADD CONSTRAINT oorel_od_damage_manhole_damage FOREIGN KEY (obj_id) REFERENCES qgep_od.damage(obj_id) ON DELETE cascade;
CREATE TABLE qgep_vl.damage_manhole_manhole_damage_code () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.damage_manhole_manhole_damage_code ADD CONSTRAINT pkey_qgep_vl_damage_manhole_manhole_damage_code_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4148,4148,'DAAA','DAAA','DAAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4149,4149,'DAAB','DAAB','DAAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4150,4150,'DABAA','DABAA','DABAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4151,4151,'DABAB','DABAB','DABAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4152,4152,'DABAC','DABAC','DABAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4153,4153,'DABAD','DABAD','DABAD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4154,4154,'DABBA','DABBA','DABBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4155,4155,'DABBB','DABBB','DABBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4156,4156,'DABBC','DABBC','DABBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4157,4157,'DABBD','DABBD','DABBD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4158,4158,'DABCA','DABCA','DABCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4159,4159,'DABCB','DABCB','DABCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4160,4160,'DABCC','DABCC','DABCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4161,4161,'DABCD','DABCD','DABCD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4162,4162,'DACA','DACA','DACA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4163,4163,'DACB','DACB','DACB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4164,4164,'DACC','DACC','DACC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4165,4165,'DADA','DADA','DADA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4166,4166,'DADB','DADB','DADB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4167,4167,'DADC','DADC','DADC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4168,4168,'DAE','DAE','DAE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4169,4169,'DAFAA','DAFAA','DAFAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4170,4170,'DAFAB','DAFAB','DAFAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4171,4171,'DAFAC','DAFAC','DAFAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4172,4172,'DAFAD','DAFAD','DAFAD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4173,4173,'DAFAE','DAFAE','DAFAE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4174,4174,'DAFBA','DAFBA','DAFBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4175,4175,'DAFBE','DAFBE','DAFBE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4176,4176,'DAFCA','DAFCA','DAFCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4177,4177,'DAFCB','DAFCB','DAFCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4178,4178,'DAFCC','DAFCC','DAFCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4179,4179,'DAFCD','DAFCD','DAFCD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4180,4180,'DAFCE','DAFCE','DAFCE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4181,4181,'DAFDA','DAFDA','DAFDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4182,4182,'DAFDB','DAFDB','DAFDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4183,4183,'DAFDC','DAFDC','DAFDC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4184,4184,'DAFDD','DAFDD','DAFDD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4185,4185,'DAFDE','DAFDE','DAFDE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4186,4186,'DAFEA','DAFEA','DAFEA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4187,4187,'DAFEB','DAFEB','DAFEB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4188,4188,'DAFEC','DAFEC','DAFEC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4189,4189,'DAFED','DAFED','DAFED', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4190,4190,'DAFEE','DAFEE','DAFEE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4191,4191,'DAFFA','DAFFA','DAFFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4192,4192,'DAFFB','DAFFB','DAFFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4193,4193,'DAFFC','DAFFC','DAFFC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4194,4194,'DAFFD','DAFFD','DAFFD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4195,4195,'DAFFE','DAFFE','DAFFE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4196,4196,'DAFGA','DAFGA','DAFGA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4197,4197,'DAFGB','DAFGB','DAFGB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4198,4198,'DAFGC','DAFGC','DAFGC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4199,4199,'DAFGD','DAFGD','DAFGD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4200,4200,'DAFGE','DAFGE','DAFGE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4201,4201,'DAFHB','DAFHB','DAFHB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4202,4202,'DAFHC','DAFHC','DAFHC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4203,4203,'DAFHD','DAFHD','DAFHD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4204,4204,'DAFHE','DAFHE','DAFHE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4205,4205,'DAFIA','DAFIA','DAFIA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4206,4206,'DAFIB','DAFIB','DAFIB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4207,4207,'DAFIC','DAFIC','DAFIC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4208,4208,'DAFID','DAFID','DAFID', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4209,4209,'DAFIE','DAFIE','DAFIE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4210,4210,'DAFJB','DAFJB','DAFJB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4211,4211,'DAFJC','DAFJC','DAFJC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4212,4212,'DAFJD','DAFJD','DAFJD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4213,4213,'DAFJE','DAFJE','DAFJE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4214,4214,'DAFZA','DAFZA','DAFZA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4215,4215,'DAFZB','DAFZB','DAFZB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4216,4216,'DAFZC','DAFZC','DAFZC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4217,4217,'DAFZD','DAFZD','DAFZD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4218,4218,'DAFZE','DAFZE','DAFZE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4219,4219,'DAG','DAG','DAG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4220,4220,'DAHA','DAHA','DAHA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4221,4221,'DAHB','DAHB','DAHB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4222,4222,'DAHC','DAHC','DAHC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4223,4223,'DAHD','DAHD','DAHD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4224,4224,'DAHE','DAHE','DAHE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4225,4225,'DAHZ','DAHZ','DAHZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4226,4226,'DAIAA','DAIAA','DAIAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4227,4227,'DAIAB','DAIAB','DAIAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4228,4228,'DAIAC','DAIAC','DAIAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4229,4229,'DAIZ','DAIZ','DAIZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4230,4230,'DAJA','DAJA','DAJA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4231,4231,'DAJB','DAJB','DAJB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4232,4232,'DAJC','DAJC','DAJC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4233,4233,'DAKA','DAKA','DAKA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4234,4234,'DAKB','DAKB','DAKB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4235,4235,'DAKC','DAKC','DAKC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4236,4236,'DAKDA','DAKDA','DAKDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4237,4237,'DAKDB','DAKDB','DAKDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4238,4238,'DAKDC','DAKDC','DAKDC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4239,4239,'DAKE','DAKE','DAKE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4240,4240,'DAKZ','DAKZ','DAKZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4241,4241,'DALA','DALA','DALA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4242,4242,'DALB','DALB','DALB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4243,4243,'DALZ','DALZ','DALZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4244,4244,'DAMA','DAMA','DAMA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4245,4245,'DAMB','DAMB','DAMB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4246,4246,'DAMC','DAMC','DAMC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4247,4247,'DAN','DAN','DAN', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4248,4248,'DAO','DAO','DAO', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4249,4249,'DAP','DAP','DAP', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4250,4250,'DAQA','DAQA','DAQA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4251,4251,'DAQB','DAQB','DAQB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4252,4252,'DAQC','DAQC','DAQC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4253,4253,'DAQD','DAQD','DAQD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4254,4254,'DAQE','DAQE','DAQE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4255,4255,'DAQF','DAQF','DAQF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4256,4256,'DAQG','DAQG','DAQG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4257,4257,'DAQH','DAQH','DAQH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4258,4258,'DAQI','DAQI','DAQI', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4259,4259,'DAQJ','DAQJ','DAQJ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4260,4260,'DAQK','DAQK','DAQK', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4261,4261,'DAQZ','DAQZ','DAQZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4262,4262,'DARA','DARA','DARA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4263,4263,'DARB','DARB','DARB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4264,4264,'DARC','DARC','DARC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4265,4265,'DARD','DARD','DARD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4266,4266,'DARE','DARE','DARE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4267,4267,'DARF','DARF','DARF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4268,4268,'DARG','DARG','DARG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4269,4269,'DARH','DARH','DARH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4270,4270,'DARZ','DARZ','DARZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4271,4271,'DBAA','DBAA','DBAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4272,4272,'DBAB','DBAB','DBAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4273,4273,'DBAC','DBAC','DBAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4274,4274,'DBBA','DBBA','DBBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4275,4275,'DBBB','DBBB','DBBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4276,4276,'DBBC','DBBC','DBBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4277,4277,'DBBZ','DBBZ','DBBZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4278,4278,'DBCA','DBCA','DBCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4279,4279,'DBCB','DBCB','DBCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4280,4280,'DBCC','DBCC','DBCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4281,4281,'DBCZ','DBCZ','DBCZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4282,4282,'DBD','DBD','DBD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4283,4283,'DBEA','DBEA','DBEA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4284,4284,'DBEB','DBEB','DBEB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4285,4285,'DBEC','DBEC','DBEC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4286,4286,'DBED','DBED','DBED', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4287,4287,'DBEE','DBEE','DBEE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4288,4288,'DBEF','DBEF','DBEF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4289,4289,'DBEG','DBEG','DBEG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4290,4290,'DBEH','DBEH','DBEH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4291,4291,'DBEZ','DBEZ','DBEZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4292,4292,'DBFAA','DBFAA','DBFAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4293,4293,'DBFAB','DBFAB','DBFAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4294,4294,'DBFAC','DBFAC','DBFAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4295,4295,'DBFBA','DBFBA','DBFBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4296,4296,'DBFBB','DBFBB','DBFBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4297,4297,'DBFBC','DBFBC','DBFBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4298,4298,'DBFCA','DBFCA','DBFCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4299,4299,'DBFCB','DBFCB','DBFCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4300,4300,'DBFCC','DBFCC','DBFCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4301,4301,'DBFDA','DBFDA','DBFDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4302,4302,'DBFDB','DBFDB','DBFDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4303,4303,'DBFDC','DBFDC','DBFDC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4304,4304,'DBG','DBG','DBG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4305,4305,'DBHAA','DBHAA','DBHAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4306,4306,'DBHAB','DBHAB','DBHAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4307,4307,'DBHAC','DBHAC','DBHAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4308,4308,'DBHAZ','DBHAZ','DBHAZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4309,4309,'DBHBA','DBHBA','DBHBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4310,4310,'DBHBB','DBHBB','DBHBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4311,4311,'DBHBC','DBHBC','DBHBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4312,4312,'DBHBZ','DBHBZ','DBHBZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4313,4313,'DBHZA','DBHZA','DBHZA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4314,4314,'DBHZB','DBHZB','DBHZB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4315,4315,'DBHZC','DBHZC','DBHZC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4316,4316,'DBHZZ','DBHZZ','DBHZZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4317,4317,'DCAA','DCAA','DCAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4318,4318,'DCAB','DCAB','DCAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4319,4319,'DCAC','DCAC','DCAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4320,4320,'DCAD','DCAD','DCAD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4321,4321,'DCAE','DCAE','DCAE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4322,4322,'DCAF','DCAF','DCAF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4323,4323,'DCAZ','DCAZ','DCAZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4324,4324,'DCBA','DCBA','DCBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4325,4325,'DCBB','DCBB','DCBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4326,4326,'DCBC','DCBC','DCBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4327,4327,'DCBZ','DCBZ','DCBZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4328,4328,'DCFA','DCFA','DCFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4329,4329,'DCFB','DCFB','DCFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4330,4330,'DCFC','DCFC','DCFC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4331,4331,'DCFD','DCFD','DCFD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4332,4332,'DCFE','DCFE','DCFE', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4333,4333,'DCFF','DCFF','DCFF', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4334,4334,'DCFG','DCFG','DCFG', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4335,4335,'DCFH','DCFH','DCFH', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4336,4336,'DCFI','DCFI','DCFI', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4337,4337,'DCFJ','DCFJ','DCFJ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4338,4338,'DCFK','DCFK','DCFK', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4339,4339,'DCFL','DCFL','DCFL', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4340,4340,'DCFM','DCFM','DCFM', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4341,4341,'DCFN','DCFN','DCFN', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4342,4342,'DCFO','DCFO','DCFO', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4343,4343,'DCFP','DCFP','DCFP', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4344,4344,'DCFQ','DCFQ','DCFQ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4345,4345,'DCFR','DCFR','DCFR', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4346,4346,'DCFS','DCFS','DCFS', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4347,4347,'DCFT','DCFT','DCFT', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4348,4348,'DCFU','DCFU','DCFU', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4349,4349,'DCFV','DCFV','DCFV', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4350,4350,'DCFW','DCFW','DCFW', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4351,4351,'DCFX','DCFX','DCFX', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4352,4352,'DCGAA','DCGAA','DCGAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4353,4353,'DCGAB','DCGAB','DCGAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4354,4354,'DCGAC','DCGAC','DCGAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4355,4355,'DCGBA','DCGBA','DCGBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4356,4356,'DCGBB','DCGBB','DCGBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4357,4357,'DCGBC','DCGBC','DCGBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4358,4358,'DCGCA','DCGCA','DCGCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4359,4359,'DCGCB','DCGCB','DCGCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4360,4360,'DCGCC','DCGCC','DCGCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4361,4361,'DCGXA','DCGXA','DCGXA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4364,4364,'DCGXAA','DCGXAA','DCGXAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4365,4365,'DCGXAB','DCGXAB','DCGXAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4366,4366,'DCGXAC','DCGXAC','DCGXAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4362,4362,'DCGXB','DCGXB','DCGXB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4367,4367,'DCGXBA','DCGXBA','DCGXBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4368,4368,'DCGXBB','DCGXBB','DCGXBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4369,4369,'DCGXBC','DCGXBC','DCGXBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4363,4363,'DCGXC','DCGXC','DCGXC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4370,4370,'DCGXCA','DCGXCA','DCGXCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4371,4371,'DCGXCB','DCGXCB','DCGXCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4372,4372,'DCGXCC','DCGXCC','DCGXCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4373,4373,'DCGYA','DCGYA','DCGYA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4374,4374,'DCGYB','DCGYB','DCGYB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4375,4375,'DCGYC','DCGYC','DCGYC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4376,4376,'DCGZA','DCGZA','DCGZA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4377,4377,'DCGZB','DCGZB','DCGZB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4378,4378,'DCGZC','DCGZC','DCGZC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4379,4379,'DCHA','DCHA','DCHA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4380,4380,'DCHAA','DCHAA','DCHAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4381,4381,'DCHAB','DCHAB','DCHAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4382,4382,'DCHB','DCHB','DCHB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4383,4383,'DCIA','DCIA','DCIA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4384,4384,'DCIB','DCIB','DCIB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4385,4385,'DCLAA','DCLAA','DCLAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4386,4386,'DCLAB','DCLAB','DCLAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4387,4387,'DCLBA','DCLBA','DCLBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4388,4388,'DCLBB','DCLBB','DCLBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4389,4389,'DCLCA','DCLCA','DCLCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4390,4390,'DCLCB','DCLCB','DCLCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4391,4391,'DCMA','DCMA','DCMA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4392,4392,'DCMB','DCMB','DCMB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4393,4393,'DCMC','DCMC','DCMC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4394,4394,'DDA','DDA','DDA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4395,4395,'DDB','DDB','DDB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4396,4396,'DDCA','DDCA','DDCA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4397,4397,'DDCB','DDCB','DDCB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4398,4398,'DDCC','DDCC','DDCC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4399,4399,'DDCD','DDCD','DDCD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4400,4400,'DDCZ','DDCZ','DDCZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4401,4401,'DDD','DDD','DDD', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4402,4402,'DDEAA','DDEAA','DDEAA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4403,4403,'DDEAB','DDEAB','DDEAB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4404,4404,'DDEAC','DDEAC','DDEAC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4405,4405,'DDEBA','DDEBA','DDEBA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4406,4406,'DDEBB','DDEBB','DDEBB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4407,4407,'DDEBC','DDEBC','DDEBC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4408,4408,'DDEYA','DDEYA','DDEYA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4409,4409,'DDEYB','DDEYB','DDEYB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4410,4410,'DDEYY','DDEYY','DDEYY', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4411,4411,'DDFA','DDFA','DDFA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4412,4412,'DDFB','DDFB','DDFB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4413,4413,'DDFC','DDFC','DDFC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4414,4414,'DDFZ','DDFZ','DDFZ', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4416,4416,'DDGA','DDGA','DDGA', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4417,4417,'DDGB','DDGB','DDGB', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4418,4418,'DDGC','DDGC','DDGC', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (4419,4419,'DDGZ','DDGZ','DDGZ', '', '', '', 'true');
-- 1.5.6.7_kek_add_vl_damage_manhole_manhole_damage_code_add_new_values
-- adding new codes to code lists
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8909,8909,'DABAE','DABAE','DABAE', 'DABAE', 'DABAE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8910,8910,'DABBE','DABBE','DABBE', 'DABBE', 'DABBE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8911,8911,'DABCE','DABCE','DABCE', 'DABCE', 'DABCE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8912,8912,'DAFAZ','DAFAZ','DAFAZ', 'DAFAZ', 'DAFAZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8913,8913,'DAFBZ','DAFBZ','DAFBZ', 'DAFBZ', 'DAFBZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8914,8914,'DAFCZ','DAFCZ','DAFCZ', 'DAFCZ', 'DAFCZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8915,8915,'DAFDZ','DAFDZ','DAFDZ', 'DAFDZ', 'DAFDZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8916,8916,'DAFEZ','DAFEZ','DAFEZ', 'DAFEZ', 'DAFEZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8917,8917,'DAFFZ','DAFFZ','DAFFZ', 'DAFFZ', 'DAFFZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8918,8918,'DAFGZ','DAFGZ','DAFGZ', 'DAFGZ', 'DAFGZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8919,8919,'DAFIZ','DAFIZ','DAFIZ', 'DAFIZ', 'DAFIZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8920,8920,'DAFJZ','DAFJZ','DAFJZ', 'DAFJZ', 'DAFJZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8921,8921,'DAFKA','DAFKA','DAFKA', 'DAFKA', 'DAFKA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8922,8922,'DAFKE','DAFKE','DAFKE', 'DAFKE', 'DAFKE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8923,8923,'DAFKZ','DAFKZ','DAFKZ', 'DAFKZ', 'DAFKZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8924,8924,'DAFZZ','DAFZZ','DAFZZ', 'DAFZZ', 'DAFZZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8925,8925,'DAKDD','DAKDD','DAKDD', 'DAKDD', 'DAKDD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8926,8926,'DAKF','DAKF','DAKF', 'DAKF', 'DAKF', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8927,8927,'DAKG','DAKG','DAKG', 'DAKG', 'DAKG', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8928,8928,'DAKH','DAKH','DAKH', 'DAKH', 'DAKH', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8929,8929,'DAKI','DAKI','DAKI', 'DAKI', 'DAKI', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8930,8930,'DAKJ','DAKJ','DAKJ', 'DAKJ', 'DAKJ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8931,8931,'DAKK','DAKK','DAKK', 'DAKK', 'DAKK', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8932,8932,'DAKL','DAKL','DAKL', 'DAKL', 'DAKL', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8933,8933,'DAKM','DAKM','DAKM', 'DAKM', 'DAKM', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8934,8934,'DAKN','DAKN','DAKN', 'DAKN', 'DAKN', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8935,8935,'DALC','DALC','DALC', 'DALC', 'DALC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8936,8936,'DALD','DALD','DALD', 'DALD', 'DALD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8937,8937,'DALE','DALE','DALE', 'DALE', 'DALE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8938,8938,'DALF','DALF','DALF', 'DALF', 'DALF', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8939,8939,'DALG','DALG','DALG', 'DALG', 'DALG', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8940,8940,'DCBD','DCBD','DCBD', 'DCBD', 'DCBD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8941,8941,'DCBE','DCBE','DCBE', 'DCBE', 'DCBE', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8942,8942,'DCBF','DCBF','DCBF', 'DCBF', 'DCBF', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8943,8943,'DCHC','DCHC','DCHC', 'DCHC', 'DCHC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8944,8944,'DCIAA','DCIAA','DCIAA', 'DCIAA', 'DCIAA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8945,8945,'DCIAB','DCIAB','DCIAB', 'DCIAB', 'DCIAB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8946,8946,'DCIAC','DCIAC','DCIAC', 'DCIAC', 'DCIAC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8947,8947,'DCIAD','DCIAD','DCIAD', 'DCIAD', 'DCIAD', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8948,8948,'DCIAZ','DCIAZ','DCIAZ', 'DCIAZ', 'DCIAZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8949,8949,'DCIBY','DCIBY','DCIBY', 'DCIBY', 'DCIBY', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8950,8950,'DCICY','DCICY','DCICY', 'DCICY', 'DCICY', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8951,8951,'DDCAB','DDCAB','DDCAB', 'DDCAB', 'DDCAB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8952,8952,'DDCAZ','DDCAZ','DDCAZ', 'DDCAZ', 'DDCAZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8953,8953,'DDCBA','DDCBA','DDCBA', 'DDCBA', 'DDCBA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8954,8954,'DDCBB','DDCBB','DDCBB', 'DDCBB', 'DDCBB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8955,8955,'DDCBZ','DDCBZ','DDCBZ', 'DDCBZ', 'DDCBZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8956,8956,'DDCCA','DDCCA','DDCCA', 'DDCCA', 'DDCCA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8957,8957,'DDCCB','DDCCB','DDCCB', 'DDCCB', 'DDCCB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8958,8958,'DDCCZ','DDCCZ','DDCCZ', 'DDCCZ', 'DDCCZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8959,8959,'DDCDA','DDCDA','DDCDA', 'DDCDA', 'DDCDA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8960,8960,'DDCDB','DDCDB','DDCDB', 'DDCDB', 'DDCDB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8961,8961,'DDCDZ','DDCDZ','DDCDZ', 'DDCDZ', 'DDCDZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8962,8962,'DDCZA','DDCZA','DDCZA', 'DDCZA', 'DDCZA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8963,8963,'DDCZB','DDCZB','DDCZB', 'DDCZB', 'DDCZB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8964,8964,'DDCZZ','DDCZZ','DDCZZ', 'DDCZZ', 'DDCZZ', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8965,8965,'DDECA','DDECA','DDECA', 'DDECA', 'DDECA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8966,8966,'DDECB','DDECB','DDECB', 'DDECB', 'DDECB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8967,8967,'DDECC','DDECC','DDECC', 'DDECC', 'DDECC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8968,8968,'DDEDA','DDEDA','DDEDA', 'DDEDA', 'DDEDA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8969,8969,'DDEDB','DDEDB','DDEDB', 'DDEDB', 'DDEDB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8970,8970,'DDEDC','DDEDC','DDEDC', 'DDEDC', 'DDEDC', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8971,8971,'DDEEA','DDEEA','DDEEA', 'DDEEA', 'DDEEA', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8972,8972,'DDEEB','DDEEB','DDEEB', 'DDEEB', 'DDEEB', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_damage_code (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8973,8973,'DDEEC','DDEEC','DDEEC', 'DDEEC', 'DDEEC', '', '', '', '', '', 'true'); 
 ALTER TABLE qgep_od.damage_manhole ADD CONSTRAINT fkey_vl_damage_manhole_manhole_damage_code FOREIGN KEY (manhole_damage_code)
 REFERENCES qgep_vl.damage_manhole_manhole_damage_code (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.damage_manhole_manhole_shaft_area () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.damage_manhole_manhole_shaft_area ADD CONSTRAINT pkey_qgep_vl_damage_manhole_manhole_shaft_area_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3743,3743,'A','A','A', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3744,3744,'B','B','B', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3745,3745,'D','D','D', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3746,3746,'F','F','F', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3747,3747,'H','H','H', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3748,3748,'I','I','I', '', '', '', 'true');
 INSERT INTO qgep_vl.damage_manhole_manhole_shaft_area (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3749,3749,'J','J','J', '', '', '', 'true');
 ALTER TABLE qgep_od.damage_manhole ADD CONSTRAINT fkey_vl_damage_manhole_manhole_shaft_area FOREIGN KEY (manhole_shaft_area)
 REFERENCES qgep_vl.damage_manhole_manhole_shaft_area (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.data_media_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.data_media_kind ADD CONSTRAINT pkey_qgep_vl_data_media_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3784,3784,'other','andere','autre', '', '', '', 'true');
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3785,3785,'CD','CD','CD', '', '', '', 'true');
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3786,3786,'floppy_disc','Diskette','disquette', '', '', '', 'true');
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3787,3787,'dvd','DVD','DVD', '', '', '', 'true');
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3788,3788,'harddisc','Festplatte','disque_dur', '', '', '', 'true');
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3789,3789,'server','Server','serveur', '', '', '', 'true');
 INSERT INTO qgep_vl.data_media_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3790,3790,'videotape','Videoband','bande_video', '', '', '', 'true');
 ALTER TABLE qgep_od.data_media ADD CONSTRAINT fkey_vl_data_media_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.data_media_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE qgep_od.file ADD COLUMN fk_data_media varchar(16);
ALTER TABLE qgep_od.file ADD CONSTRAINT rel_file_data_media FOREIGN KEY (fk_data_media) REFERENCES qgep_od.data_media(obj_id) ON UPDATE CASCADE ON DELETE set null;
CREATE TABLE qgep_vl.file_class () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.file_class ADD CONSTRAINT pkey_qgep_vl_file_class_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3800,3800,'throttle_shut_off_unit','Absperr_Drosselorgan','LIMITEUR_DEBIT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3801,3801,'wastewater_structure','Abwasserbauwerk','OUVRAGE_RESEAU_AS', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3802,3802,'waster_water_treatment','Abwasserbehandlung','TRAITEMENT_EAUX_USEES', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3803,3803,'wastewater_node','Abwasserknoten','NOEUD_RESEAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3804,3804,'wastewater_networkelement','Abwassernetzelement','ELEMENT_RESEAU_EVACUATION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3805,3805,'waste_water_treatment_plant','Abwasserreinigungsanlage','STATION_EPURATION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3806,3806,'waste_water_association','Abwasserverband','ASSOCIATION_EPURATION_EAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3807,3807,'administrative_office','Amt','OFFICE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3808,3808,'connection_object','Anschlussobjekt','OBJET_RACCORDE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3809,3809,'wwtp_structure','ARABauwerk','OUVRAGES_STEP', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3810,3810,'wwtp_energy_use','ARAEnergienutzung','CONSOMMATION_ENERGIE_STEP', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3811,3811,'bathing_area','Badestelle','LIEU_BAIGNADE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3812,3812,'benching','Bankett','BANQUETTE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3813,3813,'structure_part','BauwerksTeil','ELEMENT_OUVRAGE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3814,3814,'well','Brunnen','FONTAINE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3815,3815,'file','Datei','FICHIER', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3816,3816,'data_media','Datentraeger','SUPPORT_DONNEES', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3817,3817,'cover','Deckel','COUVERCLE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3818,3818,'passage','Durchlass','PASSAGE_SOUS_TUYAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (5083,5083,'discharge_point','Einleitstelle','EXUTOIRE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3819,3819,'access_aid','Einstiegshilfe','DISPOSITIF_ACCES', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3820,3820,'individual_surface','Einzelflaeche','SURFACE_INDIVIDUELLE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3821,3821,'catchment_area','Einzugsgebiet','BASSIN_VERSANT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3822,3822,'electric_equipment','ElektrischeEinrichtung','EQUIPEMENT_ELECTRIQUE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3823,3823,'electromechanical_equipment','ElektromechanischeAusruestung','EQUIPEMENT_ELECTROMECA', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3824,3824,'drainage_system','Entwaesserungssystem','systeme_evacuation_eaux', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3825,3825,'maintenance_event','Erhaltungsereignis','EVENEMENT_MAINTENANCE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3826,3826,'fish_pass','Fischpass','ECHELLE_POISSONS', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3827,3827,'river','Fliessgewaesser','COURS_EAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3828,3828,'pump','FoerderAggregat','INSTALLATION_REFOULEMENT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3829,3829,'ford','Furt','PASSAGE_A_GUE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3830,3830,'building','Gebaeude','BATIMENT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3831,3831,'hazard_source','Gefahrenquelle','SOURCE_DANGER', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3832,3832,'municipality','Gemeinde','COMMUNE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3833,3833,'blocking_debris','Geschiebesperre','BARRAGE_ALLUVIONS', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3834,3834,'water_course_segment','Gewaesserabschnitt','TRONCON_COURS_EAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3835,3835,'chute','GewaesserAbsturz','SEUIL', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3836,3836,'water_body_protection_sector','Gewaesserschutzbereich','SECTEUR_PROTECTION_EAUX', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3837,3837,'sector_water_body','Gewaessersektor','SECTEUR_EAUX_SUP', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3838,3838,'river_bed','Gewaessersohle','FOND_COURS_EAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3839,3839,'water_control_structure','Gewaesserverbauung','AMENAGEMENT_COURS_EAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3840,3840,'dam','GewaesserWehr','OUVRAGE_RETENUE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3841,3841,'aquifier','Grundwasserleiter','AQUIFERE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3842,3842,'ground_water_protection_perimeter','Grundwasserschutzareal','PERIMETRE_PROT_EAUX_SOUT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3843,3843,'groundwater_protection_zone','Grundwasserschutzzone','ZONE_PROT_EAUX_SOUT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3844,3844,'reach','Haltung','TRONCON', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3845,3845,'reach_point','Haltungspunkt','POINT_TRONCON', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3846,3846,'hq_relation','HQ_Relation','RELATION_HQ', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3847,3847,'hydr_geometry','Hydr_Geometrie','GEOMETRIE_HYDR', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3848,3848,'hydr_geom_relation','Hydr_GeomRelation','RELATION_GEOM_HYDR', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3849,3849,'channel','Kanal','CANALISATION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3850,3850,'damage_channel','Kanalschaden','DOMMAGE_AUX_CANALISATIONS', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3851,3851,'canton','Kanton','CANTON', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3852,3852,'leapingweir','Leapingwehr','LEAPING_WEIR', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3853,3853,'mechanical_pretreatment','MechanischeVorreinigung','PRETRAITEMENT_MECANIQUE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3854,3854,'measurement_device','Messgeraet','APPAREIL_MESURE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3855,3855,'measurement_series','Messreihe','SERIE_MESURES', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3856,3856,'measurement_result','Messresultat','RESULTAT_MESURE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3857,3857,'measuring_point','Messstelle','STATION_MESURE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3858,3858,'standard_manhole','Normschacht','CHAMBRE_STANDARD', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3859,3859,'damage_manhole','Normschachtschaden','DOMMAGE_CHAMBRE_STANDARD', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3861,3861,'surface_runoff_parameters','Oberflaechenabflussparameter','PARAM_ECOULEMENT_SUP', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3862,3862,'surface_water_bodies','Oberflaechengewaesser','EAUX_SUPERFICIELLES', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3863,3863,'organisation','Organisation','ORGANISATION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3864,3864,'planning_zone','Planungszone','ZONE_RESERVEE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3865,3865,'private','Privat','PRIVE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3866,3866,'cleaning_device','Reinigungseinrichtung','DISPOSITIF_NETTOYAGE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3867,3867,'reservoir','Reservoir','RESERVOIR', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3868,3868,'retention_body','Retentionskoerper','VOLUME_RETENTION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3869,3869,'pipe_profile','Rohrprofil','PROFIL_TUYAU', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3870,3870,'profile_geometry','Rohrprofil_Geometrie','PROFIL_TUYAU_GEOM', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3871,3871,'damage','Schaden','DOMMAGE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3872,3872,'sludge_treatment','Schlammbehandlung','TRAITEMENT_BOUES', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3873,3873,'lock','Schleuse','ECLUSE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3874,3874,'lake','See','LAC', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3875,3875,'rock_ramp','Sohlrampe','RAMPE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3876,3876,'special_structure','Spezialbauwerk','OUVRAGE_SPECIAL', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3877,3877,'control_center','Steuerungszentrale','CENTRALE_COMMANDE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3878,3878,'substance','Stoff','SUBSTANCE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3879,3879,'prank_weir','Streichwehr','DEVERSOIR_LATERAL', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3880,3880,'dryweather_downspout','Trockenwetterfallrohr','TUYAU_CHUTE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3881,3881,'dryweather_flume','Trockenwetterrinne','CUNETTE_DEBIT_TEMPS_SEC', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3882,3882,'overflow','Ueberlauf','DEVERSOIR', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3883,3883,'overflow_characteristic','Ueberlaufcharakteristik','CARACTERISTIQUES_DEVERSOIR', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3884,3884,'shore','Ufer','RIVE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3885,3885,'accident','Unfall','ACCIDENT', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3886,3886,'inspection','Untersuchung','EXAMEN', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3887,3887,'infiltration_installation','Versickerungsanlage','INSTALLATION_INFILTRATION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3888,3888,'infiltration_zone','Versickerungsbereich','ZONE_INFILTRATION', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3890,3890,'water_catchment','Wasserfassung','CAPTAGE', '', '', '', 'true');
 INSERT INTO qgep_vl.file_class (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3891,3891,'zone','Zone','ZONE', '', '', '', 'true');
 ALTER TABLE qgep_od.file ADD CONSTRAINT fkey_vl_file_class FOREIGN KEY (class)
 REFERENCES qgep_vl.file_class (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
CREATE TABLE qgep_vl.file_kind () INHERITS (qgep_sys.value_list_base);
ALTER TABLE qgep_vl.file_kind ADD CONSTRAINT pkey_qgep_vl_file_kind_code PRIMARY KEY (code);
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3770,3770,'other','andere','autre', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3772,3772,'photo','Foto','photo', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3773,3773,'panoramo_film','Panoramofilm','film_panoramique', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3774,3774,'textfile','Textdatei','fichier_texte', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, abbr_en, abbr_de, abbr_fr, active) VALUES (3775,3775,'video','Video','video', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9147,9147,'scan','Scan','scan', 'scan', 'rrr_Scan', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (8812,8812,'sketch','Skizze','croquis', 'schizzo', 'rrr_Skizze', '', '', '', '', '', 'true');
 INSERT INTO qgep_vl.file_kind (code, vsacode, value_en, value_de, value_fr, value_it, value_ro, abbr_en, abbr_de, abbr_fr, abbr_it, abbr_ro, active) VALUES (9146,9146,'digital_video','digitales_Video','video_numerique', 'video_digitale', 'rrr_digitales_Video', '', '', '', '', '', 'true');
 ALTER TABLE qgep_od.file ADD CONSTRAINT fkey_vl_file_kind FOREIGN KEY (kind)
 REFERENCES qgep_vl.file_kind (code) MATCH SIMPLE 
 ON UPDATE RESTRICT ON DELETE RESTRICT;
--------- Relations to class organisation for dataowner and provider (new 3.11.2014);

ALTER TABLE qgep_od.damage ADD CONSTRAINT rel_od_damage_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.damage ADD CONSTRAINT rel_od_damage_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.data_media ADD CONSTRAINT rel_od_data_media_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.data_media ADD CONSTRAINT rel_od_data_media_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.file ADD CONSTRAINT rel_od_file_fk_dataowner FOREIGN KEY (fk_dataowner) REFERENCES qgep_od.organisation(obj_id);
ALTER TABLE qgep_od.file ADD CONSTRAINT rel_od_file_fk_dataprovider FOREIGN KEY (fk_provider) REFERENCES qgep_od.organisation(obj_id);

------ Indexes on identifiers

 CREATE UNIQUE INDEX in_od_data_media_identifier ON qgep_od.data_media USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);
 CREATE UNIQUE INDEX in_od_file_identifier ON qgep_od.file USING btree (identifier ASC NULLS LAST, fk_dataowner ASC NULLS LAST);

COMMIT;
