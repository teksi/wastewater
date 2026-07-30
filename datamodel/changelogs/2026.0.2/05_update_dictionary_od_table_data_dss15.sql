------ this file updates the  is_dictionary (Modul aquifer(0)) in en on TEKSI
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 30.07.2026 16:11:23
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (30,'dss15_aquifer') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'dss15_aquifer',
   name_en = 'aquifer',
   display_en = 'aquifier',
   shortcut_en = 'AQ',
   name_de = 'Grundwasserleiter',
   display_de = 'Grundwasserleiter',
   shortcut_de = 'GL',
   name_fr = 'AQUIFERE',
   display_fr = 'Aquifère',
   shortcut_fr = 'AQ',
   name_it = 'acquifero',
   display_it = 'Acquifero',
   shortcut_it = '',
   name_ro = 'acvifer',
   display_ro = 'acvifer',
   shortcut_ro = ''
WHERE (id = 30 AND tablename = 'dss15_aquifer');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (104,'dss15_planning_zone') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'dss15_planning_zone',
   name_en = 'planning_zone',
   display_en = 'planning zone',
   shortcut_en = 'PL',
   name_de = 'Planungszone',
   display_de = 'Planungszone',
   shortcut_de = 'PL',
   name_fr = 'ZONE_RESERVEE',
   display_fr = 'Zones réservées',
   shortcut_fr = 'ZR',
   name_it = 'zzz_zona_di_pianificazione',
   display_it = 'Zona di pianificazione',
   shortcut_it = '',
   name_ro = 'rrr_Planungszone',
   display_ro = 'rrr_Planungszone',
   shortcut_ro = ''
WHERE (id = 104 AND tablename = 'dss15_planning_zone');

