------ this file updates the tww is_dictionary (Modul dss(2020)) in en on TEKSI
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 30.07.2026 15:10:05
------ with 3D coordinates

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (1001,'dryweather_downspout') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'dryweather_downspout',
   name_en = 'dryweather_downspout',
   display_en = 'dryweather downspout',
   shortcut_en = 'DD',
   name_de = 'Trockenwetterfallrohr',
   display_de = 'Trockenwetterfallrohr',
   shortcut_de = 'TF',
   name_fr = 'TUYAU_CHUTE',
   display_fr = 'Tuyau de chute par temps sec',
   shortcut_fr = 'TT',
   name_it = 'tubo_di_caduta_per_tempo_secco',
   display_it = 'Tubo di caduta per tempo secco',
   shortcut_it = '',
   name_ro = 'tub_uscat',
   display_ro = 'tub uscat',
   shortcut_ro = ''
WHERE (id = 1001 AND tablename = 'dryweather_downspout');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (1022,'param_ca_mouse1') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'param_ca_mouse1',
   name_en = 'param_ca_mouse1',
   display_en = 'param ca mouse1',
   shortcut_en = 'PM',
   name_de = 'EZG_PARAMETER_MOUSE1',
   display_de = 'EZG_PARAMETER_MOUSE1',
   shortcut_de = 'EM',
   name_fr = 'PARAM_BV_MOUSE1',
   display_fr = 'Paramètre BV MOUSE1',
   shortcut_fr = 'PM',
   name_it = 'zzz_BG_parametri_MOUSE1',
   display_it = 'zzz_BG_parametri_MOUSE1',
   shortcut_it = '',
   name_ro = 'rrr_EZG_PARAMETER_MOUSE1',
   display_ro = 'rrr_EZG_PARAMETER_MOUSE1',
   shortcut_ro = ''
WHERE (id = 1022 AND tablename = 'param_ca_mouse1');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (1033,'fountain') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'fountain',
   name_en = 'fountain',
   display_en = 'fountain',
   shortcut_en = 'FO',
   name_de = 'Brunnen',
   display_de = 'Brunnen',
   shortcut_de = 'BR',
   name_fr = 'FONTAINE',
   display_fr = 'Fontaine',
   shortcut_fr = 'FO',
   name_it = 'zzz_fontana',
   display_it = 'Fontana',
   shortcut_it = '',
   name_ro = 'rrr_Brunnen',
   display_ro = 'rrr_Brunnen',
   shortcut_ro = ''
WHERE (id = 1033 AND tablename = 'fountain');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (1034,'reservoir') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'reservoir',
   name_en = 'reservoir',
   display_en = 'reservoir',
   shortcut_en = 'RV',
   name_de = 'Reservoir',
   display_de = 'Reservoir',
   shortcut_de = 'RV',
   name_fr = 'RESERVOIR',
   display_fr = 'Réservoir',
   shortcut_fr = 'RE',
   name_it = 'zzz_serbatoio',
   display_it = 'Serbatoio',
   shortcut_it = '',
   name_ro = 'rrr_Reservoir',
   display_ro = 'rrr_Reservoir',
   shortcut_ro = ''
WHERE (id = 1034 AND tablename = 'reservoir');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (1035,'building') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'building',
   name_en = 'building',
   display_en = 'building',
   shortcut_en = 'BU',
   name_de = 'Gebaeude',
   display_de = 'Gebäude',
   shortcut_de = 'BD',
   name_fr = 'BATIMENT',
   display_fr = 'Bâtiment',
   shortcut_fr = 'BT',
   name_it = 'zzz_costruzione',
   display_it = 'Costruzione',
   shortcut_it = '',
   name_ro = 'rrr_cladiri',
   display_ro = 'rrr_Gebaeude',
   shortcut_ro = ''
WHERE (id = 1035 AND tablename = 'building');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (1036,'individual_surface') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'individual_surface',
   name_en = 'individual_surface',
   display_en = 'individual surface',
   shortcut_en = 'IE',
   name_de = 'Einzelflaeche',
   display_de = 'Einzelfläche',
   shortcut_de = 'FL',
   name_fr = 'SURFACE_INDIVIDUELLE',
   display_fr = 'Surface individuelle',
   shortcut_fr = 'SI',
   name_it = 'zzz_superficie_singola',
   display_it = 'Superficie singola',
   shortcut_it = '',
   name_ro = 'rrr_Einzelflaeche',
   display_ro = 'rrr_Einzelflaeche',
   shortcut_ro = ''
WHERE (id = 1036 AND tablename = 'individual_surface');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (105,'zone') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'zone',
   name_en = 'zone',
   display_en = 'zone',
   shortcut_en = 'ZO',
   name_de = 'Zone',
   display_de = 'Zone',
   shortcut_de = 'ZO',
   name_fr = 'ZONE',
   display_fr = 'Zone',
   shortcut_fr = 'ZO',
   name_it = 'zona',
   display_it = 'Zona',
   shortcut_it = '',
   name_ro = 'rrr_Zone',
   display_ro = 'rrr_Zone',
   shortcut_ro = ''
WHERE (id = 105 AND tablename = 'zone');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (106,'infiltration_zone') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'infiltration_zone',
   name_en = 'infiltration_zone',
   display_en = 'infiltration zone',
   shortcut_en = 'IZ',
   name_de = 'Versickerungsbereich',
   display_de = 'Versickerungsbereich',
   shortcut_de = 'VB',
   name_fr = 'ZONE_INFILTRATION',
   display_fr = 'Zone d''infiltration',
   shortcut_fr = 'ZI',
   name_it = 'zzz_zona_di_infiltrazione',
   display_it = 'Zona di infiltrazione',
   shortcut_it = '',
   name_ro = 'rrr_Versickerungsbereich',
   display_ro = 'rrr_Versickerungsbereich',
   shortcut_ro = ''
WHERE (id = 106 AND tablename = 'infiltration_zone');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (107,'benching') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'benching',
   name_en = 'benching',
   display_en = 'benching',
   shortcut_en = 'BE',
   name_de = 'Bankett',
   display_de = 'Bankett',
   shortcut_de = 'BN',
   name_fr = 'BANQUETTE',
   display_fr = 'Banquette',
   shortcut_fr = 'BQ',
   name_it = 'banchina',
   display_it = 'Banchina',
   shortcut_it = '',
   name_ro = 'bancheta',
   display_ro = 'bancheta',
   shortcut_ro = ''
WHERE (id = 107 AND tablename = 'benching');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (108,'wwtp_energy_use') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wwtp_energy_use',
   name_en = 'wwtp_energy_use',
   display_en = 'wwtp energy use',
   shortcut_en = 'EU',
   name_de = 'ARAEnergienutzung',
   display_de = 'ARA Energienutzung',
   shortcut_de = 'AE',
   name_fr = 'CONSOMMATION_ENERGIE_STEP',
   display_fr = 'Consomation d''énergie d''une STEP',
   shortcut_fr = 'EN',
   name_it = 'zzz_uso_di_energia_IDA',
   display_it = 'Uso di energia IDA',
   shortcut_it = '',
   name_ro = 'rrr_ARAEnergienutzung',
   display_ro = 'rrr_ARAEnergienutzung',
   shortcut_ro = ''
