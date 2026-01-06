------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 05.08.2025 16:52:39

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9438,9438) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
   value_en = 'concrete',
   value_de = 'Beton',
   value_fr = 'beton',
   value_it = 'calcestruzzo',
   value_ro = 'beton',
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
   display_en = 'concrete',
   display_de = 'Beton',
   display_fr = 'béton',
   display_it = '',
   display_ro = 'beton'
WHERE code = 9438;

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9437,9437) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
   value_en = 'cast_iron.gray_iron',
   value_de = 'Guss.Grauguss',
   value_fr = 'fonte.fonte_grise',
   value_it = 'ghisa.ghisa_grigia',
   value_ro = 'fonta.fonta_cenusie',
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
   display_en = 'cast_iron.gray_iron',
   display_de = 'Guss.Grauguss',
   display_fr = 'fonte.fonte grise',
   display_it = '',
   display_ro = 'Fonta cenu?ie'
WHERE code = 9437;

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9436,9436) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
   value_en = 'cast_iron.ductile_cast',
   value_de = 'Guss.Guss_duktil',
   value_fr = 'fonte.fonte_ductil',
   value_it = 'ghisa.ghisa_duttile',
   value_ro = 'fonta.fonta_ductila',
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
   display_en = 'cast_iron.ductile_cast',
   display_de = 'Guss.Guss_duktil',
   display_fr = 'fonte.fonte ductil',
   display_it = '',
   display_ro = 'fonta.fonta_ductila'
WHERE code = 9436;

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9433,9433) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
   value_en = 'plastic.polyethylene',
   value_de = 'Kunststoff.Polyethylen',
   value_fr = 'matiere_synthetique.polyethylene',
   value_it = 'materiale_sintetico.polietilene',
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
   display_en = 'plastic.polyethylene',
   display_de = 'Kunststoff.Polyethylen',
   display_fr = 'matiere synthétique.polyéthylene',
   display_it = '',
   display_ro = ''
WHERE code = 9433;

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9434,9434) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
   value_en = 'plastic.PVC',
   value_de = 'Kunststoff.Polyvinylchlorid',
   value_fr = 'matiere_synthetique.chlorure_de_polyvinyle',
   value_it = 'materiale_sintetico.polivinilcloruro',
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
   display_en = 'plastic.PVC',
   display_de = 'Kunststoff.Polyvinylchlorid',
   display_fr = 'matiere synthétique.chlorure de polyvinyle',
   display_it = '',
   display_ro = ''
WHERE code = 9434;

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9435,9435) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
   value_en = 'steel',
   value_de = 'Stahl',
   value_fr = 'acier',
   value_it = 'acciaio',
   value_ro = 'otel',
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
   display_en = 'steel',
   display_de = 'Stahl',
   display_fr = 'acier',
   display_it = '',
   display_ro = 'otel'
WHERE code = 9435;

--- Adapt tww_vl.sia405pt_protection_tube_material
 INSERT INTO tww_vl.sia405pt_protection_tube_material (code, vsacode) VALUES (9432,9432) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_material SET
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
WHERE code = 9432;

--- Adapt tww_vl.sia405pt_protection_tube_horizontal_positioning
 INSERT INTO tww_vl.sia405pt_protection_tube_horizontal_positioning (code, vsacode) VALUES (9443,9443) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_horizontal_positioning SET
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
WHERE code = 9443;

--- Adapt tww_vl.sia405pt_protection_tube_horizontal_positioning
 INSERT INTO tww_vl.sia405pt_protection_tube_horizontal_positioning (code, vsacode) VALUES (9444,9444) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_horizontal_positioning SET
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
WHERE code = 9444;

--- Adapt tww_vl.sia405pt_protection_tube_horizontal_positioning
 INSERT INTO tww_vl.sia405pt_protection_tube_horizontal_positioning (code, vsacode) VALUES (9445,9445) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_horizontal_positioning SET
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
WHERE code = 9445;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9446,9446) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9446;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9447,9447) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9447;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9448,9448) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9448;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9449,9449) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9449;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9450,9450) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9450;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9451,9451) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9451;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9452,9452) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9452;

--- Adapt tww_vl.sia405pt_protection_tube_status
 INSERT INTO tww_vl.sia405pt_protection_tube_status (code, vsacode) VALUES (9453,9453) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.sia405pt_protection_tube_status SET
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
WHERE code = 9453;
