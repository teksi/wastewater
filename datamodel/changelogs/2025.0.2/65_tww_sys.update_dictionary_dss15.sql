------ this file updates the  is_dictionary (Modul aquifer(0)) in en on TEKSI
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 07.08.2025 17:25:47
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (30,'aquifer') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET 
   tablename = 'aquifer',
   name_en = 'aquifier',
   shortcut_en = 'AQ',
   name_de = 'Grundwasserleiter',
   shortcut_de = 'GL',
   name_fr = 'Aquifère',
   shortcut_fr = 'AQ',
   name_it = 'Acquifero',
   shortcut_it = '',
   name_ro = 'acvifer',
   shortcut_ro = ''
WHERE (id = 30 AND tablename = 'aquifer');




--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,283) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'average_groundwater_level',
   field_name_en = 'average_groundwater_level',
   field_name_de = 'MittlererGWSpiegel',
   field_name_fr = 'NIVEAU_NAPPE_MOY',
   field_name_it = 'zzz_MittlererGWSpiegel',
   field_name_ro = 'nivelul_mediu_al_apelor_subterane',
   field_description_en = 'Average level of groundwater table',
   field_description_de = 'Höhe des mittleren Grundwasserspiegels',
   field_description_fr = 'Niveau moyen de la nappe',
   field_description_it = 'zzz_Höhe des mittleren Grundwasserspiegels',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'decimal(7,3)',
   field_unit_en = '[m.a.sl.]',
   field_unit_description_en = 'meters above sea level [m.a.sl.]',
   field_unit_de = '[M.ü.M.]',
   field_unit_description_de = 'Meter über Meer [M.ü.M.]',
   field_unit_fr = '[m.s.m.]',
   field_unit_description_fr = 'mètres sur mers [m.s.m.]',
   field_unit_it = '[m s.l.m.]',
   field_unit_description_it = 'metro sul livello del mare [m s.l.m.]',
   field_unit_ro = 'rrr_[M.ü.M.]',
   field_unit_description_ro = 'rrr_Meter über Meer [M.ü.M.]',
   field_max = 5000,
   field_min = -200
WHERE (class_id = 30 AND attribute_id = 283);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,2519) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'identifier',
   field_name_en = 'identifier',
   field_name_de = 'Bezeichnung',
   field_name_fr = 'DESIGNATION',
   field_name_it = 'denominazione',
   field_name_ro = 'identificator',
   field_description_en = '',
   field_description_de = '',
   field_description_fr = '',
   field_description_it = '',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'varchar(20)',
   field_unit_en = '',
   field_unit_description_en = '',
   field_unit_de = '',
   field_unit_description_de = '',
   field_unit_fr = '',
   field_unit_description_fr = '',
   field_unit_it = '',
   field_unit_description_it = '',
   field_unit_ro = '',
   field_unit_description_ro = '',
   field_max = NULL,
   field_min = NULL
WHERE (class_id = 30 AND attribute_id = 2519);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,284) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'maximal_groundwater_level',
   field_name_en = 'maximal_groundwater_level',
   field_name_de = 'MaxGWSpiegel',
   field_name_fr = 'NIVEAU_NAPPE_MAX',
   field_name_it = 'livello_massimo_della_falda_acquifera',
   field_name_ro = 'nivelul_maxim_al_apelor_subterane',
   field_description_en = 'Maximal level of ground water table',
   field_description_de = 'Maximale Lage des Grundwasserspiegels',
   field_description_fr = 'Niveau maximal de la nappe',
   field_description_it = 'zzz_Maximale Lage des Grundwasserspiegels',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'decimal(7,3)',
   field_unit_en = '[m.a.sl.]',
   field_unit_description_en = 'meters above sea level [m.a.sl.]',
   field_unit_de = '[M.ü.M.]',
   field_unit_description_de = 'Meter über Meer [M.ü.M.]',
   field_unit_fr = '[m.s.m.]',
   field_unit_description_fr = 'mètres sur mers [m.s.m.]',
   field_unit_it = '[m s.l.m.]',
   field_unit_description_it = 'metro sul livello del mare [m s.l.m.]',
   field_unit_ro = 'rrr_[M.ü.M.]',
   field_unit_description_ro = 'rrr_Meter über Meer [M.ü.M.]',
   field_max = 5000,
   field_min = -200