WHERE (id = 108 AND tablename = 'wwtp_energy_use');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (109,'electric_equipment') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'electric_equipment',
   name_en = 'electric_equipment',
   display_en = 'electric equipment',
   shortcut_en = 'EE',
   name_de = 'ElektrischeEinrichtung',
   display_de = 'Elektrische Einrichtung',
   shortcut_de = 'EE',
   name_fr = 'EQUIPEMENT_ELECTRIQUE',
   display_fr = 'Equipement électrique',
   shortcut_fr = 'EE',
   name_it = 'zzz_dispositivo elettrico',
   display_it = 'Dispositivo elettrico',
   shortcut_it = '',
   name_ro = 'rrr_ElektrischeEinrichtung',
   display_ro = 'rrr_ElektrischeEinrichtung',
   shortcut_ro = ''
WHERE (id = 109 AND tablename = 'electric_equipment');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (110,'electromechanical_equipment') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'electromechanical_equipment',
   name_en = 'electromechanical_equipment',
   display_en = 'electromechanical equipment',
   shortcut_en = 'EQ',
   name_de = 'ElektromechanischeAusruestung',
   display_de = 'Elektromechanische Ausrüstung',
   shortcut_de = 'EA',
   name_fr = 'EQUIPEMENT_ELECTROMECA',
   display_fr = 'Equipement électromécanique',
   shortcut_fr = 'EQ',
   name_it = 'componenti_elettromeccaniche',
   display_it = 'Componenti elettromeccaniche',
   shortcut_it = '',
   name_ro = 'rrr_ElektromechanischeAusruestung',
   display_ro = 'rrr_ElektromechanischeAusruestung',
   shortcut_ro = ''
WHERE (id = 110 AND tablename = 'electromechanical_equipment');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (111,'maintenance_event') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'maintenance_event',
   name_en = 'maintenance_event',
   display_en = 'maintenance event',
   shortcut_en = 'ME',
   name_de = 'Erhaltungsereignis',
   display_de = 'Erhaltungsereignis',
   shortcut_de = 'EH',
   name_fr = 'EVENEMENT_MAINTENANCE',
   display_fr = 'Evénement de maintenance',
   shortcut_fr = 'EM',
   name_it = 'evento_di_mantenimento',
   display_it = 'Evento di mantenimento',
   shortcut_it = '',
   name_ro = 'rrr_Erhaltungsereignis',
   display_ro = 'rrr_Erhaltungsereignis',
   shortcut_ro = ''
WHERE (id = 111 AND tablename = 'maintenance_event');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (13,'structure_part') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'structure_part',
   name_en = 'structure_part',
   display_en = 'structure part',
   shortcut_en = 'SP',
   name_de = 'BauwerksTeil',
   display_de = 'Bauwerksteil',
   shortcut_de = 'BT',
   name_fr = 'ELEMENT_OUVRAGE',
   display_fr = 'Elément d''ouvrage',
   shortcut_fr = 'EO',
   name_it = 'zzz_parte_dell_edificio',
   display_it = 'zzz_BauwerksTeil',
   shortcut_it = '',
   name_ro = 'element_structura',
   display_ro = 'element structura',
   shortcut_ro = ''
WHERE (id = 13 AND tablename = 'structure_part');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (15,'cover') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'cover',
   name_en = 'cover',
   display_en = 'cover',
   shortcut_en = 'CO',
   name_de = 'Deckel',
   display_de = 'Deckel',
   shortcut_de = 'DE',
   name_fr = 'COUVERCLE',
   display_fr = 'Couvercle',
   shortcut_fr = 'CO',
   name_it = 'zzz_chiusino',
   display_it = 'Chiusino',
   shortcut_it = '',
   name_ro = 'capac',
   display_ro = 'capac',
   shortcut_ro = ''
WHERE (id = 15 AND tablename = 'cover');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (16,'throttle_shut_off_unit') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'throttle_shut_off_unit',
   name_en = 'throttle_shut_off_unit',
   display_en = 'throttle shut off unit',
   shortcut_en = 'TS',
   name_de = 'Absperr_Drosselorgan',
   display_de = 'Absperr-/Drosselorgan',
   shortcut_de = 'DR',
   name_fr = 'LIMITEUR_DEBIT',
   display_fr = 'Limiteur de débit',
   shortcut_fr = 'LD',
   name_it = 'limitatore_portata',
   display_it = 'limitatore_portata',
   shortcut_it = '',
   name_ro = 'rrr_Absperr_Drosselorgan',
   display_ro = 'rrr_Absperr_Drosselorgan',
   shortcut_ro = ''
WHERE (id = 16 AND tablename = 'throttle_shut_off_unit');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (18,'access_aid') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'access_aid',
   name_en = 'access_aid',
   display_en = 'access aid',
   shortcut_en = 'AA',
   name_de = 'Einstiegshilfe',
   display_de = 'Einstiegshilfe',
   shortcut_de = 'EF',
   name_fr = 'DISPOSITIF_D_ACCES',
   display_fr = 'Dispositif d''accès',
   shortcut_fr = 'DA',
   name_it = 'zzz_aiuto_all_ingresso',
   display_it = 'Aiuto all''ingresso',
   shortcut_it = '',
   name_ro = 'dispozitiv_acces',
   display_ro = 'dispozitiv de acces',
   shortcut_ro = ''
WHERE (id = 18 AND tablename = 'access_aid');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (19,'catchment_area') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'catchment_area',
   name_en = 'catchment_area',
   display_en = 'catchment area',
   shortcut_en = 'CA',
   name_de = 'Einzugsgebiet',
   display_de = 'Einzugsgebiet',
   shortcut_de = 'EZ',
   name_fr = 'BASSIN_VERSANT',
   display_fr = 'Bassin versant',
   shortcut_fr = 'BV',
   name_it = 'bacino_gravitante',
   display_it = 'Bacino gravitante',
   shortcut_it = '',
   name_ro = 'aria_de_captare',
   display_ro = 'aria de captare',
   shortcut_ro = ''
WHERE (id = 19 AND tablename = 'catchment_area');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (2,'wastewater_structure') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wastewater_structure',
   name_en = 'wastewater_structure',
   display_en = 'wastewater structure',
   shortcut_en = 'WS',
   name_de = 'Abwasserbauwerk',
   display_de = 'Abwasserbauwerk',
   shortcut_de = 'BW',
   name_fr = 'OUVRAGE_RESEAU_AS',
   display_fr = 'Ouvrage du réseau d''assainissement',
   shortcut_fr = 'OU',
   name_it = 'manufatto_smaltimento_acque',
   display_it = 'Manufatto smaltimento acque',
   shortcut_it = '',
   name_ro = 'structura_canalizare',
   display_ro = 'structura canalizare',
   shortcut_ro = ''
WHERE (id = 2 AND tablename = 'wastewater_structure');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (2721,'drainage_system') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'drainage_system',
   name_en = 'drainage_system',
   display_en = 'drainage system',
   shortcut_en = 'DS',
   name_de = 'Entwaesserungssystem',
   display_de = 'Entwässerungssystem',
   shortcut_de = 'ES',
   name_fr = 'SYSTEME_EVACUATION_EAUX',
   display_fr = 'Système d''évacuation des eaux',
   shortcut_fr = 'SY',
   name_it = 'sistema_di_smaltimento_delle_acque',
   display_it = 'Sistema di smaltimento delle acque',
   shortcut_it = '',
   name_ro = 'rrr_Entwaesserungssystem',
   display_ro = 'rrr_Entwaesserungssystem',
   shortcut_ro = ''
