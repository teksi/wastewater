------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 06.08.2025 14:49:08

--- Adapt tdh_vl.sia405cc_cable_point_kind
 INSERT INTO tdh_vl.sia405cc_cable_point_kind (code, vsacode) VALUES (9385,9385) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_kind SET
   value_en = 'cable_sleeve',
   value_de = 'Kabelmuffe',
   value_fr = 'manchon_cable',
   value_it = 'manicotto_del_cavo',
   value_ro = 'manson_de_cablu',
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
   display_en = 'cable_sleeve',
   display_de = 'Kabelmuffe',
   display_fr = 'manchon cable',
   display_it = '',
   display_ro = 'Man?on de cablu'
WHERE code = 9385;

--- Adapt tdh_vl.sia405cc_cable_point_kind
 INSERT INTO tdh_vl.sia405cc_cable_point_kind (code, vsacode) VALUES (9388,9388) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_kind SET
   value_en = 'cable_point',
   value_de = 'Kabelpunkt',
   value_fr = 'point_de_cable',
   value_it = 'punto_cavo',
   value_ro = 'punct_de_cablu',
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
   display_en = 'cable_point',
   display_de = 'Kabelpunkt',
   display_fr = 'point de cable',
   display_it = '',
   display_ro = ''
WHERE code = 9388;

--- Adapt tdh_vl.sia405cc_cable_point_kind
 INSERT INTO tdh_vl.sia405cc_cable_point_kind (code, vsacode) VALUES (9386,9386) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_kind SET
   value_en = 'cable_manhole',
   value_de = 'Kabelschacht',
   value_fr = 'chambre_cable',
   value_it = '',
   value_ro = '',
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
   display_en = 'cable_manhole',
   display_de = 'Kabelschacht',
   display_fr = 'chambre cable',
   display_it = '',
   display_ro = ''
WHERE code = 9386;

--- Adapt tdh_vl.sia405cc_cable_point_kind
 INSERT INTO tdh_vl.sia405cc_cable_point_kind (code, vsacode) VALUES (9387,9387) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_kind SET
   value_en = 'cabine',
   value_de = 'Kabine',
   value_fr = 'cabine',
   value_it = 'cabina',
   value_ro = 'cabina',
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
   display_en = 'cabine',
   display_de = 'Kabine',
   display_fr = 'cabine',
   display_it = '',
   display_ro = 'Cabina'
WHERE code = 9387;

--- Adapt tdh_vl.sia405cc_cable_point_kind
 INSERT INTO tdh_vl.sia405cc_cable_point_kind (code, vsacode) VALUES (9384,9384) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_kind SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9384;

--- Adapt tdh_vl.sia405cc_cable_point_kind
 INSERT INTO tdh_vl.sia405cc_cable_point_kind (code, vsacode) VALUES (9389,9389) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_kind SET
   value_en = 'others',
   value_de = 'weitere',
   value_fr = 'autre',
   value_it = '',
   value_ro = '',
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
   display_en = 'others',
   display_de = 'weitere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 9389;

--- Adapt tdh_vl.sia405cc_cable_point_horizontal_positioning
 INSERT INTO tdh_vl.sia405cc_cable_point_horizontal_positioning (code, vsacode) VALUES (9392,9392) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_horizontal_positioning SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precis',
   value_it = 'precisa',
   value_ro = 'precisa',
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
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précis',
   display_it = '',
   display_ro = ''
WHERE code = 9392;

--- Adapt tdh_vl.sia405cc_cable_point_horizontal_positioning
 INSERT INTO tdh_vl.sia405cc_cable_point_horizontal_positioning (code, vsacode) VALUES (9390,9390) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_horizontal_positioning SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9390;

--- Adapt tdh_vl.sia405cc_cable_point_horizontal_positioning
 INSERT INTO tdh_vl.sia405cc_cable_point_horizontal_positioning (code, vsacode) VALUES (9391,9391) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_horizontal_positioning SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecis',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
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
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprecis',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 9391;

--- Adapt tdh_vl.sia405cc_cable_point_elevation_determination
 INSERT INTO tdh_vl.sia405cc_cable_point_elevation_determination (code, vsacode) VALUES (9394,9394) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_elevation_determination SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precis',
   value_it = 'precisa',
   value_ro = 'precisa',
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
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précis',
   display_it = '',
   display_ro = ''
WHERE code = 9394;

--- Adapt tdh_vl.sia405cc_cable_point_elevation_determination
 INSERT INTO tdh_vl.sia405cc_cable_point_elevation_determination (code, vsacode) VALUES (9395,9395) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_elevation_determination SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9395;

