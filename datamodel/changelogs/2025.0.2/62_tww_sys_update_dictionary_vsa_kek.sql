------ this file updates the tww is_dictionary (Modul kek(2020)) in en on TEKSI
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 05.08.2025 17:44:51
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3679,'examination') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'examination', name_en = 'examination', shortcut_en = 'EX', name_de = 'Untersuchung', shortcut_de = 'UN', name_fr = 'Examen', shortcut_fr = 'IN', name_it = 'Ispezione', shortcut_it = '', name_ro = 'rrr_Untersuchung', shortcut_ro = ''
WHERE (id = 3679 AND tablename = 'examination');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3705,'damage') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'damage', name_en = 'damage', shortcut_en = 'DG', name_de = 'Schaden', shortcut_de = 'SC', name_fr = 'Dommage', shortcut_fr = 'DO', name_it = 'Danni', shortcut_it = '', name_ro = 'rrr_Schaden', shortcut_ro = ''
WHERE (id = 3705 AND tablename = 'damage');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3714,'damage_channel') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'damage_channel', name_en = 'damage channel', shortcut_en = 'DC', name_de = 'Kanalschaden', shortcut_de = 'KS', name_fr = 'Dommage aux canalisations', shortcut_fr = 'DC', name_it = 'Danni canalizzazione', shortcut_it = '', name_ro = 'rrr_Kanalschaden', shortcut_ro = ''
WHERE (id = 3714 AND tablename = 'damage_channel');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3728,'damage_manhole') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'damage_manhole', name_en = 'damage manhole', shortcut_en = 'DM', name_de = 'Normschachtschaden', shortcut_de = 'SS', name_fr = 'Dommage chambre standard', shortcut_fr = 'SS', name_it = 'danni_pozzetto_standard', shortcut_it = '', name_ro = 'rrr_Normschachtschaden', shortcut_ro = ''
WHERE (id = 3728 AND tablename = 'damage_manhole');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3754,'file') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'file', name_en = 'file', shortcut_en = 'FI', name_de = 'Datei', shortcut_de = 'DA', name_fr = 'Fichier', shortcut_fr = 'FI', name_it = 'File', shortcut_it = '', name_ro = 'Fi?ier', shortcut_ro = ''
WHERE (id = 3754 AND tablename = 'file');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3776,'data_media') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'data_media', name_en = 'data media', shortcut_en = 'VO', name_de = 'Datenträger', shortcut_de = 'DT', name_fr = 'Support données', shortcut_fr = 'SO', name_it = 'Supporto dati', shortcut_it = '', name_ro = 'rrr_Datentraeger', shortcut_ro = ''
WHERE (id = 3776 AND tablename = 'data_media');




--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,3690) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'equipment', field_name_en = 'equipment', field_name_de = 'Geraet', field_name_fr = 'APPAREIL', field_name_it = 'apparecchio', field_name_ro = '', field_description_en = 'Name of used camera', field_description_de = 'Eingesetztes Aufnahmegeräte (Kamera)', field_description_fr = 'Appareil de prise de vues (caméra) employé', field_description_it = 'Apparecchio di rilevamento impiegato (telecamera)', field_description_ro = '', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(50)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 3690);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,4507) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'from_point_identifier', field_name_en = 'from_point_identifier', field_name_de = 'vonPunktBezeichnung', field_name_fr = 'DESIGNATION_POINT_DE', field_name_it = 'denominazione_dal_punto', field_name_ro = 'rrr_vonPunktBezeichnung', field_description_en = 'yyy_Bezeichnung des "von Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Foreign key Haltungspunkt, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet.', field_description_de = 'Bezeichnung des "von Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Fremdschlüssel Haltungspunkt, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet.', field_description_fr = 'Point (chambre ou nœud) auquel l’examen commence. Désignation du « point départ » (DESIGNATION_POINT_DE) d’une examen comme elle figure sur le plan. Elle sert d’alternative à la clé externe POINT_TRONCON, lorsque la topologie n’est pas encore définie (saisie initiale). La DESIGNATION_POINT_DE sera utilisée ultérieurement par l’hydraulicien pour la construction de la topologie du réseau.', field_description_it = 'Denominazione del «dal_punto» di un’ispezione come appare sulla pianta. Alternativa per la chiave esterna punto_tronco, se la classificazione non è ancora definita (registrazione iniziale). La designazione dal punto viene poi utilizzata dall''ingegnere idraulico per creare la topologia della rete fognaria.', field_description_ro = 'rrr_Bezeichnung des "von Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Fremdschlüssel Haltungspunkt, wenn Topologie noch nicht definiert ist (Ersterfassung). Die vonPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(20)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 4507);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,3692) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'inspected_length', field_name_en = 'inspected_length', field_name_de = 'Inspizierte_Laenge', field_name_fr = 'LONGUEUR_INSPECTEE', field_name_it = 'lunghezza_ispezione', field_name_ro = 'rrr_Inspizierte_Laenge', field_description_en = 'yyy_Total untersuchte Länge in Metern mit zwei Nachkommastellen', field_description_de = 'Total untersuchte Länge in Metern mit zwei Nachkommastellen', field_description_fr = 'Longueur totale examinée en mètres avec deux chiffres après la virgule', field_description_it = 'Totale della lunghezza ispezionata in metri con due decimali', field_description_ro = 'rrr_Total untersuchte Länge in Metern mit zwei Nachkommastellen', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(7,2)', field_unit_en = '[m]', field_unit_description_en = 'meter [m], 2 decimal digits', field_unit_de = '[m]', field_unit_description_de = 'Meter [m], 2 Dezimalstellen', field_unit_fr = '[m]', field_unit_description_fr = 'mètres [m], 2 décimals', field_unit_it = '[m]', field_unit_description_it = 'metro [m], 2 decimale', field_unit_ro = '[m]', field_unit_description_ro = 'rrr_Meter [m], 2 Dezimalstellen', field_max = 30000, field_min = 0
WHERE (class_id = 3679 AND attribute_id = 3692);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,3680) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'recording_type', field_name_en = 'recording_type', field_name_de = 'Erfassungsart', field_name_fr = 'TYPE_RELEVE', field_name_it = 'metodo_rilevamento', field_name_ro = 'rrr_Erfassungsart', field_description_en = 'yyy_Aufnahmetechnik, beschreibt die Art der Aufnahme', field_description_de = 'Aufnahmetechnik, beschreibt die Art der Aufnahme', field_description_fr = 'Technique de prise de vues, décrit le type de prise de vues', field_description_it = 'Tecnica d’ispezione, descrive il metodo di rilevamento', field_description_ro = 'rrr_Aufnahmetechnik, beschreibt die Art der Aufnahme', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 3680);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,4505) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'to_point_identifier', field_name_en = 'to_point_identifier', field_name_de = 'bisPunktBezeichnung', field_name_fr = 'DESIGNATION_POINT_VERS', field_name_it = 'denominazione_fino_al_punto', field_name_ro = 'rrr_bisPunktBezeichnung', field_description_en = 'yyy_Bezeichnung des "bis Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Foreign key Abwasserbauwerk, wenn Topologie noch nicht definiert ist (Ersterfassung). Die bisPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. Bei Schachtuntersuchungen bleibt dieser Wert leer', field_description_de = 'Bezeichnung des "bis Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Fremdschlüssel Abwasserbauwerk, wenn Topologie noch nicht definiert ist (Ersterfassung). Die bisPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. Bei Schachtuntersuchungen bleibt dieser Wert leer.', field_description_fr = 'Point (chambre ou noeud) d’où l’examen termine. Désignation du « point d’arrivée » (DESIGNATION_POINT_VERS) d’une examen comme elle figure sur le plan. Elle sert d’alternative à la clé externe OUVRAGE_RESEAU_AS lorsque la topologie n’est pas encore définie (saisie initiale). La DESIGNATION_POINT_VERS sera utilisée ultérieurement par l’hydraulicien pour la construction de la topologie du réseau. Cette valeur reste vide lors d’inspections de chambres.', field_description_it = 'Denominazione del «fino_al_punto» di un’ispezione come appare sulla pianta. Alternativa per la chiave esternamanufatto smaltimento acque, se la classificazione non è ancora definita (registrazione iniziale). La designazione fino al punto viene poi utilizzata dall''ingegnere idraulico per creare la topologia della rete fognaria. Per le ispezioni di pozzetti questo valore rimane in bianco.', field_description_ro = 'rrr_Bezeichnung des "bis Punktes" einer Untersuchung, so wie sie auf dem Plan erscheint. Alternative zum Fremdschlüssel Abwasserbauwerk, wenn Topologie noch nicht definiert ist (Ersterfassung). Die bisPunktBezeichnung wird später vom Hydrauliker für den Aufbau der Kanalnetztopologie verwendet. Bei Schachtuntersuchungen bleibt dieser Wert leer.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(20)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 4505);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,3688) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'vehicle', field_name_en = 'vehicle', field_name_de = 'Fahrzeug', field_name_fr = 'VEHICULE', field_name_it = 'veicolo', field_name_ro = 'rrr_Fahrzeug', field_description_en = 'yyy_Eingesetztes Inspektionsfahrzeug', field_description_de = 'Eingesetztes Inspektionsfahrzeug', field_description_fr = 'Véhicule d’examen employé', field_description_it = 'Veicolo d’ispezione impiegato', field_description_ro = 'rrr_Eingesetztes Inspektionsfahrzeug', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(50)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 3688);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,3696) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'videonumber', field_name_en = 'videonumber', field_name_de = 'Videonummer', field_name_fr = 'NUMERO_VIDEO', field_name_it = 'numero_video', field_name_ro = 'rrr_Videonummer', field_description_en = 'yyy_Bei Videobändern steht hier die Bandnummer (z.B. 1/99). Bei elektronischen Datenträgern ist dies die Datenträgerbezeichnung (z.B. SG001). Falls pro Untersuchung eine einzelne Datei zur Verfügung steht, dann wird diese aus der Klasse Datei referenziert und dieses Attribut kann leer gelassen werden.', field_description_de = 'Bei Videobändern steht hier die Bandnummer (z.B. 1/99). Bei elektronischen Datenträgern ist dies die Datenträgerbezeichnung (z.B. SG001). Falls pro Untersuchung eine einzelne Datei zur Verfügung steht, dann wird diese aus der Klasse Datei referenziert und dieses Attribut kann leer gelassen werden.', field_description_fr = 'Pour les bandes vidéo figure ici le numéro de la bande (p. ex. 1/99) et, pour les supports de don-nées électroniques, sa désignation (p. ex. SG001). S’il n’existe qu’un fichier par examen, ce fichier est référencé par la classe Fichier et cet attribut peut être laissé vide.', field_description_it = 'Nei nastri video viene mostrato qui il numero del nastro (ad es. 1/99). Nei supporti di dati elettronici, questa è la designazione del supporto dati (ad es. SG001). Se per ispezione è disponibile un singolo file, allora questo file è referenziato dalla classe File e questo attributo può essere lasciato in bianco.', field_description_ro = 'rrr_Bei Videobändern steht hier die Bandnummer (z.B. 1/99). Bei elektronischen Datenträgern ist dies die Datenträgerbezeichnung (z.B. SG001). Falls pro Untersuchung eine einzelne Datei zur Verfügung steht, dann wird diese aus der Klasse Datei referenziert und dieses Attribut kann leer gelassen werden.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(20)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 3696);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3679,3698) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'examination', field_name = 'weather', field_name_en = 'weather', field_name_de = 'Witterung', field_name_fr = 'CONDITIONS_METEO', field_name_it = 'condizioni_meteo', field_name_ro = 'rrr_Witterung', field_description_en = 'Wheather conditions during inspection', field_description_de = 'Wetterverhältnisse während der Inspektion', field_description_fr = 'Conditions météorologiques pendant l’examen', field_description_it = 'Condizioni meteorologiche durante l''ispezione', field_description_ro = 'rrr_Wetterverhältnisse während der Inspektion', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3679 AND attribute_id = 3698);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,3712) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'comments', field_name_en = 'comments', field_name_de = 'Anmerkung', field_name_fr = 'COMMENTAIRES', field_name_it = 'nota', field_name_ro = 'zzz_Anmerkung', field_description_en = 'Free comments on a finding', field_description_de = 'Freie Bemerkungen zu einer Feststellung', field_description_fr = 'Remarques libres concernant une observation', field_description_it = 'Osservazione libera sulla constatazione', field_description_ro = 'rrr_Freie Bemerkungen zu einer Feststellung', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(100)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 3712);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,8497) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'connection', field_name_en = 'connection', field_name_de = 'Verbindung', field_name_fr = 'RACCORDEMENT', field_name_it = 'giunto', field_name_ro = 'conexiune', field_description_en = 'Indicator for a detection at a pipe connection (2.1.7). or in case of two adjacent manhole elements according to (3.1.7). Corresponds in SN EN 13508 yes = "A", no = empty', field_description_de = 'Kennzeichen für eine Feststellung an einer Rohrverbindung (2.1.7). bzw. bei zwei aneinandergrenzenden Schachtelementen gemäss (3.1.7). Entspricht in SN EN 13508 ja = "A", nein = leer', field_description_fr = 'Indication d’une observation au niveau d’un assemblage (2.1.7) ou Observation entre deux éléments de regard de visite adjacents (3.1.7). Correspond dans la SN EN 13508 à oui = « A », non = vide', field_description_it = 'Contrassegno per una constatazione sul giunto di una tubazione. (2.1.7) o nel caso di due elementi di tombino adiacenti secondo la (3.1.7). Corrisponde a SN EN 13508 sì = «A», no = vuoto.', field_description_ro = 'Indicator pentru detectarea la o conexiune de ?eava (2.1.7) sau în cazul a doua elemente de vizitare alaturate în conformitate cu (3.1.7). Corespunde în SN EN 13508 da = "A", nu = gol', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 8497);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,8512) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'line_damage', field_name_en = 'line_damage', field_name_de = 'Streckenschaden', field_name_fr = 'DOMMAGE_TRONCONS', field_name_it = 'danno_continuo', field_name_ro = 'rrr_Streckenschaden', field_description_en = 'Codes for the beginning and end of a line damage. Detailed information under 2.1.2 resp. 3.1.2', field_description_de = 'Codes für den Anfang und das Ende eines Streckenschadens. Genaue Angaben unter 2.1.2 resp. 3.1.2', field_description_fr = 'Codes pour le début et la fin d’un dommage à un tronçon. Indications exactes sous 2.1.2 resp. 3.1.2.', field_description_it = 'Codici di inizio e fine di un danno continuo. Indicazioni dettagliate al punto 2.1.2 o 3.1.2', field_description_ro = 'rrr_Codes für den Anfang und das Ende eines Streckenschadens. Genaue Angaben unter 2.1.2 resp. 3.1.2', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(3)', field_unit_en = '', field_unit_description_en = 'Codes for the beginning and the end of a track damage', field_unit_de = '', field_unit_description_de = 'Codes für den Anfang und das Ende eines Streckenschadens', field_unit_fr = '', field_unit_description_fr = 'Codes pour le début et la fin d’un dommage tronçons', field_unit_it = '', field_unit_description_it = 'Codici per l’inizio e la fine di un danno alla linea', field_unit_ro = '', field_unit_description_ro = 'rrr_Codes für den Anfang und das Ende eines Streckenschadens', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 8512);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,9220) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'oid', field_name_en = 'oid', field_name_de = 'OID', field_name_fr = 'OID', field_name_it = 'OID', field_name_ro = 'OID', field_description_en = 'Stable unique object identification for all objects and classes', field_description_de = 'Stabile eindeutige Objektidentifikation für alle Objekte und Klassen', field_description_fr = 'Identification d''objet unique stable pour tous les objets et toutes les classes', field_description_it = 'Identificazione univoca e stabile per tutti gli oggetti e le classi', field_description_ro = 'Identificare unica stabila a obiectelor pentru toate obiectele ?i clasele', field_mandatory = ARRAY['GEP_Verband','PAA','SAA']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(16)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 9220);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,3706) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'single_damage_class', field_name_en = 'single_damage_class', field_name_de = 'Einzelschadenklasse', field_name_fr = 'CLASSE_DOMMAGE_UNIQUE', field_name_it = 'classe_danno_singolo', field_name_ro = 'clasa_de_dauna_individuala', field_description_en = 'Defines the damage class of an individual damage. The classification into condition classes (Z0-Z4) is based on the damage pattern and the extent of the damage. A wastewater structure can be directly assigned to a class or each damage can be classified individually first. (At the end, for example, the most severe individual damage determines the classification of the entire canalisation (wastewater_structure.structure_condition)).', field_description_de = 'Definiert die Schadensklasse eines Einzelschadens. Die Einteilung in die Zustandsklassen (Z0-Z4) erfolgt aufgrund des Schadenbilds und des Schadensausmasses. Dabei kann ein Abwasserbauwerk direkt einer Klasse zugeteilt werden oder zuerst jeder Schaden einzeln klassifiziert werden. (Am Schluss bestimmt dann z.B. der schwerste Einzelschaden die Klassifizierung des gesamten Kanals (Abwasserbauwerk.BaulicherZustand)).', field_description_fr = 'Définit la classe de dommages d’un dommage unique. La répartition en classes d’état (Z0-Z4) s’effectue sur la base de la nature et de l’étendue des dommages. Un ouvrage d''assainissement peut être classé directement ou chaque dommage peut d’abord être classé séparément. (A la fin, le dommage le plus important détermine le classement de l’ensemble de la canalisation (OUVRAGE_RESEAU_AS.ETAT_CONSTRUCTIF).', field_description_it = 'Definisce la classe di danno di un danno isolato. La classificazione nelle classi di stato (Z0-Z4) si basa sul modello di danno e sull''entità del danno. Unamanufatto smaltimento acque può essere assegnata direttamente ad una classe o ogni danno può essere classificato singolarmente per primo. (Alla fine, ad esempio, il danno individuale più grave determina la classificazione dell''intera fogna (struttura fognaria.stato strutturale)).', field_description_ro = 'Define?te clasa de dauna a unei daune individuale. Clasificarea în clase de stare (Z0-Z4) se bazeaza pe modelul de avarie ?i pe amploarea avariei. O structura de canalizare poate fi atribuita direct unei clase sau fiecare avarie poate fi clasificata mai întâi individual. (În final, de exemplu, cea mai grava avarie individuala determina clasificarea întregii canalizari (structura_canalizare.stare_structura)).', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 3706);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,8514) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'video_counter', field_name_en = 'video_counter', field_name_de = 'Videozaehlerstand', field_name_fr = 'RELEVE_COMPTEUR_VIDEO', field_name_it = 'contatore_video', field_name_ro = 'contor_video', field_description_en = 'Meter reading on an analog videotape or in a digital video file, in real time', field_description_de = 'Zählerstand auf einem analogen Videoband oder in einer digitalen Videodatei, in Echtzeit', field_description_fr = 'Zählerstand auf einem analogen Videoband oder in einer digitalen Videodatei, in Echtzeit', field_description_it = 'Posizione del contatore di un nastro video analogico o in un file video digitale in tempo reale', field_description_ro = 'Citirea contoarelor pe o banda video analogica sau într-un fi?ier video digital, în timp real', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(11)', field_unit_en = '[hh:mm:ss:ff]', field_unit_description_en = '[hh:mm:ss:ff]', field_unit_de = '[hh:mm:ss:ff]', field_unit_description_de = '[hh:mm:ss:ff]', field_unit_fr = '[hh:mm:ss:ff]', field_unit_description_fr = '[hh:mm:ss:ff]', field_unit_it = '[hh:mm:ss:ff]', field_unit_description_it = '[hh:mm:ss:ff]', field_unit_ro = '[hh:mm:ss:ff]', field_unit_description_ro = '[hh:mm:ss:ff]', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 8514);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3705,8516) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage', field_name = 'view_parameters', field_name_en = 'view_parameters', field_name_de = 'Ansichtsparameter', field_name_fr = 'PARAMETRES_PROJECTION', field_name_it = 'parametri_visualizzazioni', field_name_ro = 'rrr_Ansichtsparameter', field_description_en = 'Special view parameters for positioning within a film file for scanner or digital video technology', field_description_de = 'Spezielle Ansichtsparameter für die Positionierung innerhalb einer Filmdatei für Scanner- oder digitale Videotechnik', field_description_fr = 'Paramètres de projection spéciaux pour le positionnement à l’intérieur d’un fichier de film pour la technique vidéo scanner ou numérique.', field_description_it = 'Parametri di visualizzazione speciali per il posizionamento in un file oppure per tecnica di scansione o video digitale', field_description_ro = 'rrr_Spezielle Ansichtsparameter für die Positionierung innerhalb einer Filmdatei für Scanner- oder digitale Videotechnik', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(200)', field_unit_en = '', field_unit_description_en = 'Special view parameters for positioning within a film file', field_unit_de = '', field_unit_description_de = 'Spezielle Ansichtsparameter für die Positionierung innerhalb einer Filmdatei', field_unit_fr = '', field_unit_description_fr = 'Paramètres de projection spéciaux pour le positionnement à l’intérieur d’un fichier film', field_unit_it = '', field_unit_description_it = 'Parametri di visualizzazione speciali per il posizionamento all’interno di un file di film', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3705 AND attribute_id = 8516);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3714,3717) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_channel', field_name = 'channel_damage_begin', field_name_en = 'channel_damage_begin', field_name_de = 'SchadenlageAnfang', field_name_fr = 'DEBUT_DOMMAGE', field_name_it = 'posizione_danno_inizio', field_name_ro = 'rrr_SchadenlageAnfang', field_description_en = 'Location on the circumference: end of the damage. Values and procedure are described in detail in paragraph 2.1.6.', field_description_de = 'Lage am Umfang: Beginn des Schadens. Werte und Vorgehen sind in Absatz 2.1.6 genau beschrieben.', field_description_fr = 'Emplacement circonférentiel: Début du dommage. Valeurs et procédure sont décrites en détail dans le paragraphe 2.1.6.', field_description_it = 'Posizione sulla circonferenza: inizio del danno. I valori e la procedura sono descritti in dettaglio nel paragrafo 2.1.6', field_description_ro = 'rrr_Lage am Umfang: Beginn des Schadens. Werte und Vorgehen sind in Absatz 2.1.6 genau beschrieben.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = 12, field_min = 0
WHERE (class_id = 3714 AND attribute_id = 3717);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3714,3716) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', field_name_en = 'channel_damage_code', field_name_de = 'KanalSchadencode', field_name_fr = 'CODE_DOMMAGE_CANALISATIONS', field_name_it = 'codice_danno_canale', field_name_ro = '', field_description_en = 'yyy_Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 2 der Richtlinie "Schadencodierung" abschliessend aufgeführt.', field_description_de = 'Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 2 der Richtlinie "Schadencodierung" abschliessend aufgeführt.', field_description_fr = 'Domaine de valeur prédéfini: Code valide sur la base de la SN EN 13508-2. Tous les codes valides sont mentionnés dans le chapitre 2 de la directive.', field_description_it = 'Intervallo valori definito: codice valido in base alla SN EN 13508-2. Tutti i codici validi sono elencati in modo esaustivo nel capitolo 2 della linea guida "Codifica dei danni"', field_description_ro = 'rrr_Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 2 der Richtlinie "Schadencodierung" abschliessend aufgeführt.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3714 AND attribute_id = 3716);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3714,3718) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_channel', field_name = 'channel_damage_end', field_name_en = 'channel_damage_end', field_name_de = 'SchadenlageEnde', field_name_fr = 'FIN_DOMMAGE', field_name_it = 'posizione_danno_fine', field_name_ro = 'rrr_SchadenlageEnde', field_description_en = 'Location on the circumference: end of the damage. Values and procedure are described in detail in paragraph 2.1.6.', field_description_de = 'Lage am Umfang: Ende des Schadens. Werte und Vorgehen sind in Absatz 2.1.6 genau beschrieben', field_description_fr = 'Emplacement circonférentiel: Fin du dommage. Valeurs et procédure sont décrites en détail dans le paragraphe 2.1.6.', field_description_it = 'Posizione sulla circonferenza: fine del danno. I valori e la procedura sono descritti in dettaglio nel paragrafo 2.1.6', field_description_ro = 'rrr_Lage am Umfang: Ende des Schadens. Werte und Vorgehen sind in Absatz 2.1.6 genau beschrieben', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = 12, field_min = 0
WHERE (class_id = 3714 AND attribute_id = 3718);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3714,3714) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_channel', field_name = 'channel_distance', field_name_en = 'channel_distance', field_name_de = 'Distanz', field_name_fr = 'DISTANCE', field_name_it = 'distanza', field_name_ro = 'rrr_Distanz', field_description_en = 'Length from start of pipe to detection (see Guideline Visual Inspection of Drainage Systems: Damage Coding and Data Transfer, paragraph 2.1.1) in m with two decimal places.', field_description_de = 'Länge von Rohranfang bis zur Feststellung (siehe Richtlinie Optische Inspektion von Entwässerungsanlagen: Schadencodierung und Datentransfer, Absatz 2.1.1) in m mit zwei Nachkommastellen', field_description_fr = 'Longueur entre le début de la canalisation et l’observation (cf. paragraphe 2.1.1) en m avec deux chiffres après la virgule.', field_description_it = 'Lunghezza da inizio tubo fino alla constatazione (vedi linea guida Manutenzione delle canalizzazioni: Codifica dei danni e trasferimento dati, paragrafo 2.1.1) in m con due decimali', field_description_ro = 'rrr_Länge von Rohranfang bis zur Feststellung (siehe Richtlinie Optische Inspektion von Entwässerungsanlagen: Schadencodierung und Datentransfer, Absatz 2.1.1) in m mit zwei Nachkommastellen', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(7,2)', field_unit_en = '[m]', field_unit_description_en = 'meter [m], 2 decimal digits', field_unit_de = '[m]', field_unit_description_de = 'Meter [m], 2 Dezimalstellen', field_unit_fr = '[m]', field_unit_description_fr = 'mètres [m], 2 décimals', field_unit_it = '[m]', field_unit_description_it = 'metro [m], 2 decimale', field_unit_ro = '[m]', field_unit_description_ro = 'rrr_Meter [m], 2 Dezimalstellen', field_max = 30000, field_min = 0
WHERE (class_id = 3714 AND attribute_id = 3714);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3714,3719) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_channel', field_name = 'channel_quantification1', field_name_en = 'channel_quantification1', field_name_de = 'Quantifizierung1', field_name_fr = 'QUANTIFICATION1', field_name_it = 'quantificazione1', field_name_ro = 'cuantificare1', field_description_en = 'Quantification 1 according to SN EN 13508-2. Permissible inputs are described in chapter 2.3 - 2.6', field_description_de = 'Quantifizierung 1 gemäss SN EN 13508-2. Zulässige Eingaben sind in Kapitel 2.3 - 2.6 beschrieben', field_description_fr = 'Quantification 1 selon la SN EN 13508-2. Les entrées autorisées sont décrites dans les chapitres 2.3 - 2.6', field_description_it = 'Quantificazione 1 secondo SN EN 13508-2. Le immissioni consentite sono descritte nel capitolo 2.3 – 2.6.', field_description_ro = 'Cuantificarea 1 în conformitate cu SN EN 13508. Intrarile admise sunt descrise în capitolul 2.3 - 2.6.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '[mm] or [%]', field_unit_description_en = '[mm] or [%], depending on EN damage code', field_unit_de = '[mm] oder [%]', field_unit_description_de = '[mm] oder [%], je nach EN Schadencode', field_unit_fr = '[mm] ou [%]', field_unit_description_fr = '[mm] ou [%], dependant du code EN', field_unit_it = '[mm] oder [%]', field_unit_description_it = '[mm] o [%], a seconda del codice di danneggiamento', field_unit_ro = '[mm] oder [%]', field_unit_description_ro = ' [mm] oder [%], je nach EN Schadencode', field_max = 100000, field_min = 0
WHERE (class_id = 3714 AND attribute_id = 3719);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3714,3720) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_channel', field_name = 'channel_quantification2', field_name_en = 'channel_quantification2', field_name_de = 'Quantifizierung2', field_name_fr = 'QUANTIFICATION2', field_name_it = 'quantificazione2', field_name_ro = 'cuantificare2', field_description_en = 'Quantification 2 according to SN EN 13508. Permissible inputs are described in chapter 2.3 - 2.6', field_description_de = 'Quantifizierung 2 gemäss SN EN 13508. Zulässige Eingaben sind in Kapitel 2.3 - 2.6  beschrieben', field_description_fr = 'Quantification 2 selon la SN EN 13508. Les entrées autorisées sont décrites dans le chapitre 2.3 - 2.6', field_description_it = 'Quantificazione 2 secondo SN EN 13508-2. Le immissioni consentite sono descritte nel capitolo 2.3 – 2.6.', field_description_ro = 'Cuantificarea 2 în conformitate cu SN EN 13508. Intrarile admise sunt descrise în capitolul 2.3 - 2.6.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '[mm] or [%]', field_unit_description_en = '[mm] or [%], depending on EN damage code', field_unit_de = '[mm] oder [%]', field_unit_description_de = '[mm] oder [%], je nach EN Schadencode', field_unit_fr = '[mm] ou [%]', field_unit_description_fr = '[mm] ou [%], dependant du code EN', field_unit_it = '[mm] oder [%]', field_unit_description_it = '[mm] o [%], a seconda del codice di danneggiamento', field_unit_ro = '[mm] oder [%]', field_unit_description_ro = ' [mm] oder [%], je nach EN Schadencode', field_max = 100000, field_min = 0
WHERE (class_id = 3714 AND attribute_id = 3720);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3733) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_begin', field_name_en = 'manhole_damage_begin', field_name_de = 'SchadenlageAnfang', field_name_fr = 'DEBUT_DOMMAGE', field_name_it = 'posizione_danno_inizio', field_name_ro = 'rrr_SchadenlageAnfang', field_description_en = 'Location on the circumference: beginning of the damage. Values and procedure are described in detail in paragraph 3.1.6.', field_description_de = 'Lage am Umfang: Beginn des Schadens. Werte und Vorgehen sind unter Absatz 3.1.6 genau beschrieben.', field_description_fr = 'Emplacement circonférentiel: Début du dommage. Valeurs et procédure sont décrites en détail dans le paragraphe 3.1.6.', field_description_it = 'Posizione sulla circonferenza: inizio del danno. I valori e la procedura sono descritti in dettaglio nel paragrafo 3.1.6', field_description_ro = 'rrr_Lage am Umfang: Beginn des Schadens. Werte und Vorgehen sind unter Absatz 3.1.6 genau beschrieben.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = 12, field_min = 0
WHERE (class_id = 3728 AND attribute_id = 3733);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3732) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', field_name_en = 'manhole_damage_code', field_name_de = 'SchachtSchadencode', field_name_fr = 'CODE_DOMMAGE_CHAMBRE_STANDARD', field_name_it = 'codice_danno_pozzetto', field_name_ro = '', field_description_en = 'yyy_Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 3 der Richtlinie "Schadencodierung" abschliessend aufgeführt.', field_description_de = 'Vorgegebener Wertebereich: Gültiger Code auf der Grundlage von SN EN 13508-2. Alle gültigen Codes sind in Kapitel 3 der Richtlinie "Schadencodierung" abschliessend aufgeführt.', field_description_fr = 'Domaine de valeur prédéfini: Code valide sur la base de la SN EN 13508-2. Tous les codes valides sont mentionnés dans le chapitre 3 de la directive.', field_description_it = 'Intervallo valori definito: codice valido in base alla SN EN 13508-2. Tutti i codici validi sono elencati in modo esaustivo nel capitolo 3 della linea guida "Codifica dei danni"', field_description_ro = '', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3728 AND attribute_id = 3732);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3734) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_end', field_name_en = 'manhole_damage_end', field_name_de = 'SchadenlageEnde', field_name_fr = 'FIN_DOMMAGE', field_name_it = 'posizione_danno_fine', field_name_ro = 'rrr_SchadenlageEnde', field_description_en = 'Location on the circumference: end of the damage. Values and procedure are described in detail in paragraph 3.1.6.', field_description_de = 'Lage am Umfang: Ende des Schadens. Werte und Vorgehen sind unter Absatz 3.1.6 genau beschrieben.', field_description_fr = 'Emplacement circonférentiel: Fin du dommage. Valeurs et procédure sont décrites en détail dans le paragraphe 3.1.6.', field_description_it = 'Posizione sulla circonferenza: fine del danno. I valori e la procedura sono descritti in dettaglio nel paragrafo 3.1.6', field_description_ro = 'rrr_Lage am Umfang: Ende des Schadens. Werte und Vorgehen sind unter Absatz 3.1.6 genau beschrieben.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = 12, field_min = 0
WHERE (class_id = 3728 AND attribute_id = 3734);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3730) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_distance', field_name_en = 'manhole_distance', field_name_de = 'Distanz', field_name_fr = 'DISTANCE', field_name_it = 'distanza', field_name_ro = 'rrr_Distanz', field_description_en = 'Length from the top edge of the cover to the detection (see paragraph 3.1.1) in m with two decimal places.', field_description_de = 'Länge ab Oberkante Deckel bis zur Feststellung (siehe Absatz 3.1.1) in m mit zwei Nachkommastellen.', field_description_fr = 'Longueur entre le bord supérieur du couvercle et l’observation (cf. paragraphe 3.1.1) en m avec deux chiffres après la virgule.', field_description_it = 'Lunghezza dal bordo superiore del chiusino alla constatazione (vedi paragrafo 3.1.1) in m con due decimali', field_description_ro = 'rrr_Länge ab Oberkante Deckel bis zur Feststellung (siehe Absatz 3.1.1) in m mit zwei Nachkommastellen.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(7,2)', field_unit_en = '[m]', field_unit_description_en = 'meter [m], 2 decimal digits', field_unit_de = '[m]', field_unit_description_de = 'Meter [m], 2 Dezimalstellen', field_unit_fr = '[m]', field_unit_description_fr = 'mètres [m], 2 décimals', field_unit_it = '[m]', field_unit_description_it = 'metro [m], 2 decimale', field_unit_ro = '[m]', field_unit_description_ro = 'rrr_Meter [m], 2 Dezimalstellen', field_max = 30000, field_min = 0
WHERE (class_id = 3728 AND attribute_id = 3730);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3735) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_quantification1', field_name_en = 'manhole_quantification1', field_name_de = 'Quantifizierung1', field_name_fr = 'QUANTIFICATION1', field_name_it = 'quantificazione1', field_name_ro = 'cuantificare1', field_description_en = 'Quantification 1 according to SN EN 13508. Permissible inputs are described in chapter 3.1.5. Implemented as text attribute.', field_description_de = 'Quantifizierung 1 gemäss SN EN 13508. Zulässige Eingaben sind in Kapitel 3.1.5 beschrieben. Als Textattribut umgesetzt.', field_description_fr = 'Quantification 1 selon la SN EN 13508. Les entrées autorisées sont décrites dans le chapitre 3.1.5. Type texte.', field_description_it = 'Quantificazione 1 secondo SN EN 13508. Le immissioni consentite sono descritte nel capitolo 3.1.5. Implementato come attributo di testo', field_description_ro = 'rrr_Quantifizierung 1 gemäss SN EN 13508. Zulässige Eingaben sind in Kapitel 3.1.5 beschrieben. Als Textattribut umgesetzt.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(20)', field_unit_en = '', field_unit_description_en = 'variabel, depending on EN damage code', field_unit_de = '', field_unit_description_de = 'variabel, je nach EN Schadencode', field_unit_fr = '', field_unit_description_fr = 'variable, dependant du code EN', field_unit_it = '', field_unit_description_it = 'variabile, a seconda del codice danno EN', field_unit_ro = '', field_unit_description_ro = 'rrr_variabel, je nach EN Schadencode', field_max = NULL, field_min = NULL
WHERE (class_id = 3728 AND attribute_id = 3735);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3736) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_quantification2', field_name_en = 'manhole_quantification2', field_name_de = 'Quantifizierung2', field_name_fr = 'QUANTIFICATION2', field_name_it = 'quantificazione2', field_name_ro = 'cuantificare2', field_description_en = 'Quantification 2 according to SN EN 13508. Permissible inputs are described in chapter 3.1.5. Implemented as text attribute.', field_description_de = 'Quantifizierung 2 gemäss SN EN 13508. Zulässige Eingaben sind in Kapitel 3.1.5 beschrieben. Als Textattribut umgesetzt.', field_description_fr = 'Quantification 2 selon la SN EN 13508. Les entrées autorisées sont décrites dans le chapitre 3.1.5. Type texte', field_description_it = 'Quantificazione 2 secondo SN EN 13508. Le immissioni consentite sono descritte nel capitolo 3.1.5. Implementato come attributo di testo', field_description_ro = 'rrr_Quantifizierung 2 gemäss SN EN 13508. Zulässige Eingaben sind in Kapitel 3.1.5 beschrieben. Als Textattribut umgesetzt.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(20)', field_unit_en = '', field_unit_description_en = 'variabel, depending on EN damage code', field_unit_de = '', field_unit_description_de = 'variabel, je nach EN Schadencode', field_unit_fr = '', field_unit_description_fr = 'variable, dependant du code EN', field_unit_it = '', field_unit_description_it = 'variabile, a seconda del codice danno EN', field_unit_ro = '', field_unit_description_ro = 'rrr_variabel, je nach EN Schadencode', field_max = NULL, field_min = NULL
WHERE (class_id = 3728 AND attribute_id = 3736);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3728,3742) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', field_name_en = 'manhole_shaft_area', field_name_de = 'Schachtbereich', field_name_fr = 'DOMAINE_REGARD_VISITE', field_name_it = 'area_pozzetto', field_name_ro = '', field_description_en = 'yyy_Bereich in dem eine Feststellung auftritt. Die Werte sind unter 3.1.9 abschliessend beschrieben.', field_description_de = 'Bereich in dem eine Feststellung auftritt. Die Werte sind unter 3.1.9 abschliessend beschrieben.', field_description_fr = 'Domaine où une observation est faite. Les valeurs sont décrites dans 3.1.9.', field_description_it = 'Area in cui risulta una constatazione. I valori sono descritti in modo esaustivo al punto 3.1.9', field_description_ro = '', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3728 AND attribute_id = 3742);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,3764) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'classname', field_name_en = 'classname', field_name_de = 'Klasse', field_name_fr = 'CLASSE', field_name_it = 'classe', field_name_ro = 'clasa', field_description_en = 'Specifies the classname of the VSA-DSS data model to which the file belongs. In principle, all classes are possible. In the context of sewer television recordings, mainly channel, manhole damage, channel damage and examination.', field_description_de = 'Gibt an, zu welcher Klasse des VSA-DSS-Datenmodells die Datei gehört. Grundsätzlich alle Klassen möglich. Im Rahmen der Kanalfernsehaufnahmen hauptsächlich Kanal, Normschachtschaden, Kanalschaden und Untersuchung.', field_description_fr = 'Indique à quelle classe du modèle de données de VSA-SDEE appartient le fichier. Toutes les classes sont possible. Surtout CANALISATION, DOMMAGE_CHAMBRE_STANDARD, DOMMAGE_CANALISATION, EXAMEN.', field_description_it = 'Indica a quale classe del modello VSA-DSS appartiene il file. Praticamente tutte le classi possibili. Nell''ambito delle registrazioni televisive di canali, principalmente canali, classe danni pozzetto standard, danni canalizzazione e ispezione', field_description_ro = 'rrr_Gibt an, zu welcher Klasse des VSA-DSS-Datenmodells die Datei gehört. Grundsätzlich alle Klassen möglich. Im Rahmen der Kanalfernsehaufnahmen hauptsächlich Kanal, Normschachtschaden, Kanalschaden und Untersuchung.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 3764);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,3754) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'identifier', field_name_en = 'identifier', field_name_de = 'Bezeichnung', field_name_fr = 'DESIGNATION', field_name_it = 'denominazione', field_name_ro = 'identificator', field_description_en = 'yyy_Name der Datei mit Dateiendung. Z.B video_01.mpg oder haltung_01.ipf', field_description_de = 'Name der Datei mit Dateiendung. Z.B video_01.mpg oder haltung_01.ipf', field_description_fr = 'Nom du fichier avec terminaison du fichier. P. ex. video_01.mpg ou canalisation_01.ipf', field_description_it = 'Nome del file con estensione file. Per es. video_01.mpg o tronco_01.ipf', field_description_ro = 'rrr_Name der Datei mit Dateiendung. Z.B video_01.mpg oder haltung_01.ipf', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(120)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 3754);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,3769) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'kind', field_name_en = 'kind', field_name_de = 'Art', field_name_fr = 'GENRE', field_name_it = 'tipo', field_name_ro = 'tip', field_description_en = 'yyy_Beschreibt die Art der Datei. Für analoge Videos auf Bändern ist der Typ "Video" einzusetzen. Die Bezeichnung wird dann gleich gesetzt wie die Bezeichnung des Videobandes.', field_description_de = 'Beschreibt die Art der Datei. Für analoge Videos auf Bändern ist der Typ "Video" einzusetzen. Die Bezeichnung wird dann gleich gesetzt wie die Bezeichnung des Videobandes.', field_description_fr = 'Décrit le type de fichier. Pour les vidéos analo-giques sur bandes, le type « vidéo » doit être entré. La désignation sera ensuite la même que celle de la bande vidéo.', field_description_it = 'Descrive il tipo di file. Per video analogici su nastri si deve inserire il tipo «video». La designazione è identificata con la designazione del nastro video', field_description_ro = 'rrr_Beschreibt die Art der Datei. Für analoge Videos auf Bändern ist der Typ "Video" einzusetzen. Die Bezeichnung wird dann gleich gesetzt wie die Bezeichnung des Videobandes.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 3769);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,3765) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'object', field_name_en = 'object', field_name_de = 'Objekt', field_name_fr = 'OBJET', field_name_it = 'oggetto', field_name_ro = 'obiect', field_description_en = 'yyy_Objekt-ID (OID) des Datensatzes zu dem die Datei gehört', field_description_de = 'Objekt-ID (OID) des Datensatzes zu dem die Datei gehört', field_description_fr = 'Identification de l’ensemble de données auquel le fichier appartient (OID)', field_description_it = 'ID dell’oggetto (OID) del record dei dati a cui appartiene il file', field_description_ro = 'rrr_Objekt-ID (OID) des Datensatzes zu dem die Datei gehört', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(16)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 3765);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,9222) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'oid', field_name_en = 'oid', field_name_de = 'OID', field_name_fr = 'OID', field_name_it = 'OID', field_name_ro = 'OID', field_description_en = 'Stable unique object identification for all objects and classes', field_description_de = 'Stabile eindeutige Objektidentifikation für alle Objekte und Klassen', field_description_fr = 'Identification d''objet unique stable pour tous les objets et toutes les classes', field_description_it = 'Identificazione univoca e stabile per tutti gli oggetti e le classi', field_description_ro = 'Identificare unica stabila a obiectelor pentru toate obiectele ?i clasele', field_mandatory = ARRAY['GEP_Verband','PAA','SAA']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(16)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 9222);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,3767) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'path_relative', field_name_en = 'path_relative', field_name_de = 'Relativpfad', field_name_fr = 'ACCES_RELATIF', field_name_it = 'percorso_relativo', field_name_ro = 'rrr_Relativpfad', field_description_en = 'yyy_Zusätzlicher Relativer Pfad, wo die Datei auf dem Datenträger zu finden ist. Z.B. DVD_01.', field_description_de = 'Zusätzlicher Relativer Pfad, wo die Datei auf dem Datenträger zu finden ist. Z.B. DVD_01.', field_description_fr = 'Accès relatif supplémentaire à l’emplacement du fichier sur le support de données. P. ex. DVD_01', field_description_it = 'Percorso relativo aggiuntivo per reperire il file sul supporto. Per es. DVD_01', field_description_ro = 'rrr_zzz_Zusätzlicher Relativer Pfad, wo die Datei auf dem Datenträger zu finden ist. Z.B. DVD_01.', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(200)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 3767);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3754,3762) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'file', field_name = 'remark', field_name_en = 'remark', field_name_de = 'Bemerkung', field_name_fr = 'REMARQUE', field_name_it = 'osservazione', field_name_ro = 'observatie', field_description_en = 'General remarks', field_description_de = 'Allgemeine Bemerkungen', field_description_fr = 'Remarques générales', field_description_it = 'Osservazioni generali', field_description_ro = 'rrr_Allgemeine Bemerkungen', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(80)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3754 AND attribute_id = 3762);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3776,3777) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'data_media', field_name = 'identifier', field_name_en = 'identifier', field_name_de = 'Bezeichnung', field_name_fr = 'DESIGNATION', field_name_it = 'denominazione', field_name_ro = 'identificator', field_description_en = 'yyy_Name des Datenträgers. Bei elektronischen Datenträgern normalerweise das Volume-Label. Bei einem Server der Servername. Bei analogen Videobändern die Bandnummer.', field_description_de = 'Name des Datenträgers. Bei elektronischen Datenträgern normalerweise das Volume-Label. Bei einem Server der Servername. Bei analogen Videobändern die Bandnummer.', field_description_fr = 'Nom du support de données. Pour les supports de données électroniques, normalement le label volume. Pour un serveur, le nom du serveur. Pour des bandes vidéo analogiques, les numéros de bandes.', field_description_it = 'Nome del supporto dati. Per i supporti dati elettronici, di solito l’etichetta del volume. Per un server il nome del server. Per le videocassette analogiche, il numero del nastro', field_description_ro = '', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(60)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3776 AND attribute_id = 3777);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3776,3783) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'data_media', field_name = 'kind', field_name_en = 'kind', field_name_de = 'Art', field_name_fr = 'GENRE', field_name_it = 'tipo', field_name_ro = 'tip', field_description_en = 'Describes the type of data media', field_description_de = 'Beschreibt die Art des Datenträgers', field_description_fr = 'Décrit le genre de support de données', field_description_it = 'Descrive il tipo di supporto dati', field_description_ro = 'Descrie tipul de suport de date', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3776 AND attribute_id = 3783);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3776,3791) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'data_media', field_name = 'location', field_name_en = 'location', field_name_de = 'Standort', field_name_fr = 'EMPLACEMENT', field_name_it = 'ubicazione', field_name_ro = 'rrr_Standort', field_description_en = 'Location of the data medium', field_description_de = 'Ort, wo sich der Datenträger befindet', field_description_fr = 'Emplacement du support de données', field_description_it = 'Ubicazione del supporto dati', field_description_ro = 'rrr_Wo befindet sich der Datenträger', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(50)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3776 AND attribute_id = 3791);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3776,9224) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'data_media', field_name = 'oid', field_name_en = 'oid', field_name_de = 'OID', field_name_fr = 'OID', field_name_it = 'OID', field_name_ro = 'OID', field_description_en = 'Stable unique object identification for all objects and classes', field_description_de = 'Stabile eindeutige Objektidentifikation für alle Objekte und Klassen', field_description_fr = 'Identification d''objet unique stable pour tous les objets et toutes les classes', field_description_it = 'Identificazione univoca e stabile per tutti gli oggetti e le classi', field_description_ro = 'Identificare unica stabila a obiectelor pentru toate obiectele ?i clasele', field_mandatory = ARRAY['GEP_Verband','PAA','SAA']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(16)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3776 AND attribute_id = 9224);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3776,3781) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'data_media', field_name = 'path', field_name_en = 'path', field_name_de = 'Pfad', field_name_fr = 'CHEMIN_ACCES', field_name_it = 'percorso', field_name_ro = 'rrr_Pfad', field_description_en = 'Access path to the data carrier. e.g. DVD drive -> D: , server -> //server/videos, hard disk -> c:/videos . For web servers -> URI (URL). Empty for an analog video tape', field_description_de = 'Zugriffspfad zum Datenträger. z.B. DVD-Laufwerk -> D: , Server -> //server/videos, Harddisk -> c:/videos . Bei Webserver eine URI (URL). Bei einem analogen Videoband leer', field_description_fr = 'Chemin d’accès au support de données, p. ex. lecteur DVD -> D: , - serveur -> //server/videos , disque dur -> c:/videos , serveur_web -> URI(URL). Pour une bande vidéo analogique: vide', field_description_it = 'Percorso d’accesso al supporto dati, per es. Drive DVD –> D: , server –> \\server\video, disco fisso –> c:\video. Server_web -> URI (URL). Vuoto per una videocassetta analogica', field_description_ro = 'Calea de acces la suportul de date. de exemplu, unitatea DVD -> D: , server -> //server/videos, hard disc -> c:/videos . Pentru serverele web, un URI (URL). Gol pentru o banda video analogica', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(1023)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3776 AND attribute_id = 3781);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (3776,3778) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'data_media', field_name = 'remark', field_name_en = 'remark', field_name_de = 'Bemerkung', field_name_fr = 'REMARQUE', field_name_it = 'osservazione', field_name_ro = 'observatie', field_description_en = 'General remarks', field_description_de = 'Bemerkungen zum Datenträger', field_description_fr = 'Remarques concernant le support de données', field_description_it = 'Osservazioni sul supporto dati', field_description_ro = '', field_mandatory = ARRAY['kein_Plantyp_definiert']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(80)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 3776 AND attribute_id = 3778);





INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3681) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'other', value_name_en = 'other', shortcut_en = '', value_name_de = 'andere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = 'altro', shortcut_it = '', value_name_ro = 'rrr_altul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3681);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3682) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'field_visit', value_name_en = 'field_visit', shortcut_en = '', value_name_de = 'Begehung', shortcut_de = '', value_name_fr = 'parcours', shortcut_fr = '', value_name_it = 'sopralluogo', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3682);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3683) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'deformation_measurement', value_name_en = 'deformation_measurement', shortcut_en = '', value_name_de = 'Deformationsmessung', shortcut_de = '', value_name_fr = 'mesure_deformation', shortcut_fr = '', value_name_it = 'misura_deformazione', shortcut_it = '', value_name_ro = 'rrr_Deformationsmessung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3683);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3684) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'leak_test', value_name_en = 'leak_test', shortcut_en = '', value_name_de = 'Dichtheitspruefung', shortcut_de = '', value_name_fr = 'examen_etancheite', shortcut_fr = '', value_name_it = 'prova_tenuta', shortcut_it = '', value_name_ro = 'rrr_Dichtheitspruefung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3684);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3685) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'georadar', value_name_en = 'georadar', shortcut_en = '', value_name_de = 'Georadar', shortcut_de = '', value_name_fr = 'georadar', shortcut_fr = '', value_name_it = 'georadar', shortcut_it = '', value_name_ro = 'rrr_Georadar', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3685);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3686) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'channel_TV', value_name_en = 'channel_TV', shortcut_en = '', value_name_de = 'Kanalfernsehen', shortcut_de = '', value_name_fr = 'camera_canalisations', shortcut_fr = '', value_name_it = 'videoispezione', shortcut_it = '', value_name_ro = 'rrr_Kanalfernsehen', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3686);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3680,3687) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'recording_type', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnu', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3680 AND attribute_id = 3687);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3698,3699) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'weather', value_name = 'covered_rainy', value_name_en = 'covered_rainy', shortcut_en = '', value_name_de = 'bedeckt_regnerisch', shortcut_de = '', value_name_fr = 'couvert_pluvieux', shortcut_fr = '', value_name_it = 'coperto_piovoso', shortcut_it = '', value_name_ro = 'rrr_bedeckt_regnerisch', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3698 AND attribute_id = 3699);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3698,3700) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'weather', value_name = 'drizzle', value_name_en = 'drizzle', shortcut_en = '', value_name_de = 'Nieselregen', shortcut_de = '', value_name_fr = 'bruine', shortcut_fr = '', value_name_it = 'piogerella', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3698 AND attribute_id = 3700);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3698,3701) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'weather', value_name = 'rain', value_name_en = 'rain', shortcut_en = '', value_name_de = 'Regen', shortcut_de = '', value_name_fr = 'pluie', shortcut_fr = '', value_name_it = 'pioggia', shortcut_it = '', value_name_ro = 'rrr_Regen', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3698 AND attribute_id = 3701);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3698,3702) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'weather', value_name = 'snowfall', value_name_en = 'snowfall', shortcut_en = '', value_name_de = 'Schneefall', shortcut_de = '', value_name_fr = 'chute_neige', shortcut_fr = '', value_name_it = 'nevica', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3698 AND attribute_id = 3702);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3698,3703) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'weather', value_name = 'nice_dry', value_name_en = 'nice_dry', shortcut_en = '', value_name_de = 'schoen_trocken', shortcut_de = '', value_name_fr = 'beau_sec', shortcut_fr = '', value_name_it = 'sereno_asciutto', shortcut_it = '', value_name_ro = 'rrr_schoen_trocken', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3698 AND attribute_id = 3703);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3679,3698,3704) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'examination', field_name = 'weather', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnu', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3679 AND attribute_id = 3698 AND attribute_id = 3704);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,8497,8498) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'connection', value_name = 'yes', value_name_en = 'yes', shortcut_en = '', value_name_de = 'ja', shortcut_de = '', value_name_fr = 'oui', shortcut_fr = '', value_name_it = 'si', shortcut_it = '', value_name_ro = 'da', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 8497 AND attribute_id = 8498);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,8497,8499) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'connection', value_name = 'no', value_name_en = 'no', shortcut_en = '', value_name_de = 'nein', shortcut_de = '', value_name_fr = 'non', shortcut_fr = '', value_name_it = 'no', shortcut_it = '', value_name_ro = 'nu', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 8497 AND attribute_id = 8499);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,3706,3707) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'single_damage_class', value_name = 'EZ0', value_name_en = 'EZ0', shortcut_en = '', value_name_de = 'EZ0', shortcut_de = '', value_name_fr = 'EZ0', shortcut_fr = '', value_name_it = 'EZ0', shortcut_it = '', value_name_ro = 'EZ0', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 3706 AND attribute_id = 3707);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,3706,3708) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'single_damage_class', value_name = 'EZ1', value_name_en = 'EZ1', shortcut_en = '', value_name_de = 'EZ1', shortcut_de = '', value_name_fr = 'EZ1', shortcut_fr = '', value_name_it = 'EZ1', shortcut_it = '', value_name_ro = 'EZ1', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 3706 AND attribute_id = 3708);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,3706,3709) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'single_damage_class', value_name = 'EZ2', value_name_en = 'EZ2', shortcut_en = '', value_name_de = 'EZ2', shortcut_de = '', value_name_fr = 'EZ2', shortcut_fr = '', value_name_it = 'EZ2', shortcut_it = '', value_name_ro = 'EZ2', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 3706 AND attribute_id = 3709);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,3706,3710) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'single_damage_class', value_name = 'EZ3', value_name_en = 'EZ3', shortcut_en = '', value_name_de = 'EZ3', shortcut_de = '', value_name_fr = 'EZ3', shortcut_fr = '', value_name_it = 'EZ3', shortcut_it = '', value_name_ro = 'EZ3', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 3706 AND attribute_id = 3710);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,3706,3711) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'single_damage_class', value_name = 'EZ4', value_name_en = 'EZ4', shortcut_en = '', value_name_de = 'EZ4', shortcut_de = '', value_name_fr = 'EZ4', shortcut_fr = '', value_name_it = 'EZ4', shortcut_it = '', value_name_ro = 'EZ4', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 3706 AND attribute_id = 3711);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3705,3706,4561) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage', field_name = 'single_damage_class', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnu', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3705 AND attribute_id = 3706 AND attribute_id = 4561);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3900) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAAA', value_name_en = 'BAAA', shortcut_en = '', value_name_de = 'BAAA', shortcut_de = '', value_name_fr = 'BAAA', shortcut_fr = '', value_name_it = 'BAAA', shortcut_it = '', value_name_ro = 'BAAA', shortcut_ro = '', value_description_en = 'yyy_Rohr vertikal deformiert', value_description_de = 'Rohr vertikal deformiert', value_description_fr = 'Canalisation déformée verticalement', value_description_it = 'Deformazione verticale del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3900);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3901) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAAB', value_name_en = 'BAAB', shortcut_en = '', value_name_de = 'BAAB', shortcut_de = '', value_name_fr = 'BAAB', shortcut_fr = '', value_name_it = 'BAAB', shortcut_it = '', value_name_ro = 'BAAB', shortcut_ro = '', value_description_en = 'yyy_Rohr horizontal deformiert', value_description_de = 'Rohr horizontal deformiert', value_description_fr = 'Canalisation déformée horizontalement', value_description_it = 'Deformazione orizzontale del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3901);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3902) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABAA', value_name_en = 'BABAA', shortcut_en = '', value_name_de = 'BABAA', shortcut_de = '', value_name_fr = 'BABAA', shortcut_fr = '', value_name_it = 'BABAA', shortcut_it = '', value_name_ro = 'BABAA', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss) längs', value_description_de = 'Oberflächenriss (Haarriss) längs', value_description_fr = 'Fissure superficielle (micro-fissure) longitudinale', value_description_it = 'Fessura superficiale (fessura capillare), longitudinale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3902);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3903) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABAB', value_name_en = 'BABAB', shortcut_en = '', value_name_de = 'BABAB', shortcut_de = '', value_name_fr = 'BABAB', shortcut_fr = '', value_name_it = 'BABAB', shortcut_it = '', value_name_ro = 'BABAB', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss) radial', value_description_de = 'Oberflächenriss (Haarriss) radial', value_description_fr = 'Fissure superficielle (micro-fissure) radiale', value_description_it = 'Fessura superficiale (fessura capillare), radiale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3903);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3904) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABAC', value_name_en = 'BABAC', shortcut_en = '', value_name_de = 'BABAC', shortcut_de = '', value_name_fr = 'BABAC', shortcut_fr = '', value_name_it = 'BABAC', shortcut_it = '', value_name_ro = 'BABAC', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss), komplexe Rissbildung', value_description_de = 'Oberflächenriss (Haarriss), komplexe Rissbildung', value_description_fr = 'Fissure superficielle (micro-fissure), formation complexe de fissures', value_description_it = 'Fessura superficiale (fessura capillare), fessurazione complessa', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3904);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3905) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABAD', value_name_en = 'BABAD', shortcut_en = '', value_name_de = 'BABAD', shortcut_de = '', value_name_fr = 'BABAD', shortcut_fr = '', value_name_it = 'BABAD', shortcut_it = '', value_name_ro = 'BABAD', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss), spiralförmige Rissbildung', value_description_de = 'Oberflächenriss (Haarriss), spiralförmige Rissbildung', value_description_fr = 'Fissure superficielle (micro-fissure), formation hélicoïdale de fissures', value_description_it = 'Fessura superficiale (fessura capillare) fessurazione elicoidale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3905);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3906) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABBA', value_name_en = 'BABBA', shortcut_en = '', value_name_de = 'BABBA', shortcut_de = '', value_name_fr = 'BABBA', shortcut_fr = '', value_name_it = 'BABBA', shortcut_it = '', value_name_ro = 'BABBA', shortcut_ro = '', value_description_en = 'yyy_Riss längs', value_description_de = 'Riss längs', value_description_fr = 'Fissure longitudinale', value_description_it = 'Spaccatura longitudinale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3906);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3907) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABBB', value_name_en = 'BABBB', shortcut_en = '', value_name_de = 'BABBB', shortcut_de = '', value_name_fr = 'BABBB', shortcut_fr = '', value_name_it = 'BABBB', shortcut_it = '', value_name_ro = 'BABBB', shortcut_ro = '', value_description_en = 'yyy_Riss radial', value_description_de = 'Riss radial', value_description_fr = 'Fissure radiale', value_description_it = 'Spaccatura radiale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3907);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3908) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABBC', value_name_en = 'BABBC', shortcut_en = '', value_name_de = 'BABBC', shortcut_de = '', value_name_fr = 'BABBC', shortcut_fr = '', value_name_it = 'BABBC', shortcut_it = '', value_name_ro = 'BABBC', shortcut_ro = '', value_description_en = 'yyy_Riss, komplexe Rissbildung, Scherbenbildung', value_description_de = 'Riss, komplexe Rissbildung, Scherbenbildung', value_description_fr = 'Fissure, formation complexe de fissures', value_description_it = 'Spaccatura, fessurazione complessa, formazione cocci', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3908);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3909) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABBD', value_name_en = 'BABBD', shortcut_en = '', value_name_de = 'BABBD', shortcut_de = '', value_name_fr = 'BABBD', shortcut_fr = '', value_name_it = 'BABBD', shortcut_it = '', value_name_ro = 'BABBD', shortcut_ro = '', value_description_en = 'yyy_Riss, spiralförmige Rissbildung', value_description_de = 'Riss, spiralförmige Rissbildung', value_description_fr = 'Fissure, formation hélicoïdale de fissures', value_description_it = 'Spaccatura, fessurazione elicoidale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3909);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3910) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABCA', value_name_en = 'BABCA', shortcut_en = '', value_name_de = 'BABCA', shortcut_de = '', value_name_fr = 'BABCA', shortcut_fr = '', value_name_it = 'BABCA', shortcut_it = '', value_name_ro = 'BABCA', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, längs', value_description_de = 'Klaffender Riss, längs', value_description_fr = 'Fissure béante, longitudinale', value_description_it = 'Frattura aperta, longitudinale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3910);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3911) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABCB', value_name_en = 'BABCB', shortcut_en = '', value_name_de = 'BABCB', shortcut_de = '', value_name_fr = 'BABCB', shortcut_fr = '', value_name_it = 'BABCB', shortcut_it = '', value_name_ro = 'BABCB', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, radial', value_description_de = 'Klaffender Riss, radial', value_description_fr = 'Fissure béante, radiale', value_description_it = 'Frattura aperta, radiale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3911);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3912) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABCC', value_name_en = 'BABCC', shortcut_en = '', value_name_de = 'BABCC', shortcut_de = '', value_name_fr = 'BABCC', shortcut_fr = '', value_name_it = 'BABCC', shortcut_it = '', value_name_ro = 'BABCC', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, komplexe Rissbildung, Scherbenbildung', value_description_de = 'Klaffender Riss, komplexe Rissbildung, Scherbenbildung', value_description_fr = 'Fissure béante, formation complexe de fissures', value_description_it = 'Frattura aperta, fessurazione complessa, formazione cocci', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3912);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3913) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABCD', value_name_en = 'BABCD', shortcut_en = '', value_name_de = 'BABCD', shortcut_de = '', value_name_fr = 'BABCD', shortcut_fr = '', value_name_it = 'BABCD', shortcut_it = '', value_name_ro = 'BABCD', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, spiralförmige Rissbildung', value_description_de = 'Klaffender Riss, spiralförmige Rissbildung', value_description_fr = 'Fissure béante, formation hélicoïdale de fissures', value_description_it = 'Frattura aperta, fessurazione elicoidale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3913);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3914) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BACA', value_name_en = 'BACA', shortcut_en = '', value_name_de = 'BACA', shortcut_de = '', value_name_fr = 'BACA', shortcut_fr = '', value_name_it = 'BACA', shortcut_it = '', value_name_ro = 'BACA', shortcut_ro = '', value_description_en = 'yyy_In der Lage verschobene Scherbe', value_description_de = 'In der Lage verschobene Scherbe', value_description_fr = 'Formation d’éclats', value_description_it = 'Rottura con pezzi spostati ma non mancanti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3914);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3915) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BACB', value_name_en = 'BACB', shortcut_en = '', value_name_de = 'BACB', shortcut_de = '', value_name_fr = 'BACB', shortcut_fr = '', value_name_it = 'BACB', shortcut_it = '', value_name_ro = 'BACB', shortcut_ro = '', value_description_en = 'yyy_Fehlende Scherbe / Wandungsteil (Loch)', value_description_de = 'Fehlende Scherbe / Wandungsteil (Loch)', value_description_fr = 'Éclat / partie de paroi manquants (trou)', value_description_it = 'Mancanza di frammenti o pezzi sulla parete/(foro)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3915);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3916) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BACC', value_name_en = 'BACC', shortcut_en = '', value_name_de = 'BACC', shortcut_de = '', value_name_fr = 'BACC', shortcut_fr = '', value_name_it = 'BACC', shortcut_it = '', value_name_ro = 'BACC', shortcut_ro = '', value_description_en = 'yyy_Leitungsbruch / Einsturz', value_description_de = 'Leitungsbruch / Einsturz', value_description_fr = 'Rupture / effondrement', value_description_it = 'Rottura della condotta/crollo strutturale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3916);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3917) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BADA', value_name_en = 'BADA', shortcut_en = '', value_name_de = 'BADA', shortcut_de = '', value_name_fr = 'BADA', shortcut_fr = '', value_name_it = 'BADA', shortcut_it = '', value_name_ro = 'BADA', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine verschoben', value_description_de = 'Mauerwerk defekt, Mauer- / Backsteine verschoben', value_description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie déplacés', value_description_it = 'Muratura difettosa, mattoni o pezzi di muratura spostati', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3917);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3918) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BADB', value_name_en = 'BADB', shortcut_en = '', value_name_de = 'BADB', shortcut_de = '', value_name_fr = 'BADB', shortcut_fr = '', value_name_it = 'BADB', shortcut_it = '', value_name_ro = 'BADB', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine fehlen', value_description_de = 'Mauerwerk defekt, Mauer- / Backsteine fehlen', value_description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie manquants', value_description_it = 'Muratura difettosa, mattoni o pezzi di muratura mancanti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3918);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3919) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BADC', value_name_en = 'BADC', shortcut_en = '', value_name_de = 'BADC', shortcut_de = '', value_name_fr = 'BADC', shortcut_fr = '', value_name_it = 'BADC', shortcut_it = '', value_name_ro = 'BADC', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Sohle abgesackt', value_description_de = 'Mauerwerk defekt, Sohle abgesackt', value_description_fr = 'Maçonnerie défectueuse, radier affaissé', value_description_it = 'Muratura difettosa, cedimento del fondo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3919);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3920) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BADD', value_name_en = 'BADD', shortcut_en = '', value_name_de = 'BADD', shortcut_de = '', value_name_fr = 'BADD', shortcut_fr = '', value_name_it = 'BADD', shortcut_it = '', value_name_ro = 'BADD', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Einsturz', value_description_de = 'Mauerwerk defekt, Einsturz', value_description_fr = 'Maçonnerie défectueuse, effondrement', value_description_it = 'Muratura difettosa, crollo strutturale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3920);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3921) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAE', value_name_en = 'BAE', shortcut_en = '', value_name_de = 'BAE', shortcut_de = '', value_name_fr = 'BAE', shortcut_fr = '', value_name_it = 'BAE', shortcut_it = '', value_name_ro = 'BAE', shortcut_ro = '', value_description_en = 'yyy_Mörtel aus Mauerwerk fehlt ganz oder teilweise', value_description_de = 'Mörtel aus Mauerwerk fehlt ganz oder teilweise', value_description_fr = 'Tout ou partie du mortier de la maçonnerie est manquant(e)', value_description_it = 'Manca completamente o parzialmente la malta della muratura.', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3921);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3922) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFAA', value_name_en = 'BAFAA', shortcut_en = '', value_name_de = 'BAFAA', shortcut_de = '', value_name_fr = 'BAFAA', shortcut_fr = '', value_name_it = 'BAFAA', shortcut_it = '', value_name_ro = 'BAFAA', shortcut_ro = '', value_description_en = 'yyy_Rauhe Rohrwandung durch mechanische Beschädigung', value_description_de = 'Rauhe Rohrwandung durch mechanische Beschädigung', value_description_fr = 'Paroi de la canalisation rugueuse par dégradation mécanique', value_description_it = 'Parete del tubo ruvida per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3922);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3923) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFAB', value_name_en = 'BAFAB', shortcut_en = '', value_name_de = 'BAFAB', shortcut_de = '', value_name_fr = 'BAFAB', shortcut_fr = '', value_name_it = 'BAFAB', shortcut_it = '', value_name_ro = 'BAFAB', shortcut_ro = '', value_description_en = 'yyy_Rauhe Rohrwandung durch chemischen Angriff', value_description_de = 'Rauhe Rohrwandung durch chemischen Angriff', value_description_fr = 'Paroi de la canalisation rugueuse par attaque chimique', value_description_it = 'Parete del tubo ruvida per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3923);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3924) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFAC', value_name_en = 'BAFAC', shortcut_en = '', value_name_de = 'BAFAC', shortcut_de = '', value_name_fr = 'BAFAC', shortcut_fr = '', value_name_it = 'BAFAC', shortcut_it = '', value_name_ro = 'BAFAC', shortcut_ro = '', value_description_en = 'yyy_Rauhe Rohrwandung durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Rauhe Rohrwandung durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Parete del tubo ruvida per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3924);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3925) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFAD', value_name_en = 'BAFAD', shortcut_en = '', value_name_de = 'BAFAD', shortcut_de = '', value_name_fr = 'BAFAD', shortcut_fr = '', value_name_it = 'BAFAD', shortcut_it = '', value_name_ro = 'BAFAD', shortcut_ro = '', value_description_en = 'yyy_Rauhe Rohrwandung durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Rauhe Rohrwandung durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Parete del tubo ruvida per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3925);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3926) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFAE', value_name_en = 'BAFAE', shortcut_en = '', value_name_de = 'BAFAE', shortcut_de = '', value_name_fr = 'BAFAE', shortcut_fr = '', value_name_it = 'BAFAE', shortcut_it = '', value_name_ro = 'BAFAE', shortcut_ro = '', value_description_en = 'yyy_Rauhe Rohrwandung, Ursache nicht eindeutig feststellbar', value_description_de = 'Rauhe Rohrwandung, Ursache nicht eindeutig feststellbar', value_description_fr = 'Paroi de la canalisation rugueuse, cause pas clairement identifiable', value_description_it = 'Parete del tubo ruvida per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3926);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3927) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFBA', value_name_en = 'BAFBA', shortcut_en = '', value_name_de = 'BAFBA', shortcut_de = '', value_name_fr = 'BAFBA', shortcut_fr = '', value_name_it = 'BAFBA', shortcut_it = '', value_name_ro = 'BAFBA', shortcut_ro = '', value_description_en = 'yyy_Abplatzung durch mechanische Beschädigung', value_description_de = 'Abplatzung durch mechanische Beschädigung', value_description_fr = 'Écaillage par dégradation mécanique', value_description_it = 'Sfaldamento per danno meccanico (anche il giunto del tubo si è rotto)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3927);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3928) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFBE', value_name_en = 'BAFBE', shortcut_en = '', value_name_de = 'BAFBE', shortcut_de = '', value_name_fr = 'BAFBE', shortcut_fr = '', value_name_it = 'BAFBE', shortcut_it = '', value_name_ro = 'BAFBE', shortcut_ro = '', value_description_en = 'yyy_Abplatzung, Ursache nicht eindeutig feststellbar', value_description_de = 'Abplatzung, Ursache nicht eindeutig feststellbar', value_description_fr = 'Écaillage, cause pas clairement identifiable', value_description_it = 'Sfaldamento per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3928);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3929) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFCA', value_name_en = 'BAFCA', shortcut_en = '', value_name_de = 'BAFCA', shortcut_de = '', value_name_fr = 'BAFCA', shortcut_fr = '', value_name_it = 'BAFCA', shortcut_it = '', value_name_ro = 'BAFCA', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch mechanische Beschädigung', value_description_de = 'Zuschlagstoffe sichtbar durch mechanische Beschädigung', value_description_fr = 'Agrégats visibles par dégradation mécanique', value_description_it = 'Materiale inerte visibile per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3929);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3930) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFCB', value_name_en = 'BAFCB', shortcut_en = '', value_name_de = 'BAFCB', shortcut_de = '', value_name_fr = 'BAFCB', shortcut_fr = '', value_name_it = 'BAFCB', shortcut_it = '', value_name_ro = 'BAFCB', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff', value_description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff', value_description_fr = 'Agrégats visibles par attaque chimique', value_description_it = 'Materiale inerte visibile per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3930);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3931) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFCC', value_name_en = 'BAFCC', shortcut_en = '', value_name_de = 'BAFCC', shortcut_de = '', value_name_fr = 'BAFCC', shortcut_fr = '', value_name_it = 'BAFCC', shortcut_it = '', value_name_ro = 'BAFCC', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Agrégats visibles par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Materiale inerte visibile per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3931);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3932) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFCD', value_name_en = 'BAFCD', shortcut_en = '', value_name_de = 'BAFCD', shortcut_de = '', value_name_fr = 'BAFCD', shortcut_fr = '', value_name_it = 'BAFCD', shortcut_it = '', value_name_ro = 'BAFCD', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Agrégats visibles par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Materiale inerte visibile per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3932);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3933) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFCE', value_name_en = 'BAFCE', shortcut_en = '', value_name_de = 'BAFCE', shortcut_de = '', value_name_fr = 'BAFCE', shortcut_fr = '', value_name_it = 'BAFCE', shortcut_it = '', value_name_ro = 'BAFCE', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar, Ursache nicht eindeutig feststellbar', value_description_de = 'Zuschlagstoffe sichtbar, Ursache nicht eindeutig feststellbar', value_description_fr = 'Agrégats visibles, cause pas clairement identifiable', value_description_it = 'Materiale inerte visibile per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3933);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3934) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFDA', value_name_en = 'BAFDA', shortcut_en = '', value_name_de = 'BAFDA', shortcut_de = '', value_name_fr = 'BAFDA', shortcut_fr = '', value_name_it = 'BAFDA', shortcut_it = '', value_name_ro = 'BAFDA', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch mechanische Beschädigung', value_description_de = 'Zuschlagstoffe einragend durch mechanische Beschädigung', value_description_fr = 'Agrégats intrusifs en raison de dommages mécaniques', value_description_it = 'Materiale inerte sporgente per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3934);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3935) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFDB', value_name_en = 'BAFDB', shortcut_en = '', value_name_de = 'BAFDB', shortcut_de = '', value_name_fr = 'BAFDB', shortcut_fr = '', value_name_it = 'BAFDB', shortcut_it = '', value_name_ro = 'BAFDB', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff', value_description_de = 'Zuschlagstoffe einragend durch chemischen Angriff', value_description_fr = 'Agrégats intrusifs par attaque chimique', value_description_it = 'Materiale inerte sporgente per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3935);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3936) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFDC', value_name_en = 'BAFDC', shortcut_en = '', value_name_de = 'BAFDC', shortcut_de = '', value_name_fr = 'BAFDC', shortcut_fr = '', value_name_it = 'BAFDC', shortcut_it = '', value_name_ro = 'BAFDC', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Agrégats intrusifs par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Materiale inerte sporgente per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3936);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3937) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFDD', value_name_en = 'BAFDD', shortcut_en = '', value_name_de = 'BAFDD', shortcut_de = '', value_name_fr = 'BAFDD', shortcut_fr = '', value_name_it = 'BAFDD', shortcut_it = '', value_name_ro = 'BAFDD', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Agrégats intrusifs par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Materiale inerte sporgente per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3937);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3938) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFDE', value_name_en = 'BAFDE', shortcut_en = '', value_name_de = 'BAFDE', shortcut_de = '', value_name_fr = 'BAFDE', shortcut_fr = '', value_name_it = 'BAFDE', shortcut_it = '', value_name_ro = 'BAFDE', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend, Ursache nicht eindeutig feststellbar', value_description_de = 'Zuschlagstoffe einragend, Ursache nicht eindeutig feststellbar', value_description_fr = 'Agrégats intrusifs, cause pas clairement identifiable', value_description_it = 'Materiale inerte sporgente per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3938);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3939) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFEA', value_name_en = 'BAFEA', shortcut_en = '', value_name_de = 'BAFEA', shortcut_de = '', value_name_fr = 'BAFEA', shortcut_fr = '', value_name_it = 'BAFEA', shortcut_it = '', value_name_ro = 'BAFEA', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch mechanische Beschädigung', value_description_de = 'Zuschlagstoffe fehlen durch mechanische Beschädigung', value_description_fr = 'Agrégats  manquants par dégradation mécanique', value_description_it = 'Materiale mancante per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3939);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3940) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFEB', value_name_en = 'BAFEB', shortcut_en = '', value_name_de = 'BAFEB', shortcut_de = '', value_name_fr = 'BAFEB', shortcut_fr = '', value_name_it = 'BAFEB', shortcut_it = '', value_name_ro = 'BAFEB', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff', value_description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff', value_description_fr = 'Agrégats  manquants par attaque chimique', value_description_it = 'Materiale mancante per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3940);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3941) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFEC', value_name_en = 'BAFEC', shortcut_en = '', value_name_de = 'BAFEC', shortcut_de = '', value_name_fr = 'BAFEC', shortcut_fr = '', value_name_it = 'BAFEC', shortcut_it = '', value_name_ro = 'BAFEC', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Agrégats manquants par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Materiale mancante per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3941);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3942) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFED', value_name_en = 'BAFED', shortcut_en = '', value_name_de = 'BAFED', shortcut_de = '', value_name_fr = 'BAFED', shortcut_fr = '', value_name_it = 'BAFED', shortcut_it = '', value_name_ro = 'BAFED', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Agrégats manquants par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Materiale mancante per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3942);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3943) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFEE', value_name_en = 'BAFEE', shortcut_en = '', value_name_de = 'BAFEE', shortcut_de = '', value_name_fr = 'BAFEE', shortcut_fr = '', value_name_it = 'BAFEE', shortcut_it = '', value_name_ro = 'BAFEE', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen, Ursache nicht eindeutig feststellbar', value_description_de = 'Zuschlagstoffe fehlen, Ursache nicht eindeutig feststellbar', value_description_fr = 'Agrégats manquants, cause pas clairement identifiable', value_description_it = 'Materiale mancante per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3943);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3944) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFFA', value_name_en = 'BAFFA', shortcut_en = '', value_name_de = 'BAFFA', shortcut_de = '', value_name_fr = 'BAFFA', shortcut_fr = '', value_name_it = 'BAFFA', shortcut_it = '', value_name_ro = 'BAFFA', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch mechanische Beschädigung', value_description_de = 'Bewehrung sichtbar durch mechanische Beschädigung', value_description_fr = 'Armature visible par dégradation mécanique', value_description_it = 'Armatura visibile per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3944);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3945) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFFB', value_name_en = 'BAFFB', shortcut_en = '', value_name_de = 'BAFFB', shortcut_de = '', value_name_fr = 'BAFFB', shortcut_fr = '', value_name_it = 'BAFFB', shortcut_it = '', value_name_ro = 'BAFFB', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff', value_description_de = 'Bewehrung sichtbar durch chemischen Angriff', value_description_fr = 'Armature visible par attaque chimique', value_description_it = 'Armatura visibile per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3945);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3946) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFFC', value_name_en = 'BAFFC', shortcut_en = '', value_name_de = 'BAFFC', shortcut_de = '', value_name_fr = 'BAFFC', shortcut_fr = '', value_name_it = 'BAFFC', shortcut_it = '', value_name_ro = 'BAFFC', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Armature visible par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Armatura visibile per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3946);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3947) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFFD', value_name_en = 'BAFFD', shortcut_en = '', value_name_de = 'BAFFD', shortcut_de = '', value_name_fr = 'BAFFD', shortcut_fr = '', value_name_it = 'BAFFD', shortcut_it = '', value_name_ro = 'BAFFD', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Armature visible par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Armatura visibile per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3947);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3948) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFFE', value_name_en = 'BAFFE', shortcut_en = '', value_name_de = 'BAFFE', shortcut_de = '', value_name_fr = 'BAFFE', shortcut_fr = '', value_name_it = 'BAFFE', shortcut_it = '', value_name_ro = 'BAFFE', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar, Ursache nicht eindeutig feststellbar', value_description_de = 'Bewehrung sichtbar, Ursache nicht eindeutig feststellbar', value_description_fr = 'Armature visible, cause pas clairement identifiable', value_description_it = 'Armatura visibile per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3948);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3949) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFGA', value_name_en = 'BAFGA', shortcut_en = '', value_name_de = 'BAFGA', shortcut_de = '', value_name_fr = 'BAFGA', shortcut_fr = '', value_name_it = 'BAFGA', shortcut_it = '', value_name_ro = 'BAFGA', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch mechanische Beschädigung', value_description_de = 'Bewehrung einragend durch mechanische Beschädigung', value_description_fr = 'Armature dépassant de la surface par dégradation mécanique', value_description_it = 'Armatura sporgente per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3949);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3950) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFGB', value_name_en = 'BAFGB', shortcut_en = '', value_name_de = 'BAFGB', shortcut_de = '', value_name_fr = 'BAFGB', shortcut_fr = '', value_name_it = 'BAFGB', shortcut_it = '', value_name_ro = 'BAFGB', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch chemischen Angriff', value_description_de = 'Bewehrung einragend durch chemischen Angriff', value_description_fr = 'Armature dépassant de la surface par attaque chimique', value_description_it = 'Armatura sporgente per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3950);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3951) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFGC', value_name_en = 'BAFGC', shortcut_en = '', value_name_de = 'BAFGC', shortcut_de = '', value_name_fr = 'BAFGC', shortcut_fr = '', value_name_it = 'BAFGC', shortcut_it = '', value_name_ro = 'BAFGC', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Bewehrung einragend durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Armatura sporgente per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3951);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3952) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFGD', value_name_en = 'BAFGD', shortcut_en = '', value_name_de = 'BAFGD', shortcut_de = '', value_name_fr = 'BAFGD', shortcut_fr = '', value_name_it = 'BAFGD', shortcut_it = '', value_name_ro = 'BAFGD', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Bewehrung einragend durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Armatura sporgente per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3952);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3953) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFGE', value_name_en = 'BAFGE', shortcut_en = '', value_name_de = 'BAFGE', shortcut_de = '', value_name_fr = 'BAFGE', shortcut_fr = '', value_name_it = 'BAFGE', shortcut_it = '', value_name_ro = 'BAFGE', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend, Ursache nicht eindeutig feststellbar', value_description_de = 'Bewehrung einragend, Ursache nicht eindeutig feststellbar', value_description_fr = 'Armature dépassant de la surface, cause pas clairement identifiable', value_description_it = 'Armatura sporgente per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3953);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3954) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFHB', value_name_en = 'BAFHB', shortcut_en = '', value_name_de = 'BAFHB', shortcut_de = '', value_name_fr = 'BAFHB', shortcut_fr = '', value_name_it = 'BAFHB', shortcut_it = '', value_name_ro = 'BAFHB', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff', value_description_de = 'Bewehrung korrodiert durch chemischen Angriff', value_description_fr = 'Armature corrodée par attaque chimique', value_description_it = 'Armatura corrosa per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3954);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3955) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFHC', value_name_en = 'BAFHC', shortcut_en = '', value_name_de = 'BAFHC', shortcut_de = '', value_name_fr = 'BAFHC', shortcut_fr = '', value_name_it = 'BAFHC', shortcut_it = '', value_name_ro = 'BAFHC', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Armature corrodée par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Armatura corrosa per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3955);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3956) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFHD', value_name_en = 'BAFHD', shortcut_en = '', value_name_de = 'BAFHD', shortcut_de = '', value_name_fr = 'BAFHD', shortcut_fr = '', value_name_it = 'BAFHD', shortcut_it = '', value_name_ro = 'BAFHD', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Armature corrodée par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Armatura corrosa per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3956);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3957) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFHE', value_name_en = 'BAFHE', shortcut_en = '', value_name_de = 'BAFHE', shortcut_de = '', value_name_fr = 'BAFHE', shortcut_fr = '', value_name_it = 'BAFHE', shortcut_it = '', value_name_ro = 'BAFHE', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert, Ursache nicht eindeutig feststellbar', value_description_de = 'Bewehrung korrodiert, Ursache nicht eindeutig feststellbar', value_description_fr = 'Armature corrodée, cause pas clairement identifiable', value_description_it = 'Armatura corrosa per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3957);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3958) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFIA', value_name_en = 'BAFIA', shortcut_en = '', value_name_de = 'BAFIA', shortcut_de = '', value_name_fr = 'BAFIA', shortcut_fr = '', value_name_it = 'BAFIA', shortcut_it = '', value_name_ro = 'BAFIA', shortcut_ro = '', value_description_en = 'yyy_Fehlende Rohrwandung durch mechanische Beschädigung', value_description_de = 'Fehlende Rohrwandung durch mechanische Beschädigung', value_description_fr = 'Paroi manquante par dégradation mécanique', value_description_it = 'Parete mancante per danno meccanico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3958);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3959) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFIB', value_name_en = 'BAFIB', shortcut_en = '', value_name_de = 'BAFIB', shortcut_de = '', value_name_fr = 'BAFIB', shortcut_fr = '', value_name_it = 'BAFIB', shortcut_it = '', value_name_ro = 'BAFIB', shortcut_ro = '', value_description_en = 'yyy_Fehlende Rohrwandung durch chemischen Angriff', value_description_de = 'Fehlende Rohrwandung durch chemischen Angriff', value_description_fr = 'Paroi manquante par attaque chimique', value_description_it = 'Parete mancante per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3959);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3960) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFIC', value_name_en = 'BAFIC', shortcut_en = '', value_name_de = 'BAFIC', shortcut_de = '', value_name_fr = 'BAFIC', shortcut_fr = '', value_name_it = 'BAFIC', shortcut_it = '', value_name_ro = 'BAFIC', shortcut_ro = '', value_description_en = 'yyy_Fehlende Rohrwandung durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Fehlende Rohrwandung durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Paroi manquante par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Parete mancante per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3960);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3961) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFID', value_name_en = 'BAFID', shortcut_en = '', value_name_de = 'BAFID', shortcut_de = '', value_name_fr = 'BAFID', shortcut_fr = '', value_name_it = 'BAFID', shortcut_it = '', value_name_ro = 'BAFID', shortcut_ro = '', value_description_en = 'yyy_Fehlende Rohrwandung durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Fehlende Rohrwandung durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Paroi manquante par attaquechimique sur la partie inférieure du tuyau', value_description_it = 'Parete mancante per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3961);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3962) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFIE', value_name_en = 'BAFIE', shortcut_en = '', value_name_de = 'BAFIE', shortcut_de = '', value_name_fr = 'BAFIE', shortcut_fr = '', value_name_it = 'BAFIE', shortcut_it = '', value_name_ro = 'BAFIE', shortcut_ro = '', value_description_en = 'yyy_Fehlende Rohrwandung, Ursache nicht eindeutig feststellbar', value_description_de = 'Fehlende Rohrwandung, Ursache nicht eindeutig feststellbar', value_description_fr = 'Paroi manquante, cause pas clairement identifiable', value_description_it = 'Parete mancante per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3962);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3963) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFJB', value_name_en = 'BAFJB', shortcut_en = '', value_name_de = 'BAFJB', shortcut_de = '', value_name_fr = 'BAFJB', shortcut_fr = '', value_name_it = 'BAFJB', shortcut_it = '', value_name_ro = 'BAFJB', shortcut_ro = '', value_description_en = 'yyy_Rohrwand korrodiert durch chemischen Angriff', value_description_de = 'Rohrwand korrodiert durch chemischen Angriff', value_description_fr = 'Paroi corrodée par attaque chimique', value_description_it = 'Parete corrosa per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3963);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3964) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFJC', value_name_en = 'BAFJC', shortcut_en = '', value_name_de = 'BAFJC', shortcut_de = '', value_name_fr = 'BAFJC', shortcut_fr = '', value_name_it = 'BAFJC', shortcut_it = '', value_name_ro = 'BAFJC', shortcut_ro = '', value_description_en = 'yyy_Rohrwand korrodiert durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Rohrwand korrodiert durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Paroi corrodée par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Parete corrosa per aggressione chimica nella parte superiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3964);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3965) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFJD', value_name_en = 'BAFJD', shortcut_en = '', value_name_de = 'BAFJD', shortcut_de = '', value_name_fr = 'BAFJD', shortcut_fr = '', value_name_it = 'BAFJD', shortcut_it = '', value_name_ro = 'BAFJD', shortcut_ro = '', value_description_en = 'yyy_Rohrwand korrodiert durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'Rohrwand korrodiert durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Paroi corrodée par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Parete corrosa per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3965);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3966) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFJE', value_name_en = 'BAFJE', shortcut_en = '', value_name_de = 'BAFJE', shortcut_de = '', value_name_fr = 'BAFJE', shortcut_fr = '', value_name_it = 'BAFJE', shortcut_it = '', value_name_ro = 'BAFJE', shortcut_ro = '', value_description_en = 'yyy_Rohrwand korrodiert, Ursache nicht eindeutig feststellbar', value_description_de = 'Rohrwand korrodiert, Ursache nicht eindeutig feststellbar', value_description_fr = 'Paroi corrodée, cause pas clairement identifiable', value_description_it = 'Parete corrosa per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3966);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3967) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFZA', value_name_en = 'BAFZA', shortcut_en = '', value_name_de = 'BAFZA', shortcut_de = '', value_name_fr = 'BAFZA', shortcut_fr = '', value_name_it = 'BAFZA', shortcut_it = '', value_name_ro = 'BAFZA', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Oberflächenschaden durch mechanische Beschädigung', value_description_de = 'Andersartiger Oberflächenschaden durch mechanische Beschädigung', value_description_fr = 'Dégradation de surface par dégradation mécanique', value_description_it = 'Altri danni superficiali per danno meccanico (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3967);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3968) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFZB', value_name_en = 'BAFZB', shortcut_en = '', value_name_de = 'BAFZB', shortcut_de = '', value_name_fr = 'BAFZB', shortcut_fr = '', value_name_it = 'BAFZB', shortcut_it = '', value_name_ro = 'BAFZB', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Oberflächenschaden durch chemischen Angriff', value_description_de = 'Andersartiger Oberflächenschaden durch chemischen Angriff', value_description_fr = 'Dégradation de surface par attaque chimique', value_description_it = 'Altri danni superficiali per aggressione chimica (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3968);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3969) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFZC', value_name_en = 'BAFZC', shortcut_en = '', value_name_de = 'BAFZC', shortcut_de = '', value_name_fr = 'BAFZC', shortcut_fr = '', value_name_it = 'BAFZC', shortcut_it = '', value_name_ro = 'BAFZC', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Oberflächenschaden durch chemischen Angriff im oberen Teil des Rohres', value_description_de = 'Andersartiger Oberflächenschaden durch chemischen Angriff im oberen Teil des Rohres', value_description_fr = 'Dégradation de surface par attaque chimique sur la partie supérieure du tuyau ', value_description_it = 'Altri danni superficiali per aggressione chimica nella parte superiore del tubo (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3969);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3970) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFZD', value_name_en = 'BAFZD', shortcut_en = '', value_name_de = 'BAFZD', shortcut_de = '', value_name_fr = 'BAFZD', shortcut_fr = '', value_name_it = 'BAFZD', shortcut_it = '', value_name_ro = 'BAFZD', shortcut_ro = '', value_description_en = 'yyy_AndersartigerOberflächenschaden durch chemischen Angriff im unteren Teil des Rohres', value_description_de = 'AndersartigerOberflächenschaden durch chemischen Angriff im unteren Teil des Rohres', value_description_fr = 'Dégradation de surface par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Altri danni superficiali per aggressione chimica nella parte inferiore del tubo (ulteriori dettagli sono richiesti nell’osservazione))', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3970);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3971) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFZE', value_name_en = 'BAFZE', shortcut_en = '', value_name_de = 'BAFZE', shortcut_de = '', value_name_fr = 'BAFZE', shortcut_fr = '', value_name_it = 'BAFZE', shortcut_it = '', value_name_ro = 'BAFZE', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Oberflächenschaden, Ursache nicht eindeutig feststellbar', value_description_de = 'Andersartiger Oberflächenschaden, Ursache nicht eindeutig feststellbar', value_description_fr = 'Dégradation de surface, cause pas clairement identifiable ', value_description_it = 'Altri danni superficiali per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3971);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3972) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAGA', value_name_en = 'BAGA', shortcut_en = '', value_name_de = 'BAGA', shortcut_de = '', value_name_fr = 'BAGA', shortcut_fr = '', value_name_it = 'BAGA', shortcut_it = '', value_name_ro = 'BAGA', shortcut_ro = '', value_description_en = 'yyy_Anschluss einragend', value_description_de = 'Anschluss einragend', value_description_fr = 'Branchement pénétrant', value_description_it = 'Allacciamento sporgente', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3972);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3973) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAHA', value_name_en = 'BAHA', shortcut_en = '', value_name_de = 'BAHA', shortcut_de = '', value_name_fr = 'BAHA', shortcut_fr = '', value_name_it = 'BAHA', shortcut_it = '', value_name_ro = 'BAHA', shortcut_ro = '', value_description_en = 'yyy_Anschluss falsch eingeführt', value_description_de = 'Anschluss falsch eingeführt', value_description_fr = 'Raccordement à position incorrecte', value_description_it = 'Allacciamento raccordato in modo errato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3973);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3974) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAHB', value_name_en = 'BAHB', shortcut_en = '', value_name_de = 'BAHB', shortcut_de = '', value_name_fr = 'BAHB', shortcut_fr = '', value_name_it = 'BAHB', shortcut_it = '', value_name_ro = 'BAHB', shortcut_ro = '', value_description_en = 'yyy_Anschluss zurückliegend', value_description_de = 'Anschluss zurückliegend', value_description_fr = 'Raccordement en retrait', value_description_it = 'Allacciamento non raccordato a filo della parte del pozzetto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3974);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3975) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAHC', value_name_en = 'BAHC', shortcut_en = '', value_name_de = 'BAHC', shortcut_de = '', value_name_fr = 'BAHC', shortcut_fr = '', value_name_it = 'BAHC', shortcut_it = '', value_name_ro = 'BAHC', shortcut_ro = '', value_description_en = 'yyy_Anschluss unvollständig oder nicht eingebunden', value_description_de = 'Anschluss unvollständig oder nicht eingebunden', value_description_fr = 'Raccordement incomplet', value_description_it = 'Allacciamento non raccordato a tenuta stagna o solo parzialmente', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3975);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3976) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAHD', value_name_en = 'BAHD', shortcut_en = '', value_name_de = 'BAHD', shortcut_de = '', value_name_fr = 'BAHD', shortcut_fr = '', value_name_it = 'BAHD', shortcut_it = '', value_name_ro = 'BAHD', shortcut_ro = '', value_description_en = 'yyy_Anschluss beschädigt', value_description_de = 'Anschluss beschädigt', value_description_fr = 'Raccordement endommagé', value_description_it = 'Tubo di raccordo danneggiato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3976);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3977) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAHE', value_name_en = 'BAHE', shortcut_en = '', value_name_de = 'BAHE', shortcut_de = '', value_name_fr = 'BAHE', shortcut_fr = '', value_name_it = 'BAHE', shortcut_it = '', value_name_ro = 'BAHE', shortcut_ro = '', value_description_en = 'yyy_Anschluss verstopft', value_description_de = 'Anschluss verstopft', value_description_fr = 'Raccordement obstrué', value_description_it = 'Allacciamento ostruito', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3977);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3978) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAHZ', value_name_en = 'BAHZ', shortcut_en = '', value_name_de = 'BAHZ', shortcut_de = '', value_name_fr = 'BAHZ', shortcut_fr = '', value_name_it = 'BAHZ', shortcut_it = '', value_name_ro = 'BAHZ', shortcut_ro = '', value_description_en = 'yyy_Anschluss andersartig schadhaft', value_description_de = 'Anschluss andersartig schadhaft', value_description_fr = 'Raccordement défectueux', value_description_it = 'Allacciamento danneggiato per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3978);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3979) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAIAA', value_name_en = 'BAIAA', shortcut_en = '', value_name_de = 'BAIAA', shortcut_de = '', value_name_fr = 'BAIAA', shortcut_fr = '', value_name_it = 'BAIAA', shortcut_it = '', value_name_ro = 'BAIAA', shortcut_ro = '', value_description_en = 'yyy_Dichtring verschoben', value_description_de = 'Dichtring verschoben', value_description_fr = 'Joint d’étanchéité déplacé', value_description_it = 'Anello di tenuta spostato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3979);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3980) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAIAB', value_name_en = 'BAIAB', shortcut_en = '', value_name_de = 'BAIAB', shortcut_de = '', value_name_fr = 'BAIAB', shortcut_fr = '', value_name_it = 'BAIAB', shortcut_it = '', value_name_ro = 'BAIAB', shortcut_ro = '', value_description_en = 'yyy_Dichtring einragend, aber nicht gebrochen, tiefster Punkt oberhalb Rohrmitte', value_description_de = 'Dichtring einragend, aber nicht gebrochen, tiefster Punkt oberhalb Rohrmitte ', value_description_fr = 'Joint d’étanchéité saillant, mais non rompu, point le plus bas au-dessus du milieu de la canalisation', value_description_it = 'Anello di tenuta sporgente, ma non rotto, punto più basso sopra il centro del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3980);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3981) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAIAC', value_name_en = 'BAIAC', shortcut_en = '', value_name_de = 'BAIAC', shortcut_de = '', value_name_fr = 'BAIAC', shortcut_fr = '', value_name_it = 'BAIAC', shortcut_it = '', value_name_ro = 'BAIAC', shortcut_ro = '', value_description_en = 'yyy_Dichtring einragend, aber nicht gebrochen, tiefster Punkt unterhalb Rohrmitte', value_description_de = 'Dichtring einragend, aber nicht gebrochen, tiefster Punkt unterhalb Rohrmitte ', value_description_fr = 'Joint d’étanchéité saillant, mais non rompu, point le plus bas au-dessous du milieu de la canalisation', value_description_it = 'Anello di tenuta sporgente, ma non rotto, punto più basso sotto il centro del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3981);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3982) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAIAD', value_name_en = 'BAIAD', shortcut_en = '', value_name_de = 'BAIAD', shortcut_de = '', value_name_fr = 'BAIAD', shortcut_fr = '', value_name_it = 'BAIAD', shortcut_it = '', value_name_ro = 'BAIAD', shortcut_ro = '', value_description_en = 'yyy_Dichtring einragend, gebrochen', value_description_de = 'Dichtring einragend, gebrochen ', value_description_fr = 'Joint d’étanchéité rompu', value_description_it = 'Anello di tenuta rotto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3982);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3983) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAIZ', value_name_en = 'BAIZ', shortcut_en = '', value_name_de = 'BAIZ', shortcut_de = '', value_name_fr = 'BAIZ', shortcut_fr = '', value_name_it = 'BAIZ', shortcut_it = '', value_name_ro = 'BAIZ', shortcut_ro = '', value_description_en = 'yyy_Einragendes Dichtungsmaterial', value_description_de = 'Einragendes Dichtungsmaterial', value_description_fr = 'Joint d’étanchéité apparent', value_description_it = 'Intrusione di materiale sigillante (ulteriori dettagli sono richiesti nell’osserva- zione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3983);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3984) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAJA', value_name_en = 'BAJA', shortcut_en = '', value_name_de = 'BAJA', shortcut_de = '', value_name_fr = 'BAJA', shortcut_fr = '', value_name_it = 'BAJA', shortcut_it = '', value_name_ro = 'BAJA', shortcut_ro = '', value_description_en = 'yyy_Breite Rohrverbindung', value_description_de = 'Breite Rohrverbindung', value_description_fr = 'Assemblage déboîté', value_description_it = 'Spostamento giunto longitudinale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3984);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3985) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAJB', value_name_en = 'BAJB', shortcut_en = '', value_name_de = 'BAJB', shortcut_de = '', value_name_fr = 'BAJB', shortcut_fr = '', value_name_it = 'BAJB', shortcut_it = '', value_name_ro = 'BAJB', shortcut_ro = '', value_description_en = 'yyy_Rohrverbindung versetzt', value_description_de = 'Rohrverbindung versetzt', value_description_fr = 'Assemblage déplacé', value_description_it = 'Spostamento giunto radiale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3985);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3986) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAJC', value_name_en = 'BAJC', shortcut_en = '', value_name_de = 'BAJC', shortcut_de = '', value_name_fr = 'BAJC', shortcut_fr = '', value_name_it = 'BAJC', shortcut_it = '', value_name_ro = 'BAJC', shortcut_ro = '', value_description_en = 'yyy_Rohrverbindung Knick', value_description_de = 'Rohrverbindung Knick', value_description_fr = 'Assemblage dévié', value_description_it = 'Spostamento giunto angolare', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3986);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3987) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKA', value_name_en = 'BAKA', shortcut_en = '', value_name_de = 'BAKA', shortcut_de = '', value_name_fr = 'BAKA', shortcut_fr = '', value_name_it = 'BAKA', shortcut_it = '', value_name_ro = 'BAKA', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung abgelöst', value_description_de = 'Innenauskleidung abgelöst', value_description_fr = 'Revêtement détaché', value_description_it = 'Rivestimento staccato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3987);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3988) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKB', value_name_en = 'BAKB', shortcut_en = '', value_name_de = 'BAKB', shortcut_de = '', value_name_fr = 'BAKB', shortcut_fr = '', value_name_it = 'BAKB', shortcut_it = '', value_name_ro = 'BAKB', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung verfärbt', value_description_de = 'Innenauskleidung verfärbt', value_description_fr = 'Revêtement décoloré', value_description_it = 'Rivestimento scolorito', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3988);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3989) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKC', value_name_en = 'BAKC', shortcut_en = '', value_name_de = 'BAKC', shortcut_de = '', value_name_fr = 'BAKC', shortcut_fr = '', value_name_it = 'BAKC', shortcut_it = '', value_name_ro = 'BAKC', shortcut_ro = '', value_description_en = 'yyy_Endstelle der Innenauskleidung schadhaft', value_description_de = 'Endstelle der Innenauskleidung schadhaft', value_description_fr = 'Extrémité du revêtement défectueuse', value_description_it = 'Estremità del rivestimento difettoso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3989);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3990) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKDA', value_name_en = 'BAKDA', shortcut_en = '', value_name_de = 'BAKDA', shortcut_de = '', value_name_fr = 'BAKDA', shortcut_fr = '', value_name_it = 'BAKDA', shortcut_it = '', value_name_ro = 'BAKDA', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung Faltenbildung, längs', value_description_de = 'Innenauskleidung Faltenbildung, längs', value_description_fr = 'Revêtement ondulé longitudinalement', value_description_it = 'Rivestimento con grinze/pieghe longitudinali', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3990);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3991) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKDB', value_name_en = 'BAKDB', shortcut_en = '', value_name_de = 'BAKDB', shortcut_de = '', value_name_fr = 'BAKDB', shortcut_fr = '', value_name_it = 'BAKDB', shortcut_it = '', value_name_ro = 'BAKDB', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung Faltenbildung, radial', value_description_de = 'Innenauskleidung Faltenbildung, radial', value_description_fr = 'Revêtement ondulé radialement', value_description_it = 'Rivestimento con grinze/pieghe radiali', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3991);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3992) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKDC', value_name_en = 'BAKDC', shortcut_en = '', value_name_de = 'BAKDC', shortcut_de = '', value_name_fr = 'BAKDC', shortcut_fr = '', value_name_it = 'BAKDC', shortcut_it = '', value_name_ro = 'BAKDC', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung Faltenbildung, komplex', value_description_de = 'Innenauskleidung Faltenbildung, komplex ', value_description_fr = 'Revêtement ondulé de façon complexe', value_description_it = 'Rivestimento con grinze/pieghe complesse', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3992);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3993) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKE', value_name_en = 'BAKE', shortcut_en = '', value_name_de = 'BAKE', shortcut_de = '', value_name_fr = 'BAKE', shortcut_fr = '', value_name_it = 'BAKE', shortcut_it = '', value_name_ro = 'BAKE', shortcut_ro = '', value_description_en = 'yyy_Blasen/Beulen in der Innenauskleidung', value_description_de = 'Blasen/Beulen in der Innenauskleidung', value_description_fr = 'Bulles/bosses dans la doublure intérieure', value_description_it = 'Rivestimento con bolle e ammaccature', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3993);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3994) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKZ', value_name_en = 'BAKZ', shortcut_en = '', value_name_de = 'BAKZ', shortcut_de = '', value_name_fr = 'BAKZ', shortcut_fr = '', value_name_it = 'BAKZ', shortcut_it = '', value_name_ro = 'BAKZ', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung andersartig schadhaft', value_description_de = 'Innenauskleidung andersartig schadhaft', value_description_fr = 'Revêtement intérieur défectueux ', value_description_it = 'Rivestimento difettoso per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3994);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3995) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALA', value_name_en = 'BALA', shortcut_en = '', value_name_de = 'BALA', shortcut_de = '', value_name_fr = 'BALA', shortcut_fr = '', value_name_it = 'BALA', shortcut_it = '', value_name_ro = 'BALA', shortcut_ro = '', value_description_en = 'yyy_Reparatur mangelhaft, Wand fehlt teilweise', value_description_de = 'Reparatur mangelhaft, Wand fehlt teilweise', value_description_fr = 'Réparation défectueuse, paroi manquante', value_description_it = 'Riparazione difettosa, parte della parete mancante', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3995);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3996) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALB', value_name_en = 'BALB', shortcut_en = '', value_name_de = 'BALB', shortcut_de = '', value_name_fr = 'BALB', shortcut_fr = '', value_name_it = 'BALB', shortcut_it = '', value_name_ro = 'BALB', shortcut_ro = '', value_description_en = 'yyy_Reparatur Loch mangelhaft', value_description_de = 'Reparatur Loch mangelhaft', value_description_fr = 'Réparation d’un trou défectueuse', value_description_it = 'Rattoppo foro difettoso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3996);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3997) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALZ', value_name_en = 'BALZ', shortcut_en = '', value_name_de = 'BALZ', shortcut_de = '', value_name_fr = 'BALZ', shortcut_fr = '', value_name_it = 'BALZ', shortcut_it = '', value_name_ro = 'BALZ', shortcut_ro = '', value_description_en = 'yyy_Reparatur andersartig mangelhaft', value_description_de = 'Reparatur andersartig mangelhaft', value_description_fr = 'Autre réparation défectueuse', value_description_it = 'Riparazione difettosa per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3997);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3998) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAMA', value_name_en = 'BAMA', shortcut_en = '', value_name_de = 'BAMA', shortcut_de = '', value_name_fr = 'BAMA', shortcut_fr = '', value_name_it = 'BAMA', shortcut_it = '', value_name_ro = 'BAMA', shortcut_ro = '', value_description_en = 'yyy_Schweissnaht in Längsrichtung mangelhaft ', value_description_de = 'Schweissnaht in Längsrichtung mangelhaft ', value_description_fr = 'Défaut de soudage vertical', value_description_it = 'Saldatura longitudinale difettosa', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3998);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,3999) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAMB', value_name_en = 'BAMB', shortcut_en = '', value_name_de = 'BAMB', shortcut_de = '', value_name_fr = 'BAMB', shortcut_fr = '', value_name_it = 'BAMB', shortcut_it = '', value_name_ro = 'BAMB', shortcut_ro = '', value_description_en = 'yyy_Schweissnaht radial mangelhaft ', value_description_de = 'Schweissnaht radial mangelhaft ', value_description_fr = 'Défaut de soudage radial', value_description_it = 'Saldatura radiale difettosa', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 3999);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4000) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAMC', value_name_en = 'BAMC', shortcut_en = '', value_name_de = 'BAMC', shortcut_de = '', value_name_fr = 'BAMC', shortcut_fr = '', value_name_it = 'BAMC', shortcut_it = '', value_name_ro = 'BAMC', shortcut_ro = '', value_description_en = 'yyy_Schweissnaht mit spiralförmigem Verlauf mangelhaft ', value_description_de = 'Schweissnaht mit spiralförmigem Verlauf mangelhaft ', value_description_fr = 'Défaut de soudage hélicoïdal', value_description_it = 'Saldatura elicoidale difettosa', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4000);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4001) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAN', value_name_en = 'BAN', shortcut_en = '', value_name_de = 'BAN', shortcut_de = '', value_name_fr = 'BAN', shortcut_fr = '', value_name_it = 'BAN', shortcut_it = '', value_name_ro = 'BAN', shortcut_ro = '', value_description_en = 'yyy_Leitung porös', value_description_de = 'Leitung porös', value_description_fr = 'Conduite poreuse', value_description_it = 'Condotta porosa', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4001);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4002) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAO', value_name_en = 'BAO', shortcut_en = '', value_name_de = 'BAO', shortcut_de = '', value_name_fr = 'BAO', shortcut_fr = '', value_name_it = 'BAO', shortcut_it = '', value_name_ro = 'BAO', shortcut_ro = '', value_description_en = 'yyy_anstehender Boden sichtbar', value_description_de = 'anstehender Boden sichtbar ', value_description_fr = 'Sol visible', value_description_it = 'Suolo visibile', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4002);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4003) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAP', value_name_en = 'BAP', shortcut_en = '', value_name_de = 'BAP', shortcut_de = '', value_name_fr = 'BAP', shortcut_fr = '', value_name_it = 'BAP', shortcut_it = '', value_name_ro = 'BAP', shortcut_ro = '', value_description_en = 'yyy_Hohlraum sichtbar', value_description_de = 'Hohlraum sichtbar ', value_description_fr = 'Vide visible', value_description_it = 'Cavità visibile', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4003);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4004) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBAA', value_name_en = 'BBAA', shortcut_en = '', value_name_de = 'BBAA', shortcut_de = '', value_name_fr = 'BBAA', shortcut_fr = '', value_name_it = 'BBAA', shortcut_it = '', value_name_ro = 'BBAA', shortcut_ro = '', value_description_en = 'yyy_Pfahlwurzel', value_description_de = 'Pfahlwurzel', value_description_fr = 'Grosse racine isolée', value_description_it = 'Tappo di radici', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4004);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4005) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBAB', value_name_en = 'BBAB', shortcut_en = '', value_name_de = 'BBAB', shortcut_de = '', value_name_fr = 'BBAB', shortcut_fr = '', value_name_it = 'BBAB', shortcut_it = '', value_name_ro = 'BBAB', shortcut_ro = '', value_description_en = 'yyy_Einzelner, feiner Wurzeleinwuchs', value_description_de = 'Einzelner, feiner Wurzeleinwuchs', value_description_fr = 'Radicelles', value_description_it = 'Radici sottili singole', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4005);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4006) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBAC', value_name_en = 'BBAC', shortcut_en = '', value_name_de = 'BBAC', shortcut_de = '', value_name_fr = 'BBAC', shortcut_fr = '', value_name_it = 'BBAC', shortcut_it = '', value_name_ro = 'BBAC', shortcut_ro = '', value_description_en = 'yyy_Komplexes Wurzelwerk', value_description_de = 'Komplexes Wurzelwerk', value_description_fr = 'Ensemble complexe de racines', value_description_it = 'Massa complessa di radici', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4006);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4007) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBBA', value_name_en = 'BBBA', shortcut_en = '', value_name_de = 'BBBA', shortcut_de = '', value_name_fr = 'BBBA', shortcut_fr = '', value_name_it = 'BBBA', shortcut_it = '', value_name_ro = 'BBBA', shortcut_ro = '', value_description_en = 'yyy_Inkrustation (verkalkt)', value_description_de = 'Inkrustation (verkalkt)', value_description_fr = 'Concrétions (calcifié)', value_description_it = 'Incrostazioni (calcificazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4007);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4008) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBBB', value_name_en = 'BBBB', shortcut_en = '', value_name_de = 'BBBB', shortcut_de = '', value_name_fr = 'BBBB', shortcut_fr = '', value_name_it = 'BBBB', shortcut_it = '', value_name_ro = 'BBBB', shortcut_ro = '', value_description_en = 'yyy_Fett', value_description_de = 'Fett', value_description_fr = 'Graisse', value_description_it = 'Grasso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4008);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4009) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBBC', value_name_en = 'BBBC', shortcut_en = '', value_name_de = 'BBBC', shortcut_de = '', value_name_fr = 'BBBC', shortcut_fr = '', value_name_it = 'BBBC', shortcut_it = '', value_name_ro = 'BBBC', shortcut_ro = '', value_description_en = 'yyy_Fäulnis', value_description_de = 'Fäulnis', value_description_fr = 'Encrassement', value_description_it = 'Incrostazioni organiche', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4009);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4010) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBBZ', value_name_en = 'BBBZ', shortcut_en = '', value_name_de = 'BBBZ', shortcut_de = '', value_name_fr = 'BBBZ', shortcut_fr = '', value_name_it = 'BBBZ', shortcut_it = '', value_name_ro = 'BBBZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige anhaftende Stoffe', value_description_de = 'Andersartige anhaftende Stoffe', value_description_fr = 'Autres substances adhérentes', value_description_it = 'Altri depositi attaccati (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4010);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4011) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBCA', value_name_en = 'BBCA', shortcut_en = '', value_name_de = 'BBCA', shortcut_de = '', value_name_fr = 'BBCA', shortcut_fr = '', value_name_it = 'BBCA', shortcut_it = '', value_name_ro = 'BBCA', shortcut_ro = '', value_description_en = 'yyy_Lose Ablagerungen, Sand', value_description_de = 'Lose Ablagerungen, Sand', value_description_fr = 'Dépôts lâches, sable', value_description_it = 'Depositi sciolte, sabbia', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4011);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4012) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBCB', value_name_en = 'BBCB', shortcut_en = '', value_name_de = 'BBCB', shortcut_de = '', value_name_fr = 'BBCB', shortcut_fr = '', value_name_it = 'BBCB', shortcut_it = '', value_name_ro = 'BBCB', shortcut_ro = '', value_description_en = 'yyy_Lose Ablagerungen, Kies', value_description_de = 'Lose Ablagerungen, Kies', value_description_fr = 'Dépôts lâches, gravier', value_description_it = 'Depositi sciolte, ghiaia', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4012);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4013) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBCC', value_name_en = 'BBCC', shortcut_en = '', value_name_de = 'BBCC', shortcut_de = '', value_name_fr = 'BBCC', shortcut_fr = '', value_name_it = 'BBCC', shortcut_it = '', value_name_ro = 'BBCC', shortcut_ro = '', value_description_en = 'yyy_Harte Ablagerungen', value_description_de = 'Harte Ablagerungen', value_description_fr = 'Dépôts durs', value_description_it = 'Depositi duri', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4013);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4014) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBCZ', value_name_en = 'BBCZ', shortcut_en = '', value_name_de = 'BBCZ', shortcut_de = '', value_name_fr = 'BBCZ', shortcut_fr = '', value_name_it = 'BBCZ', shortcut_it = '', value_name_ro = 'BBCZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige Ablagerungen', value_description_de = 'Andersartige Ablagerungen', value_description_fr = 'Autres dépôts ', value_description_it = 'Altri tipi di depositi (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4014);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4015) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBDA', value_name_en = 'BBDA', shortcut_en = '', value_name_de = 'BBDA', shortcut_de = '', value_name_fr = 'BBDA', shortcut_fr = '', value_name_it = 'BBDA', shortcut_it = '', value_name_ro = 'BBDA', shortcut_ro = '', value_description_en = 'yyy_Sand dringt ein', value_description_de = 'Sand dringt ein', value_description_fr = 'Entrée de sable', value_description_it = 'Penetrazione di sabbia', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4015);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4016) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBDB', value_name_en = 'BBDB', shortcut_en = '', value_name_de = 'BBDB', shortcut_de = '', value_name_fr = 'BBDB', shortcut_fr = '', value_name_it = 'BBDB', shortcut_it = '', value_name_ro = 'BBDB', shortcut_ro = '', value_description_en = 'yyy_organischen Bodenmaterial dringt ein', value_description_de = 'organischen Bodenmaterial dringt ein', value_description_fr = 'Entrée d’humus', value_description_it = 'Penetrazione di humus/torba', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4016);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4017) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBDC', value_name_en = 'BBDC', shortcut_en = '', value_name_de = 'BBDC', shortcut_de = '', value_name_fr = 'BBDC', shortcut_fr = '', value_name_it = 'BBDC', shortcut_it = '', value_name_ro = 'BBDC', shortcut_ro = '', value_description_en = 'yyy_Feinmaterial dringt ein', value_description_de = 'Feinmaterial dringt ein', value_description_fr = 'Entrée de matériau fin', value_description_it = 'Penetrazione di materiale fine', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4017);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4018) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBDD', value_name_en = 'BBDD', shortcut_en = '', value_name_de = 'BBDD', shortcut_de = '', value_name_fr = 'BBDD', shortcut_fr = '', value_name_it = 'BBDD', shortcut_it = '', value_name_ro = 'BBDD', shortcut_ro = '', value_description_en = 'yyy_Grobmaterial dringt ein', value_description_de = 'Grobmaterial dringt ein', value_description_fr = 'Entrée de gravier', value_description_it = 'Penetrazione di materiale grossolano', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4018);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4019) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBDZ', value_name_en = 'BBDZ', shortcut_en = '', value_name_de = 'BBDZ', shortcut_de = '', value_name_fr = 'BBDZ', shortcut_fr = '', value_name_it = 'BBDZ', shortcut_it = '', value_name_ro = 'BBDZ', shortcut_ro = '', value_description_en = 'yyy_Bodenmaterial dringt ein', value_description_de = 'Bodenmaterial dringt ein', value_description_fr = 'Entrée de terre', value_description_it = 'Penetrazione di materiale (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4019);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4020) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEA', value_name_en = 'BBEA', shortcut_en = '', value_name_de = 'BBEA', shortcut_de = '', value_name_fr = 'BBEA', shortcut_fr = '', value_name_it = 'BBEA', shortcut_it = '', value_name_ro = 'BBEA', shortcut_ro = '', value_description_en = 'yyy_Hindernis: Mauer- oder Backstein liegt in der Rohrsohle', value_description_de = 'Hindernis: Mauer- oder Backstein liegt in der Rohrsohle', value_description_fr = 'Obstacle: briquetage ou élément de maçonnerie tombé', value_description_it = 'Ostacolo: mattoni o pezzi di muratura giacente sul fondo del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4020);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4021) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEB', value_name_en = 'BBEB', shortcut_en = '', value_name_de = 'BBEB', shortcut_de = '', value_name_fr = 'BBEB', shortcut_fr = '', value_name_it = 'BBEB', shortcut_it = '', value_name_ro = 'BBEB', shortcut_ro = '', value_description_en = 'yyy_Hindernis: Leitungsstück liegt in der Rohrsohle', value_description_de = 'Hindernis: Leitungsstück liegt in der Rohrsohle', value_description_fr = 'Obstacle: fragment de canalisation brisé', value_description_it = 'Ostacolo: pezzo di tubo rotto giacente sul fondo del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4021);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4022) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEC', value_name_en = 'BBEC', shortcut_en = '', value_name_de = 'BBEC', shortcut_de = '', value_name_fr = 'BBEC', shortcut_fr = '', value_name_it = 'BBEC', shortcut_it = '', value_name_ro = 'BBEC', shortcut_ro = '', value_description_en = 'yyy_Gegenstand liegt in der Rohrsohle', value_description_de = 'Gegenstand liegt in der Rohrsohle', value_description_fr = 'Objet gisant sur le radier', value_description_it = 'Oggetto giacente sul fondo del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4022);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4023) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBED', value_name_en = 'BBED', shortcut_en = '', value_name_de = 'BBED', shortcut_de = '', value_name_fr = 'BBED', shortcut_fr = '', value_name_it = 'BBED', shortcut_it = '', value_name_ro = 'BBED', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ragt durch die Wand ein', value_description_de = 'Gegenstand ragt durch die Wand ein', value_description_fr = 'Obstacle dépassant de la paroi', value_description_it = 'Oggetto sporgente dalla parete', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4023);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4024) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEE', value_name_en = 'BBEE', shortcut_en = '', value_name_de = 'BBEE', shortcut_de = '', value_name_fr = 'BBEE', shortcut_fr = '', value_name_it = 'BBEE', shortcut_it = '', value_name_ro = 'BBEE', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ist in der Rohrverbindung eingeklemmt', value_description_de = 'Gegenstand ist in der Rohrverbindung eingeklemmt', value_description_fr = 'Obstacle coincé dans l’assemblage', value_description_it = 'Oggetto incuneato nel giunto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4024);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4025) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEF', value_name_en = 'BBEF', shortcut_en = '', value_name_de = 'BBEF', shortcut_de = '', value_name_fr = 'BBEF', shortcut_fr = '', value_name_it = 'BBEF', shortcut_it = '', value_name_ro = 'BBEF', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ragt aus Anschluss in Hauptleitung', value_description_de = 'Gegenstand ragt aus Anschluss in Hauptleitung', value_description_fr = 'Obstacle dépassant de l’assemblage dans la canalisation principale', value_description_it = 'Oggetto sporge dall’allacciamento in condotta principale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4025);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4026) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEG', value_name_en = 'BBEG', shortcut_en = '', value_name_de = 'BBEG', shortcut_de = '', value_name_fr = 'BBEG', shortcut_fr = '', value_name_it = 'BBEG', shortcut_it = '', value_name_ro = 'BBEG', shortcut_ro = '', value_description_en = 'yyy_Fremde Werkleitungen oder Kabel durchqueren die Leitung', value_description_de = 'Fremde Werkleitungen oder Kabel durchqueren die Leitung', value_description_fr = 'Conduites externes ou câbles traversant la canalisation', value_description_it = 'Condotte sotterranee o cavi attraversano la tubazione', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4026);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4027) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEH', value_name_en = 'BBEH', shortcut_en = '', value_name_de = 'BBEH', shortcut_de = '', value_name_fr = 'BBEH', shortcut_fr = '', value_name_it = 'BBEH', shortcut_it = '', value_name_ro = 'BBEH', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ist in den Rohrkörper eingebaut', value_description_de = 'Gegenstand ist in den Rohrkörper eingebaut', value_description_fr = 'Obstacle intégré à la structure', value_description_it = 'Oggetto inglobato nella struttura del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4027);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4028) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBEZ', value_name_en = 'BBEZ', shortcut_en = '', value_name_de = 'BBEZ', shortcut_de = '', value_name_fr = 'BBEZ', shortcut_fr = '', value_name_it = 'BBEZ', shortcut_it = '', value_name_ro = 'BBEZ', shortcut_ro = '', value_description_en = 'yyy_Andersartiges Hindernis', value_description_de = 'Andersartiges Hindernis', value_description_fr = 'Obstacle', value_description_it = 'Altri ostacoli (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4028);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4029) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBFA', value_name_en = 'BBFA', shortcut_en = '', value_name_de = 'BBFA', shortcut_de = '', value_name_fr = 'BBFA', shortcut_fr = '', value_name_it = 'BBFA', shortcut_it = '', value_name_ro = 'BBFA', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Schwitzen / Verkalkung', value_description_de = 'Infiltration: Schwitzen / Verkalkung', value_description_fr = 'Infiltration: suintement / entartrage', value_description_it = 'Infiltrazioni: trasudamento/calcificazione', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4029);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4030) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBFB', value_name_en = 'BBFB', shortcut_en = '', value_name_de = 'BBFB', shortcut_de = '', value_name_fr = 'BBFB', shortcut_fr = '', value_name_it = 'BBFB', shortcut_it = '', value_name_ro = 'BBFB', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser tropft', value_description_de = 'Infiltration: Wasser tropft', value_description_fr = 'Infiltration: goutte à goutte', value_description_it = 'Infiltrazioni: gocciolamento', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4030);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4031) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBFC', value_name_en = 'BBFC', shortcut_en = '', value_name_de = 'BBFC', shortcut_de = '', value_name_fr = 'BBFC', shortcut_fr = '', value_name_it = 'BBFC', shortcut_it = '', value_name_ro = 'BBFC', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser fliesst', value_description_de = 'Infiltration: Wasser fliesst', value_description_fr = 'Infiltration: écoulement', value_description_it = 'Infiltrazioni: scorrimento', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4031);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4032) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBFD', value_name_en = 'BBFD', shortcut_en = '', value_name_de = 'BBFD', shortcut_de = '', value_name_fr = 'BBFD', shortcut_fr = '', value_name_it = 'BBFD', shortcut_it = '', value_name_ro = 'BBFD', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser spritzt', value_description_de = 'Infiltration: Wasser spritzt', value_description_fr = 'Infiltration: jaillissement', value_description_it = 'Infiltrazioni: zampillio', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4032);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4033) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBG', value_name_en = 'BBG', shortcut_en = '', value_name_de = 'BBG', shortcut_de = '', value_name_fr = 'BBG', shortcut_fr = '', value_name_it = 'BBG', shortcut_it = '', value_name_ro = 'BBG', shortcut_ro = '', value_description_en = 'yyy_Sichtbarer Wasseraustritt', value_description_de = 'Sichtbarer Wasseraustritt', value_description_fr = 'Fuite visible de la canalisation', value_description_it = 'Fuoriuscita visibile dalla tubazione', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4033);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4034) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHAA', value_name_en = 'BBHAA', shortcut_en = '', value_name_de = 'BBHAA', shortcut_de = '', value_name_fr = 'BBHAA', shortcut_fr = '', value_name_it = 'BBHAA', shortcut_it = '', value_name_ro = 'BBHAA', shortcut_ro = '', value_description_en = 'yyy_Ratte in der Rohrleitung', value_description_de = 'Ratte in der Rohrleitung', value_description_fr = 'Rats dans la canalisation', value_description_it = 'Ratti nella condotta', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4034);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4035) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHAB', value_name_en = 'BBHAB', shortcut_en = '', value_name_de = 'BBHAB', shortcut_de = '', value_name_fr = 'BBHAB', shortcut_fr = '', value_name_it = 'BBHAB', shortcut_it = '', value_name_ro = 'BBHAB', shortcut_ro = '', value_description_en = 'yyy_Ratte im Anschluss', value_description_de = 'Ratte im Anschluss', value_description_fr = 'Rats dans le raccordement', value_description_it = 'Ratti in un allacciamento', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4035);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4036) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHAC', value_name_en = 'BBHAC', shortcut_en = '', value_name_de = 'BBHAC', shortcut_de = '', value_name_fr = 'BBHAC', shortcut_fr = '', value_name_it = 'BBHAC', shortcut_it = '', value_name_ro = 'BBHAC', shortcut_ro = '', value_description_en = 'yyy_Ratte in der offenen Rohrverbindung', value_description_de = 'Ratte in der offenen Rohrverbindung', value_description_fr = 'Rats dans l’assemblage ouvert', value_description_it = 'Ratti in un giunto aperto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4036);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4037) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHAZ', value_name_en = 'BBHAZ', shortcut_en = '', value_name_de = 'BBHAZ', shortcut_de = '', value_name_fr = 'BBHAZ', shortcut_fr = '', value_name_it = 'BBHAZ', shortcut_it = '', value_name_ro = 'BBHAZ', shortcut_ro = '', value_description_en = 'yyy_Ratte', value_description_de = 'Ratte', value_description_fr = 'Rats', value_description_it = 'Ratti in genere (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4037);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4038) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHBA', value_name_en = 'BBHBA', shortcut_en = '', value_name_de = 'BBHBA', shortcut_de = '', value_name_fr = 'BBHBA', shortcut_fr = '', value_name_it = 'BBHBA', shortcut_it = '', value_name_ro = 'BBHBA', shortcut_ro = '', value_description_en = 'yyy_Kakerlake in der Rohrleitung', value_description_de = 'Kakerlake in der Rohrleitung', value_description_fr = 'Cafards dans la canalisation', value_description_it = 'Scarafaggi nella tubazione', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4038);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4039) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHBB', value_name_en = 'BBHBB', shortcut_en = '', value_name_de = 'BBHBB', shortcut_de = '', value_name_fr = 'BBHBB', shortcut_fr = '', value_name_it = 'BBHBB', shortcut_it = '', value_name_ro = 'BBHBB', shortcut_ro = '', value_description_en = 'yyy_Kakerlake im Anschluss', value_description_de = 'Kakerlake im Anschluss', value_description_fr = 'Cafards dans le raccordement', value_description_it = 'Scarafaggi in un allacciamento', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4039);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4040) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHBC', value_name_en = 'BBHBC', shortcut_en = '', value_name_de = 'BBHBC', shortcut_de = '', value_name_fr = 'BBHBC', shortcut_fr = '', value_name_it = 'BBHBC', shortcut_it = '', value_name_ro = 'BBHBC', shortcut_ro = '', value_description_en = 'yyy_Kakerlake in der offenen Rohrverbindung', value_description_de = 'Kakerlake in der offenen Rohrverbindung', value_description_fr = 'Cafards dans l’assemblage ouvert', value_description_it = 'Scarafaggi in un giunto aperto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4040);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4041) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHBZ', value_name_en = 'BBHBZ', shortcut_en = '', value_name_de = 'BBHBZ', shortcut_de = '', value_name_fr = 'BBHBZ', shortcut_fr = '', value_name_it = 'BBHBZ', shortcut_it = '', value_name_ro = 'BBHBZ', shortcut_ro = '', value_description_en = 'yyy_Kakerlake', value_description_de = 'Kakerlake', value_description_fr = 'Cafards', value_description_it = 'Scarafaggi in genere (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4041);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4042) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHZA', value_name_en = 'BBHZA', shortcut_en = '', value_name_de = 'BBHZA', shortcut_de = '', value_name_fr = 'BBHZA', shortcut_fr = '', value_name_it = 'BBHZA', shortcut_it = '', value_name_ro = 'BBHZA', shortcut_ro = '', value_description_en = 'yyy_Tier in der Rohrleitung', value_description_de = 'Tier in der Rohrleitung', value_description_fr = 'Animaux dans la canalisation', value_description_it = 'Animali nella tubazione (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4042);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4043) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHZB', value_name_en = 'BBHZB', shortcut_en = '', value_name_de = 'BBHZB', shortcut_de = '', value_name_fr = 'BBHZB', shortcut_fr = '', value_name_it = 'BBHZB', shortcut_it = '', value_name_ro = 'BBHZB', shortcut_ro = '', value_description_en = 'yyy_Tier im Anschluss', value_description_de = 'Tier im Anschluss', value_description_fr = 'Animaux dans le raccordement', value_description_it = 'Animal in un allacciamento (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4043);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4044) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHZC', value_name_en = 'BBHZC', shortcut_en = '', value_name_de = 'BBHZC', shortcut_de = '', value_name_fr = 'BBHZC', shortcut_fr = '', value_name_it = 'BBHZC', shortcut_it = '', value_name_ro = 'BBHZC', shortcut_ro = '', value_description_en = 'yyy_Tier in der offenen Rohrverbindung', value_description_de = 'Tier in der offenen Rohrverbindung', value_description_fr = 'Animaux dans l’assemblage ouvert', value_description_it = 'Animali in un giunto aperto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4044);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4045) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BBHZZ', value_name_en = 'BBHZZ', shortcut_en = '', value_name_de = 'BBHZZ', shortcut_de = '', value_name_fr = 'BBHZZ', shortcut_fr = '', value_name_it = 'BBHZZ', shortcut_it = '', value_name_ro = 'BBHZZ', shortcut_ro = '', value_description_en = 'yyy_Tier', value_description_de = 'Tier', value_description_fr = 'Animaux', value_description_it = 'Animali in genere (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4045);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4046) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAAA', value_name_en = 'BCAAA', shortcut_en = '', value_name_de = 'BCAAA', shortcut_de = '', value_name_fr = 'BCAAA', shortcut_fr = '', value_name_it = 'BCAAA', shortcut_it = '', value_name_ro = 'BCAAA', shortcut_ro = '', value_description_en = 'yyy_Anschluss mit Formstück', value_description_de = 'Anschluss mit Formstück', value_description_fr = 'Raccordement avec pièce préfabriquée', value_description_it = 'Allacciamento con pezzo prefabbricato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4046);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4047) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAAB', value_name_en = 'BCAAB', shortcut_en = '', value_name_de = 'BCAAB', shortcut_de = '', value_name_fr = 'BCAAB', shortcut_fr = '', value_name_it = 'BCAAB', shortcut_it = '', value_name_ro = 'BCAAB', shortcut_ro = '', value_description_en = 'yyy_Anschluss mit Formstück verschlossen', value_description_de = 'Anschluss mit Formstück verschlossen', value_description_fr = 'Raccordement avec pièce préfabriquée fermée', value_description_it = 'Allacciamento con pezzo prefabbricato occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4047);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4048) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCABA', value_name_en = 'BCABA', shortcut_en = '', value_name_de = 'BCABA', shortcut_de = '', value_name_fr = 'BCABA', shortcut_fr = '', value_name_it = 'BCABA', shortcut_it = '', value_name_ro = 'BCABA', shortcut_ro = '', value_description_en = 'yyy_Sattelanschluss gebohrt', value_description_de = 'Sattelanschluss gebohrt ', value_description_fr = 'Piquage latéral carotté', value_description_it = 'Allacciamento a sella forato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4048);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4049) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCABB', value_name_en = 'BCABB', shortcut_en = '', value_name_de = 'BCABB', shortcut_de = '', value_name_fr = 'BCABB', shortcut_fr = '', value_name_it = 'BCABB', shortcut_it = '', value_name_ro = 'BCABB', shortcut_ro = '', value_description_en = 'yyy_Sattelanschluss gebohrt verschlossen', value_description_de = 'Sattelanschluss gebohrt verschlossen', value_description_fr = 'Piquage latéral carotté fermé', value_description_it = 'Allacciamento a sella forato occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4049);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4050) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCACA', value_name_en = 'BCACA', shortcut_en = '', value_name_de = 'BCACA', shortcut_de = '', value_name_fr = 'BCACA', shortcut_fr = '', value_name_it = 'BCACA', shortcut_it = '', value_name_ro = 'BCACA', shortcut_ro = '', value_description_en = 'yyy_Sattelanschluss eingespitzt', value_description_de = 'Sattelanschluss eingespitzt ', value_description_fr = 'Piquage latéral buriné', value_description_it = 'Allacciamento a sella aperto con punta e martello', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4050);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4051) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCACB', value_name_en = 'BCACB', shortcut_en = '', value_name_de = 'BCACB', shortcut_de = '', value_name_fr = 'BCACB', shortcut_fr = '', value_name_it = 'BCACB', shortcut_it = '', value_name_ro = 'BCACB', shortcut_ro = '', value_description_en = 'yyy_Sattelanschluss eingespitzt verschlossen', value_description_de = 'Sattelanschluss eingespitzt verschlossen', value_description_fr = 'Piquage latéral buriné fermé', value_description_it = 'Allacciamento a sella aperto con punta e martello occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4051);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4052) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCADA', value_name_en = 'BCADA', shortcut_en = '', value_name_de = 'BCADA', shortcut_de = '', value_name_fr = 'BCADA', shortcut_fr = '', value_name_it = 'BCADA', shortcut_it = '', value_name_ro = 'BCADA', shortcut_ro = '', value_description_en = 'yyy_Anschluss gebohrt ', value_description_de = 'Anschluss gebohrt ', value_description_fr = 'Raccordement carotté', value_description_it = 'Allacciamento forato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4052);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4053) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCADB', value_name_en = 'BCADB', shortcut_en = '', value_name_de = 'BCADB', shortcut_de = '', value_name_fr = 'BCADB', shortcut_fr = '', value_name_it = 'BCADB', shortcut_it = '', value_name_ro = 'BCADB', shortcut_ro = '', value_description_en = 'yyy_Anschluss gebohrt verschlossen', value_description_de = 'Anschluss gebohrt verschlossen', value_description_fr = 'Raccordement carotté fermé', value_description_it = 'Allacciamento forato occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4053);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4054) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAEA', value_name_en = 'BCAEA', shortcut_en = '', value_name_de = 'BCAEA', shortcut_de = '', value_name_fr = 'BCAEA', shortcut_fr = '', value_name_it = 'BCAEA', shortcut_it = '', value_name_ro = 'BCAEA', shortcut_ro = '', value_description_en = 'yyy_Anschluss eingespitzt ', value_description_de = 'Anschluss eingespitzt ', value_description_fr = 'Raccordement buriné', value_description_it = 'Allacciamento aperto con punta e martello', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4054);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4055) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAEB', value_name_en = 'BCAEB', shortcut_en = '', value_name_de = 'BCAEB', shortcut_de = '', value_name_fr = 'BCAEB', shortcut_fr = '', value_name_it = 'BCAEB', shortcut_it = '', value_name_ro = 'BCAEB', shortcut_ro = '', value_description_en = 'yyy_Anschluss eingespitzt verschlossen', value_description_de = 'Anschluss eingespitzt verschlossen', value_description_fr = 'Raccordement buriné fermé', value_description_it = 'Allacciamento aperto con punta e martello occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4055);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4056) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAFA', value_name_en = 'BCAFA', shortcut_en = '', value_name_de = 'BCAFA', shortcut_de = '', value_name_fr = 'BCAFA', shortcut_fr = '', value_name_it = 'BCAFA', shortcut_it = '', value_name_ro = 'BCAFA', shortcut_ro = '', value_description_en = 'yyy_Spezialanschluss ', value_description_de = 'Spezialanschluss ', value_description_fr = 'Raccord spécial', value_description_it = 'Allacciamento speciale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4056);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4057) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAFB', value_name_en = 'BCAFB', shortcut_en = '', value_name_de = 'BCAFB', shortcut_de = '', value_name_fr = 'BCAFB', shortcut_fr = '', value_name_it = 'BCAFB', shortcut_it = '', value_name_ro = 'BCAFB', shortcut_ro = '', value_description_en = 'yyy_Spezialanschluss verschlossen', value_description_de = 'Spezialanschluss verschlossen', value_description_fr = 'Raccord spécial fermé', value_description_it = 'Allacciamento speciale occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4057);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4058) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAGA', value_name_en = 'BCAGA', shortcut_en = '', value_name_de = 'BCAGA', shortcut_de = '', value_name_fr = 'BCAGA', shortcut_fr = '', value_name_it = 'BCAGA', shortcut_it = '', value_name_ro = 'BCAGA', shortcut_ro = '', value_description_en = 'yyy_Anschluss unbekannter Bauart', value_description_de = 'Anschluss unbekannter Bauart ', value_description_fr = 'Type de raccord inconnu', value_description_it = 'Allacciamento del tipo sconosciuto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4058);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4059) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAGB', value_name_en = 'BCAGB', shortcut_en = '', value_name_de = 'BCAGB', shortcut_de = '', value_name_fr = 'BCAGB', shortcut_fr = '', value_name_it = 'BCAGB', shortcut_it = '', value_name_ro = 'BCAGB', shortcut_ro = '', value_description_en = 'yyy_Anschluss unbekannter Bauart verschlossen', value_description_de = 'Anschluss unbekannter Bauart verschlossen', value_description_fr = 'Type de raccord inconnu fermé', value_description_it = 'Allacciamento del tipo sconosciuto occluso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4059);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4060) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAZA', value_name_en = 'BCAZA', shortcut_en = '', value_name_de = 'BCAZA', shortcut_de = '', value_name_fr = 'BCAZA', shortcut_fr = '', value_name_it = 'BCAZA', shortcut_it = '', value_name_ro = 'BCAZA', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Anschluss', value_description_de = 'Andersartiger Anschluss ', value_description_fr = 'Raccordement autre', value_description_it = 'Altro tipo di allacciamento (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4060);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4061) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCAZB', value_name_en = 'BCAZB', shortcut_en = '', value_name_de = 'BCAZB', shortcut_de = '', value_name_fr = 'BCAZB', shortcut_fr = '', value_name_it = 'BCAZB', shortcut_it = '', value_name_ro = 'BCAZB', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Anschluss verschlossen', value_description_de = 'Andersartiger Anschluss verschlossen', value_description_fr = 'Raccordement autre fermé', value_description_it = 'Altro tipo di allacciamento occluso (ulteriori dettagli sono richiesti nell’osserva- zione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4061);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4062) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBA', value_name_en = 'BCBA', shortcut_en = '', value_name_de = 'BCBA', shortcut_de = '', value_name_fr = 'BCBA', shortcut_fr = '', value_name_it = 'BCBA', shortcut_it = '', value_name_ro = 'BCBA', shortcut_ro = '', value_description_en = 'yyy_Reparatur, Rohr ausgetauscht', value_description_de = 'Reparatur, Rohr ausgetauscht', value_description_fr = 'Réparation, remplacement de la canalisation', value_description_it = 'Riparazione, sostituzione del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4062);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4063) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBB', value_name_en = 'BCBB', shortcut_en = '', value_name_de = 'BCBB', shortcut_de = '', value_name_fr = 'BCBB', shortcut_fr = '', value_name_it = 'BCBB', shortcut_it = '', value_name_ro = 'BCBB', shortcut_ro = '', value_description_en = 'yyy_Reparatur, örtlich begrenzte Innenauskleidung des Rohres', value_description_de = 'Reparatur, örtlich begrenzte Innenauskleidung des Rohres', value_description_fr = 'Réparation, revêtement intérieur localisé', value_description_it = 'Riparazione, rivestimento puntuale del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4063);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4064) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBC', value_name_en = 'BCBC', shortcut_en = '', value_name_de = 'BCBC', shortcut_de = '', value_name_fr = 'BCBC', shortcut_fr = '', value_name_it = 'BCBC', shortcut_it = '', value_name_ro = 'BCBC', shortcut_ro = '', value_description_en = 'yyy_Reparatur,  Mörtelinjizierung', value_description_de = 'Reparatur,  Mörtelinjizierung', value_description_fr = 'Réparation, injection de mortier', value_description_it = 'Riparazione, iniezione di malta', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4064);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4065) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBD', value_name_en = 'BCBD', shortcut_en = '', value_name_de = 'BCBD', shortcut_de = '', value_name_fr = 'BCBD', shortcut_fr = '', value_name_it = 'BCBD', shortcut_it = '', value_name_ro = 'BCBD', shortcut_ro = '', value_description_en = 'yyy_Reparatur,  Injizierung', value_description_de = 'Reparatur,  Injizierung', value_description_fr = 'Réparation, injection', value_description_it = 'Riparazione, iniezioni di altri materiali di sigillatura', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4065);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4066) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBE', value_name_en = 'BCBE', shortcut_en = '', value_name_de = 'BCBE', shortcut_de = '', value_name_fr = 'BCBE', shortcut_fr = '', value_name_it = 'BCBE', shortcut_it = '', value_name_ro = 'BCBE', shortcut_ro = '', value_description_en = 'yyy_Loch repariert', value_description_de = 'Loch repariert', value_description_fr = 'Trou réparé', value_description_it = 'Foro riparato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4066);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4067) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBZ', value_name_en = 'BCBZ', shortcut_en = '', value_name_de = 'BCBZ', shortcut_de = '', value_name_fr = 'BCBZ', shortcut_fr = '', value_name_it = 'BCBZ', shortcut_it = '', value_name_ro = 'BCBZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige Reparatur mit grabenlosem Verfahren', value_description_de = 'Andersartige Reparatur mit grabenlosem Verfahren', value_description_fr = 'Autre réparation sans tranchée', value_description_it = 'Metodo di riparazione non invasivo dell’allacciamento (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4067);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4068) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCAA', value_name_en = 'BCCAA', shortcut_en = '', value_name_de = 'BCCAA', shortcut_de = '', value_name_fr = 'BCCAA', shortcut_fr = '', value_name_it = 'BCCAA', shortcut_it = '', value_name_ro = 'BCCAA', shortcut_ro = '', value_description_en = 'yyy_Bogen nach links oben', value_description_de = 'Bogen nach links oben', value_description_fr = 'Courbure vers la gauche et vers le haut', value_description_it = 'Curvatura a sinistra verso l’alto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4068);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4069) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCAB', value_name_en = 'BCCAB', shortcut_en = '', value_name_de = 'BCCAB', shortcut_de = '', value_name_fr = 'BCCAB', shortcut_fr = '', value_name_it = 'BCCAB', shortcut_it = '', value_name_ro = 'BCCAB', shortcut_ro = '', value_description_en = 'yyy_Bogen nach links unten ', value_description_de = 'Bogen nach links unten ', value_description_fr = 'Courbure vers la gauche et vers le bas', value_description_it = 'Curvatura a sinistra verso il basso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4069);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4070) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCAY', value_name_en = 'BCCAY', shortcut_en = '', value_name_de = 'BCCAY', shortcut_de = '', value_name_fr = 'BCCAY', shortcut_fr = '', value_name_it = 'BCCAY', shortcut_it = '', value_name_ro = 'BCCAY', shortcut_ro = '', value_description_en = 'yyy_Bogen nach links', value_description_de = 'Bogen nach links', value_description_fr = 'Courbure vers la gauche', value_description_it = 'Curvatura a sinistra', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4070);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4071) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCBA', value_name_en = 'BCCBA', shortcut_en = '', value_name_de = 'BCCBA', shortcut_de = '', value_name_fr = 'BCCBA', shortcut_fr = '', value_name_it = 'BCCBA', shortcut_it = '', value_name_ro = 'BCCBA', shortcut_ro = '', value_description_en = 'yyy_Bogen nach rechts oben', value_description_de = 'Bogen nach rechts oben', value_description_fr = 'Courbure vers la droite et vers le haut', value_description_it = 'Curvatura a destra verso l’alto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4071);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4072) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCBB', value_name_en = 'BCCBB', shortcut_en = '', value_name_de = 'BCCBB', shortcut_de = '', value_name_fr = 'BCCBB', shortcut_fr = '', value_name_it = 'BCCBB', shortcut_it = '', value_name_ro = 'BCCBB', shortcut_ro = '', value_description_en = 'yyy_Bogen nach rechts unten', value_description_de = 'Bogen nach rechts unten', value_description_fr = 'Courbure vers la droite et vers le bas', value_description_it = 'Curvatura a destra verso il basso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4072);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4073) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCBY', value_name_en = 'BCCBY', shortcut_en = '', value_name_de = 'BCCBY', shortcut_de = '', value_name_fr = 'BCCBY', shortcut_fr = '', value_name_it = 'BCCBY', shortcut_it = '', value_name_ro = 'BCCBY', shortcut_ro = '', value_description_en = 'yyy_Bogen nach rechts', value_description_de = 'Bogen nach rechts', value_description_fr = 'Courbure vers la droite', value_description_it = 'Curvatura a destra', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4073);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4074) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCYA', value_name_en = 'BCCYA', shortcut_en = '', value_name_de = 'BCCYA', shortcut_de = '', value_name_fr = 'BCCYA', shortcut_fr = '', value_name_it = 'BCCYA', shortcut_it = '', value_name_ro = 'BCCYA', shortcut_ro = '', value_description_en = 'yyy_Bogen nach oben', value_description_de = 'Bogen nach oben', value_description_fr = 'Courbure vers le haut', value_description_it = 'Curvatura verso l’alto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4074);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4075) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCCYB', value_name_en = 'BCCYB', shortcut_en = '', value_name_de = 'BCCYB', shortcut_de = '', value_name_fr = 'BCCYB', shortcut_fr = '', value_name_it = 'BCCYB', shortcut_it = '', value_name_ro = 'BCCYB', shortcut_ro = '', value_description_en = 'yyy_Bogen nach unten', value_description_de = 'Bogen nach unten', value_description_fr = 'Courbure vers le bas', value_description_it = 'Curvatura verso il basso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4075);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4076) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCD', value_name_en = 'BCD', shortcut_en = '', value_name_de = 'BCD', shortcut_de = '', value_name_fr = 'BCD', shortcut_fr = '', value_name_it = 'BCD', shortcut_it = '', value_name_ro = 'BCD', shortcut_ro = '', value_description_en = 'yyy_Rohranfang', value_description_de = 'Rohranfang', value_description_fr = 'Début de la canalisation', value_description_it = 'Inizio del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4076);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4077) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCE', value_name_en = 'BCE', shortcut_en = '', value_name_de = 'BCE', shortcut_de = '', value_name_fr = 'BCE', shortcut_fr = '', value_name_it = 'BCE', shortcut_it = '', value_name_ro = 'BCE', shortcut_ro = '', value_description_en = 'yyy_Rohrende', value_description_de = 'Rohrende', value_description_fr = 'Fin de la canalisation', value_description_it = 'Fine del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4077);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4078) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDA', value_name_en = 'BDA', shortcut_en = '', value_name_de = 'BDA', shortcut_de = '', value_name_fr = 'BDA', shortcut_fr = '', value_name_it = 'BDA', shortcut_it = '', value_name_ro = 'BDA', shortcut_ro = '', value_description_en = 'yyy_Allgemeinzustand, Fotobeispiel', value_description_de = 'Allgemeinzustand, Fotobeispiel', value_description_fr = 'Etat général, exemple de photo', value_description_it = 'Stato generale, esempio foto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4078);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4079) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDB', value_name_en = 'BDB', shortcut_en = '', value_name_de = 'BDB', shortcut_de = '', value_name_fr = 'BDB', shortcut_fr = '', value_name_it = 'BDB', shortcut_it = '', value_name_ro = 'BDB', shortcut_ro = '', value_description_en = 'yyy_ <kein Text>', value_description_de = '<kein Text>', value_description_fr = '<aucun texte>', value_description_it = '<nessun testo>', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4079);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4084) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDDA', value_name_en = 'BDDA', shortcut_en = '', value_name_de = 'BDDA', shortcut_de = '', value_name_fr = 'BDDA', shortcut_fr = '', value_name_it = 'BDDA', shortcut_it = '', value_name_ro = 'BDDA', shortcut_ro = '', value_description_en = 'yyy_Wasserspiegel, Abwasser klar', value_description_de = 'Wasserspiegel, Abwasser klar', value_description_fr = 'Niveau d’eau, effluent clair', value_description_it = 'Livello dell’acqua, acque reflue chiare', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4084);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4086) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEAA', value_name_en = 'BDEAA', shortcut_en = '', value_name_de = 'BDEAA', shortcut_de = '', value_name_fr = 'BDEAA', shortcut_fr = '', value_name_it = 'BDEAA', shortcut_it = '', value_name_ro = 'BDEAA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasser', value_description_de = 'Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasser', value_description_fr = 'Mauvais raccordement, arrivées d’eaux claires, des eaux usées se déversent dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue limpido, acque reflue entrano in acque meteoriche', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4086);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4087) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEAB', value_name_en = 'BDEAB', shortcut_en = '', value_name_de = 'BDEAB', shortcut_de = '', value_name_fr = 'BDEAB', shortcut_fr = '', value_name_it = 'BDEAB', shortcut_it = '', value_name_ro = 'BDEAB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasser', value_description_de = 'Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasser ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux claires, des eaux pluviales se déversent dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue limpido, acque meteoriche entrano in acque reflue', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4087);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4088) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEAC', value_name_en = 'BDEAC', shortcut_en = '', value_name_de = 'BDEAC', shortcut_de = '', value_name_fr = 'BDEAC', shortcut_fr = '', value_name_it = 'BDEAC', shortcut_it = '', value_name_ro = 'BDEAC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss klar', value_description_de = 'Abwasserzufluss klar', value_description_fr = 'Arrivées d’eaux claires', value_description_it = 'Afflusso acque reflue limpido', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4088);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4092) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEYA', value_name_en = 'BDEYA', shortcut_en = '', value_name_de = 'BDEYA', shortcut_de = '', value_name_fr = 'BDEYA', shortcut_fr = '', value_name_it = 'BDEYA', shortcut_it = '', value_name_ro = 'BDEYA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Schmutzabwasser fliesst in Regenabwasser', value_description_de = 'Fehlanschluss, Schmutzabwasser fliesst in Regenabwasser', value_description_fr = 'Mauvais raccordement, des eaux usées se déversent dans les eaux pluviales', value_description_it = 'Collegamento errato, acque reflue entrano in acque meteoriche', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4092);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4093) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEYB', value_name_en = 'BDEYB', shortcut_en = '', value_name_de = 'BDEYB', shortcut_de = '', value_name_fr = 'BDEYB', shortcut_fr = '', value_name_it = 'BDEYB', shortcut_it = '', value_name_ro = 'BDEYB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Regenabwasser fliesst in Schmutzabwasser', value_description_de = 'Fehlanschluss, Regenabwasser fliesst in Schmutzabwasser', value_description_fr = 'Mauvais raccordement, les eaux de surface se déversent dans les eaux usées', value_description_it = 'Collegamento errato, acque meteoriche entrano in acque reflue', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4093);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4094) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEYY', value_name_en = 'BDEYY', shortcut_en = '', value_name_de = 'BDEYY', shortcut_de = '', value_name_fr = 'BDEYY', shortcut_fr = '', value_name_it = 'BDEYY', shortcut_it = '', value_name_ro = 'BDEYY', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss', value_description_de = 'Abwasserzufluss', value_description_fr = 'Arrivée d’eaux usées', value_description_it = 'Afflusso acque reflue', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4094);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4095) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDFA', value_name_en = 'BDFA', shortcut_en = '', value_name_de = 'BDFA', shortcut_de = '', value_name_fr = 'BDFA', shortcut_fr = '', value_name_it = 'BDFA', shortcut_it = '', value_name_ro = 'BDFA', shortcut_ro = '', value_description_en = 'yyy_Gefährdung vorhanden: Sauerstoffmangel', value_description_de = 'Gefährdung vorhanden: Sauerstoffmangel', value_description_fr = 'Danger existant: manque d’oxygène', value_description_it = 'Atmosfera pericolosa: mancanza di ossigeno', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4095);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4096) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDFB', value_name_en = 'BDFB', shortcut_en = '', value_name_de = 'BDFB', shortcut_de = '', value_name_fr = 'BDFB', shortcut_fr = '', value_name_it = 'BDFB', shortcut_it = '', value_name_ro = 'BDFB', shortcut_ro = '', value_description_en = 'yyy_Gefährdung vorhanden: Schwefelwasserstoff', value_description_de = 'Gefährdung vorhanden: Schwefelwasserstoff', value_description_fr = 'Danger existant: hydrogène sulfuré', value_description_it = 'Atmosfera pericolosa: idrogeno solforato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4096);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4097) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDFC', value_name_en = 'BDFC', shortcut_en = '', value_name_de = 'BDFC', shortcut_de = '', value_name_fr = 'BDFC', shortcut_fr = '', value_name_it = 'BDFC', shortcut_it = '', value_name_ro = 'BDFC', shortcut_ro = '', value_description_en = 'yyy_Gefährdung vorhanden:  Methan', value_description_de = 'Gefährdung vorhanden:  Methan', value_description_fr = 'Danger existant: méthane', value_description_it = 'Atmosfera pericolosa: metano', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4097);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4098) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDFZ', value_name_en = 'BDFZ', shortcut_en = '', value_name_de = 'BDFZ', shortcut_de = '', value_name_fr = 'BDFZ', shortcut_fr = '', value_name_it = 'BDFZ', shortcut_it = '', value_name_ro = 'BDFZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige Gefährdung vorhanden', value_description_de = 'Andersartige Gefährdung vorhanden', value_description_fr = 'Autres Danger existant', value_description_it = 'Altri pericoli (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4098);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4099) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDGA', value_name_en = 'BDGA', shortcut_en = '', value_name_de = 'BDGA', shortcut_de = '', value_name_fr = 'BDGA', shortcut_fr = '', value_name_it = 'BDGA', shortcut_it = '', value_name_ro = 'BDGA', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, Kamera unter Wasser', value_description_de = 'Keine Sicht, Kamera unter Wasser', value_description_fr = 'Visibilité nulle, caméra sous l’eau', value_description_it = 'Nessuna visibilità, telecamera immersa', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4099);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4100) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDGB', value_name_en = 'BDGB', shortcut_en = '', value_name_de = 'BDGB', shortcut_de = '', value_name_fr = 'BDGB', shortcut_fr = '', value_name_it = 'BDGB', shortcut_it = '', value_name_ro = 'BDGB', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, Verschlammung', value_description_de = 'Keine Sicht, Verschlammung', value_description_fr = 'Visibilité nulle, envasement', value_description_it = 'Nessuna visibilità, deposito fangoso', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4100);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4101) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDGC', value_name_en = 'BDGC', shortcut_en = '', value_name_de = 'BDGC', shortcut_de = '', value_name_fr = 'BDGC', shortcut_fr = '', value_name_it = 'BDGC', shortcut_it = '', value_name_ro = 'BDGC', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, Dampf', value_description_de = 'Keine Sicht, Dampf', value_description_fr = 'Visibilité nulle, vapeur', value_description_it = 'Nessuna visibilità, vapore', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4101);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4102) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDGZ', value_name_en = 'BDGZ', shortcut_en = '', value_name_de = 'BDGZ', shortcut_de = '', value_name_fr = 'BDGZ', shortcut_fr = '', value_name_it = 'BDGZ', shortcut_it = '', value_name_ro = 'BDGZ', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, anderer Grund', value_description_de = 'Keine Sicht, anderer Grund', value_description_fr = 'Visibilité nulle, autre raison ', value_description_it = 'Nessuna visibilità, altri motivi (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4102);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4103) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXA', value_name_en = 'AECXA', shortcut_en = '', value_name_de = 'AECXA', shortcut_de = '', value_name_fr = 'AECXA', shortcut_fr = '', value_name_it = 'AECXA', shortcut_it = '', value_name_ro = 'AECXA', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel', value_description_de = 'Rohrprofilwechsel', value_description_fr = 'Modification de la section transversale de la canalisation', value_description_it = 'Modifica del profilo del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4103);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4104) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXB', value_name_en = 'AECXB', shortcut_en = '', value_name_de = 'AECXB', shortcut_de = '', value_name_fr = 'AECXB', shortcut_fr = '', value_name_it = 'AECXB', shortcut_it = '', value_name_ro = 'AECXB', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: Eiprofil', value_description_de = 'Rohrprofilwechsel: Eiprofil', value_description_fr = 'Modification de la section transversale de la canalisation: ovoïde', value_description_it = 'Modifica del profilo del tubo: profilo ovoidale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4104);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4105) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXC', value_name_en = 'AECXC', shortcut_en = '', value_name_de = 'AECXC', shortcut_de = '', value_name_fr = 'AECXC', shortcut_fr = '', value_name_it = 'AECXC', shortcut_it = '', value_name_ro = 'AECXC', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: Kreisprofil', value_description_de = 'Rohrprofilwechsel: Kreisprofil', value_description_fr = 'Modification de la section transversale de la canalisation: circulaire', value_description_it = 'Modifica del profilo del tubo: profilo circolare', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4105);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4106) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXD', value_name_en = 'AECXD', shortcut_en = '', value_name_de = 'AECXD', shortcut_de = '', value_name_fr = 'AECXD', shortcut_fr = '', value_name_it = 'AECXD', shortcut_it = '', value_name_ro = 'AECXD', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: Maulprofil', value_description_de = 'Rohrprofilwechsel: Maulprofil', value_description_fr = 'Modification de la section transversale de la canalisation: fer à cheval', value_description_it = 'Modifica del profilo del tubo: profilo ellittico', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4106);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4107) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXE', value_name_en = 'AECXE', shortcut_en = '', value_name_de = 'AECXE', shortcut_de = '', value_name_fr = 'AECXE', shortcut_fr = '', value_name_it = 'AECXE', shortcut_it = '', value_name_ro = 'AECXE', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: offenes Profil', value_description_de = 'Rohrprofilwechsel: offenes Profil', value_description_fr = 'Modification de la section transversale de la canalisation: profil ouvert', value_description_it = 'Modifica del profilo del tubo: profilo aperto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4107);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4108) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXF', value_name_en = 'AECXF', shortcut_en = '', value_name_de = 'AECXF', shortcut_de = '', value_name_fr = 'AECXF', shortcut_fr = '', value_name_it = 'AECXF', shortcut_it = '', value_name_ro = 'AECXF', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: Rechteckprofil', value_description_de = 'Rohrprofilwechsel: Rechteckprofil', value_description_fr = 'Modification de la section transversale de la canalisation: rectangulaire', value_description_it = 'Modifica del profilo del tubo: profilo rettangolare', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4108);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4109) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXG', value_name_en = 'AECXG', shortcut_en = '', value_name_de = 'AECXG', shortcut_de = '', value_name_fr = 'AECXG', shortcut_fr = '', value_name_it = 'AECXG', shortcut_it = '', value_name_ro = 'AECXG', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: Spezialprofil', value_description_de = 'Rohrprofilwechsel: Spezialprofil', value_description_fr = 'Modification de la section transversale de la canalisation: profil spéciale', value_description_it = 'Modifica del profilo del tubo: profilo speciale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4109);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4110) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AECXH', value_name_en = 'AECXH', shortcut_en = '', value_name_de = 'AECXH', shortcut_de = '', value_name_fr = 'AECXH', shortcut_fr = '', value_name_it = 'AECXH', shortcut_it = '', value_name_ro = 'AECXH', shortcut_ro = '', value_description_en = 'yyy_Rohrprofilwechsel: unbekanntes Profil', value_description_de = 'Rohrprofilwechsel: unbekanntes Profil', value_description_fr = 'Modification de la section transversale de la canalisation: profil inconnue', value_description_it = 'Modifica del profilo del tubo: profilo ignoto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4110);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4111) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXA', value_name_en = 'AEDXA', shortcut_en = '', value_name_de = 'AEDXA', shortcut_de = '', value_name_fr = 'AEDXA', shortcut_fr = '', value_name_it = 'AEDXA', shortcut_it = '', value_name_ro = 'AEDXA', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel', value_description_de = 'Rohrmaterialwechsel', value_description_fr = 'Changement du matériau de la canalisation', value_description_it = 'Cambio materiale del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4111);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4112) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXB', value_name_en = 'AEDXB', shortcut_en = '', value_name_de = 'AEDXB', shortcut_de = '', value_name_fr = 'AEDXB', shortcut_fr = '', value_name_it = 'AEDXB', shortcut_it = '', value_name_ro = 'AEDXB', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Asbestzement', value_description_de = 'Rohrmaterialwechsel: Asbestzement', value_description_fr = 'Changement du matériau de la canalisation: béton amianté', value_description_it = 'Cambio materiale del tubo: cemento amianto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4112);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4113) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXC', value_name_en = 'AEDXC', shortcut_en = '', value_name_de = 'AEDXC', shortcut_de = '', value_name_fr = 'AEDXC', shortcut_fr = '', value_name_it = 'AEDXC', shortcut_it = '', value_name_ro = 'AEDXC', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Normalbeton', value_description_de = 'Rohrmaterialwechsel: Normalbeton', value_description_fr = 'Changement du matériau de la canalisation: béton normal', value_description_it = 'Cambio materiale del tubo: calcestruzzo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4113);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4114) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXD', value_name_en = 'AEDXD', shortcut_en = '', value_name_de = 'AEDXD', shortcut_de = '', value_name_fr = 'AEDXD', shortcut_fr = '', value_name_it = 'AEDXD', shortcut_it = '', value_name_ro = 'AEDXD', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Ortsbeton', value_description_de = 'Rohrmaterialwechsel: Ortsbeton', value_description_fr = 'Changement du matériau de la canalisation: béton local', value_description_it = 'Cambio materiale del tubo: calcestruzzo gettato in opera', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4114);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4115) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXE', value_name_en = 'AEDXE', shortcut_en = '', value_name_de = 'AEDXE', shortcut_de = '', value_name_fr = 'AEDXE', shortcut_fr = '', value_name_it = 'AEDXE', shortcut_it = '', value_name_ro = 'AEDXE', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Pressrohrbeton', value_description_de = 'Rohrmaterialwechsel: Pressrohrbeton', value_description_fr = 'Changement du matériau de la canalisation: béton de tube de fonçage', value_description_it = 'Cambio materiale del tubo: calcestruzzo pressato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4115);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4116) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXF', value_name_en = 'AEDXF', shortcut_en = '', value_name_de = 'AEDXF', shortcut_de = '', value_name_fr = 'AEDXF', shortcut_fr = '', value_name_it = 'AEDXF', shortcut_it = '', value_name_ro = 'AEDXF', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Spezialbeton', value_description_de = 'Rohrmaterialwechsel: Spezialbeton', value_description_fr = 'Changement du matériau de la canalisation: béton spécial', value_description_it = 'Cambio materiale del tubo: calcestruzzo speciale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4116);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4117) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXG', value_name_en = 'AEDXG', shortcut_en = '', value_name_de = 'AEDXG', shortcut_de = '', value_name_fr = 'AEDXG', shortcut_fr = '', value_name_it = 'AEDXG', shortcut_it = '', value_name_ro = 'AEDXG', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Beton', value_description_de = 'Rohrmaterialwechsel: Beton', value_description_fr = 'Changement du matériau de la canalisation: béton', value_description_it = 'Cambio materiale del tubo: calcestruzzo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4117);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4118) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXH', value_name_en = 'AEDXH', shortcut_en = '', value_name_de = 'AEDXH', shortcut_de = '', value_name_fr = 'AEDXH', shortcut_fr = '', value_name_it = 'AEDXH', shortcut_it = '', value_name_ro = 'AEDXH', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Faserzement', value_description_de = 'Rohrmaterialwechsel: Faserzement', value_description_fr = 'Changement du matériau de la canalisation: fibrociment', value_description_it = 'Cambio materiale del tubo: fibrocemento', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4118);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4119) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXI', value_name_en = 'AEDXI', shortcut_en = '', value_name_de = 'AEDXI', shortcut_de = '', value_name_fr = 'AEDXI', shortcut_fr = '', value_name_it = 'AEDXI', shortcut_it = '', value_name_ro = 'AEDXI', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Gebrannte Steine', value_description_de = 'Rohrmaterialwechsel: Gebrannte Steine', value_description_fr = 'Changement du matériau de la canalisation: terre cuite', value_description_it = 'Cambio materiale del tubo: laterizi', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4119);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4120) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXJ', value_name_en = 'AEDXJ', shortcut_en = '', value_name_de = 'AEDXJ', shortcut_de = '', value_name_fr = 'AEDXJ', shortcut_fr = '', value_name_it = 'AEDXJ', shortcut_it = '', value_name_ro = 'AEDXJ', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Duktiler Guss', value_description_de = 'Rohrmaterialwechsel: Duktiler Guss', value_description_fr = 'Changement du matériau de la canalisation: fonte ductile', value_description_it = 'Cambio materiale del tubo: ghisa sferoidale', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4120);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4121) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXK', value_name_en = 'AEDXK', shortcut_en = '', value_name_de = 'AEDXK', shortcut_de = '', value_name_fr = 'AEDXK', shortcut_fr = '', value_name_it = 'AEDXK', shortcut_it = '', value_name_ro = 'AEDXK', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Grauguss', value_description_de = 'Rohrmaterialwechsel: Grauguss', value_description_fr = 'Changement du matériau de la canalisation: fonte grise', value_description_it = 'Cambio materiale del tubo: ghisa grigia', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4121);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4122) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXL', value_name_en = 'AEDXL', shortcut_en = '', value_name_de = 'AEDXL', shortcut_de = '', value_name_fr = 'AEDXL', shortcut_fr = '', value_name_it = 'AEDXL', shortcut_it = '', value_name_ro = 'AEDXL', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Epoxidharz', value_description_de = 'Rohrmaterialwechsel: Epoxidharz', value_description_fr = 'Changement du matériau de la canalisation: résine époxyde', value_description_it = 'Cambio materiale del tubo: resina epossidica', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4122);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4123) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXM', value_name_en = 'AEDXM', shortcut_en = '', value_name_de = 'AEDXM', shortcut_de = '', value_name_fr = 'AEDXM', shortcut_fr = '', value_name_it = 'AEDXM', shortcut_it = '', value_name_ro = 'AEDXM', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Hartpolyethylen', value_description_de = 'Rohrmaterialwechsel: Hartpolyethylen', value_description_fr = 'Changement du matériau de la canalisation: polyéthylène dur', value_description_it = 'Cambio materiale del tubo: polietilene rigido', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4123);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4124) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXN', value_name_en = 'AEDXN', shortcut_en = '', value_name_de = 'AEDXN', shortcut_de = '', value_name_fr = 'AEDXN', shortcut_fr = '', value_name_it = 'AEDXN', shortcut_it = '', value_name_ro = 'AEDXN', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Polyester GUP', value_description_de = 'Rohrmaterialwechsel: Polyester GUP', value_description_fr = 'Changement du matériau de la canalisation: polyester GUP', value_description_it = 'Cambio materiale del tubo: poliestere GUP', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4124);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4125) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXO', value_name_en = 'AEDXO', shortcut_en = '', value_name_de = 'AEDXO', shortcut_de = '', value_name_fr = 'AEDXO', shortcut_fr = '', value_name_it = 'AEDXO', shortcut_it = '', value_name_ro = 'AEDXO', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Polyethylen', value_description_de = 'Rohrmaterialwechsel: Polyethylen', value_description_fr = 'Changement du matériau de la canalisation: polyéthylène', value_description_it = 'Cambio materiale del tubo: polietilene', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4125);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4126) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXP', value_name_en = 'AEDXP', shortcut_en = '', value_name_de = 'AEDXP', shortcut_de = '', value_name_fr = 'AEDXP', shortcut_fr = '', value_name_it = 'AEDXP', shortcut_it = '', value_name_ro = 'AEDXP', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Polypropylen', value_description_de = 'Rohrmaterialwechsel: Polypropylen', value_description_fr = 'Changement du matériau de la canalisation: polypropylène', value_description_it = 'Cambio materiale del tubo: polipropilene', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4126);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4127) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXQ', value_name_en = 'AEDXQ', shortcut_en = '', value_name_de = 'AEDXQ', shortcut_de = '', value_name_fr = 'AEDXQ', shortcut_fr = '', value_name_it = 'AEDXQ', shortcut_it = '', value_name_ro = 'AEDXQ', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Polyvinylchlorid', value_description_de = 'Rohrmaterialwechsel: Polyvinylchlorid', value_description_fr = 'Changement du matériau de la canalisation: chlorure de polyvinyle (PVC)', value_description_it = 'Cambio materiale del tubo: polivinilcloruro', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4127);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4128) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXR', value_name_en = 'AEDXR', shortcut_en = '', value_name_de = 'AEDXR', shortcut_de = '', value_name_fr = 'AEDXR', shortcut_fr = '', value_name_it = 'AEDXR', shortcut_it = '', value_name_ro = 'AEDXR', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Kunststoff unbekannt', value_description_de = 'Rohrmaterialwechsel: Kunststoff unbekannt', value_description_fr = 'Changement du matériau de la canalisation: plastique inconnu', value_description_it = 'Cambio materiale del tubo: materiale sintetico non identificato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4128);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4129) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXS', value_name_en = 'AEDXS', shortcut_en = '', value_name_de = 'AEDXS', shortcut_de = '', value_name_fr = 'AEDXS', shortcut_fr = '', value_name_it = 'AEDXS', shortcut_it = '', value_name_ro = 'AEDXS', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Stahl', value_description_de = 'Rohrmaterialwechsel: Stahl', value_description_fr = 'Changement du matériau de la canalisation: acier', value_description_it = 'Cambio materiale del tubo: acciaio', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4129);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4130) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXT', value_name_en = 'AEDXT', shortcut_en = '', value_name_de = 'AEDXT', shortcut_de = '', value_name_fr = 'AEDXT', shortcut_fr = '', value_name_it = 'AEDXT', shortcut_it = '', value_name_ro = 'AEDXT', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Rostfreier Stahl', value_description_de = 'Rohrmaterialwechsel: Rostfreier Stahl', value_description_fr = 'Changement du matériau de la canalisation: acier inoxydable', value_description_it = 'Cambio materiale del tubo: acciaio inossidabile', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4130);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4131) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXU', value_name_en = 'AEDXU', shortcut_en = '', value_name_de = 'AEDXU', shortcut_de = '', value_name_fr = 'AEDXU', shortcut_fr = '', value_name_it = 'AEDXU', shortcut_it = '', value_name_ro = 'AEDXU', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Steinzeug', value_description_de = 'Rohrmaterialwechsel: Steinzeug', value_description_fr = 'Changement du matériau de la canalisation: grès céramique', value_description_it = 'Cambio materiale del tubo: grès', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4131);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4132) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXV', value_name_en = 'AEDXV', shortcut_en = '', value_name_de = 'AEDXV', shortcut_de = '', value_name_fr = 'AEDXV', shortcut_fr = '', value_name_it = 'AEDXV', shortcut_it = '', value_name_ro = 'AEDXV', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Ton', value_description_de = 'Rohrmaterialwechsel: Ton', value_description_fr = 'Changement du matériau de la canalisation: terre cuite', value_description_it = 'Cambio materiale del tubo: argilla', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4132);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4133) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXW', value_name_en = 'AEDXW', shortcut_en = '', value_name_de = 'AEDXW', shortcut_de = '', value_name_fr = 'AEDXW', shortcut_fr = '', value_name_it = 'AEDXW', shortcut_it = '', value_name_ro = 'AEDXW', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: unbekanntes Material', value_description_de = 'Rohrmaterialwechsel: unbekanntes Material', value_description_fr = 'Changement du matériau de la canalisation: matériau inconnu', value_description_it = 'Cambio materiale del tubo: materiale non identificato', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4133);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4134) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEDXX', value_name_en = 'AEDXX', shortcut_en = '', value_name_de = 'AEDXX', shortcut_de = '', value_name_fr = 'AEDXX', shortcut_fr = '', value_name_it = 'AEDXX', shortcut_it = '', value_name_ro = 'AEDXX', shortcut_ro = '', value_description_en = 'yyy_Rohrmaterialwechsel: Zement', value_description_de = 'Rohrmaterialwechsel: Zement', value_description_fr = 'Changement du matériau de la canalisation: ciment', value_description_it = 'Cambio materiale del tubo: cemento', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4134);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4135) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'AEF', value_name_en = 'AEF', shortcut_en = '', value_name_de = 'AEF', shortcut_de = '', value_name_fr = 'AEF', shortcut_fr = '', value_name_it = 'AEF', shortcut_it = '', value_name_ro = 'AEF', shortcut_ro = '', value_description_en = 'yyy_Neue Baulänge', value_description_de = 'Neue Baulänge', value_description_fr = 'Nouvelle longueur', value_description_it = 'Nuova lunghezza dell’unità del tubo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4135);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4136) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBA', value_name_en = 'BDBA', shortcut_en = '', value_name_de = 'BDBA', shortcut_de = '', value_name_fr = 'BDBA', shortcut_fr = '', value_name_it = 'BDBA', shortcut_it = '', value_name_ro = 'BDBA', shortcut_ro = '', value_description_en = 'yyy_A   Beginn TV-Untersuch (Vorgabe)', value_description_de = 'A   Beginn TV-Untersuch (Vorgabe)', value_description_fr = 'A Début de l’examen avec une caméra (norme)', value_description_it = 'A Inizio videoispezione (anticipo distanza)', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4136);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4137) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBB', value_name_en = 'BDBB', shortcut_en = '', value_name_de = 'BDBB', shortcut_de = '', value_name_fr = 'BDBB', shortcut_fr = '', value_name_it = 'BDBB', shortcut_it = '', value_name_ro = 'BDBB', shortcut_ro = '', value_description_en = 'yyy_B   Inspektion erst nach Reinigung möglich', value_description_de = 'B   Inspektion erst nach Reinigung möglich', value_description_fr = 'B Inspection possible seulement après nettoyage', value_description_it = 'B Ispezione possibile solo dopo pulizia', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4137);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4138) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBC', value_name_en = 'BDBC', shortcut_en = '', value_name_de = 'BDBC', shortcut_de = '', value_name_fr = 'BDBC', shortcut_fr = '', value_name_it = 'BDBC', shortcut_it = '', value_name_ro = 'BDBC', shortcut_ro = '', value_description_en = 'yyy_C   Inspektion erfolgt zu einem späteren Zeitpunkt', value_description_de = 'C   Inspektion erfolgt zu einem späteren Zeitpunkt', value_description_fr = 'C Inspection effectuée à une date ultérieure', value_description_it = 'C Ispezione segue in un momento successivo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4138);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4141) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBF', value_name_en = 'BDBF', shortcut_en = '', value_name_de = 'BDBF', shortcut_de = '', value_name_fr = 'BDBF', shortcut_fr = '', value_name_it = 'BDBF', shortcut_it = '', value_name_ro = 'BDBF', shortcut_ro = '', value_description_en = 'yyy_F    Inspektion erfolgt von der Gegenseite', value_description_de = 'F    Inspektion erfolgt von der Gegenseite', value_description_fr = 'F L’inspection se fait depuis l’autre côté', value_description_it = 'F Ispezione viene effettuata dal lato opposto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4141);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4142) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBG', value_name_en = 'BDBG', shortcut_en = '', value_name_de = 'BDBG', shortcut_de = '', value_name_fr = 'BDBG', shortcut_fr = '', value_name_it = 'BDBG', shortcut_it = '', value_name_ro = 'BDBG', shortcut_ro = '', value_description_en = 'yyy_G   Kamera nicht einsetzbar, Schacht durch ein Fahrzeug blockiert', value_description_de = 'G   Kamera nicht einsetzbar, Schacht durch ein Fahrzeug blockiert', value_description_fr = 'G Caméra non utilisable, regard de visite bloqué par un véhicule', value_description_it = 'G Videocamera non impiegabile, pozzetto bloccato da un veicolo', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4142);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4143) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBH', value_name_en = 'BDBH', shortcut_en = '', value_name_de = 'BDBH', shortcut_de = '', value_name_fr = 'BDBH', shortcut_fr = '', value_name_it = 'BDBH', shortcut_it = '', value_name_ro = 'BDBH', shortcut_ro = '', value_description_en = 'yyy_H   Kamera nicht einsetzbar, Schacht nicht erreichbar', value_description_de = 'H   Kamera nicht einsetzbar, Schacht nicht erreichbar', value_description_fr = 'H Caméra non utilisable, regard de visite non accessible', value_description_it = 'H Videocamera non impiegabile, pozzetto non accessibile', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4143);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4144) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBI', value_name_en = 'BDBI', shortcut_en = '', value_name_de = 'BDBI', shortcut_de = '', value_name_fr = 'BDBI', shortcut_fr = '', value_name_it = 'BDBI', shortcut_it = '', value_name_ro = 'BDBI', shortcut_ro = '', value_description_en = 'yyy_I     Kamera nicht einsetzbar, Schacht kann nicht geöffnet werden', value_description_de = 'I     Kamera nicht einsetzbar, Schacht kann nicht geöffnet werden', value_description_fr = 'I Caméra non utilisable, regard de visite ne pouvant être ouvert', value_description_it = 'I Videocamera non impiegabile, pozzetto non può essere aperto', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4144);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,4145) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBJ', value_name_en = 'BDBJ', shortcut_en = '', value_name_de = 'BDBJ', shortcut_de = '', value_name_fr = 'BDBJ', shortcut_fr = '', value_name_it = 'BDBJ', shortcut_it = '', value_name_ro = 'BDBJ', shortcut_ro = '', value_description_en = 'yyy_J   Kamera nicht einsetzbar', value_description_de = 'J   Kamera nicht einsetzbar', value_description_fr = 'J Caméra non utilisable', value_description_it = 'J Videocamera non impiegabile', value_description_ro = ''
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 4145);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8834) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABAE', value_name_en = 'BABAE', shortcut_en = '', value_name_de = 'BABAE', shortcut_de = '', value_name_fr = 'BABAE', shortcut_fr = '', value_name_it = 'BABAE', shortcut_it = '', value_name_ro = 'BABAE', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss), sternförmige Rissbildung', value_description_de = 'Oberflächenriss (Haarriss), sternförmige Rissbildung', value_description_fr = 'Fissure superficielle (microfissure), fissuration en étoile', value_description_it = 'Spaccatura, fessurazione a stella', value_description_ro = 'rrr_Oberflächenriss (Haarriss), sternförmige Rissbildung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8834);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8835) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABBE', value_name_en = 'BABBE', shortcut_en = '', value_name_de = 'BABBE', shortcut_de = '', value_name_fr = 'BABBE', shortcut_fr = '', value_name_it = 'BABBE', shortcut_it = '', value_name_ro = 'BABBE', shortcut_ro = '', value_description_en = 'yyy_Riss, sternförmige Rissbildung', value_description_de = 'Riss, sternförmige Rissbildung', value_description_fr = 'Fissure, fissuration en étoile', value_description_it = 'Spaccatura, fessurazione a stella', value_description_ro = 'rrr_Riss, sternförmige Rissbildung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8835);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8836) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BABCE', value_name_en = 'BABCE', shortcut_en = '', value_name_de = 'BABCE', shortcut_de = '', value_name_fr = 'BABCE', shortcut_fr = '', value_name_it = 'BABCE', shortcut_it = '', value_name_ro = 'BABCE', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, sternförmige Rissbildung', value_description_de = 'Klaffender Riss, sternförmige Rissbildung', value_description_fr = 'Fissure béante, fissuration en étoile', value_description_it = 'Frattura aperta, fessurazione a stella', value_description_ro = 'rrr_Klaffender Riss, sternförmige Rissbildung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8836);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8837) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFAZ', value_name_en = 'BAFAZ', shortcut_en = '', value_name_de = 'BAFAZ', shortcut_de = '', value_name_fr = 'BAFAZ', shortcut_fr = '', value_name_it = 'BAFAZ', shortcut_it = '', value_name_ro = 'BAFAZ', shortcut_ro = '', value_description_en = 'yyy_Rauhe Rohrwandung, andere Ursache', value_description_de = 'Rauhe Rohrwandung, andere Ursache', value_description_fr = 'Paroi de la canalisation rugueuse, autre cause', value_description_it = 'Parete del tubo ruvida per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = 'rrr_Rauhe Rohrwandung, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8837);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8838) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFBZ', value_name_en = 'BAFBZ', shortcut_en = '', value_name_de = 'BAFBZ', shortcut_de = '', value_name_fr = 'BAFBZ', shortcut_fr = '', value_name_it = 'BAFBZ', shortcut_it = '', value_name_ro = 'BAFBZ', shortcut_ro = '', value_description_en = 'yyy_Abplatzung, andere Ursache', value_description_de = 'Abplatzung, andere Ursache', value_description_fr = 'Écaillage, autre cause ', value_description_it = 'Sfaldamento per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Abplatzung, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8838);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8839) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFCZ', value_name_en = 'BAFCZ', shortcut_en = '', value_name_de = 'BAFCZ', shortcut_de = '', value_name_fr = 'BAFCZ', shortcut_fr = '', value_name_it = 'BAFCZ', shortcut_it = '', value_name_ro = 'BAFCZ', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar, andere Ursache', value_description_de = 'Zuschlagstoffe sichtbar, andere Ursache', value_description_fr = 'Agrégats visibles, autre cause ', value_description_it = 'Materiale inerte visibile per altre cause (ulteriori dettagli richiesti nelle osser- vazioni)', value_description_ro = 'rrr_Zuschlagstoffe sichtbar, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8839);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8840) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFDZ', value_name_en = 'BAFDZ', shortcut_en = '', value_name_de = 'BAFDZ', shortcut_de = '', value_name_fr = 'BAFDZ', shortcut_fr = '', value_name_it = 'BAFDZ', shortcut_it = '', value_name_ro = 'BAFDZ', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend, andere Ursache', value_description_de = 'Zuschlagstoffe einragend, andere Ursache', value_description_fr = 'Agrégats intrusifs, autre cause', value_description_it = 'Materiale inerte sporgente per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Zuschlagstoffe einragend, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8840);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8841) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFEZ', value_name_en = 'BAFEZ', shortcut_en = '', value_name_de = 'BAFEZ', shortcut_de = '', value_name_fr = 'BAFEZ', shortcut_fr = '', value_name_it = 'BAFEZ', shortcut_it = '', value_name_ro = 'BAFEZ', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen, andere Ursache', value_description_de = 'Zuschlagstoffe fehlen, andere Ursache', value_description_fr = 'Agrégats manquants, autre cause ', value_description_it = 'Materiale inerte mancante per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Zuschlagstoffe fehlen, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8841);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8842) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFFZ', value_name_en = 'BAFFZ', shortcut_en = '', value_name_de = 'BAFFZ', shortcut_de = '', value_name_fr = 'BAFFZ', shortcut_fr = '', value_name_it = 'BAFFZ', shortcut_it = '', value_name_ro = 'BAFFZ', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar, andere Ursache', value_description_de = 'Bewehrung sichtbar, andere Ursache', value_description_fr = 'Armature visible, autre cause ', value_description_it = 'Armatura visibile per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = 'rrr_Bewehrung sichtbar, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8842);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8843) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFGZ', value_name_en = 'BAFGZ', shortcut_en = '', value_name_de = 'BAFGZ', shortcut_de = '', value_name_fr = 'BAFGZ', shortcut_fr = '', value_name_it = 'BAFGZ', shortcut_it = '', value_name_ro = 'BAFGZ', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend, andere Ursache', value_description_de = 'Bewehrung einragend, andere Ursache', value_description_fr = 'Armature dépassant de la surface, autre cause ', value_description_it = 'Armatura sporgente per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = 'rrr_Bewehrung einragend, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8843);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8844) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFIZ', value_name_en = 'BAFIZ', shortcut_en = '', value_name_de = 'BAFIZ', shortcut_de = '', value_name_fr = 'BAFIZ', shortcut_fr = '', value_name_it = 'BAFIZ', shortcut_it = '', value_name_ro = 'BAFIZ', shortcut_ro = '', value_description_en = 'yyy_Fehlende Rohrwandung, andere Ursache', value_description_de = 'Fehlende Rohrwandung, andere Ursache', value_description_fr = 'Paroi manquante, autre cause ', value_description_it = 'Parete mancante per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = 'rrr_Fehlende Rohrwandung, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8844);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8845) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFJZ', value_name_en = 'BAFJZ', shortcut_en = '', value_name_de = 'BAFJZ', shortcut_de = '', value_name_fr = 'BAFJZ', shortcut_fr = '', value_name_it = 'BAFJZ', shortcut_it = '', value_name_ro = 'BAFJZ', shortcut_ro = '', value_description_en = 'yyy_Rohrwand korrodiert, andere Ursache', value_description_de = 'Rohrwand korrodiert, andere Ursache', value_description_fr = 'Paroi corrodée, autre cause', value_description_it = 'Parete corrosa per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Rohrwand korrodiert, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8845);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8846) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFKA', value_name_en = 'BAFKA', shortcut_en = '', value_name_de = 'BAFKA', shortcut_de = '', value_name_fr = 'BAFKA', shortcut_fr = '', value_name_it = 'BAFKA', shortcut_it = '', value_name_ro = 'BAFKA', shortcut_ro = '', value_description_en = 'yyy_Beule durch mechanische Beschädigung', value_description_de = 'Beule durch mechanische Beschädigung', value_description_fr = 'Bosse par dégradation mécanique', value_description_it = 'Protuberanza per danno meccanico', value_description_ro = 'rrr_Beule durch mechanische Beschädigung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8846);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8847) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFKE', value_name_en = 'BAFKE', shortcut_en = '', value_name_de = 'BAFKE', shortcut_de = '', value_name_fr = 'BAFKE', shortcut_fr = '', value_name_it = 'BAFKE', shortcut_it = '', value_name_ro = 'BAFKE', shortcut_ro = '', value_description_en = 'yyy_Beule, Ursache nicht eindeutig feststellbar', value_description_de = 'Beule, Ursache nicht eindeutig feststellbar', value_description_fr = 'Bosse, cause pas clairement identifiable', value_description_it = 'Protuberanza per cause non evidenti', value_description_ro = 'rrr_Beule, Ursache nicht eindeutig feststellbar'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8847);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8848) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFKZ', value_name_en = 'BAFKZ', shortcut_en = '', value_name_de = 'BAFKZ', shortcut_de = '', value_name_fr = 'BAFKZ', shortcut_fr = '', value_name_it = 'BAFKZ', shortcut_it = '', value_name_ro = 'BAFKZ', shortcut_ro = '', value_description_en = 'yyy_Beule, andere Ursache', value_description_de = 'Beule, andere Ursache', value_description_fr = 'Boss, autre cause ', value_description_it = 'Protuberanza per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Beule, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8848);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8849) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAFZZ', value_name_en = 'BAFZZ', shortcut_en = '', value_name_de = 'BAFZZ', shortcut_de = '', value_name_fr = 'BAFZZ', shortcut_fr = '', value_name_it = 'BAFZZ', shortcut_it = '', value_name_ro = 'BAFZZ', shortcut_ro = '', value_description_en = 'yyy_Andersartiger Oberflächenschaden, andere Ursache', value_description_de = 'Andersartiger Oberflächenschaden, andere Ursache', value_description_fr = 'Dégradation de surface, autre cause ', value_description_it = 'Altri danni superficiali per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)', value_description_ro = 'rrr_Andersartiger Oberflächenschaden, andere Ursache'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8849);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8850) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKDD', value_name_en = 'BAKDD', shortcut_en = '', value_name_de = 'BAKDD', shortcut_de = '', value_name_fr = 'BAKDD', shortcut_fr = '', value_name_it = 'BAKDD', shortcut_it = '', value_name_ro = 'BAKDD', shortcut_ro = '', value_description_en = 'yyy_Innenauskleidung Faltenbildung, spiralformig ', value_description_de = 'Innenauskleidung Faltenbildung, spiralformig ', value_description_fr = 'Revêtement ondulé en forme de spirale', value_description_it = 'Rivestimento con grinze/pieghe elicoidali', value_description_ro = 'rrr_Innenauskleidung Faltenbildung, spiralformig '
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8850);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8851) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKF', value_name_en = 'BAKF', shortcut_en = '', value_name_de = 'BAKF', shortcut_de = '', value_name_fr = 'BAKF', shortcut_fr = '', value_name_it = 'BAKF', shortcut_it = '', value_name_ro = 'BAKF', shortcut_ro = '', value_description_en = 'yyy_Beule der Innauskleidung nach aussen', value_description_de = 'Beule der Innauskleidung nach aussen', value_description_fr = 'Bosse de la doublure intérieure vers l’extérieur', value_description_it = 'Rivestimento con bolle verso esterno', value_description_ro = 'rrr_Beule der Innauskleidung nach aussen'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8851);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8852) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKG', value_name_en = 'BAKG', shortcut_en = '', value_name_de = 'BAKG', shortcut_de = '', value_name_fr = 'BAKG', shortcut_fr = '', value_name_it = 'BAKG', shortcut_it = '', value_name_ro = 'BAKG', shortcut_ro = '', value_description_en = 'yyy_Ablösen der Innenhaut / Beschichtung', value_description_de = 'Ablösen der Innenhaut / Beschichtung', value_description_fr = 'Décollement de la peau intérieure/du revêtement', value_description_it = 'Distacco della pellicola interna/rivestimento', value_description_ro = 'rrr_Ablösen der Innenhaut / Beschichtung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8852);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8853) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKH', value_name_en = 'BAKH', shortcut_en = '', value_name_de = 'BAKH', shortcut_de = '', value_name_fr = 'BAKH', shortcut_fr = '', value_name_it = 'BAKH', shortcut_it = '', value_name_ro = 'BAKH', shortcut_ro = '', value_description_en = 'yyy_Ablösen der Abdeckung der Verbindungsnaht', value_description_de = 'Ablösen der Abdeckung der Verbindungsnaht', value_description_fr = 'Dégradation de la couture de connexion', value_description_it = 'Distacco della copertura della cucitura', value_description_ro = 'rrr_Ablösen der Abdeckung der Verbindungsnaht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8853);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8854) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKI', value_name_en = 'BAKI', shortcut_en = '', value_name_de = 'BAKI', shortcut_de = '', value_name_fr = 'BAKI', shortcut_fr = '', value_name_it = 'BAKI', shortcut_it = '', value_name_ro = 'BAKI', shortcut_ro = '', value_description_en = 'yyy_Riss oder Splat in der Innauskleidung', value_description_de = 'Riss oder Splat in der Innauskleidung', value_description_fr = 'Fissure ou espace dans la doublure intérieure (y compris la soudure défectueuse)', value_description_it = 'Fessura o spaccatura del rivestimento (incl. saldatura difettosa)', value_description_ro = 'rrr_Riss oder Splat in der Innauskleidung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8854);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8855) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKJ', value_name_en = 'BAKJ', shortcut_en = '', value_name_de = 'BAKJ', shortcut_de = '', value_name_fr = 'BAKJ', shortcut_fr = '', value_name_it = 'BAKJ', shortcut_it = '', value_name_ro = 'BAKJ', shortcut_ro = '', value_description_en = 'yyy_Loch in der Innauskleidung', value_description_de = 'Loch in der Innauskleidung', value_description_fr = 'Trou dans la doublure intérieure', value_description_it = 'Foro nel rivestimento', value_description_ro = 'rrr_Loch in der Innauskleidung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8855);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8856) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKK', value_name_en = 'BAKK', shortcut_en = '', value_name_de = 'BAKK', shortcut_de = '', value_name_fr = 'BAKK', shortcut_fr = '', value_name_it = 'BAKK', shortcut_it = '', value_name_ro = 'BAKK', shortcut_ro = '', value_description_en = 'yyy_Auskleidungsverbindung defekt', value_description_de = 'Auskleidungsverbindung defekt', value_description_fr = 'Connexion de la doublure défectueuse', value_description_it = 'Giuntura del rivestimento difettosa', value_description_ro = 'rrr_Auskleidungsverbindung defekt'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8856);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8857) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKL', value_name_en = 'BAKL', shortcut_en = '', value_name_de = 'BAKL', shortcut_de = '', value_name_fr = 'BAKL', shortcut_fr = '', value_name_it = 'BAKL', shortcut_it = '', value_name_ro = 'BAKL', shortcut_ro = '', value_description_en = 'yyy_Auskleidungswerkstoff erscheint weich', value_description_de = 'Auskleidungswerkstoff erscheint weich', value_description_fr = 'Le matériau de la doublure semble mou', value_description_it = 'Materiale del rivestimento risulta molle', value_description_ro = 'rrr_Auskleidungswerkstoff erscheint weich'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8857);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8858) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKM', value_name_en = 'BAKM', shortcut_en = '', value_name_de = 'BAKM', shortcut_de = '', value_name_fr = 'BAKM', shortcut_fr = '', value_name_it = 'BAKM', shortcut_it = '', value_name_ro = 'BAKM', shortcut_ro = '', value_description_en = 'yyy_Harz fehlt im Laminat', value_description_de = 'Harz fehlt im Laminat', value_description_fr = 'La résine manque dans le stratifié', value_description_it = 'Manca la resina nel laminato', value_description_ro = 'rrr_Harz fehlt im Laminat'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8858);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8859) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BAKN', value_name_en = 'BAKN', shortcut_en = '', value_name_de = 'BAKN', shortcut_de = '', value_name_fr = 'BAKN', shortcut_fr = '', value_name_it = 'BAKN', shortcut_it = '', value_name_ro = 'BAKN', shortcut_ro = '', value_description_en = 'yyy_Ende der Auskleidung ist nicht abgedichtet', value_description_de = 'Ende der Auskleidung ist nicht abgedichtet', value_description_fr = 'La fin de la doublure n’est pas scellée', value_description_it = 'Estremità del rivestimento non sigillato', value_description_ro = 'rrr_Ende der Auskleidung ist nicht abgedichtet'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8859);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8860) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALC', value_name_en = 'BALC', shortcut_en = '', value_name_de = 'BALC', shortcut_de = '', value_name_fr = 'BALC', shortcut_fr = '', value_name_it = 'BALC', shortcut_it = '', value_name_ro = 'BALC', shortcut_ro = '', value_description_en = 'yyy_Reparaturwerkstoff löst sich vom Altrohr', value_description_de = 'Reparaturwerkstoff löst sich vom Altrohr', value_description_fr = 'Le matériau de réparation se désolidarise de l’ancien tuyau', value_description_it = 'Materiale di riparazione si stacca dal vecchio tubo', value_description_ro = 'rrr_Reparaturwerkstoff löst sich vom Altrohr'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8860);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8861) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALD', value_name_en = 'BALD', shortcut_en = '', value_name_de = 'BALD', shortcut_de = '', value_name_fr = 'BALD', shortcut_fr = '', value_name_it = 'BALD', shortcut_it = '', value_name_ro = 'BALD', shortcut_ro = '', value_description_en = 'yyy_Reparaturwerkstoff fehlt an der Kontaktfläche', value_description_de = 'Reparaturwerkstoff fehlt an der Kontaktfläche', value_description_fr = 'Le matériel de réparation est manquant à la surface de contact', value_description_it = 'Materiale di riparazione manca sulla superficie di contatto', value_description_ro = 'rrr_Reparaturwerkstoff fehlt an der Kontaktfläche'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8861);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8862) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALE', value_name_en = 'BALE', shortcut_en = '', value_name_de = 'BALE', shortcut_de = '', value_name_fr = 'BALE', shortcut_fr = '', value_name_it = 'BALE', shortcut_it = '', value_name_ro = 'BALE', shortcut_ro = '', value_description_en = 'yyy_Überschüssiger Reparaturwerkstoff, Hindernis', value_description_de = 'Überschüssiger Reparaturwerkstoff, Hindernis', value_description_fr = 'Matériel de réparation en excès, obstacle', value_description_it = 'Materiale di riparazione in eccesso, ostacolo', value_description_ro = 'rrr_Überschüssiger Reparaturwerkstoff, Hindernis'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8862);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8863) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALF', value_name_en = 'BALF', shortcut_en = '', value_name_de = 'BALF', shortcut_de = '', value_name_fr = 'BALF', shortcut_fr = '', value_name_it = 'BALF', shortcut_it = '', value_name_ro = 'BALF', shortcut_ro = '', value_description_en = 'yyy_Loch im Reparaturwerkstoff', value_description_de = 'Loch im Reparaturwerkstoff', value_description_fr = 'Trou dans le matériel de réparation', value_description_it = 'Foro nel materiale di riparazione', value_description_ro = 'rrr_Loch im Reparaturwerkstoff'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8863);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8864) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALGA', value_name_en = 'BALGA', shortcut_en = '', value_name_de = 'BALGA', shortcut_de = '', value_name_fr = 'BALGA', shortcut_fr = '', value_name_it = 'BALGA', shortcut_it = '', value_name_ro = 'BALGA', shortcut_ro = '', value_description_en = 'yyy_Riss im Reparaturwerkstoff, längs', value_description_de = 'Riss im Reparaturwerkstoff, längs', value_description_fr = 'Fissure dans le matériau de réparation, longitudinal', value_description_it = 'Fessura nel materiale di riparazione, longitudinale', value_description_ro = 'rrr_Riss im Reparaturwerkstoff, längs'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8864);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8865) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALGB', value_name_en = 'BALGB', shortcut_en = '', value_name_de = 'BALGB', shortcut_de = '', value_name_fr = 'BALGB', shortcut_fr = '', value_name_it = 'BALGB', shortcut_it = '', value_name_ro = 'BALGB', shortcut_ro = '', value_description_en = 'yyy_Riss im Reparaturwerkstoff, radial', value_description_de = 'Riss im Reparaturwerkstoff, radial', value_description_fr = 'Fissure dans le matériau de réparation, radial', value_description_it = 'Fessura nel materiale di riparazione, radiale', value_description_ro = 'rrr_Riss im Reparaturwerkstoff, radial'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8865);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8866) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALGC', value_name_en = 'BALGC', shortcut_en = '', value_name_de = 'BALGC', shortcut_de = '', value_name_fr = 'BALGC', shortcut_fr = '', value_name_it = 'BALGC', shortcut_it = '', value_name_ro = 'BALGC', shortcut_ro = '', value_description_en = 'yyy_Riss im Reparaturwerkstoff, komplex', value_description_de = 'Riss im Reparaturwerkstoff, komplex', value_description_fr = 'Fissure dans le matériau de réparation, complexe', value_description_it = 'Fessura nel materiale di riparazione, complesso', value_description_ro = 'rrr_Riss im Reparaturwerkstoff, komplex'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8866);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8867) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BALGD', value_name_en = 'BALGD', shortcut_en = '', value_name_de = 'BALGD', shortcut_de = '', value_name_fr = 'BALGD', shortcut_fr = '', value_name_it = 'BALGD', shortcut_it = '', value_name_ro = 'BALGD', shortcut_ro = '', value_description_en = 'yyy_Riss im Reparaturwerkstoff, spiralförmig', value_description_de = 'Riss im Reparaturwerkstoff, spiralförmig', value_description_fr = 'Fissure dans le matériau de réparation, en spirale', value_description_it = 'Fessura nel materiale di riparazione, elicoidale', value_description_ro = 'rrr_Riss im Reparaturwerkstoff, spiralförmig'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8867);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8868) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBF', value_name_en = 'BCBF', shortcut_en = '', value_name_de = 'BCBF', shortcut_de = '', value_name_fr = 'BCBF', shortcut_fr = '', value_name_it = 'BCBF', shortcut_it = '', value_name_ro = 'BCBF', shortcut_ro = '', value_description_en = 'yyy_Reparatur, örtlich begrenzte Innenauskleidung des Rohres', value_description_de = 'Reparatur, örtlich begrenzte Innenauskleidung des Rohres', value_description_fr = 'Réparation, revêtement intérieur du Raccordement localisé', value_description_it = 'Riparazione, rivestimento puntuale dell’allacciamento', value_description_ro = 'rrr_Reparatur, örtlich begrenzte Innenauskleidung des Rohres'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8868);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8869) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCBG', value_name_en = 'BCBG', shortcut_en = '', value_name_de = 'BCBG', shortcut_de = '', value_name_fr = 'BCBG', shortcut_fr = '', value_name_it = 'BCBG', shortcut_it = '', value_name_ro = 'BCBG', shortcut_ro = '', value_description_en = 'yyy_Andersartige Reparatur des Anschlusses', value_description_de = 'Andersartige Reparatur des Anschlusses', value_description_fr = 'Autre réparation du raccordement', value_description_it = 'Diverso tipo di riparazione dell’allacciamento', value_description_ro = 'rrr_Andersartige Reparatur des Anschlusses'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8869);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8870) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCDXP', value_name_en = 'BCDXP', shortcut_en = '', value_name_de = 'BCDXP', shortcut_de = '', value_name_fr = 'BCDXP', shortcut_fr = '', value_name_it = 'BCDXP', shortcut_it = '', value_name_ro = 'BCDXP', shortcut_ro = '', value_description_en = 'yyy_Distanzmessung Anfang', value_description_de = 'Distanzmessung Anfang', value_description_fr = 'Début de la mesure de distance', value_description_it = 'Misurazione della distanza, inizio', value_description_ro = 'rrr_Distanzmessung Anfang'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8870);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8871) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BCEXP', value_name_en = 'BCEXP', shortcut_en = '', value_name_de = 'BCEXP', shortcut_de = '', value_name_fr = 'BCEXP', shortcut_fr = '', value_name_it = 'BCEXP', shortcut_it = '', value_name_ro = 'BCEXP', shortcut_ro = '', value_description_en = 'yyy_Distanzmessung Ende', value_description_de = 'Distanzmessung Ende', value_description_fr = 'Fin de la mesure de distance', value_description_it = 'Misurazione della distanza, fine', value_description_ro = 'rrr_Distanzmessung Ende'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8871);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8872) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDBM', value_name_en = 'BDBM', shortcut_en = '', value_name_de = 'BDBM', shortcut_de = '', value_name_fr = 'BDBM', shortcut_fr = '', value_name_it = 'BDBM', shortcut_it = '', value_name_ro = 'BDBM', shortcut_ro = '', value_description_en = 'yyy_M   Inspektion von der Gegenseite nicht möglich', value_description_de = 'M   Inspektion von der Gegenseite nicht möglich', value_description_fr = 'M Inspection impossible depuis le côté opposé', value_description_it = 'M Ispezione dal lato opposto non possibile', value_description_ro = 'rrr_M   Inspektion von der Gegenseite nicht möglich'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8872);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8873) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCAA', value_name_en = 'BDCAA', shortcut_en = '', value_name_de = 'BDCAA', shortcut_de = '', value_name_fr = 'BDCAA', shortcut_fr = '', value_name_it = 'BDCAA', shortcut_it = '', value_name_ro = 'BDCAA', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Hindernis, Inspektionsziel erreicht', value_description_de = 'Abbruch der Inspektion, Hindernis, Inspektionsziel erreicht', value_description_fr = 'Inspection abandonnée, obstruction, objectif d’inspection atteint', value_description_it = 'Interruzione dell’ispezione, ostacolo, obiettivo ispezione raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Inspektionsziel erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8873);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8874) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCAB', value_name_en = 'BDCAB', shortcut_en = '', value_name_de = 'BDCAB', shortcut_de = '', value_name_fr = 'BDCAB', shortcut_fr = '', value_name_it = 'BDCAB', shortcut_it = '', value_name_ro = 'BDCAB', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Hindernis, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Abbruch der Inspektion, Hindernis, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Inspection abandonnée, obstruction, le client renonce à une inspection plus pous- sée', value_description_it = 'Interruzione dell’ispezione, ostacolo, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8874);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8875) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCAC', value_name_en = 'BDCAC', shortcut_en = '', value_name_de = 'BDCAC', shortcut_de = '', value_name_fr = 'BDCAC', shortcut_fr = '', value_name_it = 'BDCAC', shortcut_it = '', value_name_ro = 'BDCAC', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Hindernis, Gegenseite erreicht', value_description_de = 'Abbruch der Inspektion, Hindernis, Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, obstruction, côté opposé atteint', value_description_it = 'Interruzione dell’ispezione, ostacolo, lato opposto raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8875);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8876) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCAD', value_name_en = 'BDCAD', shortcut_en = '', value_name_de = 'BDCAD', shortcut_de = '', value_name_fr = 'BDCAD', shortcut_fr = '', value_name_it = 'BDCAD', shortcut_it = '', value_name_ro = 'BDCAD', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Hindernis, Gegenseite nicht erreicht', value_description_de = 'Abbruch der Inspektion, Hindernis, Gegenseite nicht erreicht', value_description_fr = 'Inspection abandonnée, obstruction, côté opposé non atteint', value_description_it = 'Interruzione dell’ispezione, ostacolo, lato opposto non raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Gegenseite nicht erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8876);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8877) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCAE', value_name_en = 'BDCAE', shortcut_en = '', value_name_de = 'BDCAE', shortcut_de = '', value_name_fr = 'BDCAE', shortcut_fr = '', value_name_it = 'BDCAE', shortcut_it = '', value_name_ro = 'BDCAE', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Hindernis, unklar, ob Gegenseite erreicht', value_description_de = 'Abbruch der Inspektion, Hindernis, unklar, ob Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, obstruction, pas clair si le côté opposé est atteint', value_description_it = 'Interruzione dell’ispezione, ostacolo, incerto, se lato opposto raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Hindernis, unklar, ob Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8877);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8878) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCAZ', value_name_en = 'BDCAZ', shortcut_en = '', value_name_de = 'BDCAZ', shortcut_de = '', value_name_fr = 'BDCAZ', shortcut_fr = '', value_name_it = 'BDCAZ', shortcut_it = '', value_name_ro = 'BDCAZ', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Hindernis', value_description_de = 'Abbruch der Inspektion, Hindernis', value_description_fr = 'Inspection abandonnée, obstruction', value_description_it = 'Interruzione dell’ispezione, ostacolo ulteriori dettagli sono richiesti nella nota', value_description_ro = 'rrr_Abbruch der Inspektion, Hindernis'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8878);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8879) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCBA', value_name_en = 'BDCBA', shortcut_en = '', value_name_de = 'BDCBA', shortcut_de = '', value_name_fr = 'BDCBA', shortcut_fr = '', value_name_it = 'BDCBA', shortcut_it = '', value_name_ro = 'BDCBA', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Inspektionsziel erreicht', value_description_de = 'Abbruch der Inspektion, hoher Wasserstand, Inspektionsziel erreicht', value_description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, objectif d’inspection atteint', value_description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, obiettivo ispezione raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Inspektionsziel erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8879);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8880) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCBB', value_name_en = 'BDCBB', shortcut_en = '', value_name_de = 'BDCBB', shortcut_de = '', value_name_fr = 'BDCBB', shortcut_fr = '', value_name_it = 'BDCBB', shortcut_it = '', value_name_ro = 'BDCBB', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Abbruch der Inspektion, hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, le client renonce à une inspection plus poussée', value_description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8880);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8881) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCBC', value_name_en = 'BDCBC', shortcut_en = '', value_name_de = 'BDCBC', shortcut_de = '', value_name_fr = 'BDCBC', shortcut_fr = '', value_name_it = 'BDCBC', shortcut_it = '', value_name_ro = 'BDCBC', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Gegenseite erreicht', value_description_de = 'Abbruch der Inspektion, hoher Wasserstand, Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, côté opposé atteint', value_description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, lato opposto raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8881);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8882) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCBD', value_name_en = 'BDCBD', shortcut_en = '', value_name_de = 'BDCBD', shortcut_de = '', value_name_fr = 'BDCBD', shortcut_fr = '', value_name_it = 'BDCBD', shortcut_it = '', value_name_ro = 'BDCBD', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Gegenseite nicht erreicht', value_description_de = 'Abbruch der Inspektion, hoher Wasserstand, Gegenseite nicht erreicht', value_description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, côté opposé non atteint', value_description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, lato opposto non raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Gegenseite nicht erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8882);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8883) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCBE', value_name_en = 'BDCBE', shortcut_en = '', value_name_de = 'BDCBE', shortcut_de = '', value_name_fr = 'BDCBE', shortcut_fr = '', value_name_it = 'BDCBE', shortcut_it = '', value_name_ro = 'BDCBE', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, unklar, ob Gegenseite erreicht', value_description_de = 'Abbruch der Inspektion, hoher Wasserstand, unklar, ob Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, pas clair si le côté opposé est atteint', value_description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, incerto, se lato opposto raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, unklar, ob Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8883);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8884) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCBZ', value_name_en = 'BDCBZ', shortcut_en = '', value_name_de = 'BDCBZ', shortcut_de = '', value_name_fr = 'BDCBZ', shortcut_fr = '', value_name_it = 'BDCBZ', shortcut_it = '', value_name_ro = 'BDCBZ', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand', value_description_de = 'Abbruch der Inspektion, hoher Wasserstand', value_description_fr = 'Inspection abandonnée, niveau d’eau trop élevé (plus de détails requis dans la note)', value_description_it = 'Interruzione dell’ispezione, livello dell’acqua alto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8884);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8885) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCCA', value_name_en = 'BDCCA', shortcut_en = '', value_name_de = 'BDCCA', shortcut_de = '', value_name_fr = 'BDCCA', shortcut_fr = '', value_name_it = 'BDCCA', shortcut_it = '', value_name_ro = 'BDCCA', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Inspektionsziel erreicht', value_description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Inspektionsziel erreicht', value_description_fr = 'Inspection abandonnée, caméra défectueuse, objectif d’inspection atteint', value_description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, obiettivo ispezione raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Inspektionsziel erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8885);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8886) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCCB', value_name_en = 'BDCCB', shortcut_en = '', value_name_de = 'BDCCB', shortcut_de = '', value_name_fr = 'BDCCB', shortcut_fr = '', value_name_it = 'BDCCB', shortcut_it = '', value_name_ro = 'BDCCB', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Inspection abandonnée, caméra défectueuse, le client renonce à une inspection plus poussée', value_description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8886);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8887) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCCC', value_name_en = 'BDCCC', shortcut_en = '', value_name_de = 'BDCCC', shortcut_de = '', value_name_fr = 'BDCCC', shortcut_fr = '', value_name_it = 'BDCCC', shortcut_it = '', value_name_ro = 'BDCCC', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite erreicht', value_description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, caméra défectueuse, côté opposé atteint', value_description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, lato opposto raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8887);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8888) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCCD', value_name_en = 'BDCCD', shortcut_en = '', value_name_de = 'BDCCD', shortcut_de = '', value_name_fr = 'BDCCD', shortcut_fr = '', value_name_it = 'BDCCD', shortcut_it = '', value_name_ro = 'BDCCD', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite nicht erreicht', value_description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite nicht erreicht', value_description_fr = 'Inspection abandonnée, caméra défectueuse, côté opposé non atteint', value_description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, lato opposto non raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite nicht erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8888);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8889) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCCE', value_name_en = 'BDCCE', shortcut_en = '', value_name_de = 'BDCCE', shortcut_de = '', value_name_fr = 'BDCCE', shortcut_fr = '', value_name_it = 'BDCCE', shortcut_it = '', value_name_ro = 'BDCCE', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, unklar, ob Gegenseite erreicht', value_description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, unklar, ob Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, caméra défectueuse, pas clair si le côté opposé est atteint', value_description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, incerto, se lato opposto raggiunto', value_description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, unklar, ob Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8889);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8890) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCCZ', value_name_en = 'BDCCZ', shortcut_en = '', value_name_de = 'BDCCZ', shortcut_de = '', value_name_fr = 'BDCCZ', shortcut_fr = '', value_name_it = 'BDCCZ', shortcut_it = '', value_name_ro = 'BDCCZ', shortcut_ro = '', value_description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung', value_description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung', value_description_fr = 'Inspection abandonnée, caméra défectueuse, (plus de détails requis dans la note)', value_description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8890);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8891) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCZA', value_name_en = 'BDCZA', shortcut_en = '', value_name_de = 'BDCZA', shortcut_de = '', value_name_fr = 'BDCZA', shortcut_fr = '', value_name_it = 'BDCZA', shortcut_it = '', value_name_ro = 'BDCZA', shortcut_ro = '', value_description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Inspektionsziel erreicht', value_description_de = 'Anderer Grund für Abbruch der Inspektion, Inspektionsziel erreicht', value_description_fr = 'Inspection abandonnée, autre raison ; (plus de détails requis dans la note)', value_description_it = 'Altro motivo per l’interruzione dell’ispezione, obiettivo ispezione raggiunto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Inspektionsziel erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8891);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8892) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCZB', value_name_en = 'BDCZB', shortcut_en = '', value_name_de = 'BDCZB', shortcut_de = '', value_name_fr = 'BDCZB', shortcut_fr = '', value_name_it = 'BDCZB', shortcut_it = '', value_name_ro = 'BDCZB', shortcut_ro = '', value_description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Anderer Grund für Abbruch der Inspektion, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Inspection abandonnée, autre raison , le client s’abstient de toute autre inspec- tion, (plus de détails requis dans la note)', value_description_it = 'Altro motivo per l’interruzione dell’ispezione, il committente rinuncia a ulteriore ispezione (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8892);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8893) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCZC', value_name_en = 'BDCZC', shortcut_en = '', value_name_de = 'BDCZC', shortcut_de = '', value_name_fr = 'BDCZC', shortcut_fr = '', value_name_it = 'BDCZC', shortcut_it = '', value_name_ro = 'BDCZC', shortcut_ro = '', value_description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Gegenseite erreicht', value_description_de = 'Anderer Grund für Abbruch der Inspektion, Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, autre raison, côté opposé atteint (plus de détails requis dans la note)', value_description_it = 'Altro motivo per l’interruzione dell’ispezione, lato opposto raggiunto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8893);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8894) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCZD', value_name_en = 'BDCZD', shortcut_en = '', value_name_de = 'BDCZD', shortcut_de = '', value_name_fr = 'BDCZD', shortcut_fr = '', value_name_it = 'BDCZD', shortcut_it = '', value_name_ro = 'BDCZD', shortcut_ro = '', value_description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Gegenseite nicht erreicht', value_description_de = 'Anderer Grund für Abbruch der Inspektion, Gegenseite nicht erreicht', value_description_fr = 'Inspection abandonnée, autre raison, côté opposé non atteint (plus de détails requis dans la note)', value_description_it = 'Altro motivo per l’interruzione dell’ispezione, lato opposto non raggiunto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Gegenseite nicht erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8894);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8895) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCZE', value_name_en = 'BDCZE', shortcut_en = '', value_name_de = 'BDCZE', shortcut_de = '', value_name_fr = 'BDCZE', shortcut_fr = '', value_name_it = 'BDCZE', shortcut_it = '', value_name_ro = 'BDCZE', shortcut_ro = '', value_description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, unklar, ob Gegenseite erreicht', value_description_de = 'Anderer Grund für Abbruch der Inspektion, unklar, ob Gegenseite erreicht', value_description_fr = 'Inspection abandonnée, autre raison, pas clair si le côté opposé est atteint (plus de détails requis dans la note)', value_description_it = 'Altro motivo per l’interruzione dell’ispezione, incerto, se lato opposto raggiunto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, unklar, ob Gegenseite erreicht'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8895);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8896) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDCZZ', value_name_en = 'BDCZZ', shortcut_en = '', value_name_de = 'BDCZZ', shortcut_de = '', value_name_fr = 'BDCZZ', shortcut_fr = '', value_name_it = 'BDCZZ', shortcut_it = '', value_name_ro = 'BDCZZ', shortcut_ro = '', value_description_en = 'yyy_Anderer Grund für Abbruch der Inspektion,', value_description_de = 'Anderer Grund für Abbruch der Inspektion,', value_description_fr = 'Inspection abandonnée, autre raison, (plus de détails requis dans la note)', value_description_it = 'Altro motivo per l’interruzione dell’ispezione (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion,'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8896);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8897) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDDC', value_name_en = 'BDDC', shortcut_en = '', value_name_de = 'BDDC', shortcut_de = '', value_name_fr = 'BDDC', shortcut_fr = '', value_name_it = 'BDDC', shortcut_it = '', value_name_ro = 'BDDC', shortcut_ro = '', value_description_en = 'yyy_Wasserspiegel, Abwasser trüb', value_description_de = 'Wasserspiegel, Abwasser trüb', value_description_fr = 'Niveau d’eau, effluent trouble', value_description_it = 'Livello dell’acqua, acque reflue torbide', value_description_ro = 'rrr_Wasserspiegel, Abwasser trüb'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8897);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8898) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDDD', value_name_en = 'BDDD', shortcut_en = '', value_name_de = 'BDDD', shortcut_de = '', value_name_fr = 'BDDD', shortcut_fr = '', value_name_it = 'BDDD', shortcut_it = '', value_name_ro = 'BDDD', shortcut_ro = '', value_description_en = 'yyy_Wasserspiegel, Abwasser gefärbt', value_description_de = 'Wasserspiegel, Abwasser gefärbt', value_description_fr = 'Niveau d’eau, effluent coloré', value_description_it = 'Livello dell’acqua, acque reflue colorate', value_description_ro = 'rrr_Wasserspiegel, Abwasser gefärbt'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8898);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8899) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDDE', value_name_en = 'BDDE', shortcut_en = '', value_name_de = 'BDDE', shortcut_de = '', value_name_fr = 'BDDE', shortcut_fr = '', value_name_it = 'BDDE', shortcut_it = '', value_name_ro = 'BDDE', shortcut_ro = '', value_description_en = 'yyy_Wasserspiegel, Abwasser trüb und gefärbt', value_description_de = 'Wasserspiegel, Abwasser trüb und gefärbt', value_description_fr = 'Niveau d’eau, effluent trouble et coloré', value_description_it = 'Livello dell’acqua, acque reflue torbide e colorate', value_description_ro = 'rrr_Wasserspiegel, Abwasser trüb und gefärbt'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8899);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8900) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDECA', value_name_en = 'BDECA', shortcut_en = '', value_name_de = 'BDECA', shortcut_de = '', value_name_fr = 'BDECA', shortcut_fr = '', value_name_it = 'BDECA', shortcut_it = '', value_name_ro = 'BDECA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasser', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasser', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, des eaux usées se déversent dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue torbido, acque reflue entrano in acque meteoriche', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasser'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8900);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8901) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDECB', value_name_en = 'BDECB', shortcut_en = '', value_name_de = 'BDECB', shortcut_de = '', value_name_fr = 'BDECB', shortcut_fr = '', value_name_it = 'BDECB', shortcut_it = '', value_name_ro = 'BDECB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasser ', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasser ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, des eaux pluviales se déversent dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue torbido, acque meteoriche entrano in acque reflue', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasser '
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8901);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8902) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDECC', value_name_en = 'BDECC', shortcut_en = '', value_name_de = 'BDECC', shortcut_de = '', value_name_fr = 'BDECC', shortcut_fr = '', value_name_it = 'BDECC', shortcut_it = '', value_name_ro = 'BDECC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss trüb', value_description_de = 'Abwasserzufluss trüb', value_description_fr = 'Arrivées d’eaux troubles', value_description_it = 'Afflusso acque reflue torbido', value_description_ro = 'rrr_Abwasserzufluss trüb'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8902);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8903) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEDA', value_name_en = 'BDEDA', shortcut_en = '', value_name_de = 'BDEDA', shortcut_de = '', value_name_fr = 'BDEDA', shortcut_fr = '', value_name_it = 'BDEDA', shortcut_it = '', value_name_ro = 'BDEDA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasser', value_description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasser', value_description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux usées se déversent dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue colorato, acque reflue entrano in acque meteoriche', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasser'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8903);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8904) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEDB', value_name_en = 'BDEDB', shortcut_en = '', value_name_de = 'BDEDB', shortcut_de = '', value_name_fr = 'BDEDB', shortcut_fr = '', value_name_it = 'BDEDB', shortcut_it = '', value_name_ro = 'BDEDB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasser ', value_description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasser ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux pluviales se déversent dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue colorato, acque meteoriche entrano in acque reflue', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasser '
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8904);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8905) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEDC', value_name_en = 'BDEDC', shortcut_en = '', value_name_de = 'BDEDC', shortcut_de = '', value_name_fr = 'BDEDC', shortcut_fr = '', value_name_it = 'BDEDC', shortcut_it = '', value_name_ro = 'BDEDC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss gefärbt', value_description_de = 'Abwasserzufluss gefärbt', value_description_fr = 'Arrivées d’eaux troubles et colorées', value_description_it = 'Afflusso acque reflue colorato', value_description_ro = 'rrr_Abwasserzufluss gefärbt'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8905);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8906) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEEA', value_name_en = 'BDEEA', shortcut_en = '', value_name_de = 'BDEEA', shortcut_de = '', value_name_fr = 'BDEEA', shortcut_fr = '', value_name_it = 'BDEEA', shortcut_it = '', value_name_ro = 'BDEEA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasser', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasser', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux usées se déversent dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque reflue entrano in acque meteoriche', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasser'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8906);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8907) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEEB', value_name_en = 'BDEEB', shortcut_en = '', value_name_de = 'BDEEB', shortcut_de = '', value_name_fr = 'BDEEB', shortcut_fr = '', value_name_it = 'BDEEB', shortcut_it = '', value_name_ro = 'BDEEB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasser ', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasser ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux pluviales se déversent dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque meteoriche entrano in acque reflue', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasser '
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8907);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3714,3716,8908) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_channel', field_name = 'channel_damage_code', value_name = 'BDEEC', value_name_en = 'BDEEC', shortcut_en = '', value_name_de = 'BDEEC', shortcut_de = '', value_name_fr = 'BDEEC', shortcut_fr = '', value_name_it = 'BDEEC', shortcut_it = '', value_name_ro = 'BDEEC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss trüb und gefärbt', value_description_de = 'Abwasserzufluss trüb und gefärbt', value_description_fr = 'Arrivées d’eaux troubles et colorées', value_description_it = 'Afflusso acque reflue torbido e colorato', value_description_ro = 'rrr_Abwasserzufluss trüb und gefärbt'
WHERE (class_id = 3714 AND attribute_id = 3716 AND attribute_id = 8908);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4148) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAAA', value_name_en = 'DAAA', shortcut_en = '', value_name_de = 'DAAA', shortcut_de = '', value_name_fr = 'DAAA', shortcut_fr = '', value_name_it = 'DAAA', shortcut_it = '', value_name_ro = 'DAAA', shortcut_ro = '', value_description_en = 'yyy_Allgemeine Verformung', value_description_de = 'Allgemeine Verformung', value_description_fr = 'Déformation générale', value_description_it = 'Deformazione generale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4148);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4149) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAAB', value_name_en = 'DAAB', shortcut_en = '', value_name_de = 'DAAB', shortcut_de = '', value_name_fr = 'DAAB', shortcut_fr = '', value_name_it = 'DAAB', shortcut_it = '', value_name_ro = 'DAAB', shortcut_ro = '', value_description_en = 'yyy_Punktuelle Verformung', value_description_de = 'Punktuelle Verformung', value_description_fr = 'Déformation localisée', value_description_it = 'Deformazione puntuale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4149);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4150) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABAA', value_name_en = 'DABAA', shortcut_en = '', value_name_de = 'DABAA', shortcut_de = '', value_name_fr = 'DABAA', shortcut_fr = '', value_name_it = 'DABAA', shortcut_it = '', value_name_ro = 'DABAA', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss) vertikal', value_description_de = 'Oberflächenriss (Haarriss) vertikal', value_description_fr = 'Fissure superficielle (micro-fissure) verticale', value_description_it = 'Fessura superficiale (fessura capillare) verticale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4150);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4151) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABAB', value_name_en = 'DABAB', shortcut_en = '', value_name_de = 'DABAB', shortcut_de = '', value_name_fr = 'DABAB', shortcut_fr = '', value_name_it = 'DABAB', shortcut_it = '', value_name_ro = 'DABAB', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss) horizontal', value_description_de = 'Oberflächenriss (Haarriss) horizontal', value_description_fr = 'Fissure superficielle (micro-fissure) horizontale', value_description_it = 'Fessura superficiale (fessura capillare), orizzontale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4151);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4152) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABAC', value_name_en = 'DABAC', shortcut_en = '', value_name_de = 'DABAC', shortcut_de = '', value_name_fr = 'DABAC', shortcut_fr = '', value_name_it = 'DABAC', shortcut_it = '', value_name_ro = 'DABAC', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss), komplexe Rissbildung', value_description_de = 'Oberflächenriss (Haarriss), komplexe Rissbildung', value_description_fr = 'Fissure superficielle (micro-fissure), formation complexe de fissures', value_description_it = 'Fessura superficiale (fessura capillare), fessurazione complessa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4152);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4153) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABAD', value_name_en = 'DABAD', shortcut_en = '', value_name_de = 'DABAD', shortcut_de = '', value_name_fr = 'DABAD', shortcut_fr = '', value_name_it = 'DABAD', shortcut_it = '', value_name_ro = 'DABAD', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss), geneigte Rissbildung', value_description_de = 'Oberflächenriss (Haarriss), geneigte Rissbildung', value_description_fr = 'Fissure superficielle (micro-fissure), formation inclinée de fissures', value_description_it = 'Fessura superficiale (fessura capillare), fessurazione inclinata', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4153);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4154) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABBA', value_name_en = 'DABBA', shortcut_en = '', value_name_de = 'DABBA', shortcut_de = '', value_name_fr = 'DABBA', shortcut_fr = '', value_name_it = 'DABBA', shortcut_it = '', value_name_ro = 'DABBA', shortcut_ro = '', value_description_en = 'yyy_Riss vertikal', value_description_de = 'Riss vertikal', value_description_fr = 'Fissure verticale', value_description_it = 'Spaccatura verticale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4154);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4155) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABBB', value_name_en = 'DABBB', shortcut_en = '', value_name_de = 'DABBB', shortcut_de = '', value_name_fr = 'DABBB', shortcut_fr = '', value_name_it = 'DABBB', shortcut_it = '', value_name_ro = 'DABBB', shortcut_ro = '', value_description_en = 'yyy_Riss horizontal', value_description_de = 'Riss horizontal', value_description_fr = 'Fissure horizontale', value_description_it = 'Spaccatura orizzontale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4155);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4156) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABBC', value_name_en = 'DABBC', shortcut_en = '', value_name_de = 'DABBC', shortcut_de = '', value_name_fr = 'DABBC', shortcut_fr = '', value_name_it = 'DABBC', shortcut_it = '', value_name_ro = 'DABBC', shortcut_ro = '', value_description_en = 'yyy_Riss, komplexe Rissbildung', value_description_de = 'Riss, komplexe Rissbildung', value_description_fr = 'Fissure, formation complexe de fissures', value_description_it = 'Spaccatura, fessurazione complessa, formazione di frammenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4156);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4157) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABBD', value_name_en = 'DABBD', shortcut_en = '', value_name_de = 'DABBD', shortcut_de = '', value_name_fr = 'DABBD', shortcut_fr = '', value_name_it = 'DABBD', shortcut_it = '', value_name_ro = 'DABBD', shortcut_ro = '', value_description_en = 'yyy_Riss, geneigte Rissbildung', value_description_de = 'Riss, geneigte Rissbildung', value_description_fr = 'Fissure, formation inclinée de fissures', value_description_it = 'Spaccatura, fessurazione inclinata', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4157);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4158) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABCA', value_name_en = 'DABCA', shortcut_en = '', value_name_de = 'DABCA', shortcut_de = '', value_name_fr = 'DABCA', shortcut_fr = '', value_name_it = 'DABCA', shortcut_it = '', value_name_ro = 'DABCA', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, vertikal', value_description_de = 'Klaffender Riss, vertikal', value_description_fr = 'Fissure béante, verticale', value_description_it = 'Frattura aperta, verticale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4158);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4159) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABCB', value_name_en = 'DABCB', shortcut_en = '', value_name_de = 'DABCB', shortcut_de = '', value_name_fr = 'DABCB', shortcut_fr = '', value_name_it = 'DABCB', shortcut_it = '', value_name_ro = 'DABCB', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, horizontal', value_description_de = 'Klaffender Riss, horizontal', value_description_fr = 'Fissure béante, horizontale', value_description_it = 'Frattura aperta, orizzontale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4159);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4160) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABCC', value_name_en = 'DABCC', shortcut_en = '', value_name_de = 'DABCC', shortcut_de = '', value_name_fr = 'DABCC', shortcut_fr = '', value_name_it = 'DABCC', shortcut_it = '', value_name_ro = 'DABCC', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, komplexe Rissbildung', value_description_de = 'Klaffender Riss, komplexe Rissbildung', value_description_fr = 'Fissure béante, formation complexe de fissures', value_description_it = 'Frattura aperta, fessurazione complessa, formazione di frammenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4160);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4161) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABCD', value_name_en = 'DABCD', shortcut_en = '', value_name_de = 'DABCD', shortcut_de = '', value_name_fr = 'DABCD', shortcut_fr = '', value_name_it = 'DABCD', shortcut_it = '', value_name_ro = 'DABCD', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, geneigte Rissbildung', value_description_de = 'Klaffender Riss, geneigte Rissbildung', value_description_fr = 'Fissure béante, formation inclinée de fissures', value_description_it = 'Frattura aperta, fessurazione inclinata', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4161);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4162) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DACA', value_name_en = 'DACA', shortcut_en = '', value_name_de = 'DACA', shortcut_de = '', value_name_fr = 'DACA', shortcut_fr = '', value_name_it = 'DACA', shortcut_it = '', value_name_ro = 'DACA', shortcut_ro = '', value_description_en = 'yyy_In der Lage verschobene Scherbe', value_description_de = 'In der Lage verschobene Scherbe', value_description_fr = 'Formation d’éclats', value_description_it = 'Rottura con pezzi spostati ma non mancanti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4162);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4163) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DACB', value_name_en = 'DACB', shortcut_en = '', value_name_de = 'DACB', shortcut_de = '', value_name_fr = 'DACB', shortcut_fr = '', value_name_it = 'DACB', shortcut_it = '', value_name_ro = 'DACB', shortcut_ro = '', value_description_en = 'yyy_Fehlende Scherbe / Wandungsteil (Loch)', value_description_de = 'Fehlende Scherbe / Wandungsteil (Loch)', value_description_fr = 'Éclat / partie de paroi manquante', value_description_it = 'Mancanza di frammenti o pezzi sulla parete/(foro)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4163);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4164) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DACC', value_name_en = 'DACC', shortcut_en = '', value_name_de = 'DACC', shortcut_de = '', value_name_fr = 'DACC', shortcut_fr = '', value_name_it = 'DACC', shortcut_it = '', value_name_ro = 'DACC', shortcut_ro = '', value_description_en = 'yyy_Einsturz', value_description_de = 'Einsturz', value_description_fr = 'Effondrement', value_description_it = 'Rottura della condotta/crollo strutturale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4164);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4165) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DADA', value_name_en = 'DADA', shortcut_en = '', value_name_de = 'DADA', shortcut_de = '', value_name_fr = 'DADA', shortcut_fr = '', value_name_it = 'DADA', shortcut_it = '', value_name_ro = 'DADA', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine verschoben', value_description_de = 'Mauerwerk defekt, Mauer- / Backsteine verschoben', value_description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie déplacés', value_description_it = 'Muratura difettosa, mattoni o pezzi di muratura spostati', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4165);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4166) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DADB', value_name_en = 'DADB', shortcut_en = '', value_name_de = 'DADB', shortcut_de = '', value_name_fr = 'DADB', shortcut_fr = '', value_name_it = 'DADB', shortcut_it = '', value_name_ro = 'DADB', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine fehlen', value_description_de = 'Mauerwerk defekt, Mauer- / Backsteine fehlen', value_description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie manquants', value_description_it = 'Muratura difettosa, mattoni/mattoni o pezzi di muratura mancanti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4166);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4167) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DADC', value_name_en = 'DADC', shortcut_en = '', value_name_de = 'DADC', shortcut_de = '', value_name_fr = 'DADC', shortcut_fr = '', value_name_it = 'DADC', shortcut_it = '', value_name_ro = 'DADC', shortcut_ro = '', value_description_en = 'yyy_Mauerwerk defekt, Einsturz', value_description_de = 'Mauerwerk defekt, Einsturz', value_description_fr = 'Maçonnerie défectueuse, effondrement', value_description_it = 'Muratura difettosa, crollo strutturale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4167);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4168) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAE', value_name_en = 'DAE', shortcut_en = '', value_name_de = 'DAE', shortcut_de = '', value_name_fr = 'DAE', shortcut_fr = '', value_name_it = 'DAE', shortcut_it = '', value_name_ro = 'DAE', shortcut_ro = '', value_description_en = 'yyy_Mörtel aus Mauerwerk fehlt ganz oder teilweise', value_description_de = 'Mörtel aus Mauerwerk fehlt ganz oder teilweise', value_description_fr = 'Tout ou partie du mortier de la maçonnerie est manquant(e)', value_description_it = 'Manca completamente o parzialmente la malta della muratura', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4168);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4169) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFAA', value_name_en = 'DAFAA', shortcut_en = '', value_name_de = 'DAFAA', shortcut_de = '', value_name_fr = 'DAFAA', shortcut_fr = '', value_name_it = 'DAFAA', shortcut_it = '', value_name_ro = 'DAFAA', shortcut_ro = '', value_description_en = 'yyy_Erhöhte Rauheit durch mechanische Beschädigung', value_description_de = 'Erhöhte Rauheit durch mechanische Beschädigung', value_description_fr = 'Paroi de la canalisation rugueuse par dégradation mécanique', value_description_it = 'Parete del tubo ruvida per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4169);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4170) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFAB', value_name_en = 'DAFAB', shortcut_en = '', value_name_de = 'DAFAB', shortcut_de = '', value_name_fr = 'DAFAB', shortcut_fr = '', value_name_it = 'DAFAB', shortcut_it = '', value_name_ro = 'DAFAB', shortcut_ro = '', value_description_en = 'yyy_Erhöhte Rauheit durch chemischen Angriff', value_description_de = 'Erhöhte Rauheit durch chemischen Angriff', value_description_fr = 'Paroi de la canalisation rugueuse par attaque chimique', value_description_it = 'Parete del tubo ruvida per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4170);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4171) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFAC', value_name_en = 'DAFAC', shortcut_en = '', value_name_de = 'DAFAC', shortcut_de = '', value_name_fr = 'DAFAC', shortcut_fr = '', value_name_it = 'DAFAC', shortcut_it = '', value_name_ro = 'DAFAC', shortcut_ro = '', value_description_en = 'yyy_Erhöhte Rauheit durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Erhöhte Rauheit durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Parete del tubo ruvida per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4171);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4172) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFAD', value_name_en = 'DAFAD', shortcut_en = '', value_name_de = 'DAFAD', shortcut_de = '', value_name_fr = 'DAFAD', shortcut_fr = '', value_name_it = 'DAFAD', shortcut_it = '', value_name_ro = 'DAFAD', shortcut_ro = '', value_description_en = 'yyy_Erhöhte Rauheit durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Erhöhte Rauheit durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Parete del tubo ruvida per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4172);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4173) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFAE', value_name_en = 'DAFAE', shortcut_en = '', value_name_de = 'DAFAE', shortcut_de = '', value_name_fr = 'DAFAE', shortcut_fr = '', value_name_it = 'DAFAE', shortcut_it = '', value_name_ro = 'DAFAE', shortcut_ro = '', value_description_en = 'yyy_Erhöhte Rauheit, Schadensursache nicht feststellbar', value_description_de = 'Erhöhte Rauheit, Schadensursache nicht feststellbar', value_description_fr = 'Paroi de la canalisation rugueuse, cause du dommage non définissable', value_description_it = 'Parete del tubo ruvida per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4173);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4174) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFBA', value_name_en = 'DAFBA', shortcut_en = '', value_name_de = 'DAFBA', shortcut_de = '', value_name_fr = 'DAFBA', shortcut_fr = '', value_name_it = 'DAFBA', shortcut_it = '', value_name_ro = 'DAFBA', shortcut_ro = '', value_description_en = 'yyy_Abplatzung durch mechanische Beschädigung', value_description_de = 'Abplatzung durch mechanische Beschädigung', value_description_fr = 'Écaillage par dégradation mécanique', value_description_it = 'Sfaldamento per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4174);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4175) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFBE', value_name_en = 'DAFBE', shortcut_en = '', value_name_de = 'DAFBE', shortcut_de = '', value_name_fr = 'DAFBE', shortcut_fr = '', value_name_it = 'DAFBE', shortcut_it = '', value_name_ro = 'DAFBE', shortcut_ro = '', value_description_en = 'yyy_Abplatzung, Schadensursache nicht feststellbar', value_description_de = 'Abplatzung, Schadensursache nicht feststellbar', value_description_fr = 'Écaillage, cause du dommage non définissable', value_description_it = 'Sfaldamento per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4175);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4176) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFCA', value_name_en = 'DAFCA', shortcut_en = '', value_name_de = 'DAFCA', shortcut_de = '', value_name_fr = 'DAFCA', shortcut_fr = '', value_name_it = 'DAFCA', shortcut_it = '', value_name_ro = 'DAFCA', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch mechanische Beschädigung', value_description_de = 'Zuschlagstoffe sichtbar durch mechanische Beschädigung', value_description_fr = 'Agrégats visibles par dégradation mécanique', value_description_it = 'Materiale inerte visibile per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4176);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4177) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFCB', value_name_en = 'DAFCB', shortcut_en = '', value_name_de = 'DAFCB', shortcut_de = '', value_name_fr = 'DAFCB', shortcut_fr = '', value_name_it = 'DAFCB', shortcut_it = '', value_name_ro = 'DAFCB', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff', value_description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff', value_description_fr = 'Agrégats visibles par attaque chimique', value_description_it = 'Materiale inerte visibile per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4177);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4178) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFCC', value_name_en = 'DAFCC', shortcut_en = '', value_name_de = 'DAFCC', shortcut_de = '', value_name_fr = 'DAFCC', shortcut_fr = '', value_name_it = 'DAFCC', shortcut_it = '', value_name_ro = 'DAFCC', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Agrégats visibles par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Materiale inerte visibile per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4178);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4179) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFCD', value_name_en = 'DAFCD', shortcut_en = '', value_name_de = 'DAFCD', shortcut_de = '', value_name_fr = 'DAFCD', shortcut_fr = '', value_name_it = 'DAFCD', shortcut_it = '', value_name_ro = 'DAFCD', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Agrégats visibles par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Materiale inerte visibile per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4179);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4180) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFCE', value_name_en = 'DAFCE', shortcut_en = '', value_name_de = 'DAFCE', shortcut_de = '', value_name_fr = 'DAFCE', shortcut_fr = '', value_name_it = 'DAFCE', shortcut_it = '', value_name_ro = 'DAFCE', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar, Schadensursache nicht feststellbar', value_description_de = 'Zuschlagstoffe sichtbar, Schadensursache nicht feststellbar', value_description_fr = 'Agrégats visibles, cause du dommage non définissable', value_description_it = 'Materiale inerte visibile per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4180);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4181) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFDA', value_name_en = 'DAFDA', shortcut_en = '', value_name_de = 'DAFDA', shortcut_de = '', value_name_fr = 'DAFDA', shortcut_fr = '', value_name_it = 'DAFDA', shortcut_it = '', value_name_ro = 'DAFDA', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch mechanische Beschädigung', value_description_de = 'Zuschlagstoffe einragend durch mechanische Beschädigung', value_description_fr = 'Agrégats intrusifs par dégradation mécanique', value_description_it = 'Materiale inerte sporgente per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4181);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4182) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFDB', value_name_en = 'DAFDB', shortcut_en = '', value_name_de = 'DAFDB', shortcut_de = '', value_name_fr = 'DAFDB', shortcut_fr = '', value_name_it = 'DAFDB', shortcut_it = '', value_name_ro = 'DAFDB', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff', value_description_de = 'Zuschlagstoffe einragend durch chemischen Angriff', value_description_fr = 'Agrégats intrusifs par attaque chimique', value_description_it = 'Materiale inerte sporgente per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4182);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4183) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFDC', value_name_en = 'DAFDC', shortcut_en = '', value_name_de = 'DAFDC', shortcut_de = '', value_name_fr = 'DAFDC', shortcut_fr = '', value_name_it = 'DAFDC', shortcut_it = '', value_name_ro = 'DAFDC', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Agrégats intrusifs par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Materiale inerte visibile per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4183);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4184) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFDD', value_name_en = 'DAFDD', shortcut_en = '', value_name_de = 'DAFDD', shortcut_de = '', value_name_fr = 'DAFDD', shortcut_fr = '', value_name_it = 'DAFDD', shortcut_it = '', value_name_ro = 'DAFDD', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Agrégats intrusifs par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Materiale inerte visibile per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4184);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4185) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFDE', value_name_en = 'DAFDE', shortcut_en = '', value_name_de = 'DAFDE', shortcut_de = '', value_name_fr = 'DAFDE', shortcut_fr = '', value_name_it = 'DAFDE', shortcut_it = '', value_name_ro = 'DAFDE', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend, Schadensursache nicht feststellbar', value_description_de = 'Zuschlagstoffe einragend, Schadensursache nicht feststellbar', value_description_fr = 'Agrégats intrusifs, cause du dommage non définissable', value_description_it = 'Materiale inerte visibile per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4185);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4186) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFEA', value_name_en = 'DAFEA', shortcut_en = '', value_name_de = 'DAFEA', shortcut_de = '', value_name_fr = 'DAFEA', shortcut_fr = '', value_name_it = 'DAFEA', shortcut_it = '', value_name_ro = 'DAFEA', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch mechanische Beschädigung', value_description_de = 'Zuschlagstoffe fehlen durch mechanische Beschädigung', value_description_fr = 'Granulats manquants par dégradation mécanique', value_description_it = 'Materiale mancante per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4186);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4187) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFEB', value_name_en = 'DAFEB', shortcut_en = '', value_name_de = 'DAFEB', shortcut_de = '', value_name_fr = 'DAFEB', shortcut_fr = '', value_name_it = 'DAFEB', shortcut_it = '', value_name_ro = 'DAFEB', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff', value_description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff', value_description_fr = 'Agrégats manquants par attaque chimique', value_description_it = 'Materiale mancante per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4187);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4188) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFEC', value_name_en = 'DAFEC', shortcut_en = '', value_name_de = 'DAFEC', shortcut_de = '', value_name_fr = 'DAFEC', shortcut_fr = '', value_name_it = 'DAFEC', shortcut_it = '', value_name_ro = 'DAFEC', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Agrégats manquants par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Materiale mancante per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4188);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4189) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFED', value_name_en = 'DAFED', shortcut_en = '', value_name_de = 'DAFED', shortcut_de = '', value_name_fr = 'DAFED', shortcut_fr = '', value_name_it = 'DAFED', shortcut_it = '', value_name_ro = 'DAFED', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Agrégats manquants par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Materiale mancante per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4189);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4190) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFEE', value_name_en = 'DAFEE', shortcut_en = '', value_name_de = 'DAFEE', shortcut_de = '', value_name_fr = 'DAFEE', shortcut_fr = '', value_name_it = 'DAFEE', shortcut_it = '', value_name_ro = 'DAFEE', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen, Schadensursache nicht feststellbar', value_description_de = 'Zuschlagstoffe fehlen, Schadensursache nicht feststellbar', value_description_fr = 'Agrégats manquants, cause du dommage non définissable', value_description_it = 'Materiale mancante per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4190);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4191) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFFA', value_name_en = 'DAFFA', shortcut_en = '', value_name_de = 'DAFFA', shortcut_de = '', value_name_fr = 'DAFFA', shortcut_fr = '', value_name_it = 'DAFFA', shortcut_it = '', value_name_ro = 'DAFFA', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch mechanische Beschädigung', value_description_de = 'Bewehrung sichtbar durch mechanische Beschädigung', value_description_fr = 'Armature visible par dégradation mécanique', value_description_it = 'Armatura visibile per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4191);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4192) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFFB', value_name_en = 'DAFFB', shortcut_en = '', value_name_de = 'DAFFB', shortcut_de = '', value_name_fr = 'DAFFB', shortcut_fr = '', value_name_it = 'DAFFB', shortcut_it = '', value_name_ro = 'DAFFB', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff', value_description_de = 'Bewehrung sichtbar durch chemischen Angriff', value_description_fr = 'Armature visible par attaque chimique', value_description_it = 'Armatura visibile per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4192);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4193) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFFC', value_name_en = 'DAFFC', shortcut_en = '', value_name_de = 'DAFFC', shortcut_de = '', value_name_fr = 'DAFFC', shortcut_fr = '', value_name_it = 'DAFFC', shortcut_it = '', value_name_ro = 'DAFFC', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Armature visible par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Armatura visibile per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4193);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4194) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFFD', value_name_en = 'DAFFD', shortcut_en = '', value_name_de = 'DAFFD', shortcut_de = '', value_name_fr = 'DAFFD', shortcut_fr = '', value_name_it = 'DAFFD', shortcut_it = '', value_name_ro = 'DAFFD', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Armature visible par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Armatura visibile per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4194);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4195) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFFE', value_name_en = 'DAFFE', shortcut_en = '', value_name_de = 'DAFFE', shortcut_de = '', value_name_fr = 'DAFFE', shortcut_fr = '', value_name_it = 'DAFFE', shortcut_it = '', value_name_ro = 'DAFFE', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar, Schadensursache nicht feststellbar', value_description_de = 'Bewehrung sichtbar, Schadensursache nicht feststellbar', value_description_fr = 'Armature visible, cause pas clairement identifiable', value_description_it = 'Armatura visibile per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4195);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4196) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFGA', value_name_en = 'DAFGA', shortcut_en = '', value_name_de = 'DAFGA', shortcut_de = '', value_name_fr = 'DAFGA', shortcut_fr = '', value_name_it = 'DAFGA', shortcut_it = '', value_name_ro = 'DAFGA', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch mechanische Beschädigung', value_description_de = 'Bewehrung einragend durch mechanische Beschädigung', value_description_fr = 'Armature dépassant de la surface par dégradation mécanique', value_description_it = 'Armatura sporgente per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4196);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4197) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFGB', value_name_en = 'DAFGB', shortcut_en = '', value_name_de = 'DAFGB', shortcut_de = '', value_name_fr = 'DAFGB', shortcut_fr = '', value_name_it = 'DAFGB', shortcut_it = '', value_name_ro = 'DAFGB', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch chemischen Angriff', value_description_de = 'Bewehrung einragend durch chemischen Angriff', value_description_fr = 'Armature dépassant de la surface par attaque chimique', value_description_it = 'Armatura sporgente per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4197);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4198) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFGC', value_name_en = 'DAFGC', shortcut_en = '', value_name_de = 'DAFGC', shortcut_de = '', value_name_fr = 'DAFGC', shortcut_fr = '', value_name_it = 'DAFGC', shortcut_it = '', value_name_ro = 'DAFGC', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Bewehrung einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Armatura sporgente per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4198);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4199) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFGD', value_name_en = 'DAFGD', shortcut_en = '', value_name_de = 'DAFGD', shortcut_de = '', value_name_fr = 'DAFGD', shortcut_fr = '', value_name_it = 'DAFGD', shortcut_it = '', value_name_ro = 'DAFGD', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Bewehrung einragend durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Armatura sporgente per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4199);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4200) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFGE', value_name_en = 'DAFGE', shortcut_en = '', value_name_de = 'DAFGE', shortcut_de = '', value_name_fr = 'DAFGE', shortcut_fr = '', value_name_it = 'DAFGE', shortcut_it = '', value_name_ro = 'DAFGE', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend, Schadensursache nicht feststellbar', value_description_de = 'Bewehrung einragend, Schadensursache nicht feststellbar', value_description_fr = 'Armature dépassant de la surface, cause pas clairement identifiable', value_description_it = 'Armatura sporgente per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4200);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4201) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFHB', value_name_en = 'DAFHB', shortcut_en = '', value_name_de = 'DAFHB', shortcut_de = '', value_name_fr = 'DAFHB', shortcut_fr = '', value_name_it = 'DAFHB', shortcut_it = '', value_name_ro = 'DAFHB', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff', value_description_de = 'Bewehrung korrodiert durch chemischen Angriff', value_description_fr = 'Armature corrodée par attaque chimique', value_description_it = 'Armatura corrosa per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4201);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4202) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFHC', value_name_en = 'DAFHC', shortcut_en = '', value_name_de = 'DAFHC', shortcut_de = '', value_name_fr = 'DAFHC', shortcut_fr = '', value_name_it = 'DAFHC', shortcut_it = '', value_name_ro = 'DAFHC', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Armature corrodée par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Armatura corrosa per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4202);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4203) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFHD', value_name_en = 'DAFHD', shortcut_en = '', value_name_de = 'DAFHD', shortcut_de = '', value_name_fr = 'DAFHD', shortcut_fr = '', value_name_it = 'DAFHD', shortcut_it = '', value_name_ro = 'DAFHD', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Armature corrodée par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Armatura corrosa per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4203);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4204) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFHE', value_name_en = 'DAFHE', shortcut_en = '', value_name_de = 'DAFHE', shortcut_de = '', value_name_fr = 'DAFHE', shortcut_fr = '', value_name_it = 'DAFHE', shortcut_it = '', value_name_ro = 'DAFHE', shortcut_ro = '', value_description_en = 'yyy_Bewehrung korrodiert, Schadensursache nicht feststellbar', value_description_de = 'Bewehrung korrodiert, Schadensursache nicht feststellbar', value_description_fr = 'Armature corrodée, cause pas clairement identifiable', value_description_it = 'Armatura corrosa per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4204);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4205) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFIA', value_name_en = 'DAFIA', shortcut_en = '', value_name_de = 'DAFIA', shortcut_de = '', value_name_fr = 'DAFIA', shortcut_fr = '', value_name_it = 'DAFIA', shortcut_it = '', value_name_ro = 'DAFIA', shortcut_ro = '', value_description_en = 'yyy_Fehlende Wand durch mechanische Beschädigung', value_description_de = 'Fehlende Wand durch mechanische Beschädigung', value_description_fr = 'Paroi manquante par dégradation mécanique', value_description_it = 'Parete mancante per danno meccanico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4205);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4206) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFIB', value_name_en = 'DAFIB', shortcut_en = '', value_name_de = 'DAFIB', shortcut_de = '', value_name_fr = 'DAFIB', shortcut_fr = '', value_name_it = 'DAFIB', shortcut_it = '', value_name_ro = 'DAFIB', shortcut_ro = '', value_description_en = 'yyy_Fehlende Wand durch chemischen Angriff', value_description_de = 'Fehlende Wand durch chemischen Angriff', value_description_fr = 'Paroi manquante par attaque chimique', value_description_it = 'Parete mancante per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4206);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4207) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFIC', value_name_en = 'DAFIC', shortcut_en = '', value_name_de = 'DAFIC', shortcut_de = '', value_name_fr = 'DAFIC', shortcut_fr = '', value_name_it = 'DAFIC', shortcut_it = '', value_name_ro = 'DAFIC', shortcut_ro = '', value_description_en = 'yyy_Fehlende Wand  durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Fehlende Wand  durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Paroi manquante par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Parete mancante per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4207);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4208) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFID', value_name_en = 'DAFID', shortcut_en = '', value_name_de = 'DAFID', shortcut_de = '', value_name_fr = 'DAFID', shortcut_fr = '', value_name_it = 'DAFID', shortcut_it = '', value_name_ro = 'DAFID', shortcut_ro = '', value_description_en = 'yyy_Fehlende Wand  durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Fehlende Wand  durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Paroi manquante par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Parete mancante per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4208);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4209) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFIE', value_name_en = 'DAFIE', shortcut_en = '', value_name_de = 'DAFIE', shortcut_de = '', value_name_fr = 'DAFIE', shortcut_fr = '', value_name_it = 'DAFIE', shortcut_it = '', value_name_ro = 'DAFIE', shortcut_ro = '', value_description_en = 'yyy_Fehlende Wand, Schadensursache nicht feststellbar', value_description_de = 'Fehlende Wand, Schadensursache nicht feststellbar', value_description_fr = 'Paroi manquante, cause pas clairement identifiable', value_description_it = 'Parete mancante per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4209);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4210) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFJB', value_name_en = 'DAFJB', shortcut_en = '', value_name_de = 'DAFJB', shortcut_de = '', value_name_fr = 'DAFJB', shortcut_fr = '', value_name_it = 'DAFJB', shortcut_it = '', value_name_ro = 'DAFJB', shortcut_ro = '', value_description_en = 'yyy_Korrosion durch chemischen Angriff', value_description_de = 'Korrosion durch chemischen Angriff', value_description_fr = 'Corrosion par attaque chimique', value_description_it = 'Corrosione per aggressione chimica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4210);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4211) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFJC', value_name_en = 'DAFJC', shortcut_en = '', value_name_de = 'DAFJC', shortcut_de = '', value_name_fr = 'DAFJC', shortcut_fr = '', value_name_it = 'DAFJC', shortcut_it = '', value_name_ro = 'DAFJC', shortcut_ro = '', value_description_en = 'yyy_Korrosion durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Korrosion durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Corrosion par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Corrosione per aggressione chimica nella parte superiore del tubo o più in alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4211);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4212) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFJD', value_name_en = 'DAFJD', shortcut_en = '', value_name_de = 'DAFJD', shortcut_de = '', value_name_fr = 'DAFJD', shortcut_fr = '', value_name_it = 'DAFJD', shortcut_it = '', value_name_ro = 'DAFJD', shortcut_ro = '', value_description_en = 'yyy_Korrosion durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Korrosion durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Corrosion par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Corrosione per aggressione chimica nella parte inferiore del tubo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4212);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4213) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFJE', value_name_en = 'DAFJE', shortcut_en = '', value_name_de = 'DAFJE', shortcut_de = '', value_name_fr = 'DAFJE', shortcut_fr = '', value_name_it = 'DAFJE', shortcut_it = '', value_name_ro = 'DAFJE', shortcut_ro = '', value_description_en = 'yyy_Korrosion, Schadensursache nicht feststellbar', value_description_de = 'Korrosion, Schadensursache nicht feststellbar', value_description_fr = 'Corrosion, cause pas clairement identifiable', value_description_it = 'Corrosione per cause non evidenti', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4213);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4214) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFZA', value_name_en = 'DAFZA', shortcut_en = '', value_name_de = 'DAFZA', shortcut_de = '', value_name_fr = 'DAFZA', shortcut_fr = '', value_name_it = 'DAFZA', shortcut_it = '', value_name_ro = 'DAFZA', shortcut_ro = '', value_description_en = 'yyy_Anderer Oberflächenschaden durch mechanische Beschädigung', value_description_de = 'Anderer Oberflächenschaden durch mechanische Beschädigung', value_description_fr = 'Autre dégradation de surface par dégradation mécanique', value_description_it = 'Altri danni superficiali per danno meccanico (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4214);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4215) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFZB', value_name_en = 'DAFZB', shortcut_en = '', value_name_de = 'DAFZB', shortcut_de = '', value_name_fr = 'DAFZB', shortcut_fr = '', value_name_it = 'DAFZB', shortcut_it = '', value_name_ro = 'DAFZB', shortcut_ro = '', value_description_en = 'yyy_Anderer Oberflächenschaden durch chemischen Angriff', value_description_de = 'Anderer Oberflächenschaden durch chemischen Angriff', value_description_fr = 'Autre dégradation de surface par attaque chimique', value_description_it = 'Altri danni superficiali per aggressione chimica (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4215);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4216) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFZC', value_name_en = 'DAFZC', shortcut_en = '', value_name_de = 'DAFZC', shortcut_de = '', value_name_fr = 'DAFZC', shortcut_fr = '', value_name_it = 'DAFZC', shortcut_it = '', value_name_ro = 'DAFZC', shortcut_ro = '', value_description_en = 'yyy_Anderer Oberflächenschaden durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_de = 'Anderer Oberflächenschaden durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben', value_description_fr = 'Autre dégradation de surface par attaque chimique sur la partie supérieure du tuyau', value_description_it = 'Altri danni superficiali per aggressione chimica nella parte superiore del tubo o più in alto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4216);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4217) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFZD', value_name_en = 'DAFZD', shortcut_en = '', value_name_de = 'DAFZD', shortcut_de = '', value_name_fr = 'DAFZD', shortcut_fr = '', value_name_it = 'DAFZD', shortcut_it = '', value_name_ro = 'DAFZD', shortcut_ro = '', value_description_en = 'yyy_Anderer Oberflächenschaden durch chemischen Angriff im unteren Teil des Gerinnes', value_description_de = 'Anderer Oberflächenschaden durch chemischen Angriff im unteren Teil des Gerinnes', value_description_fr = 'Autre dégradation de surface par attaque chimique sur la partie inférieure du tuyau', value_description_it = 'Altri danni superficiali per aggressione chimica nella parte inferiore del tubo (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4217);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4218) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFZE', value_name_en = 'DAFZE', shortcut_en = '', value_name_de = 'DAFZE', shortcut_de = '', value_name_fr = 'DAFZE', shortcut_fr = '', value_name_it = 'DAFZE', shortcut_it = '', value_name_ro = 'DAFZE', shortcut_ro = '', value_description_en = 'yyy_Anderer Oberflächenschaden, Schadensursache nicht feststellbar', value_description_de = 'Anderer Oberflächenschaden, Schadensursache nicht feststellbar', value_description_fr = 'Autre dégradation de surface, cause pas clairement identifiable (plus de détails requis dans la note)', value_description_it = 'Altri danni superficiali per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4218);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4219) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAG', value_name_en = 'DAG', shortcut_en = '', value_name_de = 'DAG', shortcut_de = '', value_name_fr = 'DAG', shortcut_fr = '', value_name_it = 'DAG', shortcut_it = '', value_name_ro = 'DAG', shortcut_ro = '', value_description_en = 'yyy_Anschluss einragend', value_description_de = 'Anschluss einragend', value_description_fr = 'Branchement pénétrant', value_description_it = 'Allacciamento sporgente', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4219);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4220) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAHA', value_name_en = 'DAHA', shortcut_en = '', value_name_de = 'DAHA', shortcut_de = '', value_name_fr = 'DAHA', shortcut_fr = '', value_name_it = 'DAHA', shortcut_it = '', value_name_ro = 'DAHA', shortcut_ro = '', value_description_en = 'yyy_Anschluss falsch eingeführt', value_description_de = 'Anschluss falsch eingeführt', value_description_fr = 'Raccordement à position incorrecte', value_description_it = 'Allacciamento inserito in modo errato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4220);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4221) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAHB', value_name_en = 'DAHB', shortcut_en = '', value_name_de = 'DAHB', shortcut_de = '', value_name_fr = 'DAHB', shortcut_fr = '', value_name_it = 'DAHB', shortcut_it = '', value_name_ro = 'DAHB', shortcut_ro = '', value_description_en = 'yyy_Anschluss zurückliegend', value_description_de = 'Anschluss zurückliegend', value_description_fr = 'Raccordement en retrait', value_description_it = 'Allacciamento non raccordato a filo della parte del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4221);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4222) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAHC', value_name_en = 'DAHC', shortcut_en = '', value_name_de = 'DAHC', shortcut_de = '', value_name_fr = 'DAHC', shortcut_fr = '', value_name_it = 'DAHC', shortcut_it = '', value_name_ro = 'DAHC', shortcut_ro = '', value_description_en = 'yyy_Anschluss unvollständig oder nicht eingebunden', value_description_de = 'Anschluss unvollständig oder nicht eingebunden', value_description_fr = 'Raccordement incomplet ou non étanche', value_description_it = 'Allacciamento non raccordato a tenuta stagna o solo parzialmente', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4222);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4223) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAHD', value_name_en = 'DAHD', shortcut_en = '', value_name_de = 'DAHD', shortcut_de = '', value_name_fr = 'DAHD', shortcut_fr = '', value_name_it = 'DAHD', shortcut_it = '', value_name_ro = 'DAHD', shortcut_ro = '', value_description_en = 'yyy_Anschluss beschädigt', value_description_de = 'Anschluss beschädigt', value_description_fr = 'Raccordement endommagé', value_description_it = 'Tubo di raccordo danneggiato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4223);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4224) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAHE', value_name_en = 'DAHE', shortcut_en = '', value_name_de = 'DAHE', shortcut_de = '', value_name_fr = 'DAHE', shortcut_fr = '', value_name_it = 'DAHE', shortcut_it = '', value_name_ro = 'DAHE', shortcut_ro = '', value_description_en = 'yyy_Anschluss verstopft', value_description_de = 'Anschluss verstopft', value_description_fr = 'Raccordement obstrué', value_description_it = 'Allacciamento ostruito', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4224);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4225) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAHZ', value_name_en = 'DAHZ', shortcut_en = '', value_name_de = 'DAHZ', shortcut_de = '', value_name_fr = 'DAHZ', shortcut_fr = '', value_name_it = 'DAHZ', shortcut_it = '', value_name_ro = 'DAHZ', shortcut_ro = '', value_description_en = 'yyy_Anschluss andersartig schadhaft', value_description_de = 'Anschluss andersartig schadhaft', value_description_fr = 'Raccordement défectueux', value_description_it = 'Allacciamento danneggiato per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4225);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4226) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAIAA', value_name_en = 'DAIAA', shortcut_en = '', value_name_de = 'DAIAA', shortcut_de = '', value_name_fr = 'DAIAA', shortcut_fr = '', value_name_it = 'DAIAA', shortcut_it = '', value_name_ro = 'DAIAA', shortcut_ro = '', value_description_en = 'yyy_Dichtring verschoben', value_description_de = 'Dichtring verschoben', value_description_fr = 'Joint d’étanchéité déplacé', value_description_it = 'Guarnizione spostata', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4226);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4227) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAIAB', value_name_en = 'DAIAB', shortcut_en = '', value_name_de = 'DAIAB', shortcut_de = '', value_name_fr = 'DAIAB', shortcut_fr = '', value_name_it = 'DAIAB', shortcut_it = '', value_name_ro = 'DAIAB', shortcut_ro = '', value_description_en = 'yyy_Dichtring hängend, aber nicht gebrochen', value_description_de = 'Dichtring hängend, aber nicht gebrochen ', value_description_fr = 'Joint d’étanchéité pendant, mais non rompu', value_description_it = 'Guarnizione sporgente ma non rotta', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4227);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4228) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAIAC', value_name_en = 'DAIAC', shortcut_en = '', value_name_de = 'DAIAC', shortcut_de = '', value_name_fr = 'DAIAC', shortcut_fr = '', value_name_it = 'DAIAC', shortcut_it = '', value_name_ro = 'DAIAC', shortcut_ro = '', value_description_en = 'yyy_Dichtring einragend, gebrochen', value_description_de = 'Dichtring einragend, gebrochen ', value_description_fr = 'Joint d’étanchéité apparent, rompu', value_description_it = 'Guarnizione sporgente rotta', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4228);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4229) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAIZ', value_name_en = 'DAIZ', shortcut_en = '', value_name_de = 'DAIZ', shortcut_de = '', value_name_fr = 'DAIZ', shortcut_fr = '', value_name_it = 'DAIZ', shortcut_it = '', value_name_ro = 'DAIZ', shortcut_ro = '', value_description_en = 'yyy_Einragendes Dichtungsmaterial', value_description_de = 'Einragendes Dichtungsmaterial', value_description_fr = 'Joint d’étanchéité apparent', value_description_it = 'Intrusione di materiale sigillante (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4229);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4230) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAJA', value_name_en = 'DAJA', shortcut_en = '', value_name_de = 'DAJA', shortcut_de = '', value_name_fr = 'DAJA', shortcut_fr = '', value_name_it = 'DAJA', shortcut_it = '', value_name_ro = 'DAJA', shortcut_ro = '', value_description_en = 'yyy_Breite Schachtelementverbindung', value_description_de = 'Breite Schachtelementverbindung', value_description_fr = 'Assemblage déboîté d’éléments du regard de visite', value_description_it = 'Spostamento verticale tra gli elementi del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4230);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4231) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAJB', value_name_en = 'DAJB', shortcut_en = '', value_name_de = 'DAJB', shortcut_de = '', value_name_fr = 'DAJB', shortcut_fr = '', value_name_it = 'DAJB', shortcut_it = '', value_name_ro = 'DAJB', shortcut_ro = '', value_description_en = 'yyy_Schachtelement versetzt', value_description_de = 'Schachtelement versetzt', value_description_fr = 'Elément du regard de visite déplacé', value_description_it = 'Spostamento orizzontale tra gli elementi del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4231);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4232) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAJC', value_name_en = 'DAJC', shortcut_en = '', value_name_de = 'DAJC', shortcut_de = '', value_name_fr = 'DAJC', shortcut_fr = '', value_name_it = 'DAJC', shortcut_it = '', value_name_ro = 'DAJC', shortcut_ro = '', value_description_en = 'yyy_Schachtelemente Knick', value_description_de = 'Schachtelemente Knick', value_description_fr = 'Eléments du regard de visite déviés', value_description_it = 'Spostamento angolare tra gli elementi del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4232);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4233) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKA', value_name_en = 'DAKA', shortcut_en = '', value_name_de = 'DAKA', shortcut_de = '', value_name_fr = 'DAKA', shortcut_fr = '', value_name_it = 'DAKA', shortcut_it = '', value_name_ro = 'DAKA', shortcut_ro = '', value_description_en = 'yyy_Auskleidung abgelöst', value_description_de = 'Auskleidung abgelöst', value_description_fr = 'Revêtement détaché', value_description_it = 'Rivestimento staccato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4233);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4234) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKB', value_name_en = 'DAKB', shortcut_en = '', value_name_de = 'DAKB', shortcut_de = '', value_name_fr = 'DAKB', shortcut_fr = '', value_name_it = 'DAKB', shortcut_it = '', value_name_ro = 'DAKB', shortcut_ro = '', value_description_en = 'yyy_Auskleidung verfärbt', value_description_de = 'Auskleidung verfärbt', value_description_fr = 'Revêtement décoloré', value_description_it = 'Rivestimento scolorito', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4234);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4235) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKC', value_name_en = 'DAKC', shortcut_en = '', value_name_de = 'DAKC', shortcut_de = '', value_name_fr = 'DAKC', shortcut_fr = '', value_name_it = 'DAKC', shortcut_it = '', value_name_ro = 'DAKC', shortcut_ro = '', value_description_en = 'yyy_Endstelle der Auskleidung schadhaft', value_description_de = 'Endstelle der Auskleidung schadhaft', value_description_fr = 'Extrémité du revêtement défectueuse', value_description_it = 'Estremità del rivestimento difettoso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4235);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4236) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKDA', value_name_en = 'DAKDA', shortcut_en = '', value_name_de = 'DAKDA', shortcut_de = '', value_name_fr = 'DAKDA', shortcut_fr = '', value_name_it = 'DAKDA', shortcut_it = '', value_name_ro = 'DAKDA', shortcut_ro = '', value_description_en = 'yyy_Vertikale Faltenbildung in der Auskleidung', value_description_de = 'Vertikale Faltenbildung in der Auskleidung', value_description_fr = 'Revêtement ondulé verticalement', value_description_it = 'Rivestimento con grinze/pieghe verticali', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4236);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4237) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKDB', value_name_en = 'DAKDB', shortcut_en = '', value_name_de = 'DAKDB', shortcut_de = '', value_name_fr = 'DAKDB', shortcut_fr = '', value_name_it = 'DAKDB', shortcut_it = '', value_name_ro = 'DAKDB', shortcut_ro = '', value_description_en = 'yyy_Horizontale Faltenbildung in der Auskleidung', value_description_de = 'Horizontale Faltenbildung in der Auskleidung', value_description_fr = 'Revêtement ondulé horizontalement', value_description_it = 'Rivestimento con grinze/pieghe orizzontali', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4237);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4238) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKDC', value_name_en = 'DAKDC', shortcut_en = '', value_name_de = 'DAKDC', shortcut_de = '', value_name_fr = 'DAKDC', shortcut_fr = '', value_name_it = 'DAKDC', shortcut_it = '', value_name_ro = 'DAKDC', shortcut_ro = '', value_description_en = 'yyy_Komplexe Faltenbildung in der Auskleidung', value_description_de = 'Komplexe Faltenbildung in der Auskleidung', value_description_fr = 'Revêtement ondulé de façon complexe', value_description_it = 'Rivestimento con grinze/pieghe complesse', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4238);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4239) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKE', value_name_en = 'DAKE', shortcut_en = '', value_name_de = 'DAKE', shortcut_de = '', value_name_fr = 'DAKE', shortcut_fr = '', value_name_it = 'DAKE', shortcut_it = '', value_name_ro = 'DAKE', shortcut_ro = '', value_description_en = 'yyy_Blasen / Beulen in der Auskleidung', value_description_de = 'Blasen / Beulen in der Auskleidung', value_description_fr = 'Revêtement cloqué', value_description_it = 'Rivestimento con bolle e ammaccature', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4239);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4240) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKZ', value_name_en = 'DAKZ', shortcut_en = '', value_name_de = 'DAKZ', shortcut_de = '', value_name_fr = 'DAKZ', shortcut_fr = '', value_name_it = 'DAKZ', shortcut_it = '', value_name_ro = 'DAKZ', shortcut_ro = '', value_description_en = 'yyy_Auskleidung andersartig mangelhaft', value_description_de = 'Auskleidung andersartig mangelhaft', value_description_fr = 'Revêtement défectueux', value_description_it = 'Rivestimento difettoso per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4240);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4241) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALA', value_name_en = 'DALA', shortcut_en = '', value_name_de = 'DALA', shortcut_de = '', value_name_fr = 'DALA', shortcut_fr = '', value_name_it = 'DALA', shortcut_it = '', value_name_ro = 'DALA', shortcut_ro = '', value_description_en = 'yyy_Reparatur mangelhaft, Wand fehlt teilweise', value_description_de = 'Reparatur mangelhaft, Wand fehlt teilweise', value_description_fr = 'Réparation défectueuse, paroi manquante', value_description_it = 'Riparazione difettosa, parte della parete mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4241);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4242) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALB', value_name_en = 'DALB', shortcut_en = '', value_name_de = 'DALB', shortcut_de = '', value_name_fr = 'DALB', shortcut_fr = '', value_name_it = 'DALB', shortcut_it = '', value_name_ro = 'DALB', shortcut_ro = '', value_description_en = 'yyy_Reparatur Loch mangelhaft', value_description_de = 'Reparatur Loch mangelhaft', value_description_fr = 'Réparation d’un trou défectueuse', value_description_it = 'Rattoppo foro difettoso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4242);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4243) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALZ', value_name_en = 'DALZ', shortcut_en = '', value_name_de = 'DALZ', shortcut_de = '', value_name_fr = 'DALZ', shortcut_fr = '', value_name_it = 'DALZ', shortcut_it = '', value_name_ro = 'DALZ', shortcut_ro = '', value_description_en = 'yyy_Reparatur andersartig mangelhaft', value_description_de = 'Reparatur andersartig mangelhaft', value_description_fr = 'Réparation défectueuse', value_description_it = 'Riparazione difettosa per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4243);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4244) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAMA', value_name_en = 'DAMA', shortcut_en = '', value_name_de = 'DAMA', shortcut_de = '', value_name_fr = 'DAMA', shortcut_fr = '', value_name_it = 'DAMA', shortcut_it = '', value_name_ro = 'DAMA', shortcut_ro = '', value_description_en = 'yyy_Vertikale Schweissnaht mangelhaft', value_description_de = 'Vertikale Schweissnaht mangelhaft ', value_description_fr = 'Défaut de soudage vertical', value_description_it = 'Saldatura verticale difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4244);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4245) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAMB', value_name_en = 'DAMB', shortcut_en = '', value_name_de = 'DAMB', shortcut_de = '', value_name_fr = 'DAMB', shortcut_fr = '', value_name_it = 'DAMB', shortcut_it = '', value_name_ro = 'DAMB', shortcut_ro = '', value_description_en = 'yyy_Horizontale Schweissnaht mangelhaft', value_description_de = 'Horizontale Schweissnaht mangelhaft ', value_description_fr = 'Défaut de soudage horizontal', value_description_it = 'Saldatura orizzontale difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4245);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4246) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAMC', value_name_en = 'DAMC', shortcut_en = '', value_name_de = 'DAMC', shortcut_de = '', value_name_fr = 'DAMC', shortcut_fr = '', value_name_it = 'DAMC', shortcut_it = '', value_name_ro = 'DAMC', shortcut_ro = '', value_description_en = 'yyy_Schweissnaht mit spiralförmigem Verlauf mangelhaft', value_description_de = 'Schweissnaht mit spiralförmigem Verlauf mangelhaft ', value_description_fr = 'Défaut de soudage hélicoïdal', value_description_it = 'Saldatura elicoidale difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4246);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4247) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAN', value_name_en = 'DAN', shortcut_en = '', value_name_de = 'DAN', shortcut_de = '', value_name_fr = 'DAN', shortcut_fr = '', value_name_it = 'DAN', shortcut_it = '', value_name_ro = 'DAN', shortcut_ro = '', value_description_en = 'yyy_Schachtwand porös', value_description_de = 'Schachtwand porös', value_description_fr = 'Paroi du regard de visite poreuse', value_description_it = 'Parete del pozzetto porosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4247);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4248) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAO', value_name_en = 'DAO', shortcut_en = '', value_name_de = 'DAO', shortcut_de = '', value_name_fr = 'DAO', shortcut_fr = '', value_name_it = 'DAO', shortcut_it = '', value_name_ro = 'DAO', shortcut_ro = '', value_description_en = 'yyy_anstehender Boden sichtbar', value_description_de = 'anstehender Boden sichtbar ', value_description_fr = 'Sol visible', value_description_it = 'Suolo visibile', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4248);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4249) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAP', value_name_en = 'DAP', shortcut_en = '', value_name_de = 'DAP', shortcut_de = '', value_name_fr = 'DAP', shortcut_fr = '', value_name_it = 'DAP', shortcut_it = '', value_name_ro = 'DAP', shortcut_ro = '', value_description_en = 'yyy_Hohlraum sichtbar', value_description_de = 'Hohlraum sichtbar ', value_description_fr = 'Vide visible', value_description_it = 'Cavità visibile', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4249);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4250) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQA', value_name_en = 'DAQA', shortcut_en = '', value_name_de = 'DAQA', shortcut_de = '', value_name_fr = 'DAQA', shortcut_fr = '', value_name_it = 'DAQA', shortcut_it = '', value_name_ro = 'DAQA', shortcut_ro = '', value_description_en = 'yyy_Steighilfe locker', value_description_de = 'Steighilfe locker', value_description_fr = 'Échelon déboîté', value_description_it = 'Scalino allentato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4250);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4251) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQB', value_name_en = 'DAQB', shortcut_en = '', value_name_de = 'DAQB', shortcut_de = '', value_name_fr = 'DAQB', shortcut_fr = '', value_name_it = 'DAQB', shortcut_it = '', value_name_ro = 'DAQB', shortcut_ro = '', value_description_en = 'yyy_Steighilfe fehlt', value_description_de = 'Steighilfe fehlt', value_description_fr = 'Échelon manquant', value_description_it = 'Scalino mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4251);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4252) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQC', value_name_en = 'DAQC', shortcut_en = '', value_name_de = 'DAQC', shortcut_de = '', value_name_fr = 'DAQC', shortcut_fr = '', value_name_it = 'DAQC', shortcut_it = '', value_name_ro = 'DAQC', shortcut_ro = '', value_description_en = 'yyy_Steighilfe korrodiert', value_description_de = 'Steighilfe korrodiert', value_description_fr = 'Échelon corrodé', value_description_it = 'Scalino corroso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4252);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4253) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQD', value_name_en = 'DAQD', shortcut_en = '', value_name_de = 'DAQD', shortcut_de = '', value_name_fr = 'DAQD', shortcut_fr = '', value_name_it = 'DAQD', shortcut_it = '', value_name_ro = 'DAQD', shortcut_ro = '', value_description_en = 'yyy_Steighilfe verbogen', value_description_de = 'Steighilfe verbogen', value_description_fr = 'Échelon plié', value_description_it = 'Scalino ricurvo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4253);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4254) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQE', value_name_en = 'DAQE', shortcut_en = '', value_name_de = 'DAQE', shortcut_de = '', value_name_fr = 'DAQE', shortcut_fr = '', value_name_it = 'DAQE', shortcut_it = '', value_name_ro = 'DAQE', shortcut_ro = '', value_description_en = 'yyy_Steighilfe Kunststoffverkleidung gebrochen', value_description_de = 'Steighilfe Kunststoffverkleidung gebrochen', value_description_fr = 'Revêtement plastique de l''échelon brisé', value_description_it = 'Il rivestimento in plastica dello scalino è rotto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4254);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4255) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQF', value_name_en = 'DAQF', shortcut_en = '', value_name_de = 'DAQF', shortcut_de = '', value_name_fr = 'DAQF', shortcut_fr = '', value_name_it = 'DAQF', shortcut_it = '', value_name_ro = 'DAQF', shortcut_ro = '', value_description_en = 'yyy_Steighilfe Handlauf korrodiert', value_description_de = 'Steighilfe Handlauf korrodiert', value_description_fr = 'Main-courante de l’échelle corrodée', value_description_it = 'Corrosione del corrimano della scala', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4255);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4256) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQG', value_name_en = 'DAQG', shortcut_en = '', value_name_de = 'DAQG', shortcut_de = '', value_name_fr = 'DAQG', shortcut_fr = '', value_name_it = 'DAQG', shortcut_it = '', value_name_ro = 'DAQG', shortcut_ro = '', value_description_en = 'yyy_Absturzsicherung locker', value_description_de = 'Absturzsicherung locker', value_description_fr = 'Protection antichute déboîtée', value_description_it = 'Protezione anticaduta allentata', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4256);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4257) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQH', value_name_en = 'DAQH', shortcut_en = '', value_name_de = 'DAQH', shortcut_de = '', value_name_fr = 'DAQH', shortcut_fr = '', value_name_it = 'DAQH', shortcut_it = '', value_name_ro = 'DAQH', shortcut_ro = '', value_description_en = 'yyy_Absturzsicherung fehlt', value_description_de = 'Absturzsicherung fehlt ', value_description_fr = 'Protection antichute manquante', value_description_it = 'Protezione anticaduta mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4257);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4258) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQI', value_name_en = 'DAQI', shortcut_en = '', value_name_de = 'DAQI', shortcut_de = '', value_name_fr = 'DAQI', shortcut_fr = '', value_name_it = 'DAQI', shortcut_it = '', value_name_ro = 'DAQI', shortcut_ro = '', value_description_en = 'yyy_Absturzsicherung korrodiert', value_description_de = 'Absturzsicherung korrodiert', value_description_fr = 'Protection antichute corrodée', value_description_it = 'Protezione anticaduta corrosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4258);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4259) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQJ', value_name_en = 'DAQJ', shortcut_en = '', value_name_de = 'DAQJ', shortcut_de = '', value_name_fr = 'DAQJ', shortcut_fr = '', value_name_it = 'DAQJ', shortcut_it = '', value_name_ro = 'DAQJ', shortcut_ro = '', value_description_en = 'yyy_Leitersprossen korrodiert', value_description_de = 'Leitersprossen korrodiert', value_description_fr = 'Échelons d’échelle corrodés', value_description_it = 'Pioli della scala corrosi', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4259);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4260) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQK', value_name_en = 'DAQK', shortcut_en = '', value_name_de = 'DAQK', shortcut_de = '', value_name_fr = 'DAQK', shortcut_fr = '', value_name_it = 'DAQK', shortcut_it = '', value_name_ro = 'DAQK', shortcut_ro = '', value_description_en = 'yyy_Steigkasten schadhaft', value_description_de = 'Steigkasten schadhaft', value_description_fr = 'Trou d''homme défectueux', value_description_it = 'Appoggio per i piedi difettoso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4260);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4261) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAQZ', value_name_en = 'DAQZ', shortcut_en = '', value_name_de = 'DAQZ', shortcut_de = '', value_name_fr = 'DAQZ', shortcut_fr = '', value_name_it = 'DAQZ', shortcut_it = '', value_name_ro = 'DAQZ', shortcut_ro = '', value_description_en = 'yyy_Steighilfe andersweitig schadhaft', value_description_de = 'Steighilfe andersweitig schadhaft', value_description_fr = 'Échelle autrement défectueuse', value_description_it = 'Scalino o scala difettoso per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4261);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4262) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARA', value_name_en = 'DARA', shortcut_en = '', value_name_de = 'DARA', shortcut_de = '', value_name_fr = 'DARA', shortcut_fr = '', value_name_it = 'DARA', shortcut_it = '', value_name_ro = 'DARA', shortcut_ro = '', value_description_en = 'yyy_Deckel gebrochen', value_description_de = 'Deckel gebrochen ', value_description_fr = 'Couvercle cassé', value_description_it = 'Chiusino rotto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4262);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4263) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARB', value_name_en = 'DARB', shortcut_en = '', value_name_de = 'DARB', shortcut_de = '', value_name_fr = 'DARB', shortcut_fr = '', value_name_it = 'DARB', shortcut_it = '', value_name_ro = 'DARB', shortcut_ro = '', value_description_en = 'yyy_Deckel wackelt', value_description_de = 'Deckel wackelt', value_description_fr = 'Couvercle oscillant', value_description_it = 'Chiusino traballante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4263);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4264) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARC', value_name_en = 'DARC', shortcut_en = '', value_name_de = 'DARC', shortcut_de = '', value_name_fr = 'DARC', shortcut_fr = '', value_name_it = 'DARC', shortcut_it = '', value_name_ro = 'DARC', shortcut_ro = '', value_description_en = 'yyy_Deckel fehlt', value_description_de = 'Deckel fehlt', value_description_fr = 'Couvercle manquant', value_description_it = 'Chiusino mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4264);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4265) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARD', value_name_en = 'DARD', shortcut_en = '', value_name_de = 'DARD', shortcut_de = '', value_name_fr = 'DARD', shortcut_fr = '', value_name_it = 'DARD', shortcut_it = '', value_name_ro = 'DARD', shortcut_ro = '', value_description_en = 'yyy_Rahmen gebrochen', value_description_de = 'Rahmen gebrochen', value_description_fr = 'Cadre brisé', value_description_it = 'Telaio rotto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4265);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4266) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARE', value_name_en = 'DARE', shortcut_en = '', value_name_de = 'DARE', shortcut_de = '', value_name_fr = 'DARE', shortcut_fr = '', value_name_it = 'DARE', shortcut_it = '', value_name_ro = 'DARE', shortcut_ro = '', value_description_en = 'yyy_Rahmen locker', value_description_de = 'Rahmen locker', value_description_fr = 'Cadre déboîté', value_description_it = 'Telaio instabile', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4266);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4267) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARF', value_name_en = 'DARF', shortcut_en = '', value_name_de = 'DARF', shortcut_de = '', value_name_fr = 'DARF', shortcut_fr = '', value_name_it = 'DARF', shortcut_it = '', value_name_ro = 'DARF', shortcut_ro = '', value_description_en = 'yyy_Rahmen fehlt', value_description_de = 'Rahmen fehlt', value_description_fr = 'Cadre manquant', value_description_it = 'Telaio mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4267);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4268) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARG', value_name_en = 'DARG', shortcut_en = '', value_name_de = 'DARG', shortcut_de = '', value_name_fr = 'DARG', shortcut_fr = '', value_name_it = 'DARG', shortcut_it = '', value_name_ro = 'DARG', shortcut_ro = '', value_description_en = 'yyy_Abdeckung zu tief', value_description_de = 'Abdeckung zu tief', value_description_fr = 'Couvercle trop bas', value_description_it = 'Chiusino troppo basso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4268);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4269) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARH', value_name_en = 'DARH', shortcut_en = '', value_name_de = 'DARH', shortcut_de = '', value_name_fr = 'DARH', shortcut_fr = '', value_name_it = 'DARH', shortcut_it = '', value_name_ro = 'DARH', shortcut_ro = '', value_description_en = 'yyy_Abdeckung zu hoch', value_description_de = 'Abdeckung zu hoch ', value_description_fr = 'Couvercle trop haut', value_description_it = 'Chiusino troppo alto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4269);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4270) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DARZ', value_name_en = 'DARZ', shortcut_en = '', value_name_de = 'DARZ', shortcut_de = '', value_name_fr = 'DARZ', shortcut_fr = '', value_name_it = 'DARZ', shortcut_it = '', value_name_ro = 'DARZ', shortcut_ro = '', value_description_en = 'yyy_Abdeckung andersweitig schadhaft', value_description_de = 'Abdeckung andersweitig schadhaft', value_description_fr = 'Couvercle défectueux', value_description_it = 'Chiusino difettoso per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4270);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4271) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBAA', value_name_en = 'DBAA', shortcut_en = '', value_name_de = 'DBAA', shortcut_de = '', value_name_fr = 'DBAA', shortcut_fr = '', value_name_it = 'DBAA', shortcut_it = '', value_name_ro = 'DBAA', shortcut_ro = '', value_description_en = 'yyy_Pfahlwurzel', value_description_de = 'Pfahlwurzel', value_description_fr = 'Grosse racine isolée', value_description_it = 'Tappo di radici', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4271);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4272) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBAB', value_name_en = 'DBAB', shortcut_en = '', value_name_de = 'DBAB', shortcut_de = '', value_name_fr = 'DBAB', shortcut_fr = '', value_name_it = 'DBAB', shortcut_it = '', value_name_ro = 'DBAB', shortcut_ro = '', value_description_en = 'yyy_Einzelner, feiner Wurzeleinwuchs', value_description_de = 'Einzelner, feiner Wurzeleinwuchs', value_description_fr = 'Radicelles', value_description_it = 'Radici sottili singole', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4272);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4273) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBAC', value_name_en = 'DBAC', shortcut_en = '', value_name_de = 'DBAC', shortcut_de = '', value_name_fr = 'DBAC', shortcut_fr = '', value_name_it = 'DBAC', shortcut_it = '', value_name_ro = 'DBAC', shortcut_ro = '', value_description_en = 'yyy_Komplexes Wurzelwerk', value_description_de = 'Komplexes Wurzelwerk', value_description_fr = 'Ensemble complexe de racines', value_description_it = 'Massa complessa di radici', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4273);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4274) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBBA', value_name_en = 'DBBA', shortcut_en = '', value_name_de = 'DBBA', shortcut_de = '', value_name_fr = 'DBBA', shortcut_fr = '', value_name_it = 'DBBA', shortcut_it = '', value_name_ro = 'DBBA', shortcut_ro = '', value_description_en = 'yyy_Inkrustation (verkalkt)', value_description_de = 'Inkrustation (verkalkt)', value_description_fr = 'Concrétions (calcifié)', value_description_it = 'Incrostazioni (calcificazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4274);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4275) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBBB', value_name_en = 'DBBB', shortcut_en = '', value_name_de = 'DBBB', shortcut_de = '', value_name_fr = 'DBBB', shortcut_fr = '', value_name_it = 'DBBB', shortcut_it = '', value_name_ro = 'DBBB', shortcut_ro = '', value_description_en = 'yyy_Fett', value_description_de = 'Fett', value_description_fr = 'Graisse', value_description_it = 'Grasso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4275);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4276) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBBC', value_name_en = 'DBBC', shortcut_en = '', value_name_de = 'DBBC', shortcut_de = '', value_name_fr = 'DBBC', shortcut_fr = '', value_name_it = 'DBBC', shortcut_it = '', value_name_ro = 'DBBC', shortcut_ro = '', value_description_en = 'yyy_Fäulnis', value_description_de = 'Fäulnis', value_description_fr = 'Moisissement', value_description_it = 'Incrostazioni organiche', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4276);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4277) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBBZ', value_name_en = 'DBBZ', shortcut_en = '', value_name_de = 'DBBZ', shortcut_de = '', value_name_fr = 'DBBZ', shortcut_fr = '', value_name_it = 'DBBZ', shortcut_it = '', value_name_ro = 'DBBZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige anhaftende Stoffe', value_description_de = 'Andersartige anhaftende Stoffe', value_description_fr = 'Autres substances adhérentes ', value_description_it = 'Altri depositi attaccati (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4277);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4278) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBCA', value_name_en = 'DBCA', shortcut_en = '', value_name_de = 'DBCA', shortcut_de = '', value_name_fr = 'DBCA', shortcut_fr = '', value_name_it = 'DBCA', shortcut_it = '', value_name_ro = 'DBCA', shortcut_ro = '', value_description_en = 'yyy_Lose Ablagerungen, Sand', value_description_de = 'Lose Ablagerungen, Sand', value_description_fr = 'Dépôts lâches, sable', value_description_it = 'Depositi sciolte, sabbia', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4278);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4279) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBCB', value_name_en = 'DBCB', shortcut_en = '', value_name_de = 'DBCB', shortcut_de = '', value_name_fr = 'DBCB', shortcut_fr = '', value_name_it = 'DBCB', shortcut_it = '', value_name_ro = 'DBCB', shortcut_ro = '', value_description_en = 'yyy_Lose Ablagerungen, Kies', value_description_de = 'Lose Ablagerungen, Kies', value_description_fr = 'Dépôts lâches, gravier', value_description_it = 'Depositi sciolte, ghiaia', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4279);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4280) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBCC', value_name_en = 'DBCC', shortcut_en = '', value_name_de = 'DBCC', shortcut_de = '', value_name_fr = 'DBCC', shortcut_fr = '', value_name_it = 'DBCC', shortcut_it = '', value_name_ro = 'DBCC', shortcut_ro = '', value_description_en = 'yyy_Harte Ablagerungen', value_description_de = 'Harte Ablagerungen', value_description_fr = 'Dépôts durs', value_description_it = 'Depositi duri', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4280);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4281) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBCZ', value_name_en = 'DBCZ', shortcut_en = '', value_name_de = 'DBCZ', shortcut_de = '', value_name_fr = 'DBCZ', shortcut_fr = '', value_name_it = 'DBCZ', shortcut_it = '', value_name_ro = 'DBCZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige Ablagerungen', value_description_de = 'Andersartige Ablagerungen', value_description_fr = 'Autres Dépôts', value_description_it = 'Altri tipi di depositi (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4281);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4282) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBD', value_name_en = 'DBD', shortcut_en = '', value_name_de = 'DBD', shortcut_de = '', value_name_fr = 'DBD', shortcut_fr = '', value_name_it = 'DBD', shortcut_it = '', value_name_ro = 'DBD', shortcut_ro = '', value_description_en = 'yyy_Bodenmaterial dringt ein', value_description_de = 'Bodenmaterial dringt ein', value_description_fr = 'Entrée de terre', value_description_it = 'Penetrazione di materiale dal sottosuolo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4282);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4283) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEA', value_name_en = 'DBEA', shortcut_en = '', value_name_de = 'DBEA', shortcut_de = '', value_name_fr = 'DBEA', shortcut_fr = '', value_name_it = 'DBEA', shortcut_it = '', value_name_ro = 'DBEA', shortcut_ro = '', value_description_en = 'yyy_Abflusshindernis: Herausgefallener Mauer- oder Backstein', value_description_de = 'Abflusshindernis: Herausgefallener Mauer- oder Backstein', value_description_fr = 'Obstacle à l’écoulement dans la cunette: briquetage ou élément de maçonnerie délogé', value_description_it = 'Ostacolo al deflusso nella cunetta: mattoni o pezzi di muratura staccati', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4283);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4284) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEB', value_name_en = 'DBEB', shortcut_en = '', value_name_de = 'DBEB', shortcut_de = '', value_name_fr = 'DBEB', shortcut_fr = '', value_name_it = 'DBEB', shortcut_it = '', value_name_ro = 'DBEB', shortcut_ro = '', value_description_en = 'yyy_Abflusshindernis: Herausgebrochenes Leitungsstück', value_description_de = 'Abflusshindernis: Herausgebrochenes Leitungsstück', value_description_fr = 'Obstacle à l’écoulement dans la cunette: fragment de canalisation brisé', value_description_it = 'Ostacolo al deflusso nella cunetta: pezzo di tubo rotto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4284);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4285) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEC', value_name_en = 'DBEC', shortcut_en = '', value_name_de = 'DBEC', shortcut_de = '', value_name_fr = 'DBEC', shortcut_fr = '', value_name_it = 'DBEC', shortcut_it = '', value_name_ro = 'DBEC', shortcut_ro = '', value_description_en = 'yyy_Abflusshindernis', value_description_de = 'Abflusshindernis', value_description_fr = 'Obstacle à l’écoulement dans la cunette', value_description_it = 'Ostacolo al deflusso nella cunetta', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4285);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4286) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBED', value_name_en = 'DBED', shortcut_en = '', value_name_de = 'DBED', shortcut_de = '', value_name_fr = 'DBED', shortcut_fr = '', value_name_it = 'DBED', shortcut_it = '', value_name_ro = 'DBED', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ragt durch die Wand ein', value_description_de = 'Gegenstand ragt durch die Wand ein', value_description_fr = 'Obstacle dépassant de la paroi', value_description_it = 'Oggetto sporgente dalla parete', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4286);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4287) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEE', value_name_en = 'DBEE', shortcut_en = '', value_name_de = 'DBEE', shortcut_de = '', value_name_fr = 'DBEE', shortcut_fr = '', value_name_it = 'DBEE', shortcut_it = '', value_name_ro = 'DBEE', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ist in der Schachtelementverbindung eingeklemmt', value_description_de = 'Gegenstand ist in der Schachtelementverbindung eingeklemmt', value_description_fr = 'Obstacle coincé dans l’assemblage des éléments du regard', value_description_it = 'Oggetto incuneato nel giunto tra elementi del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4287);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4288) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEF', value_name_en = 'DBEF', shortcut_en = '', value_name_de = 'DBEF', shortcut_de = '', value_name_fr = 'DBEF', shortcut_fr = '', value_name_it = 'DBEF', shortcut_it = '', value_name_ro = 'DBEF', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ragt aus Anschluss', value_description_de = 'Gegenstand ragt aus Anschluss', value_description_fr = 'Obstacle dépassant du raccordement', value_description_it = 'Oggetto sporge da un allacciamento', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4288);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4289) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEG', value_name_en = 'DBEG', shortcut_en = '', value_name_de = 'DBEG', shortcut_de = '', value_name_fr = 'DBEG', shortcut_fr = '', value_name_it = 'DBEG', shortcut_it = '', value_name_ro = 'DBEG', shortcut_ro = '', value_description_en = 'yyy_Fremde Werkleitungen oder Kabel durchqueren den Schacht', value_description_de = 'Fremde Werkleitungen oder Kabel durchqueren den Schacht', value_description_fr = 'Conduites externes ou câbles traversant le regard de visite', value_description_it = 'Condotte sotterranee o cavi attraversano il pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4289);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4290) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEH', value_name_en = 'DBEH', shortcut_en = '', value_name_de = 'DBEH', shortcut_de = '', value_name_fr = 'DBEH', shortcut_fr = '', value_name_it = 'DBEH', shortcut_it = '', value_name_ro = 'DBEH', shortcut_ro = '', value_description_en = 'yyy_Gegenstand ist in den Schacht eingebaut', value_description_de = 'Gegenstand ist in den Schacht eingebaut', value_description_fr = 'Obstacle intégré à la structure du regard', value_description_it = 'Oggetto inglobato nella struttura del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4290);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4291) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBEZ', value_name_en = 'DBEZ', shortcut_en = '', value_name_de = 'DBEZ', shortcut_de = '', value_name_fr = 'DBEZ', shortcut_fr = '', value_name_it = 'DBEZ', shortcut_it = '', value_name_ro = 'DBEZ', shortcut_ro = '', value_description_en = 'yyy_Andersartiges Hindernis', value_description_de = 'Andersartiges Hindernis', value_description_fr = 'Autres obstacle', value_description_it = 'Altri ostacoli (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4291);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4292) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFAA', value_name_en = 'DBFAA', shortcut_en = '', value_name_de = 'DBFAA', shortcut_de = '', value_name_fr = 'DBFAA', shortcut_fr = '', value_name_it = 'DBFAA', shortcut_it = '', value_name_ro = 'DBFAA', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Schwitzen / Verkalkung an der Schachtwand', value_description_de = 'Infiltration: Schwitzen / Verkalkung an der Schachtwand', value_description_fr = 'Infiltration: suintement / entartrage de la paroi du regard de visite', value_description_it = 'Infiltrazioni: trasudamento/calcificazione alla parete del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4292);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4293) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFAB', value_name_en = 'DBFAB', shortcut_en = '', value_name_de = 'DBFAB', shortcut_de = '', value_name_fr = 'DBFAB', shortcut_fr = '', value_name_it = 'DBFAB', shortcut_it = '', value_name_ro = 'DBFAB', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss im Sohlbereich ', value_description_de = 'Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss im Sohlbereich ', value_description_fr = 'Infiltration: suintement / entartrage de l’encastrement d’un raccordement au niveau du radier', value_description_it = 'Infiltrazioni: trasudamento/calcificazione del raccordo di un allacciamento a livello del fondo pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4293);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4294) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFAC', value_name_en = 'DBFAC', shortcut_en = '', value_name_de = 'DBFAC', shortcut_de = '', value_name_fr = 'DBFAC', shortcut_fr = '', value_name_it = 'DBFAC', shortcut_it = '', value_name_ro = 'DBFAC', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss oberhalb des Banketts', value_description_de = 'Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss oberhalb des Banketts', value_description_fr = 'Infiltration: suintement / entartrage de l’encastrement d’un raccordement au-dessus de la banquette', value_description_it = 'Infiltrazioni: trasudamento/calcificazione del raccordo di allacciamento sopra la banchina', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4294);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4295) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFBA', value_name_en = 'DBFBA', shortcut_en = '', value_name_de = 'DBFBA', shortcut_de = '', value_name_fr = 'DBFBA', shortcut_fr = '', value_name_it = 'DBFBA', shortcut_it = '', value_name_ro = 'DBFBA', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser tropft aus der Schachtwand', value_description_de = 'Infiltration: Wasser tropft aus der Schachtwand', value_description_fr = 'Infiltration: l’eau goutte de la paroi du regard de visite', value_description_it = 'Infiltrazioni: gocciolamento attraverso la parete del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4295);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4296) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFBB', value_name_en = 'DBFBB', shortcut_en = '', value_name_de = 'DBFBB', shortcut_de = '', value_name_fr = 'DBFBB', shortcut_fr = '', value_name_it = 'DBFBB', shortcut_it = '', value_name_ro = 'DBFBB', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser tropft aus der Einbindung eines Anschluss im Sohlbereich', value_description_de = 'Infiltration: Wasser tropft aus der Einbindung eines Anschluss im Sohlbereich', value_description_fr = 'Infiltration: l’eau goutte de l’encastrement d’un raccordement au niveau du radier', value_description_it = 'Infiltrazioni: gocciolamento attraverso il raccordo del giunto di un allacciamento a livello del fondo pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4296);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4297) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFBC', value_name_en = 'DBFBC', shortcut_en = '', value_name_de = 'DBFBC', shortcut_de = '', value_name_fr = 'DBFBC', shortcut_fr = '', value_name_it = 'DBFBC', shortcut_it = '', value_name_ro = 'DBFBC', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser tropft aus der Einbindung eines Anschluss oberhalb des Banketts', value_description_de = 'Infiltration: Wasser tropft aus der Einbindung eines Anschluss oberhalb des Banketts', value_description_fr = 'Infiltration: l’eau goutte de l’encastrement d’un raccordement au-dessus de la banquette', value_description_it = 'Infiltrazioni: gocciolamento attraverso il raccordo del giunto di un allacciamento sopra la banchina', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4297);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4298) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFCA', value_name_en = 'DBFCA', shortcut_en = '', value_name_de = 'DBFCA', shortcut_de = '', value_name_fr = 'DBFCA', shortcut_fr = '', value_name_it = 'DBFCA', shortcut_it = '', value_name_ro = 'DBFCA', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser fliesst aus der Schachtwand', value_description_de = 'Infiltration: Wasser fliesst aus der Schachtwand', value_description_fr = 'Infiltration: l’eau s’écoule de la paroi du regard de visite', value_description_it = 'Infiltrazioni: acqua penetra attraverso la parete del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4298);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4299) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFCB', value_name_en = 'DBFCB', shortcut_en = '', value_name_de = 'DBFCB', shortcut_de = '', value_name_fr = 'DBFCB', shortcut_fr = '', value_name_it = 'DBFCB', shortcut_it = '', value_name_ro = 'DBFCB', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser fliesst aus der Einbindung eines Anschluss im Sohlbereich', value_description_de = 'Infiltration: Wasser fliesst aus der Einbindung eines Anschluss im Sohlbereich', value_description_fr = 'Infiltration: l’eau s’écoule de l’encastrement d’un raccordement au niveau du radier', value_description_it = 'Infiltrazioni: acqua penetra attraverso il raccordo del giunto di un allacciamento a livello del fondo pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4299);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4300) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFCC', value_name_en = 'DBFCC', shortcut_en = '', value_name_de = 'DBFCC', shortcut_de = '', value_name_fr = 'DBFCC', shortcut_fr = '', value_name_it = 'DBFCC', shortcut_it = '', value_name_ro = 'DBFCC', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser fliesst aus der Einbindung eines Anschluss oberhalb des Banketts', value_description_de = 'Infiltration: Wasser fliesst aus der Einbindung eines Anschluss oberhalb des Banketts', value_description_fr = 'Infiltration: l’eau s’écoule de l’encastrement d’un raccordement au-dessus de la banquette', value_description_it = 'Infiltrazioni: acqua penetra attraverso il raccordo del giunto di un allacciamento sopra la banchina', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4300);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4301) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFDA', value_name_en = 'DBFDA', shortcut_en = '', value_name_de = 'DBFDA', shortcut_de = '', value_name_fr = 'DBFDA', shortcut_fr = '', value_name_it = 'DBFDA', shortcut_it = '', value_name_ro = 'DBFDA', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser spritzt aus der Schachtwand', value_description_de = 'Infiltration: Wasser spritzt aus der Schachtwand', value_description_fr = 'Infiltration: l’eau jaillit de la paroi du regard de visite', value_description_it = 'Infiltrazioni: zampillo dalla parete del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4301);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4302) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFDB', value_name_en = 'DBFDB', shortcut_en = '', value_name_de = 'DBFDB', shortcut_de = '', value_name_fr = 'DBFDB', shortcut_fr = '', value_name_it = 'DBFDB', shortcut_it = '', value_name_ro = 'DBFDB', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser spritzt aus der Einbindung eines Anschluss im Sohlbereich', value_description_de = 'Infiltration: Wasser spritzt aus der Einbindung eines Anschluss im Sohlbereich', value_description_fr = 'Infiltration: l’eau jaillit de l’encastrement d’un raccordement au niveau du radier', value_description_it = 'Infiltrazioni: zampillo attraverso il raccordo del giunto di un allacciamento a livello del fondo pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4302);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4303) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBFDC', value_name_en = 'DBFDC', shortcut_en = '', value_name_de = 'DBFDC', shortcut_de = '', value_name_fr = 'DBFDC', shortcut_fr = '', value_name_it = 'DBFDC', shortcut_it = '', value_name_ro = 'DBFDC', shortcut_ro = '', value_description_en = 'yyy_Infiltration: Wasser spritzt aus der Einbindung eines Anschluss oberhalb des Banketts', value_description_de = 'Infiltration: Wasser spritzt aus der Einbindung eines Anschluss oberhalb des Banketts', value_description_fr = 'Infiltration: l’eau jaillit de l’encastrement d’un raccordement au-dessus de la banquette', value_description_it = 'Infiltrazioni: zampillo attraverso il raccordo del giunto di un allacciamento sopra la banchina', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4303);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4304) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBG', value_name_en = 'DBG', shortcut_en = '', value_name_de = 'DBG', shortcut_de = '', value_name_fr = 'DBG', shortcut_fr = '', value_name_it = 'DBG', shortcut_it = '', value_name_ro = 'DBG', shortcut_ro = '', value_description_en = 'yyy_Sichtbarer Wasseraustritt', value_description_de = 'Sichtbarer Wasseraustritt', value_description_fr = 'Fuite visible de la canalisation', value_description_it = 'Fuoriuscita visibile dal pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4304);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4305) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHAA', value_name_en = 'DBHAA', shortcut_en = '', value_name_de = 'DBHAA', shortcut_de = '', value_name_fr = 'DBHAA', shortcut_fr = '', value_name_it = 'DBHAA', shortcut_it = '', value_name_ro = 'DBHAA', shortcut_ro = '', value_description_en = 'yyy_Ratte im Schacht', value_description_de = 'Ratte im Schacht', value_description_fr = 'Rats dans le regard de visite', value_description_it = 'Ratti nel pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4305);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4306) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHAB', value_name_en = 'DBHAB', shortcut_en = '', value_name_de = 'DBHAB', shortcut_de = '', value_name_fr = 'DBHAB', shortcut_fr = '', value_name_it = 'DBHAB', shortcut_it = '', value_name_ro = 'DBHAB', shortcut_ro = '', value_description_en = 'yyy_Ratte im Anschluss', value_description_de = 'Ratte im Anschluss', value_description_fr = 'Rats dans le raccordement', value_description_it = 'Ratti in un allacciamento', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4306);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4307) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHAC', value_name_en = 'DBHAC', shortcut_en = '', value_name_de = 'DBHAC', shortcut_de = '', value_name_fr = 'DBHAC', shortcut_fr = '', value_name_it = 'DBHAC', shortcut_it = '', value_name_ro = 'DBHAC', shortcut_ro = '', value_description_en = 'yyy_Ratte in der offenen Schachtelementverbindung', value_description_de = 'Ratte in der offenen Schachtelementverbindung', value_description_fr = 'Rats dans l’assemblage ouvert du regard de visite', value_description_it = 'Ratti in un elemento di giunzione aperto del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4307);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4308) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHAZ', value_name_en = 'DBHAZ', shortcut_en = '', value_name_de = 'DBHAZ', shortcut_de = '', value_name_fr = 'DBHAZ', shortcut_fr = '', value_name_it = 'DBHAZ', shortcut_it = '', value_name_ro = 'DBHAZ', shortcut_ro = '', value_description_en = 'yyy_Ratte', value_description_de = 'Ratte', value_description_fr = 'Rats', value_description_it = 'Ratti (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4308);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4309) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHBA', value_name_en = 'DBHBA', shortcut_en = '', value_name_de = 'DBHBA', shortcut_de = '', value_name_fr = 'DBHBA', shortcut_fr = '', value_name_it = 'DBHBA', shortcut_it = '', value_name_ro = 'DBHBA', shortcut_ro = '', value_description_en = 'yyy_Kakerlaken im Schacht', value_description_de = 'Kakerlaken im Schacht', value_description_fr = 'Cafards dans le regard de visite', value_description_it = 'Scarafaggi nel pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4309);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4310) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHBB', value_name_en = 'DBHBB', shortcut_en = '', value_name_de = 'DBHBB', shortcut_de = '', value_name_fr = 'DBHBB', shortcut_fr = '', value_name_it = 'DBHBB', shortcut_it = '', value_name_ro = 'DBHBB', shortcut_ro = '', value_description_en = 'yyy_Kakerlaken im Anschluss', value_description_de = 'Kakerlaken im Anschluss', value_description_fr = 'Cafards dans le raccordement', value_description_it = 'Scarafaggi in un allacciamento', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4310);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4311) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHBC', value_name_en = 'DBHBC', shortcut_en = '', value_name_de = 'DBHBC', shortcut_de = '', value_name_fr = 'DBHBC', shortcut_fr = '', value_name_it = 'DBHBC', shortcut_it = '', value_name_ro = 'DBHBC', shortcut_ro = '', value_description_en = 'yyy_Kakerlaken in der offenen Schachtelementverbindung', value_description_de = 'Kakerlaken in der offenen Schachtelementverbindung', value_description_fr = 'Cafards dans l’assemblage ouvert du regard de visite', value_description_it = 'Scarafaggi in un elemento di giunzione aperto del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4311);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4312) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHBZ', value_name_en = 'DBHBZ', shortcut_en = '', value_name_de = 'DBHBZ', shortcut_de = '', value_name_fr = 'DBHBZ', shortcut_fr = '', value_name_it = 'DBHBZ', shortcut_it = '', value_name_ro = 'DBHBZ', shortcut_ro = '', value_description_en = 'yyy_Kakerlaken', value_description_de = 'Kakerlaken', value_description_fr = 'Cafards', value_description_it = 'Scarafaggi (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4312);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4313) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHZA', value_name_en = 'DBHZA', shortcut_en = '', value_name_de = 'DBHZA', shortcut_de = '', value_name_fr = 'DBHZA', shortcut_fr = '', value_name_it = 'DBHZA', shortcut_it = '', value_name_ro = 'DBHZA', shortcut_ro = '', value_description_en = 'yyy_Tier im Schacht', value_description_de = 'Tier im Schacht', value_description_fr = 'Animaux dans le regard de visite', value_description_it = 'Animali nel pozzetto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4313);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4314) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHZB', value_name_en = 'DBHZB', shortcut_en = '', value_name_de = 'DBHZB', shortcut_de = '', value_name_fr = 'DBHZB', shortcut_fr = '', value_name_it = 'DBHZB', shortcut_it = '', value_name_ro = 'DBHZB', shortcut_ro = '', value_description_en = 'yyy_Tier im Anschluss', value_description_de = 'Tier im Anschluss', value_description_fr = 'Animaux dans le raccordement', value_description_it = 'Animal in un allacciamento (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4314);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4315) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHZC', value_name_en = 'DBHZC', shortcut_en = '', value_name_de = 'DBHZC', shortcut_de = '', value_name_fr = 'DBHZC', shortcut_fr = '', value_name_it = 'DBHZC', shortcut_it = '', value_name_ro = 'DBHZC', shortcut_ro = '', value_description_en = 'yyy_Tier in der offenen Schachtelementverbindung', value_description_de = 'Tier in der offenen Schachtelementverbindung', value_description_fr = 'Animaux dans l’assemblage ouvert du regard de visite', value_description_it = 'Animali in un elemento di giunzione aperto del pozzetto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4315);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4316) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DBHZZ', value_name_en = 'DBHZZ', shortcut_en = '', value_name_de = 'DBHZZ', shortcut_de = '', value_name_fr = 'DBHZZ', shortcut_fr = '', value_name_it = 'DBHZZ', shortcut_it = '', value_name_ro = 'DBHZZ', shortcut_ro = '', value_description_en = 'yyy_Tier', value_description_de = 'Tier', value_description_fr = 'Animaux', value_description_it = 'Animali in genere (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4316);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4317) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAA', value_name_en = 'DCAA', shortcut_en = '', value_name_de = 'DCAA', shortcut_de = '', value_name_fr = 'DCAA', shortcut_fr = '', value_name_it = 'DCAA', shortcut_it = '', value_name_ro = 'DCAA', shortcut_ro = '', value_description_en = 'yyy_Anschluss mit Gerinne im Bankett', value_description_de = 'Anschluss mit Gerinne im Bankett', value_description_fr = 'Raccordement dans la banquette', value_description_it = 'Allacciamento con cunetta nella banchina', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4317);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4318) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAB', value_name_en = 'DCAB', shortcut_en = '', value_name_de = 'DCAB', shortcut_de = '', value_name_fr = 'DCAB', shortcut_fr = '', value_name_it = 'DCAB', shortcut_it = '', value_name_ro = 'DCAB', shortcut_ro = '', value_description_en = 'yyy_Anschluss in die Durchlaufrinne', value_description_de = 'Anschluss in die Durchlaufrinne', value_description_fr = 'Raccordement à la cunette', value_description_it = 'Allacciamento nella cunetta passante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4318);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4319) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAC', value_name_en = 'DCAC', shortcut_en = '', value_name_de = 'DCAC', shortcut_de = '', value_name_fr = 'DCAC', shortcut_fr = '', value_name_it = 'DCAC', shortcut_it = '', value_name_ro = 'DCAC', shortcut_ro = '', value_description_en = 'yyy_Anschluss Schwanenhals', value_description_de = 'Anschluss Schwanenhals', value_description_fr = 'Raccordement au col de cygne', value_description_it = 'Allacciamento sifonato (tubo superiore)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4319);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4320) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAD', value_name_en = 'DCAD', shortcut_en = '', value_name_de = 'DCAD', shortcut_de = '', value_name_fr = 'DCAD', shortcut_fr = '', value_name_it = 'DCAD', shortcut_it = '', value_name_ro = 'DCAD', shortcut_ro = '', value_description_en = 'yyy_Anschluss Schwanenhals innenliegend', value_description_de = 'Anschluss Schwanenhals innenliegend', value_description_fr = 'Raccordement au col de cygne interne', value_description_it = 'Allacciamento sifonato (tubo interno)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4320);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4321) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAE', value_name_en = 'DCAE', shortcut_en = '', value_name_de = 'DCAE', shortcut_de = '', value_name_fr = 'DCAE', shortcut_fr = '', value_name_it = 'DCAE', shortcut_it = '', value_name_ro = 'DCAE', shortcut_ro = '', value_description_en = 'yyy_Anschluss mit Schussgerinne', value_description_de = 'Anschluss mit Schussgerinne', value_description_fr = 'Raccordement incliné externe', value_description_it = 'Allacciamento con cunetta a rampa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4321);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4322) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAF', value_name_en = 'DCAF', shortcut_en = '', value_name_de = 'DCAF', shortcut_de = '', value_name_fr = 'DCAF', shortcut_fr = '', value_name_it = 'DCAF', shortcut_it = '', value_name_ro = 'DCAF', shortcut_ro = '', value_description_en = 'yyy_Belüftungsrohr', value_description_de = 'Belüftungsrohr', value_description_fr = 'Canalisation d’aération', value_description_it = 'Colonna di ventilazione', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4322);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4323) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCAZ', value_name_en = 'DCAZ', shortcut_en = '', value_name_de = 'DCAZ', shortcut_de = '', value_name_fr = 'DCAZ', shortcut_fr = '', value_name_it = 'DCAZ', shortcut_it = '', value_name_ro = 'DCAZ', shortcut_ro = '', value_description_en = 'yyy_Anschluss ', value_description_de = 'Anschluss ', value_description_fr = 'Raccordement', value_description_it = 'Altro tipo d’allacciamento (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4323);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4324) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBA', value_name_en = 'DCBA', shortcut_en = '', value_name_de = 'DCBA', shortcut_de = '', value_name_fr = 'DCBA', shortcut_fr = '', value_name_it = 'DCBA', shortcut_it = '', value_name_ro = 'DCBA', shortcut_ro = '', value_description_en = 'yyy_Reparatur, Teil der Schachtwand ausgetauscht', value_description_de = 'Reparatur, Teil der Schachtwand ausgetauscht', value_description_fr = 'Réparation, partie de la paroi du regard de visite remplacée', value_description_it = 'Riparazione, sostituzione parziale della parete del pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4324);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4325) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBB', value_name_en = 'DCBB', shortcut_en = '', value_name_de = 'DCBB', shortcut_de = '', value_name_fr = 'DCBB', shortcut_fr = '', value_name_it = 'DCBB', shortcut_it = '', value_name_ro = 'DCBB', shortcut_ro = '', value_description_en = 'yyy_Reparatur, örtlich begrenzte Innenauskleidung', value_description_de = 'Reparatur, örtlich begrenzte Innenauskleidung', value_description_fr = 'Réparation, revêtement localisé', value_description_it = 'Riparazione, rivestimento interno puntuale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4325);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4326) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBC', value_name_en = 'DCBC', shortcut_en = '', value_name_de = 'DCBC', shortcut_de = '', value_name_fr = 'DCBC', shortcut_fr = '', value_name_it = 'DCBC', shortcut_it = '', value_name_ro = 'DCBC', shortcut_ro = '', value_description_en = 'yyy_Reparatur, Injizierung', value_description_de = 'Reparatur, Injizierung', value_description_fr = 'Réparation, injection', value_description_it = 'Riparazione, iniezione', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4326);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4327) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBZ', value_name_en = 'DCBZ', shortcut_en = '', value_name_de = 'DCBZ', shortcut_de = '', value_name_fr = 'DCBZ', shortcut_fr = '', value_name_it = 'DCBZ', shortcut_it = '', value_name_ro = 'DCBZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige Reparatur', value_description_de = 'Andersartige Reparatur', value_description_fr = 'Réparation autre', value_description_it = 'Diverso tipo di riparazione dell’allacciamento (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4327);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4328) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFA', value_name_en = 'DCFA', shortcut_en = '', value_name_de = 'DCFA', shortcut_de = '', value_name_fr = 'DCFA', shortcut_fr = '', value_name_it = 'DCFA', shortcut_it = '', value_name_ro = 'DCFA', shortcut_ro = '', value_description_en = 'yyy_<anderes Material> ', value_description_de = '<anderes Material> ', value_description_fr = '<autre matériau>', value_description_it = '<altro materiale>', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4328);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4329) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFB', value_name_en = 'DCFB', shortcut_en = '', value_name_de = 'DCFB', shortcut_de = '', value_name_fr = 'DCFB', shortcut_fr = '', value_name_it = 'DCFB', shortcut_it = '', value_name_ro = 'DCFB', shortcut_ro = '', value_description_en = 'yyy_Asbestzement', value_description_de = 'Asbestzement', value_description_fr = 'Béton amianté', value_description_it = 'Cemento amianto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4329);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4330) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFC', value_name_en = 'DCFC', shortcut_en = '', value_name_de = 'DCFC', shortcut_de = '', value_name_fr = 'DCFC', shortcut_fr = '', value_name_it = 'DCFC', shortcut_it = '', value_name_ro = 'DCFC', shortcut_ro = '', value_description_en = 'yyy_Normalbeton', value_description_de = 'Normalbeton', value_description_fr = 'Béton normal', value_description_it = 'Calcestruzzo normale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4330);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4331) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFD', value_name_en = 'DCFD', shortcut_en = '', value_name_de = 'DCFD', shortcut_de = '', value_name_fr = 'DCFD', shortcut_fr = '', value_name_it = 'DCFD', shortcut_it = '', value_name_ro = 'DCFD', shortcut_ro = '', value_description_en = 'yyy_Ortsbeton', value_description_de = 'Ortsbeton', value_description_fr = 'Béton frais', value_description_it = 'Calcestruzzo gettato in opera', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4331);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4332) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFE', value_name_en = 'DCFE', shortcut_en = '', value_name_de = 'DCFE', shortcut_de = '', value_name_fr = 'DCFE', shortcut_fr = '', value_name_it = 'DCFE', shortcut_it = '', value_name_ro = 'DCFE', shortcut_ro = '', value_description_en = 'yyy_Pressrohrbeton', value_description_de = 'Pressrohrbeton', value_description_fr = 'Béton de tube de fonçage', value_description_it = 'Calcestruzzo pressato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4332);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4333) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFF', value_name_en = 'DCFF', shortcut_en = '', value_name_de = 'DCFF', shortcut_de = '', value_name_fr = 'DCFF', shortcut_fr = '', value_name_it = 'DCFF', shortcut_it = '', value_name_ro = 'DCFF', shortcut_ro = '', value_description_en = 'yyy_Spezialbeton', value_description_de = 'Spezialbeton', value_description_fr = 'Béton spécial', value_description_it = 'Calcestruzzo speciale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4333);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4334) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFG', value_name_en = 'DCFG', shortcut_en = '', value_name_de = 'DCFG', shortcut_de = '', value_name_fr = 'DCFG', shortcut_fr = '', value_name_it = 'DCFG', shortcut_it = '', value_name_ro = 'DCFG', shortcut_ro = '', value_description_en = 'yyy_Beton', value_description_de = 'Beton', value_description_fr = 'Béton', value_description_it = 'Calcestruzzo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4334);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4335) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFH', value_name_en = 'DCFH', shortcut_en = '', value_name_de = 'DCFH', shortcut_de = '', value_name_fr = 'DCFH', shortcut_fr = '', value_name_it = 'DCFH', shortcut_it = '', value_name_ro = 'DCFH', shortcut_ro = '', value_description_en = 'yyy_Faserzement', value_description_de = 'Faserzement', value_description_fr = 'Fibrociment', value_description_it = 'Fibrocemento', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4335);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4336) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFI', value_name_en = 'DCFI', shortcut_en = '', value_name_de = 'DCFI', shortcut_de = '', value_name_fr = 'DCFI', shortcut_fr = '', value_name_it = 'DCFI', shortcut_it = '', value_name_ro = 'DCFI', shortcut_ro = '', value_description_en = 'yyy_Gebrannte Steine', value_description_de = 'Gebrannte Steine', value_description_fr = 'Terre cuites', value_description_it = 'Laterizi', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4336);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4337) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFJ', value_name_en = 'DCFJ', shortcut_en = '', value_name_de = 'DCFJ', shortcut_de = '', value_name_fr = 'DCFJ', shortcut_fr = '', value_name_it = 'DCFJ', shortcut_it = '', value_name_ro = 'DCFJ', shortcut_ro = '', value_description_en = 'yyy_Duktiler Guss', value_description_de = 'Duktiler Guss', value_description_fr = 'Fonte ductile', value_description_it = 'Ghisa sferoidale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4337);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4338) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFK', value_name_en = 'DCFK', shortcut_en = '', value_name_de = 'DCFK', shortcut_de = '', value_name_fr = 'DCFK', shortcut_fr = '', value_name_it = 'DCFK', shortcut_it = '', value_name_ro = 'DCFK', shortcut_ro = '', value_description_en = 'yyy_Grauguss', value_description_de = 'Grauguss', value_description_fr = 'Fonte grise', value_description_it = 'Ghisa grigia', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4338);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4339) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFL', value_name_en = 'DCFL', shortcut_en = '', value_name_de = 'DCFL', shortcut_de = '', value_name_fr = 'DCFL', shortcut_fr = '', value_name_it = 'DCFL', shortcut_it = '', value_name_ro = 'DCFL', shortcut_ro = '', value_description_en = 'yyy_Epoxidharz', value_description_de = 'Epoxidharz', value_description_fr = 'Résine époxyde', value_description_it = 'Resina epossidica', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4339);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4340) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFM', value_name_en = 'DCFM', shortcut_en = '', value_name_de = 'DCFM', shortcut_de = '', value_name_fr = 'DCFM', shortcut_fr = '', value_name_it = 'DCFM', shortcut_it = '', value_name_ro = 'DCFM', shortcut_ro = '', value_description_en = 'yyy_Hartpolyethylen', value_description_de = 'Hartpolyethylen', value_description_fr = 'Polyéthylène dur', value_description_it = 'Polietilene rigido', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4340);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4341) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFN', value_name_en = 'DCFN', shortcut_en = '', value_name_de = 'DCFN', shortcut_de = '', value_name_fr = 'DCFN', shortcut_fr = '', value_name_it = 'DCFN', shortcut_it = '', value_name_ro = 'DCFN', shortcut_ro = '', value_description_en = 'yyy_Polyester GUP', value_description_de = 'Polyester GUP', value_description_fr = 'Polyester GUP', value_description_it = 'Poliestere GUP', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4341);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4342) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFO', value_name_en = 'DCFO', shortcut_en = '', value_name_de = 'DCFO', shortcut_de = '', value_name_fr = 'DCFO', shortcut_fr = '', value_name_it = 'DCFO', shortcut_it = '', value_name_ro = 'DCFO', shortcut_ro = '', value_description_en = 'yyy_Polyethylen', value_description_de = 'Polyethylen', value_description_fr = 'Polyéthylène', value_description_it = 'Polietilene', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4342);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4343) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFP', value_name_en = 'DCFP', shortcut_en = '', value_name_de = 'DCFP', shortcut_de = '', value_name_fr = 'DCFP', shortcut_fr = '', value_name_it = 'DCFP', shortcut_it = '', value_name_ro = 'DCFP', shortcut_ro = '', value_description_en = 'yyy_Polypropylen', value_description_de = 'Polypropylen', value_description_fr = 'Polypropylène', value_description_it = 'Polipropilene', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4343);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4344) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFQ', value_name_en = 'DCFQ', shortcut_en = '', value_name_de = 'DCFQ', shortcut_de = '', value_name_fr = 'DCFQ', shortcut_fr = '', value_name_it = 'DCFQ', shortcut_it = '', value_name_ro = 'DCFQ', shortcut_ro = '', value_description_en = 'yyy_Polyvinylchlorid', value_description_de = 'Polyvinylchlorid', value_description_fr = 'Chlorure de polyvinyle (PVC)', value_description_it = 'Polivinilcloruro', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4344);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4345) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFR', value_name_en = 'DCFR', shortcut_en = '', value_name_de = 'DCFR', shortcut_de = '', value_name_fr = 'DCFR', shortcut_fr = '', value_name_it = 'DCFR', shortcut_it = '', value_name_ro = 'DCFR', shortcut_ro = '', value_description_en = 'yyy_Kunststoff unbekannt', value_description_de = 'Kunststoff unbekannt', value_description_fr = 'Plastique inconnu', value_description_it = 'Materiale sintetico non identificato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4345);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4346) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFS', value_name_en = 'DCFS', shortcut_en = '', value_name_de = 'DCFS', shortcut_de = '', value_name_fr = 'DCFS', shortcut_fr = '', value_name_it = 'DCFS', shortcut_it = '', value_name_ro = 'DCFS', shortcut_ro = '', value_description_en = 'yyy_Stahl', value_description_de = 'Stahl', value_description_fr = 'Acier', value_description_it = 'Acciaio', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4346);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4347) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFT', value_name_en = 'DCFT', shortcut_en = '', value_name_de = 'DCFT', shortcut_de = '', value_name_fr = 'DCFT', shortcut_fr = '', value_name_it = 'DCFT', shortcut_it = '', value_name_ro = 'DCFT', shortcut_ro = '', value_description_en = 'yyy_Rostfreier Stahl', value_description_de = 'Rostfreier Stahl', value_description_fr = 'Acier inoxydable', value_description_it = 'Acciaio inossidabile', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4347);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4348) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFU', value_name_en = 'DCFU', shortcut_en = '', value_name_de = 'DCFU', shortcut_de = '', value_name_fr = 'DCFU', shortcut_fr = '', value_name_it = 'DCFU', shortcut_it = '', value_name_ro = 'DCFU', shortcut_ro = '', value_description_en = 'yyy_Steinzeug', value_description_de = 'Steinzeug', value_description_fr = 'Grès céramique', value_description_it = 'Grès', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4348);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4349) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFV', value_name_en = 'DCFV', shortcut_en = '', value_name_de = 'DCFV', shortcut_de = '', value_name_fr = 'DCFV', shortcut_fr = '', value_name_it = 'DCFV', shortcut_it = '', value_name_ro = 'DCFV', shortcut_ro = '', value_description_en = 'yyy_Ton', value_description_de = 'Ton', value_description_fr = 'Argile', value_description_it = 'Argilla', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4349);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4350) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFW', value_name_en = 'DCFW', shortcut_en = '', value_name_de = 'DCFW', shortcut_de = '', value_name_fr = 'DCFW', shortcut_fr = '', value_name_it = 'DCFW', shortcut_it = '', value_name_ro = 'DCFW', shortcut_ro = '', value_description_en = 'yyy_unbekanntes Material', value_description_de = 'unbekanntes Material', value_description_fr = 'Matériau inconnu', value_description_it = 'Materiale non identificato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4350);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4351) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCFX', value_name_en = 'DCFX', shortcut_en = '', value_name_de = 'DCFX', shortcut_de = '', value_name_fr = 'DCFX', shortcut_fr = '', value_name_it = 'DCFX', shortcut_it = '', value_name_ro = 'DCFX', shortcut_ro = '', value_description_en = 'yyy_Zement', value_description_de = 'Zement', value_description_fr = 'Ciment', value_description_it = 'Cemento', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4351);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4352) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGAA', value_name_en = 'DCGAA', shortcut_en = '', value_name_de = 'DCGAA', shortcut_de = '', value_name_fr = 'DCGAA', shortcut_fr = '', value_name_it = 'DCGAA', shortcut_it = '', value_name_ro = 'DCGAA', shortcut_ro = '', value_description_en = 'yyy_Zulauf Kreisprofil', value_description_de = 'Zulauf Kreisprofil', value_description_fr = 'Entrée de forme circulaire', value_description_it = 'Condotta in entrata profilo circolare', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4352);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4353) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGAB', value_name_en = 'DCGAB', shortcut_en = '', value_name_de = 'DCGAB', shortcut_de = '', value_name_fr = 'DCGAB', shortcut_fr = '', value_name_it = 'DCGAB', shortcut_it = '', value_name_ro = 'DCGAB', shortcut_ro = '', value_description_en = 'yyy_Ablauf Kreisprofil', value_description_de = 'Ablauf Kreisprofil', value_description_fr = 'Sortie de forme circulaire', value_description_it = 'Condotta in uscita profilo circolare', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4353);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4354) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGAC', value_name_en = 'DCGAC', shortcut_en = '', value_name_de = 'DCGAC', shortcut_de = '', value_name_fr = 'DCGAC', shortcut_fr = '', value_name_it = 'DCGAC', shortcut_it = '', value_name_ro = 'DCGAC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss Kreisprofil', value_description_de = 'Verschlossener Anschluss Kreisprofil', value_description_fr = 'Raccordement fermé de forme circulaire', value_description_it = 'Raccordo occluso profilo circolare', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4354);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4355) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGBA', value_name_en = 'DCGBA', shortcut_en = '', value_name_de = 'DCGBA', shortcut_de = '', value_name_fr = 'DCGBA', shortcut_fr = '', value_name_it = 'DCGBA', shortcut_it = '', value_name_ro = 'DCGBA', shortcut_ro = '', value_description_en = 'yyy_Zulauf Rechteckprofil', value_description_de = 'Zulauf Rechteckprofil', value_description_fr = 'Entrée de forme rectangulaire', value_description_it = 'Condotta in entrata profilo rettangolare', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4355);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4356) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGBB', value_name_en = 'DCGBB', shortcut_en = '', value_name_de = 'DCGBB', shortcut_de = '', value_name_fr = 'DCGBB', shortcut_fr = '', value_name_it = 'DCGBB', shortcut_it = '', value_name_ro = 'DCGBB', shortcut_ro = '', value_description_en = 'yyy_Ablauf Rechteckprofil', value_description_de = 'Ablauf Rechteckprofil', value_description_fr = 'Sortie de forme rectangulaire', value_description_it = 'Condotta in uscita profilo rettangolare', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4356);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4357) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGBC', value_name_en = 'DCGBC', shortcut_en = '', value_name_de = 'DCGBC', shortcut_de = '', value_name_fr = 'DCGBC', shortcut_fr = '', value_name_it = 'DCGBC', shortcut_it = '', value_name_ro = 'DCGBC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss Rechteckprofil', value_description_de = 'Verschlossener Anschluss Rechteckprofil', value_description_fr = 'Raccordement fermé de forme rectangulaire', value_description_it = 'Raccordo occluso profilo rettangolare', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4357);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4358) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGCA', value_name_en = 'DCGCA', shortcut_en = '', value_name_de = 'DCGCA', shortcut_de = '', value_name_fr = 'DCGCA', shortcut_fr = '', value_name_it = 'DCGCA', shortcut_it = '', value_name_ro = 'DCGCA', shortcut_ro = '', value_description_en = 'yyy_Zulauf Eiprofil', value_description_de = 'Zulauf Eiprofil', value_description_fr = 'Entrée de forme ovoïde', value_description_it = 'Condotta in entrata profilo ovoidale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4358);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4359) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGCB', value_name_en = 'DCGCB', shortcut_en = '', value_name_de = 'DCGCB', shortcut_de = '', value_name_fr = 'DCGCB', shortcut_fr = '', value_name_it = 'DCGCB', shortcut_it = '', value_name_ro = 'DCGCB', shortcut_ro = '', value_description_en = 'yyy_Ablauf Eiprofil', value_description_de = 'Ablauf Eiprofil', value_description_fr = 'Sortie ovoïde', value_description_it = 'Condotta in uscita profilo ovoidale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4359);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4360) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGCC', value_name_en = 'DCGCC', shortcut_en = '', value_name_de = 'DCGCC', shortcut_de = '', value_name_fr = 'DCGCC', shortcut_fr = '', value_name_it = 'DCGCC', shortcut_it = '', value_name_ro = 'DCGCC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss Eiprofil', value_description_de = 'Verschlossener Anschluss Eiprofil', value_description_fr = 'Raccordement fermé ovoïde', value_description_it = 'Raccordo occluso profilo ovoidale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4360);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4364) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXAA', value_name_en = 'DCGXAA', shortcut_en = '', value_name_de = 'DCGXAA', shortcut_de = '', value_name_fr = 'DCGXAA', shortcut_fr = '', value_name_it = 'DCGXAA', shortcut_it = '', value_name_ro = 'DCGXAA', shortcut_ro = '', value_description_en = 'yyy_Zulauf  Spezialprofil', value_description_de = 'Zulauf  Spezialprofil', value_description_fr = 'Entrée de forme spéciale', value_description_it = 'Condotta in entrata profilo speciale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4364);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4365) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXAB', value_name_en = 'DCGXAB', shortcut_en = '', value_name_de = 'DCGXAB', shortcut_de = '', value_name_fr = 'DCGXAB', shortcut_fr = '', value_name_it = 'DCGXAB', shortcut_it = '', value_name_ro = 'DCGXAB', shortcut_ro = '', value_description_en = 'yyy_Ablauf  Spezialprofil', value_description_de = 'Ablauf  Spezialprofil', value_description_fr = 'Sortie de forme spéciale', value_description_it = 'Condotta in uscita profilo speciale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4365);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4366) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXAC', value_name_en = 'DCGXAC', shortcut_en = '', value_name_de = 'DCGXAC', shortcut_de = '', value_name_fr = 'DCGXAC', shortcut_fr = '', value_name_it = 'DCGXAC', shortcut_it = '', value_name_ro = 'DCGXAC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss Spezialprofil', value_description_de = 'Verschlossener Anschluss Spezialprofil', value_description_fr = 'Raccordement fermé de forme spéciale', value_description_it = 'Raccordo occluso profilo speciale', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4366);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4367) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXBA', value_name_en = 'DCGXBA', shortcut_en = '', value_name_de = 'DCGXBA', shortcut_de = '', value_name_fr = 'DCGXBA', shortcut_fr = '', value_name_it = 'DCGXBA', shortcut_it = '', value_name_ro = 'DCGXBA', shortcut_ro = '', value_description_en = 'yyy_Zulauf  Maulprofil', value_description_de = 'Zulauf  Maulprofil', value_description_fr = 'Entrée de forme fer à cheval', value_description_it = 'Condotta in entrata profilo ellittico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4367);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4368) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXBB', value_name_en = 'DCGXBB', shortcut_en = '', value_name_de = 'DCGXBB', shortcut_de = '', value_name_fr = 'DCGXBB', shortcut_fr = '', value_name_it = 'DCGXBB', shortcut_it = '', value_name_ro = 'DCGXBB', shortcut_ro = '', value_description_en = 'yyy_Ablauf  Maulprofil', value_description_de = 'Ablauf  Maulprofil', value_description_fr = 'Sortie de forme fer à cheval', value_description_it = 'Condotta in uscita profilo ellittico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4368);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4369) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXBC', value_name_en = 'DCGXBC', shortcut_en = '', value_name_de = 'DCGXBC', shortcut_de = '', value_name_fr = 'DCGXBC', shortcut_fr = '', value_name_it = 'DCGXBC', shortcut_it = '', value_name_ro = 'DCGXBC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss Maulprofil', value_description_de = 'Verschlossener Anschluss Maulprofil', value_description_fr = 'Raccordement fermé de forme fer à cheval', value_description_it = 'Raccordo occluso profilo ellittico', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4369);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4370) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXCA', value_name_en = 'DCGXCA', shortcut_en = '', value_name_de = 'DCGXCA', shortcut_de = '', value_name_fr = 'DCGXCA', shortcut_fr = '', value_name_it = 'DCGXCA', shortcut_it = '', value_name_ro = 'DCGXCA', shortcut_ro = '', value_description_en = 'yyy_Zulauf  offenes Profil', value_description_de = 'Zulauf  offenes Profil', value_description_fr = 'Entrée de forme ouverte', value_description_it = 'Condotta in entrata profilo aperto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4370);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4371) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXCB', value_name_en = 'DCGXCB', shortcut_en = '', value_name_de = 'DCGXCB', shortcut_de = '', value_name_fr = 'DCGXCB', shortcut_fr = '', value_name_it = 'DCGXCB', shortcut_it = '', value_name_ro = 'DCGXCB', shortcut_ro = '', value_description_en = 'yyy_Ablauf  offenes Profil', value_description_de = 'Ablauf  offenes Profil', value_description_fr = 'Sortie de forme ouverte', value_description_it = 'Condotta in uscita profilo aperto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4371);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4372) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGXCC', value_name_en = 'DCGXCC', shortcut_en = '', value_name_de = 'DCGXCC', shortcut_de = '', value_name_fr = 'DCGXCC', shortcut_fr = '', value_name_it = 'DCGXCC', shortcut_it = '', value_name_ro = 'DCGXCC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss offenes Profil', value_description_de = 'Verschlossener Anschluss offenes Profil', value_description_fr = 'Raccordement fermé de forme ouverte', value_description_it = 'Raccordo occluso profilo aperto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4372);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4373) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGYA', value_name_en = 'DCGYA', shortcut_en = '', value_name_de = 'DCGYA', shortcut_de = '', value_name_fr = 'DCGYA', shortcut_fr = '', value_name_it = 'DCGYA', shortcut_it = '', value_name_ro = 'DCGYA', shortcut_ro = '', value_description_en = 'yyy_Zulauf  Profil unbekannt', value_description_de = 'Zulauf  Profil unbekannt', value_description_fr = 'Entrée de forme inconnue', value_description_it = 'Condotta in entrata profilo ignoto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4373);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4374) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGYB', value_name_en = 'DCGYB', shortcut_en = '', value_name_de = 'DCGYB', shortcut_de = '', value_name_fr = 'DCGYB', shortcut_fr = '', value_name_it = 'DCGYB', shortcut_it = '', value_name_ro = 'DCGYB', shortcut_ro = '', value_description_en = 'yyy_Ablauf  Profil unbekannt', value_description_de = 'Ablauf  Profil unbekannt', value_description_fr = 'Sortie de forme inconnue', value_description_it = 'Condotta in uscita profilo ignoto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4374);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4375) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGYC', value_name_en = 'DCGYC', shortcut_en = '', value_name_de = 'DCGYC', shortcut_de = '', value_name_fr = 'DCGYC', shortcut_fr = '', value_name_it = 'DCGYC', shortcut_it = '', value_name_ro = 'DCGYC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss Profil unbekannt', value_description_de = 'Verschlossener Anschluss Profil unbekannt', value_description_fr = 'Raccordement fermé de forme inconnue', value_description_it = 'Raccordo occluso profilo ignoto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4375);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4376) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGZA', value_name_en = 'DCGZA', shortcut_en = '', value_name_de = 'DCGZA', shortcut_de = '', value_name_fr = 'DCGZA', shortcut_fr = '', value_name_it = 'DCGZA', shortcut_it = '', value_name_ro = 'DCGZA', shortcut_ro = '', value_description_en = 'yyy_Zulauf anderes Profil', value_description_de = 'Zulauf anderes Profil', value_description_fr = 'Entrée d’une autre forme', value_description_it = 'Condotta in entrata altro profilo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4376);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4377) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGZB', value_name_en = 'DCGZB', shortcut_en = '', value_name_de = 'DCGZB', shortcut_de = '', value_name_fr = 'DCGZB', shortcut_fr = '', value_name_it = 'DCGZB', shortcut_it = '', value_name_ro = 'DCGZB', shortcut_ro = '', value_description_en = 'yyy_Ablauf anderes Profil', value_description_de = 'Ablauf anderes Profil', value_description_fr = 'Sortie d’une autre forme', value_description_it = 'Condotta in uscita altro profilo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4377);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4378) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCGZC', value_name_en = 'DCGZC', shortcut_en = '', value_name_de = 'DCGZC', shortcut_de = '', value_name_fr = 'DCGZC', shortcut_fr = '', value_name_it = 'DCGZC', shortcut_it = '', value_name_ro = 'DCGZC', shortcut_ro = '', value_description_en = 'yyy_Verschlossener Anschluss anderes Profil', value_description_de = 'Verschlossener Anschluss anderes Profil', value_description_fr = 'Raccordement fermé d’une autre forme', value_description_it = 'Raccordo occluso altro profilo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4378);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4379) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCHA', value_name_en = 'DCHA', shortcut_en = '', value_name_de = 'DCHA', shortcut_de = '', value_name_fr = 'DCHA', shortcut_fr = '', value_name_it = 'DCHA', shortcut_it = '', value_name_ro = 'DCHA', shortcut_ro = '', value_description_en = 'yyy_Bankett mangelhaft', value_description_de = 'Bankett mangelhaft', value_description_fr = 'Banquette défectueuse', value_description_it = 'Banchina difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4379);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4382) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCHB', value_name_en = 'DCHB', shortcut_en = '', value_name_de = 'DCHB', shortcut_de = '', value_name_fr = 'DCHB', shortcut_fr = '', value_name_it = 'DCHB', shortcut_it = '', value_name_ro = 'DCHB', shortcut_ro = '', value_description_en = 'yyy_Bakett nicht mangelhaft', value_description_de = 'Bakett nicht mangelhaft', value_description_fr = 'Banquette en état', value_description_it = 'Banchina non difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4382);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4384) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIB', value_name_en = 'DCIB', shortcut_en = '', value_name_de = 'DCIB', shortcut_de = '', value_name_fr = 'DCIB', shortcut_fr = '', value_name_it = 'DCIB', shortcut_it = '', value_name_ro = 'DCIB', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne', value_description_de = 'Durchlaufrinne', value_description_fr = 'Cunette', value_description_it = 'Cunetta passante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4384);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4385) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCLAA', value_name_en = 'DCLAA', shortcut_en = '', value_name_de = 'DCLAA', shortcut_de = '', value_name_fr = 'DCLAA', shortcut_fr = '', value_name_it = 'DCLAA', shortcut_it = '', value_name_ro = 'DCLAA', shortcut_ro = '', value_description_en = 'yyy_ Rohrdurchführung ohne Öffnungsmöglichkeit, schadhaft', value_description_de = 'Rohrdurchführung ohne Öffnungsmöglichkeit, schadhaft', value_description_fr = 'Canalisation fermée sans accès, défectueuse', value_description_it = 'Tubazione passante senza possibilità d’apertura, difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4385);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4386) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCLAB', value_name_en = 'DCLAB', shortcut_en = '', value_name_de = 'DCLAB', shortcut_de = '', value_name_fr = 'DCLAB', shortcut_fr = '', value_name_it = 'DCLAB', shortcut_it = '', value_name_ro = 'DCLAB', shortcut_ro = '', value_description_en = 'yyy_ Rohrdurchführung ohne Öffnungsmöglichkeit', value_description_de = 'Rohrdurchführung ohne Öffnungsmöglichkeit', value_description_fr = 'Canalisation fermée sans accès', value_description_it = 'Tubazione passante senza possibilità d’apertura', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4386);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4387) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCLBA', value_name_en = 'DCLBA', shortcut_en = '', value_name_de = 'DCLBA', shortcut_de = '', value_name_fr = 'DCLBA', shortcut_fr = '', value_name_it = 'DCLBA', shortcut_it = '', value_name_ro = 'DCLBA', shortcut_ro = '', value_description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit, schadhaft', value_description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit, schadhaft', value_description_fr = 'Canalisation fermée avec accès, défectueuse', value_description_it = 'Tubazione passante con possibilità d’apertura, difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4387);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4388) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCLBB', value_name_en = 'DCLBB', shortcut_en = '', value_name_de = 'DCLBB', shortcut_de = '', value_name_fr = 'DCLBB', shortcut_fr = '', value_name_it = 'DCLBB', shortcut_it = '', value_name_ro = 'DCLBB', shortcut_ro = '', value_description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit', value_description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit', value_description_fr = 'Canalisation fermée avec accès', value_description_it = 'Tubazione passante con possibilità d’apertura', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4388);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4389) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCLCA', value_name_en = 'DCLCA', shortcut_en = '', value_name_de = 'DCLCA', shortcut_de = '', value_name_fr = 'DCLCA', shortcut_fr = '', value_name_it = 'DCLCA', shortcut_it = '', value_name_ro = 'DCLCA', shortcut_ro = '', value_description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt, schadhaft', value_description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt, schadhaft', value_description_fr = 'Canalisation fermée avec accès, fermeture manquant, défectueux', value_description_it = 'Tubazione passante con possibilità d’apertura, coperchio mancante, difettosa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4389);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4390) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCLCB', value_name_en = 'DCLCB', shortcut_en = '', value_name_de = 'DCLCB', shortcut_de = '', value_name_fr = 'DCLCB', shortcut_fr = '', value_name_it = 'DCLCB', shortcut_it = '', value_name_ro = 'DCLCB', shortcut_ro = '', value_description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt', value_description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt', value_description_fr = 'Canalisation fermée avec accès, tampon manquant', value_description_it = 'Tubazione passante con possibilità d’apertura, coperchio mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4390);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4391) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCMA', value_name_en = 'DCMA', shortcut_en = '', value_name_de = 'DCMA', shortcut_de = '', value_name_fr = 'DCMA', shortcut_fr = '', value_name_it = 'DCMA', shortcut_it = '', value_name_ro = 'DCMA', shortcut_ro = '', value_description_en = 'yyy_Schlammeimer vorhanden', value_description_de = 'Schlammeimer vorhanden', value_description_fr = 'sac à boues présent', value_description_it = 'Secchio raccolta fango presente', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4391);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4392) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCMB', value_name_en = 'DCMB', shortcut_en = '', value_name_de = 'DCMB', shortcut_de = '', value_name_fr = 'DCMB', shortcut_fr = '', value_name_it = 'DCMB', shortcut_it = '', value_name_ro = 'DCMB', shortcut_ro = '', value_description_en = 'yyy_Schlammeimer fehlt', value_description_de = 'Schlammeimer fehlt', value_description_fr = 'sac à boues manquant', value_description_it = 'Secchio raccolta fango mancante', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4392);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4393) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCMC', value_name_en = 'DCMC', shortcut_en = '', value_name_de = 'DCMC', shortcut_de = '', value_name_fr = 'DCMC', shortcut_fr = '', value_name_it = 'DCMC', shortcut_it = '', value_name_ro = 'DCMC', shortcut_ro = '', value_description_en = 'yyy_Schlammeimer defekt', value_description_de = 'Schlammeimer defekt', value_description_fr = 'sac à boues défectueux', value_description_it = 'Secchio raccolta fango difettoso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4393);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4394) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDA', value_name_en = 'DDA', shortcut_en = '', value_name_de = 'DDA', shortcut_de = '', value_name_fr = 'DDA', shortcut_fr = '', value_name_it = 'DDA', shortcut_it = '', value_name_ro = 'DDA', shortcut_ro = '', value_description_en = 'yyy_Allgemeinzustand, Fotobeispiel', value_description_de = 'Allgemeinzustand, Fotobeispiel', value_description_fr = 'Etat général, exemple de photo', value_description_it = 'Stato generale, esempio foto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4394);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4395) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDB', value_name_en = 'DDB', shortcut_en = '', value_name_de = 'DDB', shortcut_de = '', value_name_fr = 'DDB', shortcut_fr = '', value_name_it = 'DDB', shortcut_it = '', value_name_ro = 'DDB', shortcut_ro = '', value_description_en = 'yyy_    <kein Text>', value_description_de = '<kein Text>', value_description_fr = '<aucun texte>', value_description_it = 'Inserimento di testo libero per la descrizione di rilievi altrimenti non codificabili', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4395);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4401) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDD', value_name_en = 'DDD', shortcut_en = '', value_name_de = 'DDD', shortcut_de = '', value_name_fr = 'DDD', shortcut_fr = '', value_name_it = 'DDD', shortcut_it = '', value_name_ro = 'DDD', shortcut_ro = '', value_description_en = 'yyy_Niveau Wasserspiegel', value_description_de = 'Niveau Wasserspiegel', value_description_fr = 'Niveau d’eau', value_description_it = 'Livello dell’acqua', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4401);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4402) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEAA', value_name_en = 'DDEAA', shortcut_en = '', value_name_de = 'DDEAA', shortcut_de = '', value_name_fr = 'DDEAA', shortcut_fr = '', value_name_it = 'DDEAA', shortcut_it = '', value_name_ro = 'DDEAA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_de = 'Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_fr = 'Mauvais raccordement, arrivées d''eaux claires, des eaux usées se déversent dans une canalisation d’eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue limpido, acque reflue entrano in acque meteoriche', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4402);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4403) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEAB', value_name_en = 'DDEAB', shortcut_en = '', value_name_de = 'DDEAB', shortcut_de = '', value_name_fr = 'DDEAB', shortcut_fr = '', value_name_it = 'DDEAB', shortcut_it = '', value_name_ro = 'DDEAB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_de = 'Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux claires, des eaux pluviales se déversent dans une canalisation d’eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue limpido, acque meteoriche entrano in acque reflue', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4403);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4404) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEAC', value_name_en = 'DDEAC', shortcut_en = '', value_name_de = 'DDEAC', shortcut_de = '', value_name_fr = 'DDEAC', shortcut_fr = '', value_name_it = 'DDEAC', shortcut_it = '', value_name_ro = 'DDEAC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss klar', value_description_de = 'Abwasserzufluss klar', value_description_fr = 'Arrivées d’eaux claires', value_description_it = 'Afflusso acque reflue limpido', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4404);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4408) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEYA', value_name_en = 'DDEYA', shortcut_en = '', value_name_de = 'DDEYA', shortcut_de = '', value_name_fr = 'DDEYA', shortcut_fr = '', value_name_it = 'DDEYA', shortcut_it = '', value_name_ro = 'DDEYA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_de = 'Fehlanschluss, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_fr = 'Mauvais raccordement, des eaux usées se déversent dans une canalisation d’eaux pluviales', value_description_it = 'Collegamento errato, acque reflue entrano in acque meteoriche', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4408);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4409) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEYB', value_name_en = 'DDEYB', shortcut_en = '', value_name_de = 'DDEYB', shortcut_de = '', value_name_fr = 'DDEYB', shortcut_fr = '', value_name_it = 'DDEYB', shortcut_it = '', value_name_ro = 'DDEYB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Regenabwasser fliesst in Schmutzabwasserleitung', value_description_de = 'Fehlanschluss, Regenabwasser fliesst in Schmutzabwasserleitung', value_description_fr = 'Mauvais raccordement, des eaux pluviales se déversent dans une canalisation d’eaux usées', value_description_it = 'Collegamento errato, acque meteoriche entrano in acque reflue', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4409);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4410) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEYY', value_name_en = 'DDEYY', shortcut_en = '', value_name_de = 'DDEYY', shortcut_de = '', value_name_fr = 'DDEYY', shortcut_fr = '', value_name_it = 'DDEYY', shortcut_it = '', value_name_ro = 'DDEYY', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss', value_description_de = 'Abwasserzufluss', value_description_fr = 'Arrivées d’eaux usées', value_description_it = 'Afflusso acque reflue', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4410);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4411) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDFA', value_name_en = 'DDFA', shortcut_en = '', value_name_de = 'DDFA', shortcut_de = '', value_name_fr = 'DDFA', shortcut_fr = '', value_name_it = 'DDFA', shortcut_it = '', value_name_ro = 'DDFA', shortcut_ro = '', value_description_en = 'yyy_Gefährdung vorhanden: Sauerstoffmangel', value_description_de = 'Gefährdung vorhanden: Sauerstoffmangel', value_description_fr = 'Danger existant: manque d’oxygène', value_description_it = 'Atmosfera pericolosa: mancanza di ossigeno', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4411);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4412) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDFB', value_name_en = 'DDFB', shortcut_en = '', value_name_de = 'DDFB', shortcut_de = '', value_name_fr = 'DDFB', shortcut_fr = '', value_name_it = 'DDFB', shortcut_it = '', value_name_ro = 'DDFB', shortcut_ro = '', value_description_en = 'yyy_Gefährdung vorhanden: Schwefelwasserstoff', value_description_de = 'Gefährdung vorhanden: Schwefelwasserstoff', value_description_fr = 'Danger existant: hydrogène sulfuré', value_description_it = 'Atmosfera pericolosa: idrogeno solforato', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4412);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4413) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDFC', value_name_en = 'DDFC', shortcut_en = '', value_name_de = 'DDFC', shortcut_de = '', value_name_fr = 'DDFC', shortcut_fr = '', value_name_it = 'DDFC', shortcut_it = '', value_name_ro = 'DDFC', shortcut_ro = '', value_description_en = 'yyy_Gefährdung vorhanden: Methan', value_description_de = 'Gefährdung vorhanden: Methan', value_description_fr = 'Danger existant: méthane', value_description_it = 'Atmosfera pericolosa: metano', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4413);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4414) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDFZ', value_name_en = 'DDFZ', shortcut_en = '', value_name_de = 'DDFZ', shortcut_de = '', value_name_fr = 'DDFZ', shortcut_fr = '', value_name_it = 'DDFZ', shortcut_it = '', value_name_ro = 'DDFZ', shortcut_ro = '', value_description_en = 'yyy_Andersartige Gefährdung vorhanden', value_description_de = 'Andersartige Gefährdung vorhanden', value_description_fr = 'Autres dangers présents ', value_description_it = 'Altri pericoli (ulteriori dettagli sono richiesti nella nota)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4414);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4416) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDGA', value_name_en = 'DDGA', shortcut_en = '', value_name_de = 'DDGA', shortcut_de = '', value_name_fr = 'DDGA', shortcut_fr = '', value_name_it = 'DDGA', shortcut_it = '', value_name_ro = 'DDGA', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, Kamera unter Wasser', value_description_de = 'Keine Sicht, Kamera unter Wasser', value_description_fr = 'Absence de visibilité, caméra sous l’eau', value_description_it = 'Nessuna visibilità, telecamera immersa', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4416);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4417) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDGB', value_name_en = 'DDGB', shortcut_en = '', value_name_de = 'DDGB', shortcut_de = '', value_name_fr = 'DDGB', shortcut_fr = '', value_name_it = 'DDGB', shortcut_it = '', value_name_ro = 'DDGB', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, Verschlammung', value_description_de = 'Keine Sicht, Verschlammung', value_description_fr = 'Absence de visibilité, vase', value_description_it = 'Nessuna visibilità, deposito fangoso', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4417);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4418) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDGC', value_name_en = 'DDGC', shortcut_en = '', value_name_de = 'DDGC', shortcut_de = '', value_name_fr = 'DDGC', shortcut_fr = '', value_name_it = 'DDGC', shortcut_it = '', value_name_ro = 'DDGC', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht, Dampf', value_description_de = 'Keine Sicht, Dampf', value_description_fr = 'Absence de visibilité, vapeur', value_description_it = 'Nessuna visibilità, vapore', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4418);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,4419) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDGZ', value_name_en = 'DDGZ', shortcut_en = '', value_name_de = 'DDGZ', shortcut_de = '', value_name_fr = 'DDGZ', shortcut_fr = '', value_name_it = 'DDGZ', shortcut_it = '', value_name_ro = 'DDGZ', shortcut_ro = '', value_description_en = 'yyy_Keine Sicht', value_description_de = 'Keine Sicht', value_description_fr = 'Absence de visibilité', value_description_it = 'Nessuna visibilità, altri motivi (ulteriori dettagli sono richiesti nella nota)', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 4419);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8909) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABAE', value_name_en = 'DABAE', shortcut_en = '', value_name_de = 'DABAE', shortcut_de = '', value_name_fr = 'DABAE', shortcut_fr = '', value_name_it = 'DABAE', shortcut_it = '', value_name_ro = 'DABAE', shortcut_ro = '', value_description_en = 'yyy_Oberflächenriss (Haarriss), sternförmig Rissbildung', value_description_de = 'Oberflächenriss (Haarriss), sternförmig Rissbildung', value_description_fr = 'Fissure superficielle (microfissure), fissuration en étoile', value_description_it = 'Fessura superficiale (fessura capillare), fessurazione a stella', value_description_ro = 'rrr_Oberflächenriss (Haarriss), sternförmig Rissbildung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8909);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8910) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABBE', value_name_en = 'DABBE', shortcut_en = '', value_name_de = 'DABBE', shortcut_de = '', value_name_fr = 'DABBE', shortcut_fr = '', value_name_it = 'DABBE', shortcut_it = '', value_name_ro = 'DABBE', shortcut_ro = '', value_description_en = 'yyy_Riss, sternförmige Rissbildung', value_description_de = 'Riss, sternförmige Rissbildung', value_description_fr = 'Fissure, fissuration en étoile', value_description_it = 'Spaccatura, fessurazione a stella', value_description_ro = 'rrr_Riss, sternförmige Rissbildung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8910);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8911) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DABCE', value_name_en = 'DABCE', shortcut_en = '', value_name_de = 'DABCE', shortcut_de = '', value_name_fr = 'DABCE', shortcut_fr = '', value_name_it = 'DABCE', shortcut_it = '', value_name_ro = 'DABCE', shortcut_ro = '', value_description_en = 'yyy_Klaffender Riss, sternförmige Rissbildung', value_description_de = 'Klaffender Riss, sternförmige Rissbildung', value_description_fr = 'Fissure béante, fissuration en étoile', value_description_it = 'Frattura aperta, fessurazione a stella', value_description_ro = 'rrr_Klaffender Riss, sternförmige Rissbildung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8911);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8912) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFAZ', value_name_en = 'DAFAZ', shortcut_en = '', value_name_de = 'DAFAZ', shortcut_de = '', value_name_fr = 'DAFAZ', shortcut_fr = '', value_name_it = 'DAFAZ', shortcut_it = '', value_name_ro = 'DAFAZ', shortcut_ro = '', value_description_en = 'yyy_Erhöhte Rauheit, andere Ursache', value_description_de = 'Erhöhte Rauheit, andere Ursache', value_description_fr = 'Paroi de la canalisation rugueuse, autre cause, (plus de détails requis dans la note)', value_description_it = 'Parete del tubo ruvida per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Erhöhte Rauheit, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8912);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8913) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFBZ', value_name_en = 'DAFBZ', shortcut_en = '', value_name_de = 'DAFBZ', shortcut_de = '', value_name_fr = 'DAFBZ', shortcut_fr = '', value_name_it = 'DAFBZ', shortcut_it = '', value_name_ro = 'DAFBZ', shortcut_ro = '', value_description_en = 'yyy_Abplatzung, andere Ursache', value_description_de = 'Abplatzung, andere Ursache', value_description_fr = 'Écaillage, autre cause', value_description_it = 'Sfaldamento per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Abplatzung, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8913);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8914) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFCZ', value_name_en = 'DAFCZ', shortcut_en = '', value_name_de = 'DAFCZ', shortcut_de = '', value_name_fr = 'DAFCZ', shortcut_fr = '', value_name_it = 'DAFCZ', shortcut_it = '', value_name_ro = 'DAFCZ', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe sichtbar, andere Ursache', value_description_de = 'Zuschlagstoffe sichtbar, andere Ursache', value_description_fr = 'Agrégats visibles, autre cause', value_description_it = 'Materiale inerte visibile per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Zuschlagstoffe sichtbar, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8914);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8915) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFDZ', value_name_en = 'DAFDZ', shortcut_en = '', value_name_de = 'DAFDZ', shortcut_de = '', value_name_fr = 'DAFDZ', shortcut_fr = '', value_name_it = 'DAFDZ', shortcut_it = '', value_name_ro = 'DAFDZ', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe einragend, andere Ursache', value_description_de = 'Zuschlagstoffe einragend, andere Ursache', value_description_fr = 'Agrégats intrusifs, autre cause', value_description_it = 'Materiale inerte visibile per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Zuschlagstoffe einragend, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8915);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8916) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFEZ', value_name_en = 'DAFEZ', shortcut_en = '', value_name_de = 'DAFEZ', shortcut_de = '', value_name_fr = 'DAFEZ', shortcut_fr = '', value_name_it = 'DAFEZ', shortcut_it = '', value_name_ro = 'DAFEZ', shortcut_ro = '', value_description_en = 'yyy_Zuschlagstoffe fehlen, andere Ursache', value_description_de = 'Zuschlagstoffe fehlen, andere Ursache', value_description_fr = 'Agrégats manquants, autre cause ', value_description_it = 'Materiale inerte sporgente per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Zuschlagstoffe fehlen, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8916);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8917) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFFZ', value_name_en = 'DAFFZ', shortcut_en = '', value_name_de = 'DAFFZ', shortcut_de = '', value_name_fr = 'DAFFZ', shortcut_fr = '', value_name_it = 'DAFFZ', shortcut_it = '', value_name_ro = 'DAFFZ', shortcut_ro = '', value_description_en = 'yyy_Bewehrung sichtbar, andere Ursache', value_description_de = 'Bewehrung sichtbar, andere Ursache', value_description_fr = 'Armature visible, autre cause', value_description_it = 'Armatura visibile per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Bewehrung sichtbar, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8917);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8918) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFGZ', value_name_en = 'DAFGZ', shortcut_en = '', value_name_de = 'DAFGZ', shortcut_de = '', value_name_fr = 'DAFGZ', shortcut_fr = '', value_name_it = 'DAFGZ', shortcut_it = '', value_name_ro = 'DAFGZ', shortcut_ro = '', value_description_en = 'yyy_Bewehrung einragend, andere Ursache', value_description_de = 'Bewehrung einragend, andere Ursache', value_description_fr = 'Armature dépassant de la surface, autre cause', value_description_it = 'Armatura sporgente per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Bewehrung einragend, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8918);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8919) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFIZ', value_name_en = 'DAFIZ', shortcut_en = '', value_name_de = 'DAFIZ', shortcut_de = '', value_name_fr = 'DAFIZ', shortcut_fr = '', value_name_it = 'DAFIZ', shortcut_it = '', value_name_ro = 'DAFIZ', shortcut_ro = '', value_description_en = 'yyy_Fehlende Wand, andere Ursache', value_description_de = 'Fehlende Wand, andere Ursache', value_description_fr = 'Paroi manquante, autre cause', value_description_it = 'Parete mancante per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Fehlende Wand, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8919);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8920) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFJZ', value_name_en = 'DAFJZ', shortcut_en = '', value_name_de = 'DAFJZ', shortcut_de = '', value_name_fr = 'DAFJZ', shortcut_fr = '', value_name_it = 'DAFJZ', shortcut_it = '', value_name_ro = 'DAFJZ', shortcut_ro = '', value_description_en = 'yyy_Korrosion, andere Ursache', value_description_de = 'Korrosion, andere Ursache', value_description_fr = 'Corrosion, autre cause ', value_description_it = 'Corrosione per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Korrosion, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8920);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8921) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFKA', value_name_en = 'DAFKA', shortcut_en = '', value_name_de = 'DAFKA', shortcut_de = '', value_name_fr = 'DAFKA', shortcut_fr = '', value_name_it = 'DAFKA', shortcut_it = '', value_name_ro = 'DAFKA', shortcut_ro = '', value_description_en = 'yyy_Beule durch mechanische Beschädigung', value_description_de = 'Beule durch mechanische Beschädigung', value_description_fr = 'Bosse due à des dommages mécaniques', value_description_it = 'Protuberanza per danno meccanico', value_description_ro = 'rrr_Beule durch mechanische Beschädigung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8921);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8922) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFKE', value_name_en = 'DAFKE', shortcut_en = '', value_name_de = 'DAFKE', shortcut_de = '', value_name_fr = 'DAFKE', shortcut_fr = '', value_name_it = 'DAFKE', shortcut_it = '', value_name_ro = 'DAFKE', shortcut_ro = '', value_description_en = 'yyy_Beule, Schadensursache nicht feststellbar', value_description_de = 'Beule, Schadensursache nicht feststellbar', value_description_fr = 'Bosse, cause pas clairement identifiable', value_description_it = 'Protuberanza per cause non evidenti', value_description_ro = 'rrr_Beule, Schadensursache nicht feststellbar'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8922);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8923) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFKZ', value_name_en = 'DAFKZ', shortcut_en = '', value_name_de = 'DAFKZ', shortcut_de = '', value_name_fr = 'DAFKZ', shortcut_fr = '', value_name_it = 'DAFKZ', shortcut_it = '', value_name_ro = 'DAFKZ', shortcut_ro = '', value_description_en = 'yyy_Beule, andere Ursache', value_description_de = 'Beule, andere Ursache', value_description_fr = 'Bosse, autre cause', value_description_it = 'Protuberanza per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Beule, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8923);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8924) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAFZZ', value_name_en = 'DAFZZ', shortcut_en = '', value_name_de = 'DAFZZ', shortcut_de = '', value_name_fr = 'DAFZZ', shortcut_fr = '', value_name_it = 'DAFZZ', shortcut_it = '', value_name_ro = 'DAFZZ', shortcut_ro = '', value_description_en = 'yyy_Anderer Oberflächenschaden, andere Ursache', value_description_de = 'Anderer Oberflächenschaden, andere Ursache', value_description_fr = 'Autre dégradation de surface, autre cause', value_description_it = 'Altri danni superficiali, per altre cause (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Anderer Oberflächenschaden, andere Ursache'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8924);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8925) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKDD', value_name_en = 'DAKDD', shortcut_en = '', value_name_de = 'DAKDD', shortcut_de = '', value_name_fr = 'DAKDD', shortcut_fr = '', value_name_it = 'DAKDD', shortcut_it = '', value_name_ro = 'DAKDD', shortcut_ro = '', value_description_en = 'yyy_Spiralförmige Faltenbildung in der Auskleidung', value_description_de = 'Spiralförmige Faltenbildung in der Auskleidung', value_description_fr = 'Revêtement ondulé en forme de spirale', value_description_it = 'Rivestimento con grinze/pieghe elicoidali', value_description_ro = 'rrr_Spiralförmige Faltenbildung in der Auskleidung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8925);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8926) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKF', value_name_en = 'DAKF', shortcut_en = '', value_name_de = 'DAKF', shortcut_de = '', value_name_fr = 'DAKF', shortcut_fr = '', value_name_it = 'DAKF', shortcut_it = '', value_name_ro = 'DAKF', shortcut_ro = '', value_description_en = 'yyy_Beule derAuskleidung nach aussen', value_description_de = 'Beule derAuskleidung nach aussen', value_description_fr = 'Revêtement cloqué vers l’extérieur', value_description_it = 'Rivestimento con bolle verso esterno', value_description_ro = 'rrr_Beule derAuskleidung nach aussen'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8926);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8927) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKG', value_name_en = 'DAKG', shortcut_en = '', value_name_de = 'DAKG', shortcut_de = '', value_name_fr = 'DAKG', shortcut_fr = '', value_name_it = 'DAKG', shortcut_it = '', value_name_ro = 'DAKG', shortcut_ro = '', value_description_en = 'yyy_Ablösen der Innenhaut / Beschichtung', value_description_de = 'Ablösen der Innenhaut / Beschichtung', value_description_fr = 'Décollement de la peau intérieure / du revêtement', value_description_it = 'Distacco della pellicola interna/rivestimento', value_description_ro = 'rrr_Ablösen der Innenhaut / Beschichtung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8927);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8928) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKH', value_name_en = 'DAKH', shortcut_en = '', value_name_de = 'DAKH', shortcut_de = '', value_name_fr = 'DAKH', shortcut_fr = '', value_name_it = 'DAKH', shortcut_it = '', value_name_ro = 'DAKH', shortcut_ro = '', value_description_en = 'yyy_Ablösen der Abdeckung der Verbindungsnaht', value_description_de = 'Ablösen der Abdeckung der Verbindungsnaht', value_description_fr = 'Décollement de la couture de connexion', value_description_it = 'Distacco della copertura della cucitura', value_description_ro = 'rrr_Ablösen der Abdeckung der Verbindungsnaht'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8928);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8929) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKI', value_name_en = 'DAKI', shortcut_en = '', value_name_de = 'DAKI', shortcut_de = '', value_name_fr = 'DAKI', shortcut_fr = '', value_name_it = 'DAKI', shortcut_it = '', value_name_ro = 'DAKI', shortcut_ro = '', value_description_en = 'yyy_Riss oder Spalt in der Innenauskleidung', value_description_de = 'Riss oder Spalt in der Innenauskleidung', value_description_fr = 'Fissure ou espace dans la doublure intérieure (y compris la soudure défectueuse)', value_description_it = 'Fessura o spaccatura del rivestimento (incl. saldatura difettosa)', value_description_ro = 'rrr_Riss oder Spalt in der Innenauskleidung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8929);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8930) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKJ', value_name_en = 'DAKJ', shortcut_en = '', value_name_de = 'DAKJ', shortcut_de = '', value_name_fr = 'DAKJ', shortcut_fr = '', value_name_it = 'DAKJ', shortcut_it = '', value_name_ro = 'DAKJ', shortcut_ro = '', value_description_en = 'yyy_Loch in der Innauskleidung', value_description_de = 'Loch in der Innauskleidung', value_description_fr = 'Trou dans la doublure', value_description_it = 'Foro nel rivestimento', value_description_ro = 'rrr_Loch in der Innauskleidung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8930);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8931) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKK', value_name_en = 'DAKK', shortcut_en = '', value_name_de = 'DAKK', shortcut_de = '', value_name_fr = 'DAKK', shortcut_fr = '', value_name_it = 'DAKK', shortcut_it = '', value_name_ro = 'DAKK', shortcut_ro = '', value_description_en = 'yyy_Auskleidungsverbindung defekt', value_description_de = 'Auskleidungsverbindung defekt', value_description_fr = 'Connexion de la doublure défectueuse', value_description_it = 'Giuntura del rivestimento difettosa', value_description_ro = 'rrr_Auskleidungsverbindung defekt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8931);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8932) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKL', value_name_en = 'DAKL', shortcut_en = '', value_name_de = 'DAKL', shortcut_de = '', value_name_fr = 'DAKL', shortcut_fr = '', value_name_it = 'DAKL', shortcut_it = '', value_name_ro = 'DAKL', shortcut_ro = '', value_description_en = 'yyy_Auskleidungswerkstoff erscheint weich', value_description_de = 'Auskleidungswerkstoff erscheint weich', value_description_fr = 'Le matériau de la doublure semble mou', value_description_it = 'Materiale del rivestimento risulta molle', value_description_ro = 'rrr_Auskleidungswerkstoff erscheint weich'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8932);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8933) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKM', value_name_en = 'DAKM', shortcut_en = '', value_name_de = 'DAKM', shortcut_de = '', value_name_fr = 'DAKM', shortcut_fr = '', value_name_it = 'DAKM', shortcut_it = '', value_name_ro = 'DAKM', shortcut_ro = '', value_description_en = 'yyy_Harz fehlt im Laminat', value_description_de = 'Harz fehlt im Laminat', value_description_fr = 'La résine manque dans le stratifié', value_description_it = 'Manca la resina nel laminato', value_description_ro = 'rrr_Harz fehlt im Laminat'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8933);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8934) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DAKN', value_name_en = 'DAKN', shortcut_en = '', value_name_de = 'DAKN', shortcut_de = '', value_name_fr = 'DAKN', shortcut_fr = '', value_name_it = 'DAKN', shortcut_it = '', value_name_ro = 'DAKN', shortcut_ro = '', value_description_en = 'yyy_Ende der Auskleidung ist nicht abgedichtet', value_description_de = 'Ende der Auskleidung ist nicht abgedichtet', value_description_fr = 'Fin de la doublure non scellée', value_description_it = 'Estremità del rivestimento non sigillato', value_description_ro = 'rrr_Ende der Auskleidung ist nicht abgedichtet'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8934);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8935) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALC', value_name_en = 'DALC', shortcut_en = '', value_name_de = 'DALC', shortcut_de = '', value_name_fr = 'DALC', shortcut_fr = '', value_name_it = 'DALC', shortcut_it = '', value_name_ro = 'DALC', shortcut_ro = '', value_description_en = 'yyy_Reparaturwerkstoff löst sich von der Wand', value_description_de = 'Reparaturwerkstoff löst sich von der Wand', value_description_fr = 'Le matériau de réparation se décolle du mur', value_description_it = 'Materiale di riparazione si stacca dalla parete', value_description_ro = 'rrr_Reparaturwerkstoff löst sich von der Wand'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8935);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8936) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALD', value_name_en = 'DALD', shortcut_en = '', value_name_de = 'DALD', shortcut_de = '', value_name_fr = 'DALD', shortcut_fr = '', value_name_it = 'DALD', shortcut_it = '', value_name_ro = 'DALD', shortcut_ro = '', value_description_en = 'yyy_Reparaturwerkstoff fehlt an der Kontaktfläche', value_description_de = 'Reparaturwerkstoff fehlt an der Kontaktfläche', value_description_fr = 'Le matériau de réparation est manquant sur la surface de contact', value_description_it = 'Materiale di riparazione manca sulla superficie di contatto', value_description_ro = 'rrr_Reparaturwerkstoff fehlt an der Kontaktfläche'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8936);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8937) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALE', value_name_en = 'DALE', shortcut_en = '', value_name_de = 'DALE', shortcut_de = '', value_name_fr = 'DALE', shortcut_fr = '', value_name_it = 'DALE', shortcut_it = '', value_name_ro = 'DALE', shortcut_ro = '', value_description_en = 'yyy_Überschüssiger Reparaturwerkstoff, Hindernis', value_description_de = 'Überschüssiger Reparaturwerkstoff, Hindernis', value_description_fr = 'Excédent de matériel de réparation, obstacle', value_description_it = 'Materiale di riparazione in eccesso, ostacolo', value_description_ro = 'rrr_Überschüssiger Reparaturwerkstoff, Hindernis'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8937);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8938) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALF', value_name_en = 'DALF', shortcut_en = '', value_name_de = 'DALF', shortcut_de = '', value_name_fr = 'DALF', shortcut_fr = '', value_name_it = 'DALF', shortcut_it = '', value_name_ro = 'DALF', shortcut_ro = '', value_description_en = 'yyy_Loch im Reparaturwerkstoff', value_description_de = 'Loch im Reparaturwerkstoff', value_description_fr = 'Trou dans le matériau de réparation', value_description_it = 'Foro nel materiale di riparazione', value_description_ro = 'rrr_Loch im Reparaturwerkstoff'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8938);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8939) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DALG', value_name_en = 'DALG', shortcut_en = '', value_name_de = 'DALG', shortcut_de = '', value_name_fr = 'DALG', shortcut_fr = '', value_name_it = 'DALG', shortcut_it = '', value_name_ro = 'DALG', shortcut_ro = '', value_description_en = 'yyy_Riss im Reparaturwerkstoff, längs', value_description_de = 'Riss im Reparaturwerkstoff, längs', value_description_fr = 'Fissure dans le matériau de réparation, longitudinal', value_description_it = 'Fessura nel materiale di riparazione, longitudinale', value_description_ro = 'rrr_Riss im Reparaturwerkstoff, längs'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8939);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8940) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBD', value_name_en = 'DCBD', shortcut_en = '', value_name_de = 'DCBD', shortcut_de = '', value_name_fr = 'DCBD', shortcut_fr = '', value_name_it = 'DCBD', shortcut_it = '', value_name_ro = 'DCBD', shortcut_ro = '', value_description_en = 'yyy_Loch repariert', value_description_de = 'Loch repariert', value_description_fr = 'Trou réparé', value_description_it = 'Foro riparato', value_description_ro = 'rrr_Loch repariert'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8940);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8941) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBE', value_name_en = 'DCBE', shortcut_en = '', value_name_de = 'DCBE', shortcut_de = '', value_name_fr = 'DCBE', shortcut_fr = '', value_name_it = 'DCBE', shortcut_it = '', value_name_ro = 'DCBE', shortcut_ro = '', value_description_en = 'yyy_Reparatur, ortlich begrenzet Innenauskleidung des Anschlusses', value_description_de = 'Reparatur, ortlich begrenzet Innenauskleidung des Anschlusses', value_description_fr = 'Réparation, doublure du revêtement intérieur du raccordement localisé', value_description_it = 'Riparazione, puntuale del rivestimento interno dell’allacciamento (per es. cappuccio)', value_description_ro = 'rrr_Reparatur, ortlich begrenzet Innenauskleidung des Anschlusses'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8941);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8942) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCBF', value_name_en = 'DCBF', shortcut_en = '', value_name_de = 'DCBF', shortcut_de = '', value_name_fr = 'DCBF', shortcut_fr = '', value_name_it = 'DCBF', shortcut_it = '', value_name_ro = 'DCBF', shortcut_ro = '', value_description_en = 'yyy_Andersartige Reparatur des Anschlusses', value_description_de = 'Andersartige Reparatur des Anschlusses', value_description_fr = 'Réparation autre du raccordement', value_description_it = 'Diverso tipo di riparazione dell’allacciamento', value_description_ro = 'rrr_Andersartige Reparatur des Anschlusses'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8942);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8943) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCHC', value_name_en = 'DCHC', shortcut_en = '', value_name_de = 'DCHC', shortcut_de = '', value_name_fr = 'DCHC', shortcut_fr = '', value_name_it = 'DCHC', shortcut_it = '', value_name_ro = 'DCHC', shortcut_ro = '', value_description_en = 'yyy_Kein Bankett', value_description_de = 'Kein Bankett', value_description_fr = 'Pas de banquette', value_description_it = 'Banchina mancante', value_description_ro = 'rrr_Kein Bankett'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8943);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8944) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIAA', value_name_en = 'DCIAA', shortcut_en = '', value_name_de = 'DCIAA', shortcut_de = '', value_name_fr = 'DCIAA', shortcut_fr = '', value_name_it = 'DCIAA', shortcut_it = '', value_name_ro = 'DCIAA', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne mangelhaft, in Fliessrichtung verengt', value_description_de = 'Durchlaufrinne mangelhaft, in Fliessrichtung verengt', value_description_fr = 'Cunette défectueuse, étranglement dans le sens de l’écoulement', value_description_it = 'Cunetta passante difettosa, restringimento in direzione del flusso', value_description_ro = 'rrr_Durchlaufrinne mangelhaft, in Fliessrichtung verengt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8944);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8945) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIAB', value_name_en = 'DCIAB', shortcut_en = '', value_name_de = 'DCIAB', shortcut_de = '', value_name_fr = 'DCIAB', shortcut_fr = '', value_name_it = 'DCIAB', shortcut_it = '', value_name_ro = 'DCIAB', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne mangelhaft, in Fliessrichtung erweitert', value_description_de = 'Durchlaufrinne mangelhaft, in Fliessrichtung erweitert', value_description_fr = 'Cunette défectueuse, élargissement dans le sens de l’écoulement', value_description_it = 'Cunetta passante difettosa, dilatazione in direzione del flusso', value_description_ro = 'rrr_Durchlaufrinne mangelhaft, in Fliessrichtung erweitert'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8945);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8946) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIAC', value_name_en = 'DCIAC', shortcut_en = '', value_name_de = 'DCIAC', shortcut_de = '', value_name_fr = 'DCIAC', shortcut_fr = '', value_name_it = 'DCIAC', shortcut_it = '', value_name_ro = 'DCIAC', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne mangelhaft, Hochpunkt', value_description_de = 'Durchlaufrinne mangelhaft, Hochpunkt', value_description_fr = 'Cunette défectueuse, point haut', value_description_it = 'Cunetta passante difettosa, punto superiore', value_description_ro = 'rrr_Durchlaufrinne mangelhaft, Hochpunkt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8946);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8947) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIAD', value_name_en = 'DCIAD', shortcut_en = '', value_name_de = 'DCIAD', shortcut_de = '', value_name_fr = 'DCIAD', shortcut_fr = '', value_name_it = 'DCIAD', shortcut_it = '', value_name_ro = 'DCIAD', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne mangelhaft, Tiefpunkt', value_description_de = 'Durchlaufrinne mangelhaft, Tiefpunkt', value_description_fr = 'Cunette défectueuse, point bas', value_description_it = 'Cunetta passante difettosa, punto inferiore', value_description_ro = 'rrr_Durchlaufrinne mangelhaft, Tiefpunkt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8947);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8948) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIAZ', value_name_en = 'DCIAZ', shortcut_en = '', value_name_de = 'DCIAZ', shortcut_de = '', value_name_fr = 'DCIAZ', shortcut_fr = '', value_name_it = 'DCIAZ', shortcut_it = '', value_name_ro = 'DCIAZ', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne mangelhaft', value_description_de = 'Durchlaufrinne mangelhaft', value_description_fr = 'Cunette défectueuse', value_description_it = 'Cunetta passante difettosa', value_description_ro = 'rrr_Durchlaufrinne mangelhaft'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8948);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8949) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCIBY', value_name_en = 'DCIBY', shortcut_en = '', value_name_de = 'DCIBY', shortcut_de = '', value_name_fr = 'DCIBY', shortcut_fr = '', value_name_it = 'DCIBY', shortcut_it = '', value_name_ro = 'DCIBY', shortcut_ro = '', value_description_en = 'yyy_Durchlaufrinne nicht mangelhaft', value_description_de = 'Durchlaufrinne nicht mangelhaft', value_description_fr = 'Cunette non défectueux', value_description_it = 'Cunetta passante non difettosa', value_description_ro = 'rrr_Durchlaufrinne nicht mangelhaft'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8949);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8950) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DCICY', value_name_en = 'DCICY', shortcut_en = '', value_name_de = 'DCICY', shortcut_de = '', value_name_fr = 'DCICY', shortcut_fr = '', value_name_it = 'DCICY', shortcut_it = '', value_name_ro = 'DCICY', shortcut_ro = '', value_description_en = 'yyy_Keine Durchlaufrinne', value_description_de = 'Keine Durchlaufrinne', value_description_fr = 'Pas de cunette', value_description_it = 'Cunetta passante mancante', value_description_ro = 'rrr_Keine Durchlaufrinne'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8950);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8951) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCAB', value_name_en = 'DDCAB', shortcut_en = '', value_name_de = 'DDCAB', shortcut_de = '', value_name_fr = 'DDCAB', shortcut_fr = '', value_name_it = 'DDCAB', shortcut_it = '', value_name_ro = 'DDCAB', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht möglich: Deckel kann nicht geöffnet werden, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Inspektion nicht möglich: Deckel kann nicht geöffnet werden, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Examen incomplet: le couvercle ne peut pas être ouvert, le client renonce à une inspection supplémentaire', value_description_it = 'Ispezione non completata: apertura del chiusino impossibile, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Inspektion nicht möglich: Deckel kann nicht geöffnet werden, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8951);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8952) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCAZ', value_name_en = 'DDCAZ', shortcut_en = '', value_name_de = 'DDCAZ', shortcut_de = '', value_name_fr = 'DDCAZ', shortcut_fr = '', value_name_it = 'DDCAZ', shortcut_it = '', value_name_ro = 'DDCAZ', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht möglich: Deckel kann nicht geöffnet werden', value_description_de = 'Inspektion nicht möglich: Deckel kann nicht geöffnet werden', value_description_fr = 'Examen incomplet: le couvercle ne peut pas être ouvert', value_description_it = 'Ispezione non completata: apertura del chiusino impossibile (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht möglich: Deckel kann nicht geöffnet werden'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8952);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8953) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCBA', value_name_en = 'DDCBA', shortcut_en = '', value_name_de = 'DDCBA', shortcut_de = '', value_name_fr = 'DDCBA', shortcut_fr = '', value_name_it = 'DDCBA', shortcut_it = '', value_name_ro = 'DDCBA', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Hindernis, Inspektionsziel erreicht', value_description_de = 'Inspektion nicht vollständig: Hindernis, Inspektionsziel erreicht', value_description_fr = 'Examen incomplet: obstacle, cible d’inspection atteinte', value_description_it = 'Ispezione non completata: ostacolo, obiettivo ispezione raggiunto', value_description_ro = 'rrr_Inspektion nicht vollständig: Hindernis, Inspektionsziel erreicht'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8953);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8954) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCBB', value_name_en = 'DDCBB', shortcut_en = '', value_name_de = 'DDCBB', shortcut_de = '', value_name_fr = 'DDCBB', shortcut_fr = '', value_name_it = 'DDCBB', shortcut_it = '', value_name_ro = 'DDCBB', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Hindernis, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Inspektion nicht vollständig: Hindernis, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Examen incomplet: obstacle, le client renonce à une nouvelle inspection', value_description_it = 'Ispezione non completata: ostacolo, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Inspektion nicht vollständig: Hindernis, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8954);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8955) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCBZ', value_name_en = 'DDCBZ', shortcut_en = '', value_name_de = 'DDCBZ', shortcut_de = '', value_name_fr = 'DDCBZ', shortcut_fr = '', value_name_it = 'DDCBZ', shortcut_it = '', value_name_ro = 'DDCBZ', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Hindernis', value_description_de = 'Inspektion nicht vollständig: Hindernis', value_description_fr = 'Examen incomplet: obstacle', value_description_it = 'Ispezione non completata: ostacolo, (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht vollständig: Hindernis'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8955);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8956) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCCA', value_name_en = 'DDCCA', shortcut_en = '', value_name_de = 'DDCCA', shortcut_de = '', value_name_fr = 'DDCCA', shortcut_fr = '', value_name_it = 'DDCCA', shortcut_it = '', value_name_ro = 'DDCCA', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Hoher Wasserstand, Inspektionsziel erreicht', value_description_de = 'Inspektion nicht vollständig: Hoher Wasserstand, Inspektionsziel erreicht', value_description_fr = 'Examen incomplet: niveau d’eau élevé, objectif d’inspection atteint', value_description_it = 'Ispezione non completata: livello dell’acqua alto, obiettivo ispezione raggiunto', value_description_ro = 'rrr_Inspektion nicht vollständig: Hoher Wasserstand, Inspektionsziel erreicht'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8956);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8957) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCCB', value_name_en = 'DDCCB', shortcut_en = '', value_name_de = 'DDCCB', shortcut_de = '', value_name_fr = 'DDCCB', shortcut_fr = '', value_name_it = 'DDCCB', shortcut_it = '', value_name_ro = 'DDCCB', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Inspektion nicht vollständig: Hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Examen incomplet: niveau d’eau élevé, le client s’abstient de toute inspection ultérieure', value_description_it = 'Ispezione non completata: livello dell’acqua alto, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Inspektion nicht vollständig: Hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8957);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8958) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCCZ', value_name_en = 'DDCCZ', shortcut_en = '', value_name_de = 'DDCCZ', shortcut_de = '', value_name_fr = 'DDCCZ', shortcut_fr = '', value_name_it = 'DDCCZ', shortcut_it = '', value_name_ro = 'DDCCZ', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Hoher Wasserstand', value_description_de = 'Inspektion nicht vollständig: Hoher Wasserstand', value_description_fr = 'Examen incomplet: niveau d’eau élevé', value_description_it = 'Ispezione non completata: livello dell’acqua alto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht vollständig: Hoher Wasserstand'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8958);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8959) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCDA', value_name_en = 'DDCDA', shortcut_en = '', value_name_de = 'DDCDA', shortcut_de = '', value_name_fr = 'DDCDA', shortcut_fr = '', value_name_it = 'DDCDA', shortcut_it = '', value_name_ro = 'DDCDA', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig:  Ausrüstung defekt, Inspektionsziel erreicht', value_description_de = 'Inspektion nicht vollständig:  Ausrüstung defekt, Inspektionsziel erreicht', value_description_fr = 'Examen incomplet: équipement défectueux, cible d’inspection atteinte', value_description_it = 'Ispezione non completata: guasto alle apparecchiature, obiettivo ispezione raggiunto', value_description_ro = 'rrr_Inspektion nicht vollständig:  Ausrüstung defekt, Inspektionsziel erreicht'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8959);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8960) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCDB', value_name_en = 'DDCDB', shortcut_en = '', value_name_de = 'DDCDB', shortcut_de = '', value_name_fr = 'DDCDB', shortcut_fr = '', value_name_it = 'DDCDB', shortcut_it = '', value_name_ro = 'DDCDB', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig:  Ausrüstung defekt, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Inspektion nicht vollständig:  Ausrüstung defekt, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Examen incomplet: équipement défectueux, le client renonce à une inspection supplémentaire', value_description_it = 'Ispezione non completata: guasto §alle apparecchiature, il committente rinuncia a ulteriore ispezione', value_description_ro = 'rrr_Inspektion nicht vollständig:  Ausrüstung defekt, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8960);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8961) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCDZ', value_name_en = 'DDCDZ', shortcut_en = '', value_name_de = 'DDCDZ', shortcut_de = '', value_name_fr = 'DDCDZ', shortcut_fr = '', value_name_it = 'DDCDZ', shortcut_it = '', value_name_ro = 'DDCDZ', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig: Ausrüstung defekt', value_description_de = 'Inspektion nicht vollständig: Ausrüstung defekt', value_description_fr = 'Examen incomplet: équipement défectueux', value_description_it = 'Ispezione non completata: guasto alle apparecchiature alto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht vollständig: Ausrüstung defekt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8961);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8962) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCZA', value_name_en = 'DDCZA', shortcut_en = '', value_name_de = 'DDCZA', shortcut_de = '', value_name_fr = 'DDCZA', shortcut_fr = '', value_name_it = 'DDCZA', shortcut_it = '', value_name_ro = 'DDCZA', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig, Inspektionsziel erreicht', value_description_de = 'Inspektion nicht vollständig, Inspektionsziel erreicht', value_description_fr = 'Examen incomplet, objectif d’inspection atteint (plus de détails requis dans le commentaire)', value_description_it = 'Ispezione non completata: obiettivo ispezione raggiunto (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht vollständig, Inspektionsziel erreicht'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8962);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8963) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCZB', value_name_en = 'DDCZB', shortcut_en = '', value_name_de = 'DDCZB', shortcut_de = '', value_name_fr = 'DDCZB', shortcut_fr = '', value_name_it = 'DDCZB', shortcut_it = '', value_name_ro = 'DDCZB', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig, Auftraggeber verzichtet auf weitere Inspektion', value_description_de = 'Inspektion nicht vollständig, Auftraggeber verzichtet auf weitere Inspektion', value_description_fr = 'Examen incomplet, le client renonce à une inspection plus poussée (plus de détails requis dans le commentaire)', value_description_it = 'Ispezione non completata, il committente rinuncia a ulteriore ispezione (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht vollständig, Auftraggeber verzichtet auf weitere Inspektion'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8963);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8964) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDCZZ', value_name_en = 'DDCZZ', shortcut_en = '', value_name_de = 'DDCZZ', shortcut_de = '', value_name_fr = 'DDCZZ', shortcut_fr = '', value_name_it = 'DDCZZ', shortcut_it = '', value_name_ro = 'DDCZZ', shortcut_ro = '', value_description_en = 'yyy_Inspektion nicht vollständig', value_description_de = 'Inspektion nicht vollständig', value_description_fr = 'Examen incomplet', value_description_it = 'Ispezione non completata ispezione (ulteriori dettagli sono richiesti nell’osservazione)', value_description_ro = 'rrr_Inspektion nicht vollständig'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8964);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8965) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDECA', value_name_en = 'DDECA', shortcut_en = '', value_name_de = 'DDECA', shortcut_de = '', value_name_fr = 'DDECA', shortcut_fr = '', value_name_it = 'DDECA', shortcut_it = '', value_name_ro = 'DDECA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, eaux usées se déversant dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue torbido, acque reflue entrano in acque meteoriche', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasserleitung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8965);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8966) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDECB', value_name_en = 'DDECB', shortcut_en = '', value_name_de = 'DDECB', shortcut_de = '', value_name_fr = 'DDECB', shortcut_fr = '', value_name_it = 'DDECB', shortcut_it = '', value_name_ro = 'DDECB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, des eaux pluviales se trouvant dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue torbido, acque meteoriche entrano in acque reflue', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasserleitung '
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8966);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8967) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDECC', value_name_en = 'DDECC', shortcut_en = '', value_name_de = 'DDECC', shortcut_de = '', value_name_fr = 'DDECC', shortcut_fr = '', value_name_it = 'DDECC', shortcut_it = '', value_name_ro = 'DDECC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss trüb', value_description_de = 'Abwasserzufluss trüb', value_description_fr = 'Arrivées d’eaux troubles', value_description_it = 'Afflusso acque reflue torbido', value_description_ro = 'rrr_Abwasserzufluss trüb'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8967);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8968) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEDA', value_name_en = 'DDEDA', shortcut_en = '', value_name_de = 'DDEDA', shortcut_de = '', value_name_fr = 'DDEDA', shortcut_fr = '', value_name_it = 'DDEDA', shortcut_it = '', value_name_ro = 'DDEDA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux usées se déversant dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue colorato, acque reflue entrano in acque meteoriche', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8968);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8969) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEDB', value_name_en = 'DDEDB', shortcut_en = '', value_name_de = 'DDEDB', shortcut_de = '', value_name_fr = 'DDEDB', shortcut_fr = '', value_name_it = 'DDEDB', shortcut_it = '', value_name_ro = 'DDEDB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux pluviales dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue colorato, acque meteoriche entrano in acque reflue', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung '
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8969);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8970) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEDC', value_name_en = 'DDEDC', shortcut_en = '', value_name_de = 'DDEDC', shortcut_de = '', value_name_fr = 'DDEDC', shortcut_fr = '', value_name_it = 'DDEDC', shortcut_it = '', value_name_ro = 'DDEDC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss gefärbt', value_description_de = 'Abwasserzufluss gefärbt', value_description_fr = 'Arrivées d’eaux colorées', value_description_it = 'Afflusso acque reflue colorato', value_description_ro = 'rrr_Abwasserzufluss gefärbt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8970);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8971) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEEA', value_name_en = 'DDEEA', shortcut_en = '', value_name_de = 'DDEEA', shortcut_de = '', value_name_fr = 'DDEEA', shortcut_fr = '', value_name_it = 'DDEEA', shortcut_it = '', value_name_ro = 'DDEEA', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux usées se déversant dans les eaux pluviales', value_description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque reflue entrano in acque meteoriche', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8971);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8972) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEEB', value_name_en = 'DDEEB', shortcut_en = '', value_name_de = 'DDEEB', shortcut_de = '', value_name_fr = 'DDEEB', shortcut_fr = '', value_name_it = 'DDEEB', shortcut_it = '', value_name_ro = 'DDEEB', shortcut_ro = '', value_description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ', value_description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux pluviales se déversant dans les eaux usées', value_description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque meteoriche entrano in acque reflue', value_description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung '
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8972);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3732,8973) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_damage_code', value_name = 'DDEEC', value_name_en = 'DDEEC', shortcut_en = '', value_name_de = 'DDEEC', shortcut_de = '', value_name_fr = 'DDEEC', shortcut_fr = '', value_name_it = 'DDEEC', shortcut_it = '', value_name_ro = 'DDEEC', shortcut_ro = '', value_description_en = 'yyy_Abwasserzufluss trüb und gefärbt', value_description_de = 'Abwasserzufluss trüb und gefärbt', value_description_fr = 'Arrivées d’eaux troubles et colorées', value_description_it = 'Afflusso acque reflue torbido e colorato', value_description_ro = 'rrr_Abwasserzufluss trüb und gefärbt'
WHERE (class_id = 3728 AND attribute_id = 3732 AND attribute_id = 8973);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3743) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'A', value_name_en = 'A', shortcut_en = '', value_name_de = 'A', shortcut_de = '', value_name_fr = 'A', shortcut_fr = '', value_name_it = 'A', shortcut_it = '', value_name_ro = 'A', shortcut_ro = '', value_description_en = 'yyy_A Abdeckung und Rahmen', value_description_de = 'A Abdeckung und Rahmen', value_description_fr = 'A Tampon du regard et cadre', value_description_it = 'A Chiusino e telaio', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3743);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3744) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'B', value_name_en = 'B', shortcut_en = '', value_name_de = 'B', shortcut_de = '', value_name_fr = 'B', shortcut_fr = '', value_name_it = 'B', shortcut_it = '', value_name_ro = 'B', shortcut_ro = '', value_description_en = 'yyy_B Schachthals', value_description_de = 'B Schachthals', value_description_fr = 'B Col du regard de visite', value_description_it = 'B Anello', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3744);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3745) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'D', value_name_en = 'D', shortcut_en = '', value_name_de = 'D', shortcut_de = '', value_name_fr = 'D', shortcut_fr = '', value_name_it = 'D', shortcut_it = '', value_name_ro = 'D', shortcut_ro = '', value_description_en = 'yyy_D Konus', value_description_de = 'D Konus', value_description_fr = 'D Cône de réduction', value_description_it = 'D Cono', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3745);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3746) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'F', value_name_en = 'F', shortcut_en = '', value_name_de = 'F', shortcut_de = '', value_name_fr = 'F', shortcut_fr = '', value_name_it = 'F', shortcut_it = '', value_name_ro = 'F', shortcut_ro = '', value_description_en = 'yyy_F Schachtrohre', value_description_de = 'F Schachtrohre', value_description_fr = 'F Chambre', value_description_it = 'F Pozzetto', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3746);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3747) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'H', value_name_en = 'H', shortcut_en = '', value_name_de = 'H', shortcut_de = '', value_name_fr = 'H', shortcut_fr = '', value_name_it = 'H', shortcut_it = '', value_name_ro = 'H', shortcut_ro = '', value_description_en = 'yyy_H Bankett', value_description_de = 'H Bankett', value_description_fr = 'H Banquette', value_description_it = 'H Banchina', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3747);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3748) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'I', value_name_en = 'I', shortcut_en = '', value_name_de = 'I', shortcut_de = '', value_name_fr = 'I', shortcut_fr = '', value_name_it = 'I', shortcut_it = '', value_name_ro = 'I', shortcut_ro = '', value_description_en = 'yyy_I Durchlaufrinne', value_description_de = 'I Durchlaufrinne', value_description_fr = 'I Cunette', value_description_it = 'I Cunetta di scorrimento', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3748);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3728,3742,3749) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'damage_manhole', field_name = 'manhole_shaft_area', value_name = 'J', value_name_en = 'J', shortcut_en = '', value_name_de = 'J', shortcut_de = '', value_name_fr = 'J', shortcut_fr = '', value_name_it = 'J', shortcut_it = '', value_name_ro = 'J', shortcut_ro = '', value_description_en = 'yyy_J Sohle', value_description_de = 'J Sohle', value_description_fr = 'J Radier', value_description_it = 'J Fondo', value_description_ro = ''
WHERE (class_id = 3728 AND attribute_id = 3742 AND attribute_id = 3749);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3800) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'throttle_shut_off_unit', value_name_en = 'throttle_shut_off_unit', shortcut_en = '', value_name_de = 'Absperr_Drosselorgan', shortcut_de = '', value_name_fr = 'LIMITEUR_DEBIT', shortcut_fr = '', value_name_it = 'zzz_Absperr_Drosselorgan', shortcut_it = '', value_name_ro = 'rrr_Absperr_Drosselorgan', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3800);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3801) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'wastewater_structure', value_name_en = 'wastewater_structure', shortcut_en = '', value_name_de = 'Abwasserbauwerk', shortcut_de = '', value_name_fr = 'OUVRAGE_RESEAU_AS', shortcut_fr = '', value_name_it = 'manufatto_smaltimento_acque', shortcut_it = '', value_name_ro = 'rrr_Abwasserbauwerk', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = 'manufatto_smaltimento_acque', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3801);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3802) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'waster_water_treatment', value_name_en = 'waster_water_treatment', shortcut_en = '', value_name_de = 'Abwasserbehandlung', shortcut_de = '', value_name_fr = 'TRAITEMENT_EAUX_USEES', shortcut_fr = '', value_name_it = 'zzz_Abwasserbehandlung', shortcut_it = '', value_name_ro = 'rrr_Abwasserbehandlung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3802);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3803) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'wastewater_node', value_name_en = 'wastewater_node', shortcut_en = '', value_name_de = 'Abwasserknoten', shortcut_de = '', value_name_fr = 'NOEUD_RESEAU', shortcut_fr = '', value_name_it = 'zzz_Abwasserknoten', shortcut_it = '', value_name_ro = 'rrr_Abwasserknoten', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3803);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3804) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'wastewater_networkelement', value_name_en = 'wastewater_networkelement', shortcut_en = '', value_name_de = 'Abwassernetzelement', shortcut_de = '', value_name_fr = 'ELEMENT_RESEAU_EVACUATION', shortcut_fr = '', value_name_it = 'zzz_Abwassernetzelement', shortcut_it = '', value_name_ro = 'rrr_Abwassernetzelement', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3804);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3805) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'waste_water_treatment_plant', value_name_en = 'waste_water_treatment_plant', shortcut_en = '', value_name_de = 'Abwasserreinigungsanlage', shortcut_de = '', value_name_fr = 'STATION_EPURATION', shortcut_fr = '', value_name_it = 'zzz_Abwasserreinigungsanlage', shortcut_it = '', value_name_ro = 'rrr_Abwasserreinigungsanlage', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3805);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3806) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'waste_water_association', value_name_en = 'waste_water_association', shortcut_en = '', value_name_de = 'Abwasserverband', shortcut_de = '', value_name_fr = 'ASSOCIATION_EPURATION_EAU', shortcut_fr = '', value_name_it = 'consorzio_depurazione', shortcut_it = '', value_name_ro = 'rrr_Abwasserverband', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3806);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3807) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'administrative_office', value_name_en = 'administrative_office', shortcut_en = '', value_name_de = 'Amt', shortcut_de = '', value_name_fr = 'OFFICE', shortcut_fr = '', value_name_it = 'zzz_Amt', shortcut_it = '', value_name_ro = 'rrr_Amt', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3807);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3808) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'connection_object', value_name_en = 'connection_object', shortcut_en = '', value_name_de = 'Anschlussobjekt', shortcut_de = '', value_name_fr = 'OBJET_RACCORDE', shortcut_fr = '', value_name_it = 'zzz_Anschlussobjekt', shortcut_it = '', value_name_ro = 'rrr_Anschlussobjekt', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3808);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3809) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'wwtp_structure', value_name_en = 'wwtp_structure', shortcut_en = '', value_name_de = 'ARABauwerk', shortcut_de = '', value_name_fr = 'OUVRAGES_STEP', shortcut_fr = '', value_name_it = 'manufatto_IDA', shortcut_it = '', value_name_ro = 'rrr_ARABauwerk', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3809);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3810) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'wwtp_energy_use', value_name_en = 'wwtp_energy_use', shortcut_en = '', value_name_de = 'ARAEnergienutzung', shortcut_de = '', value_name_fr = 'CONSOMMATION_ENERGIE_STEP', shortcut_fr = '', value_name_it = 'zzz_ARAEnergienutzung', shortcut_it = '', value_name_ro = 'rrr_ARAEnergienutzung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3810);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3811) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'bathing_area', value_name_en = 'bathing_area', shortcut_en = '', value_name_de = 'Badestelle', shortcut_de = '', value_name_fr = 'LIEU_BAIGNADE', shortcut_fr = '', value_name_it = 'zzz_Badestelle', shortcut_it = '', value_name_ro = 'rrr_Badestelle', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3811);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3812) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'benching', value_name_en = 'benching', shortcut_en = '', value_name_de = 'Bankett', shortcut_de = '', value_name_fr = 'BANQUETTE', shortcut_fr = '', value_name_it = 'zzz_Bankett', shortcut_it = '', value_name_ro = 'rrr_Bankett', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3812);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3813) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'structure_part', value_name_en = 'structure_part', shortcut_en = '', value_name_de = 'BauwerksTeil', shortcut_de = '', value_name_fr = 'ELEMENT_OUVRAGE', shortcut_fr = '', value_name_it = 'zzz_BauwerksTeil', shortcut_it = '', value_name_ro = 'rrr_BauwerksTeil', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3813);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3814) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'well', value_name_en = 'well', shortcut_en = '', value_name_de = 'Brunnen', shortcut_de = '', value_name_fr = 'FONTAINE', shortcut_fr = '', value_name_it = 'zzz_Brunnen', shortcut_it = '', value_name_ro = 'rrr_Brunnen', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3814);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3815) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'file', value_name_en = 'file', shortcut_en = '', value_name_de = 'Datei', shortcut_de = '', value_name_fr = 'FICHIER', shortcut_fr = '', value_name_it = 'file', shortcut_it = '', value_name_ro = 'rrr_Datei', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3815);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3816) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'data_media', value_name_en = 'data_media', shortcut_en = '', value_name_de = 'Datentraeger', shortcut_de = '', value_name_fr = 'SUPPORT_DONNEES', shortcut_fr = '', value_name_it = 'supporto_dati', shortcut_it = '', value_name_ro = 'rrr_Datentraeger', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3816);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3817) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'cover', value_name_en = 'cover', shortcut_en = '', value_name_de = 'Deckel', shortcut_de = '', value_name_fr = 'COUVERCLE', shortcut_fr = '', value_name_it = 'zzz_Deckel', shortcut_it = '', value_name_ro = 'rrr_Deckel', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3817);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3818) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'passage', value_name_en = 'passage', shortcut_en = '', value_name_de = 'Durchlass', shortcut_de = '', value_name_fr = 'PASSAGE_SOUS_TUYAU', shortcut_fr = '', value_name_it = 'zzz_Durchlass', shortcut_it = '', value_name_ro = 'rrr_Durchlass', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3818);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3819) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'access_aid', value_name_en = 'access_aid', shortcut_en = '', value_name_de = 'Einstiegshilfe', shortcut_de = '', value_name_fr = 'DISPOSITIF_ACCES', shortcut_fr = '', value_name_it = 'zzz_Einstiegshilfe', shortcut_it = '', value_name_ro = 'rrr_Einstiegshilfe', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3819);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3820) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'individual_surface', value_name_en = 'individual_surface', shortcut_en = '', value_name_de = 'Einzelflaeche', shortcut_de = '', value_name_fr = 'SURFACE_INDIVIDUELLE', shortcut_fr = '', value_name_it = 'zzz_Einzelflaeche', shortcut_it = '', value_name_ro = 'rrr_Einzelflaeche', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3820);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3821) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'catchment_area', value_name_en = 'catchment_area', shortcut_en = '', value_name_de = 'Einzugsgebiet', shortcut_de = '', value_name_fr = 'BASSIN_VERSANT', shortcut_fr = '', value_name_it = 'area_tributaria', shortcut_it = '', value_name_ro = 'rrr_Einzugsgebiet', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3821);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3822) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'electric_equipment', value_name_en = 'electric_equipment', shortcut_en = '', value_name_de = 'ElektrischeEinrichtung', shortcut_de = '', value_name_fr = 'EQUIPEMENT_ELECTRIQUE', shortcut_fr = '', value_name_it = 'zzz_ElektrischeEinrichtung', shortcut_it = '', value_name_ro = 'rrr_ElektrischeEinrichtung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3822);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3823) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'electromechanical_equipment', value_name_en = 'electromechanical_equipment', shortcut_en = '', value_name_de = 'ElektromechanischeAusruestung', shortcut_de = '', value_name_fr = 'EQUIPEMENT_ELECTROMECA', shortcut_fr = '', value_name_it = 'zzz_ElektromechanischeAusruestung', shortcut_it = '', value_name_ro = 'rrr_ElektromechanischeAusruestung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3823);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3824) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'drainage_system', value_name_en = 'drainage_system', shortcut_en = '', value_name_de = 'Entwaesserungssystem', shortcut_de = '', value_name_fr = 'systeme_evacuation_eaux', shortcut_fr = '', value_name_it = 'zzz_Entwaesserungssystem', shortcut_it = '', value_name_ro = 'rrr_Entwaesserungssystem', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3824);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3825) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'maintenance_event', value_name_en = 'maintenance_event', shortcut_en = '', value_name_de = 'Erhaltungsereignis', shortcut_de = '', value_name_fr = 'EVENEMENT_MAINTENANCE', shortcut_fr = '', value_name_it = 'evento_di_mantenimento', shortcut_it = '', value_name_ro = 'rrr_Erhaltungsereignis', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3825);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3826) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'fish_pass', value_name_en = 'fish_pass', shortcut_en = '', value_name_de = 'Fischpass', shortcut_de = '', value_name_fr = 'ECHELLE_POISSONS', shortcut_fr = '', value_name_it = 'zzz_Fischpass', shortcut_it = '', value_name_ro = 'rrr_Fischpass', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3826);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3827) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'river', value_name_en = 'river', shortcut_en = '', value_name_de = 'Fliessgewaesser', shortcut_de = '', value_name_fr = 'COURS_EAU', shortcut_fr = '', value_name_it = 'zzz_Fliessgewaesser', shortcut_it = '', value_name_ro = 'rrr_Fliessgewaesser', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3827);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3828) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'pump', value_name_en = 'pump', shortcut_en = '', value_name_de = 'FoerderAggregat', shortcut_de = '', value_name_fr = 'INSTALLATION_REFOULEMENT', shortcut_fr = '', value_name_it = 'pompaggio', shortcut_it = '', value_name_ro = 'rrr_FoerderAggregat', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = 'installation de refoulement', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3828);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3829) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'ford', value_name_en = 'ford', shortcut_en = '', value_name_de = 'Furt', shortcut_de = '', value_name_fr = 'PASSAGE_A_GUE', shortcut_fr = '', value_name_it = 'zzz_Furt', shortcut_it = '', value_name_ro = 'rrr_Furt', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3829);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3830) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'building', value_name_en = 'building', shortcut_en = '', value_name_de = 'Gebaeude', shortcut_de = '', value_name_fr = 'BATIMENT', shortcut_fr = '', value_name_it = 'zzz_Gebaeude', shortcut_it = '', value_name_ro = 'rrr_Gebaeude', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3830);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3831) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'hazard_source', value_name_en = 'hazard_source', shortcut_en = '', value_name_de = 'Gefahrenquelle', shortcut_de = '', value_name_fr = 'SOURCE_DANGER', shortcut_fr = '', value_name_it = 'zzz_Gefahrenquelle', shortcut_it = '', value_name_ro = 'rrr_hart', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3831);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3832) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'municipality', value_name_en = 'municipality', shortcut_en = '', value_name_de = 'Gemeinde', shortcut_de = '', value_name_fr = 'COMMUNE', shortcut_fr = '', value_name_it = 'comune', shortcut_it = '', value_name_ro = 'municipiul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3832);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3833) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'blocking_debris', value_name_en = 'blocking_debris', shortcut_en = '', value_name_de = 'Geschiebesperre', shortcut_de = '', value_name_fr = 'BARRAGE_ALLUVIONS', shortcut_fr = '', value_name_it = 'zzz_Geschiebesperre', shortcut_it = '', value_name_ro = 'rrr_Geschiebesperre', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3833);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3834) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'water_course_segment', value_name_en = 'water_course_segment', shortcut_en = '', value_name_de = 'Gewaesserabschnitt', shortcut_de = '', value_name_fr = 'TRONCON_COURS_EAU', shortcut_fr = '', value_name_it = 'zzz_Gewaesserabschnitt', shortcut_it = '', value_name_ro = 'rrr_Gewaesserabschnitt', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3834);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3835) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'chute', value_name_en = 'chute', shortcut_en = '', value_name_de = 'GewaesserAbsturz', shortcut_de = '', value_name_fr = 'SEUIL', shortcut_fr = '', value_name_it = 'zzz_GewaesserAbsturz', shortcut_it = '', value_name_ro = 'rrr_GewaesserAbsturz', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3835);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3836) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'water_body_protection_sector', value_name_en = 'water_body_protection_sector', shortcut_en = '', value_name_de = 'Gewaesserschutzbereich', shortcut_de = '', value_name_fr = 'SECTEUR_PROTECTION_EAUX', shortcut_fr = '', value_name_it = 'zzz_Gewaesserschutzbereich', shortcut_it = '', value_name_ro = 'rrr_Gewaesserschutzbereich', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3836);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3837) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'sector_water_body', value_name_en = 'sector_water_body', shortcut_en = '', value_name_de = 'Gewaessersektor', shortcut_de = '', value_name_fr = 'SECTEUR_EAUX_SUP', shortcut_fr = '', value_name_it = 'zzz_Gewaessersektor', shortcut_it = '', value_name_ro = 'rrr_Gewaessersektor', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3837);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3838) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'river_bed', value_name_en = 'river_bed', shortcut_en = '', value_name_de = 'Gewaessersohle', shortcut_de = '', value_name_fr = 'FOND_COURS_EAU', shortcut_fr = '', value_name_it = 'zzz_Gewaessersohle', shortcut_it = '', value_name_ro = 'rrr_Gewaessersohle', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3838);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3839) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'water_control_structure', value_name_en = 'water_control_structure', shortcut_en = '', value_name_de = 'Gewaesserverbauung', shortcut_de = '', value_name_fr = 'AMENAGEMENT_COURS_EAU', shortcut_fr = '', value_name_it = 'zzz_Gewaesserverbauung', shortcut_it = '', value_name_ro = 'rrr_Gewaesserverbauung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3839);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3840) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'dam', value_name_en = 'dam', shortcut_en = '', value_name_de = 'GewaesserWehr', shortcut_de = '', value_name_fr = 'OUVRAGE_RETENUE', shortcut_fr = '', value_name_it = 'zzz_GewaesserWehr', shortcut_it = '', value_name_ro = 'rrr_GewaesserWehr', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3840);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3841) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'aquifer', value_name_en = 'aquifer', shortcut_en = '', value_name_de = 'Grundwasserleiter', shortcut_de = '', value_name_fr = 'AQUIFERE', shortcut_fr = '', value_name_it = 'acquifero', shortcut_it = '', value_name_ro = 'rrr_Grundwasserleiter', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3841);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3842) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'ground_water_protection_perimeter', value_name_en = 'ground_water_protection_perimeter', shortcut_en = '', value_name_de = 'Grundwasserschutzareal', shortcut_de = '', value_name_fr = 'PERIMETRE_PROT_EAUX_SOUT', shortcut_fr = '', value_name_it = 'zzz_Grundwasserschutzareal', shortcut_it = '', value_name_ro = 'rrr_Grundwasserschutzareal', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3842);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3843) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'groundwater_protection_zone', value_name_en = 'groundwater_protection_zone', shortcut_en = '', value_name_de = 'Grundwasserschutzzone', shortcut_de = '', value_name_fr = 'ZONE_PROT_EAUX_SOUT', shortcut_fr = '', value_name_it = 'zzz_Grundwasserschutzzone', shortcut_it = '', value_name_ro = 'rrr_Grundwasserschutzzone', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3843);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3844) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'reach', value_name_en = 'reach', shortcut_en = '', value_name_de = 'Haltung', shortcut_de = '', value_name_fr = 'TRONCON', shortcut_fr = '', value_name_it = 'tratta', shortcut_it = '', value_name_ro = 'rrr_Haltung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3844);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3845) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'reach_point', value_name_en = 'reach_point', shortcut_en = '', value_name_de = 'Haltungspunkt', shortcut_de = '', value_name_fr = 'POINT_TRONCON', shortcut_fr = '', value_name_it = 'punto_tratta', shortcut_it = '', value_name_ro = 'rrr_Haltungspunkt', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3845);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3846) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'hq_relation', value_name_en = 'hq_relation', shortcut_en = '', value_name_de = 'HQ_Relation', shortcut_de = '', value_name_fr = 'RELATION_HQ', shortcut_fr = '', value_name_it = 'zzz_HQ_Relation', shortcut_it = '', value_name_ro = 'rrr_HQ_Relation', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3846);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3847) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'hydr_geometry', value_name_en = 'hydr_geometry', shortcut_en = '', value_name_de = 'Hydr_Geometrie', shortcut_de = '', value_name_fr = 'GEOMETRIE_HYDR', shortcut_fr = '', value_name_it = 'zzz_Hydr_Geometrie', shortcut_it = '', value_name_ro = 'rrr_Hydr_Geometrie', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3847);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3848) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'hydr_geom_relation', value_name_en = 'hydr_geom_relation', shortcut_en = '', value_name_de = 'Hydr_GeomRelation', shortcut_de = '', value_name_fr = 'RELATION_GEOM_HYDR', shortcut_fr = '', value_name_it = 'zzz_Hydr_GeomRelation', shortcut_it = '', value_name_ro = 'rrr_Hydr_GeomRelation', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3848);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3849) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'channel', value_name_en = 'channel', shortcut_en = '', value_name_de = 'Kanal', shortcut_de = '', value_name_fr = 'CANALISATION', shortcut_fr = '', value_name_it = 'zzz_Kanal', shortcut_it = '', value_name_ro = 'rrr_Kanal', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3849);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3850) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'damage_channel', value_name_en = 'damage_channel', shortcut_en = '', value_name_de = 'Kanalschaden', shortcut_de = '', value_name_fr = 'DOMMAGE_AUX_CANALISATIONS', shortcut_fr = '', value_name_it = 'zzz_Kanalschaden', shortcut_it = '', value_name_ro = 'rrr_Kanalschaden', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3850);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3851) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'canton', value_name_en = 'canton', shortcut_en = '', value_name_de = 'Kanton', shortcut_de = '', value_name_fr = 'CANTON', shortcut_fr = '', value_name_it = 'zzz_Kanton', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3851);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3852) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'leapingweir', value_name_en = 'leapingweir', shortcut_en = '', value_name_de = 'Leapingwehr', shortcut_de = '', value_name_fr = 'LEAPING_WEIR', shortcut_fr = '', value_name_it = 'leaping_weir', shortcut_it = '', value_name_ro = 'rrr_Leapingwehr', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3852);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3853) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'mechanical_pretreatment', value_name_en = 'mechanical_pretreatment', shortcut_en = '', value_name_de = 'MechanischeVorreinigung', shortcut_de = '', value_name_fr = 'PRETRAITEMENT_MECANIQUE', shortcut_fr = '', value_name_it = 'zzz_MechanischeVorreinigung', shortcut_it = '', value_name_ro = 'rrr_MechanischeVorreinigung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3853);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3854) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'measurement_device', value_name_en = 'measurement_device', shortcut_en = '', value_name_de = 'Messgeraet', shortcut_de = '', value_name_fr = 'APPAREIL_MESURE', shortcut_fr = '', value_name_it = 'apparecchio_misura', shortcut_it = '', value_name_ro = 'rrr_Messgeraet', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3854);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3855) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'measurement_series', value_name_en = 'measurement_series', shortcut_en = '', value_name_de = 'Messreihe', shortcut_de = '', value_name_fr = 'SERIE_MESURES', shortcut_fr = '', value_name_it = 'zzz_Messreihe', shortcut_it = '', value_name_ro = 'rrr_Messreihe', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3855);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3856) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'measurement_result', value_name_en = 'measurement_result', shortcut_en = '', value_name_de = 'Messresultat', shortcut_de = '', value_name_fr = 'RESULTAT_MESURE', shortcut_fr = '', value_name_it = 'zzz_Messresultat', shortcut_it = '', value_name_ro = 'rrr_Messresultat', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3856);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3857) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'measuring_point', value_name_en = 'measuring_point', shortcut_en = '', value_name_de = 'Messstelle', shortcut_de = '', value_name_fr = 'STATION_MESURE', shortcut_fr = '', value_name_it = 'stazione_misura', shortcut_it = '', value_name_ro = 'rrr_Messstelle', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3857);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3858) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'standard_manhole', value_name_en = 'standard_manhole', shortcut_en = '', value_name_de = 'Normschacht', shortcut_de = '', value_name_fr = 'CHAMBRE_STANDARD', shortcut_fr = '', value_name_it = 'zzz_Normschacht', shortcut_it = '', value_name_ro = 'rrr_Normschacht', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3858);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3859) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'damage_manhole', value_name_en = 'damage_manhole', shortcut_en = '', value_name_de = 'Normschachtschaden', shortcut_de = '', value_name_fr = 'DOMMAGE_CHAMBRE_STANDARD', shortcut_fr = '', value_name_it = 'zzz_Normschachtschaden', shortcut_it = '', value_name_ro = 'rrr_Normschachtschaden', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3859);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3861) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'surface_runoff_parameters', value_name_en = 'surface_runoff_parameters', shortcut_en = '', value_name_de = 'Oberflaechenabflussparameter', shortcut_de = '', value_name_fr = 'PARAM_ECOULEMENT_SUP', shortcut_fr = '', value_name_it = 'zzz_Oberflaechenabflussparameter', shortcut_it = '', value_name_ro = 'rrr_Oberflaechenabflussparameter', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3861);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3862) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'surface_water_bodies', value_name_en = 'surface_water_bodies', shortcut_en = '', value_name_de = 'Oberflaechengewaesser', shortcut_de = '', value_name_fr = 'EAUX_SUPERFICIELLES', shortcut_fr = '', value_name_it = 'zzz_Oberflaechengewaesser', shortcut_it = '', value_name_ro = 'rrr_Oberflaechengewaesser', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3862);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3863) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'organisation', value_name_en = 'organisation', shortcut_en = '', value_name_de = 'Organisation', shortcut_de = '', value_name_fr = 'ORGANISATION', shortcut_fr = '', value_name_it = 'organizzazione', shortcut_it = '', value_name_ro = 'rrr_Organisation', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3863);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3864) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'planning_zone', value_name_en = 'planning_zone', shortcut_en = '', value_name_de = 'Planungszone', shortcut_de = '', value_name_fr = 'ZONE_RESERVEE', shortcut_fr = '', value_name_it = 'zzz_Planungszone', shortcut_it = '', value_name_ro = 'rrr_Planungszone', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3864);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3865) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'private', value_name_en = 'private', shortcut_en = '', value_name_de = 'Privat', shortcut_de = '', value_name_fr = 'PRIVE', shortcut_fr = '', value_name_it = 'privato', shortcut_it = '', value_name_ro = 'privata', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3865);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3866) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'cleaning_device', value_name_en = 'cleaning_device', shortcut_en = '', value_name_de = 'Reinigungseinrichtung', shortcut_de = '', value_name_fr = 'DISPOSITIF_NETTOYAGE', shortcut_fr = '', value_name_it = 'zzz_Reinigungseinrichtung', shortcut_it = '', value_name_ro = 'rrr_Reinigungseinrichtung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3866);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3867) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'reservoir', value_name_en = 'reservoir', shortcut_en = '', value_name_de = 'Reservoir', shortcut_de = '', value_name_fr = 'RESERVOIR', shortcut_fr = '', value_name_it = 'zzz_Reservoir', shortcut_it = '', value_name_ro = 'rrr_Reservoir', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3867);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3868) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'retention_body', value_name_en = 'retention_body', shortcut_en = '', value_name_de = 'Retentionskoerper', shortcut_de = '', value_name_fr = 'VOLUME_RETENTION', shortcut_fr = '', value_name_it = 'zzz_Retentionskoerper', shortcut_it = '', value_name_ro = 'rrr_Retentionskoerper', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3868);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3869) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'pipe_profile', value_name_en = 'pipe_profile', shortcut_en = '', value_name_de = 'Rohrprofil', shortcut_de = '', value_name_fr = 'PROFIL_TUYAU', shortcut_fr = '', value_name_it = 'profilo_del_tubo', shortcut_it = '', value_name_ro = 'rrr_Rohrprofil', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3869);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3870) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'profile_geometry', value_name_en = 'profile_geometry', shortcut_en = '', value_name_de = 'Rohrprofil_Geometrie', shortcut_de = '', value_name_fr = 'PROFIL_TUYAU_GEOM', shortcut_fr = '', value_name_it = 'zzz_Rohrprofil_Geometrie', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3870);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3871) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'damage', value_name_en = 'damage', shortcut_en = '', value_name_de = 'Schaden', shortcut_de = '', value_name_fr = 'DOMMAGE', shortcut_fr = '', value_name_it = 'zzz_Schaden', shortcut_it = '', value_name_ro = 'rrr_Schaden', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3871);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3872) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'sludge_treatment', value_name_en = 'sludge_treatment', shortcut_en = '', value_name_de = 'Schlammbehandlung', shortcut_de = '', value_name_fr = 'TRAITEMENT_BOUES', shortcut_fr = '', value_name_it = 'zzz_Schlammbehandlung', shortcut_it = '', value_name_ro = 'rrr_Schlammbehandlung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3872);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3873) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'lock', value_name_en = 'lock', shortcut_en = '', value_name_de = 'Schleuse', shortcut_de = '', value_name_fr = 'ECLUSE', shortcut_fr = '', value_name_it = 'zzz_Schleuse', shortcut_it = '', value_name_ro = 'rrr_Schleuse', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3873);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3874) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'lake', value_name_en = 'lake', shortcut_en = '', value_name_de = 'See', shortcut_de = '', value_name_fr = 'LAC', shortcut_fr = '', value_name_it = 'lago', shortcut_it = '', value_name_ro = 'rrr_See', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3874);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3875) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'rock_ramp', value_name_en = 'rock_ramp', shortcut_en = '', value_name_de = 'Sohlrampe', shortcut_de = '', value_name_fr = 'RAMPE', shortcut_fr = '', value_name_it = 'zzz_Sohlrampe', shortcut_it = '', value_name_ro = 'rrr_Sohlrampe', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3875);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3876) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'special_structure', value_name_en = 'special_structure', shortcut_en = '', value_name_de = 'Spezialbauwerk', shortcut_de = '', value_name_fr = 'OUVRAGE_SPECIAL', shortcut_fr = '', value_name_it = 'zzz_Spezialbauwerk', shortcut_it = '', value_name_ro = 'rrr_Spezialbauwerk', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3876);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3877) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'control_center', value_name_en = 'control_center', shortcut_en = '', value_name_de = 'Steuerungszentrale', shortcut_de = '', value_name_fr = 'CENTRALE_COMMANDE', shortcut_fr = '', value_name_it = 'zzz_Steuerungszentrale', shortcut_it = '', value_name_ro = 'rrr_Steuerungszentrale', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3877);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3878) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'substance', value_name_en = 'substance', shortcut_en = '', value_name_de = 'Stoff', shortcut_de = '', value_name_fr = 'SUBSTANCE', shortcut_fr = '', value_name_it = 'zzz_Stoff', shortcut_it = '', value_name_ro = 'rrr_Stoff', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3878);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3879) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'prank_weir', value_name_en = 'prank_weir', shortcut_en = '', value_name_de = 'Streichwehr', shortcut_de = '', value_name_fr = 'DEVERSOIR_LATERAL', shortcut_fr = '', value_name_it = 'stramazzo_laterale', shortcut_it = '', value_name_ro = 'rrr_Streichwehr', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3879);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3880) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'dryweather_downspout', value_name_en = 'dryweather_downspout', shortcut_en = '', value_name_de = 'Trockenwetterfallrohr', shortcut_de = '', value_name_fr = 'TUYAU_CHUTE', shortcut_fr = '', value_name_it = 'zzz_Trockenwetterfallrohr', shortcut_it = '', value_name_ro = 'rrr_Trockenwetterfallrohr', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3880);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3881) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'dryweather_flume', value_name_en = 'dryweather_flume', shortcut_en = '', value_name_de = 'Trockenwetterrinne', shortcut_de = '', value_name_fr = 'CUNETTE_DEBIT_TEMPS_SEC', shortcut_fr = '', value_name_it = 'zzz_Trockenwetterrinne', shortcut_it = '', value_name_ro = 'rrr_Trockenwetterrinne', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3881);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3882) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'overflow', value_name_en = 'overflow', shortcut_en = '', value_name_de = 'Ueberlauf', shortcut_de = '', value_name_fr = 'DEVERSOIR', shortcut_fr = '', value_name_it = 'zzz_Ueberlauf', shortcut_it = '', value_name_ro = 'rrr_Ueberlauf', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3882);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3883) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'overflow_characteristic', value_name_en = 'overflow_characteristic', shortcut_en = '', value_name_de = 'Ueberlaufcharakteristik', shortcut_de = '', value_name_fr = 'CARACTERISTIQUES_DEVERSOIR', shortcut_fr = '', value_name_it = 'zzz_Ueberlaufcharakteristik', shortcut_it = '', value_name_ro = 'rrr_Ueberlaufcharakteristik', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3883);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3884) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'shore', value_name_en = 'shore', shortcut_en = '', value_name_de = 'Ufer', shortcut_de = '', value_name_fr = 'RIVE', shortcut_fr = '', value_name_it = 'zzz_Ufer', shortcut_it = '', value_name_ro = 'rrr_Ufer', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3884);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3885) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'accident', value_name_en = 'accident', shortcut_en = '', value_name_de = 'Unfall', shortcut_de = '', value_name_fr = 'ACCIDENT', shortcut_fr = '', value_name_it = 'zzz_Unfall', shortcut_it = '', value_name_ro = 'rrr_Unfall', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3885);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3886) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'examination', value_name_en = 'examination', shortcut_en = '', value_name_de = 'Untersuchung', shortcut_de = '', value_name_fr = 'EXAMEN', shortcut_fr = '', value_name_it = 'zzz_Untersuchung', shortcut_it = '', value_name_ro = 'rrr_Untersuchung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3886);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3887) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'infiltration_installation', value_name_en = 'infiltration_installation', shortcut_en = '', value_name_de = 'Versickerungsanlage', shortcut_de = '', value_name_fr = 'INSTALLATION_INFILTRATION', shortcut_fr = '', value_name_it = 'impianto_infiltrazione', shortcut_it = '', value_name_ro = 'rrr_Versickerungsanlage', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3887);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3888) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'infiltration_zone', value_name_en = 'infiltration_zone', shortcut_en = '', value_name_de = 'Versickerungsbereich', shortcut_de = '', value_name_fr = 'ZONE_INFILTRATION', shortcut_fr = '', value_name_it = 'zzz_Versickerungsbereich', shortcut_it = '', value_name_ro = 'rrr_Versickerungsbereich', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3888);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3890) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'water_catchment', value_name_en = 'water_catchment', shortcut_en = '', value_name_de = 'Wasserfassung', shortcut_de = '', value_name_fr = 'CAPTAGE', shortcut_fr = '', value_name_it = 'zzz_Wasserfassung', shortcut_it = '', value_name_ro = 'rrr_Wasserfassung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3890);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,3891) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'zone', value_name_en = 'zone', shortcut_en = '', value_name_de = 'Zone', shortcut_de = '', value_name_fr = 'ZONE', shortcut_fr = '', value_name_it = 'zzz_Zone', shortcut_it = '', value_name_ro = 'rrr_Zone', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 3891);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,5083) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'discharge_point', value_name_en = 'discharge_point', shortcut_en = '', value_name_de = 'Einleitstelle', shortcut_de = '', value_name_fr = 'EXUTOIRE', shortcut_fr = '', value_name_it = 'punto_immissione', shortcut_it = '', value_name_ro = 'deversor', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 5083);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9026) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'flushing_nozzle', value_name_en = 'flushing_nozzle', shortcut_en = '', value_name_de = 'Spuelstutzen', shortcut_de = '', value_name_fr = 'TETE_DE_RINCAGE', shortcut_fr = '', value_name_it = 'zzz_Ugello_di_lavaggio', shortcut_it = '', value_name_ro = 'rrr_Spuelstutzen', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9026);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9027) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'bio_ecol_assessment', value_name_en = 'bio_ecol_assessment', shortcut_en = '', value_name_de = 'Biol_oekol_Gesamtbeurteilung', shortcut_de = '', value_name_fr = 'EVALUATION_GENERALE_ECO_BIOL', shortcut_fr = '', value_name_it = 'valutazione_biol_ecol_globale', shortcut_it = '', value_name_ro = 'rrr_Biol_oekol_Gesamtbeurteilung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9027);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9028) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'disposal', value_name_en = 'disposal', shortcut_en = '', value_name_de = 'Entsorgung', shortcut_de = '', value_name_fr = 'EVACUATION', shortcut_fr = '', value_name_it = 'zzz_Entsorgung', shortcut_it = '', value_name_ro = 'rrr_Entsorgung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9028);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9029) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'solids_retention', value_name_en = 'solids_retention', shortcut_en = '', value_name_de = 'Feststoffrueckhalt', shortcut_de = '', value_name_fr = 'RETENUE_DE_MATIERES_SOLIDES', shortcut_fr = '', value_name_it = 'ritenzione_solidi', shortcut_it = '', value_name_ro = 'rrr_Feststoffrueckhalt', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9029);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9030) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'building_group', value_name_en = 'building_group', shortcut_en = '', value_name_de = 'Gebaeudegruppe', shortcut_de = '', value_name_fr = 'BATIMENTS', shortcut_fr = '', value_name_it = 'zzz_Gebaeudegruppe', shortcut_it = '', value_name_ro = 'rrr_Gebaeudegruppe', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9030);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9031) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'building_group_baugwr', value_name_en = 'building_group_baugwr', shortcut_en = '', value_name_de = 'Gebaeudegruppe_BAUGWR', shortcut_de = '', value_name_fr = 'BATIMENTS_BAUREGBL', shortcut_fr = '', value_name_it = 'zzz_Gebaeudegruppe_BAUGWR', shortcut_it = '', value_name_ro = 'rrr_Gebaeudegruppe_BAUGWR', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9031);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9032) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'cooperative', value_name_en = 'cooperative', shortcut_en = '', value_name_de = 'Genossenschaft_Korporation', shortcut_de = '', value_name_fr = 'COOPERATIVE', shortcut_fr = '', value_name_it = 'cooperativa_corporazione', shortcut_it = '', value_name_ro = 'rrr_Genossenschaft_Korporation', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9032);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9033) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'hydraulic_char_data', value_name_en = 'hydraulic_char_data', shortcut_en = '', value_name_de = 'Hydr_Kennwerte', shortcut_de = '', value_name_fr = 'PARAMETRES_HYDR', shortcut_fr = '', value_name_it = 'zzz_Hydr_Kennwerte', shortcut_it = '', value_name_ro = 'rrr_Hydr_Kennwerte', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9033);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9034) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'small_treatment_plant', value_name_en = 'small_treatment_plant', shortcut_en = '', value_name_de = 'KLARA', shortcut_de = '', value_name_fr = 'PETITE_STEP', shortcut_fr = '', value_name_it = 'zzz_KLARA', shortcut_it = '', value_name_ro = 'rrr_KLARA', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9034);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9035) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'farm', value_name_en = 'farm', shortcut_en = '', value_name_de = 'Landwirtschaftsbetrieb', shortcut_de = '', value_name_fr = 'EXPLOITATION_AGRICOLE', shortcut_fr = '', value_name_it = 'zzz_Landwirtschaftsbetrieb', shortcut_it = '', value_name_ro = 'rrr_Landwirtschaftsbetrieb', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9035);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9036) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'measure', value_name_en = 'measure', shortcut_en = '', value_name_de = 'Massnahme', shortcut_de = '', value_name_fr = 'MESURE', shortcut_fr = '', value_name_it = 'intervento', shortcut_it = '', value_name_ro = 'rrr_Massnahme', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9036);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9037) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'log_card', value_name_en = 'log_card', shortcut_en = '', value_name_de = 'Stammkarte', shortcut_de = '', value_name_fr = 'FICHE_TECHNIQUE', shortcut_fr = '', value_name_it = 'scheda_tipo', shortcut_it = '', value_name_ro = 'rrr_Stammkarte', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9037);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9038) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'tank_emptying', value_name_en = 'tank_emptying', shortcut_en = '', value_name_de = 'Beckenentleerung', shortcut_de = '', value_name_fr = 'VIDANGE_DE_BASSINS', shortcut_fr = '', value_name_it = 'vuotamento_bacino', shortcut_it = '', value_name_ro = 'rrr_Beckenentleerung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9038);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9039) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'tank_cleaning', value_name_en = 'tank_cleaning', shortcut_en = '', value_name_de = 'Beckenreinigung', shortcut_de = '', value_name_fr = 'NETTOYAGE_DE_BASSINS', shortcut_fr = '', value_name_it = 'pulizia_bacino', shortcut_it = '', value_name_ro = 'rrr_Beckenreinigung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9039);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9040) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'backflow_prevention', value_name_en = 'backflow_prevention', shortcut_en = '', value_name_de = 'Rueckstausicherung', shortcut_de = '', value_name_fr = 'PROTECTION_REFOULEMENT', shortcut_fr = '', value_name_it = 'dispositivo_anti_rigurgito', shortcut_it = '', value_name_ro = 'rrr_Rueckstausicherung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9040);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9041) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'catchment_area_totals', value_name_en = 'catchment_area_totals', shortcut_en = '', value_name_de = 'Gesamteinzugsgebiet', shortcut_de = '', value_name_fr = 'BASSIN_VERSANT_COMPLET', shortcut_fr = '', value_name_it = 'area_tributaria_totale', shortcut_it = '', value_name_ro = 'rrr_Gesamteinzugsgebiet', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9041);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9042) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'disposal_without_drain', value_name_en = 'disposal_without_drain', shortcut_en = '', value_name_de = 'AbflussloseEntsorgung', shortcut_de = '', value_name_fr = 'EVACUATION_SANS_REJET', shortcut_fr = '', value_name_it = 'zzz_AbflussloseEntsorgung', shortcut_it = '', value_name_ro = 'rrr_AbflussloseEntsorgung', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9042);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9043) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'disposal_with_drain', value_name_en = 'disposal_with_drain', shortcut_en = '', value_name_de = 'EntsorgungMitAbfluss', shortcut_de = '', value_name_fr = 'EVACUATION_AVEC_REJET', shortcut_fr = '', value_name_it = 'zzz_EntsorgungMitAbfluss', shortcut_it = '', value_name_ro = 'rrr_EntsorgungMitAbfluss', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9043);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3764,9044) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'classname', value_name = 'drainless_toilet', value_name_en = 'drainless_toilet', shortcut_en = '', value_name_de = 'Abflusslose_Toilette', shortcut_de = '', value_name_fr = 'TOILETTE_SANS_VIDANGE', shortcut_fr = '', value_name_it = 'toilette_senza_scarico', shortcut_it = '', value_name_ro = 'rrr_Abflusslose_Toilette', shortcut_ro = '', value_description_en = 'drainless toilet', value_description_de = 'Abflusslose Toilette', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3764 AND attribute_id = 9044);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,3770) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'other', value_name_en = 'other', shortcut_en = '', value_name_de = 'andere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = 'altro', shortcut_it = '', value_name_ro = 'rrr_altul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 3770);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,3772) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'photo', value_name_en = 'photo', shortcut_en = '', value_name_de = 'Foto', shortcut_de = '', value_name_fr = 'photo', shortcut_fr = '', value_name_it = 'foto', shortcut_it = '', value_name_ro = 'foto', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 3772);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,3773) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'panoramo_film', value_name_en = 'panoramo_film', shortcut_en = '', value_name_de = 'Panoramofilm', shortcut_de = '', value_name_fr = 'film_panoramique', shortcut_fr = '', value_name_it = 'film_panoramico', shortcut_it = '', value_name_ro = 'rrr_Panoramofilm', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 3773);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,3774) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'textfile', value_name_en = 'textfile', shortcut_en = '', value_name_de = 'Textdatei', shortcut_de = '', value_name_fr = 'fichier_texte', shortcut_fr = '', value_name_it = 'file_di_testo', shortcut_it = '', value_name_ro = 'rrr_Textdatei', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 3774);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,3775) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'video', value_name_en = 'video', shortcut_en = '', value_name_de = 'Video', shortcut_de = '', value_name_fr = 'video', shortcut_fr = '', value_name_it = 'video', shortcut_it = '', value_name_ro = 'rrr_video', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 3775);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,8812) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'sketch', value_name_en = 'sketch', shortcut_en = '', value_name_de = 'Skizze', shortcut_de = '', value_name_fr = 'croquis', shortcut_fr = '', value_name_it = 'schizzo', shortcut_it = '', value_name_ro = 'schita', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 8812);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,9146) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'digital_video', value_name_en = 'digital_video', shortcut_en = '', value_name_de = 'digitales_Video', shortcut_de = '', value_name_fr = 'video_numerique', shortcut_fr = '', value_name_it = 'video_digitale', shortcut_it = '', value_name_ro = 'rrr_digitales_Video', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 9146);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3754,3769,9147) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'file', field_name = 'kind', value_name = 'scan', value_name_en = 'scan', shortcut_en = '', value_name_de = 'Scan', shortcut_de = '', value_name_fr = 'scan', shortcut_fr = '', value_name_it = 'scan', shortcut_it = '', value_name_ro = 'scanare', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3754 AND attribute_id = 3769 AND attribute_id = 9147);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3784) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'other', value_name_en = 'other', shortcut_en = '', value_name_de = 'andere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = 'altro', shortcut_it = '', value_name_ro = 'rrr_altul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3784);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3785) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'CD', value_name_en = 'CD', shortcut_en = '', value_name_de = 'CD', shortcut_de = '', value_name_fr = 'CD', shortcut_fr = '', value_name_it = 'CD', shortcut_it = '', value_name_ro = 'CD', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3785);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3786) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'floppy_disc', value_name_en = 'floppy_disc', shortcut_en = '', value_name_de = 'Diskette', shortcut_de = '', value_name_fr = 'disquette', shortcut_fr = '', value_name_it = 'dischetto', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3786);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3787) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'dvd', value_name_en = 'dvd', shortcut_en = '', value_name_de = 'DVD', shortcut_de = '', value_name_fr = 'DVD', shortcut_fr = '', value_name_it = 'DVD', shortcut_it = '', value_name_ro = 'DVD', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3787);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3788) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'harddisc', value_name_en = 'harddisc', shortcut_en = '', value_name_de = 'Festplatte', shortcut_de = '', value_name_fr = 'disque_dur', shortcut_fr = '', value_name_it = 'disco_fisso', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3788);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3789) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'server', value_name_en = 'server', shortcut_en = '', value_name_de = 'Server', shortcut_de = '', value_name_fr = 'serveur', shortcut_fr = '', value_name_it = 'server', shortcut_it = '', value_name_ro = 'server', shortcut_ro = '', value_description_en = 'Local server (as opposed to Webserver)', value_description_de = 'Lokaler Server (im Gegensatz zu Webserver)', value_description_fr = 'Serveur local (par opposition à serveur web)', value_description_it = 'Server locale (rispetto all server web)', value_description_ro = 'Server local (spre deosebire de server web)'
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3789);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,3790) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'videotape', value_name_en = 'videotape', shortcut_en = '', value_name_de = 'Videoband', shortcut_de = '', value_name_fr = 'bande_video', shortcut_fr = '', value_name_it = 'nastro_video', shortcut_it = '', value_name_ro = 'rrr_Videoband', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 3790);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (3776,3783,9318) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'data_media', field_name = 'kind', value_name = 'webserver', value_name_en = 'webserver', shortcut_en = '', value_name_de = 'Webserver', shortcut_de = '', value_name_fr = 'serveur_web', shortcut_fr = '', value_name_it = 'server_web', shortcut_it = '', value_name_ro = 'server_web', shortcut_ro = '', value_description_en = 'Web server with URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)', value_description_de = 'Webserver mit URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)', value_description_fr = 'Serveur web avec URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)', value_description_it = 'Server web con URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)', value_description_ro = 'Server web cu URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)'
WHERE (class_id = 3776 AND attribute_id = 3783 AND attribute_id = 9318);