WHERE (id = 2721 AND tablename = 'drainage_system');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (2723,'control_center') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'control_center',
   name_en = 'control_center',
   display_en = 'control center',
   shortcut_en = 'CC',
   name_de = 'Steuerungszentrale',
   display_de = 'Steuerungszentrale',
   shortcut_de = 'SZ',
   name_fr = 'CENTRALE_COMMANDE',
   display_fr = 'Centrale de commande',
   shortcut_fr = 'CC',
   name_it = 'zzz_centro_di_ controllo',
   display_it = 'Centro di controllo',
   shortcut_it = '',
   name_ro = 'rrr_Steuerungszentrale',
   display_ro = 'rrr_Steuerungszentrale',
   shortcut_ro = ''
WHERE (id = 2723 AND tablename = 'control_center');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (2964,'profile_geometry') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'profile_geometry',
   name_en = 'profile_geometry',
   display_en = 'profile geometry',
   shortcut_en = 'PG',
   name_de = 'Rohrprofil_Geometrie',
   display_de = 'Rohrprofil Geometrie',
   shortcut_de = 'RG',
   name_fr = 'PROFIL_TUYAU_GEOM',
   display_fr = 'Profil du tuyau geometrie',
   shortcut_fr = 'TG',
   name_it = 'profilo_tubo_geometria',
   display_it = 'Profilo tubogeometria',
   shortcut_it = '',
   name_ro = 'rrr_profil_conducta_geometry',
   display_ro = 'rrr_profil_conducta_geometry',
   shortcut_ro = ''
WHERE (id = 2964 AND tablename = 'profile_geometry');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3,'waste_water_treatment') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'waste_water_treatment',
   name_en = 'waste_water_treatment',
   display_en = 'waste water treatment',
   shortcut_en = 'TR',
   name_de = 'Abwasserbehandlung',
   display_de = 'Abwasserbehandlung',
   shortcut_de = 'AH',
   name_fr = 'TRAITEMENT_EAUX_USEES',
   display_fr = 'Traitement des eaux usées',
   shortcut_fr = 'TE',
   name_it = 'trattamento_delle_acque_di_scarico',
   display_it = 'Trattamento delle acque di scarico',
   shortcut_it = '',
   name_ro = 'rrr_Abwasserbehandlung',
   display_ro = 'rrr_Abwasserbehandlung',
   shortcut_ro = ''
WHERE (id = 3 AND tablename = 'waste_water_treatment');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (31,'reach') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'reach',
   name_en = 'reach',
   display_en = 'reach',
   shortcut_en = 'RE',
   name_de = 'Haltung',
   display_de = 'Haltung',
   shortcut_de = 'HA',
   name_fr = 'TRONCON',
   display_fr = 'Tronçon',
   shortcut_fr = 'TR',
   name_it = 'tratta',
   display_it = 'Tratta',
   shortcut_it = '',
   name_ro = 'tronson',
   display_ro = 'tronson',
   shortcut_ro = ''
WHERE (id = 31 AND tablename = 'reach');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (3189,'param_ca_general') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'param_ca_general',
   name_en = 'param_ca_general',
   display_en = 'param ca general',
   shortcut_en = 'PC',
   name_de = 'EZG_PARAMETER_ALLG',
   display_de = 'EZG_PARAMETER_ALLG',
   shortcut_de = 'EG',
   name_fr = 'PARAM_BV_GENERAL',
   display_fr = 'Param BV géneral',
   shortcut_fr = 'PB',
   name_it = 'zzz_BG_parametri_generale',
   display_it = 'zzz_BG_parametri_generale',
   shortcut_it = '',
   name_ro = 'rrr_EZG_PARAMETER_ALLG',
   display_ro = 'rrr_EZG_PARAMETER_ALLG',
   shortcut_ro = ''
WHERE (id = 3189 AND tablename = 'param_ca_general');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (32,'reach_point') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'reach_point',
   name_en = 'reach_point',
   display_en = 'reach point',
   shortcut_en = 'RP',
   name_de = 'Haltungspunkt',
   display_de = 'Haltungspunkt',
   shortcut_de = 'HP',
   name_fr = 'POINT_TRONCON',
   display_fr = 'Point de tronçon',
   shortcut_fr = 'PT',
   name_it = 'punto_tratta',
   display_it = 'Punto tratta',
   shortcut_it = '',
   name_ro = 'punct_tronson',
   display_ro = 'punct tronson',
   shortcut_ro = ''
WHERE (id = 32 AND tablename = 'reach_point');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (33,'hq_relation') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'hq_relation',
   name_en = 'hq_relation',
   display_en = 'hq relation',
   shortcut_en = 'HQ',
   name_de = 'HQ_Relation',
   display_de = 'HQ-Relation',
   shortcut_de = 'HR',
   name_fr = 'RELATION_HQ',
   display_fr = 'Relation HQ',
   shortcut_fr = 'HQ',
   name_it = 'HQ_relazione',
   display_it = 'HQ-Relazione',
   shortcut_it = '',
   name_ro = 'HQ_Relatia',
   display_ro = 'rrr_HQ_Relation',
   shortcut_ro = ''
WHERE (id = 33 AND tablename = 'hq_relation');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (36,'hydr_geometry') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'hydr_geometry',
   name_en = 'hydr_geometry',
   display_en = 'hydraulic geometry',
   shortcut_en = 'HG',
   name_de = 'Hydr_Geometrie',
   display_de = 'Hydro-Geometrie',
   shortcut_de = 'HG',
   name_fr = 'GEOMETRIE_HYDR',
   display_fr = 'Géométrie hydraulique',
   shortcut_fr = 'GH',
   name_it = 'geometria_idraulica',
   display_it = 'Geometria_idraulica',
   shortcut_it = '',
   name_ro = 'geometria_hidraulica',
   display_ro = 'hidro_geometrie',
   shortcut_ro = ''
WHERE (id = 36 AND tablename = 'hydr_geometry');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (37,'hydr_geom_relation') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'hydr_geom_relation',
   name_en = 'hydr_geom_relation',
   display_en = 'hydr geom relation',
   shortcut_en = 'HR',
   name_de = 'Hydr_GeomRelation',
   display_de = 'Hydro-Geometrie-Relation',
   shortcut_de = 'HY',
   name_fr = 'RELATION_GEOM_HYDR',
   display_fr = 'Relation géometrie hydraulique',
   shortcut_fr = 'RG',
   name_it = 'relazione_geometrica_idraulica',
   display_it = 'Relazione_geometrica_idraulica',
   shortcut_it = '',
   name_ro = 'relatia_geometrie_hidraulica',
   display_ro = 'rrr_Hydr_GeomRelation',
   shortcut_ro = ''
WHERE (id = 37 AND tablename = 'hydr_geom_relation');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (38,'channel') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'channel',
   name_en = 'channel',
   display_en = 'channel',
   shortcut_en = 'CH',
   name_de = 'Kanal',
   display_de = 'Kanal',
   shortcut_de = 'KA',
   name_fr = 'CANALISATION',
   display_fr = 'Canalisation',
   shortcut_fr = 'CA',
   name_it = 'canalizzazione',
   display_it = 'Canalizzazione',
   shortcut_it = '',
   name_ro = 'canal',
   display_ro = 'canal',
   shortcut_ro = ''
WHERE (id = 38 AND tablename = 'channel');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (4,'wastewater_node') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wastewater_node',
   name_en = 'wastewater_node',
   display_en = 'wastewater node',
   shortcut_en = 'WN',
   name_de = 'Abwasserknoten',
   display_de = 'Abwasserknoten',
   shortcut_de = 'AK',
   name_fr = 'NOEUD_RESEAU',
   display_fr = 'Noeud de réseau',
   shortcut_fr = 'NR',
   name_it = 'zzz_nodo_acque_reflue',
   display_it = 'Nodo acque reflue',
   shortcut_it = '',
   name_ro = 'nod_canalizare',
   display_ro = 'nod canalizare',
   shortcut_ro = ''
