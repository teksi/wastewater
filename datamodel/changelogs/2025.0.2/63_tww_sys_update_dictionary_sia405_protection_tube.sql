------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 05.08.2025 16:52:45
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (8502,'sia405pt_protection_tube') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'sia405pt_protection_tube', name_en = 'protection tube', shortcut_en = 'PT', name_de = 'Schutzrohr', shortcut_de = 'PT', name_fr = 'tube de protection', shortcut_fr = 'TP', name_it = 'pozzetto termico', shortcut_it = '', name_ro = 'rrr_Schutzrohr', shortcut_ro = ''
WHERE (id = 8502 AND tablename = 'sia405pt_protection_tube');




--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9418) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'name_number', field_name_en = 'name_number', field_name_de = 'Name_Nummer', field_name_fr = 'Nom_numero', field_name_it = 'nome_numero', field_name_ro = 'nume_numarul', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(40)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9418);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9419) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'geometry', field_name_en = 'geometry', field_name_de = 'Geometrie', field_name_fr = 'Geometrie', field_name_it = 'geometria', field_name_ro = 'geometria', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'geometry', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9419);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9420) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', field_name_en = 'material', field_name_de = 'Material', field_name_fr = 'Materiau', field_name_it = 'materiale', field_name_ro = 'material', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9420);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9421) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'nominal_diameter', field_name_en = 'nominal_diameter', field_name_de = 'Nennweite', field_name_fr = 'Largeur_nominale', field_name_it = 'larghezza_nominale', field_name_ro = 'diametrul_nominal', field_description_en = 'as TEXT, as in some cases double values with slash (eg. 1500/800)', field_description_de = 'als TEXT, da zum Teil auch Doppelwerte mit Schrägstrich (z.B. 1500/800)', field_description_fr = 'comme TEXTE, parcequ''on a aussi des valeurs doubles (par example 1500/800)', field_description_it = 'come TESTO, poiché in alcuni casi i valori sono doppi con la barra (es. 1500/800).', field_description_ro = 'ca TEXT, deoarece în unele cazuri se dubleaza valorile cu o bara oblica (de exemplu, 1500/800)', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(10)', field_unit_en = '', field_unit_description_en = 'as TEXT, because sometimes also double values with slash inbetween eg. 500/800', field_unit_de = '', field_unit_description_de = 'als TEXT, da zum Teil auch Doppelwerte mit Schrägstrich (1500/1000)', field_unit_fr = '', field_unit_description_fr = 'En tant que TEXT, car peut contenir des valeurs doubles avec barre oblique (1500/1000)', field_unit_it = '', field_unit_description_it = 'come TESTO, poiché in alcuni casi valori doppi con slash (1500/1000)', field_unit_ro = '', field_unit_description_ro = 'rrr_als TEXT, da zum Teil auch Doppelwerte mit Schrägstrich (1500/1000)', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9421);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9422) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'outside_diameter', field_name_en = 'outside_diameter', field_name_de = 'Aussendurchmesser', field_name_fr = 'Diametre_exterieur', field_name_it = 'diametro_esterno', field_name_ro = 'diametrul_exterior', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimétre [mm]', field_unit_it = '[mm]', field_unit_description_it = 'millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 999999, field_min = 0
WHERE (class_id = 8502 AND attribute_id = 9422);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9423) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'lenght', field_name_en = 'lenght', field_name_de = 'Laenge', field_name_fr = 'Longeur', field_name_it = 'lunghezza', field_name_ro = 'lungime', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '[mm]', field_unit_description_en = 'millimeter [mm]', field_unit_de = '[mm]', field_unit_description_de = 'Millimeter [mm]', field_unit_fr = '[mm]', field_unit_description_fr = 'milimétre [mm]', field_unit_it = '[mm]', field_unit_description_it = 'millimetro [mm]', field_unit_ro = '[mm]', field_unit_description_ro = 'rrr_Millimeter [mm]', field_max = 999999, field_min = 0
WHERE (class_id = 8502 AND attribute_id = 9423);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9424) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'installation_year', field_name_en = 'installation_year', field_name_de = 'Einbaujahr', field_name_fr = 'Annee_construction', field_name_it = 'anno_costruzione', field_name_ro = 'anul_instalarii', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'smallint', field_unit_en = '', field_unit_description_en = ' If unknown set lowest value of value range', field_unit_de = '', field_unit_description_de = 'Falls unbekannt, tiefsten Wert des Wertebereichs einsetzen', field_unit_fr = '', field_unit_description_fr = 'Si inconnu ajouter la plus bas valeur du domaine des valeurs', field_unit_it = '', field_unit_description_it = 'Se sconosciuto, inserire valore minimo dell’intervallo di valori', field_unit_ro = '', field_unit_description_ro = 'rrr_Falls unbekannt, tiefsten Wert des Wertebereichs einsetzen', field_max = 2100, field_min = 1800
WHERE (class_id = 8502 AND attribute_id = 9424);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9425) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'horizontal_positioning', field_name_en = 'horizontal_positioning', field_name_de = 'Lagebestimmung', field_name_fr = 'Determination_planimetrique', field_name_it = 'determinazione_posizione', field_name_ro = 'precizie_pozitie', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9425);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9426) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', field_name_en = 'status', field_name_de = 'Status', field_name_fr = 'Etat', field_name_it = 'stato', field_name_ro = 'stare', field_description_en = 'Operating and planning status of the structure', field_description_de = 'Betriebs- bzw. Planungszustand des Bauwerks', field_description_fr = 'Etat de fonctionnement et de planification de l’ouvrage', field_description_it = 'Stato di funzionamento e di pianificazione del manufatto.', field_description_ro = '', field_mandatory = ARRAY['Leitungskataster','Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'integer', field_unit_en = '', field_unit_description_en = 'extends value range of SIA405 status', field_unit_de = '', field_unit_description_de = 'Erweitert Wertebereich von SIA405 Status', field_unit_fr = '', field_unit_description_fr = 'extension valeurs SIA405 Etat', field_unit_it = '', field_unit_description_it = 'dilatato codominio SIA405 Stato', field_unit_ro = '', field_unit_description_ro = 'rrr_Erweitert Wertebereich von SIA405 Status', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9426);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9427) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'sur_plus_cover', field_name_en = 'sur_plus_cover', field_name_de = 'Ueberdeckung', field_name_fr = 'Couverture', field_name_it = 'zzz_Ueberdeckung', field_name_ro = '', field_description_en = 'yyy_mittlerer Wert eines Objektes', field_description_de = 'mittlerer Wert eines Objektes', field_description_fr = 'xxx_mittlerer Wert eines Objektes', field_description_it = 'zzz_mittlerer Wert eines Objektes', field_description_ro = 'rrr_mittlerer Wert eines Objektes', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'decimal(4,1)', field_unit_en = '[m]', field_unit_description_en = 'meter [m]', field_unit_de = '[m]', field_unit_description_de = 'Meter [m]', field_unit_fr = '[m]', field_unit_description_fr = 'mètre [m]', field_unit_it = '[m]', field_unit_description_it = 'metro [m]', field_unit_ro = '[m]', field_unit_description_ro = 'rrr_Meter [m]', field_max = 999.9, field_min = 0
WHERE (class_id = 8502 AND attribute_id = 9427);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9428) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'condition', field_name_en = 'condition', field_name_de = 'Zustand', field_name_fr = 'Condition', field_name_it = 'condizione', field_name_ro = 'rrr_Zustand', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(30)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9428);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9429) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'remark', field_name_en = 'remark', field_name_de = 'Bemerkung', field_name_fr = 'Remarque', field_name_it = 'osservazione', field_name_ro = 'observatie', field_description_en = 'General remarks', field_description_de = 'Allgemeine Bemerkungen', field_description_fr = 'Remarques générales', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'varchar(80)', field_unit_en = '', field_unit_description_en = '', field_unit_de = '', field_unit_description_de = '', field_unit_fr = '', field_unit_description_fr = '', field_unit_it = '', field_unit_description_it = '', field_unit_ro = '', field_unit_description_ro = '', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9429);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (8502,9457) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'sia405pt_protection_tube', field_name = 'geometry3d', field_name_en = 'geometry3d', field_name_de = 'Geometrie3D', field_name_fr = 'Geometrie3D', field_name_it = 'geometria3d', field_name_ro = 'geometria3D', field_description_en = '', field_description_de = '', field_description_fr = '', field_description_it = '', field_description_ro = '', field_mandatory = ARRAY['Werkinformation']::tww_od.plantype[], field_visible = 'true', field_datatype = 'geometry', field_unit_en = '[HKoord]', field_unit_description_en = 'points with coordinates in the swiss national grid', field_unit_de = '[HKoord]', field_unit_description_de = 'Punkte mit Schweizer Landeskoordinaten [HKoord]', field_unit_fr = '[CoordH]', field_unit_description_fr = 'points avec coordonnées dans le système de coordonnées suisse', field_unit_it = '[HKoord]', field_unit_description_it = 'Punti con coordinate nazionali svizzere', field_unit_ro = '[HKoord]', field_unit_description_ro = 'rrr_Punkte mit Schweizer Landeskoordinaten', field_max = NULL, field_min = NULL
WHERE (class_id = 8502 AND attribute_id = 9457);





INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9432) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9432);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9433) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'plastic.polyethylene', value_name_en = 'plastic.polyethylene', shortcut_en = '', value_name_de = 'Kunststoff.Polyethylen', shortcut_de = '', value_name_fr = 'matiere_synthetique.polyethylene', shortcut_fr = '', value_name_it = 'materiale_sintetico.polietilene', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9433);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9434) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'plastic.PVC', value_name_en = 'plastic.PVC', shortcut_en = '', value_name_de = 'Kunststoff.Polyvinylchlorid', shortcut_de = '', value_name_fr = 'matiere_synthetique.chlorure_de_polyvinyle', shortcut_fr = '', value_name_it = 'materiale_sintetico.polivinilcloruro', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9434);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9435) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'steel', value_name_en = 'steel', shortcut_en = '', value_name_de = 'Stahl', shortcut_de = '', value_name_fr = 'acier', shortcut_fr = '', value_name_it = 'acciaio', shortcut_it = '', value_name_ro = 'otel', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9435);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9436) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'cast_iron.ductile_cast', value_name_en = 'cast_iron.ductile_cast', shortcut_en = '', value_name_de = 'Guss.Guss_duktil', shortcut_de = '', value_name_fr = 'fonte.fonte_ductil', shortcut_fr = '', value_name_it = 'ghisa.ghisa_duttile', shortcut_it = '', value_name_ro = 'fonta.fonta_ductila', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9436);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9437) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'cast_iron.gray_iron', value_name_en = 'cast_iron.gray_iron', shortcut_en = '', value_name_de = 'Guss.Grauguss', shortcut_de = '', value_name_fr = 'fonte.fonte_grise', shortcut_fr = '', value_name_it = 'ghisa.ghisa_grigia', shortcut_it = '', value_name_ro = 'fonta.fonta_cenusie', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9437);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9420,9438) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'material', value_name = 'concrete', value_name_en = 'concrete', shortcut_en = '', value_name_de = 'Beton', shortcut_de = '', value_name_fr = 'beton', shortcut_fr = '', value_name_it = 'calcestruzzo', shortcut_it = '', value_name_ro = 'beton', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9420 AND attribute_id = 9438);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9425,9443) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'horizontal_positioning', value_name = 'accurate', value_name_en = 'accurate', shortcut_en = '', value_name_de = 'genau', shortcut_de = '', value_name_fr = 'precis', shortcut_fr = '', value_name_it = 'precisa', shortcut_it = '', value_name_ro = 'precisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9425 AND attribute_id = 9443);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9425,9444) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'horizontal_positioning', value_name = 'unknown', value_name_en = 'unknown', shortcut_en = '', value_name_de = 'unbekannt', shortcut_de = '', value_name_fr = 'inconnue', shortcut_fr = '', value_name_it = 'sconosciuto', shortcut_it = '', value_name_ro = 'necunoscuta', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9425 AND attribute_id = 9444);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9425,9445) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'horizontal_positioning', value_name = 'inaccurate', value_name_en = 'inaccurate', shortcut_en = '', value_name_de = 'ungenau', shortcut_de = '', value_name_fr = 'imprecis', shortcut_fr = '', value_name_it = 'impreciso', shortcut_it = '', value_name_ro = 'imprecisa', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9425 AND attribute_id = 9445);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9446) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'inoperative', value_name_en = 'inoperative', shortcut_en = '', value_name_de = 'ausser_Betrieb', shortcut_de = '', value_name_fr = 'hors_service', shortcut_fr = '', value_name_it = 'fuori_servizio', shortcut_it = '', value_name_ro = 'rrr_ausser_Betrieb', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9446);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9447) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'inoperative.reserve', value_name_en = 'inoperative.reserve', shortcut_en = '', value_name_de = 'ausser_Betrieb.Reserve', shortcut_de = '', value_name_fr = 'hors_service.en_reserve', shortcut_fr = '', value_name_it = 'fuori_servizio.riserva', shortcut_it = '', value_name_ro = 'rrr_ausser_Betrieb.Reserve', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9447);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9448) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'operational', value_name_en = 'operational', shortcut_en = '', value_name_de = 'in_Betrieb', shortcut_de = '', value_name_fr = 'en_service', shortcut_fr = '', value_name_it = 'in_funzione', shortcut_it = '', value_name_ro = 'functionala', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9448);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9449) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'operational.tentative', value_name_en = 'operational.tentative', shortcut_en = '', value_name_de = 'in_Betrieb.provisorisch', shortcut_de = '', value_name_fr = 'en_service.provisoire', shortcut_fr = '', value_name_it = 'in_funzione.provvisorio', shortcut_it = '', value_name_ro = 'functionala.provizoriu', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9449);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9450) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'others', value_name_en = 'others', shortcut_en = '', value_name_de = 'weitere', shortcut_de = '', value_name_fr = 'autre', shortcut_fr = '', value_name_it = '', shortcut_it = '', value_name_ro = '', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9450);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9451) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'other.calculation_alternative', value_name_en = 'other.calculation_alternative', shortcut_en = '', value_name_de = 'weitere.Berechnungsvariante', shortcut_de = '', value_name_fr = 'autre.variante_de_calcule', shortcut_fr = '', value_name_it = 'altro.variante_calcolo', shortcut_it = '', value_name_ro = 'alta.varianta_calcul', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9451);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9452) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'other.planned', value_name_en = 'other.planned', shortcut_en = '', value_name_de = 'weitere.geplant', shortcut_de = '', value_name_fr = 'autre.planifie', shortcut_fr = '', value_name_it = 'altro.previsto', shortcut_it = '', value_name_ro = 'rrr_weitere.geplant', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9452);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (8502,9426,9453) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET
   table_name = 'sia405pt_protection_tube', field_name = 'status', value_name = 'other.project', value_name_en = 'other.project', shortcut_en = '', value_name_de = 'weitere.Projekt', shortcut_de = '', value_name_fr = 'autre.projet', shortcut_fr = '', value_name_it = 'altro.progetto', shortcut_it = '', value_name_ro = 'alta.proiect', shortcut_ro = '', value_description_en = '', value_description_de = '', value_description_fr = '', value_description_it = '', value_description_ro = ''
WHERE (class_id = 8502 AND attribute_id = 9426 AND attribute_id = 9453);