WHERE (class_id = 30 AND attribute_id = 284);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,285) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'minimal_groundwater_level',
   field_name_en = 'minimal_groundwater_level',
   field_name_de = 'MinGWSpiegel',
   field_name_fr = 'NIVEAU_NAPPE_MIN',
   field_name_it = 'zzz_MinGWSpiegel',
   field_name_ro = 'nivelul_minim_al_apelor_subterane',
   field_description_en = 'Minimal level of groundwater table',
   field_description_de = 'Minimale Lage des Grundwasserspiegels',
   field_description_fr = 'Niveau minimal de la nappe',
   field_description_it = 'zzz_Minimale Lage des Grundwasserspiegels',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'decimal(7,3)',
   field_unit_en = '[m.a.sl.]',
   field_unit_description_en = 'meters above sea level [m.a.sl.]',
   field_unit_de = '[M.ü.M.]',
   field_unit_description_de = 'Meter über Meer [M.ü.M.]',
   field_unit_fr = '[m.s.m.]',
   field_unit_description_fr = 'mètres sur mers [m.s.m.]',
   field_unit_it = '[m s.l.m.]',
   field_unit_description_it = 'metro sul livello del mare [m s.l.m.]',
   field_unit_ro = 'rrr_[M.ü.M.]',
   field_unit_description_ro = 'rrr_Meter über Meer [M.ü.M.]',
   field_max = 5000,
   field_min = -200
WHERE (class_id = 30 AND attribute_id = 285);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,9210) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'oid',
   field_name_en = 'oid',
   field_name_de = 'OID',
   field_name_fr = 'OID',
   field_name_it = 'OID',
   field_name_ro = 'OID',
   field_description_en = 'Stable unique object identification for all objects and classes',
   field_description_de = 'Stabile eindeutige Objektidentifikation für alle Objekte und Klassen',
   field_description_fr = 'Identification d''objet unique stable pour tous les objets et toutes les classes',
   field_description_it = 'Identificazione univoca e stabile per tutti gli oggetti e le classi',
   field_description_ro = 'Identificare unica stabila a obiectelor pentru toate obiectele ?i clasele',
   field_mandatory = ARRAY['GEP_Verband','PAA','SAA']::.plantype[],
   field_visible = 'true',
   field_datatype = 'varchar(16)',
   field_unit_en = '',
   field_unit_description_en = '',
   field_unit_de = '',
   field_unit_description_de = '',
   field_unit_fr = '',
   field_unit_description_fr = '',
   field_unit_it = '',
   field_unit_description_it = '',
   field_unit_ro = '',
   field_unit_description_ro = '',
   field_max = NULL,
   field_min = NULL
WHERE (class_id = 30 AND attribute_id = 9210);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,2246) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'perimeter',
   field_name_en = 'perimeter',
   field_name_de = 'Perimeter',
   field_name_fr = 'PERIMETRE',
   field_name_it = 'perimetro',
   field_name_ro = 'perimetru',
   field_description_en = 'Boundary points of the perimeter',
   field_description_de = 'Begrenzungspunkte der Fläche',
   field_description_fr = 'Points de délimitation de la surface',
   field_description_it = 'zzz_Begrenzungspunkte der Fläche',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'geometry',
   field_unit_en = '[LKoord]',
   field_unit_description_en = 'points with coordinates in the swiss national grid',
   field_unit_de = '[LKoord]',
   field_unit_description_de = 'Punkte mit Schweizer Landeskoordinaten',
   field_unit_fr = '[CoordNat]',
   field_unit_description_fr = 'points avec coordonnées dans le système de coordonnées suisse',
   field_unit_it = '[LKoord]',
   field_unit_description_it = 'zzz_Punkte mit Schweizer Landeskoordinaten',
   field_unit_ro = '[LKoord]',
   field_unit_description_ro = 'rrr_Punkte mit Schweizer Landeskoordinaten',
   field_max = NULL,
   field_min = NULL