WHERE (id = 4 AND tablename = 'wastewater_node');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (41,'leapingweir') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'leapingweir',
   name_en = 'leapingweir',
   display_en = 'leapingweir',
   shortcut_en = 'LW',
   name_de = 'Leapingwehr',
   display_de = 'Leapingwehr',
   shortcut_de = 'LW',
   name_fr = 'LEAPING_WEIR',
   display_fr = 'Leapingweir',
   shortcut_fr = 'LW',
   name_it = 'leaping_weir',
   display_it = 'leaping_weir',
   shortcut_it = '',
   name_ro = 'rrr_Leapingwehr',
   display_ro = 'rrr_Leapingwehr',
   shortcut_ro = ''
WHERE (id = 41 AND tablename = 'leapingweir');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (42,'measurement_series') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'measurement_series',
   name_en = 'measurement_series',
   display_en = 'measurement series',
   shortcut_en = 'MS',
   name_de = 'Messreihe',
   display_de = 'Messreihe',
   shortcut_de = 'MH',
   name_fr = 'SERIE_MESURES',
   display_fr = 'Série de mesures',
   shortcut_fr = 'SE',
   name_it = 'zzz_serie_di_misure',
   display_it = 'Serie di misure',
   shortcut_it = '',
   name_ro = 'rrr_Messreihe',
   display_ro = 'rrr_Messreihe',
   shortcut_ro = ''
WHERE (id = 42 AND tablename = 'measurement_series');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (43,'measurement_result') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'measurement_result',
   name_en = 'measurement_result',
   display_en = 'measurement result',
   shortcut_en = 'MR',
   name_de = 'Messresultat',
   display_de = 'Messresultat',
   shortcut_de = 'MR',
   name_fr = 'RESULTAT_MESURE',
   display_fr = 'Résultat de la mesure',
   shortcut_fr = 'RM',
   name_it = 'risultato_misura',
   display_it = 'Risultato_misura',
   shortcut_it = '',
   name_ro = 'rrr_Messresultat',
   display_ro = 'rrr_Messresultat',
   shortcut_ro = ''
WHERE (id = 43 AND tablename = 'measurement_result');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (44,'measuring_point') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'measuring_point',
   name_en = 'measuring_point',
   display_en = 'measuring point',
   shortcut_en = 'MP',
   name_de = 'Messstelle',
   display_de = 'Messstelle',
   shortcut_de = 'MS',
   name_fr = 'STATION_MESURE',
   display_fr = 'Station de mesure',
   shortcut_fr = 'SM',
   name_it = 'zzz_punto_di_misura',
   display_it = 'Punto di misura',
   shortcut_it = '',
   name_ro = 'rrr_Messstelle',
   display_ro = 'rrr_Messstelle',
   shortcut_ro = ''
WHERE (id = 44 AND tablename = 'measuring_point');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (45,'manhole') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'manhole',
   name_en = 'manhole',
   display_en = 'manhole',
   shortcut_en = 'MA',
   name_de = 'Normschacht',
   display_de = 'Normschacht',
   shortcut_de = 'NS',
   name_fr = 'CHAMBRE_STANDARD',
   display_fr = 'Chambre standard',
   shortcut_fr = 'CS',
   name_it = 'pozzetto_standard',
   display_it = 'Pozzetto standard',
   shortcut_it = '',
   name_ro = 'camin_canalizare',
   display_ro = 'camin canalizare',
   shortcut_ro = ''
WHERE (id = 45 AND tablename = 'manhole');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (46,'surface_runoff_parameters') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'surface_runoff_parameters',
   name_en = 'surface_runoff_parameters',
   display_en = 'surface runoff parameters',
   shortcut_en = 'SR',
   name_de = 'Oberflaechenabflussparameter',
   display_de = 'Oberflächenabflussparameter',
   shortcut_de = 'OP',
   name_fr = 'PARAM_ECOULEMENT_SUP',
   display_fr = 'Paramètres d''écoulement superficiel',
   shortcut_fr = 'PE',
   name_it = 'parametro_di_deflusso_superficiale',
   display_it = 'Parametro di deflusso superficiale',
   shortcut_it = '',
   name_ro = 'rrr_Oberflaechenabflussparameter',
   display_ro = 'rrr_Oberflaechenabflussparameter',
   shortcut_ro = ''
WHERE (id = 46 AND tablename = 'surface_runoff_parameters');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (47,'organisation') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'organisation',
   name_en = 'organisation',
   display_en = 'organisation',
   shortcut_en = 'OG',
   name_de = 'Organisation',
   display_de = 'Organisation',
   shortcut_de = 'OG',
   name_fr = 'ORGANISATION',
   display_fr = 'Organisation',
   shortcut_fr = 'OG',
   name_it = 'organizzazione',
   display_it = 'Organizzazione',
   shortcut_it = '',
   name_ro = 'organizatia',
   display_ro = 'organizatia',
   shortcut_ro = ''
WHERE (id = 47 AND tablename = 'organisation');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (49,'pipe_profile') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'pipe_profile',
   name_en = 'pipe_profile',
   display_en = 'pipe profile',
   shortcut_en = 'PP',
   name_de = 'Rohrprofil',
   display_de = 'Rohrprofil',
   shortcut_de = 'RP',
   name_fr = 'PROFIL_TUYAU',
   display_fr = 'Genre de profil de tuyau',
   shortcut_fr = 'GP',
   name_it = 'profilo_del_tubo',
   display_it = 'Profilo del tubo',
   shortcut_it = '',
   name_ro = 'profil_conducta',
   display_ro = 'profil conducta',
   shortcut_ro = ''
WHERE (id = 49 AND tablename = 'pipe_profile');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5,'wastewater_networkelement') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wastewater_networkelement',
   name_en = 'wastewater_networkelement',
   display_en = 'wastewater networkelement',
   shortcut_en = 'WE',
   name_de = 'Abwassernetzelement',
   display_de = 'Abwassernetzelement',
   shortcut_de = 'AN',
   name_fr = 'ELEMENT_RESEAU_EVACUATION',
   display_fr = 'Elément du réseau d''évacuation des eaux',
   shortcut_fr = 'ER',
   name_it = 'zzz_elemento_di_rete_delle_acque_reflue',
   display_it = 'Elemento di rete delle acque acque reflue',
   shortcut_it = '',
   name_ro = 'element_retea_canalizare',
   display_ro = 'element canalizare',
   shortcut_ro = ''
WHERE (id = 5 AND tablename = 'wastewater_networkelement');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (50,'pump') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'pump',
   name_en = 'pump',
   display_en = 'pump',
   shortcut_en = 'PU',
   name_de = 'FoerderAggregat',
   display_de = 'Förderaggregat',
   shortcut_de = 'FA',
   name_fr = 'INSTALLATION_REFOULEMENT',
   display_fr = 'Installation de refoulement',
   shortcut_fr = 'IR',
   name_it = 'pompaggio',
   display_it = 'Pompaggio',
   shortcut_it = '',
   name_ro = 'rrr_FoerderAggregat',
   display_ro = 'rrr_FoerderAggregat',
   shortcut_ro = ''