--- Adapt tdh_vl.sia405cc_cable_point_elevation_determination
 INSERT INTO tdh_vl.sia405cc_cable_point_elevation_determination (code, vsacode) VALUES (9396,9396) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_elevation_determination SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecis',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
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
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprecis',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 9396;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9397,9397) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'inoperative',
   value_de = 'ausser_Betrieb',
   value_fr = 'hors_service',
   value_it = 'fuori_servizio',
   value_ro = 'rrr_ausser_Betrieb',
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
   display_en = 'inoperative',
   display_de = 'ausser_Betrieb',
   display_fr = 'hors service',
   display_it = '',
   display_ro = ''
WHERE code = 9397;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9398,9398) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'inoperative.reserve',
   value_de = 'ausser_Betrieb.Reserve',
   value_fr = 'hors_service.en_reserve',
   value_it = 'fuori_servizio.riserva',
   value_ro = 'rrr_ausser_Betrieb.Reserve',
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
   display_en = 'inoperative.reserve',
   display_de = 'ausser_Betrieb.Reserve',
   display_fr = 'hors service.en réserve',
   display_it = '',
   display_ro = ''
WHERE code = 9398;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9399,9399) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'operational',
   value_de = 'in_Betrieb',
   value_fr = 'en_service',
   value_it = 'in_funzione',
   value_ro = 'functionala',
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
   display_en = 'operational',
   display_de = 'in_Betrieb',
   display_fr = 'en service',
   display_it = '',
   display_ro = ''
WHERE code = 9399;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9400,9400) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'operational.tentative',
   value_de = 'in_Betrieb.provisorisch',
   value_fr = 'en_service.provisoire',
   value_it = 'in_funzione.provvisorio',
   value_ro = 'functionala.provizoriu',
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
   display_en = 'operational.tentative',
   display_de = 'in_Betrieb.provisorisch',
   display_fr = 'en service.provisoire',
   display_it = '',
   display_ro = 'functionala.provizoriu'
WHERE code = 9400;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9401,9401) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'others',
   value_de = 'weitere',
   value_fr = 'autre',
   value_it = '',
   value_ro = '',
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
   display_en = 'others',
   display_de = 'weitere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 9401;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9402,9402) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'other.calculation_alternative',
   value_de = 'weitere.Berechnungsvariante',
   value_fr = 'autre.variante_de_calcule',
   value_it = 'altro.variante_calcolo',
   value_ro = 'alta.varianta_calcul',
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
   display_en = 'other.calculation_alternative',
   display_de = 'weitere.Berechnungsvariante',
   display_fr = 'autre.variante de calcule',
   display_it = '',
   display_ro = 'alta.varianta_calcul'
WHERE code = 9402;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9403,9403) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'other.planned',
   value_de = 'weitere.geplant',
   value_fr = 'autre.planifie',
   value_it = 'altro.previsto',
   value_ro = 'rrr_weitere.geplant',
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
   display_en = 'other.planned',
   display_de = 'weitere.geplant',
   display_fr = 'autre.planifié',
   display_it = '',
   display_ro = ''
WHERE code = 9403;

--- Adapt tdh_vl.sia405cc_cable_point_status
 INSERT INTO tdh_vl.sia405cc_cable_point_status (code, vsacode) VALUES (9404,9404) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_point_status SET
   value_en = 'other.project',
   value_de = 'weitere.Projekt',
   value_fr = 'autre.projet',
   value_it = 'altro.progetto',
   value_ro = 'alta.proiect',
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
   display_en = 'other.project',
   display_de = 'weitere.Projekt',
   display_fr = 'autre.projet',
   display_it = '',
   display_ro = 'alta.proiect'
WHERE code = 9404;

--- Adapt tdh_vl.sia405cc_cable_function
 INSERT INTO tdh_vl.sia405cc_cable_function (code, vsacode) VALUES (9339,9339) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_function SET
   value_en = 'signal_cable',
   value_de = 'Signalkabel',
   value_fr = 'cable_de_signal',
   value_it = 'cavo_di_segnale',
   value_ro = 'cablu_de_semnal',
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
   display_en = 'signal_cable',
   display_de = 'Signalkabel',
   display_fr = 'cable de signal',
   display_it = '',
   display_ro = 'Cablu de semnal'
WHERE code = 9339;

--- Adapt tdh_vl.sia405cc_cable_function
 INSERT INTO tdh_vl.sia405cc_cable_function (code, vsacode) VALUES (9340,9340) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_function SET
   value_en = 'control_cable',
   value_de = 'Steuerkabel',
   value_fr = 'cable_de_conduite',
   value_it = 'cavo_di_comando',
   value_ro = 'cablu_de_control',
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
   display_en = 'control_cable',
   display_de = 'Steuerkabel',
   display_fr = 'cable de conduite',
   display_it = '',
   display_ro = 'Cablu de control'
WHERE code = 9340;