WHERE (class_id = 30 AND attribute_id = 2246);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (30,2577) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'aquifer',
   field_name = 'remark',
   field_name_en = 'remark',
   field_name_de = 'Bemerkung',
   field_name_fr = 'REMARQUE',
   field_name_it = 'osservazione',
   field_name_ro = 'observatie',
   field_description_en = 'General remarks',
   field_description_de = 'Allgemeine Bemerkungen',
   field_description_fr = 'Remarques générales',
   field_description_it = 'Osservazioni generali',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'varchar(80)',
   field_unit_en = '',
   field_unit_description_en = '',
   field_unit_de = '',
   field_unit_description_de = '',
   field_unit_fr = '',
   field_unit_description_fr = '',
   field_unit_it = '',
   field_unit_description_it = '',
   field_unit_ro = '',
   field_unit_description_ro = '',
   field_max = NULL,
   field_min = NULL
WHERE (class_id = 30 AND attribute_id = 2577);



--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (104,'planning_zone') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET 
   tablename = 'planning_zone',
   name_en = 'planning zone',
   shortcut_en = 'PL',
   name_de = 'Planungszone',
   shortcut_de = 'PL',
   name_fr = 'Zones réservées',
   shortcut_fr = 'ZR',
   name_it = 'Zona di pianificazione',
   shortcut_it = '',
   name_ro = 'rrr_Planungszone',
   shortcut_ro = ''
WHERE (id = 104 AND tablename = 'planning_zone');




--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (104,313) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'planning_zone',
   field_name = 'kind',
   field_name_en = 'kind',
   field_name_de = 'Art',
   field_name_fr = 'GENRE',
   field_name_it = 'tipo',
   field_name_ro = 'tip',
   field_description_en = 'Type of planning zone',
   field_description_de = 'Art der Bauzone',
   field_description_fr = 'Genre de zones à bâtir',
   field_description_it = 'Tipo di zona_di_pianificazione',
   field_description_ro = 'Tipul zonei de construc?ie',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'integer',
   field_unit_en = '',
   field_unit_description_en = '',
   field_unit_de = '',
   field_unit_description_de = '',
   field_unit_fr = '',
   field_unit_description_fr = '',
   field_unit_it = '',
   field_unit_description_it = '',
   field_unit_ro = '',
   field_unit_description_ro = '',
   field_max = NULL,
   field_min = NULL
WHERE (class_id = 104 AND attribute_id = 313);

--- Adapt tww_sys.dictionary_od_field
INSERT INTO tww_sys.dictionary_od_field (class_id, attribute_id) VALUES (104,3623) ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_field  SET
   table_name = 'planning_zone',
   field_name = 'perimeter',
   field_name_en = 'perimeter',
   field_name_de = 'Perimeter',
   field_name_fr = 'PERIMETRE',
   field_name_it = 'perimetro',
   field_name_ro = 'perimetru',
   field_description_en = 'Boundary points of the perimeter',
   field_description_de = 'Begrenzungspunkte der Fläche',
   field_description_fr = 'Points de délimitation de la surface',
   field_description_it = 'zzz_Begrenzungspunkte der Fläche',
   field_description_ro = '',
   field_mandatory = ARRAY['kein_Plantyp_definiert']::.plantype[],
   field_visible = 'true',
   field_datatype = 'geometry',
   field_unit_en = '[LKoord]',
   field_unit_description_en = 'Swiss national grid coordinates',
   field_unit_de = '[LKoord]',
   field_unit_description_de = 'Punkte mit Schweizer Landeskoordinaten',
   field_unit_fr = '[CoordNat]',
   field_unit_description_fr = 'points avec coordonnées dans le système de coordonnées suisse',
   field_unit_it = '[LKoord]',
   field_unit_description_it = 'Punti con coordinate nazionali svizzere',
   field_unit_ro = '[LKoord]',
   field_unit_description_ro = 'rrr_Schweizer Landeskoordinaten',
   field_max = NULL,
   field_min = NULL
WHERE (class_id = 104 AND attribute_id = 3623);





INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (104,313,29) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET 
   table_name = 'planning_zone',
   field_name = 'kind',
   value_name = 'residential_zone',
   value_name_en = 'residential_zone',
   shortcut_en = '',
   value_name_de = 'Wohnzone',
   shortcut_de = '',
   value_name_fr = 'zone_d_habitations',
   shortcut_fr = '',
   value_name_it = 'zzz_Wohnzone',
   shortcut_it = '',
   value_name_ro = 'rrr_Wohnzone',
   shortcut_ro = '',
   value_description_en = '',
   value_description_de = '',
   value_description_fr = '',
   value_description_it = '',
   value_description_ro = ''
WHERE (class_id = 104 AND attribute_id = 313 AND attribute_id = 29);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (104,313,2990) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET 
   table_name = 'planning_zone',
   field_name = 'kind',
   value_name = 'other',
   value_name_en = 'other',
   shortcut_en = '',
   value_name_de = 'andere',
   shortcut_de = '',
   value_name_fr = 'autres',
   shortcut_fr = '',
   value_name_it = 'altro',
   shortcut_it = '',
   value_name_ro = 'rrr_altul',
   shortcut_ro = '',
   value_description_en = '',
   value_description_de = '',
   value_description_fr = '',
   value_description_it = '',
   value_description_ro = ''
WHERE (class_id = 104 AND attribute_id = 313 AND attribute_id = 2990);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (104,313,30) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET 
   table_name = 'planning_zone',
   field_name = 'kind',
   value_name = 'agricultural_zone',
   value_name_en = 'agricultural_zone',
   shortcut_en = '',
   value_name_de = 'Landwirtschaftszone',
   shortcut_de = '',
   value_name_fr = 'zone_agricole',
   shortcut_fr = '',
   value_name_it = 'zzz_Landwirtschaftszone',
   shortcut_it = '',
   value_name_ro = 'rrr_Landwirtschaftszone',
   shortcut_ro = '',
   value_description_en = '',
   value_description_de = '',
   value_description_fr = '',
   value_description_it = '',
   value_description_ro = ''
WHERE (class_id = 104 AND attribute_id = 313 AND attribute_id = 30);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (104,313,3077) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET 
   table_name = 'planning_zone',
   field_name = 'kind',
   value_name = 'unknown',
   value_name_en = 'unknown',
   shortcut_en = '',
   value_name_de = 'unbekannt',
   shortcut_de = '',
   value_name_fr = 'inconnu',
   shortcut_fr = '',
   value_name_it = 'sconosciuto',
   shortcut_it = '',
   value_name_ro = 'necunoscuta',
   shortcut_ro = '',
   value_description_en = '',
   value_description_de = '',
   value_description_fr = '',
   value_description_it = '',
   value_description_ro = ''
WHERE (class_id = 104 AND attribute_id = 313 AND attribute_id = 3077);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (104,313,31) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET 
   table_name = 'planning_zone',
   field_name = 'kind',
   value_name = 'commercial_zone',
   value_name_en = 'commercial_zone',
   shortcut_en = '',
   value_name_de = 'Gewerbezone',
   shortcut_de = '',
   value_name_fr = 'zone_artisanale',
   shortcut_fr = '',
   value_name_it = 'zzz_Gewerbezone',
   shortcut_it = '',
   value_name_ro = 'rrr_Gewerbezone',
   shortcut_ro = '',
   value_description_en = '',
   value_description_de = '',
   value_description_fr = '',
   value_description_it = '',
   value_description_ro = ''
WHERE (class_id = 104 AND attribute_id = 313 AND attribute_id = 31);


INSERT INTO tww_sys.dictionary_od_values (class_id, attribute_id, value_id) VALUES (104,313,32) ON CONFLICT DO NOTHING;
UPDATE tww_sys.dictionary_od_values SET 
   table_name = 'planning_zone',
   field_name = 'kind',
   value_name = 'industrial_zone',
   value_name_en = 'industrial_zone',
   shortcut_en = '',
   value_name_de = 'Industriezone',
   shortcut_de = '',
   value_name_fr = 'zone_industrielle',
   shortcut_fr = '',
   value_name_it = 'zzz_Industriezone',
   shortcut_it = '',
   value_name_ro = 'rrr_Industriezone',
   shortcut_ro = '',
   value_description_en = '',
   value_description_de = '',
   value_description_fr = '',
   value_description_it = '',
   value_description_ro = ''
WHERE (class_id = 104 AND attribute_id = 313 AND attribute_id = 32);