WHERE (id = 50 AND tablename = 'pump');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5100,'log_card') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'log_card',
   name_en = 'log_card',
   display_en = 'log card',
   shortcut_en = 'LC',
   name_de = 'Stammkarte',
   display_de = 'Stammkarte Sonderbauwerk',
   shortcut_de = 'SK',
   name_fr = 'FICHE_TECHNIQUE',
   display_fr = 'Fichier technique',
   shortcut_fr = 'FT',
   name_it = 'scheda_tipo',
   display_it = 'Scheda_tipo',
   shortcut_it = '',
   name_ro = 'Fisa_tehnica',
   display_ro = 'rrr_Stammkarte',
   shortcut_ro = ''
WHERE (id = 5100 AND tablename = 'log_card');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5101,'tank_emptying') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'tank_emptying',
   name_en = 'tank_emptying',
   display_en = 'tank emptying',
   shortcut_en = 'TE',
   name_de = 'Beckenentleerung',
   display_de = 'Beckenentleerung',
   shortcut_de = 'BE',
   name_fr = 'VIDANGE_DE_BASSINS',
   display_fr = 'Vidange de bassins',
   shortcut_fr = 'VB',
   name_it = 'vuotamento_bacino',
   display_it = 'Vuotamento bacino',
   shortcut_it = '',
   name_ro = 'rrr_Beckenentleerung',
   display_ro = 'rrr_Beckenentleerung',
   shortcut_ro = ''
WHERE (id = 5101 AND tablename = 'tank_emptying');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5102,'tank_cleaning') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'tank_cleaning',
   name_en = 'tank_cleaning',
   display_en = 'tank cleaning',
   shortcut_en = 'TC',
   name_de = 'Beckenreinigung',
   display_de = 'Beckenreinigung',
   shortcut_de = 'BI',
   name_fr = 'NETTOYAGE_DE_BASSINS',
   display_fr = 'Nettoyage de bassins',
   shortcut_fr = 'YB',
   name_it = 'pulizia_bacino',
   display_it = 'Pulizia manufatto',
   shortcut_it = '',
   name_ro = 'rrr_Beckenreinigung',
   display_ro = 'rrr_Beckenreinigung',
   shortcut_ro = ''
WHERE (id = 5102 AND tablename = 'tank_cleaning');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5103,'solids_retention') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'solids_retention',
   name_en = 'solids_retention',
   display_en = 'solids retention',
   shortcut_en = 'SO',
   name_de = 'Feststoffrueckhalt',
   display_de = 'Feststoffrückhalt',
   shortcut_de = 'FE',
   name_fr = 'RETENUE_DE_MATIERES_SOLIDES',
   display_fr = 'Retenue de matières solides',
   shortcut_fr = 'FR',
   name_it = 'ritenzione_solidi',
   display_it = 'Ritenzione solidi',
   shortcut_it = '',
   name_ro = 'rrr_Feststoffrueckhalt',
   display_ro = 'rrr_Feststoffrueckhalt',
   shortcut_ro = ''
WHERE (id = 5103 AND tablename = 'solids_retention');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5104,'backflow_prevention') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'backflow_prevention',
   name_en = 'backflow_prevention',
   display_en = 'backflow prevention',
   shortcut_en = 'BP',
   name_de = 'Rueckstausicherung',
   display_de = 'Rückstausicherung',
   shortcut_de = 'RS',
   name_fr = 'PROTECTION_REFOULEMENT',
   display_fr = 'Protection contre le refoulement',
   shortcut_fr = 'RS',
   name_it = 'dispositivo_anti_rigurgito',
   display_it = 'Dispositivo anti rigurgito',
   shortcut_it = '',
   name_ro = 'rrr_Rueckstausicherung',
   display_ro = 'rrr_Rueckstausicherung',
   shortcut_ro = ''
WHERE (id = 5104 AND tablename = 'backflow_prevention');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5105,'catchment_area_totals') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'catchment_area_totals',
   name_en = 'catchment_area_totals',
   display_en = 'catchment area totals',
   shortcut_en = 'CM',
   name_de = 'Gesamteinzugsgebiet',
   display_de = 'Einzugsgebiet / Wassermengen / Einleitstelle',
   shortcut_de = 'GT',
   name_fr = 'BASSIN_VERSANT_COMPLET',
   display_fr = 'Bassin versant, débits d''eau et exutoire',
   shortcut_fr = 'BC',
   name_it = 'area_tributaria_totale',
   display_it = 'Bacino imbrifero totale',
   shortcut_it = '',
   name_ro = 'rrr_Gesamteinzugsgebiet',
   display_ro = 'rrr_Gesamteinzugsgebiet',
   shortcut_ro = ''
WHERE (id = 5105 AND tablename = 'catchment_area_totals');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5106,'bio_ecol_assessment') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'bio_ecol_assessment',
   name_en = 'bio_ecol_assessment',
   display_en = 'biological and ecological overall assessment',
   shortcut_en = 'BO',
   name_de = 'Biol_oekol_Gesamtbeurteilung',
   display_de = 'Biologisch-ökologische Gesamtbeurteilung',
   shortcut_de = 'BG',
   name_fr = 'EVALUATION_GENERALE_ECO_BIOL',
   display_fr = 'Evaluation générale éco-biologique',
   shortcut_fr = 'EB',
   name_it = 'valutazione_biol_ecol_globale',
   display_it = 'valutazione biol ecol globale',
   shortcut_it = '',
   name_ro = 'rrr_Biol_oekol_Gesamtbeurteilung',
   display_ro = 'rrr_Biol_oekol_Gesamtbeurteilung',
   shortcut_ro = ''
WHERE (id = 5106 AND tablename = 'bio_ecol_assessment');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (5107,'hydraulic_char_data') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'hydraulic_char_data',
   name_en = 'hydraulic_char_data',
   display_en = 'hydraulic characteristic data',
   shortcut_en = 'HC',
   name_de = 'Hydr_Kennwerte',
   display_de = 'Hydraulische Kennwerte',
   shortcut_de = 'HK',
   name_fr = 'PARAMETRES_HYDR',
   display_fr = 'Parametres hydrauliques',
   shortcut_fr = 'PH',
   name_it = 'caratteristiche_idrauliche',
   display_it = 'Caratteristiche idrauliche',
   shortcut_it = '',
   name_ro = 'caracteristici_hidraulice',
   display_ro = 'rrr_Hydr_Kennwerte',
   shortcut_ro = ''
WHERE (id = 5107 AND tablename = 'hydraulic_char_data');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (53,'retention_body') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'retention_body',
   name_en = 'retention_body',
   display_en = 'retention body',
   shortcut_en = 'RB',
   name_de = 'Retentionskoerper',
   display_de = 'Retentionskörper',
   shortcut_de = 'RK',
   name_fr = 'VOLUME_RETENTION',
   display_fr = 'Volume de rétention',
   shortcut_fr = 'VR',
   name_it = 'corpo_di_ritenzione',
   display_it = 'Corpo di ritenzione',
   shortcut_it = '',
   name_ro = 'rrr_Retentionskoerper',
   display_ro = 'rrr_Retentionskoerper',
   shortcut_ro = ''
WHERE (id = 53 AND tablename = 'retention_body');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (55,'sludge_treatment') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'sludge_treatment',
   name_en = 'sludge_treatment',
   display_en = 'sludge treatment',
   shortcut_en = 'ST',
   name_de = 'Schlammbehandlung',
   display_de = 'Schlammbehandlung',
   shortcut_de = 'SH',
   name_fr = 'TRAITEMENT_BOUES',
   display_fr = 'Traitement des boues',
   shortcut_fr = 'TB',
   name_it = 'trattamento_dei_fanghi',
   display_it = 'Trattamento die fanghi',
   shortcut_it = '',
   name_ro = 'rrr_Schlammbehandlung',
   display_ro = 'rrr_Schlammbehandlung',
   shortcut_ro = ''
