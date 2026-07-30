------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 30.07.2026 16:03:26
------ with 3D coordinates

--- Adapt tdh_sys.dictionary_od_table
INSERT INTO tdh_sys.dictionary_od_table (id, tablename) VALUES (8500,'sia405cc_cable') ON CONFLICT DO NOTHING;

UPDATE tdh_sys.dictionary_od_table SET
   tablename = 'sia405cc_cable',
   name_en = 'cable',
   display_en = 'cable',
   shortcut_en = 'CB',
   name_de = 'Kabel',
   display_de = 'Kabel',
   shortcut_de = '',
   name_fr = 'Cable',
   display_fr = 'Cable',
   shortcut_fr = '',
   name_it = 'cavo',
   display_it = 'Cavo',
   shortcut_it = '',
   name_ro = 'cablue',
   display_ro = 'Cablu',
   shortcut_ro = ''
WHERE (id = 8500 AND tablename = 'sia405cc_cable');

--- Adapt tdh_sys.dictionary_od_table
INSERT INTO tdh_sys.dictionary_od_table (id, tablename) VALUES (8501,'sia405cc_cable_point') ON CONFLICT DO NOTHING;

UPDATE tdh_sys.dictionary_od_table SET
   tablename = 'sia405cc_cable_point',
   name_en = 'cable_point',
   display_en = 'cable point',
   shortcut_en = 'CI',
   name_de = 'Kabelpunkt',
   display_de = 'Kabelpunkt',
   shortcut_de = '',
   name_fr = 'Point_cable',
   display_fr = 'Point cable',
   shortcut_fr = '',
   name_it = 'punto_cavo',
   display_it = 'Punto cavo',
   shortcut_it = '',
   name_ro = 'punct_de_cablu',
   display_ro = 'Punct de cablu',
   shortcut_ro = ''
WHERE (id = 8501 AND tablename = 'sia405cc_cable_point');

