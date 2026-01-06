------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 06.08.2025 14:49:19
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (8500,'sia405cc_cable') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'sia405cc_cable', name_en = 'cable', shortcut_en = 'CB', name_de = 'Kabel', shortcut_de = '', name_fr = 'Cable', shortcut_fr = '', name_it = 'Cavo', shortcut_it = '', name_ro = 'Cablu', shortcut_ro = ''
WHERE (id = 8500 AND tablename = 'sia405cc_cable');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (8501,'sia405cc_cable_point') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'sia405cc_cable_point', name_en = 'cable point', shortcut_en = 'CI', name_de = 'Kabelpunkt', shortcut_de = '', name_fr = 'Point cable', shortcut_fr = '', name_it = 'Punto cavo', shortcut_it = '', name_ro = 'Punct de cablu', shortcut_ro = ''
WHERE (id = 8501 AND tablename = 'sia405cc_cable_point');




--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9327) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'name_number', field_name_en = 'name_number', field_name_de = 'Name_Nummer', field_name_fr = 'Nom_numero', field_name_it = 'nome_numero', field_name_ro = 'nume_numarul', field_description_en = '', field_description_de = 'z.B. Kabelpunktanfang_Kabelpunkteende', field_description_fr = 'xxx_z.B. Point_cableanfang_Point_cableeende', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(40)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9327);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9328) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'geometry', field_name_en = 'geometry', field_name_de = 'Geometrie', field_name_fr = 'Geometrie', field_name_it = 'geometria', field_name_ro = 'geometria', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'geometry', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9328);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9329) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'function', field_name_en = 'function', field_name_de = 'Funktion', field_name_fr = 'Fonction', field_name_it = 'zzz_Funktion', field_name_ro = 'zzz_Funktion', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9329);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9330) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'cable_type', field_name_en = 'cable_type', field_name_de = 'Kabelart', field_name_fr = 'Genre', field_name_it = 'zzz_Kabelart', field_name_ro = '', field_description_en = 'Cable type', field_description_de = 'Kabelart', field_description_fr = 'Genre de cable', field_description_it = 'zzz_Kabelart', field_description_ro = 'rrr_Kabelart', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9330);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9331) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'horizontal_positioning', field_name_en = 'horizontal_positioning', field_name_de = 'Lagebestimmung', field_name_fr = 'Determination_planimetrique', field_name_it = 'determinazione_posizione', field_name_ro = 'precizie_pozitie', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9331);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9332) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'status', field_name_en = 'status', field_name_de = 'Status', field_name_fr = 'Etat', field_name_it = 'stato', field_name_ro = 'stare', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = 'extends value range of SIA405 status', field_unit_de = '', field_unit_description_de = 'Erweitert Wertebereich von SIA405 Status', field_unit_fr = '', field_unit_description_fr = 'extension valeurs SIA405 Etat', field_unit_it = '', field_unit_description_it = 'dilatato codominio SIA405 Stato', field_unit_ro = '', field_unit_description_ro = 'rrr_Erweitert Wertebereich von SIA405 Status', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9332);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9333) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'installation_year', field_name_en = 'installation_year', field_name_de = 'Einbaujahr', field_name_fr = 'Annee_construction', field_name_it = 'anno_costruzione', field_name_ro = 'anul_instalarii', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = ' If unknown set lowest value of value range', field_unit_de = '', field_unit_description_de = 'Falls unbekannt, tiefsten Wert des Wertebereichs einsetzen', field_unit_fr = '', field_unit_description_fr = 'Si inconnu ajouter la plus bas valeur du domaine des valeurs', field_unit_it = '', field_unit_description_it = 'Se sconosciuto, inserire valore minimo dell’intervallo di valori', field_unit_ro = '', field_unit_description_ro = 'rrr_Falls unbekannt, tiefsten Wert des Wertebereichs einsetzen', field_max = 2100, field_min = 1800
WHERE (class_id = 8500 AND attribute_id = 9333);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9334) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'sur_plus_cover', field_name_en = 'sur_plus_cover', field_name_de = 'Ueberdeckung', field_name_fr = 'Couverture_ouvrage', field_name_it = 'zzz_Ueberdeckung', field_name_ro = 'zzz_Ueberdeckung', field_description_en = 'Numerical mean value of an object', field_description_de = 'Numerisch mittlerer Wert eines Objektes', field_description_fr = 'Valeur moyenne d''''un objet', field_description_it = 'Valore medio numerico di un oggetto', field_description_ro = 'Valoarea medie numerica a unui obiect', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(4,1)', field_unit_en = '[m]', field_unit_description_en = 'meter [m]', field_unit_de = '[m]', field_unit_description_de = 'Meter [m]', field_unit_fr = '[m]', field_unit_description_fr = 'mètre [m]', field_unit_it = '[m]', field_unit_description_it = 'metro [m]', field_unit_ro = '[m]', field_unit_description_ro = 'rrr_Meter [m]', field_max = 999.9, field_min = 0
WHERE (class_id = 8500 AND attribute_id = 9334);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9335) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'remark', field_name_en = 'remark', field_name_de = 'Bemerkung', field_name_fr = 'Remarque', field_name_it = '', field_name_ro = '', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(80)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9335);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9336) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'condition', field_name_en = 'condition', field_name_de = 'Zustand', field_name_fr = 'Condition', field_name_it = 'condizione', field_name_ro = 'zzz_Zustand', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(40)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9336);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9353) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'width', field_name_en = 'width', field_name_de = 'Breite', field_name_fr = 'Largeur', field_name_it = 'larghezza', field_name_ro = 'latime', field_description_en = 'Width of cable trench', field_description_de = 'Breite Kabeltrasse', field_description_fr = 'Largeur du tracé du câble', field_description_it = 'zzz_Breite Kabeltrasse', field_description_ro = 'rrr_Breite Kabeltrasse', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimètre [mm]', field_unit_it = '[mm]', field_unit_description_it = '	millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 4000, field_min = 0
WHERE (class_id = 8500 AND attribute_id = 9353);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9355) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'geometry3d', field_name_en = 'geometry3d', field_name_de = 'Geometrie3D', field_name_fr = 'Geometrie3D', field_name_it = 'geometria3d', field_name_ro = 'geometria3D', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'geometry', field_unit_en = '[HKoord]', field_unit_description_en = 'points with coordinates in the swiss national grid', field_unit_de = '[HKoord]', field_unit_description_de = 'Punkte mit Schweizer Landeskoordinaten [HKoord]', field_unit_fr = '[CoordH]', field_unit_description_fr = 'points avec coordonnées dans le système de coordonnées suisse', field_unit_it = '[HKoord]', field_unit_description_it = 'Punti con coordinate nazionali svizzere', field_unit_ro = '[HKoord]', field_unit_description_ro = 'rrr_Punkte mit Schweizer Landeskoordinaten', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9355);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9356) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'elevation_determination', field_name_en = 'elevation_determination', field_name_de = 'Hoehenbestimmung', field_name_fr = 'Determination_altimetrique', field_name_it = 'determinazione_dell_altezza', field_name_ro = 'determinare_altimetrica', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8500 AND attribute_id = 9356);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8500,9357) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable', field_name = 'depth', field_name_en = 'depth', field_name_de = 'Maechtigkeit', field_name_fr = 'Epaisseur', field_name_it = 'spessore', field_name_ro = 'adancime', field_description_en = 'Extension 3D, heigth of of cable trench [mm].', field_description_de = 'Erweiterung 3D, Mächtigkeit (Höhe) Kabeltrasse [mm].', field_description_fr = 'Extension 3D, épaisseur (largeur) du trace du câble [mm].', field_description_it = 'zzz_Erweiterung 3D, Mächtigkeit (Höhe) Kabeltrasse [mm].', field_description_ro = 'rrr_Erweiterung 3D, Mächtigkeit (Höhe) Kabeltrasse [mm].', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimètre [mm]', field_unit_it = '[mm]', field_unit_description_it = 'millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 99999, field_min = -99999
WHERE (class_id = 8500 AND attribute_id = 9357);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9371) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'name_number', field_name_en = 'name_number', field_name_de = 'Name_Nummer', field_name_fr = 'Nom_numero', field_name_it = 'nome_numero', field_name_ro = 'nume_numarul', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(40)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9371);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9372) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'geometry', field_name_en = 'geometry', field_name_de = 'Geometrie', field_name_fr = 'Geometrie', field_name_it = 'geometria', field_name_ro = 'geometria', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'geometry', field_unit_en = '[NCoord]', field_unit_description_en = 'Swiss national grid coordinates', field_unit_de = '[LKoord]', field_unit_description_de = 'Schweizer Landeskoordinaten', field_unit_fr = '[CoordNat]', field_unit_description_fr = 'coordonnées dans le système de coordonnées suisse', field_unit_it = '[CoordNaz]', field_unit_description_it = 'Coordinate nazionali Svizzera', field_unit_ro = 'rrr_[LKoord]', field_unit_description_ro = 'rrr_Schweizer Landeskoordinaten', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9372);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9373) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', field_name_en = 'kind', field_name_de = 'Art', field_name_fr = 'Genre', field_name_it = 'tipo', field_name_ro = 'tip', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9373);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9374) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'horizontal_positioning', field_name_en = 'horizontal_positioning', field_name_de = 'Lagebestimmung', field_name_fr = 'Determination_planimetrique', field_name_it = 'determinazione_posizione', field_name_ro = 'precizie_pozitie', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9374);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9375) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'altitude', field_name_en = 'altitude', field_name_de = 'Hoehe', field_name_fr = 'Altitude', field_name_it = 'livello', field_name_ro = 'altitudine', field_description_en = 'Altitude of component', field_description_de = 'Oberkante Bauteil', field_description_fr = 'Bord supérieur de l''élément contructif', field_description_it = 'Bordo superiore del componente', field_description_ro = 'Marginea superioara a componentei', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(7,3)', field_unit_en = '[m.a.sl.]', field_unit_description_en = 'meters above sea level [m.a.sl.]', field_unit_de = '[M.ü.M.]', field_unit_description_de = 'Meter über Meer [M.ü.M.]', field_unit_fr = '[m.s.m.]', field_unit_description_fr = 'mètres sur mers [m.s.m.]', field_unit_it = '[m s.l.m.]', field_unit_description_it = 'metro sul livello del mare [m s.l.m.]', field_unit_ro = 'rrr_[M.ü.M.]', field_unit_description_ro = 'rrr_Meter über Meer [M.ü.M.]', field_max = 5000, field_min = -200
WHERE (class_id = 8501 AND attribute_id = 9375);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9376) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'elevation_determination', field_name_en = 'elevation_determination', field_name_de = 'Hoehenbestimmung', field_name_fr = 'Determination_altimetrique', field_name_it = 'determinazione_dell_altezza', field_name_ro = 'determinare_altimetrica', field_description_en = 'Elevation determination of geometry (3D)', field_description_de = 'Höhenbestimmung der Geometrie (3D)', field_description_fr = 'Définition de la détermination altimétrique de la Géométrie (3D)', field_description_it = 'Determinazione dell''altezza della geometria (3D)', field_description_ro = 'Determinarea altimetrica geometriei (3D)', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9376);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9377) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'status', field_name_en = 'status', field_name_de = 'Status', field_name_fr = 'Etat', field_name_it = 'stato', field_name_ro = 'stare', field_description_en = 'Operating and planning status of the structure', field_description_de = 'Betriebs- bzw. Planungszustand des Bauwerks', field_description_fr = 'Etat de fonctionnement et de planification de l’ouvrage', field_description_it = 'Stato di funzionamento e di pianificazione del manufatto.', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = 'extends value range of SIA405 status', field_unit_de = '', field_unit_description_de = 'Erweitert Wertebereich von SIA405 Status', field_unit_fr = '', field_unit_description_fr = 'extension valeurs SIA405 Etat', field_unit_it = '', field_unit_description_it = 'dilatato codominio SIA405 Stato', field_unit_ro = '', field_unit_description_ro = 'rrr_Erweitert Wertebereich von SIA405 Status', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9377);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9378) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'installation_year', field_name_en = 'installation_year', field_name_de = 'Einbaujahr', field_name_fr = 'Annee_construction', field_name_it = 'anno_costruzione', field_name_ro = 'anul_instalarii', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = ' If unknown set lowest value of value range', field_unit_de = '', field_unit_description_de = 'Falls unbekannt, tiefsten Wert des Wertebereichs einsetzen', field_unit_fr = '', field_unit_description_fr = 'Si inconnu ajouter la plus bas valeur du domaine des valeurs', field_unit_it = '', field_unit_description_it = 'Se sconosciuto, inserire valore minimo dell’intervallo di valori', field_unit_ro = '', field_unit_description_ro = 'rrr_Falls unbekannt, tiefsten Wert des Wertebereichs einsetzen', field_max = 2100, field_min = 1800
WHERE (class_id = 8501 AND attribute_id = 9378);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9379) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'sur_plus_cover', field_name_en = 'sur_plus_cover', field_name_de = 'Ueberdeckung', field_name_fr = 'Couverture_ouvrage', field_name_it = 'zzz_Ueberdeckung', field_name_ro = '', field_description_en = 'Numerical mean value of an object', field_description_de = 'Numerisch mittlerer Wert eines Objektes', field_description_fr = 'Valeur moyenne d''un objet', field_description_it = 'Valore medio numerico di un oggetto', field_description_ro = 'Valoarea medie numerica a unui obiect', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(4,1)', field_unit_en = '[m]', field_unit_description_en = 'meter [m]', field_unit_de = '[m]', field_unit_description_de = 'Meter [m]', field_unit_fr = '[m]', field_unit_description_fr = 'mètre [m]', field_unit_it = '[m]', field_unit_description_it = 'metro [m]', field_unit_ro = '[m]', field_unit_description_ro = 'rrr_Meter [m]', field_max = 999.9, field_min = 0
WHERE (class_id = 8501 AND attribute_id = 9379);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9380) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'condition', field_name_en = 'condition', field_name_de = 'Zustand', field_name_fr = 'Condition', field_name_it = 'condizione', field_name_ro = 'rrr_Zustand', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(40)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9380);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9381) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'remark', field_name_en = 'remark', field_name_de = 'Bemerkung', field_name_fr = 'Remarque', field_name_it = 'osservazione', field_name_ro = 'observatie', field_description_en = 'General remarks', field_description_de = 'Allgemeine Bemerkungen', field_description_fr = 'Remarques générales', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(80)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9381);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9408) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'dimension1', field_name_en = 'dimension1', field_name_de = 'Dimension1', field_name_fr = 'Dimension1', field_name_it = 'dimensione1', field_name_ro = 'dimensiune1', field_description_en = 'Larger dimension of an object (e.g. length)', field_description_de = 'grösseres Mass eines Objektes (z.B. Länge)', field_description_fr = 'plus grande mesure d''un objet (par ex. Longueur, diamètre)', field_description_it = 'Dimensione maggiore di un oggetto (ad es. lunghezza)', field_description_ro = 'Dimensiunea mai mare a unui obiect (de exemplu, lungimea)', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimètre [mm]', field_unit_it = '[mm]', field_unit_description_it = '	millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 4000, field_min = 0
WHERE (class_id = 8501 AND attribute_id = 9408);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9409) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'dimension2', field_name_en = 'dimension2', field_name_de = 'Dimension2', field_name_fr = 'Dimension2', field_name_it = 'dimensione2', field_name_ro = 'dimenisune2', field_description_en = 'smaller dimension of an object (e.g. width)', field_description_de = 'kleineres Mass eines Objektes (z.B. Breite)', field_description_fr = 'plus petite msure d''un objet (par ex. Largeur)', field_description_it = 'dimensione minore di un oggetto (ad es. larghezza)', field_description_ro = 'dimensiunea mai mica a unui obiect (de exemplu, la?imea)', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimètre [mm]', field_unit_it = '[mm]', field_unit_description_it = '	millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 4000, field_min = 0
WHERE (class_id = 8501 AND attribute_id = 9409);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9410) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'altitude_lower_edge', field_name_en = 'altitude_lower_edge', field_name_de = 'Hoehe_UK', field_name_fr = 'Altitude_BI', field_name_it = 'zzz_livello_bordo_inferiore', field_name_ro = 'rrr_Hoehe_UK', field_description_en = 'Altitude lower edge of component', field_description_de = 'Höhe Unterkante', field_description_fr = 'Bord inférieur de l''élément constructif', field_description_it = 'Bordo inferiore del componente', field_description_ro = 'Marginea inferioara a componentei', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(7,3)', field_unit_en = '[m.a.sl.]', field_unit_description_en = 'meters above sea level [m.a.sl.]', field_unit_de = '[M.ü.M.]', field_unit_description_de = 'Meter über Meer [M.ü.M.]', field_unit_fr = '[m.s.m.]', field_unit_description_fr = 'mètres sur mers [m.s.m.]', field_unit_it = '[m s.l.m.]', field_unit_description_it = 'metro sul livello del mare [m s.l.m.]', field_unit_ro = 'rrr_[M.ü.M.]', field_unit_description_ro = 'rrr_Meter über Meer [M.ü.M.]', field_max = 5000, field_min = -200
WHERE (class_id = 8501 AND attribute_id = 9410);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9411) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'symbolori', field_name_en = 'symbolori', field_name_de = 'SymbolOri', field_name_fr = 'SymboleOri', field_name_it = 'simboloori', field_name_ro = 'simbolori', field_description_en = 'Default: 90 degree', field_description_de = 'Default: 90 Grad', field_description_fr = 'Default: 90 degre', field_description_it = 'Default: 90 gradi', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(4,1)', field_unit_en = '[degrees]', field_unit_description_en = 'Degree', field_unit_de = '[Altgrad]', field_unit_description_de = '[Altgrad]', field_unit_fr = '[degres]', field_unit_description_fr = 'degrées [degres]', field_unit_it = '[vecchi gradi]', field_unit_description_it = 'vecchi gradi', field_unit_ro = 'rrr_[Altgrad]', field_unit_description_ro = 'rrr_Altgrad', field_max = 359.9, field_min = 0
WHERE (class_id = 8501 AND attribute_id = 9411);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9412) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'depth', field_name_en = 'depth', field_name_de = 'Maechtigkeit', field_name_fr = 'Epaisseur', field_name_it = 'spessore', field_name_ro = 'adancime', field_description_en = 'Extension3D, Fonction (calculated value) = altitude minus altitude_lower_edge', field_description_de = 'Erweiterung 3D, Funktion (berechneter Wert) = Hoehe minus Hoehe_UK.', field_description_fr = 'Extension 3D, Fonction (valuer calculée) = Altitude minus Altitude_BI.', field_description_it = 'zzz_Erweiterung 3D, Funktion (berechneter Wert) = Hoehe minus Hoehe_UK.', field_description_ro = 'rrr_Erweiterung 3D, Funktion (berechneter Wert) = Hoehe minus Hoehe_UK.', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimètre [mm]', field_unit_it = '[mm]', field_unit_description_it = 'millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 99999, field_min = -99999
WHERE (class_id = 8501 AND attribute_id = 9412);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8501,9472) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405cc_cable_point', field_name = 'geometry3d', field_name_en = 'geometry3d', field_name_de = 'Geometrie3D', field_name_fr = 'Geometrie3D', field_name_it = 'geometria3d', field_name_ro = 'geometria3D', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'geometry', field_unit_en = '[HKoord]', field_unit_description_en = 'Swiss national grid coordinates', field_unit_de = '[HKoord]', field_unit_description_de = 'Schweizer Landeskoordinaten [HKoord]', field_unit_fr = '[CoordH]', field_unit_description_fr = 'coordonnées dans le système de coordonnées suisse', field_unit_it = '[HKoord]', field_unit_description_it = 'Coordinate nazionali Svizzera', field_unit_ro = '[HKoord]', field_unit_description_ro = 'rrr_Schweizer Landeskoordinaten [HKoord]', field_max = NULL, field_min = NULL
WHERE (class_id = 8501 AND attribute_id = 9472);





INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9329,9338) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'function', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9329 AND attribute_id = 9338);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9329,9339) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'function', value_name = 'signal_cable', value_name_en = 'signal_cable', shortcut_en = '', value_name_de = 'Signalkabel', shortcut_de = '', value_name_fr = 'cable_de_signal', shortcut_fr = '', value_name_it = 'cavo_di_segnale', shortcut_it = '', value_name_ro = 'cablu_de_semnal', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9329 AND attribute_id = 9339);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9329,9340) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'function', value_name = 'control_cable', value_name_en = 'control_cable', shortcut_en = '', value_name_de = 'Steuerkabel', shortcut_de = '', value_name_fr = 'cable_de_conduite', shortcut_fr = '', value_name_it = 'cavo_di_comando', shortcut_it = '', value_name_ro = 'cablu_de_control', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9329 AND attribute_id = 9340);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9329,9341) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'function', value_name = 'power_cable', value_name_en = 'power_cable', shortcut_en = '', value_name_de = 'Stromkabel', shortcut_de = '', value_name_fr = 'cable_de_courant', shortcut_fr = '', value_name_it = 'cavo_di_alimentazione', shortcut_it = '', value_name_ro = 'cablu_de_alimentare', shortcut_ro = '', value_description_en = 'for district heating only', value_description_de = 'nur bei Fernwärme', value_description_fr = 'uniquement pour le chauffage à distance', value_description_it = 'zzz_nur bei Fernwärme', value_description_ro = 'zzz_nur bei Fernwärme'
WHERE (class_id = 8500 AND attribute_id = 9329 AND attribute_id = 9341);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9329,9342) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'function', value_name = 'others', value_name_en = 'others', shortcut_en = '', value_name_de = 'weitere', shortcut_de = '', value_name_fr = 'autres', shortcut_fr = '', value_name_it = 'zzz_weitere', shortcut_it = '', value_name_ro = 'rrr_weitere', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9329 AND attribute_id = 9342);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9330,9343) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'cable_type', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9330 AND attribute_id = 9343);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9330,9344) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'cable_type', value_name = 'copper', value_name_en = 'copper', shortcut_en = '', value_name_de = 'Kupfer', shortcut_de = '', value_name_fr = 'cuivre', shortcut_fr = '', value_name_it = 'zzz_rame', shortcut_it = '', value_name_ro = 'zzz_Kupfer', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9330 AND attribute_id = 9344);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9330,9345) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'cable_type', value_name = 'coaxial', value_name_en = 'coaxial', shortcut_en = '', value_name_de = 'koaxial', shortcut_de = '', value_name_fr = 'coaxial', shortcut_fr = '', value_name_it = 'zzz_coassiale', shortcut_it = '', value_name_ro = 'rrr_koaxial', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9330 AND attribute_id = 9345);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9330,9346) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'cable_type', value_name = 'fiber_optic', value_name_en = 'fiber_optic', shortcut_en = '', value_name_de = 'Lichtwellenleiter', shortcut_de = '', value_name_fr = 'optique', shortcut_fr = '', value_name_it = 'zzz_Lichtwellenleiter', shortcut_it = '', value_name_ro = 'rrr_Lichtwellenleiter', shortcut_ro = '', value_description_en = 'Fiber optic cable', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9330 AND attribute_id = 9346);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9331,9347) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'horizontal_positioning', value_name = 'accurate', value_name_en = 'accurate', shortcut_en = '', value_name_de = 'genau', shortcut_de = '', value_name_fr = 'precis', shortcut_fr = '', value_name_it = 'precisa', shortcut_it = '', value_name_ro = 'precisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9331 AND attribute_id = 9347);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9331,9348) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'horizontal_positioning', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9331 AND attribute_id = 9348);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9331,9349) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'horizontal_positioning', value_name = 'inaccurate', value_name_en = 'inaccurate', shortcut_en = '', value_name_de = 'ungenau', shortcut_de = '', value_name_fr = 'imprecis', shortcut_fr = '', value_name_it = 'impreciso', shortcut_it = '', value_name_ro = 'imprecisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9331 AND attribute_id = 9349);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9363) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'inoperative', value_name_en = 'inoperative', shortcut_en = '', value_name_de = 'ausser_Betrieb', shortcut_de = '', value_name_fr = 'hors_service', shortcut_fr = '', value_name_it = 'fuori_servizio', shortcut_it = '', value_name_ro = 'rrr_ausser_Betrieb', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9363);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9364) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'inoperative.reserve', value_name_en = 'inoperative.reserve', shortcut_en = '', value_name_de = 'ausser_Betrieb.Reserve', shortcut_de = '', value_name_fr = 'hors_service.en_reserve', shortcut_fr = '', value_name_it = 'fuori_servizio.riserva', shortcut_it = '', value_name_ro = 'rrr_ausser_Betrieb.Reserve', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9364);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9365) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'operational', value_name_en = 'operational', shortcut_en = '', value_name_de = 'in_Betrieb', shortcut_de = '', value_name_fr = 'en_service', shortcut_fr = '', value_name_it = 'in_funzione', shortcut_it = '', value_name_ro = 'functionala', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9365);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9366) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'operational.tentative', value_name_en = 'operational.tentative', shortcut_en = '', value_name_de = 'in_Betrieb.provisorisch', shortcut_de = '', value_name_fr = 'en_service.provisoire', shortcut_fr = '', value_name_it = 'in_funzione.provvisorio', shortcut_it = '', value_name_ro = 'functionala.provizoriu', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9366);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9367) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'others', value_name_en = 'others', shortcut_en = '', value_name_de = 'weitere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = '', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9367);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9368) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'other.calculation_alternative', value_name_en = 'other.calculation_alternative', shortcut_en = '', value_name_de = 'weitere.Berechnungsvariante', shortcut_de = '', value_name_fr = 'autre.variante_de_calcule', shortcut_fr = '', value_name_it = 'altro.variante_calcolo', shortcut_it = '', value_name_ro = 'alta.varianta_calcul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9368);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9369) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'other.planned', value_name_en = 'other.planned', shortcut_en = '', value_name_de = 'weitere.geplant', shortcut_de = '', value_name_fr = 'autre.planifie', shortcut_fr = '', value_name_it = 'altro.previsto', shortcut_it = '', value_name_ro = 'rrr_weitere.geplant', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9369);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9332,9370) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'status', value_name = 'other.project', value_name_en = 'other.project', shortcut_en = '', value_name_de = 'weitere.Projekt', shortcut_de = '', value_name_fr = 'autre.projet', shortcut_fr = '', value_name_it = 'altro.progetto', shortcut_it = '', value_name_ro = 'alta.proiect', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9332 AND attribute_id = 9370);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9356,9359) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'elevation_determination', value_name = 'accurate', value_name_en = 'accurate', shortcut_en = '', value_name_de = 'genau', shortcut_de = '', value_name_fr = 'precis', shortcut_fr = '', value_name_it = 'precisa', shortcut_it = '', value_name_ro = 'precisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9356 AND attribute_id = 9359);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9356,9360) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'elevation_determination', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9356 AND attribute_id = 9360);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8500,9356,9361) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable', field_name = 'elevation_determination', value_name = 'inaccurate', value_name_en = 'inaccurate', shortcut_en = '', value_name_de = 'ungenau', shortcut_de = '', value_name_fr = 'imprecis', shortcut_fr = '', value_name_it = 'impreciso', shortcut_it = '', value_name_ro = 'imprecisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8500 AND attribute_id = 9356 AND attribute_id = 9361);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9373,9384) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9373 AND attribute_id = 9384);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9373,9385) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', value_name = 'cable_sleeve', value_name_en = 'cable_sleeve', shortcut_en = '', value_name_de = 'Kabelmuffe', shortcut_de = '', value_name_fr = 'manchon_cable', shortcut_fr = '', value_name_it = 'manicotto_del_cavo', shortcut_it = '', value_name_ro = 'manson_de_cablu', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9373 AND attribute_id = 9385);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9373,9386) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', value_name = 'cable_manhole', value_name_en = 'cable_manhole', shortcut_en = '', value_name_de = 'Kabelschacht', shortcut_de = '', value_name_fr = 'chambre_cable', shortcut_fr = '', value_name_it = '', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9373 AND attribute_id = 9386);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9373,9387) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', value_name = 'cabine', value_name_en = 'cabine', shortcut_en = '', value_name_de = 'Kabine', shortcut_de = '', value_name_fr = 'cabine', shortcut_fr = '', value_name_it = 'cabina', shortcut_it = '', value_name_ro = 'cabina', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9373 AND attribute_id = 9387);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9373,9388) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', value_name = 'cable_point', value_name_en = 'cable_point', shortcut_en = '', value_name_de = 'Kabelpunkt', shortcut_de = '', value_name_fr = 'point_de_cable', shortcut_fr = '', value_name_it = 'punto_cavo', shortcut_it = '', value_name_ro = 'punct_de_cablu', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9373 AND attribute_id = 9388);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9373,9389) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'kind', value_name = 'others', value_name_en = 'others', shortcut_en = '', value_name_de = 'weitere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = '', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9373 AND attribute_id = 9389);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9374,9390) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'horizontal_positioning', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9374 AND attribute_id = 9390);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9374,9391) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'horizontal_positioning', value_name = 'inaccurate', value_name_en = 'inaccurate', shortcut_en = '', value_name_de = 'ungenau', shortcut_de = '', value_name_fr = 'imprecis', shortcut_fr = '', value_name_it = 'impreciso', shortcut_it = '', value_name_ro = 'imprecisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9374 AND attribute_id = 9391);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9374,9392) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'horizontal_positioning', value_name = 'accurate', value_name_en = 'accurate', shortcut_en = '', value_name_de = 'genau', shortcut_de = '', value_name_fr = 'precis', shortcut_fr = '', value_name_it = 'precisa', shortcut_it = '', value_name_ro = 'precisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9374 AND attribute_id = 9392);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9376,9394) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'elevation_determination', value_name = 'accurate', value_name_en = 'accurate', shortcut_en = '', value_name_de = 'genau', shortcut_de = '', value_name_fr = 'precis', shortcut_fr = '', value_name_it = 'precisa', shortcut_it = '', value_name_ro = 'precisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9376 AND attribute_id = 9394);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9376,9395) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'elevation_determination', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9376 AND attribute_id = 9395);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9376,9396) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'elevation_determination', value_name = 'inaccurate', value_name_en = 'inaccurate', shortcut_en = '', value_name_de = 'ungenau', shortcut_de = '', value_name_fr = 'imprecis', shortcut_fr = '', value_name_it = 'impreciso', shortcut_it = '', value_name_ro = 'imprecisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9376 AND attribute_id = 9396);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9397) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'inoperative', value_name_en = 'inoperative', shortcut_en = '', value_name_de = 'ausser_Betrieb', shortcut_de = '', value_name_fr = 'hors_service', shortcut_fr = '', value_name_it = 'fuori_servizio', shortcut_it = '', value_name_ro = 'rrr_ausser_Betrieb', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9397);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9398) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'inoperative.reserve', value_name_en = 'inoperative.reserve', shortcut_en = '', value_name_de = 'ausser_Betrieb.Reserve', shortcut_de = '', value_name_fr = 'hors_service.en_reserve', shortcut_fr = '', value_name_it = 'fuori_servizio.riserva', shortcut_it = '', value_name_ro = 'rrr_ausser_Betrieb.Reserve', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9398);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9399) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'operational', value_name_en = 'operational', shortcut_en = '', value_name_de = 'in_Betrieb', shortcut_de = '', value_name_fr = 'en_service', shortcut_fr = '', value_name_it = 'in_funzione', shortcut_it = '', value_name_ro = 'functionala', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9399);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9400) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'operational.tentative', value_name_en = 'operational.tentative', shortcut_en = '', value_name_de = 'in_Betrieb.provisorisch', shortcut_de = '', value_name_fr = 'en_service.provisoire', shortcut_fr = '', value_name_it = 'in_funzione.provvisorio', shortcut_it = '', value_name_ro = 'functionala.provizoriu', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9400);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9401) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'others', value_name_en = 'others', shortcut_en = '', value_name_de = 'weitere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = '', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9401);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9402) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'other.calculation_alternative', value_name_en = 'other.calculation_alternative', shortcut_en = '', value_name_de = 'weitere.Berechnungsvariante', shortcut_de = '', value_name_fr = 'autre.variante_de_calcule', shortcut_fr = '', value_name_it = 'altro.variante_calcolo', shortcut_it = '', value_name_ro = 'alta.varianta_calcul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9402);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9403) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'other.planned', value_name_en = 'other.planned', shortcut_en = '', value_name_de = 'weitere.geplant', shortcut_de = '', value_name_fr = 'autre.planifie', shortcut_fr = '', value_name_it = 'altro.previsto', shortcut_it = '', value_name_ro = 'rrr_weitere.geplant', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9403);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8501,9377,9404) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405cc_cable_point', field_name = 'status', value_name = 'other.project', value_name_en = 'other.project', shortcut_en = '', value_name_de = 'weitere.Projekt', shortcut_de = '', value_name_fr = 'autre.projet', shortcut_fr = '', value_name_it = 'altro.progetto', shortcut_it = '', value_name_ro = 'alta.proiect', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8501 AND attribute_id = 9377 AND attribute_id = 9404);
