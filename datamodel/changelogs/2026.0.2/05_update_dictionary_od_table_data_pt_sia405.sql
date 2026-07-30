------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 30.07.2026 16:02:40
------ with 3D coordinates

--- Adapt tdh_sys.dictionary_od_table
INSERT INTO tdh_sys.dictionary_od_table (id, tablename) VALUES (8502,'sia405pt_protection_tube') ON CONFLICT DO NOTHING;

UPDATE tdh_sys.dictionary_od_table SET
   tablename = 'sia405pt_protection_tube',
   name_en = 'protection_tube',
   display_en = 'protection tube',
   shortcut_en = 'PT',
   name_de = 'Schutzrohr',
   display_de = 'Schutzrohr',
   shortcut_de = 'PT',
   name_fr = 'tube_de_protection',
   display_fr = 'tube de protection',
   shortcut_fr = 'TP',
   name_it = 'pozzetto_termico',
   display_it = 'pozzetto termico',
   shortcut_it = '',
   name_ro = 'rrr_Schutzrohr',
   display_ro = 'rrr_Schutzrohr',
   shortcut_ro = ''
WHERE (id = 8502 AND tablename = 'sia405pt_protection_tube');
