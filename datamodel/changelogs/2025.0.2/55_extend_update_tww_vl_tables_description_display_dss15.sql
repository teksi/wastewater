------ This file generates the delta file for updating value list tables for VSA-DSS database (Modul dss15 (2020)) in en for QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 07.08.2025 14:05:32

--- Adapt tww_vl.dss15_planning_zone_kind
 INSERT INTO tww_vl.dss15_planning_zone_kind (code, vsacode) VALUES (2990,2990) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dss15_planning_zone_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autres',
   value_it = 'altro',
   value_ro = 'rrr_altul',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'other',
   display_de = 'andere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 2990;

--- Adapt tww_vl.dss15_planning_zone_kind
 INSERT INTO tww_vl.dss15_planning_zone_kind (code, vsacode) VALUES (31,31) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dss15_planning_zone_kind SET
   value_en = 'commercial_zone',
   value_de = 'Gewerbezone',
   value_fr = 'zone_artisanale',
   value_it = 'zzz_Gewerbezone',
   value_ro = 'rrr_Gewerbezone',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'commercial_zone',
   display_de = 'Gewerbezone',
   display_fr = 'zone artisanale',
   display_it = '',
   display_ro = ''
WHERE code = 31;

--- Adapt tww_vl.dss15_planning_zone_kind
 INSERT INTO tww_vl.dss15_planning_zone_kind (code, vsacode) VALUES (32,32) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dss15_planning_zone_kind SET
   value_en = 'industrial_zone',
   value_de = 'Industriezone',
   value_fr = 'zone_industrielle',
   value_it = 'zzz_Industriezone',
   value_ro = 'rrr_Industriezone',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'industrial_zone',
   display_de = 'Industriezone',
   display_fr = 'zone industrielle',
   display_it = '',
   display_ro = ''
WHERE code = 32;

--- Adapt tww_vl.dss15_planning_zone_kind
 INSERT INTO tww_vl.dss15_planning_zone_kind (code, vsacode) VALUES (30,30) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dss15_planning_zone_kind SET
   value_en = 'agricultural_zone',
   value_de = 'Landwirtschaftszone',
   value_fr = 'zone_agricole',
   value_it = 'zzz_Landwirtschaftszone',
   value_ro = 'rrr_Landwirtschaftszone',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'agricultural_zone',
   display_de = 'Landwirtschaftszone',
   display_fr = 'zone agricole',
   display_it = '',
   display_ro = ''
WHERE code = 30;

--- Adapt tww_vl.dss15_planning_zone_kind
 INSERT INTO tww_vl.dss15_planning_zone_kind (code, vsacode) VALUES (3077,3077) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dss15_planning_zone_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnu',
   value_it = 'sconosciuto',
   value_ro = 'necunoscuta',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'unknown',
   display_de = 'unbekannt',
   display_fr = 'inconnu',
   display_it = '',
   display_ro = ''
WHERE code = 3077;

--- Adapt tww_vl.dss15_planning_zone_kind
 INSERT INTO tww_vl.dss15_planning_zone_kind (code, vsacode) VALUES (29,29) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.dss15_planning_zone_kind SET
   value_en = 'residential_zone',
   value_de = 'Wohnzone',
   value_fr = 'zone_d_habitations',
   value_it = 'zzz_Wohnzone',
   value_ro = 'rrr_Wohnzone',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'residential_zone',
   display_de = 'Wohnzone',
   display_fr = 'zone d''habitations',
   display_it = '',
   display_ro = ''
WHERE code = 29;

