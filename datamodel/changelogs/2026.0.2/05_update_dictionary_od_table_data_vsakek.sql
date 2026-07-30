------ this file updates the tww is_dictionary (Modul kek(2020)) in en on TEKSI
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 30.07.2026 15:51:24
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3679,'examination') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'examination',
   name_en = 'examination',
   display_en = 'examination',
   shortcut_en = 'EX',
   name_de = 'Untersuchung',
   display_de = 'Untersuchung',
   shortcut_de = 'UN',
   name_fr = 'EXAMEN',
   display_fr = 'Examen',
   shortcut_fr = 'IN',
   name_it = 'ispezione',
   display_it = 'Ispezione',
   shortcut_it = '',
   name_ro = 'rrr_Untersuchung',
   display_ro = 'rrr_Untersuchung',
   shortcut_ro = ''
WHERE (id = 3679 AND tablename = 'examination');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3705,'damage') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'damage',
   name_en = 'damage',
   display_en = 'damage',
   shortcut_en = 'DG',
   name_de = 'Schaden',
   display_de = 'Schaden',
   shortcut_de = 'SC',
   name_fr = 'DOMMAGE',
   display_fr = 'Dommage',
   shortcut_fr = 'DO',
   name_it = 'danni',
   display_it = 'Danni',
   shortcut_it = '',
   name_ro = 'rrr_Schaden',
   display_ro = 'rrr_Schaden',
   shortcut_ro = ''
WHERE (id = 3705 AND tablename = 'damage');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3714,'damage_channel') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'damage_channel',
   name_en = 'damage_channel',
   display_en = 'damage channel',
   shortcut_en = 'DC',
   name_de = 'Kanalschaden',
   display_de = 'Kanalschaden',
   shortcut_de = 'KS',
   name_fr = 'DOMMAGE_AUX_CANALISATIONS',
   display_fr = 'Dommage aux canalisations',
   shortcut_fr = 'DC',
   name_it = 'danni_canalizzazione',
   display_it = 'Danni canalizzazione',
   shortcut_it = '',
   name_ro = 'rrr_Kanalschaden',
   display_ro = 'rrr_Kanalschaden',
   shortcut_ro = ''
WHERE (id = 3714 AND tablename = 'damage_channel');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3728,'damage_manhole') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'damage_manhole',
   name_en = 'damage_manhole',
   display_en = 'damage manhole',
   shortcut_en = 'DM',
   name_de = 'Normschachtschaden',
   display_de = 'Normschachtschaden',
   shortcut_de = 'SS',
   name_fr = 'DOMMAGE_CHAMBRE_STANDARD',
   display_fr = 'Dommage chambre standard',
   shortcut_fr = 'SS',
   name_it = 'danni_pozzetto_standard',
   display_it = 'danni_pozzetto_standard',
   shortcut_it = '',
   name_ro = 'rrr_Normschachtschaden',
   display_ro = 'rrr_Normschachtschaden',
   shortcut_ro = ''
WHERE (id = 3728 AND tablename = 'damage_manhole');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3754,'file') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'file',
   name_en = 'file',
   display_en = 'file',
   shortcut_en = 'FI',
   name_de = 'Datei',
   display_de = 'Datei',
   shortcut_de = 'DA',
   name_fr = 'FICHIER',
   display_fr = 'Fichier',
   shortcut_fr = 'FI',
   name_it = 'file',
   display_it = 'File',
   shortcut_it = '',
   name_ro = 'fisier',
   display_ro = 'Fi?ier',
   shortcut_ro = ''
WHERE (id = 3754 AND tablename = 'file');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3776,'data_media') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'data_media',
   name_en = 'data_media',
   display_en = 'data media',
   shortcut_en = 'VO',
   name_de = 'Datentraeger',
   display_de = 'Datenträger',
   shortcut_de = 'DT',
   name_fr = 'SUPPORT_DONNEES',
   display_fr = 'Support données',
   shortcut_fr = 'SO',
   name_it = 'supporto_dati',
   display_it = 'Supporto dati',
   shortcut_it = '',
   name_ro = 'suport_de_date',
   display_ro = 'rrr_Datentraeger',
   shortcut_ro = ''
WHERE (id = 3776 AND tablename = 'data_media');