WHERE (id = 55 AND tablename = 'sludge_treatment');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (57,'special_structure') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'special_structure',
   name_en = 'special_structure',
   display_en = 'special structure',
   shortcut_en = 'SS',
   name_de = 'Spezialbauwerk',
   display_de = 'Spezialbauwerk',
   shortcut_de = 'SW',
   name_fr = 'OUVRAGE_SPECIAL',
   display_fr = 'Ouvrage spécial',
   shortcut_fr = 'OC',
   name_it = 'struttura_speciale',
   display_it = 'Manufatto speciale',
   shortcut_it = '',
   name_ro = 'structura_speciala',
   display_ro = 'structura speciala',
   shortcut_ro = ''
WHERE (id = 57 AND tablename = 'special_structure');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (60,'prank_weir') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'prank_weir',
   name_en = 'prank_weir',
   display_en = 'prank weir',
   shortcut_en = 'PW',
   name_de = 'Streichwehr',
   display_de = 'Streichwehr',
   shortcut_de = 'WE',
   name_fr = 'DEVERSOIR_LATERAL',
   display_fr = 'Déversoir latéral',
   shortcut_fr = 'DL',
   name_it = 'stramazzo_laterale',
   display_it = 'Stramazzo laterale',
   shortcut_it = '',
   name_ro = 'rrr_Streichwehr',
   display_ro = 'rrr_Streichwehr',
   shortcut_ro = ''
WHERE (id = 60 AND tablename = 'prank_weir');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (6100,'building_group') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'building_group',
   name_en = 'building_group',
   display_en = 'building group',
   shortcut_en = 'BG',
   name_de = 'Gebaeudegruppe',
   display_de = 'Gebäudegruppe',
   shortcut_de = 'GG',
   name_fr = 'BATIMENTS',
   display_fr = 'Bâtiments',
   shortcut_fr = 'BG',
   name_it = 'gruppo_costruzione',
   display_it = 'Gruppo costruzione',
   shortcut_it = '',
   name_ro = 'grupuri_de_cladiri',
   display_ro = 'rrr_Gebaeudegruppe',
   shortcut_ro = ''
WHERE (id = 6100 AND tablename = 'building_group');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (6101,'farm') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'farm',
   name_en = 'farm',
   display_en = 'farm',
   shortcut_en = 'FA',
   name_de = 'Landwirtschaftsbetrieb',
   display_de = 'Landwirtschaftsbetrieb',
   shortcut_de = 'LB',
   name_fr = 'EXPLOITATION_AGRICOLE',
   display_fr = 'Exploitation agricole',
   shortcut_fr = 'EA',
   name_it = 'fattoria',
   display_it = 'zzz_Landwirtschaftsbetrieb',
   shortcut_it = '',
   name_ro = 'ferma',
   display_ro = 'rrr_Landwirtschaftsbetrieb',
   shortcut_ro = ''
WHERE (id = 6101 AND tablename = 'farm');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (6103,'small_treatment_plant') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'small_treatment_plant',
   name_en = 'small_treatment_plant',
   display_en = 'small treatment plant',
   shortcut_en = 'SM',
   name_de = 'KLARA',
   display_de = 'KLARA',
   shortcut_de = 'KL',
   name_fr = 'PETITE_STEP',
   display_fr = 'Petite STEP',
   shortcut_fr = 'PS',
   name_it = 'piccolo_IDA',
   display_it = 'Piccolo IDA',
   shortcut_it = '',
   name_ro = 'rrr_KLARA',
   display_ro = 'rrr_KLARA',
   shortcut_ro = ''
WHERE (id = 6103 AND tablename = 'small_treatment_plant');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (6105,'building_group_baugwr') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'building_group_baugwr',
   name_en = 'building_group_baugwr',
   display_en = 'building group baugwr',
   shortcut_en = 'BW',
   name_de = 'Gebaeudegruppe_BAUGWR',
   display_de = 'Gebäudegruppe BAUGWR',
   shortcut_de = 'BA',
   name_fr = 'BATIMENTS_BAUREGBL',
   display_fr = 'Bâtiment BAUREGBL',
   shortcut_fr = 'BR',
   name_it = 'gruppo_costruzione_BAUREA',
   display_it = 'Gruppo costruzione BAUREA',
   shortcut_it = '',
   name_ro = 'grup_de_cladiri_BAUGWR',
   display_ro = 'rrr_Gebaeudegruppe_BAUGWR',
   shortcut_ro = ''
WHERE (id = 6105 AND tablename = 'building_group_baugwr');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (6106,'disposal') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'disposal',
   name_en = 'disposal',
   display_en = 'disposal',
   shortcut_en = 'DI',
   name_de = 'Entsorgung',
   display_de = 'Entsorgung',
   shortcut_de = 'NG',
   name_fr = 'EVACUATION',
   display_fr = 'Evacuation',
   shortcut_fr = 'ON',
   name_it = 'smaltimento',
   display_it = 'Smaltimento',
   shortcut_it = '',
   name_ro = 'rrr_Entsorgung',
   display_ro = 'rrr_Entsorgung',
   shortcut_ro = ''
WHERE (id = 6106 AND tablename = 'disposal');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (6107,'drainless_toilet') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'drainless_toilet',
   name_en = 'drainless_toilet',
   display_en = 'toilet',
   shortcut_en = 'DT',
   name_de = 'Abflusslose_Toilette',
   display_de = 'Abflusslose Toilette',
   shortcut_de = 'TA',
   name_fr = 'TOILETTE_SANS_VIDANGE',
   display_fr = 'Toilette sans vidange',
   shortcut_fr = 'DT',
   name_it = 'toilette_senza_scarico',
   display_it = 'Toilette senza scarico',
   shortcut_it = 'DT',
   name_ro = 'rrr_Abflusslose_Toilette',
   display_ro = 'rrr_Abflusslose_Toilette',
   shortcut_ro = 'DT'
WHERE (id = 6107 AND tablename = 'drainless_toilet');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (62,'dryweather_flume') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'dryweather_flume',
   name_en = 'dryweather_flume',
   display_en = 'dryweather flume',
   shortcut_en = 'DF',
   name_de = 'Trockenwetterrinne',
   display_de = 'Trockenwetterrinne',
   shortcut_de = 'TR',
   name_fr = 'CUNETTE_DEBIT_TEMPS_SEC',
   display_fr = 'Cunette de débit temps sec',
   shortcut_fr = 'CU',
   name_it = 'canaletta_per_tempo_secco',
   display_it = 'Canaletta per tempo secco',
   shortcut_it = '',
   name_ro = 'albie_minora',
   display_ro = 'albie minora',
   shortcut_ro = ''
WHERE (id = 62 AND tablename = 'dryweather_flume');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (63,'overflow') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'overflow',
   name_en = 'overflow',
   display_en = 'overflow',
   shortcut_en = 'OV',
   name_de = 'Ueberlauf',
   display_de = 'Überlauf',
   shortcut_de = 'UE',
   name_fr = 'DEVERSOIR',
   display_fr = 'Déversoir',
   shortcut_fr = 'DE',
   name_it = 'stramazzo',
   display_it = 'Stramazzo',
   shortcut_it = '',
   name_ro = 'rrr_Ueberlauf',
   display_ro = 'rrr_Ueberlauf',
   shortcut_ro = ''