--- Adapt tdh_vl.sia405cc_cable_function
 INSERT INTO tdh_vl.sia405cc_cable_function (code, vsacode) VALUES (9341,9341) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_function SET
   value_en = 'power_cable',
   value_de = 'Stromkabel',
   value_fr = 'cable_de_courant',
   value_it = 'cavo_di_alimentazione',
   value_ro = 'cablu_de_alimentare',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'for district heating only',
   description_de = 'nur bei Fernwärme',
   description_fr = 'uniquement pour le chauffage à distance',
   description_it = 'zzz_nur bei Fernwärme',
   description_ro = 'zzz_nur bei Fernwärme',
   display_en = 'power_cable',
   display_de = 'Stromkabel',
   display_fr = 'cable de courant',
   display_it = '',
   display_ro = 'Cablu de alimentare'
WHERE code = 9341;

--- Adapt tdh_vl.sia405cc_cable_function
 INSERT INTO tdh_vl.sia405cc_cable_function (code, vsacode) VALUES (9338,9338) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_function SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9338;

--- Adapt tdh_vl.sia405cc_cable_function
 INSERT INTO tdh_vl.sia405cc_cable_function (code, vsacode) VALUES (9342,9342) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_function SET
   value_en = 'others',
   value_de = 'weitere',
   value_fr = 'autres',
   value_it = 'zzz_weitere',
   value_ro = 'rrr_weitere',
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
   display_en = 'others',
   display_de = 'weitere',
   display_fr = 'autres',
   display_it = '',
   display_ro = ''
WHERE code = 9342;

--- Adapt tdh_vl.sia405cc_cable_cable_type
 INSERT INTO tdh_vl.sia405cc_cable_cable_type (code, vsacode) VALUES (9345,9345) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_cable_type SET
   value_en = 'coaxial',
   value_de = 'koaxial',
   value_fr = 'coaxial',
   value_it = 'zzz_coassiale',
   value_ro = 'rrr_koaxial',
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
   display_en = 'coaxial',
   display_de = 'koaxial',
   display_fr = 'coaxial',
   display_it = '',
   display_ro = ''
WHERE code = 9345;

--- Adapt tdh_vl.sia405cc_cable_cable_type
 INSERT INTO tdh_vl.sia405cc_cable_cable_type (code, vsacode) VALUES (9344,9344) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_cable_type SET
   value_en = 'copper',
   value_de = 'Kupfer',
   value_fr = 'cuivre',
   value_it = 'zzz_rame',
   value_ro = 'zzz_Kupfer',
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
   display_en = 'copper',
   display_de = 'Kupfer',
   display_fr = 'cuivre',
   display_it = '',
   display_ro = ''
WHERE code = 9344;

--- Adapt tdh_vl.sia405cc_cable_cable_type
 INSERT INTO tdh_vl.sia405cc_cable_cable_type (code, vsacode) VALUES (9346,9346) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_cable_type SET
   value_en = 'fiber_optic',
   value_de = 'Lichtwellenleiter',
   value_fr = 'optique',
   value_it = 'zzz_Lichtwellenleiter',
   value_ro = 'rrr_Lichtwellenleiter',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Fiber optic cable',
   description_de = '',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'fiber_optic',
   display_de = 'Lichtwellenleiter',
   display_fr = 'optique',
   display_it = '',
   display_ro = ''
WHERE code = 9346;

--- Adapt tdh_vl.sia405cc_cable_cable_type
 INSERT INTO tdh_vl.sia405cc_cable_cable_type (code, vsacode) VALUES (9343,9343) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_cable_type SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9343;

--- Adapt tdh_vl.sia405cc_cable_horizontal_positioning
 INSERT INTO tdh_vl.sia405cc_cable_horizontal_positioning (code, vsacode) VALUES (9347,9347) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_horizontal_positioning SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precis',
   value_it = 'precisa',
   value_ro = 'precisa',
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
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précis',
   display_it = '',
   display_ro = ''
WHERE code = 9347;

--- Adapt tdh_vl.sia405cc_cable_horizontal_positioning
 INSERT INTO tdh_vl.sia405cc_cable_horizontal_positioning (code, vsacode) VALUES (9348,9348) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_horizontal_positioning SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9348;

--- Adapt tdh_vl.sia405cc_cable_horizontal_positioning
 INSERT INTO tdh_vl.sia405cc_cable_horizontal_positioning (code, vsacode) VALUES (9349,9349) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_horizontal_positioning SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecis',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
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
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprécis',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 9349;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9363,9363) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'inoperative',
   value_de = 'ausser_Betrieb',
   value_fr = 'hors_service',
   value_it = 'fuori_servizio',
   value_ro = 'rrr_ausser_Betrieb',
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
   display_en = 'inoperative',
   display_de = 'ausser_Betrieb',
   display_fr = 'hors service',
   display_it = '',
   display_ro = ''