WHERE (id = 63 AND tablename = 'overflow');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (64,'overflow_char') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'overflow_char',
   name_en = 'overflow_char',
   display_en = 'overflow characteristic',
   shortcut_en = 'OC',
   name_de = 'Ueberlaufcharakteristik',
   display_de = 'Überlaufcharakteristik',
   shortcut_de = 'UC',
   name_fr = 'CARACTERISTIQUES_DEVERSOIR',
   display_fr = 'Caractéristiques du déversoir',
   shortcut_fr = 'CD',
   name_it = 'zzz_caratteristiche_del_stramazzo',
   display_it = 'Caratteristiche del stramazzo',
   shortcut_it = '',
   name_ro = 'rrr_Ueberlaufcharakteristik',
   display_ro = 'rrr_Ueberlaufcharakteristik',
   shortcut_ro = ''
WHERE (id = 64 AND tablename = 'overflow_char');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (68,'infiltration_installation') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'infiltration_installation',
   name_en = 'infiltration_installation',
   display_en = 'infiltration installation',
   shortcut_en = 'II',
   name_de = 'Versickerungsanlage',
   display_de = 'Versickerungsanlage',
   shortcut_de = 'VA',
   name_fr = 'INSTALLATION_INFILTRATION',
   display_fr = 'Installation d''infiltration',
   shortcut_fr = 'II',
   name_it = 'impianto_infiltrazione',
   display_it = 'Impianto infiltrazione',
   shortcut_it = '',
   name_ro = 'dren',
   display_ro = 'dren',
   shortcut_ro = ''
WHERE (id = 68 AND tablename = 'infiltration_installation');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (69,'discharge_point') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'discharge_point',
   name_en = 'discharge_point',
   display_en = 'discharge point',
   shortcut_en = 'DP',
   name_de = 'Einleitstelle',
   display_de = 'Einleitstelle',
   shortcut_de = 'VE',
   name_fr = 'EXUTOIRE',
   display_fr = 'Exutoire au milieu récepteur',
   shortcut_fr = 'EX',
   name_it = 'punto_immissione',
   display_it = 'Punto immissione',
   shortcut_it = '',
   name_ro = 'deversor',
   display_ro = 'punct deversare',
   shortcut_ro = ''
WHERE (id = 69 AND tablename = 'discharge_point');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (70,'mechanical_pretreatment') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'mechanical_pretreatment',
   name_en = 'mechanical_pretreatment',
   display_en = 'mechanical pretreatment',
   shortcut_en = 'MT',
   name_de = 'MechanischeVorreinigung',
   display_de = 'Mechanische Vorreinigung',
   shortcut_de = 'MV',
   name_fr = 'PRETRAITEMENT_MECANIQUE',
   display_fr = 'Prétraitement méchanique',
   shortcut_fr = 'ME',
   name_it = 'trattamenti_meccanici',
   display_it = 'Trattamenti meccanici',
   shortcut_it = '',
   name_ro = 'rrr_MechanischeVorreinigung',
   display_ro = 'rrr_MechanischeVorreinigung',
   shortcut_ro = ''
WHERE (id = 70 AND tablename = 'mechanical_pretreatment');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (74,'measure') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'measure',
   name_en = 'measure',
   display_en = 'mesure',
   shortcut_en = 'MM',
   name_de = 'Massnahme',
   display_de = 'Massnahme',
   shortcut_de = 'MP',
   name_fr = 'MESURE',
   display_fr = 'Mésure',
   shortcut_fr = 'MX',
   name_it = 'intervento',
   display_it = 'Intervento',
   shortcut_it = '',
   name_ro = 'rrr_Massnahme',
   display_ro = 'rrr_Massnahme',
   shortcut_ro = ''
WHERE (id = 74 AND tablename = 'measure');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (76,'flushing_nozzle') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'flushing_nozzle',
   name_en = 'flushing_nozzle',
   display_en = 'Flushing nozzle',
   shortcut_en = 'FN',
   name_de = 'Spuelstutzen',
   display_de = 'Spülstutzen',
   shortcut_de = 'SP',
   name_fr = 'TETE_DE_RINCAGE',
   display_fr = 'Tête de rinçage',
   shortcut_fr = 'BU',
   name_it = 'zzz_ugello_di_lavaggio',
   display_it = 'Ugello di lavaggio',
   shortcut_it = '',
   name_ro = 'rrr_Spuelstutzen',
   display_ro = 'rrr_Spuelstutzen',
   shortcut_ro = ''
WHERE (id = 76 AND tablename = 'flushing_nozzle');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (8,'connection_object') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'connection_object',
   name_en = 'connection_object',
   display_en = 'connection object',
   shortcut_en = 'CN',
   name_de = 'Anschlussobjekt',
   display_de = 'Anschlussobjekt',
   shortcut_de = 'AO',
   name_fr = 'OBJET_RACCORDE',
   display_fr = 'Objet raccordé',
   shortcut_fr = 'OB',
   name_it = 'zzz_oggetto_di_connessione',
   display_it = 'Oggetto di connessione',
   shortcut_it = '',
   name_ro = 'rrr_Anschlussobjekt',
   display_ro = 'rrr_Anschlussobjekt',
   shortcut_ro = ''
WHERE (id = 8 AND tablename = 'connection_object');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (83,'maintenance') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'maintenance',
   name_en = 'maintenance',
   display_en = 'maintencance',
   shortcut_en = 'MN',
   name_de = 'Unterhalt',
   display_de = 'Unterhalt',
   shortcut_de = 'UH',
   name_fr = 'MAINTENANCE',
   display_fr = 'maintenance',
   shortcut_fr = 'MN',
   name_it = 'mantenimento',
   display_it = 'Mantenimento',
   shortcut_it = '',
   name_ro = 'mentenanta',
   display_ro = 'Mentenan?a',
   shortcut_ro = ''
WHERE (id = 83 AND tablename = 'maintenance');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (9,'waste_water_treatment_plant') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'waste_water_treatment_plant',
   name_en = 'waste_water_treatment_plant',
   display_en = 'waste water treatment plant',
   shortcut_en = 'TP',
   name_de = 'Abwasserreinigungsanlage',
   display_de = 'Abwasserreinigungsanlage',
   shortcut_de = 'AR',
   name_fr = 'STATION_EPURATION',
   display_fr = 'Station d''épuration des eaux usées',
   shortcut_fr = 'ST',
   name_it = 'IDA',
   display_it = 'Impianti di depurazione delle acque di scarico (IDA)',
   shortcut_it = '',
   name_ro = 'statia_de_tratare_a_apelor_uzate',
   display_ro = 'statia_de_tratare_a_apelor_uzate',
   shortcut_ro = ''
WHERE (id = 9 AND tablename = 'waste_water_treatment_plant');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (97,'wwtp_structure') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wwtp_structure',
   name_en = 'wwtp_structure',
   display_en = 'wwtp structure',
   shortcut_en = 'WT',
   name_de = 'ARABauwerk',
   display_de = 'ARA Bauwerk',
   shortcut_de = 'AW',
   name_fr = 'OUVRAGES_STEP',
   display_fr = 'Ouvrages d''une  STEP',
   shortcut_fr = 'OS',
   name_it = 'zzz_manufatto_IDA',
   display_it = 'Manufatto IDA',
   shortcut_it = '',
   name_ro = 'rrr_ARABauwerk',
   display_ro = 'rrr_ARABauwerk',
   shortcut_ro = ''