WHERE code = 9363;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9364,9364) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'inoperative.reserve',
   value_de = 'ausser_Betrieb.Reserve',
   value_fr = 'hors_service.en_reserve',
   value_it = 'fuori_servizio.riserva',
   value_ro = 'rrr_ausser_Betrieb.Reserve',
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
   display_en = 'inoperative.reserve',
   display_de = 'ausser_Betrieb.Reserve',
   display_fr = 'hors service.en réserve',
   display_it = '',
   display_ro = ''
WHERE code = 9364;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9365,9365) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'operational',
   value_de = 'in_Betrieb',
   value_fr = 'en_service',
   value_it = 'in_funzione',
   value_ro = 'functionala',
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
   display_en = 'operational',
   display_de = 'in_Betrieb',
   display_fr = 'en service',
   display_it = '',
   display_ro = ''
WHERE code = 9365;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9366,9366) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'operational.tentative',
   value_de = 'in_Betrieb.provisorisch',
   value_fr = 'en_service.provisoire',
   value_it = 'in_funzione.provvisorio',
   value_ro = 'functionala.provizoriu',
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
   display_en = 'operational.tentative',
   display_de = 'in_Betrieb.provisorisch',
   display_fr = 'en service.provisoire',
   display_it = '',
   display_ro = 'functionala.provizoriu'
WHERE code = 9366;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9367,9367) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'others',
   value_de = 'weitere',
   value_fr = 'autre',
   value_it = '',
   value_ro = '',
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
   display_en = 'others',
   display_de = 'weitere',
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code = 9367;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9368,9368) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'other.calculation_alternative',
   value_de = 'weitere.Berechnungsvariante',
   value_fr = 'autre.variante_de_calcule',
   value_it = 'altro.variante_calcolo',
   value_ro = 'alta.varianta_calcul',
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
   display_en = 'other.calculation_alternative',
   display_de = 'weitere.Berechnungsvariante',
   display_fr = 'autre.variante de calcule',
   display_it = '',
   display_ro = 'alta.varianta_calcul'
WHERE code = 9368;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9369,9369) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'other.planned',
   value_de = 'weitere.geplant',
   value_fr = 'autre.planifie',
   value_it = 'altro.previsto',
   value_ro = 'rrr_weitere.geplant',
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
   display_en = 'other.planned',
   display_de = 'weitere.geplant',
   display_fr = 'autre.planifié',
   display_it = '',
   display_ro = ''
WHERE code = 9369;

--- Adapt tdh_vl.sia405cc_cable_status
 INSERT INTO tdh_vl.sia405cc_cable_status (code, vsacode) VALUES (9370,9370) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_status SET
   value_en = 'other.project',
   value_de = 'weitere.Projekt',
   value_fr = 'autre.projet',
   value_it = 'altro.progetto',
   value_ro = 'alta.proiect',
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
   display_en = 'other.project',
   display_de = 'weitere.Projekt',
   display_fr = 'autre.projet',
   display_it = '',
   display_ro = 'alta.proiect'
WHERE code = 9370;

--- Adapt tdh_vl.sia405cc_cable_elevation_determination
 INSERT INTO tdh_vl.sia405cc_cable_elevation_determination (code, vsacode) VALUES (9359,9359) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_elevation_determination SET
   value_en = 'accurate',
   value_de = 'genau',
   value_fr = 'precis',
   value_it = 'precisa',
   value_ro = 'precisa',
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
   display_en = 'accurate',
   display_de = 'genau',
   display_fr = 'précis',
   display_it = '',
   display_ro = ''
WHERE code = 9359;

--- Adapt tdh_vl.sia405cc_cable_elevation_determination
 INSERT INTO tdh_vl.sia405cc_cable_elevation_determination (code, vsacode) VALUES (9360,9360) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_elevation_determination SET
   value_en = 'unknown',
   value_de = 'unbekannt',
   value_fr = 'inconnue',
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
   display_fr = 'inconnue',
   display_it = '',
   display_ro = ''
WHERE code = 9360;

--- Adapt tdh_vl.sia405cc_cable_elevation_determination
 INSERT INTO tdh_vl.sia405cc_cable_elevation_determination (code, vsacode) VALUES (9361,9361) ON CONFLICT DO NOTHING;

 UPDATE tdh_vl.sia405cc_cable_elevation_determination SET
   value_en = 'inaccurate',
   value_de = 'ungenau',
   value_fr = 'imprecis',
   value_it = 'impreciso',
   value_ro = 'imprecisa',
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
   display_en = 'inaccurate',
   display_de = 'ungenau',
   display_fr = 'imprécis',
   display_it = '',
   display_ro = 'imprecisa'
WHERE code = 9361;