WHERE (id = 97 AND tablename = 'wwtp_structure');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99,'measuring_device') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'measuring_device',
   name_en = 'measuring_device',
   display_en = 'measuring device',
   shortcut_en = 'MV',
   name_de = 'Messgeraet',
   display_de = 'Messgerät',
   shortcut_de = 'MG',
   name_fr = 'APPAREIL_MESURE',
   display_fr = 'Appareil de mesure',
   shortcut_fr = 'AP',
   name_it = 'zzz_dispositivo_di_misura',
   display_it = 'Dispositivo di misura',
   shortcut_it = '',
   name_ro = 'rrr_Messgeraet',
   display_ro = 'rrr_Messgeraet',
   shortcut_ro = ''
WHERE (id = 99 AND tablename = 'measuring_device');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99700,'wastewater_structure_symbol') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wastewater_structure_symbol',
   name_en = 'wastewater_structure_symbol',
   display_en = 'wastewater structure symbol',
   shortcut_en = 'BX',
   name_de = 'Abwasserbauwerk_Symbol',
   display_de = 'Abwasserbauwerk Symbol',
   shortcut_de = 'BX',
   name_fr = 'OUVRAGE_RESEAU_AS_SYMBOLE',
   display_fr = 'Ouvrage du réseau d''assainissement Symbole',
   shortcut_fr = 'BX',
   name_it = 'manufatto_smaltimento_simbolo',
   display_it = 'manufatto smaltimentoSimbolo',
   shortcut_it = 'BX',
   name_ro = 'structura_canalizare_simbol',
   display_ro = 'structura canalizare simbol',
   shortcut_ro = 'BX'
WHERE (id = 99700 AND tablename = 'wastewater_structure_symbol');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99800,'reach_progression_alternative') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'reach_progression_alternative',
   name_en = 'reach_progression_alternative',
   display_en = 'reach progression alternative',
   shortcut_en = 'PX',
   name_de = 'Haltung_AlternativVerlauf',
   display_de = 'Haltung Alternativ Verlauf',
   shortcut_de = 'PX',
   name_fr = 'TRONCON_TRACE_ALTERNATIVE',
   display_fr = 'Troncon Trace alternative',
   shortcut_fr = 'PX',
   name_it = 'tratta_tracciato_alternativo',
   display_it = 'Tracciato alternativo',
   shortcut_it = 'PX',
   name_ro = 'tronson_traseu_alternativ',
   display_ro = 'tronson traseu alternativ',
   shortcut_ro = 'PX'
WHERE (id = 99800 AND tablename = 'reach_progression_alternative');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99900,'wastewater_structure_text') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'wastewater_structure_text',
   name_en = 'wastewater_structure_text',
   display_en = 'wastewater structure text',
   shortcut_en = 'WX',
   name_de = 'Abwasserbauwerk_Text',
   display_de = 'Abwasserbauwerk Text',
   shortcut_de = 'WX',
   name_fr = 'OUVRAGE_RESEAU_AS_TEXTE',
   display_fr = 'Ouvrage du réseau d''assainissement Texte',
   shortcut_fr = 'WX',
   name_it = 'manufatto_smaltimento_acque_testo',
   display_it = 'Manufatto smaltimento acque Testo',
   shortcut_it = 'WX',
   name_ro = 'structura_canalizare_text',
   display_ro = 'structura canalizare text',
   shortcut_ro = 'WX'
WHERE (id = 99900 AND tablename = 'wastewater_structure_text');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99901,'reach_text') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'reach_text',
   name_en = 'reach_text',
   display_en = 'reach text',
   shortcut_en = 'RX',
   name_de = 'Haltung_Text',
   display_de = 'Haltung Text',
   shortcut_de = 'RX',
   name_fr = 'TRONCON_TEXTE',
   display_fr = 'Troncon Texte',
   shortcut_fr = 'RX',
   name_it = 'tratta_testo',
   display_it = 'Tratta Testo',
   shortcut_it = 'RX',
   name_ro = 'tronson_text',
   display_ro = 'tronson text',
   shortcut_ro = 'RX'
WHERE (id = 99901 AND tablename = 'reach_text');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99902,'catchment_area_text') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'catchment_area_text',
   name_en = 'catchment_area_text',
   display_en = 'catchment area text',
   shortcut_en = 'CX',
   name_de = 'Einzugsgebiet_Text',
   display_de = 'Einzugsgebiet Text',
   shortcut_de = 'CX',
   name_fr = 'BASSIN_VERSANT_TEXTE',
   display_fr = 'Bassin versant Texte',
   shortcut_fr = 'CX',
   name_it = 'bacino_gravitante_testo',
   display_it = 'Bacino gravitante Testo',
   shortcut_it = 'CX',
   name_ro = 'aria_de_captare_text',
   display_ro = 'aria de captare text',
   shortcut_ro = 'CX'
WHERE (id = 99902 AND tablename = 'catchment_area_text');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (9998,'mutation') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 'mutation',
   name_en = 'mutation',
   display_en = 'mutation',
   shortcut_en = 'MD',
   name_de = 'Mutation',
   display_de = 'Mutation',
   shortcut_de = 'MD',
   name_fr = 'MUTATION',
   display_fr = 'Mutation',
   shortcut_fr = 'MD',
   name_it = 'mutazione',
   display_it = 'Mutazione',
   shortcut_it = '',
   name_ro = 'Mutatia',
   display_ro = 'rrr_MUTATION',
   shortcut_ro = ''
WHERE (id = 9998 AND tablename = 'mutation');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99982,'re_maintenance_event_wastewater_structure') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 're_maintenance_event_wastewater_structure',
   name_en = 'maintenance_event_wastewater_structure',
   display_en = 'maintenance event wastewater structure',
   shortcut_en = 'MW',
   name_de = 'Erhaltungsereignis_Abwasserbauwerk',
   display_de = 'Erhaltungsereignis Abwasserbauwerk',
   shortcut_de = 'RA',
   name_fr = 'EVENEMENT_MAINTENANCE_OUVRAGE_RESEAU_AS',
   display_fr = 'Evénement de maintenance Ouvrage réseau AS',
   shortcut_fr = 'EZ',
   name_it = 'zzz_evento_di_mantenimento_manufatto_smaltimento_acque',
   display_it = 'evento_di_mantenimento_manufatto_smaltimento_acque',
   shortcut_it = '',
   name_ro = 'rrr_Erhaltungsereignis_structura_canalizare',
   display_ro = 'rrr_Erhaltungsereignis_structura_canalizare',
   shortcut_ro = ''
WHERE (id = 99982 AND tablename = 're_maintenance_event_wastewater_structure');

--- Adapt tww_sys.dictionary_od_table
INSERT INTO tww_sys.dictionary_od_table (id, tablename) VALUES (99985,'re_building_group_disposal') ON CONFLICT DO NOTHING;

UPDATE tww_sys.dictionary_od_table SET
   tablename = 're_building_group_disposal',
   name_en = 'building_group_disposal',
   display_en = 'building group disposal',
   shortcut_en = 'ZZ',
   name_de = 'Gebaeudegruppe_Entsorgung',
   display_de = 'Gebaeudegruppe Entsorgung',
   shortcut_de = 'ZZ',
   name_fr = 'BATIMENTS_EVACUATION',
   display_fr = 'Bâtiments Evacuation',
   shortcut_fr = 'ZZ',
   name_it = 'gruppo_costruzione_smaltimento',
   display_it = 'Gruppo costruzione smaltimento',
   shortcut_it = 'ZZ',
   name_ro = 'rrr_Gebaeudegruppe_Entsorgung',
   display_ro = 'rrr_Gebaeudegruppe_Entsorgung',
   shortcut_ro = 'ZZ'
WHERE (id = 99985 AND tablename = 're_building_group_disposal');
