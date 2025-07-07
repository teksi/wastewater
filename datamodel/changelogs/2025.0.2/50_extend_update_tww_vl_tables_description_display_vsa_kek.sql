------ This file generates the delta file for updating value list tables for VSA-DSS database (Modul VSA-KEK (2020)) in en for QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 07.07.2025 18:10:38

ALTER TABLE tww_vl.value_list_base
ADD COLUMN IF NOT EXISTS description_en text,
ADD COLUMN IF NOT EXISTS description_de text,
ADD COLUMN IF NOT EXISTS description_fr text,
ADD COLUMN IF NOT EXISTS description_it text,
ADD COLUMN IF NOT EXISTS description_ro text,
ADD COLUMN IF NOT EXISTS display_en character varying(100),
ADD COLUMN IF NOT EXISTS display_de character varying(100),
ADD COLUMN IF NOT EXISTS display_fr character varying(100),
ADD COLUMN IF NOT EXISTS display_it character varying(100),
ADD COLUMN IF NOT EXISTS display_ro character varying(100),
ADD COLUMN IF NOT EXISTS display_en character varying(100);

--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3681,3681) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
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
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code =3681;
--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3682,3682) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
   value_en = 'field_visit',
   value_de = 'Begehung',
   value_fr = 'parcours',
   value_it = 'sopralluogo',
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
   display_en = 'field_visit',
   display_de = 'Begehung',
   display_fr = 'parcours',
   display_it = '',
   display_ro = ''
WHERE code =3682;
--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3683,3683) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
   value_en = 'deformation_measurement',
   value_de = 'Deformationsmessung',
   value_fr = 'mesure_deformation',
   value_it = 'misura_deformazione',
   value_ro = 'rrr_Deformationsmessung',
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
   display_en = 'deformation_measurement',
   display_de = 'Deformationsmessung',
   display_fr = 'mesure déformation',
   display_it = '',
   display_ro = ''
WHERE code =3683;
--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3684,3684) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
   value_en = 'leak_test',
   value_de = 'Dichtheitspruefung',
   value_fr = 'examen_etancheite',
   value_it = 'prova_tenuta',
   value_ro = 'rrr_Dichtheitspruefung',
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
   display_en = 'leak_test',
   display_de = 'Dichtheitspruefung',
   display_fr = 'examen etancheite',
   display_it = '',
   display_ro = ''
WHERE code =3684;
--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3685,3685) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
   value_en = 'georadar',
   value_de = 'Georadar',
   value_fr = 'georadar',
   value_it = 'georadar',
   value_ro = 'rrr_Georadar',
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
   display_en = 'georadar',
   display_de = 'Georadar',
   display_fr = 'georadar',
   display_it = '',
   display_ro = ''
WHERE code =3685;
--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3686,3686) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
   value_en = 'channel_TV',
   value_de = 'Kanalfernsehen',
   value_fr = 'camera_canalisations',
   value_it = 'videoispezione',
   value_ro = 'rrr_Kanalfernsehen',
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
   display_en = 'channel_TV',
   display_de = 'Kanalfernsehen',
   display_fr = 'camera canalisations',
   display_it = '',
   display_ro = ''
WHERE code =3686;
--- Adapt tww_vl.examination_recording_type
 INSERT INTO tww_vl.examination_recording_type (code, vsacode) VALUES (3687,3687) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_recording_type SET
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
WHERE code =3687;
--- Adapt tww_vl.examination_weather
 INSERT INTO tww_vl.examination_weather (code, vsacode) VALUES (3699,3699) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_weather SET
   value_en = 'covered_rainy',
   value_de = 'bedeckt_regnerisch',
   value_fr = 'couvert_pluvieux',
   value_it = 'coperto_piovoso',
   value_ro = 'rrr_bedeckt_regnerisch',
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
   display_en = 'covered_rainy',
   display_de = 'bedeckt_regnerisch',
   display_fr = 'couvert pluvieux',
   display_it = '',
   display_ro = ''
WHERE code =3699;
--- Adapt tww_vl.examination_weather
 INSERT INTO tww_vl.examination_weather (code, vsacode) VALUES (3700,3700) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_weather SET
   value_en = 'drizzle',
   value_de = 'Nieselregen',
   value_fr = 'bruine',
   value_it = 'piogerella',
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
   display_en = 'drizzle',
   display_de = 'Nieselregen',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3700;
--- Adapt tww_vl.examination_weather
 INSERT INTO tww_vl.examination_weather (code, vsacode) VALUES (3701,3701) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_weather SET
   value_en = 'rain',
   value_de = 'Regen',
   value_fr = 'pluie',
   value_it = 'pioggia',
   value_ro = 'rrr_Regen',
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
   display_en = 'rain',
   display_de = 'Regen',
   display_fr = 'pluie',
   display_it = '',
   display_ro = ''
WHERE code =3701;
--- Adapt tww_vl.examination_weather
 INSERT INTO tww_vl.examination_weather (code, vsacode) VALUES (3702,3702) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_weather SET
   value_en = 'snowfall',
   value_de = 'Schneefall',
   value_fr = 'chute_neige',
   value_it = 'nevica',
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
   display_en = 'snowfall',
   display_de = 'Schneefall',
   display_fr = 'chute neige',
   display_it = '',
   display_ro = ''
WHERE code =3702;
--- Adapt tww_vl.examination_weather
 INSERT INTO tww_vl.examination_weather (code, vsacode) VALUES (3703,3703) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_weather SET
   value_en = 'nice_dry',
   value_de = 'schoen_trocken',
   value_fr = 'beau_sec',
   value_it = 'sereno_asciutto',
   value_ro = 'rrr_schoen_trocken',
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
   display_en = 'nice_dry',
   display_de = 'schoen_trocken',
   display_fr = 'beau sec',
   display_it = '',
   display_ro = ''
WHERE code =3703;
--- Adapt tww_vl.examination_weather
 INSERT INTO tww_vl.examination_weather (code, vsacode) VALUES (3704,3704) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.examination_weather SET
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
WHERE code =3704;
--- Adapt tww_vl.damage_connection
 INSERT INTO tww_vl.damage_connection (code, vsacode) VALUES (8498,8498) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_connection SET
   value_en = 'yes',
   value_de = 'ja',
   value_fr = 'oui',
   value_it = 'si',
   value_ro = 'da',
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
   display_en = 'yes',
   display_de = 'ja',
   display_fr = 'oui',
   display_it = 'si',
   display_ro = 'da'
WHERE code =8498;
--- Adapt tww_vl.damage_connection
 INSERT INTO tww_vl.damage_connection (code, vsacode) VALUES (8499,8499) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_connection SET
   value_en = 'no',
   value_de = 'nein',
   value_fr = 'non',
   value_it = 'no',
   value_ro = 'nu',
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
   display_en = 'no',
   display_de = 'nein',
   display_fr = 'non',
   display_it = '',
   display_ro = ''
WHERE code =8499;
--- Adapt tww_vl.damage_single_damage_class
 INSERT INTO tww_vl.damage_single_damage_class (code, vsacode) VALUES (3707,3707) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_single_damage_class SET
   value_en = 'EZ0',
   value_de = 'EZ0',
   value_fr = 'EZ0',
   value_it = 'EZ0',
   value_ro = 'EZ0',
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
   display_en = 'EZ0',
   display_de = 'EZ0',
   display_fr = 'EZ0',
   display_it = '',
   display_ro = 'EZ0'
WHERE code =3707;
--- Adapt tww_vl.damage_single_damage_class
 INSERT INTO tww_vl.damage_single_damage_class (code, vsacode) VALUES (3708,3708) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_single_damage_class SET
   value_en = 'EZ1',
   value_de = 'EZ1',
   value_fr = 'EZ1',
   value_it = 'EZ1',
   value_ro = 'EZ1',
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
   display_en = 'EZ1',
   display_de = 'EZ1',
   display_fr = 'EZ1',
   display_it = '',
   display_ro = 'EZ1'
WHERE code =3708;
--- Adapt tww_vl.damage_single_damage_class
 INSERT INTO tww_vl.damage_single_damage_class (code, vsacode) VALUES (3709,3709) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_single_damage_class SET
   value_en = 'EZ2',
   value_de = 'EZ2',
   value_fr = 'EZ2',
   value_it = 'EZ2',
   value_ro = 'EZ2',
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
   display_en = 'EZ2',
   display_de = 'EZ2',
   display_fr = 'EZ2',
   display_it = '',
   display_ro = 'EZ2'
WHERE code =3709;
--- Adapt tww_vl.damage_single_damage_class
 INSERT INTO tww_vl.damage_single_damage_class (code, vsacode) VALUES (3710,3710) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_single_damage_class SET
   value_en = 'EZ3',
   value_de = 'EZ3',
   value_fr = 'EZ3',
   value_it = 'EZ3',
   value_ro = 'EZ3',
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
   display_en = 'EZ3',
   display_de = 'EZ3',
   display_fr = 'EZ3',
   display_it = '',
   display_ro = 'EZ3'
WHERE code =3710;
--- Adapt tww_vl.damage_single_damage_class
 INSERT INTO tww_vl.damage_single_damage_class (code, vsacode) VALUES (3711,3711) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_single_damage_class SET
   value_en = 'EZ4',
   value_de = 'EZ4',
   value_fr = 'EZ4',
   value_it = 'EZ4',
   value_ro = 'EZ4',
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
   display_en = 'EZ4',
   display_de = 'EZ4',
   display_fr = 'EZ4',
   display_it = '',
   display_ro = 'EZ4'
WHERE code =3711;
--- Adapt tww_vl.damage_single_damage_class
 INSERT INTO tww_vl.damage_single_damage_class (code, vsacode) VALUES (4561,4561) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_single_damage_class SET
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
WHERE code =4561;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4103,4103) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXA',
   value_de = 'AECXA',
   value_fr = 'AECXA',
   value_it = 'AECXA',
   value_ro = 'AECXA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel',
   description_de = 'Rohrprofilwechsel',
   description_fr = 'Modification de la section transversale de la canalisation',
   description_it = 'Modifica del profilo del tubo',
   description_ro = '',
   display_en = 'AECXA',
   display_de = 'AECXA',
   display_fr = 'AECXA',
   display_it = 'AECXA',
   display_ro = 'AECXA'
WHERE code =4103;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4104,4104) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXB',
   value_de = 'AECXB',
   value_fr = 'AECXB',
   value_it = 'AECXB',
   value_ro = 'AECXB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: Eiprofil',
   description_de = 'Rohrprofilwechsel: Eiprofil',
   description_fr = 'Modification de la section transversale de la canalisation: ovoïde',
   description_it = 'Modifica del profilo del tubo: profilo ovoidale',
   description_ro = '',
   display_en = 'AECXB',
   display_de = 'AECXB',
   display_fr = 'AECXB',
   display_it = 'AECXB',
   display_ro = 'AECXB'
WHERE code =4104;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4105,4105) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXC',
   value_de = 'AECXC',
   value_fr = 'AECXC',
   value_it = 'AECXC',
   value_ro = 'AECXC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: Kreisprofil',
   description_de = 'Rohrprofilwechsel: Kreisprofil',
   description_fr = 'Modification de la section transversale de la canalisation: circulaire',
   description_it = 'Modifica del profilo del tubo: profilo circolare',
   description_ro = '',
   display_en = 'AECXC',
   display_de = 'AECXC',
   display_fr = 'AECXC',
   display_it = 'AECXC',
   display_ro = 'AECXC'
WHERE code =4105;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4106,4106) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXD',
   value_de = 'AECXD',
   value_fr = 'AECXD',
   value_it = 'AECXD',
   value_ro = 'AECXD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: Maulprofil',
   description_de = 'Rohrprofilwechsel: Maulprofil',
   description_fr = 'Modification de la section transversale de la canalisation: fer à cheval',
   description_it = 'Modifica del profilo del tubo: profilo ellittico',
   description_ro = '',
   display_en = 'AECXD',
   display_de = 'AECXD',
   display_fr = 'AECXD',
   display_it = 'AECXD',
   display_ro = 'AECXD'
WHERE code =4106;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4107,4107) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXE',
   value_de = 'AECXE',
   value_fr = 'AECXE',
   value_it = 'AECXE',
   value_ro = 'AECXE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: offenes Profil',
   description_de = 'Rohrprofilwechsel: offenes Profil',
   description_fr = 'Modification de la section transversale de la canalisation: profil ouvert',
   description_it = 'Modifica del profilo del tubo: profilo aperto',
   description_ro = '',
   display_en = 'AECXE',
   display_de = 'AECXE',
   display_fr = 'AECXE',
   display_it = 'AECXE',
   display_ro = 'AECXE'
WHERE code =4107;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4108,4108) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXF',
   value_de = 'AECXF',
   value_fr = 'AECXF',
   value_it = 'AECXF',
   value_ro = 'AECXF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: Rechteckprofil',
   description_de = 'Rohrprofilwechsel: Rechteckprofil',
   description_fr = 'Modification de la section transversale de la canalisation: rectangulaire',
   description_it = 'Modifica del profilo del tubo: profilo rettangolare',
   description_ro = '',
   display_en = 'AECXF',
   display_de = 'AECXF',
   display_fr = 'AECXF',
   display_it = 'AECXF',
   display_ro = 'AECXF'
WHERE code =4108;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4109,4109) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXG',
   value_de = 'AECXG',
   value_fr = 'AECXG',
   value_it = 'AECXG',
   value_ro = 'AECXG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: Spezialprofil',
   description_de = 'Rohrprofilwechsel: Spezialprofil',
   description_fr = 'Modification de la section transversale de la canalisation: profil spéciale',
   description_it = 'Modifica del profilo del tubo: profilo speciale',
   description_ro = '',
   display_en = 'AECXG',
   display_de = 'AECXG',
   display_fr = 'AECXG',
   display_it = 'AECXG',
   display_ro = 'AECXG'
WHERE code =4109;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4110,4110) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AECXH',
   value_de = 'AECXH',
   value_fr = 'AECXH',
   value_it = 'AECXH',
   value_ro = 'AECXH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrprofilwechsel: unbekanntes Profil',
   description_de = 'Rohrprofilwechsel: unbekanntes Profil',
   description_fr = 'Modification de la section transversale de la canalisation: profil inconnue',
   description_it = 'Modifica del profilo del tubo: profilo ignoto',
   description_ro = '',
   display_en = 'AECXH',
   display_de = 'AECXH',
   display_fr = 'AECXH',
   display_it = 'AECXH',
   display_ro = 'AECXH'
WHERE code =4110;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4111,4111) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXA',
   value_de = 'AEDXA',
   value_fr = 'AEDXA',
   value_it = 'AEDXA',
   value_ro = 'AEDXA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel',
   description_de = 'Rohrmaterialwechsel',
   description_fr = 'Changement du matériau de la canalisation',
   description_it = 'Cambio materiale del tubo',
   description_ro = '',
   display_en = 'AEDXA',
   display_de = 'AEDXA',
   display_fr = 'AEDXA',
   display_it = 'AEDXA',
   display_ro = 'AEDXA'
WHERE code =4111;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4112,4112) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXB',
   value_de = 'AEDXB',
   value_fr = 'AEDXB',
   value_it = 'AEDXB',
   value_ro = 'AEDXB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Asbestzement',
   description_de = 'Rohrmaterialwechsel: Asbestzement',
   description_fr = 'Changement du matériau de la canalisation: béton amianté',
   description_it = 'Cambio materiale del tubo: cemento amianto',
   description_ro = '',
   display_en = 'AEDXB',
   display_de = 'AEDXB',
   display_fr = 'AEDXB',
   display_it = 'AEDXB',
   display_ro = 'AEDXB'
WHERE code =4112;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4113,4113) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXC',
   value_de = 'AEDXC',
   value_fr = 'AEDXC',
   value_it = 'AEDXC',
   value_ro = 'AEDXC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Normalbeton',
   description_de = 'Rohrmaterialwechsel: Normalbeton',
   description_fr = 'Changement du matériau de la canalisation: béton normal',
   description_it = 'Cambio materiale del tubo: calcestruzzo',
   description_ro = '',
   display_en = 'AEDXC',
   display_de = 'AEDXC',
   display_fr = 'AEDXC',
   display_it = 'AEDXC',
   display_ro = 'AEDXC'
WHERE code =4113;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4114,4114) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXD',
   value_de = 'AEDXD',
   value_fr = 'AEDXD',
   value_it = 'AEDXD',
   value_ro = 'AEDXD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Ortsbeton',
   description_de = 'Rohrmaterialwechsel: Ortsbeton',
   description_fr = 'Changement du matériau de la canalisation: béton local',
   description_it = 'Cambio materiale del tubo: calcestruzzo gettato in opera',
   description_ro = '',
   display_en = 'AEDXD',
   display_de = 'AEDXD',
   display_fr = 'AEDXD',
   display_it = 'AEDXD',
   display_ro = 'AEDXD'
WHERE code =4114;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4115,4115) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXE',
   value_de = 'AEDXE',
   value_fr = 'AEDXE',
   value_it = 'AEDXE',
   value_ro = 'AEDXE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Pressrohrbeton',
   description_de = 'Rohrmaterialwechsel: Pressrohrbeton',
   description_fr = 'Changement du matériau de la canalisation: béton de tube de fonçage',
   description_it = 'Cambio materiale del tubo: calcestruzzo pressato',
   description_ro = '',
   display_en = 'AEDXE',
   display_de = 'AEDXE',
   display_fr = 'AEDXE',
   display_it = 'AEDXE',
   display_ro = 'AEDXE'
WHERE code =4115;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4116,4116) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXF',
   value_de = 'AEDXF',
   value_fr = 'AEDXF',
   value_it = 'AEDXF',
   value_ro = 'AEDXF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Spezialbeton',
   description_de = 'Rohrmaterialwechsel: Spezialbeton',
   description_fr = 'Changement du matériau de la canalisation: béton spécial',
   description_it = 'Cambio materiale del tubo: calcestruzzo speciale',
   description_ro = '',
   display_en = 'AEDXF',
   display_de = 'AEDXF',
   display_fr = 'AEDXF',
   display_it = 'AEDXF',
   display_ro = 'AEDXF'
WHERE code =4116;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4117,4117) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXG',
   value_de = 'AEDXG',
   value_fr = 'AEDXG',
   value_it = 'AEDXG',
   value_ro = 'AEDXG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Beton',
   description_de = 'Rohrmaterialwechsel: Beton',
   description_fr = 'Changement du matériau de la canalisation: béton',
   description_it = 'Cambio materiale del tubo: calcestruzzo',
   description_ro = '',
   display_en = 'AEDXG',
   display_de = 'AEDXG',
   display_fr = 'AEDXG',
   display_it = 'AEDXG',
   display_ro = 'AEDXG'
WHERE code =4117;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4118,4118) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXH',
   value_de = 'AEDXH',
   value_fr = 'AEDXH',
   value_it = 'AEDXH',
   value_ro = 'AEDXH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Faserzement',
   description_de = 'Rohrmaterialwechsel: Faserzement',
   description_fr = 'Changement du matériau de la canalisation: fibrociment',
   description_it = 'Cambio materiale del tubo: fibrocemento',
   description_ro = '',
   display_en = 'AEDXH',
   display_de = 'AEDXH',
   display_fr = 'AEDXH',
   display_it = 'AEDXH',
   display_ro = 'AEDXH'
WHERE code =4118;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4119,4119) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXI',
   value_de = 'AEDXI',
   value_fr = 'AEDXI',
   value_it = 'AEDXI',
   value_ro = 'AEDXI',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Gebrannte Steine',
   description_de = 'Rohrmaterialwechsel: Gebrannte Steine',
   description_fr = 'Changement du matériau de la canalisation: terre cuite',
   description_it = 'Cambio materiale del tubo: laterizi',
   description_ro = '',
   display_en = 'AEDXI',
   display_de = 'AEDXI',
   display_fr = 'AEDXI',
   display_it = 'AEDXI',
   display_ro = 'AEDXI'
WHERE code =4119;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4120,4120) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXJ',
   value_de = 'AEDXJ',
   value_fr = 'AEDXJ',
   value_it = 'AEDXJ',
   value_ro = 'AEDXJ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Duktiler Guss',
   description_de = 'Rohrmaterialwechsel: Duktiler Guss',
   description_fr = 'Changement du matériau de la canalisation: fonte ductile',
   description_it = 'Cambio materiale del tubo: ghisa sferoidale',
   description_ro = '',
   display_en = 'AEDXJ',
   display_de = 'AEDXJ',
   display_fr = 'AEDXJ',
   display_it = 'AEDXJ',
   display_ro = 'AEDXJ'
WHERE code =4120;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4121,4121) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXK',
   value_de = 'AEDXK',
   value_fr = 'AEDXK',
   value_it = 'AEDXK',
   value_ro = 'AEDXK',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Grauguss',
   description_de = 'Rohrmaterialwechsel: Grauguss',
   description_fr = 'Changement du matériau de la canalisation: fonte grise',
   description_it = 'Cambio materiale del tubo: ghisa grigia',
   description_ro = '',
   display_en = 'AEDXK',
   display_de = 'AEDXK',
   display_fr = 'AEDXK',
   display_it = 'AEDXK',
   display_ro = 'AEDXK'
WHERE code =4121;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4122,4122) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXL',
   value_de = 'AEDXL',
   value_fr = 'AEDXL',
   value_it = 'AEDXL',
   value_ro = 'AEDXL',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Epoxidharz',
   description_de = 'Rohrmaterialwechsel: Epoxidharz',
   description_fr = 'Changement du matériau de la canalisation: résine époxyde',
   description_it = 'Cambio materiale del tubo: resina epossidica',
   description_ro = '',
   display_en = 'AEDXL',
   display_de = 'AEDXL',
   display_fr = 'AEDXL',
   display_it = 'AEDXL',
   display_ro = 'AEDXL'
WHERE code =4122;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4123,4123) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXM',
   value_de = 'AEDXM',
   value_fr = 'AEDXM',
   value_it = 'AEDXM',
   value_ro = 'AEDXM',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Hartpolyethylen',
   description_de = 'Rohrmaterialwechsel: Hartpolyethylen',
   description_fr = 'Changement du matériau de la canalisation: polyéthylène dur',
   description_it = 'Cambio materiale del tubo: polietilene rigido',
   description_ro = '',
   display_en = 'AEDXM',
   display_de = 'AEDXM',
   display_fr = 'AEDXM',
   display_it = 'AEDXM',
   display_ro = 'AEDXM'
WHERE code =4123;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4124,4124) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXN',
   value_de = 'AEDXN',
   value_fr = 'AEDXN',
   value_it = 'AEDXN',
   value_ro = 'AEDXN',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Polyester GUP',
   description_de = 'Rohrmaterialwechsel: Polyester GUP',
   description_fr = 'Changement du matériau de la canalisation: polyester GUP',
   description_it = 'Cambio materiale del tubo: poliestere GUP',
   description_ro = '',
   display_en = 'AEDXN',
   display_de = 'AEDXN',
   display_fr = 'AEDXN',
   display_it = 'AEDXN',
   display_ro = 'AEDXN'
WHERE code =4124;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4125,4125) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXO',
   value_de = 'AEDXO',
   value_fr = 'AEDXO',
   value_it = 'AEDXO',
   value_ro = 'AEDXO',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Polyethylen',
   description_de = 'Rohrmaterialwechsel: Polyethylen',
   description_fr = 'Changement du matériau de la canalisation: polyéthylène',
   description_it = 'Cambio materiale del tubo: polietilene',
   description_ro = '',
   display_en = 'AEDXO',
   display_de = 'AEDXO',
   display_fr = 'AEDXO',
   display_it = 'AEDXO',
   display_ro = 'AEDXO'
WHERE code =4125;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4126,4126) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXP',
   value_de = 'AEDXP',
   value_fr = 'AEDXP',
   value_it = 'AEDXP',
   value_ro = 'AEDXP',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Polypropylen',
   description_de = 'Rohrmaterialwechsel: Polypropylen',
   description_fr = 'Changement du matériau de la canalisation: polypropylène',
   description_it = 'Cambio materiale del tubo: polipropilene',
   description_ro = '',
   display_en = 'AEDXP',
   display_de = 'AEDXP',
   display_fr = 'AEDXP',
   display_it = 'AEDXP',
   display_ro = 'AEDXP'
WHERE code =4126;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4127,4127) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXQ',
   value_de = 'AEDXQ',
   value_fr = 'AEDXQ',
   value_it = 'AEDXQ',
   value_ro = 'AEDXQ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Polyvinylchlorid',
   description_de = 'Rohrmaterialwechsel: Polyvinylchlorid',
   description_fr = 'Changement du matériau de la canalisation: chlorure de polyvinyle (PVC)',
   description_it = 'Cambio materiale del tubo: polivinilcloruro',
   description_ro = '',
   display_en = 'AEDXQ',
   display_de = 'AEDXQ',
   display_fr = 'AEDXQ',
   display_it = 'AEDXQ',
   display_ro = 'AEDXQ'
WHERE code =4127;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4128,4128) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXR',
   value_de = 'AEDXR',
   value_fr = 'AEDXR',
   value_it = 'AEDXR',
   value_ro = 'AEDXR',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Kunststoff unbekannt',
   description_de = 'Rohrmaterialwechsel: Kunststoff unbekannt',
   description_fr = 'Changement du matériau de la canalisation: plastique inconnu',
   description_it = 'Cambio materiale del tubo: materiale sintetico non identificato',
   description_ro = '',
   display_en = 'AEDXR',
   display_de = 'AEDXR',
   display_fr = 'AEDXR',
   display_it = 'AEDXR',
   display_ro = 'AEDXR'
WHERE code =4128;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4129,4129) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXS',
   value_de = 'AEDXS',
   value_fr = 'AEDXS',
   value_it = 'AEDXS',
   value_ro = 'AEDXS',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Stahl',
   description_de = 'Rohrmaterialwechsel: Stahl',
   description_fr = 'Changement du matériau de la canalisation: acier',
   description_it = 'Cambio materiale del tubo: acciaio',
   description_ro = '',
   display_en = 'AEDXS',
   display_de = 'AEDXS',
   display_fr = 'AEDXS',
   display_it = 'AEDXS',
   display_ro = 'AEDXS'
WHERE code =4129;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4130,4130) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXT',
   value_de = 'AEDXT',
   value_fr = 'AEDXT',
   value_it = 'AEDXT',
   value_ro = 'AEDXT',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Rostfreier Stahl',
   description_de = 'Rohrmaterialwechsel: Rostfreier Stahl',
   description_fr = 'Changement du matériau de la canalisation: acier inoxydable',
   description_it = 'Cambio materiale del tubo: acciaio inossidabile',
   description_ro = '',
   display_en = 'AEDXT',
   display_de = 'AEDXT',
   display_fr = 'AEDXT',
   display_it = 'AEDXT',
   display_ro = 'AEDXT'
WHERE code =4130;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4131,4131) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXU',
   value_de = 'AEDXU',
   value_fr = 'AEDXU',
   value_it = 'AEDXU',
   value_ro = 'AEDXU',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Steinzeug',
   description_de = 'Rohrmaterialwechsel: Steinzeug',
   description_fr = 'Changement du matériau de la canalisation: grès céramique',
   description_it = 'Cambio materiale del tubo: grès',
   description_ro = '',
   display_en = 'AEDXU',
   display_de = 'AEDXU',
   display_fr = 'AEDXU',
   display_it = 'AEDXU',
   display_ro = 'AEDXU'
WHERE code =4131;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4132,4132) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXV',
   value_de = 'AEDXV',
   value_fr = 'AEDXV',
   value_it = 'AEDXV',
   value_ro = 'AEDXV',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Ton',
   description_de = 'Rohrmaterialwechsel: Ton',
   description_fr = 'Changement du matériau de la canalisation: terre cuite',
   description_it = 'Cambio materiale del tubo: argilla',
   description_ro = '',
   display_en = 'AEDXV',
   display_de = 'AEDXV',
   display_fr = 'AEDXV',
   display_it = 'AEDXV',
   display_ro = 'AEDXV'
WHERE code =4132;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4133,4133) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXW',
   value_de = 'AEDXW',
   value_fr = 'AEDXW',
   value_it = 'AEDXW',
   value_ro = 'AEDXW',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: unbekanntes Material',
   description_de = 'Rohrmaterialwechsel: unbekanntes Material',
   description_fr = 'Changement du matériau de la canalisation: matériau inconnu',
   description_it = 'Cambio materiale del tubo: materiale non identificato',
   description_ro = '',
   display_en = 'AEDXW',
   display_de = 'AEDXW',
   display_fr = 'AEDXW',
   display_it = 'AEDXW',
   display_ro = 'AEDXW'
WHERE code =4133;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4134,4134) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEDXX',
   value_de = 'AEDXX',
   value_fr = 'AEDXX',
   value_it = 'AEDXX',
   value_ro = 'AEDXX',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrmaterialwechsel: Zement',
   description_de = 'Rohrmaterialwechsel: Zement',
   description_fr = 'Changement du matériau de la canalisation: ciment',
   description_it = 'Cambio materiale del tubo: cemento',
   description_ro = '',
   display_en = 'AEDXX',
   display_de = 'AEDXX',
   display_fr = 'AEDXX',
   display_it = 'AEDXX',
   display_ro = 'AEDXX'
WHERE code =4134;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4135,4135) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'AEF',
   value_de = 'AEF',
   value_fr = 'AEF',
   value_it = 'AEF',
   value_ro = 'AEF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Neue Baulänge',
   description_de = 'Neue Baulänge',
   description_fr = 'Nouvelle longueur',
   description_it = 'Nuova lunghezza dell’unità del tubo',
   description_ro = '',
   display_en = 'AEF',
   display_de = 'AEF',
   display_fr = 'AEF',
   display_it = 'AEF',
   display_ro = 'AEF'
WHERE code =4135;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3900,3900) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAAA',
   value_de = 'BAAA',
   value_fr = 'BAAA',
   value_it = 'BAAA',
   value_ro = 'BAAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohr vertikal deformiert',
   description_de = 'Rohr vertikal deformiert',
   description_fr = 'Canalisation déformée verticalement',
   description_it = 'Deformazione verticale del tubo',
   description_ro = '',
   display_en = 'BAAA',
   display_de = 'BAAA',
   display_fr = 'BAAA',
   display_it = 'BAAA',
   display_ro = ''
WHERE code =3900;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3901,3901) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAAB',
   value_de = 'BAAB',
   value_fr = 'BAAB',
   value_it = 'BAAB',
   value_ro = 'BAAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohr horizontal deformiert',
   description_de = 'Rohr horizontal deformiert',
   description_fr = 'Canalisation déformée horizontalement',
   description_it = 'Deformazione orizzontale del tubo',
   description_ro = '',
   display_en = 'BAAB',
   display_de = 'BAAB',
   display_fr = 'BAAB',
   display_it = 'BAAB',
   display_ro = ''
WHERE code =3901;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3902,3902) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABAA',
   value_de = 'BABAA',
   value_fr = 'BABAA',
   value_it = 'BABAA',
   value_ro = 'BABAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss) längs',
   description_de = 'Oberflächenriss (Haarriss) längs',
   description_fr = 'Fissure superficielle (micro-fissure) longitudinale',
   description_it = 'Fessura superficiale (fessura capillare), longitudinale',
   description_ro = '',
   display_en = 'BABAA',
   display_de = 'BABAA',
   display_fr = 'BABAA',
   display_it = 'BABAA',
   display_ro = ''
WHERE code =3902;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3903,3903) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABAB',
   value_de = 'BABAB',
   value_fr = 'BABAB',
   value_it = 'BABAB',
   value_ro = 'BABAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss) radial',
   description_de = 'Oberflächenriss (Haarriss) radial',
   description_fr = 'Fissure superficielle (micro-fissure) radiale',
   description_it = 'Fessura superficiale (fessura capillare), radiale',
   description_ro = '',
   display_en = 'BABAB',
   display_de = 'BABAB',
   display_fr = 'BABAB',
   display_it = 'BABAB',
   display_ro = ''
WHERE code =3903;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3904,3904) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABAC',
   value_de = 'BABAC',
   value_fr = 'BABAC',
   value_it = 'BABAC',
   value_ro = 'BABAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss), komplexe Rissbildung',
   description_de = 'Oberflächenriss (Haarriss), komplexe Rissbildung',
   description_fr = 'Fissure superficielle (micro-fissure), formation complexe de fissures',
   description_it = 'Fessura superficiale (fessura capillare), fessurazione complessa',
   description_ro = '',
   display_en = 'BABAC',
   display_de = 'BABAC',
   display_fr = 'BABAC',
   display_it = 'BABAC',
   display_ro = ''
WHERE code =3904;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3905,3905) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABAD',
   value_de = 'BABAD',
   value_fr = 'BABAD',
   value_it = 'BABAD',
   value_ro = 'BABAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss), spiralförmige Rissbildung',
   description_de = 'Oberflächenriss (Haarriss), spiralförmige Rissbildung',
   description_fr = 'Fissure superficielle (micro-fissure), formation hélicoïdale de fissures',
   description_it = 'Fessura superficiale (fessura capillare) fessurazione elicoidale',
   description_ro = '',
   display_en = 'BABAD',
   display_de = 'BABAD',
   display_fr = 'BABAD',
   display_it = 'BABAD',
   display_ro = ''
WHERE code =3905;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8834,8834) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABAE',
   value_de = 'BABAE',
   value_fr = 'BABAE',
   value_it = 'BABAE',
   value_ro = 'BABAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss), sternförmige Rissbildung',
   description_de = 'Oberflächenriss (Haarriss), sternförmige Rissbildung',
   description_fr = 'Fissure superficielle (microfissure), fissuration en étoile',
   description_it = 'Spaccatura, fessurazione a stella',
   description_ro = 'rrr_Oberflächenriss (Haarriss), sternförmige Rissbildung',
   display_en = 'BABAE',
   display_de = 'BABAE',
   display_fr = 'BABAE',
   display_it = 'BABAE',
   display_ro = ''
WHERE code =8834;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3906,3906) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABBA',
   value_de = 'BABBA',
   value_fr = 'BABBA',
   value_it = 'BABBA',
   value_ro = 'BABBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss längs',
   description_de = 'Riss längs',
   description_fr = 'Fissure longitudinale',
   description_it = 'Spaccatura longitudinale',
   description_ro = '',
   display_en = 'BABBA',
   display_de = 'BABBA',
   display_fr = 'BABBA',
   display_it = 'BABBA',
   display_ro = ''
WHERE code =3906;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3907,3907) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABBB',
   value_de = 'BABBB',
   value_fr = 'BABBB',
   value_it = 'BABBB',
   value_ro = 'BABBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss radial',
   description_de = 'Riss radial',
   description_fr = 'Fissure radiale',
   description_it = 'Spaccatura radiale',
   description_ro = '',
   display_en = 'BABBB',
   display_de = 'BABBB',
   display_fr = 'BABBB',
   display_it = 'BABBB',
   display_ro = ''
WHERE code =3907;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3908,3908) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABBC',
   value_de = 'BABBC',
   value_fr = 'BABBC',
   value_it = 'BABBC',
   value_ro = 'BABBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss, komplexe Rissbildung, Scherbenbildung',
   description_de = 'Riss, komplexe Rissbildung, Scherbenbildung',
   description_fr = 'Fissure, formation complexe de fissures',
   description_it = 'Spaccatura, fessurazione complessa, formazione cocci',
   description_ro = '',
   display_en = 'BABBC',
   display_de = 'BABBC',
   display_fr = 'BABBC',
   display_it = 'BABBC',
   display_ro = ''
WHERE code =3908;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3909,3909) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABBD',
   value_de = 'BABBD',
   value_fr = 'BABBD',
   value_it = 'BABBD',
   value_ro = 'BABBD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss, spiralförmige Rissbildung',
   description_de = 'Riss, spiralförmige Rissbildung',
   description_fr = 'Fissure, formation hélicoïdale de fissures',
   description_it = 'Spaccatura, fessurazione elicoidale',
   description_ro = '',
   display_en = 'BABBD',
   display_de = 'BABBD',
   display_fr = 'BABBD',
   display_it = 'BABBD',
   display_ro = ''
WHERE code =3909;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8835,8835) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABBE',
   value_de = 'BABBE',
   value_fr = 'BABBE',
   value_it = 'BABBE',
   value_ro = 'BABBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss, sternförmige Rissbildung',
   description_de = 'Riss, sternförmige Rissbildung',
   description_fr = 'Fissure, fissuration en étoile',
   description_it = 'Spaccatura, fessurazione a stella',
   description_ro = 'rrr_Riss, sternförmige Rissbildung',
   display_en = 'BABBE',
   display_de = 'BABBE',
   display_fr = 'BABBE',
   display_it = 'BABBE',
   display_ro = ''
WHERE code =8835;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3910,3910) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABCA',
   value_de = 'BABCA',
   value_fr = 'BABCA',
   value_it = 'BABCA',
   value_ro = 'BABCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, längs',
   description_de = 'Klaffender Riss, längs',
   description_fr = 'Fissure béante, longitudinale',
   description_it = 'Frattura aperta, longitudinale',
   description_ro = '',
   display_en = 'BABCA',
   display_de = 'BABCA',
   display_fr = 'BABCA',
   display_it = 'BABCA',
   display_ro = ''
WHERE code =3910;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3911,3911) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABCB',
   value_de = 'BABCB',
   value_fr = 'BABCB',
   value_it = 'BABCB',
   value_ro = 'BABCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, radial',
   description_de = 'Klaffender Riss, radial',
   description_fr = 'Fissure béante, radiale',
   description_it = 'Frattura aperta, radiale',
   description_ro = '',
   display_en = 'BABCB',
   display_de = 'BABCB',
   display_fr = 'BABCB',
   display_it = 'BABCB',
   display_ro = ''
WHERE code =3911;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3912,3912) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABCC',
   value_de = 'BABCC',
   value_fr = 'BABCC',
   value_it = 'BABCC',
   value_ro = 'BABCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, komplexe Rissbildung, Scherbenbildung',
   description_de = 'Klaffender Riss, komplexe Rissbildung, Scherbenbildung',
   description_fr = 'Fissure béante, formation complexe de fissures',
   description_it = 'Frattura aperta, fessurazione complessa, formazione cocci',
   description_ro = '',
   display_en = 'BABCC',
   display_de = 'BABCC',
   display_fr = 'BABCC',
   display_it = 'BABCC',
   display_ro = ''
WHERE code =3912;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3913,3913) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABCD',
   value_de = 'BABCD',
   value_fr = 'BABCD',
   value_it = 'BABCD',
   value_ro = 'BABCD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, spiralförmige Rissbildung',
   description_de = 'Klaffender Riss, spiralförmige Rissbildung',
   description_fr = 'Fissure béante, formation hélicoïdale de fissures',
   description_it = 'Frattura aperta, fessurazione elicoidale',
   description_ro = '',
   display_en = 'BABCD',
   display_de = 'BABCD',
   display_fr = 'BABCD',
   display_it = 'BABCD',
   display_ro = ''
WHERE code =3913;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8836,8836) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BABCE',
   value_de = 'BABCE',
   value_fr = 'BABCE',
   value_it = 'BABCE',
   value_ro = 'BABCE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, sternförmige Rissbildung',
   description_de = 'Klaffender Riss, sternförmige Rissbildung',
   description_fr = 'Fissure béante, fissuration en étoile',
   description_it = 'Frattura aperta, fessurazione a stella',
   description_ro = 'rrr_Klaffender Riss, sternförmige Rissbildung',
   display_en = 'BABCE',
   display_de = 'BABCE',
   display_fr = 'BABCE',
   display_it = 'BABCE',
   display_ro = ''
WHERE code =8836;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3914,3914) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BACA',
   value_de = 'BACA',
   value_fr = 'BACA',
   value_it = 'BACA',
   value_ro = 'BACA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_In der Lage verschobene Scherbe',
   description_de = 'In der Lage verschobene Scherbe',
   description_fr = 'Formation d’éclats',
   description_it = 'Rottura con pezzi spostati ma non mancanti',
   description_ro = '',
   display_en = 'BACA',
   display_de = 'BACA',
   display_fr = 'BACA',
   display_it = 'BACA',
   display_ro = ''
WHERE code =3914;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3915,3915) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BACB',
   value_de = 'BACB',
   value_fr = 'BACB',
   value_it = 'BACB',
   value_ro = 'BACB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Scherbe / Wandungsteil (Loch)',
   description_de = 'Fehlende Scherbe / Wandungsteil (Loch)',
   description_fr = 'Éclat / partie de paroi manquants (trou)',
   description_it = 'Mancanza di frammenti o pezzi sulla parete/(foro)',
   description_ro = '',
   display_en = 'BACB',
   display_de = 'BACB',
   display_fr = 'BACB',
   display_it = 'BACB',
   display_ro = ''
WHERE code =3915;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3916,3916) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BACC',
   value_de = 'BACC',
   value_fr = 'BACC',
   value_it = 'BACC',
   value_ro = 'BACC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Leitungsbruch / Einsturz',
   description_de = 'Leitungsbruch / Einsturz',
   description_fr = 'Rupture / effondrement',
   description_it = 'Rottura della condotta/crollo strutturale',
   description_ro = '',
   display_en = 'BACC',
   display_de = 'BACC',
   display_fr = 'BACC',
   display_it = 'BACC',
   display_ro = ''
WHERE code =3916;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3917,3917) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BADA',
   value_de = 'BADA',
   value_fr = 'BADA',
   value_it = 'BADA',
   value_ro = 'BADA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine verschoben',
   description_de = 'Mauerwerk defekt, Mauer- / Backsteine verschoben',
   description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie déplacés',
   description_it = 'Muratura difettosa, mattoni o pezzi di muratura spostati',
   description_ro = '',
   display_en = 'BADA',
   display_de = 'BADA',
   display_fr = 'BADA',
   display_it = 'BADA',
   display_ro = ''
WHERE code =3917;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3918,3918) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BADB',
   value_de = 'BADB',
   value_fr = 'BADB',
   value_it = 'BADB',
   value_ro = 'BADB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine fehlen',
   description_de = 'Mauerwerk defekt, Mauer- / Backsteine fehlen',
   description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie manquants',
   description_it = 'Muratura difettosa, mattoni o pezzi di muratura mancanti',
   description_ro = '',
   display_en = 'BADB',
   display_de = 'BADB',
   display_fr = 'BADB',
   display_it = 'BADB',
   display_ro = ''
WHERE code =3918;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3919,3919) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BADC',
   value_de = 'BADC',
   value_fr = 'BADC',
   value_it = 'BADC',
   value_ro = 'BADC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Sohle abgesackt',
   description_de = 'Mauerwerk defekt, Sohle abgesackt',
   description_fr = 'Maçonnerie défectueuse, radier affaissé',
   description_it = 'Muratura difettosa, cedimento del fondo',
   description_ro = '',
   display_en = 'BADC',
   display_de = 'BADC',
   display_fr = 'BADC',
   display_it = 'BADC',
   display_ro = ''
WHERE code =3919;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3920,3920) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BADD',
   value_de = 'BADD',
   value_fr = 'BADD',
   value_it = 'BADD',
   value_ro = 'BADD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Einsturz',
   description_de = 'Mauerwerk defekt, Einsturz',
   description_fr = 'Maçonnerie défectueuse, effondrement',
   description_it = 'Muratura difettosa, crollo strutturale',
   description_ro = '',
   display_en = 'BADD',
   display_de = 'BADD',
   display_fr = 'BADD',
   display_it = 'BADD',
   display_ro = ''
WHERE code =3920;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3921,3921) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAE',
   value_de = 'BAE',
   value_fr = 'BAE',
   value_it = 'BAE',
   value_ro = 'BAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mörtel aus Mauerwerk fehlt ganz oder teilweise',
   description_de = 'Mörtel aus Mauerwerk fehlt ganz oder teilweise',
   description_fr = 'Tout ou partie du mortier de la maçonnerie est manquant(e)',
   description_it = 'Manca completamente o parzialmente la malta della muratura.',
   description_ro = '',
   display_en = 'BAE',
   display_de = 'BAE',
   display_fr = 'BAE',
   display_it = 'BAE',
   display_ro = ''
WHERE code =3921;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3922,3922) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFAA',
   value_de = 'BAFAA',
   value_fr = 'BAFAA',
   value_it = 'BAFAA',
   value_ro = 'BAFAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rauhe Rohrwandung durch mechanische Beschädigung',
   description_de = 'Rauhe Rohrwandung durch mechanische Beschädigung',
   description_fr = 'Paroi de la canalisation rugueuse par dégradation mécanique',
   description_it = 'Parete del tubo ruvida per danno meccanico',
   description_ro = '',
   display_en = 'BAFAA',
   display_de = 'BAFAA',
   display_fr = 'BAFAA',
   display_it = 'BAFAA',
   display_ro = ''
WHERE code =3922;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3923,3923) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFAB',
   value_de = 'BAFAB',
   value_fr = 'BAFAB',
   value_it = 'BAFAB',
   value_ro = 'BAFAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rauhe Rohrwandung durch chemischen Angriff',
   description_de = 'Rauhe Rohrwandung durch chemischen Angriff',
   description_fr = 'Paroi de la canalisation rugueuse par attaque chimique',
   description_it = 'Parete del tubo ruvida per aggressione chimica',
   description_ro = '',
   display_en = 'BAFAB',
   display_de = 'BAFAB',
   display_fr = 'BAFAB',
   display_it = 'BAFAB',
   display_ro = ''
WHERE code =3923;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3924,3924) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFAC',
   value_de = 'BAFAC',
   value_fr = 'BAFAC',
   value_it = 'BAFAC',
   value_ro = 'BAFAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rauhe Rohrwandung durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Rauhe Rohrwandung durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Parete del tubo ruvida per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFAC',
   display_de = 'BAFAC',
   display_fr = 'BAFAC',
   display_it = 'BAFAC',
   display_ro = ''
WHERE code =3924;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3925,3925) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFAD',
   value_de = 'BAFAD',
   value_fr = 'BAFAD',
   value_it = 'BAFAD',
   value_ro = 'BAFAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rauhe Rohrwandung durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Rauhe Rohrwandung durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Parete del tubo ruvida per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFAD',
   display_de = 'BAFAD',
   display_fr = 'BAFAD',
   display_it = 'BAFAD',
   display_ro = ''
WHERE code =3925;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3926,3926) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFAE',
   value_de = 'BAFAE',
   value_fr = 'BAFAE',
   value_it = 'BAFAE',
   value_ro = 'BAFAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rauhe Rohrwandung, Ursache nicht eindeutig feststellbar',
   description_de = 'Rauhe Rohrwandung, Ursache nicht eindeutig feststellbar',
   description_fr = 'Paroi de la canalisation rugueuse, cause pas clairement identifiable',
   description_it = 'Parete del tubo ruvida per cause non evidenti',
   description_ro = '',
   display_en = 'BAFAE',
   display_de = 'BAFAE',
   display_fr = 'BAFAE',
   display_it = 'BAFAE',
   display_ro = ''
WHERE code =3926;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8837,8837) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFAZ',
   value_de = 'BAFAZ',
   value_fr = 'BAFAZ',
   value_it = 'BAFAZ',
   value_ro = 'BAFAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rauhe Rohrwandung, andere Ursache',
   description_de = 'Rauhe Rohrwandung, andere Ursache',
   description_fr = 'Paroi de la canalisation rugueuse, autre cause',
   description_it = 'Parete del tubo ruvida per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = 'rrr_Rauhe Rohrwandung, andere Ursache',
   display_en = 'BAFAZ',
   display_de = 'BAFAZ',
   display_fr = 'BAFAZ',
   display_it = 'BAFAZ',
   display_ro = ''
WHERE code =8837;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3927,3927) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFBA',
   value_de = 'BAFBA',
   value_fr = 'BAFBA',
   value_it = 'BAFBA',
   value_ro = 'BAFBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abplatzung durch mechanische Beschädigung',
   description_de = 'Abplatzung durch mechanische Beschädigung',
   description_fr = 'Écaillage par dégradation mécanique',
   description_it = 'Sfaldamento per danno meccanico (anche il giunto del tubo si è rotto)',
   description_ro = '',
   display_en = 'BAFBA',
   display_de = 'BAFBA',
   display_fr = 'BAFBA',
   display_it = 'BAFBA',
   display_ro = ''
WHERE code =3927;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3928,3928) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFBE',
   value_de = 'BAFBE',
   value_fr = 'BAFBE',
   value_it = 'BAFBE',
   value_ro = 'BAFBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abplatzung, Ursache nicht eindeutig feststellbar',
   description_de = 'Abplatzung, Ursache nicht eindeutig feststellbar',
   description_fr = 'Écaillage, cause pas clairement identifiable',
   description_it = 'Sfaldamento per cause non evidenti',
   description_ro = '',
   display_en = 'BAFBE',
   display_de = 'BAFBE',
   display_fr = 'BAFBE',
   display_it = 'BAFBE',
   display_ro = ''
WHERE code =3928;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8838,8838) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFBZ',
   value_de = 'BAFBZ',
   value_fr = 'BAFBZ',
   value_it = 'BAFBZ',
   value_ro = 'BAFBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abplatzung, andere Ursache',
   description_de = 'Abplatzung, andere Ursache',
   description_fr = 'Écaillage, autre cause ',
   description_it = 'Sfaldamento per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Abplatzung, andere Ursache',
   display_en = 'BAFBZ',
   display_de = 'BAFBZ',
   display_fr = 'BAFBZ',
   display_it = 'BAFBZ',
   display_ro = ''
WHERE code =8838;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3929,3929) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFCA',
   value_de = 'BAFCA',
   value_fr = 'BAFCA',
   value_it = 'BAFCA',
   value_ro = 'BAFCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch mechanische Beschädigung',
   description_de = 'Zuschlagstoffe sichtbar durch mechanische Beschädigung',
   description_fr = 'Agrégats visibles par dégradation mécanique',
   description_it = 'Materiale inerte visibile per danno meccanico',
   description_ro = '',
   display_en = 'BAFCA',
   display_de = 'BAFCA',
   display_fr = 'BAFCA',
   display_it = 'BAFCA',
   display_ro = ''
WHERE code =3929;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3930,3930) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFCB',
   value_de = 'BAFCB',
   value_fr = 'BAFCB',
   value_it = 'BAFCB',
   value_ro = 'BAFCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff',
   description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff',
   description_fr = 'Agrégats visibles par attaque chimique',
   description_it = 'Materiale inerte visibile per aggressione chimica',
   description_ro = '',
   display_en = 'BAFCB',
   display_de = 'BAFCB',
   display_fr = 'BAFCB',
   display_it = 'BAFCB',
   display_ro = ''
WHERE code =3930;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3931,3931) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFCC',
   value_de = 'BAFCC',
   value_fr = 'BAFCC',
   value_it = 'BAFCC',
   value_ro = 'BAFCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Agrégats visibles par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Materiale inerte visibile per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFCC',
   display_de = 'BAFCC',
   display_fr = 'BAFCC',
   display_it = 'BAFCC',
   display_ro = ''
WHERE code =3931;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3932,3932) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFCD',
   value_de = 'BAFCD',
   value_fr = 'BAFCD',
   value_it = 'BAFCD',
   value_ro = 'BAFCD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Agrégats visibles par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Materiale inerte visibile per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFCD',
   display_de = 'BAFCD',
   display_fr = 'BAFCD',
   display_it = 'BAFCD',
   display_ro = ''
WHERE code =3932;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3933,3933) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFCE',
   value_de = 'BAFCE',
   value_fr = 'BAFCE',
   value_it = 'BAFCE',
   value_ro = 'BAFCE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar, Ursache nicht eindeutig feststellbar',
   description_de = 'Zuschlagstoffe sichtbar, Ursache nicht eindeutig feststellbar',
   description_fr = 'Agrégats visibles, cause pas clairement identifiable',
   description_it = 'Materiale inerte visibile per cause non evidenti',
   description_ro = '',
   display_en = 'BAFCE',
   display_de = 'BAFCE',
   display_fr = 'BAFCE',
   display_it = 'BAFCE',
   display_ro = ''
WHERE code =3933;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8839,8839) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFCZ',
   value_de = 'BAFCZ',
   value_fr = 'BAFCZ',
   value_it = 'BAFCZ',
   value_ro = 'BAFCZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar, andere Ursache',
   description_de = 'Zuschlagstoffe sichtbar, andere Ursache',
   description_fr = 'Agrégats visibles, autre cause ',
   description_it = 'Materiale inerte visibile per altre cause (ulteriori dettagli richiesti nelle osser- vazioni)',
   description_ro = 'rrr_Zuschlagstoffe sichtbar, andere Ursache',
   display_en = 'BAFCZ',
   display_de = 'BAFCZ',
   display_fr = 'BAFCZ',
   display_it = 'BAFCZ',
   display_ro = ''
WHERE code =8839;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3934,3934) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFDA',
   value_de = 'BAFDA',
   value_fr = 'BAFDA',
   value_it = 'BAFDA',
   value_ro = 'BAFDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch mechanische Beschädigung',
   description_de = 'Zuschlagstoffe einragend durch mechanische Beschädigung',
   description_fr = 'Agrégats intrusifs en raison de dommages mécaniques',
   description_it = 'Materiale inerte sporgente per danno meccanico',
   description_ro = '',
   display_en = 'BAFDA',
   display_de = 'BAFDA',
   display_fr = 'BAFDA',
   display_it = 'BAFDA',
   display_ro = ''
WHERE code =3934;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3935,3935) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFDB',
   value_de = 'BAFDB',
   value_fr = 'BAFDB',
   value_it = 'BAFDB',
   value_ro = 'BAFDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff',
   description_de = 'Zuschlagstoffe einragend durch chemischen Angriff',
   description_fr = 'Agrégats intrusifs par attaque chimique',
   description_it = 'Materiale inerte sporgente per aggressione chimica',
   description_ro = '',
   display_en = 'BAFDB',
   display_de = 'BAFDB',
   display_fr = 'BAFDB',
   display_it = 'BAFDB',
   display_ro = ''
WHERE code =3935;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3936,3936) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFDC',
   value_de = 'BAFDC',
   value_fr = 'BAFDC',
   value_it = 'BAFDC',
   value_ro = 'BAFDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Agrégats intrusifs par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Materiale inerte sporgente per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFDC',
   display_de = 'BAFDC',
   display_fr = 'BAFDC',
   display_it = 'BAFDC',
   display_ro = ''
WHERE code =3936;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3937,3937) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFDD',
   value_de = 'BAFDD',
   value_fr = 'BAFDD',
   value_it = 'BAFDD',
   value_ro = 'BAFDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Agrégats intrusifs par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Materiale inerte sporgente per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFDD',
   display_de = 'BAFDD',
   display_fr = 'BAFDD',
   display_it = 'BAFDD',
   display_ro = ''
WHERE code =3937;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3938,3938) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFDE',
   value_de = 'BAFDE',
   value_fr = 'BAFDE',
   value_it = 'BAFDE',
   value_ro = 'BAFDE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend, Ursache nicht eindeutig feststellbar',
   description_de = 'Zuschlagstoffe einragend, Ursache nicht eindeutig feststellbar',
   description_fr = 'Agrégats intrusifs, cause pas clairement identifiable',
   description_it = 'Materiale inerte sporgente per cause non evidenti',
   description_ro = '',
   display_en = 'BAFDE',
   display_de = 'BAFDE',
   display_fr = 'BAFDE',
   display_it = 'BAFDE',
   display_ro = ''
WHERE code =3938;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8840,8840) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFDZ',
   value_de = 'BAFDZ',
   value_fr = 'BAFDZ',
   value_it = 'BAFDZ',
   value_ro = 'BAFDZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend, andere Ursache',
   description_de = 'Zuschlagstoffe einragend, andere Ursache',
   description_fr = 'Agrégats intrusifs, autre cause',
   description_it = 'Materiale inerte sporgente per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Zuschlagstoffe einragend, andere Ursache',
   display_en = 'BAFDZ',
   display_de = 'BAFDZ',
   display_fr = 'BAFDZ',
   display_it = 'BAFDZ',
   display_ro = ''
WHERE code =8840;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3939,3939) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFEA',
   value_de = 'BAFEA',
   value_fr = 'BAFEA',
   value_it = 'BAFEA',
   value_ro = 'BAFEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch mechanische Beschädigung',
   description_de = 'Zuschlagstoffe fehlen durch mechanische Beschädigung',
   description_fr = 'Agrégats  manquants par dégradation mécanique',
   description_it = 'Materiale mancante per danno meccanico',
   description_ro = '',
   display_en = 'BAFEA',
   display_de = 'BAFEA',
   display_fr = 'BAFEA',
   display_it = 'BAFEA',
   display_ro = ''
WHERE code =3939;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3940,3940) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFEB',
   value_de = 'BAFEB',
   value_fr = 'BAFEB',
   value_it = 'BAFEB',
   value_ro = 'BAFEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff',
   description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff',
   description_fr = 'Agrégats  manquants par attaque chimique',
   description_it = 'Materiale mancante per aggressione chimica',
   description_ro = '',
   display_en = 'BAFEB',
   display_de = 'BAFEB',
   display_fr = 'BAFEB',
   display_it = 'BAFEB',
   display_ro = ''
WHERE code =3940;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3941,3941) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFEC',
   value_de = 'BAFEC',
   value_fr = 'BAFEC',
   value_it = 'BAFEC',
   value_ro = 'BAFEC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Agrégats manquants par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Materiale mancante per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFEC',
   display_de = 'BAFEC',
   display_fr = 'BAFEC',
   display_it = 'BAFEC',
   display_ro = ''
WHERE code =3941;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3942,3942) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFED',
   value_de = 'BAFED',
   value_fr = 'BAFED',
   value_it = 'BAFED',
   value_ro = 'BAFED',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Agrégats manquants par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Materiale mancante per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFED',
   display_de = 'BAFED',
   display_fr = 'BAFED',
   display_it = 'BAFED',
   display_ro = ''
WHERE code =3942;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3943,3943) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFEE',
   value_de = 'BAFEE',
   value_fr = 'BAFEE',
   value_it = 'BAFEE',
   value_ro = 'BAFEE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen, Ursache nicht eindeutig feststellbar',
   description_de = 'Zuschlagstoffe fehlen, Ursache nicht eindeutig feststellbar',
   description_fr = 'Agrégats manquants, cause pas clairement identifiable',
   description_it = 'Materiale mancante per cause non evidenti',
   description_ro = '',
   display_en = 'BAFEE',
   display_de = 'BAFEE',
   display_fr = 'BAFEE',
   display_it = 'BAFEE',
   display_ro = ''
WHERE code =3943;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8841,8841) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFEZ',
   value_de = 'BAFEZ',
   value_fr = 'BAFEZ',
   value_it = 'BAFEZ',
   value_ro = 'BAFEZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen, andere Ursache',
   description_de = 'Zuschlagstoffe fehlen, andere Ursache',
   description_fr = 'Agrégats manquants, autre cause ',
   description_it = 'Materiale inerte mancante per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Zuschlagstoffe fehlen, andere Ursache',
   display_en = 'BAFEZ',
   display_de = 'BAFEZ',
   display_fr = 'BAFEZ',
   display_it = 'BAFEZ',
   display_ro = ''
WHERE code =8841;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3944,3944) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFFA',
   value_de = 'BAFFA',
   value_fr = 'BAFFA',
   value_it = 'BAFFA',
   value_ro = 'BAFFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch mechanische Beschädigung',
   description_de = 'Bewehrung sichtbar durch mechanische Beschädigung',
   description_fr = 'Armature visible par dégradation mécanique',
   description_it = 'Armatura visibile per danno meccanico',
   description_ro = '',
   display_en = 'BAFFA',
   display_de = 'BAFFA',
   display_fr = 'BAFFA',
   display_it = 'BAFFA',
   display_ro = ''
WHERE code =3944;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3945,3945) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFFB',
   value_de = 'BAFFB',
   value_fr = 'BAFFB',
   value_it = 'BAFFB',
   value_ro = 'BAFFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff',
   description_de = 'Bewehrung sichtbar durch chemischen Angriff',
   description_fr = 'Armature visible par attaque chimique',
   description_it = 'Armatura visibile per aggressione chimica',
   description_ro = '',
   display_en = 'BAFFB',
   display_de = 'BAFFB',
   display_fr = 'BAFFB',
   display_it = 'BAFFB',
   display_ro = ''
WHERE code =3945;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3946,3946) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFFC',
   value_de = 'BAFFC',
   value_fr = 'BAFFC',
   value_it = 'BAFFC',
   value_ro = 'BAFFC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Armature visible par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Armatura visibile per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFFC',
   display_de = 'BAFFC',
   display_fr = 'BAFFC',
   display_it = 'BAFFC',
   display_ro = ''
WHERE code =3946;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3947,3947) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFFD',
   value_de = 'BAFFD',
   value_fr = 'BAFFD',
   value_it = 'BAFFD',
   value_ro = 'BAFFD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Armature visible par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Armatura visibile per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFFD',
   display_de = 'BAFFD',
   display_fr = 'BAFFD',
   display_it = 'BAFFD',
   display_ro = ''
WHERE code =3947;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3948,3948) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFFE',
   value_de = 'BAFFE',
   value_fr = 'BAFFE',
   value_it = 'BAFFE',
   value_ro = 'BAFFE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar, Ursache nicht eindeutig feststellbar',
   description_de = 'Bewehrung sichtbar, Ursache nicht eindeutig feststellbar',
   description_fr = 'Armature visible, cause pas clairement identifiable',
   description_it = 'Armatura visibile per cause non evidenti',
   description_ro = '',
   display_en = 'BAFFE',
   display_de = 'BAFFE',
   display_fr = 'BAFFE',
   display_it = 'BAFFE',
   display_ro = ''
WHERE code =3948;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8842,8842) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFFZ',
   value_de = 'BAFFZ',
   value_fr = 'BAFFZ',
   value_it = 'BAFFZ',
   value_ro = 'BAFFZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar, andere Ursache',
   description_de = 'Bewehrung sichtbar, andere Ursache',
   description_fr = 'Armature visible, autre cause ',
   description_it = 'Armatura visibile per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = 'rrr_Bewehrung sichtbar, andere Ursache',
   display_en = 'BAFFZ',
   display_de = 'BAFFZ',
   display_fr = 'BAFFZ',
   display_it = 'BAFFZ',
   display_ro = ''
WHERE code =8842;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3949,3949) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFGA',
   value_de = 'BAFGA',
   value_fr = 'BAFGA',
   value_it = 'BAFGA',
   value_ro = 'BAFGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch mechanische Beschädigung',
   description_de = 'Bewehrung einragend durch mechanische Beschädigung',
   description_fr = 'Armature dépassant de la surface par dégradation mécanique',
   description_it = 'Armatura sporgente per danno meccanico',
   description_ro = '',
   display_en = 'BAFGA',
   display_de = 'BAFGA',
   display_fr = 'BAFGA',
   display_it = 'BAFGA',
   display_ro = ''
WHERE code =3949;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3950,3950) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFGB',
   value_de = 'BAFGB',
   value_fr = 'BAFGB',
   value_it = 'BAFGB',
   value_ro = 'BAFGB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch chemischen Angriff',
   description_de = 'Bewehrung einragend durch chemischen Angriff',
   description_fr = 'Armature dépassant de la surface par attaque chimique',
   description_it = 'Armatura sporgente per aggressione chimica',
   description_ro = '',
   display_en = 'BAFGB',
   display_de = 'BAFGB',
   display_fr = 'BAFGB',
   display_it = 'BAFGB',
   display_ro = ''
WHERE code =3950;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3951,3951) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFGC',
   value_de = 'BAFGC',
   value_fr = 'BAFGC',
   value_it = 'BAFGC',
   value_ro = 'BAFGC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Bewehrung einragend durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Armatura sporgente per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFGC',
   display_de = 'BAFGC',
   display_fr = 'BAFGC',
   display_it = 'BAFGC',
   display_ro = ''
WHERE code =3951;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3952,3952) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFGD',
   value_de = 'BAFGD',
   value_fr = 'BAFGD',
   value_it = 'BAFGD',
   value_ro = 'BAFGD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Bewehrung einragend durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Armatura sporgente per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFGD',
   display_de = 'BAFGD',
   display_fr = 'BAFGD',
   display_it = 'BAFGD',
   display_ro = ''
WHERE code =3952;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3953,3953) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFGE',
   value_de = 'BAFGE',
   value_fr = 'BAFGE',
   value_it = 'BAFGE',
   value_ro = 'BAFGE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend, Ursache nicht eindeutig feststellbar',
   description_de = 'Bewehrung einragend, Ursache nicht eindeutig feststellbar',
   description_fr = 'Armature dépassant de la surface, cause pas clairement identifiable',
   description_it = 'Armatura sporgente per cause non evidenti',
   description_ro = '',
   display_en = 'BAFGE',
   display_de = 'BAFGE',
   display_fr = 'BAFGE',
   display_it = 'BAFGE',
   display_ro = ''
WHERE code =3953;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8843,8843) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFGZ',
   value_de = 'BAFGZ',
   value_fr = 'BAFGZ',
   value_it = 'BAFGZ',
   value_ro = 'BAFGZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend, andere Ursache',
   description_de = 'Bewehrung einragend, andere Ursache',
   description_fr = 'Armature dépassant de la surface, autre cause ',
   description_it = 'Armatura sporgente per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = 'rrr_Bewehrung einragend, andere Ursache',
   display_en = 'BAFGZ',
   display_de = 'BAFGZ',
   display_fr = 'BAFGZ',
   display_it = 'BAFGZ',
   display_ro = ''
WHERE code =8843;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3954,3954) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFHB',
   value_de = 'BAFHB',
   value_fr = 'BAFHB',
   value_it = 'BAFHB',
   value_ro = 'BAFHB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff',
   description_de = 'Bewehrung korrodiert durch chemischen Angriff',
   description_fr = 'Armature corrodée par attaque chimique',
   description_it = 'Armatura corrosa per aggressione chimica',
   description_ro = '',
   display_en = 'BAFHB',
   display_de = 'BAFHB',
   display_fr = 'BAFHB',
   display_it = 'BAFHB',
   display_ro = ''
WHERE code =3954;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3955,3955) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFHC',
   value_de = 'BAFHC',
   value_fr = 'BAFHC',
   value_it = 'BAFHC',
   value_ro = 'BAFHC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Armature corrodée par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Armatura corrosa per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFHC',
   display_de = 'BAFHC',
   display_fr = 'BAFHC',
   display_it = 'BAFHC',
   display_ro = ''
WHERE code =3955;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3956,3956) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFHD',
   value_de = 'BAFHD',
   value_fr = 'BAFHD',
   value_it = 'BAFHD',
   value_ro = 'BAFHD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Armature corrodée par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Armatura corrosa per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFHD',
   display_de = 'BAFHD',
   display_fr = 'BAFHD',
   display_it = 'BAFHD',
   display_ro = ''
WHERE code =3956;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3957,3957) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFHE',
   value_de = 'BAFHE',
   value_fr = 'BAFHE',
   value_it = 'BAFHE',
   value_ro = 'BAFHE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert, Ursache nicht eindeutig feststellbar',
   description_de = 'Bewehrung korrodiert, Ursache nicht eindeutig feststellbar',
   description_fr = 'Armature corrodée, cause pas clairement identifiable',
   description_it = 'Armatura corrosa per cause non evidenti',
   description_ro = '',
   display_en = 'BAFHE',
   display_de = 'BAFHE',
   display_fr = 'BAFHE',
   display_it = 'BAFHE',
   display_ro = ''
WHERE code =3957;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3958,3958) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFIA',
   value_de = 'BAFIA',
   value_fr = 'BAFIA',
   value_it = 'BAFIA',
   value_ro = 'BAFIA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Rohrwandung durch mechanische Beschädigung',
   description_de = 'Fehlende Rohrwandung durch mechanische Beschädigung',
   description_fr = 'Paroi manquante par dégradation mécanique',
   description_it = 'Parete mancante per danno meccanico',
   description_ro = '',
   display_en = 'BAFIA',
   display_de = 'BAFIA',
   display_fr = 'BAFIA',
   display_it = 'BAFIA',
   display_ro = ''
WHERE code =3958;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3959,3959) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFIB',
   value_de = 'BAFIB',
   value_fr = 'BAFIB',
   value_it = 'BAFIB',
   value_ro = 'BAFIB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Rohrwandung durch chemischen Angriff',
   description_de = 'Fehlende Rohrwandung durch chemischen Angriff',
   description_fr = 'Paroi manquante par attaque chimique',
   description_it = 'Parete mancante per aggressione chimica',
   description_ro = '',
   display_en = 'BAFIB',
   display_de = 'BAFIB',
   display_fr = 'BAFIB',
   display_it = 'BAFIB',
   display_ro = ''
WHERE code =3959;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3960,3960) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFIC',
   value_de = 'BAFIC',
   value_fr = 'BAFIC',
   value_it = 'BAFIC',
   value_ro = 'BAFIC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Rohrwandung durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Fehlende Rohrwandung durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Paroi manquante par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Parete mancante per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFIC',
   display_de = 'BAFIC',
   display_fr = 'BAFIC',
   display_it = 'BAFIC',
   display_ro = ''
WHERE code =3960;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3961,3961) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFID',
   value_de = 'BAFID',
   value_fr = 'BAFID',
   value_it = 'BAFID',
   value_ro = 'BAFID',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Rohrwandung durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Fehlende Rohrwandung durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Paroi manquante par attaquechimique sur la partie inférieure du tuyau',
   description_it = 'Parete mancante per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFID',
   display_de = 'BAFID',
   display_fr = 'BAFID',
   display_it = 'BAFID',
   display_ro = ''
WHERE code =3961;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3962,3962) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFIE',
   value_de = 'BAFIE',
   value_fr = 'BAFIE',
   value_it = 'BAFIE',
   value_ro = 'BAFIE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Rohrwandung, Ursache nicht eindeutig feststellbar',
   description_de = 'Fehlende Rohrwandung, Ursache nicht eindeutig feststellbar',
   description_fr = 'Paroi manquante, cause pas clairement identifiable',
   description_it = 'Parete mancante per cause non evidenti',
   description_ro = '',
   display_en = 'BAFIE',
   display_de = 'BAFIE',
   display_fr = 'BAFIE',
   display_it = 'BAFIE',
   display_ro = ''
WHERE code =3962;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8844,8844) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFIZ',
   value_de = 'BAFIZ',
   value_fr = 'BAFIZ',
   value_it = 'BAFIZ',
   value_ro = 'BAFIZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Rohrwandung, andere Ursache',
   description_de = 'Fehlende Rohrwandung, andere Ursache',
   description_fr = 'Paroi manquante, autre cause ',
   description_it = 'Parete mancante per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = 'rrr_Fehlende Rohrwandung, andere Ursache',
   display_en = 'BAFIZ',
   display_de = 'BAFIZ',
   display_fr = 'BAFIZ',
   display_it = 'BAFIZ',
   display_ro = ''
WHERE code =8844;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3963,3963) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFJB',
   value_de = 'BAFJB',
   value_fr = 'BAFJB',
   value_it = 'BAFJB',
   value_ro = 'BAFJB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrwand korrodiert durch chemischen Angriff',
   description_de = 'Rohrwand korrodiert durch chemischen Angriff',
   description_fr = 'Paroi corrodée par attaque chimique',
   description_it = 'Parete corrosa per aggressione chimica',
   description_ro = '',
   display_en = 'BAFJB',
   display_de = 'BAFJB',
   display_fr = 'BAFJB',
   display_it = 'BAFJB',
   display_ro = ''
WHERE code =3963;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3964,3964) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFJC',
   value_de = 'BAFJC',
   value_fr = 'BAFJC',
   value_it = 'BAFJC',
   value_ro = 'BAFJC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrwand korrodiert durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Rohrwand korrodiert durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Paroi corrodée par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Parete corrosa per aggressione chimica nella parte superiore del tubo',
   description_ro = '',
   display_en = 'BAFJC',
   display_de = 'BAFJC',
   display_fr = 'BAFJC',
   display_it = 'BAFJC',
   display_ro = ''
WHERE code =3964;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3965,3965) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFJD',
   value_de = 'BAFJD',
   value_fr = 'BAFJD',
   value_it = 'BAFJD',
   value_ro = 'BAFJD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrwand korrodiert durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'Rohrwand korrodiert durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Paroi corrodée par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Parete corrosa per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'BAFJD',
   display_de = 'BAFJD',
   display_fr = 'BAFJD',
   display_it = 'BAFJD',
   display_ro = ''
WHERE code =3965;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3966,3966) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFJE',
   value_de = 'BAFJE',
   value_fr = 'BAFJE',
   value_it = 'BAFJE',
   value_ro = 'BAFJE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrwand korrodiert, Ursache nicht eindeutig feststellbar',
   description_de = 'Rohrwand korrodiert, Ursache nicht eindeutig feststellbar',
   description_fr = 'Paroi corrodée, cause pas clairement identifiable',
   description_it = 'Parete corrosa per cause non evidenti',
   description_ro = '',
   display_en = 'BAFJE',
   display_de = 'BAFJE',
   display_fr = 'BAFJE',
   display_it = 'BAFJE',
   display_ro = ''
WHERE code =3966;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8845,8845) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFJZ',
   value_de = 'BAFJZ',
   value_fr = 'BAFJZ',
   value_it = 'BAFJZ',
   value_ro = 'BAFJZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrwand korrodiert, andere Ursache',
   description_de = 'Rohrwand korrodiert, andere Ursache',
   description_fr = 'Paroi corrodée, autre cause',
   description_it = 'Parete corrosa per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Rohrwand korrodiert, andere Ursache',
   display_en = 'BAFJZ',
   display_de = 'BAFJZ',
   display_fr = 'BAFJZ',
   display_it = 'BAFJZ',
   display_ro = ''
WHERE code =8845;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8846,8846) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFKA',
   value_de = 'BAFKA',
   value_fr = 'BAFKA',
   value_it = 'BAFKA',
   value_ro = 'BAFKA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule durch mechanische Beschädigung',
   description_de = 'Beule durch mechanische Beschädigung',
   description_fr = 'Bosse par dégradation mécanique',
   description_it = 'Protuberanza per danno meccanico',
   description_ro = 'rrr_Beule durch mechanische Beschädigung',
   display_en = 'BAFKA',
   display_de = 'BAFKA',
   display_fr = 'BAFKA',
   display_it = 'BAFKA',
   display_ro = ''
WHERE code =8846;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8847,8847) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFKE',
   value_de = 'BAFKE',
   value_fr = 'BAFKE',
   value_it = 'BAFKE',
   value_ro = 'BAFKE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule, Ursache nicht eindeutig feststellbar',
   description_de = 'Beule, Ursache nicht eindeutig feststellbar',
   description_fr = 'Bosse, cause pas clairement identifiable',
   description_it = 'Protuberanza per cause non evidenti',
   description_ro = 'rrr_Beule, Ursache nicht eindeutig feststellbar',
   display_en = 'BAFKE',
   display_de = 'BAFKE',
   display_fr = 'BAFKE',
   display_it = 'BAFKE',
   display_ro = ''
WHERE code =8847;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8848,8848) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFKZ',
   value_de = 'BAFKZ',
   value_fr = 'BAFKZ',
   value_it = 'BAFKZ',
   value_ro = 'BAFKZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule, andere Ursache',
   description_de = 'Beule, andere Ursache',
   description_fr = 'Boss, autre cause ',
   description_it = 'Protuberanza per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Beule, andere Ursache',
   display_en = 'BAFKZ',
   display_de = 'BAFKZ',
   display_fr = 'BAFKZ',
   display_it = 'BAFKZ',
   display_ro = ''
WHERE code =8848;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3967,3967) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFZA',
   value_de = 'BAFZA',
   value_fr = 'BAFZA',
   value_it = 'BAFZA',
   value_ro = 'BAFZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Oberflächenschaden durch mechanische Beschädigung',
   description_de = 'Andersartiger Oberflächenschaden durch mechanische Beschädigung',
   description_fr = 'Dégradation de surface par dégradation mécanique',
   description_it = 'Altri danni superficiali per danno meccanico (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BAFZA',
   display_de = 'BAFZA',
   display_fr = 'BAFZA',
   display_it = 'BAFZA',
   display_ro = ''
WHERE code =3967;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3968,3968) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFZB',
   value_de = 'BAFZB',
   value_fr = 'BAFZB',
   value_it = 'BAFZB',
   value_ro = 'BAFZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Oberflächenschaden durch chemischen Angriff',
   description_de = 'Andersartiger Oberflächenschaden durch chemischen Angriff',
   description_fr = 'Dégradation de surface par attaque chimique',
   description_it = 'Altri danni superficiali per aggressione chimica (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BAFZB',
   display_de = 'BAFZB',
   display_fr = 'BAFZB',
   display_it = 'BAFZB',
   display_ro = ''
WHERE code =3968;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3969,3969) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFZC',
   value_de = 'BAFZC',
   value_fr = 'BAFZC',
   value_it = 'BAFZC',
   value_ro = 'BAFZC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Oberflächenschaden durch chemischen Angriff im oberen Teil des Rohres',
   description_de = 'Andersartiger Oberflächenschaden durch chemischen Angriff im oberen Teil des Rohres',
   description_fr = 'Dégradation de surface par attaque chimique sur la partie supérieure du tuyau ',
   description_it = 'Altri danni superficiali per aggressione chimica nella parte superiore del tubo (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BAFZC',
   display_de = 'BAFZC',
   display_fr = 'BAFZC',
   display_it = 'BAFZC',
   display_ro = ''
WHERE code =3969;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3970,3970) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFZD',
   value_de = 'BAFZD',
   value_fr = 'BAFZD',
   value_it = 'BAFZD',
   value_ro = 'BAFZD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_AndersartigerOberflächenschaden durch chemischen Angriff im unteren Teil des Rohres',
   description_de = 'AndersartigerOberflächenschaden durch chemischen Angriff im unteren Teil des Rohres',
   description_fr = 'Dégradation de surface par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Altri danni superficiali per aggressione chimica nella parte inferiore del tubo (ulteriori dettagli sono richiesti nell’osservazione))',
   description_ro = '',
   display_en = 'BAFZD',
   display_de = 'BAFZD',
   display_fr = 'BAFZD',
   display_it = 'BAFZD',
   display_ro = ''
WHERE code =3970;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3971,3971) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFZE',
   value_de = 'BAFZE',
   value_fr = 'BAFZE',
   value_it = 'BAFZE',
   value_ro = 'BAFZE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Oberflächenschaden, Ursache nicht eindeutig feststellbar',
   description_de = 'Andersartiger Oberflächenschaden, Ursache nicht eindeutig feststellbar',
   description_fr = 'Dégradation de surface, cause pas clairement identifiable ',
   description_it = 'Altri danni superficiali per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BAFZE',
   display_de = 'BAFZE',
   display_fr = 'BAFZE',
   display_it = 'BAFZE',
   display_ro = ''
WHERE code =3971;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8849,8849) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAFZZ',
   value_de = 'BAFZZ',
   value_fr = 'BAFZZ',
   value_it = 'BAFZZ',
   value_ro = 'BAFZZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Oberflächenschaden, andere Ursache',
   description_de = 'Andersartiger Oberflächenschaden, andere Ursache',
   description_fr = 'Dégradation de surface, autre cause ',
   description_it = 'Altri danni superficiali per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = 'rrr_Andersartiger Oberflächenschaden, andere Ursache',
   display_en = 'BAFZZ',
   display_de = 'BAFZZ',
   display_fr = 'BAFZZ',
   display_it = 'BAFZZ',
   display_ro = ''
WHERE code =8849;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3972,3972) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAGA',
   value_de = 'BAGA',
   value_fr = 'BAGA',
   value_it = 'BAGA',
   value_ro = 'BAGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss einragend',
   description_de = 'Anschluss einragend',
   description_fr = 'Branchement pénétrant',
   description_it = 'Allacciamento sporgente',
   description_ro = '',
   display_en = 'BAGA',
   display_de = 'BAGA',
   display_fr = 'BAGA',
   display_it = 'BAGA',
   display_ro = ''
WHERE code =3972;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3973,3973) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAHA',
   value_de = 'BAHA',
   value_fr = 'BAHA',
   value_it = 'BAHA',
   value_ro = 'BAHA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss falsch eingeführt',
   description_de = 'Anschluss falsch eingeführt',
   description_fr = 'Raccordement à position incorrecte',
   description_it = 'Allacciamento raccordato in modo errato',
   description_ro = '',
   display_en = 'BAHA',
   display_de = 'BAHA',
   display_fr = 'BAHA',
   display_it = 'BAHA',
   display_ro = ''
WHERE code =3973;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3974,3974) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAHB',
   value_de = 'BAHB',
   value_fr = 'BAHB',
   value_it = 'BAHB',
   value_ro = 'BAHB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss zurückliegend',
   description_de = 'Anschluss zurückliegend',
   description_fr = 'Raccordement en retrait',
   description_it = 'Allacciamento non raccordato a filo della parte del pozzetto',
   description_ro = '',
   display_en = 'BAHB',
   display_de = 'BAHB',
   display_fr = 'BAHB',
   display_it = 'BAHB',
   display_ro = ''
WHERE code =3974;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3975,3975) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAHC',
   value_de = 'BAHC',
   value_fr = 'BAHC',
   value_it = 'BAHC',
   value_ro = 'BAHC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss unvollständig oder nicht eingebunden',
   description_de = 'Anschluss unvollständig oder nicht eingebunden',
   description_fr = 'Raccordement incomplet',
   description_it = 'Allacciamento non raccordato a tenuta stagna o solo parzialmente',
   description_ro = '',
   display_en = 'BAHC',
   display_de = 'BAHC',
   display_fr = 'BAHC',
   display_it = 'BAHC',
   display_ro = ''
WHERE code =3975;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3976,3976) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAHD',
   value_de = 'BAHD',
   value_fr = 'BAHD',
   value_it = 'BAHD',
   value_ro = 'BAHD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss beschädigt',
   description_de = 'Anschluss beschädigt',
   description_fr = 'Raccordement endommagé',
   description_it = 'Tubo di raccordo danneggiato',
   description_ro = '',
   display_en = 'BAHD',
   display_de = 'BAHD',
   display_fr = 'BAHD',
   display_it = 'BAHD',
   display_ro = ''
WHERE code =3976;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3977,3977) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAHE',
   value_de = 'BAHE',
   value_fr = 'BAHE',
   value_it = 'BAHE',
   value_ro = 'BAHE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss verstopft',
   description_de = 'Anschluss verstopft',
   description_fr = 'Raccordement obstrué',
   description_it = 'Allacciamento ostruito',
   description_ro = '',
   display_en = 'BAHE',
   display_de = 'BAHE',
   display_fr = 'BAHE',
   display_it = 'BAHE',
   display_ro = ''
WHERE code =3977;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3978,3978) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAHZ',
   value_de = 'BAHZ',
   value_fr = 'BAHZ',
   value_it = 'BAHZ',
   value_ro = 'BAHZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss andersartig schadhaft',
   description_de = 'Anschluss andersartig schadhaft',
   description_fr = 'Raccordement défectueux',
   description_it = 'Allacciamento danneggiato per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BAHZ',
   display_de = 'BAHZ',
   display_fr = 'BAHZ',
   display_it = 'BAHZ',
   display_ro = ''
WHERE code =3978;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3979,3979) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAIAA',
   value_de = 'BAIAA',
   value_fr = 'BAIAA',
   value_it = 'BAIAA',
   value_ro = 'BAIAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring verschoben',
   description_de = 'Dichtring verschoben',
   description_fr = 'Joint d’étanchéité déplacé',
   description_it = 'Anello di tenuta spostato',
   description_ro = '',
   display_en = 'BAIAA',
   display_de = 'BAIAA',
   display_fr = 'BAIAA',
   display_it = 'BAIAA',
   display_ro = ''
WHERE code =3979;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3980,3980) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAIAB',
   value_de = 'BAIAB',
   value_fr = 'BAIAB',
   value_it = 'BAIAB',
   value_ro = 'BAIAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring einragend, aber nicht gebrochen, tiefster Punkt oberhalb Rohrmitte',
   description_de = 'Dichtring einragend, aber nicht gebrochen, tiefster Punkt oberhalb Rohrmitte ',
   description_fr = 'Joint d’étanchéité saillant, mais non rompu, point le plus bas au-dessus du milieu de la canalisation',
   description_it = 'Anello di tenuta sporgente, ma non rotto, punto più basso sopra il centro del tubo',
   description_ro = '',
   display_en = 'BAIAB',
   display_de = 'BAIAB',
   display_fr = 'BAIAB',
   display_it = 'BAIAB',
   display_ro = ''
WHERE code =3980;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3981,3981) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAIAC',
   value_de = 'BAIAC',
   value_fr = 'BAIAC',
   value_it = 'BAIAC',
   value_ro = 'BAIAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring einragend, aber nicht gebrochen, tiefster Punkt unterhalb Rohrmitte',
   description_de = 'Dichtring einragend, aber nicht gebrochen, tiefster Punkt unterhalb Rohrmitte ',
   description_fr = 'Joint d’étanchéité saillant, mais non rompu, point le plus bas au-dessous du milieu de la canalisation',
   description_it = 'Anello di tenuta sporgente, ma non rotto, punto più basso sotto il centro del tubo',
   description_ro = '',
   display_en = 'BAIAC',
   display_de = 'BAIAC',
   display_fr = 'BAIAC',
   display_it = 'BAIAC',
   display_ro = ''
WHERE code =3981;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3982,3982) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAIAD',
   value_de = 'BAIAD',
   value_fr = 'BAIAD',
   value_it = 'BAIAD',
   value_ro = 'BAIAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring einragend, gebrochen',
   description_de = 'Dichtring einragend, gebrochen ',
   description_fr = 'Joint d’étanchéité rompu',
   description_it = 'Anello di tenuta rotto',
   description_ro = '',
   display_en = 'BAIAD',
   display_de = 'BAIAD',
   display_fr = 'BAIAD',
   display_it = 'BAIAD',
   display_ro = ''
WHERE code =3982;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3983,3983) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAIZ',
   value_de = 'BAIZ',
   value_fr = 'BAIZ',
   value_it = 'BAIZ',
   value_ro = 'BAIZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Einragendes Dichtungsmaterial',
   description_de = 'Einragendes Dichtungsmaterial',
   description_fr = 'Joint d’étanchéité apparent',
   description_it = 'Intrusione di materiale sigillante (ulteriori dettagli sono richiesti nell’osserva- zione)',
   description_ro = '',
   display_en = 'BAIZ',
   display_de = 'BAIZ',
   display_fr = 'BAIZ',
   display_it = 'BAIZ',
   display_ro = ''
WHERE code =3983;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3984,3984) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAJA',
   value_de = 'BAJA',
   value_fr = 'BAJA',
   value_it = 'BAJA',
   value_ro = 'BAJA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Breite Rohrverbindung',
   description_de = 'Breite Rohrverbindung',
   description_fr = 'Assemblage déboîté',
   description_it = 'Spostamento giunto longitudinale',
   description_ro = '',
   display_en = 'BAJA',
   display_de = 'BAJA',
   display_fr = 'BAJA',
   display_it = 'BAJA',
   display_ro = ''
WHERE code =3984;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3985,3985) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAJB',
   value_de = 'BAJB',
   value_fr = 'BAJB',
   value_it = 'BAJB',
   value_ro = 'BAJB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrverbindung versetzt',
   description_de = 'Rohrverbindung versetzt',
   description_fr = 'Assemblage déplacé',
   description_it = 'Spostamento giunto radiale',
   description_ro = '',
   display_en = 'BAJB',
   display_de = 'BAJB',
   display_fr = 'BAJB',
   display_it = 'BAJB',
   display_ro = ''
WHERE code =3985;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3986,3986) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAJC',
   value_de = 'BAJC',
   value_fr = 'BAJC',
   value_it = 'BAJC',
   value_ro = 'BAJC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrverbindung Knick',
   description_de = 'Rohrverbindung Knick',
   description_fr = 'Assemblage dévié',
   description_it = 'Spostamento giunto angolare',
   description_ro = '',
   display_en = 'BAJC',
   display_de = 'BAJC',
   display_fr = 'BAJC',
   display_it = 'BAJC',
   display_ro = ''
WHERE code =3986;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3987,3987) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKA',
   value_de = 'BAKA',
   value_fr = 'BAKA',
   value_it = 'BAKA',
   value_ro = 'BAKA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung abgelöst',
   description_de = 'Innenauskleidung abgelöst',
   description_fr = 'Revêtement détaché',
   description_it = 'Rivestimento staccato',
   description_ro = '',
   display_en = 'BAKA',
   display_de = 'BAKA',
   display_fr = 'BAKA',
   display_it = 'BAKA',
   display_ro = ''
WHERE code =3987;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3988,3988) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKB',
   value_de = 'BAKB',
   value_fr = 'BAKB',
   value_it = 'BAKB',
   value_ro = 'BAKB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung verfärbt',
   description_de = 'Innenauskleidung verfärbt',
   description_fr = 'Revêtement décoloré',
   description_it = 'Rivestimento scolorito',
   description_ro = '',
   display_en = 'BAKB',
   display_de = 'BAKB',
   display_fr = 'BAKB',
   display_it = 'BAKB',
   display_ro = ''
WHERE code =3988;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3989,3989) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKC',
   value_de = 'BAKC',
   value_fr = 'BAKC',
   value_it = 'BAKC',
   value_ro = 'BAKC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Endstelle der Innenauskleidung schadhaft',
   description_de = 'Endstelle der Innenauskleidung schadhaft',
   description_fr = 'Extrémité du revêtement défectueuse',
   description_it = 'Estremità del rivestimento difettoso',
   description_ro = '',
   display_en = 'BAKC',
   display_de = 'BAKC',
   display_fr = 'BAKC',
   display_it = 'BAKC',
   display_ro = ''
WHERE code =3989;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3990,3990) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKDA',
   value_de = 'BAKDA',
   value_fr = 'BAKDA',
   value_it = 'BAKDA',
   value_ro = 'BAKDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung Faltenbildung, längs',
   description_de = 'Innenauskleidung Faltenbildung, längs',
   description_fr = 'Revêtement ondulé longitudinalement',
   description_it = 'Rivestimento con grinze/pieghe longitudinali',
   description_ro = '',
   display_en = 'BAKDA',
   display_de = 'BAKDA',
   display_fr = 'BAKDA',
   display_it = 'BAKDA',
   display_ro = ''
WHERE code =3990;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3991,3991) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKDB',
   value_de = 'BAKDB',
   value_fr = 'BAKDB',
   value_it = 'BAKDB',
   value_ro = 'BAKDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung Faltenbildung, radial',
   description_de = 'Innenauskleidung Faltenbildung, radial',
   description_fr = 'Revêtement ondulé radialement',
   description_it = 'Rivestimento con grinze/pieghe radiali',
   description_ro = '',
   display_en = 'BAKDB',
   display_de = 'BAKDB',
   display_fr = 'BAKDB',
   display_it = 'BAKDB',
   display_ro = ''
WHERE code =3991;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3992,3992) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKDC',
   value_de = 'BAKDC',
   value_fr = 'BAKDC',
   value_it = 'BAKDC',
   value_ro = 'BAKDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung Faltenbildung, komplex',
   description_de = 'Innenauskleidung Faltenbildung, komplex ',
   description_fr = 'Revêtement ondulé de façon complexe',
   description_it = 'Rivestimento con grinze/pieghe complesse',
   description_ro = '',
   display_en = 'BAKDC',
   display_de = 'BAKDC',
   display_fr = 'BAKDC',
   display_it = 'BAKDC',
   display_ro = ''
WHERE code =3992;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8850,8850) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKDD',
   value_de = 'BAKDD',
   value_fr = 'BAKDD',
   value_it = 'BAKDD',
   value_ro = 'BAKDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung Faltenbildung, spiralformig ',
   description_de = 'Innenauskleidung Faltenbildung, spiralformig ',
   description_fr = 'Revêtement ondulé en forme de spirale',
   description_it = 'Rivestimento con grinze/pieghe elicoidali',
   description_ro = 'rrr_Innenauskleidung Faltenbildung, spiralformig ',
   display_en = 'BAKDD',
   display_de = 'BAKDD',
   display_fr = 'BAKDD',
   display_it = 'BAKDD',
   display_ro = ''
WHERE code =8850;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3993,3993) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKE',
   value_de = 'BAKE',
   value_fr = 'BAKE',
   value_it = 'BAKE',
   value_ro = 'BAKE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Blasen/Beulen in der Innenauskleidung',
   description_de = 'Blasen/Beulen in der Innenauskleidung',
   description_fr = 'Bulles/bosses dans la doublure intérieure',
   description_it = 'Rivestimento con bolle e ammaccature',
   description_ro = '',
   display_en = 'BAKE',
   display_de = 'BAKE',
   display_fr = 'BAKE',
   display_it = 'BAKE',
   display_ro = ''
WHERE code =3993;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8851,8851) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKF',
   value_de = 'BAKF',
   value_fr = 'BAKF',
   value_it = 'BAKF',
   value_ro = 'BAKF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule der Innauskleidung nach aussen',
   description_de = 'Beule der Innauskleidung nach aussen',
   description_fr = 'Bosse de la doublure intérieure vers l’extérieur',
   description_it = 'Rivestimento con bolle verso esterno',
   description_ro = 'rrr_Beule der Innauskleidung nach aussen',
   display_en = 'BAKF',
   display_de = 'BAKF',
   display_fr = 'BAKF',
   display_it = 'BAKF',
   display_ro = ''
WHERE code =8851;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8852,8852) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKG',
   value_de = 'BAKG',
   value_fr = 'BAKG',
   value_it = 'BAKG',
   value_ro = 'BAKG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablösen der Innenhaut / Beschichtung',
   description_de = 'Ablösen der Innenhaut / Beschichtung',
   description_fr = 'Décollement de la peau intérieure/du revêtement',
   description_it = 'Distacco della pellicola interna/rivestimento',
   description_ro = 'rrr_Ablösen der Innenhaut / Beschichtung',
   display_en = 'BAKG',
   display_de = 'BAKG',
   display_fr = 'BAKG',
   display_it = 'BAKG',
   display_ro = ''
WHERE code =8852;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8853,8853) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKH',
   value_de = 'BAKH',
   value_fr = 'BAKH',
   value_it = 'BAKH',
   value_ro = 'BAKH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablösen der Abdeckung der Verbindungsnaht',
   description_de = 'Ablösen der Abdeckung der Verbindungsnaht',
   description_fr = 'Dégradation de la couture de connexion',
   description_it = 'Distacco della copertura della cucitura',
   description_ro = 'rrr_Ablösen der Abdeckung der Verbindungsnaht',
   display_en = 'BAKH',
   display_de = 'BAKH',
   display_fr = 'BAKH',
   display_it = 'BAKH',
   display_ro = ''
WHERE code =8853;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8854,8854) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKI',
   value_de = 'BAKI',
   value_fr = 'BAKI',
   value_it = 'BAKI',
   value_ro = 'BAKI',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss oder Splat in der Innauskleidung',
   description_de = 'Riss oder Splat in der Innauskleidung',
   description_fr = 'Fissure ou espace dans la doublure intérieure (y compris la soudure défectueuse)',
   description_it = 'Fessura o spaccatura del rivestimento (incl. saldatura difettosa)',
   description_ro = 'rrr_Riss oder Splat in der Innauskleidung',
   display_en = 'BAKI',
   display_de = 'BAKI',
   display_fr = 'BAKI',
   display_it = 'BAKI',
   display_ro = ''
WHERE code =8854;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8855,8855) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKJ',
   value_de = 'BAKJ',
   value_fr = 'BAKJ',
   value_it = 'BAKJ',
   value_ro = 'BAKJ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Loch in der Innauskleidung',
   description_de = 'Loch in der Innauskleidung',
   description_fr = 'Trou dans la doublure intérieure',
   description_it = 'Foro nel rivestimento',
   description_ro = 'rrr_Loch in der Innauskleidung',
   display_en = 'BAKJ',
   display_de = 'BAKJ',
   display_fr = 'BAKJ',
   display_it = 'BAKJ',
   display_ro = ''
WHERE code =8855;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8856,8856) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKK',
   value_de = 'BAKK',
   value_fr = 'BAKK',
   value_it = 'BAKK',
   value_ro = 'BAKK',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidungsverbindung defekt',
   description_de = 'Auskleidungsverbindung defekt',
   description_fr = 'Connexion de la doublure défectueuse',
   description_it = 'Giuntura del rivestimento difettosa',
   description_ro = 'rrr_Auskleidungsverbindung defekt',
   display_en = 'BAKK',
   display_de = 'BAKK',
   display_fr = 'BAKK',
   display_it = 'BAKK',
   display_ro = ''
WHERE code =8856;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8857,8857) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKL',
   value_de = 'BAKL',
   value_fr = 'BAKL',
   value_it = 'BAKL',
   value_ro = 'BAKL',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidungswerkstoff erscheint weich',
   description_de = 'Auskleidungswerkstoff erscheint weich',
   description_fr = 'Le matériau de la doublure semble mou',
   description_it = 'Materiale del rivestimento risulta molle',
   description_ro = 'rrr_Auskleidungswerkstoff erscheint weich',
   display_en = 'BAKL',
   display_de = 'BAKL',
   display_fr = 'BAKL',
   display_it = 'BAKL',
   display_ro = ''
WHERE code =8857;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8858,8858) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKM',
   value_de = 'BAKM',
   value_fr = 'BAKM',
   value_it = 'BAKM',
   value_ro = 'BAKM',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Harz fehlt im Laminat',
   description_de = 'Harz fehlt im Laminat',
   description_fr = 'La résine manque dans le stratifié',
   description_it = 'Manca la resina nel laminato',
   description_ro = 'rrr_Harz fehlt im Laminat',
   display_en = 'BAKM',
   display_de = 'BAKM',
   display_fr = 'BAKM',
   display_it = 'BAKM',
   display_ro = ''
WHERE code =8858;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8859,8859) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKN',
   value_de = 'BAKN',
   value_fr = 'BAKN',
   value_it = 'BAKN',
   value_ro = 'BAKN',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ende der Auskleidung ist nicht abgedichtet',
   description_de = 'Ende der Auskleidung ist nicht abgedichtet',
   description_fr = 'La fin de la doublure n’est pas scellée',
   description_it = 'Estremità del rivestimento non sigillato',
   description_ro = 'rrr_Ende der Auskleidung ist nicht abgedichtet',
   display_en = 'BAKN',
   display_de = 'BAKN',
   display_fr = 'BAKN',
   display_it = 'BAKN',
   display_ro = ''
WHERE code =8859;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3994,3994) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAKZ',
   value_de = 'BAKZ',
   value_fr = 'BAKZ',
   value_it = 'BAKZ',
   value_ro = 'BAKZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Innenauskleidung andersartig schadhaft',
   description_de = 'Innenauskleidung andersartig schadhaft',
   description_fr = 'Revêtement intérieur défectueux ',
   description_it = 'Rivestimento difettoso per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = '',
   display_en = 'BAKZ',
   display_de = 'BAKZ',
   display_fr = 'BAKZ',
   display_it = 'BAKZ',
   display_ro = ''
WHERE code =3994;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3995,3995) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALA',
   value_de = 'BALA',
   value_fr = 'BALA',
   value_it = 'BALA',
   value_ro = 'BALA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur mangelhaft, Wand fehlt teilweise',
   description_de = 'Reparatur mangelhaft, Wand fehlt teilweise',
   description_fr = 'Réparation défectueuse, paroi manquante',
   description_it = 'Riparazione difettosa, parte della parete mancante',
   description_ro = '',
   display_en = 'BALA',
   display_de = 'BALA',
   display_fr = 'BALA',
   display_it = 'BALA',
   display_ro = ''
WHERE code =3995;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3996,3996) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALB',
   value_de = 'BALB',
   value_fr = 'BALB',
   value_it = 'BALB',
   value_ro = 'BALB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur Loch mangelhaft',
   description_de = 'Reparatur Loch mangelhaft',
   description_fr = 'Réparation d’un trou défectueuse',
   description_it = 'Rattoppo foro difettoso',
   description_ro = '',
   display_en = 'BALB',
   display_de = 'BALB',
   display_fr = 'BALB',
   display_it = 'BALB',
   display_ro = ''
WHERE code =3996;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8860,8860) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALC',
   value_de = 'BALC',
   value_fr = 'BALC',
   value_it = 'BALC',
   value_ro = 'BALC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparaturwerkstoff löst sich vom Altrohr',
   description_de = 'Reparaturwerkstoff löst sich vom Altrohr',
   description_fr = 'Le matériau de réparation se désolidarise de l’ancien tuyau',
   description_it = 'Materiale di riparazione si stacca dal vecchio tubo',
   description_ro = 'rrr_Reparaturwerkstoff löst sich vom Altrohr',
   display_en = 'BALC',
   display_de = 'BALC',
   display_fr = 'BALC',
   display_it = 'BALC',
   display_ro = ''
WHERE code =8860;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8861,8861) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALD',
   value_de = 'BALD',
   value_fr = 'BALD',
   value_it = 'BALD',
   value_ro = 'BALD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparaturwerkstoff fehlt an der Kontaktfläche',
   description_de = 'Reparaturwerkstoff fehlt an der Kontaktfläche',
   description_fr = 'Le matériel de réparation est manquant à la surface de contact',
   description_it = 'Materiale di riparazione manca sulla superficie di contatto',
   description_ro = 'rrr_Reparaturwerkstoff fehlt an der Kontaktfläche',
   display_en = 'BALD',
   display_de = 'BALD',
   display_fr = 'BALD',
   display_it = 'BALD',
   display_ro = ''
WHERE code =8861;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8862,8862) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALE',
   value_de = 'BALE',
   value_fr = 'BALE',
   value_it = 'BALE',
   value_ro = 'BALE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Überschüssiger Reparaturwerkstoff, Hindernis',
   description_de = 'Überschüssiger Reparaturwerkstoff, Hindernis',
   description_fr = 'Matériel de réparation en excès, obstacle',
   description_it = 'Materiale di riparazione in eccesso, ostacolo',
   description_ro = 'rrr_Überschüssiger Reparaturwerkstoff, Hindernis',
   display_en = 'BALE',
   display_de = 'BALE',
   display_fr = 'BALE',
   display_it = 'BALE',
   display_ro = ''
WHERE code =8862;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8863,8863) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALF',
   value_de = 'BALF',
   value_fr = 'BALF',
   value_it = 'BALF',
   value_ro = 'BALF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Loch im Reparaturwerkstoff',
   description_de = 'Loch im Reparaturwerkstoff',
   description_fr = 'Trou dans le matériel de réparation',
   description_it = 'Foro nel materiale di riparazione',
   description_ro = 'rrr_Loch im Reparaturwerkstoff',
   display_en = 'BALF',
   display_de = 'BALF',
   display_fr = 'BALF',
   display_it = 'BALF',
   display_ro = ''
WHERE code =8863;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8864,8864) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALGA',
   value_de = 'BALGA',
   value_fr = 'BALGA',
   value_it = 'BALGA',
   value_ro = 'BALGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss im Reparaturwerkstoff, längs',
   description_de = 'Riss im Reparaturwerkstoff, längs',
   description_fr = 'Fissure dans le matériau de réparation, longitudinal',
   description_it = 'Fessura nel materiale di riparazione, longitudinale',
   description_ro = 'rrr_Riss im Reparaturwerkstoff, längs',
   display_en = 'BALGA',
   display_de = 'BALGA',
   display_fr = 'BALGA',
   display_it = 'BALGA',
   display_ro = ''
WHERE code =8864;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8865,8865) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALGB',
   value_de = 'BALGB',
   value_fr = 'BALGB',
   value_it = 'BALGB',
   value_ro = 'BALGB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss im Reparaturwerkstoff, radial',
   description_de = 'Riss im Reparaturwerkstoff, radial',
   description_fr = 'Fissure dans le matériau de réparation, radial',
   description_it = 'Fessura nel materiale di riparazione, radiale',
   description_ro = 'rrr_Riss im Reparaturwerkstoff, radial',
   display_en = 'BALGB',
   display_de = 'BALGB',
   display_fr = 'BALGB',
   display_it = 'BALGB',
   display_ro = ''
WHERE code =8865;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8866,8866) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALGC',
   value_de = 'BALGC',
   value_fr = 'BALGC',
   value_it = 'BALGC',
   value_ro = 'BALGC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss im Reparaturwerkstoff, komplex',
   description_de = 'Riss im Reparaturwerkstoff, komplex',
   description_fr = 'Fissure dans le matériau de réparation, complexe',
   description_it = 'Fessura nel materiale di riparazione, complesso',
   description_ro = 'rrr_Riss im Reparaturwerkstoff, komplex',
   display_en = 'BALGC',
   display_de = 'BALGC',
   display_fr = 'BALGC',
   display_it = 'BALGC',
   display_ro = ''
WHERE code =8866;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8867,8867) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALGD',
   value_de = 'BALGD',
   value_fr = 'BALGD',
   value_it = 'BALGD',
   value_ro = 'BALGD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss im Reparaturwerkstoff, spiralförmig',
   description_de = 'Riss im Reparaturwerkstoff, spiralförmig',
   description_fr = 'Fissure dans le matériau de réparation, en spirale',
   description_it = 'Fessura nel materiale di riparazione, elicoidale',
   description_ro = 'rrr_Riss im Reparaturwerkstoff, spiralförmig',
   display_en = 'BALGD',
   display_de = 'BALGD',
   display_fr = 'BALGD',
   display_it = 'BALGD',
   display_ro = ''
WHERE code =8867;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3997,3997) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BALZ',
   value_de = 'BALZ',
   value_fr = 'BALZ',
   value_it = 'BALZ',
   value_ro = 'BALZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur andersartig mangelhaft',
   description_de = 'Reparatur andersartig mangelhaft',
   description_fr = 'Autre réparation défectueuse',
   description_it = 'Riparazione difettosa per altre cause (ulteriori dettagli sono richiesti nell’osser- vazione)',
   description_ro = '',
   display_en = 'BALZ',
   display_de = 'BALZ',
   display_fr = 'BALZ',
   display_it = 'BALZ',
   display_ro = ''
WHERE code =3997;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3998,3998) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAMA',
   value_de = 'BAMA',
   value_fr = 'BAMA',
   value_it = 'BAMA',
   value_ro = 'BAMA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schweissnaht in Längsrichtung mangelhaft ',
   description_de = 'Schweissnaht in Längsrichtung mangelhaft ',
   description_fr = 'Défaut de soudage vertical',
   description_it = 'Saldatura longitudinale difettosa',
   description_ro = '',
   display_en = 'BAMA',
   display_de = 'BAMA',
   display_fr = 'BAMA',
   display_it = 'BAMA',
   display_ro = ''
WHERE code =3998;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (3999,3999) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAMB',
   value_de = 'BAMB',
   value_fr = 'BAMB',
   value_it = 'BAMB',
   value_ro = 'BAMB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schweissnaht radial mangelhaft ',
   description_de = 'Schweissnaht radial mangelhaft ',
   description_fr = 'Défaut de soudage radial',
   description_it = 'Saldatura radiale difettosa',
   description_ro = '',
   display_en = 'BAMB',
   display_de = 'BAMB',
   display_fr = 'BAMB',
   display_it = 'BAMB',
   display_ro = ''
WHERE code =3999;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4000,4000) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAMC',
   value_de = 'BAMC',
   value_fr = 'BAMC',
   value_it = 'BAMC',
   value_ro = 'BAMC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schweissnaht mit spiralförmigem Verlauf mangelhaft ',
   description_de = 'Schweissnaht mit spiralförmigem Verlauf mangelhaft ',
   description_fr = 'Défaut de soudage hélicoïdal',
   description_it = 'Saldatura elicoidale difettosa',
   description_ro = '',
   display_en = 'BAMC',
   display_de = 'BAMC',
   display_fr = 'BAMC',
   display_it = 'BAMC',
   display_ro = ''
WHERE code =4000;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4001,4001) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAN',
   value_de = 'BAN',
   value_fr = 'BAN',
   value_it = 'BAN',
   value_ro = 'BAN',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Leitung porös',
   description_de = 'Leitung porös',
   description_fr = 'Conduite poreuse',
   description_it = 'Condotta porosa',
   description_ro = '',
   display_en = 'BAN',
   display_de = 'BAN',
   display_fr = 'BAN',
   display_it = 'BAN',
   display_ro = ''
WHERE code =4001;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4002,4002) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAO',
   value_de = 'BAO',
   value_fr = 'BAO',
   value_it = 'BAO',
   value_ro = 'BAO',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_anstehender Boden sichtbar',
   description_de = 'anstehender Boden sichtbar ',
   description_fr = 'Sol visible',
   description_it = 'Suolo visibile',
   description_ro = '',
   display_en = 'BAO',
   display_de = 'BAO',
   display_fr = 'BAO',
   display_it = 'BAO',
   display_ro = ''
WHERE code =4002;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4003,4003) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BAP',
   value_de = 'BAP',
   value_fr = 'BAP',
   value_it = 'BAP',
   value_ro = 'BAP',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hohlraum sichtbar',
   description_de = 'Hohlraum sichtbar ',
   description_fr = 'Vide visible',
   description_it = 'Cavità visibile',
   description_ro = '',
   display_en = 'BAP',
   display_de = 'BAP',
   display_fr = 'BAP',
   display_it = 'BAP',
   display_ro = ''
WHERE code =4003;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4004,4004) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBAA',
   value_de = 'BBAA',
   value_fr = 'BBAA',
   value_it = 'BBAA',
   value_ro = 'BBAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Pfahlwurzel',
   description_de = 'Pfahlwurzel',
   description_fr = 'Grosse racine isolée',
   description_it = 'Tappo di radici',
   description_ro = '',
   display_en = 'BBAA',
   display_de = 'BBAA',
   display_fr = 'BBAA',
   display_it = 'BBAA',
   display_ro = 'BBAA'
WHERE code =4004;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4005,4005) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBAB',
   value_de = 'BBAB',
   value_fr = 'BBAB',
   value_it = 'BBAB',
   value_ro = 'BBAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Einzelner, feiner Wurzeleinwuchs',
   description_de = 'Einzelner, feiner Wurzeleinwuchs',
   description_fr = 'Radicelles',
   description_it = 'Radici sottili singole',
   description_ro = '',
   display_en = 'BBAB',
   display_de = 'BBAB',
   display_fr = 'BBAB',
   display_it = 'BBAB',
   display_ro = 'BBAB'
WHERE code =4005;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4006,4006) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBAC',
   value_de = 'BBAC',
   value_fr = 'BBAC',
   value_it = 'BBAC',
   value_ro = 'BBAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Komplexes Wurzelwerk',
   description_de = 'Komplexes Wurzelwerk',
   description_fr = 'Ensemble complexe de racines',
   description_it = 'Massa complessa di radici',
   description_ro = '',
   display_en = 'BBAC',
   display_de = 'BBAC',
   display_fr = 'BBAC',
   display_it = 'BBAC',
   display_ro = 'BBAC'
WHERE code =4006;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4007,4007) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBBA',
   value_de = 'BBBA',
   value_fr = 'BBBA',
   value_it = 'BBBA',
   value_ro = 'BBBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inkrustation (verkalkt)',
   description_de = 'Inkrustation (verkalkt)',
   description_fr = 'Concrétions (calcifié)',
   description_it = 'Incrostazioni (calcificazione)',
   description_ro = '',
   display_en = 'BBBA',
   display_de = 'BBBA',
   display_fr = 'BBBA',
   display_it = 'BBBA',
   display_ro = 'BBBA'
WHERE code =4007;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4008,4008) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBBB',
   value_de = 'BBBB',
   value_fr = 'BBBB',
   value_it = 'BBBB',
   value_ro = 'BBBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fett',
   description_de = 'Fett',
   description_fr = 'Graisse',
   description_it = 'Grasso',
   description_ro = '',
   display_en = 'BBBB',
   display_de = 'BBBB',
   display_fr = 'BBBB',
   display_it = 'BBBB',
   display_ro = 'BBBB'
WHERE code =4008;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4009,4009) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBBC',
   value_de = 'BBBC',
   value_fr = 'BBBC',
   value_it = 'BBBC',
   value_ro = 'BBBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fäulnis',
   description_de = 'Fäulnis',
   description_fr = 'Encrassement',
   description_it = 'Incrostazioni organiche',
   description_ro = '',
   display_en = 'BBBC',
   display_de = 'BBBC',
   display_fr = 'BBBC',
   display_it = 'BBBC',
   display_ro = 'BBBC'
WHERE code =4009;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4010,4010) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBBZ',
   value_de = 'BBBZ',
   value_fr = 'BBBZ',
   value_it = 'BBBZ',
   value_ro = 'BBBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige anhaftende Stoffe',
   description_de = 'Andersartige anhaftende Stoffe',
   description_fr = 'Autres substances adhérentes',
   description_it = 'Altri depositi attaccati (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBBZ',
   display_de = 'BBBZ',
   display_fr = 'BBBZ',
   display_it = 'BBBZ',
   display_ro = 'BBBZ'
WHERE code =4010;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4011,4011) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBCA',
   value_de = 'BBCA',
   value_fr = 'BBCA',
   value_it = 'BBCA',
   value_ro = 'BBCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Lose Ablagerungen, Sand',
   description_de = 'Lose Ablagerungen, Sand',
   description_fr = 'Dépôts lâches, sable',
   description_it = 'Depositi sciolte, sabbia',
   description_ro = '',
   display_en = 'BBCA',
   display_de = 'BBCA',
   display_fr = 'BBCA',
   display_it = 'BBCA',
   display_ro = 'BBCA'
WHERE code =4011;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4012,4012) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBCB',
   value_de = 'BBCB',
   value_fr = 'BBCB',
   value_it = 'BBCB',
   value_ro = 'BBCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Lose Ablagerungen, Kies',
   description_de = 'Lose Ablagerungen, Kies',
   description_fr = 'Dépôts lâches, gravier',
   description_it = 'Depositi sciolte, ghiaia',
   description_ro = '',
   display_en = 'BBCB',
   display_de = 'BBCB',
   display_fr = 'BBCB',
   display_it = 'BBCB',
   display_ro = 'BBCB'
WHERE code =4012;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4013,4013) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBCC',
   value_de = 'BBCC',
   value_fr = 'BBCC',
   value_it = 'BBCC',
   value_ro = 'BBCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Harte Ablagerungen',
   description_de = 'Harte Ablagerungen',
   description_fr = 'Dépôts durs',
   description_it = 'Depositi duri',
   description_ro = '',
   display_en = 'BBCC',
   display_de = 'BBCC',
   display_fr = 'BBCC',
   display_it = 'BBCC',
   display_ro = 'BBCC'
WHERE code =4013;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4014,4014) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBCZ',
   value_de = 'BBCZ',
   value_fr = 'BBCZ',
   value_it = 'BBCZ',
   value_ro = 'BBCZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Ablagerungen',
   description_de = 'Andersartige Ablagerungen',
   description_fr = 'Autres dépôts ',
   description_it = 'Altri tipi di depositi (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBCZ',
   display_de = 'BBCZ',
   display_fr = 'BBCZ',
   display_it = 'BBCZ',
   display_ro = 'BBCZ'
WHERE code =4014;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4015,4015) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBDA',
   value_de = 'BBDA',
   value_fr = 'BBDA',
   value_it = 'BBDA',
   value_ro = 'BBDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sand dringt ein',
   description_de = 'Sand dringt ein',
   description_fr = 'Entrée de sable',
   description_it = 'Penetrazione di sabbia',
   description_ro = '',
   display_en = 'BBDA',
   display_de = 'BBDA',
   display_fr = 'BBDA',
   display_it = 'BBDA',
   display_ro = 'BBDA'
WHERE code =4015;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4016,4016) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBDB',
   value_de = 'BBDB',
   value_fr = 'BBDB',
   value_it = 'BBDB',
   value_ro = 'BBDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_organischen Bodenmaterial dringt ein',
   description_de = 'organischen Bodenmaterial dringt ein',
   description_fr = 'Entrée d’humus',
   description_it = 'Penetrazione di humus/torba',
   description_ro = '',
   display_en = 'BBDB',
   display_de = 'BBDB',
   display_fr = 'BBDB',
   display_it = 'BBDB',
   display_ro = 'BBDB'
WHERE code =4016;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4017,4017) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBDC',
   value_de = 'BBDC',
   value_fr = 'BBDC',
   value_it = 'BBDC',
   value_ro = 'BBDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Feinmaterial dringt ein',
   description_de = 'Feinmaterial dringt ein',
   description_fr = 'Entrée de matériau fin',
   description_it = 'Penetrazione di materiale fine',
   description_ro = '',
   display_en = 'BBDC',
   display_de = 'BBDC',
   display_fr = 'BBDC',
   display_it = 'BBDC',
   display_ro = 'BBDC'
WHERE code =4017;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4018,4018) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBDD',
   value_de = 'BBDD',
   value_fr = 'BBDD',
   value_it = 'BBDD',
   value_ro = 'BBDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Grobmaterial dringt ein',
   description_de = 'Grobmaterial dringt ein',
   description_fr = 'Entrée de gravier',
   description_it = 'Penetrazione di materiale grossolano',
   description_ro = '',
   display_en = 'BBDD',
   display_de = 'BBDD',
   display_fr = 'BBDD',
   display_it = 'BBDD',
   display_ro = 'BBDD'
WHERE code =4018;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4019,4019) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBDZ',
   value_de = 'BBDZ',
   value_fr = 'BBDZ',
   value_it = 'BBDZ',
   value_ro = 'BBDZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bodenmaterial dringt ein',
   description_de = 'Bodenmaterial dringt ein',
   description_fr = 'Entrée de terre',
   description_it = 'Penetrazione di materiale (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBDZ',
   display_de = 'BBDZ',
   display_fr = 'BBDZ',
   display_it = 'BBDZ',
   display_ro = 'BBDZ'
WHERE code =4019;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4020,4020) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEA',
   value_de = 'BBEA',
   value_fr = 'BBEA',
   value_it = 'BBEA',
   value_ro = 'BBEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hindernis: Mauer- oder Backstein liegt in der Rohrsohle',
   description_de = 'Hindernis: Mauer- oder Backstein liegt in der Rohrsohle',
   description_fr = 'Obstacle: briquetage ou élément de maçonnerie tombé',
   description_it = 'Ostacolo: mattoni o pezzi di muratura giacente sul fondo del tubo',
   description_ro = '',
   display_en = 'BBEA',
   display_de = 'BBEA',
   display_fr = 'BBEA',
   display_it = 'BBEA',
   display_ro = 'BBEA'
WHERE code =4020;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4021,4021) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEB',
   value_de = 'BBEB',
   value_fr = 'BBEB',
   value_it = 'BBEB',
   value_ro = 'BBEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hindernis: Leitungsstück liegt in der Rohrsohle',
   description_de = 'Hindernis: Leitungsstück liegt in der Rohrsohle',
   description_fr = 'Obstacle: fragment de canalisation brisé',
   description_it = 'Ostacolo: pezzo di tubo rotto giacente sul fondo del tubo',
   description_ro = '',
   display_en = 'BBEB',
   display_de = 'BBEB',
   display_fr = 'BBEB',
   display_it = 'BBEB',
   display_ro = 'BBEB'
WHERE code =4021;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4022,4022) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEC',
   value_de = 'BBEC',
   value_fr = 'BBEC',
   value_it = 'BBEC',
   value_ro = 'BBEC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand liegt in der Rohrsohle',
   description_de = 'Gegenstand liegt in der Rohrsohle',
   description_fr = 'Objet gisant sur le radier',
   description_it = 'Oggetto giacente sul fondo del tubo',
   description_ro = '',
   display_en = 'BBEC',
   display_de = 'BBEC',
   display_fr = 'BBEC',
   display_it = 'BBEC',
   display_ro = 'BBEC'
WHERE code =4022;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4023,4023) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBED',
   value_de = 'BBED',
   value_fr = 'BBED',
   value_it = 'BBED',
   value_ro = 'BBED',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ragt durch die Wand ein',
   description_de = 'Gegenstand ragt durch die Wand ein',
   description_fr = 'Obstacle dépassant de la paroi',
   description_it = 'Oggetto sporgente dalla parete',
   description_ro = '',
   display_en = 'BBED',
   display_de = 'BBED',
   display_fr = 'BBED',
   display_it = 'BBED',
   display_ro = 'BBED'
WHERE code =4023;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4024,4024) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEE',
   value_de = 'BBEE',
   value_fr = 'BBEE',
   value_it = 'BBEE',
   value_ro = 'BBEE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ist in der Rohrverbindung eingeklemmt',
   description_de = 'Gegenstand ist in der Rohrverbindung eingeklemmt',
   description_fr = 'Obstacle coincé dans l’assemblage',
   description_it = 'Oggetto incuneato nel giunto',
   description_ro = '',
   display_en = 'BBEE',
   display_de = 'BBEE',
   display_fr = 'BBEE',
   display_it = 'BBEE',
   display_ro = 'BBEE'
WHERE code =4024;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4025,4025) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEF',
   value_de = 'BBEF',
   value_fr = 'BBEF',
   value_it = 'BBEF',
   value_ro = 'BBEF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ragt aus Anschluss in Hauptleitung',
   description_de = 'Gegenstand ragt aus Anschluss in Hauptleitung',
   description_fr = 'Obstacle dépassant de l’assemblage dans la canalisation principale',
   description_it = 'Oggetto sporge dall’allacciamento in condotta principale',
   description_ro = '',
   display_en = 'BBEF',
   display_de = 'BBEF',
   display_fr = 'BBEF',
   display_it = 'BBEF',
   display_ro = 'BBEF'
WHERE code =4025;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4026,4026) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEG',
   value_de = 'BBEG',
   value_fr = 'BBEG',
   value_it = 'BBEG',
   value_ro = 'BBEG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fremde Werkleitungen oder Kabel durchqueren die Leitung',
   description_de = 'Fremde Werkleitungen oder Kabel durchqueren die Leitung',
   description_fr = 'Conduites externes ou câbles traversant la canalisation',
   description_it = 'Condotte sotterranee o cavi attraversano la tubazione',
   description_ro = '',
   display_en = 'BBEG',
   display_de = 'BBEG',
   display_fr = 'BBEG',
   display_it = 'BBEG',
   display_ro = 'BBEG'
WHERE code =4026;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4027,4027) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEH',
   value_de = 'BBEH',
   value_fr = 'BBEH',
   value_it = 'BBEH',
   value_ro = 'BBEH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ist in den Rohrkörper eingebaut',
   description_de = 'Gegenstand ist in den Rohrkörper eingebaut',
   description_fr = 'Obstacle intégré à la structure',
   description_it = 'Oggetto inglobato nella struttura del tubo',
   description_ro = '',
   display_en = 'BBEH',
   display_de = 'BBEH',
   display_fr = 'BBEH',
   display_it = 'BBEH',
   display_ro = 'BBEH'
WHERE code =4027;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4028,4028) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBEZ',
   value_de = 'BBEZ',
   value_fr = 'BBEZ',
   value_it = 'BBEZ',
   value_ro = 'BBEZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiges Hindernis',
   description_de = 'Andersartiges Hindernis',
   description_fr = 'Obstacle',
   description_it = 'Altri ostacoli (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBEZ',
   display_de = 'BBEZ',
   display_fr = 'BBEZ',
   display_it = 'BBEZ',
   display_ro = 'BBEZ'
WHERE code =4028;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4029,4029) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBFA',
   value_de = 'BBFA',
   value_fr = 'BBFA',
   value_it = 'BBFA',
   value_ro = 'BBFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Schwitzen / Verkalkung',
   description_de = 'Infiltration: Schwitzen / Verkalkung',
   description_fr = 'Infiltration: suintement / entartrage',
   description_it = 'Infiltrazioni: trasudamento/calcificazione',
   description_ro = '',
   display_en = 'BBFA',
   display_de = 'BBFA',
   display_fr = 'BBFA',
   display_it = 'BBFA',
   display_ro = 'BBFA'
WHERE code =4029;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4030,4030) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBFB',
   value_de = 'BBFB',
   value_fr = 'BBFB',
   value_it = 'BBFB',
   value_ro = 'BBFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser tropft',
   description_de = 'Infiltration: Wasser tropft',
   description_fr = 'Infiltration: goutte à goutte',
   description_it = 'Infiltrazioni: gocciolamento',
   description_ro = '',
   display_en = 'BBFB',
   display_de = 'BBFB',
   display_fr = 'BBFB',
   display_it = 'BBFB',
   display_ro = 'BBFB'
WHERE code =4030;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4031,4031) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBFC',
   value_de = 'BBFC',
   value_fr = 'BBFC',
   value_it = 'BBFC',
   value_ro = 'BBFC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser fliesst',
   description_de = 'Infiltration: Wasser fliesst',
   description_fr = 'Infiltration: écoulement',
   description_it = 'Infiltrazioni: scorrimento',
   description_ro = '',
   display_en = 'BBFC',
   display_de = 'BBFC',
   display_fr = 'BBFC',
   display_it = 'BBFC',
   display_ro = 'BBFC'
WHERE code =4031;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4032,4032) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBFD',
   value_de = 'BBFD',
   value_fr = 'BBFD',
   value_it = 'BBFD',
   value_ro = 'BBFD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser spritzt',
   description_de = 'Infiltration: Wasser spritzt',
   description_fr = 'Infiltration: jaillissement',
   description_it = 'Infiltrazioni: zampillio',
   description_ro = '',
   display_en = 'BBFD',
   display_de = 'BBFD',
   display_fr = 'BBFD',
   display_it = 'BBFD',
   display_ro = 'BBFD'
WHERE code =4032;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4033,4033) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBG',
   value_de = 'BBG',
   value_fr = 'BBG',
   value_it = 'BBG',
   value_ro = 'BBG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sichtbarer Wasseraustritt',
   description_de = 'Sichtbarer Wasseraustritt',
   description_fr = 'Fuite visible de la canalisation',
   description_it = 'Fuoriuscita visibile dalla tubazione',
   description_ro = '',
   display_en = 'BBG',
   display_de = 'BBG',
   display_fr = 'BBG',
   display_it = 'BBG',
   display_ro = 'BBG'
WHERE code =4033;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4034,4034) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHAA',
   value_de = 'BBHAA',
   value_fr = 'BBHAA',
   value_it = 'BBHAA',
   value_ro = 'BBHAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte in der Rohrleitung',
   description_de = 'Ratte in der Rohrleitung',
   description_fr = 'Rats dans la canalisation',
   description_it = 'Ratti nella condotta',
   description_ro = '',
   display_en = 'BBHAA',
   display_de = 'BBHAA',
   display_fr = 'BBHAA',
   display_it = 'BBHAA',
   display_ro = 'BBHAA'
WHERE code =4034;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4035,4035) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHAB',
   value_de = 'BBHAB',
   value_fr = 'BBHAB',
   value_it = 'BBHAB',
   value_ro = 'BBHAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte im Anschluss',
   description_de = 'Ratte im Anschluss',
   description_fr = 'Rats dans le raccordement',
   description_it = 'Ratti in un allacciamento',
   description_ro = '',
   display_en = 'BBHAB',
   display_de = 'BBHAB',
   display_fr = 'BBHAB',
   display_it = 'BBHAB',
   display_ro = 'BBHAB'
WHERE code =4035;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4036,4036) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHAC',
   value_de = 'BBHAC',
   value_fr = 'BBHAC',
   value_it = 'BBHAC',
   value_ro = 'BBHAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte in der offenen Rohrverbindung',
   description_de = 'Ratte in der offenen Rohrverbindung',
   description_fr = 'Rats dans l’assemblage ouvert',
   description_it = 'Ratti in un giunto aperto',
   description_ro = '',
   display_en = 'BBHAC',
   display_de = 'BBHAC',
   display_fr = 'BBHAC',
   display_it = 'BBHAC',
   display_ro = 'BBHAC'
WHERE code =4036;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4037,4037) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHAZ',
   value_de = 'BBHAZ',
   value_fr = 'BBHAZ',
   value_it = 'BBHAZ',
   value_ro = 'BBHAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte',
   description_de = 'Ratte',
   description_fr = 'Rats',
   description_it = 'Ratti in genere (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBHAZ',
   display_de = 'BBHAZ',
   display_fr = 'BBHAZ',
   display_it = 'BBHAZ',
   display_ro = 'BBHAZ'
WHERE code =4037;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4038,4038) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHBA',
   value_de = 'BBHBA',
   value_fr = 'BBHBA',
   value_it = 'BBHBA',
   value_ro = 'BBHBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlake in der Rohrleitung',
   description_de = 'Kakerlake in der Rohrleitung',
   description_fr = 'Cafards dans la canalisation',
   description_it = 'Scarafaggi nella tubazione',
   description_ro = '',
   display_en = 'BBHBA',
   display_de = 'BBHBA',
   display_fr = 'BBHBA',
   display_it = 'BBHBA',
   display_ro = 'BBHBA'
WHERE code =4038;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4039,4039) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHBB',
   value_de = 'BBHBB',
   value_fr = 'BBHBB',
   value_it = 'BBHBB',
   value_ro = 'BBHBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlake im Anschluss',
   description_de = 'Kakerlake im Anschluss',
   description_fr = 'Cafards dans le raccordement',
   description_it = 'Scarafaggi in un allacciamento',
   description_ro = '',
   display_en = 'BBHBB',
   display_de = 'BBHBB',
   display_fr = 'BBHBB',
   display_it = 'BBHBB',
   display_ro = 'BBHBB'
WHERE code =4039;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4040,4040) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHBC',
   value_de = 'BBHBC',
   value_fr = 'BBHBC',
   value_it = 'BBHBC',
   value_ro = 'BBHBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlake in der offenen Rohrverbindung',
   description_de = 'Kakerlake in der offenen Rohrverbindung',
   description_fr = 'Cafards dans l’assemblage ouvert',
   description_it = 'Scarafaggi in un giunto aperto',
   description_ro = '',
   display_en = 'BBHBC',
   display_de = 'BBHBC',
   display_fr = 'BBHBC',
   display_it = 'BBHBC',
   display_ro = 'BBHBC'
WHERE code =4040;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4041,4041) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHBZ',
   value_de = 'BBHBZ',
   value_fr = 'BBHBZ',
   value_it = 'BBHBZ',
   value_ro = 'BBHBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlake',
   description_de = 'Kakerlake',
   description_fr = 'Cafards',
   description_it = 'Scarafaggi in genere (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBHBZ',
   display_de = 'BBHBZ',
   display_fr = 'BBHBZ',
   display_it = 'BBHBZ',
   display_ro = 'BBHBZ'
WHERE code =4041;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4042,4042) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHZA',
   value_de = 'BBHZA',
   value_fr = 'BBHZA',
   value_it = 'BBHZA',
   value_ro = 'BBHZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier in der Rohrleitung',
   description_de = 'Tier in der Rohrleitung',
   description_fr = 'Animaux dans la canalisation',
   description_it = 'Animali nella tubazione (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBHZA',
   display_de = 'BBHZA',
   display_fr = 'BBHZA',
   display_it = 'BBHZA',
   display_ro = 'BBHZA'
WHERE code =4042;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4043,4043) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHZB',
   value_de = 'BBHZB',
   value_fr = 'BBHZB',
   value_it = 'BBHZB',
   value_ro = 'BBHZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier im Anschluss',
   description_de = 'Tier im Anschluss',
   description_fr = 'Animaux dans le raccordement',
   description_it = 'Animal in un allacciamento (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBHZB',
   display_de = 'BBHZB',
   display_fr = 'BBHZB',
   display_it = 'BBHZB',
   display_ro = 'BBHZB'
WHERE code =4043;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4044,4044) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHZC',
   value_de = 'BBHZC',
   value_fr = 'BBHZC',
   value_it = 'BBHZC',
   value_ro = 'BBHZC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier in der offenen Rohrverbindung',
   description_de = 'Tier in der offenen Rohrverbindung',
   description_fr = 'Animaux dans l’assemblage ouvert',
   description_it = 'Animali in un giunto aperto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBHZC',
   display_de = 'BBHZC',
   display_fr = 'BBHZC',
   display_it = 'BBHZC',
   display_ro = 'BBHZC'
WHERE code =4044;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4045,4045) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BBHZZ',
   value_de = 'BBHZZ',
   value_fr = 'BBHZZ',
   value_it = 'BBHZZ',
   value_ro = 'BBHZZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier',
   description_de = 'Tier',
   description_fr = 'Animaux',
   description_it = 'Animali in genere (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BBHZZ',
   display_de = 'BBHZZ',
   display_fr = 'BBHZZ',
   display_it = 'BBHZZ',
   display_ro = 'BBHZZ'
WHERE code =4045;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4046,4046) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAAA',
   value_de = 'BCAAA',
   value_fr = 'BCAAA',
   value_it = 'BCAAA',
   value_ro = 'BCAAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss mit Formstück',
   description_de = 'Anschluss mit Formstück',
   description_fr = 'Raccordement avec pièce préfabriquée',
   description_it = 'Allacciamento con pezzo prefabbricato',
   description_ro = '',
   display_en = 'BCAAA',
   display_de = 'BCAAA',
   display_fr = 'BCAAA',
   display_it = 'BCAAA',
   display_ro = ''
WHERE code =4046;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4047,4047) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAAB',
   value_de = 'BCAAB',
   value_fr = 'BCAAB',
   value_it = 'BCAAB',
   value_ro = 'BCAAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss mit Formstück verschlossen',
   description_de = 'Anschluss mit Formstück verschlossen',
   description_fr = 'Raccordement avec pièce préfabriquée fermée',
   description_it = 'Allacciamento con pezzo prefabbricato occluso',
   description_ro = '',
   display_en = 'BCAAB',
   display_de = 'BCAAB',
   display_fr = 'BCAAB',
   display_it = 'BCAAB',
   display_ro = ''
WHERE code =4047;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4048,4048) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCABA',
   value_de = 'BCABA',
   value_fr = 'BCABA',
   value_it = 'BCABA',
   value_ro = 'BCABA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sattelanschluss gebohrt',
   description_de = 'Sattelanschluss gebohrt ',
   description_fr = 'Piquage latéral carotté',
   description_it = 'Allacciamento a sella forato',
   description_ro = '',
   display_en = 'BCABA',
   display_de = 'BCABA',
   display_fr = 'BCABA',
   display_it = 'BCABA',
   display_ro = ''
WHERE code =4048;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4049,4049) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCABB',
   value_de = 'BCABB',
   value_fr = 'BCABB',
   value_it = 'BCABB',
   value_ro = 'BCABB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sattelanschluss gebohrt verschlossen',
   description_de = 'Sattelanschluss gebohrt verschlossen',
   description_fr = 'Piquage latéral carotté fermé',
   description_it = 'Allacciamento a sella forato occluso',
   description_ro = '',
   display_en = 'BCABB',
   display_de = 'BCABB',
   display_fr = 'BCABB',
   display_it = 'BCABB',
   display_ro = ''
WHERE code =4049;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4050,4050) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCACA',
   value_de = 'BCACA',
   value_fr = 'BCACA',
   value_it = 'BCACA',
   value_ro = 'BCACA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sattelanschluss eingespitzt',
   description_de = 'Sattelanschluss eingespitzt ',
   description_fr = 'Piquage latéral buriné',
   description_it = 'Allacciamento a sella aperto con punta e martello',
   description_ro = '',
   display_en = 'BCACA',
   display_de = 'BCACA',
   display_fr = 'BCACA',
   display_it = 'BCACA',
   display_ro = ''
WHERE code =4050;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4051,4051) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCACB',
   value_de = 'BCACB',
   value_fr = 'BCACB',
   value_it = 'BCACB',
   value_ro = 'BCACB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sattelanschluss eingespitzt verschlossen',
   description_de = 'Sattelanschluss eingespitzt verschlossen',
   description_fr = 'Piquage latéral buriné fermé',
   description_it = 'Allacciamento a sella aperto con punta e martello occluso',
   description_ro = '',
   display_en = 'BCACB',
   display_de = 'BCACB',
   display_fr = 'BCACB',
   display_it = 'BCACB',
   display_ro = ''
WHERE code =4051;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4052,4052) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCADA',
   value_de = 'BCADA',
   value_fr = 'BCADA',
   value_it = 'BCADA',
   value_ro = 'BCADA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss gebohrt ',
   description_de = 'Anschluss gebohrt ',
   description_fr = 'Raccordement carotté',
   description_it = 'Allacciamento forato',
   description_ro = '',
   display_en = 'BCADA',
   display_de = 'BCADA',
   display_fr = 'BCADA',
   display_it = 'BCADA',
   display_ro = ''
WHERE code =4052;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4053,4053) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCADB',
   value_de = 'BCADB',
   value_fr = 'BCADB',
   value_it = 'BCADB',
   value_ro = 'BCADB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss gebohrt verschlossen',
   description_de = 'Anschluss gebohrt verschlossen',
   description_fr = 'Raccordement carotté fermé',
   description_it = 'Allacciamento forato occluso',
   description_ro = '',
   display_en = 'BCADB',
   display_de = 'BCADB',
   display_fr = 'BCADB',
   display_it = 'BCADB',
   display_ro = ''
WHERE code =4053;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4054,4054) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAEA',
   value_de = 'BCAEA',
   value_fr = 'BCAEA',
   value_it = 'BCAEA',
   value_ro = 'BCAEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss eingespitzt ',
   description_de = 'Anschluss eingespitzt ',
   description_fr = 'Raccordement buriné',
   description_it = 'Allacciamento aperto con punta e martello',
   description_ro = '',
   display_en = 'BCAEA',
   display_de = 'BCAEA',
   display_fr = 'BCAEA',
   display_it = 'BCAEA',
   display_ro = ''
WHERE code =4054;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4055,4055) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAEB',
   value_de = 'BCAEB',
   value_fr = 'BCAEB',
   value_it = 'BCAEB',
   value_ro = 'BCAEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss eingespitzt verschlossen',
   description_de = 'Anschluss eingespitzt verschlossen',
   description_fr = 'Raccordement buriné fermé',
   description_it = 'Allacciamento aperto con punta e martello occluso',
   description_ro = '',
   display_en = 'BCAEB',
   display_de = 'BCAEB',
   display_fr = 'BCAEB',
   display_it = 'BCAEB',
   display_ro = ''
WHERE code =4055;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4056,4056) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAFA',
   value_de = 'BCAFA',
   value_fr = 'BCAFA',
   value_it = 'BCAFA',
   value_ro = 'BCAFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spezialanschluss ',
   description_de = 'Spezialanschluss ',
   description_fr = 'Raccord spécial',
   description_it = 'Allacciamento speciale',
   description_ro = '',
   display_en = 'BCAFA',
   display_de = 'BCAFA',
   display_fr = 'BCAFA',
   display_it = 'BCAFA',
   display_ro = ''
WHERE code =4056;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4057,4057) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAFB',
   value_de = 'BCAFB',
   value_fr = 'BCAFB',
   value_it = 'BCAFB',
   value_ro = 'BCAFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spezialanschluss verschlossen',
   description_de = 'Spezialanschluss verschlossen',
   description_fr = 'Raccord spécial fermé',
   description_it = 'Allacciamento speciale occluso',
   description_ro = '',
   display_en = 'BCAFB',
   display_de = 'BCAFB',
   display_fr = 'BCAFB',
   display_it = 'BCAFB',
   display_ro = ''
WHERE code =4057;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4058,4058) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAGA',
   value_de = 'BCAGA',
   value_fr = 'BCAGA',
   value_it = 'BCAGA',
   value_ro = 'BCAGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss unbekannter Bauart',
   description_de = 'Anschluss unbekannter Bauart ',
   description_fr = 'Type de raccord inconnu',
   description_it = 'Allacciamento del tipo sconosciuto',
   description_ro = '',
   display_en = 'BCAGA',
   display_de = 'BCAGA',
   display_fr = 'BCAGA',
   display_it = 'BCAGA',
   display_ro = ''
WHERE code =4058;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4059,4059) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAGB',
   value_de = 'BCAGB',
   value_fr = 'BCAGB',
   value_it = 'BCAGB',
   value_ro = 'BCAGB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss unbekannter Bauart verschlossen',
   description_de = 'Anschluss unbekannter Bauart verschlossen',
   description_fr = 'Type de raccord inconnu fermé',
   description_it = 'Allacciamento del tipo sconosciuto occluso',
   description_ro = '',
   display_en = 'BCAGB',
   display_de = 'BCAGB',
   display_fr = 'BCAGB',
   display_it = 'BCAGB',
   display_ro = ''
WHERE code =4059;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4060,4060) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAZA',
   value_de = 'BCAZA',
   value_fr = 'BCAZA',
   value_it = 'BCAZA',
   value_ro = 'BCAZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Anschluss',
   description_de = 'Andersartiger Anschluss ',
   description_fr = 'Raccordement autre',
   description_it = 'Altro tipo di allacciamento (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BCAZA',
   display_de = 'BCAZA',
   display_fr = 'BCAZA',
   display_it = 'BCAZA',
   display_ro = ''
WHERE code =4060;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4061,4061) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCAZB',
   value_de = 'BCAZB',
   value_fr = 'BCAZB',
   value_it = 'BCAZB',
   value_ro = 'BCAZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiger Anschluss verschlossen',
   description_de = 'Andersartiger Anschluss verschlossen',
   description_fr = 'Raccordement autre fermé',
   description_it = 'Altro tipo di allacciamento occluso (ulteriori dettagli sono richiesti nell’osserva- zione)',
   description_ro = '',
   display_en = 'BCAZB',
   display_de = 'BCAZB',
   display_fr = 'BCAZB',
   display_it = 'BCAZB',
   display_ro = ''
WHERE code =4061;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4062,4062) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBA',
   value_de = 'BCBA',
   value_fr = 'BCBA',
   value_it = 'BCBA',
   value_ro = 'BCBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, Rohr ausgetauscht',
   description_de = 'Reparatur, Rohr ausgetauscht',
   description_fr = 'Réparation, remplacement de la canalisation',
   description_it = 'Riparazione, sostituzione del tubo',
   description_ro = '',
   display_en = 'BCBA',
   display_de = 'BCBA',
   display_fr = 'BCBA',
   display_it = 'BCBA',
   display_ro = ''
WHERE code =4062;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4063,4063) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBB',
   value_de = 'BCBB',
   value_fr = 'BCBB',
   value_it = 'BCBB',
   value_ro = 'BCBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, örtlich begrenzte Innenauskleidung des Rohres',
   description_de = 'Reparatur, örtlich begrenzte Innenauskleidung des Rohres',
   description_fr = 'Réparation, revêtement intérieur localisé',
   description_it = 'Riparazione, rivestimento puntuale del tubo',
   description_ro = '',
   display_en = 'BCBB',
   display_de = 'BCBB',
   display_fr = 'BCBB',
   display_it = 'BCBB',
   display_ro = ''
WHERE code =4063;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4064,4064) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBC',
   value_de = 'BCBC',
   value_fr = 'BCBC',
   value_it = 'BCBC',
   value_ro = 'BCBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur,  Mörtelinjizierung',
   description_de = 'Reparatur,  Mörtelinjizierung',
   description_fr = 'Réparation, injection de mortier',
   description_it = 'Riparazione, iniezione di malta',
   description_ro = '',
   display_en = 'BCBC',
   display_de = 'BCBC',
   display_fr = 'BCBC',
   display_it = 'BCBC',
   display_ro = ''
WHERE code =4064;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4065,4065) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBD',
   value_de = 'BCBD',
   value_fr = 'BCBD',
   value_it = 'BCBD',
   value_ro = 'BCBD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur,  Injizierung',
   description_de = 'Reparatur,  Injizierung',
   description_fr = 'Réparation, injection',
   description_it = 'Riparazione, iniezioni di altri materiali di sigillatura',
   description_ro = '',
   display_en = 'BCBD',
   display_de = 'BCBD',
   display_fr = 'BCBD',
   display_it = 'BCBD',
   display_ro = ''
WHERE code =4065;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4066,4066) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBE',
   value_de = 'BCBE',
   value_fr = 'BCBE',
   value_it = 'BCBE',
   value_ro = 'BCBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Loch repariert',
   description_de = 'Loch repariert',
   description_fr = 'Trou réparé',
   description_it = 'Foro riparato',
   description_ro = '',
   display_en = 'BCBE',
   display_de = 'BCBE',
   display_fr = 'BCBE',
   display_it = 'BCBE',
   display_ro = ''
WHERE code =4066;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8868,8868) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBF',
   value_de = 'BCBF',
   value_fr = 'BCBF',
   value_it = 'BCBF',
   value_ro = 'BCBF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, örtlich begrenzte Innenauskleidung des Rohres',
   description_de = 'Reparatur, örtlich begrenzte Innenauskleidung des Rohres',
   description_fr = 'Réparation, revêtement intérieur du Raccordement localisé',
   description_it = 'Riparazione, rivestimento puntuale dell’allacciamento',
   description_ro = 'rrr_Reparatur, örtlich begrenzte Innenauskleidung des Rohres',
   display_en = 'BCBF',
   display_de = 'BCBF',
   display_fr = 'BCBF',
   display_it = 'BCBF',
   display_ro = ''
WHERE code =8868;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8869,8869) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBG',
   value_de = 'BCBG',
   value_fr = 'BCBG',
   value_it = 'BCBG',
   value_ro = 'BCBG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Reparatur des Anschlusses',
   description_de = 'Andersartige Reparatur des Anschlusses',
   description_fr = 'Autre réparation du raccordement',
   description_it = 'Diverso tipo di riparazione dell’allacciamento',
   description_ro = 'rrr_Andersartige Reparatur des Anschlusses',
   display_en = 'BCBG',
   display_de = 'BCBG',
   display_fr = 'BCBG',
   display_it = 'BCBG',
   display_ro = ''
WHERE code =8869;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4067,4067) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCBZ',
   value_de = 'BCBZ',
   value_fr = 'BCBZ',
   value_it = 'BCBZ',
   value_ro = 'BCBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Reparatur mit grabenlosem Verfahren',
   description_de = 'Andersartige Reparatur mit grabenlosem Verfahren',
   description_fr = 'Autre réparation sans tranchée',
   description_it = 'Metodo di riparazione non invasivo dell’allacciamento (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BCBZ',
   display_de = 'BCBZ',
   display_fr = 'BCBZ',
   display_it = 'BCBZ',
   display_ro = ''
WHERE code =4067;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4068,4068) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCAA',
   value_de = 'BCCAA',
   value_fr = 'BCCAA',
   value_it = 'BCCAA',
   value_ro = 'BCCAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach links oben',
   description_de = 'Bogen nach links oben',
   description_fr = 'Courbure vers la gauche et vers le haut',
   description_it = 'Curvatura a sinistra verso l’alto',
   description_ro = '',
   display_en = 'BCCAA',
   display_de = 'BCCAA',
   display_fr = 'BCCAA',
   display_it = 'BCCAA',
   display_ro = ''
WHERE code =4068;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4069,4069) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCAB',
   value_de = 'BCCAB',
   value_fr = 'BCCAB',
   value_it = 'BCCAB',
   value_ro = 'BCCAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach links unten ',
   description_de = 'Bogen nach links unten ',
   description_fr = 'Courbure vers la gauche et vers le bas',
   description_it = 'Curvatura a sinistra verso il basso',
   description_ro = '',
   display_en = 'BCCAB',
   display_de = 'BCCAB',
   display_fr = 'BCCAB',
   display_it = 'BCCAB',
   display_ro = ''
WHERE code =4069;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4070,4070) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCAY',
   value_de = 'BCCAY',
   value_fr = 'BCCAY',
   value_it = 'BCCAY',
   value_ro = 'BCCAY',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach links',
   description_de = 'Bogen nach links',
   description_fr = 'Courbure vers la gauche',
   description_it = 'Curvatura a sinistra',
   description_ro = '',
   display_en = 'BCCAY',
   display_de = 'BCCAY',
   display_fr = 'BCCAY',
   display_it = 'BCCAY',
   display_ro = ''
WHERE code =4070;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4071,4071) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCBA',
   value_de = 'BCCBA',
   value_fr = 'BCCBA',
   value_it = 'BCCBA',
   value_ro = 'BCCBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach rechts oben',
   description_de = 'Bogen nach rechts oben',
   description_fr = 'Courbure vers la droite et vers le haut',
   description_it = 'Curvatura a destra verso l’alto',
   description_ro = '',
   display_en = 'BCCBA',
   display_de = 'BCCBA',
   display_fr = 'BCCBA',
   display_it = 'BCCBA',
   display_ro = ''
WHERE code =4071;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4072,4072) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCBB',
   value_de = 'BCCBB',
   value_fr = 'BCCBB',
   value_it = 'BCCBB',
   value_ro = 'BCCBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach rechts unten',
   description_de = 'Bogen nach rechts unten',
   description_fr = 'Courbure vers la droite et vers le bas',
   description_it = 'Curvatura a destra verso il basso',
   description_ro = '',
   display_en = 'BCCBB',
   display_de = 'BCCBB',
   display_fr = 'BCCBB',
   display_it = 'BCCBB',
   display_ro = ''
WHERE code =4072;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4073,4073) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCBY',
   value_de = 'BCCBY',
   value_fr = 'BCCBY',
   value_it = 'BCCBY',
   value_ro = 'BCCBY',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach rechts',
   description_de = 'Bogen nach rechts',
   description_fr = 'Courbure vers la droite',
   description_it = 'Curvatura a destra',
   description_ro = '',
   display_en = 'BCCBY',
   display_de = 'BCCBY',
   display_fr = 'BCCBY',
   display_it = 'BCCBY',
   display_ro = ''
WHERE code =4073;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4074,4074) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCYA',
   value_de = 'BCCYA',
   value_fr = 'BCCYA',
   value_it = 'BCCYA',
   value_ro = 'BCCYA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach oben',
   description_de = 'Bogen nach oben',
   description_fr = 'Courbure vers le haut',
   description_it = 'Curvatura verso l’alto',
   description_ro = '',
   display_en = 'BCCYA',
   display_de = 'BCCYA',
   display_fr = 'BCCYA',
   display_it = 'BCCYA',
   display_ro = ''
WHERE code =4074;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4075,4075) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCCYB',
   value_de = 'BCCYB',
   value_fr = 'BCCYB',
   value_it = 'BCCYB',
   value_ro = 'BCCYB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bogen nach unten',
   description_de = 'Bogen nach unten',
   description_fr = 'Courbure vers le bas',
   description_it = 'Curvatura verso il basso',
   description_ro = '',
   display_en = 'BCCYB',
   display_de = 'BCCYB',
   display_fr = 'BCCYB',
   display_it = 'BCCYB',
   display_ro = ''
WHERE code =4075;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4076,4076) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCD',
   value_de = 'BCD',
   value_fr = 'BCD',
   value_it = 'BCD',
   value_ro = 'BCD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohranfang',
   description_de = 'Rohranfang',
   description_fr = 'Début de la canalisation',
   description_it = 'Inizio del tubo',
   description_ro = '',
   display_en = 'BCD',
   display_de = 'BCD',
   display_fr = 'BCD',
   display_it = 'BCD',
   display_ro = ''
WHERE code =4076;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8870,8870) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCDXP',
   value_de = 'BCDXP',
   value_fr = 'BCDXP',
   value_it = 'BCDXP',
   value_ro = 'BCDXP',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Distanzmessung Anfang',
   description_de = 'Distanzmessung Anfang',
   description_fr = 'Début de la mesure de distance',
   description_it = 'Misurazione della distanza, inizio',
   description_ro = 'rrr_Distanzmessung Anfang',
   display_en = 'BCDXP',
   display_de = 'BCDXP',
   display_fr = 'BCDXP',
   display_it = 'BCDXP',
   display_ro = ''
WHERE code =8870;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4077,4077) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCE',
   value_de = 'BCE',
   value_fr = 'BCE',
   value_it = 'BCE',
   value_ro = 'BCE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rohrende',
   description_de = 'Rohrende',
   description_fr = 'Fin de la canalisation',
   description_it = 'Fine del tubo',
   description_ro = '',
   display_en = 'BCE',
   display_de = 'BCE',
   display_fr = 'BCE',
   display_it = 'BCE',
   display_ro = ''
WHERE code =4077;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8871,8871) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BCEXP',
   value_de = 'BCEXP',
   value_fr = 'BCEXP',
   value_it = 'BCEXP',
   value_ro = 'BCEXP',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Distanzmessung Ende',
   description_de = 'Distanzmessung Ende',
   description_fr = 'Fin de la mesure de distance',
   description_it = 'Misurazione della distanza, fine',
   description_ro = 'rrr_Distanzmessung Ende',
   display_en = 'BCEXP',
   display_de = 'BCEXP',
   display_fr = 'BCEXP',
   display_it = 'BCEXP',
   display_ro = ''
WHERE code =8871;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4078,4078) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDA',
   value_de = 'BDA',
   value_fr = 'BDA',
   value_it = 'BDA',
   value_ro = 'BDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Allgemeinzustand, Fotobeispiel',
   description_de = 'Allgemeinzustand, Fotobeispiel',
   description_fr = 'Etat général, exemple de photo',
   description_it = 'Stato generale, esempio foto',
   description_ro = '',
   display_en = 'BDA',
   display_de = 'BDA',
   display_fr = 'BDA',
   display_it = 'BDA',
   display_ro = ''
WHERE code =4078;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4079,4079) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDB',
   value_de = 'BDB',
   value_fr = 'BDB',
   value_it = 'BDB',
   value_ro = 'BDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ <kein Text>',
   description_de = '<kein Text>',
   description_fr = '<aucun texte>',
   description_it = '<nessun testo>',
   description_ro = '',
   display_en = 'BDB',
   display_de = 'BDB',
   display_fr = 'BDB',
   display_it = 'BDB',
   display_ro = ''
WHERE code =4079;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4136,4136) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBA',
   value_de = 'BDBA',
   value_fr = 'BDBA',
   value_it = 'BDBA',
   value_ro = 'BDBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_A   Beginn TV-Untersuch (Vorgabe)',
   description_de = 'A   Beginn TV-Untersuch (Vorgabe)',
   description_fr = 'A Début de l’examen avec une caméra (norme)',
   description_it = 'A Inizio videoispezione (anticipo distanza)',
   description_ro = '',
   display_en = 'BDBA',
   display_de = 'BDBA',
   display_fr = 'BDBA',
   display_it = 'BDBA',
   display_ro = ''
WHERE code =4136;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4137,4137) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBB',
   value_de = 'BDBB',
   value_fr = 'BDBB',
   value_it = 'BDBB',
   value_ro = 'BDBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_B   Inspektion erst nach Reinigung möglich',
   description_de = 'B   Inspektion erst nach Reinigung möglich',
   description_fr = 'B Inspection possible seulement après nettoyage',
   description_it = 'B Ispezione possibile solo dopo pulizia',
   description_ro = '',
   display_en = 'BDBB',
   display_de = 'BDBB',
   display_fr = 'BDBB',
   display_it = 'BDBB',
   display_ro = ''
WHERE code =4137;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4138,4138) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBC',
   value_de = 'BDBC',
   value_fr = 'BDBC',
   value_it = 'BDBC',
   value_ro = 'BDBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_C   Inspektion erfolgt zu einem späteren Zeitpunkt',
   description_de = 'C   Inspektion erfolgt zu einem späteren Zeitpunkt',
   description_fr = 'C Inspection effectuée à une date ultérieure',
   description_it = 'C Ispezione segue in un momento successivo',
   description_ro = '',
   display_en = 'BDBC',
   display_de = 'BDBC',
   display_fr = 'BDBC',
   display_it = 'BDBC',
   display_ro = ''
WHERE code =4138;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4141,4141) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBF',
   value_de = 'BDBF',
   value_fr = 'BDBF',
   value_it = 'BDBF',
   value_ro = 'BDBF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_F    Inspektion erfolgt von der Gegenseite',
   description_de = 'F    Inspektion erfolgt von der Gegenseite',
   description_fr = 'F L’inspection se fait depuis l’autre côté',
   description_it = 'F Ispezione viene effettuata dal lato opposto',
   description_ro = '',
   display_en = 'BDBF',
   display_de = 'BDBF',
   display_fr = 'BDBF',
   display_it = 'BDBF',
   display_ro = ''
WHERE code =4141;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4142,4142) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBG',
   value_de = 'BDBG',
   value_fr = 'BDBG',
   value_it = 'BDBG',
   value_ro = 'BDBG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_G   Kamera nicht einsetzbar, Schacht durch ein Fahrzeug blockiert',
   description_de = 'G   Kamera nicht einsetzbar, Schacht durch ein Fahrzeug blockiert',
   description_fr = 'G Caméra non utilisable, regard de visite bloqué par un véhicule',
   description_it = 'G Videocamera non impiegabile, pozzetto bloccato da un veicolo',
   description_ro = '',
   display_en = 'BDBG',
   display_de = 'BDBG',
   display_fr = 'BDBG',
   display_it = 'BDBG',
   display_ro = ''
WHERE code =4142;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4143,4143) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBH',
   value_de = 'BDBH',
   value_fr = 'BDBH',
   value_it = 'BDBH',
   value_ro = 'BDBH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_H   Kamera nicht einsetzbar, Schacht nicht erreichbar',
   description_de = 'H   Kamera nicht einsetzbar, Schacht nicht erreichbar',
   description_fr = 'H Caméra non utilisable, regard de visite non accessible',
   description_it = 'H Videocamera non impiegabile, pozzetto non accessibile',
   description_ro = '',
   display_en = 'BDBH',
   display_de = 'BDBH',
   display_fr = 'BDBH',
   display_it = 'BDBH',
   display_ro = ''
WHERE code =4143;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4144,4144) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBI',
   value_de = 'BDBI',
   value_fr = 'BDBI',
   value_it = 'BDBI',
   value_ro = 'BDBI',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_I     Kamera nicht einsetzbar, Schacht kann nicht geöffnet werden',
   description_de = 'I     Kamera nicht einsetzbar, Schacht kann nicht geöffnet werden',
   description_fr = 'I Caméra non utilisable, regard de visite ne pouvant être ouvert',
   description_it = 'I Videocamera non impiegabile, pozzetto non può essere aperto',
   description_ro = '',
   display_en = 'BDBI',
   display_de = 'BDBI',
   display_fr = 'BDBI',
   display_it = 'BDBI',
   display_ro = ''
WHERE code =4144;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4145,4145) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBJ',
   value_de = 'BDBJ',
   value_fr = 'BDBJ',
   value_it = 'BDBJ',
   value_ro = 'BDBJ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_J   Kamera nicht einsetzbar',
   description_de = 'J   Kamera nicht einsetzbar',
   description_fr = 'J Caméra non utilisable',
   description_it = 'J Videocamera non impiegabile',
   description_ro = '',
   display_en = 'BDBJ',
   display_de = 'BDBJ',
   display_fr = 'BDBJ',
   display_it = 'BDBJ',
   display_ro = ''
WHERE code =4145;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8872,8872) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDBM',
   value_de = 'BDBM',
   value_fr = 'BDBM',
   value_it = 'BDBM',
   value_ro = 'BDBM',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_M   Inspektion von der Gegenseite nicht möglich',
   description_de = 'M   Inspektion von der Gegenseite nicht möglich',
   description_fr = 'M Inspection impossible depuis le côté opposé',
   description_it = 'M Ispezione dal lato opposto non possibile',
   description_ro = 'rrr_M   Inspektion von der Gegenseite nicht möglich',
   display_en = 'BDBM',
   display_de = 'BDBM',
   display_fr = 'BDBM',
   display_it = 'BDBM',
   display_ro = ''
WHERE code =8872;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8873,8873) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCAA',
   value_de = 'BDCAA',
   value_fr = 'BDCAA',
   value_it = 'BDCAA',
   value_ro = 'BDCAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Hindernis, Inspektionsziel erreicht',
   description_de = 'Abbruch der Inspektion, Hindernis, Inspektionsziel erreicht',
   description_fr = 'Inspection abandonnée, obstruction, objectif d’inspection atteint',
   description_it = 'Interruzione dell’ispezione, ostacolo, obiettivo ispezione raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Inspektionsziel erreicht',
   display_en = 'BDCAA',
   display_de = 'BDCAA',
   display_fr = 'BDCAA',
   display_it = 'BDCAA',
   display_ro = ''
WHERE code =8873;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8874,8874) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCAB',
   value_de = 'BDCAB',
   value_fr = 'BDCAB',
   value_it = 'BDCAB',
   value_ro = 'BDCAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Hindernis, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Abbruch der Inspektion, Hindernis, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Inspection abandonnée, obstruction, le client renonce à une inspection plus pous- sée',
   description_it = 'Interruzione dell’ispezione, ostacolo, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'BDCAB',
   display_de = 'BDCAB',
   display_fr = 'BDCAB',
   display_it = 'BDCAB',
   display_ro = ''
WHERE code =8874;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8875,8875) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCAC',
   value_de = 'BDCAC',
   value_fr = 'BDCAC',
   value_it = 'BDCAC',
   value_ro = 'BDCAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Hindernis, Gegenseite erreicht',
   description_de = 'Abbruch der Inspektion, Hindernis, Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, obstruction, côté opposé atteint',
   description_it = 'Interruzione dell’ispezione, ostacolo, lato opposto raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Gegenseite erreicht',
   display_en = 'BDCAC',
   display_de = 'BDCAC',
   display_fr = 'BDCAC',
   display_it = 'BDCAC',
   display_ro = ''
WHERE code =8875;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8876,8876) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCAD',
   value_de = 'BDCAD',
   value_fr = 'BDCAD',
   value_it = 'BDCAD',
   value_ro = 'BDCAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Hindernis, Gegenseite nicht erreicht',
   description_de = 'Abbruch der Inspektion, Hindernis, Gegenseite nicht erreicht',
   description_fr = 'Inspection abandonnée, obstruction, côté opposé non atteint',
   description_it = 'Interruzione dell’ispezione, ostacolo, lato opposto non raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Hindernis, Gegenseite nicht erreicht',
   display_en = 'BDCAD',
   display_de = 'BDCAD',
   display_fr = 'BDCAD',
   display_it = 'BDCAD',
   display_ro = ''
WHERE code =8876;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8877,8877) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCAE',
   value_de = 'BDCAE',
   value_fr = 'BDCAE',
   value_it = 'BDCAE',
   value_ro = 'BDCAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Hindernis, unklar, ob Gegenseite erreicht',
   description_de = 'Abbruch der Inspektion, Hindernis, unklar, ob Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, obstruction, pas clair si le côté opposé est atteint',
   description_it = 'Interruzione dell’ispezione, ostacolo, incerto, se lato opposto raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Hindernis, unklar, ob Gegenseite erreicht',
   display_en = 'BDCAE',
   display_de = 'BDCAE',
   display_fr = 'BDCAE',
   display_it = 'BDCAE',
   display_ro = ''
WHERE code =8877;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8878,8878) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCAZ',
   value_de = 'BDCAZ',
   value_fr = 'BDCAZ',
   value_it = 'BDCAZ',
   value_ro = 'BDCAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Hindernis',
   description_de = 'Abbruch der Inspektion, Hindernis',
   description_fr = 'Inspection abandonnée, obstruction',
   description_it = 'Interruzione dell’ispezione, ostacolo ulteriori dettagli sono richiesti nella nota',
   description_ro = 'rrr_Abbruch der Inspektion, Hindernis',
   display_en = 'BDCAZ',
   display_de = 'BDCAZ',
   display_fr = 'BDCAZ',
   display_it = 'BDCAZ',
   display_ro = ''
WHERE code =8878;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8879,8879) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCBA',
   value_de = 'BDCBA',
   value_fr = 'BDCBA',
   value_it = 'BDCBA',
   value_ro = 'BDCBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Inspektionsziel erreicht',
   description_de = 'Abbruch der Inspektion, hoher Wasserstand, Inspektionsziel erreicht',
   description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, objectif d’inspection atteint',
   description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, obiettivo ispezione raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Inspektionsziel erreicht',
   display_en = 'BDCBA',
   display_de = 'BDCBA',
   display_fr = 'BDCBA',
   display_it = 'BDCBA',
   display_ro = ''
WHERE code =8879;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8880,8880) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCBB',
   value_de = 'BDCBB',
   value_fr = 'BDCBB',
   value_it = 'BDCBB',
   value_ro = 'BDCBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Abbruch der Inspektion, hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, le client renonce à une inspection plus poussée',
   description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'BDCBB',
   display_de = 'BDCBB',
   display_fr = 'BDCBB',
   display_it = 'BDCBB',
   display_ro = ''
WHERE code =8880;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8881,8881) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCBC',
   value_de = 'BDCBC',
   value_fr = 'BDCBC',
   value_it = 'BDCBC',
   value_ro = 'BDCBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Gegenseite erreicht',
   description_de = 'Abbruch der Inspektion, hoher Wasserstand, Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, côté opposé atteint',
   description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, lato opposto raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Gegenseite erreicht',
   display_en = 'BDCBC',
   display_de = 'BDCBC',
   display_fr = 'BDCBC',
   display_it = 'BDCBC',
   display_ro = ''
WHERE code =8881;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8882,8882) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCBD',
   value_de = 'BDCBD',
   value_fr = 'BDCBD',
   value_it = 'BDCBD',
   value_ro = 'BDCBD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, Gegenseite nicht erreicht',
   description_de = 'Abbruch der Inspektion, hoher Wasserstand, Gegenseite nicht erreicht',
   description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, côté opposé non atteint',
   description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, lato opposto non raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, Gegenseite nicht erreicht',
   display_en = 'BDCBD',
   display_de = 'BDCBD',
   display_fr = 'BDCBD',
   display_it = 'BDCBD',
   display_ro = ''
WHERE code =8882;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8883,8883) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCBE',
   value_de = 'BDCBE',
   value_fr = 'BDCBE',
   value_it = 'BDCBE',
   value_ro = 'BDCBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand, unklar, ob Gegenseite erreicht',
   description_de = 'Abbruch der Inspektion, hoher Wasserstand, unklar, ob Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, niveau d’eau trop élevé, pas clair si le côté opposé est atteint',
   description_it = 'Interruzione dell’ispezione, livello dell’acqua alto, incerto, se lato opposto raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand, unklar, ob Gegenseite erreicht',
   display_en = 'BDCBE',
   display_de = 'BDCBE',
   display_fr = 'BDCBE',
   display_it = 'BDCBE',
   display_ro = ''
WHERE code =8883;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8884,8884) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCBZ',
   value_de = 'BDCBZ',
   value_fr = 'BDCBZ',
   value_it = 'BDCBZ',
   value_ro = 'BDCBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, hoher Wasserstand',
   description_de = 'Abbruch der Inspektion, hoher Wasserstand',
   description_fr = 'Inspection abandonnée, niveau d’eau trop élevé (plus de détails requis dans la note)',
   description_it = 'Interruzione dell’ispezione, livello dell’acqua alto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Abbruch der Inspektion, hoher Wasserstand',
   display_en = 'BDCBZ',
   display_de = 'BDCBZ',
   display_fr = 'BDCBZ',
   display_it = 'BDCBZ',
   display_ro = ''
WHERE code =8884;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8885,8885) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCCA',
   value_de = 'BDCCA',
   value_fr = 'BDCCA',
   value_it = 'BDCCA',
   value_ro = 'BDCCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Inspektionsziel erreicht',
   description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Inspektionsziel erreicht',
   description_fr = 'Inspection abandonnée, caméra défectueuse, objectif d’inspection atteint',
   description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, obiettivo ispezione raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Inspektionsziel erreicht',
   display_en = 'BDCCA',
   display_de = 'BDCCA',
   display_fr = 'BDCCA',
   display_it = 'BDCCA',
   display_ro = ''
WHERE code =8885;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8886,8886) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCCB',
   value_de = 'BDCCB',
   value_fr = 'BDCCB',
   value_it = 'BDCCB',
   value_ro = 'BDCCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Inspection abandonnée, caméra défectueuse, le client renonce à une inspection plus poussée',
   description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'BDCCB',
   display_de = 'BDCCB',
   display_fr = 'BDCCB',
   display_it = 'BDCCB',
   display_ro = ''
WHERE code =8886;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8887,8887) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCCC',
   value_de = 'BDCCC',
   value_fr = 'BDCCC',
   value_it = 'BDCCC',
   value_ro = 'BDCCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite erreicht',
   description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, caméra défectueuse, côté opposé atteint',
   description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, lato opposto raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite erreicht',
   display_en = 'BDCCC',
   display_de = 'BDCCC',
   display_fr = 'BDCCC',
   display_it = 'BDCCC',
   display_ro = ''
WHERE code =8887;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8888,8888) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCCD',
   value_de = 'BDCCD',
   value_fr = 'BDCCD',
   value_it = 'BDCCD',
   value_ro = 'BDCCD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite nicht erreicht',
   description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite nicht erreicht',
   description_fr = 'Inspection abandonnée, caméra défectueuse, côté opposé non atteint',
   description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, lato opposto non raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, Gegenseite nicht erreicht',
   display_en = 'BDCCD',
   display_de = 'BDCCD',
   display_fr = 'BDCCD',
   display_it = 'BDCCD',
   display_ro = ''
WHERE code =8888;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8889,8889) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCCE',
   value_de = 'BDCCE',
   value_fr = 'BDCCE',
   value_it = 'BDCCE',
   value_ro = 'BDCCE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung, unklar, ob Gegenseite erreicht',
   description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung, unklar, ob Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, caméra défectueuse, pas clair si le côté opposé est atteint',
   description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature, incerto, se lato opposto raggiunto',
   description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung, unklar, ob Gegenseite erreicht',
   display_en = 'BDCCE',
   display_de = 'BDCCE',
   display_fr = 'BDCCE',
   display_it = 'BDCCE',
   display_ro = ''
WHERE code =8889;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8890,8890) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCCZ',
   value_de = 'BDCCZ',
   value_fr = 'BDCCZ',
   value_it = 'BDCCZ',
   value_ro = 'BDCCZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abbruch der Inspektion, Versagen der Ausrüstung',
   description_de = 'Abbruch der Inspektion, Versagen der Ausrüstung',
   description_fr = 'Inspection abandonnée, caméra défectueuse, (plus de détails requis dans la note)',
   description_it = 'Interruzione dell’ispezione, guasto alle apparecchiature (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Abbruch der Inspektion, Versagen der Ausrüstung',
   display_en = 'BDCCZ',
   display_de = 'BDCCZ',
   display_fr = 'BDCCZ',
   display_it = 'BDCCZ',
   display_ro = ''
WHERE code =8890;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8891,8891) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCZA',
   value_de = 'BDCZA',
   value_fr = 'BDCZA',
   value_it = 'BDCZA',
   value_ro = 'BDCZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Inspektionsziel erreicht',
   description_de = 'Anderer Grund für Abbruch der Inspektion, Inspektionsziel erreicht',
   description_fr = 'Inspection abandonnée, autre raison ; (plus de détails requis dans la note)',
   description_it = 'Altro motivo per l’interruzione dell’ispezione, obiettivo ispezione raggiunto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Inspektionsziel erreicht',
   display_en = 'BDCZA',
   display_de = 'BDCZA',
   display_fr = 'BDCZA',
   display_it = 'BDCZA',
   display_ro = ''
WHERE code =8891;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8892,8892) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCZB',
   value_de = 'BDCZB',
   value_fr = 'BDCZB',
   value_it = 'BDCZB',
   value_ro = 'BDCZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Anderer Grund für Abbruch der Inspektion, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Inspection abandonnée, autre raison , le client s’abstient de toute autre inspec- tion, (plus de détails requis dans la note)',
   description_it = 'Altro motivo per l’interruzione dell’ispezione, il committente rinuncia a ulteriore ispezione (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'BDCZB',
   display_de = 'BDCZB',
   display_fr = 'BDCZB',
   display_it = 'BDCZB',
   display_ro = ''
WHERE code =8892;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8893,8893) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCZC',
   value_de = 'BDCZC',
   value_fr = 'BDCZC',
   value_it = 'BDCZC',
   value_ro = 'BDCZC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Gegenseite erreicht',
   description_de = 'Anderer Grund für Abbruch der Inspektion, Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, autre raison, côté opposé atteint (plus de détails requis dans la note)',
   description_it = 'Altro motivo per l’interruzione dell’ispezione, lato opposto raggiunto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Gegenseite erreicht',
   display_en = 'BDCZC',
   display_de = 'BDCZC',
   display_fr = 'BDCZC',
   display_it = 'BDCZC',
   display_ro = ''
WHERE code =8893;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8894,8894) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCZD',
   value_de = 'BDCZD',
   value_fr = 'BDCZD',
   value_it = 'BDCZD',
   value_ro = 'BDCZD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, Gegenseite nicht erreicht',
   description_de = 'Anderer Grund für Abbruch der Inspektion, Gegenseite nicht erreicht',
   description_fr = 'Inspection abandonnée, autre raison, côté opposé non atteint (plus de détails requis dans la note)',
   description_it = 'Altro motivo per l’interruzione dell’ispezione, lato opposto non raggiunto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, Gegenseite nicht erreicht',
   display_en = 'BDCZD',
   display_de = 'BDCZD',
   display_fr = 'BDCZD',
   display_it = 'BDCZD',
   display_ro = ''
WHERE code =8894;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8895,8895) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCZE',
   value_de = 'BDCZE',
   value_fr = 'BDCZE',
   value_it = 'BDCZE',
   value_ro = 'BDCZE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Grund für Abbruch der Inspektion, unklar, ob Gegenseite erreicht',
   description_de = 'Anderer Grund für Abbruch der Inspektion, unklar, ob Gegenseite erreicht',
   description_fr = 'Inspection abandonnée, autre raison, pas clair si le côté opposé est atteint (plus de détails requis dans la note)',
   description_it = 'Altro motivo per l’interruzione dell’ispezione, incerto, se lato opposto raggiunto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion, unklar, ob Gegenseite erreicht',
   display_en = 'BDCZE',
   display_de = 'BDCZE',
   display_fr = 'BDCZE',
   display_it = 'BDCZE',
   display_ro = ''
WHERE code =8895;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8896,8896) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDCZZ',
   value_de = 'BDCZZ',
   value_fr = 'BDCZZ',
   value_it = 'BDCZZ',
   value_ro = 'BDCZZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Grund für Abbruch der Inspektion,',
   description_de = 'Anderer Grund für Abbruch der Inspektion,',
   description_fr = 'Inspection abandonnée, autre raison, (plus de détails requis dans la note)',
   description_it = 'Altro motivo per l’interruzione dell’ispezione (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Grund für Abbruch der Inspektion,',
   display_en = 'BDCZZ',
   display_de = 'BDCZZ',
   display_fr = 'BDCZZ',
   display_it = 'BDCZZ',
   display_ro = ''
WHERE code =8896;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4084,4084) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDDA',
   value_de = 'BDDA',
   value_fr = 'BDDA',
   value_it = 'BDDA',
   value_ro = 'BDDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasserspiegel, Abwasser klar',
   description_de = 'Wasserspiegel, Abwasser klar',
   description_fr = 'Niveau d’eau, effluent clair',
   description_it = 'Livello dell’acqua, acque reflue chiare',
   description_ro = '',
   display_en = 'BDDA',
   display_de = 'BDDA',
   display_fr = 'BDDA',
   display_it = 'BDDA',
   display_ro = ''
WHERE code =4084;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8897,8897) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDDC',
   value_de = 'BDDC',
   value_fr = 'BDDC',
   value_it = 'BDDC',
   value_ro = 'BDDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasserspiegel, Abwasser trüb',
   description_de = 'Wasserspiegel, Abwasser trüb',
   description_fr = 'Niveau d’eau, effluent trouble',
   description_it = 'Livello dell’acqua, acque reflue torbide',
   description_ro = 'rrr_Wasserspiegel, Abwasser trüb',
   display_en = 'BDDC',
   display_de = 'BDDC',
   display_fr = 'BDDC',
   display_it = 'BDDC',
   display_ro = ''
WHERE code =8897;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8898,8898) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDDD',
   value_de = 'BDDD',
   value_fr = 'BDDD',
   value_it = 'BDDD',
   value_ro = 'BDDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasserspiegel, Abwasser gefärbt',
   description_de = 'Wasserspiegel, Abwasser gefärbt',
   description_fr = 'Niveau d’eau, effluent coloré',
   description_it = 'Livello dell’acqua, acque reflue colorate',
   description_ro = 'rrr_Wasserspiegel, Abwasser gefärbt',
   display_en = 'BDDD',
   display_de = 'BDDD',
   display_fr = 'BDDD',
   display_it = 'BDDD',
   display_ro = ''
WHERE code =8898;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8899,8899) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDDE',
   value_de = 'BDDE',
   value_fr = 'BDDE',
   value_it = 'BDDE',
   value_ro = 'BDDE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Wasserspiegel, Abwasser trüb und gefärbt',
   description_de = 'Wasserspiegel, Abwasser trüb und gefärbt',
   description_fr = 'Niveau d’eau, effluent trouble et coloré',
   description_it = 'Livello dell’acqua, acque reflue torbide e colorate',
   description_ro = 'rrr_Wasserspiegel, Abwasser trüb und gefärbt',
   display_en = 'BDDE',
   display_de = 'BDDE',
   display_fr = 'BDDE',
   display_it = 'BDDE',
   display_ro = ''
WHERE code =8899;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4086,4086) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEAA',
   value_de = 'BDEAA',
   value_fr = 'BDEAA',
   value_it = 'BDEAA',
   value_ro = 'BDEAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasser',
   description_de = 'Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasser',
   description_fr = 'Mauvais raccordement, arrivées d’eaux claires, des eaux usées se déversent dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue limpido, acque reflue entrano in acque meteoriche',
   description_ro = '',
   display_en = 'BDEAA',
   display_de = 'BDEAA',
   display_fr = 'BDEAA',
   display_it = 'BDEAA',
   display_ro = ''
WHERE code =4086;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4087,4087) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEAB',
   value_de = 'BDEAB',
   value_fr = 'BDEAB',
   value_it = 'BDEAB',
   value_ro = 'BDEAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasser',
   description_de = 'Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasser ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux claires, des eaux pluviales se déversent dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue limpido, acque meteoriche entrano in acque reflue',
   description_ro = '',
   display_en = 'BDEAB',
   display_de = 'BDEAB',
   display_fr = 'BDEAB',
   display_it = 'BDEAB',
   display_ro = ''
WHERE code =4087;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4088,4088) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEAC',
   value_de = 'BDEAC',
   value_fr = 'BDEAC',
   value_it = 'BDEAC',
   value_ro = 'BDEAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss klar',
   description_de = 'Abwasserzufluss klar',
   description_fr = 'Arrivées d’eaux claires',
   description_it = 'Afflusso acque reflue limpido',
   description_ro = '',
   display_en = 'BDEAC',
   display_de = 'BDEAC',
   display_fr = 'BDEAC',
   display_it = 'BDEAC',
   display_ro = ''
WHERE code =4088;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8900,8900) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDECA',
   value_de = 'BDECA',
   value_fr = 'BDECA',
   value_it = 'BDECA',
   value_ro = 'BDECA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasser',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasser',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, des eaux usées se déversent dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue torbido, acque reflue entrano in acque meteoriche',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasser',
   display_en = 'BDECA',
   display_de = 'BDECA',
   display_fr = 'BDECA',
   display_it = 'BDECA',
   display_ro = ''
WHERE code =8900;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8901,8901) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDECB',
   value_de = 'BDECB',
   value_fr = 'BDECB',
   value_it = 'BDECB',
   value_ro = 'BDECB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasser ',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasser ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, des eaux pluviales se déversent dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue torbido, acque meteoriche entrano in acque reflue',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasser ',
   display_en = 'BDECB',
   display_de = 'BDECB',
   display_fr = 'BDECB',
   display_it = 'BDECB',
   display_ro = ''
WHERE code =8901;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8902,8902) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDECC',
   value_de = 'BDECC',
   value_fr = 'BDECC',
   value_it = 'BDECC',
   value_ro = 'BDECC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss trüb',
   description_de = 'Abwasserzufluss trüb',
   description_fr = 'Arrivées d’eaux troubles',
   description_it = 'Afflusso acque reflue torbido',
   description_ro = 'rrr_Abwasserzufluss trüb',
   display_en = 'BDECC',
   display_de = 'BDECC',
   display_fr = 'BDECC',
   display_it = 'BDECC',
   display_ro = ''
WHERE code =8902;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8903,8903) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEDA',
   value_de = 'BDEDA',
   value_fr = 'BDEDA',
   value_it = 'BDEDA',
   value_ro = 'BDEDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasser',
   description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasser',
   description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux usées se déversent dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue colorato, acque reflue entrano in acque meteoriche',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasser',
   display_en = 'BDEDA',
   display_de = 'BDEDA',
   display_fr = 'BDEDA',
   display_it = 'BDEDA',
   display_ro = ''
WHERE code =8903;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8904,8904) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEDB',
   value_de = 'BDEDB',
   value_fr = 'BDEDB',
   value_it = 'BDEDB',
   value_ro = 'BDEDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasser ',
   description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasser ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux pluviales se déversent dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue colorato, acque meteoriche entrano in acque reflue',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasser ',
   display_en = 'BDEDB',
   display_de = 'BDEDB',
   display_fr = 'BDEDB',
   display_it = 'BDEDB',
   display_ro = ''
WHERE code =8904;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8905,8905) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEDC',
   value_de = 'BDEDC',
   value_fr = 'BDEDC',
   value_it = 'BDEDC',
   value_ro = 'BDEDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss gefärbt',
   description_de = 'Abwasserzufluss gefärbt',
   description_fr = 'Arrivées d’eaux troubles et colorées',
   description_it = 'Afflusso acque reflue colorato',
   description_ro = 'rrr_Abwasserzufluss gefärbt',
   display_en = 'BDEDC',
   display_de = 'BDEDC',
   display_fr = 'BDEDC',
   display_it = 'BDEDC',
   display_ro = ''
WHERE code =8905;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8906,8906) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEEA',
   value_de = 'BDEEA',
   value_fr = 'BDEEA',
   value_it = 'BDEEA',
   value_ro = 'BDEEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasser',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasser',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux usées se déversent dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque reflue entrano in acque meteoriche',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasser',
   display_en = 'BDEEA',
   display_de = 'BDEEA',
   display_fr = 'BDEEA',
   display_it = 'BDEEA',
   display_ro = ''
WHERE code =8906;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8907,8907) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEEB',
   value_de = 'BDEEB',
   value_fr = 'BDEEB',
   value_it = 'BDEEB',
   value_ro = 'BDEEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasser ',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasser ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux pluviales se déversent dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque meteoriche entrano in acque reflue',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasser ',
   display_en = 'BDEEB',
   display_de = 'BDEEB',
   display_fr = 'BDEEB',
   display_it = 'BDEEB',
   display_ro = ''
WHERE code =8907;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (8908,8908) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEEC',
   value_de = 'BDEEC',
   value_fr = 'BDEEC',
   value_it = 'BDEEC',
   value_ro = 'BDEEC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss trüb und gefärbt',
   description_de = 'Abwasserzufluss trüb und gefärbt',
   description_fr = 'Arrivées d’eaux troubles et colorées',
   description_it = 'Afflusso acque reflue torbido e colorato',
   description_ro = 'rrr_Abwasserzufluss trüb und gefärbt',
   display_en = 'BDEEC',
   display_de = 'BDEEC',
   display_fr = 'BDEEC',
   display_it = 'BDEEC',
   display_ro = ''
WHERE code =8908;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4092,4092) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEYA',
   value_de = 'BDEYA',
   value_fr = 'BDEYA',
   value_it = 'BDEYA',
   value_ro = 'BDEYA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Schmutzabwasser fliesst in Regenabwasser',
   description_de = 'Fehlanschluss, Schmutzabwasser fliesst in Regenabwasser',
   description_fr = 'Mauvais raccordement, des eaux usées se déversent dans les eaux pluviales',
   description_it = 'Collegamento errato, acque reflue entrano in acque meteoriche',
   description_ro = '',
   display_en = 'BDEYA',
   display_de = 'BDEYA',
   display_fr = 'BDEYA',
   display_it = 'BDEYA',
   display_ro = ''
WHERE code =4092;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4093,4093) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEYB',
   value_de = 'BDEYB',
   value_fr = 'BDEYB',
   value_it = 'BDEYB',
   value_ro = 'BDEYB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Regenabwasser fliesst in Schmutzabwasser',
   description_de = 'Fehlanschluss, Regenabwasser fliesst in Schmutzabwasser',
   description_fr = 'Mauvais raccordement, les eaux de surface se déversent dans les eaux usées',
   description_it = 'Collegamento errato, acque meteoriche entrano in acque reflue',
   description_ro = '',
   display_en = 'BDEYB',
   display_de = 'BDEYB',
   display_fr = 'BDEYB',
   display_it = 'BDEYB',
   display_ro = ''
WHERE code =4093;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4094,4094) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDEYY',
   value_de = 'BDEYY',
   value_fr = 'BDEYY',
   value_it = 'BDEYY',
   value_ro = 'BDEYY',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss',
   description_de = 'Abwasserzufluss',
   description_fr = 'Arrivée d’eaux usées',
   description_it = 'Afflusso acque reflue',
   description_ro = '',
   display_en = 'BDEYY',
   display_de = 'BDEYY',
   display_fr = 'BDEYY',
   display_it = 'BDEYY',
   display_ro = ''
WHERE code =4094;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4095,4095) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDFA',
   value_de = 'BDFA',
   value_fr = 'BDFA',
   value_it = 'BDFA',
   value_ro = 'BDFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gefährdung vorhanden: Sauerstoffmangel',
   description_de = 'Gefährdung vorhanden: Sauerstoffmangel',
   description_fr = 'Danger existant: manque d’oxygène',
   description_it = 'Atmosfera pericolosa: mancanza di ossigeno',
   description_ro = '',
   display_en = 'BDFA',
   display_de = 'BDFA',
   display_fr = 'BDFA',
   display_it = 'BDFA',
   display_ro = ''
WHERE code =4095;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4096,4096) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDFB',
   value_de = 'BDFB',
   value_fr = 'BDFB',
   value_it = 'BDFB',
   value_ro = 'BDFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gefährdung vorhanden: Schwefelwasserstoff',
   description_de = 'Gefährdung vorhanden: Schwefelwasserstoff',
   description_fr = 'Danger existant: hydrogène sulfuré',
   description_it = 'Atmosfera pericolosa: idrogeno solforato',
   description_ro = '',
   display_en = 'BDFB',
   display_de = 'BDFB',
   display_fr = 'BDFB',
   display_it = 'BDFB',
   display_ro = ''
WHERE code =4096;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4097,4097) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDFC',
   value_de = 'BDFC',
   value_fr = 'BDFC',
   value_it = 'BDFC',
   value_ro = 'BDFC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gefährdung vorhanden:  Methan',
   description_de = 'Gefährdung vorhanden:  Methan',
   description_fr = 'Danger existant: méthane',
   description_it = 'Atmosfera pericolosa: metano',
   description_ro = '',
   display_en = 'BDFC',
   display_de = 'BDFC',
   display_fr = 'BDFC',
   display_it = 'BDFC',
   display_ro = ''
WHERE code =4097;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4098,4098) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDFZ',
   value_de = 'BDFZ',
   value_fr = 'BDFZ',
   value_it = 'BDFZ',
   value_ro = 'BDFZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Gefährdung vorhanden',
   description_de = 'Andersartige Gefährdung vorhanden',
   description_fr = 'Autres Danger existant',
   description_it = 'Altri pericoli (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BDFZ',
   display_de = 'BDFZ',
   display_fr = 'BDFZ',
   display_it = 'BDFZ',
   display_ro = ''
WHERE code =4098;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4099,4099) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDGA',
   value_de = 'BDGA',
   value_fr = 'BDGA',
   value_it = 'BDGA',
   value_ro = 'BDGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, Kamera unter Wasser',
   description_de = 'Keine Sicht, Kamera unter Wasser',
   description_fr = 'Visibilité nulle, caméra sous l’eau',
   description_it = 'Nessuna visibilità, telecamera immersa',
   description_ro = '',
   display_en = 'BDGA',
   display_de = 'BDGA',
   display_fr = 'BDGA',
   display_it = 'BDGA',
   display_ro = ''
WHERE code =4099;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4100,4100) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDGB',
   value_de = 'BDGB',
   value_fr = 'BDGB',
   value_it = 'BDGB',
   value_ro = 'BDGB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, Verschlammung',
   description_de = 'Keine Sicht, Verschlammung',
   description_fr = 'Visibilité nulle, envasement',
   description_it = 'Nessuna visibilità, deposito fangoso',
   description_ro = '',
   display_en = 'BDGB',
   display_de = 'BDGB',
   display_fr = 'BDGB',
   display_it = 'BDGB',
   display_ro = ''
WHERE code =4100;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4101,4101) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDGC',
   value_de = 'BDGC',
   value_fr = 'BDGC',
   value_it = 'BDGC',
   value_ro = 'BDGC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, Dampf',
   description_de = 'Keine Sicht, Dampf',
   description_fr = 'Visibilité nulle, vapeur',
   description_it = 'Nessuna visibilità, vapore',
   description_ro = '',
   display_en = 'BDGC',
   display_de = 'BDGC',
   display_fr = 'BDGC',
   display_it = 'BDGC',
   display_ro = ''
WHERE code =4101;
--- Adapt tww_vl.damage_channel_channel_damage_code
 INSERT INTO tww_vl.damage_channel_channel_damage_code (code, vsacode) VALUES (4102,4102) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_channel_channel_damage_code SET
   value_en = 'BDGZ',
   value_de = 'BDGZ',
   value_fr = 'BDGZ',
   value_it = 'BDGZ',
   value_ro = 'BDGZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, anderer Grund',
   description_de = 'Keine Sicht, anderer Grund',
   description_fr = 'Visibilité nulle, autre raison ',
   description_it = 'Nessuna visibilità, altri motivi (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'BDGZ',
   display_de = 'BDGZ',
   display_fr = 'BDGZ',
   display_it = 'BDGZ',
   display_ro = ''
WHERE code =4102;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4148,4148) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAAA',
   value_de = 'DAAA',
   value_fr = 'DAAA',
   value_it = 'DAAA',
   value_ro = 'DAAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Allgemeine Verformung',
   description_de = 'Allgemeine Verformung',
   description_fr = 'Déformation générale',
   description_it = 'Deformazione generale',
   description_ro = '',
   display_en = 'DAAA',
   display_de = 'DAAA',
   display_fr = 'DAAA',
   display_it = 'DAAA',
   display_ro = 'DAAA'
WHERE code =4148;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4149,4149) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAAB',
   value_de = 'DAAB',
   value_fr = 'DAAB',
   value_it = 'DAAB',
   value_ro = 'DAAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Punktuelle Verformung',
   description_de = 'Punktuelle Verformung',
   description_fr = 'Déformation localisée',
   description_it = 'Deformazione puntuale',
   description_ro = '',
   display_en = 'DAAB',
   display_de = 'DAAB',
   display_fr = 'DAAB',
   display_it = 'DAAB',
   display_ro = 'DAAB'
WHERE code =4149;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4150,4150) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABAA',
   value_de = 'DABAA',
   value_fr = 'DABAA',
   value_it = 'DABAA',
   value_ro = 'DABAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss) vertikal',
   description_de = 'Oberflächenriss (Haarriss) vertikal',
   description_fr = 'Fissure superficielle (micro-fissure) verticale',
   description_it = 'Fessura superficiale (fessura capillare) verticale',
   description_ro = '',
   display_en = 'DABAA',
   display_de = 'DABAA',
   display_fr = 'DABAA',
   display_it = 'DABAA',
   display_ro = 'DABAA'
WHERE code =4150;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4151,4151) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABAB',
   value_de = 'DABAB',
   value_fr = 'DABAB',
   value_it = 'DABAB',
   value_ro = 'DABAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss) horizontal',
   description_de = 'Oberflächenriss (Haarriss) horizontal',
   description_fr = 'Fissure superficielle (micro-fissure) horizontale',
   description_it = 'Fessura superficiale (fessura capillare), orizzontale',
   description_ro = '',
   display_en = 'DABAB',
   display_de = 'DABAB',
   display_fr = 'DABAB',
   display_it = 'DABAB',
   display_ro = 'DABAB'
WHERE code =4151;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4152,4152) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABAC',
   value_de = 'DABAC',
   value_fr = 'DABAC',
   value_it = 'DABAC',
   value_ro = 'DABAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss), komplexe Rissbildung',
   description_de = 'Oberflächenriss (Haarriss), komplexe Rissbildung',
   description_fr = 'Fissure superficielle (micro-fissure), formation complexe de fissures',
   description_it = 'Fessura superficiale (fessura capillare), fessurazione complessa',
   description_ro = '',
   display_en = 'DABAC',
   display_de = 'DABAC',
   display_fr = 'DABAC',
   display_it = 'DABAC',
   display_ro = 'DABAC'
WHERE code =4152;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4153,4153) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABAD',
   value_de = 'DABAD',
   value_fr = 'DABAD',
   value_it = 'DABAD',
   value_ro = 'DABAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss), geneigte Rissbildung',
   description_de = 'Oberflächenriss (Haarriss), geneigte Rissbildung',
   description_fr = 'Fissure superficielle (micro-fissure), formation inclinée de fissures',
   description_it = 'Fessura superficiale (fessura capillare), fessurazione inclinata',
   description_ro = '',
   display_en = 'DABAD',
   display_de = 'DABAD',
   display_fr = 'DABAD',
   display_it = 'DABAD',
   display_ro = 'DABAD'
WHERE code =4153;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8909,8909) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABAE',
   value_de = 'DABAE',
   value_fr = 'DABAE',
   value_it = 'DABAE',
   value_ro = 'DABAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Oberflächenriss (Haarriss), sternförmig Rissbildung',
   description_de = 'Oberflächenriss (Haarriss), sternförmig Rissbildung',
   description_fr = 'Fissure superficielle (microfissure), fissuration en étoile',
   description_it = 'Fessura superficiale (fessura capillare), fessurazione a stella',
   description_ro = 'rrr_Oberflächenriss (Haarriss), sternförmig Rissbildung',
   display_en = 'DABAE',
   display_de = 'DABAE',
   display_fr = 'DABAE',
   display_it = 'DABAE',
   display_ro = 'DABAE'
WHERE code =8909;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4154,4154) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABBA',
   value_de = 'DABBA',
   value_fr = 'DABBA',
   value_it = 'DABBA',
   value_ro = 'DABBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss vertikal',
   description_de = 'Riss vertikal',
   description_fr = 'Fissure verticale',
   description_it = 'Spaccatura verticale',
   description_ro = '',
   display_en = 'DABBA',
   display_de = 'DABBA',
   display_fr = 'DABBA',
   display_it = 'DABBA',
   display_ro = 'DABBA'
WHERE code =4154;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4155,4155) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABBB',
   value_de = 'DABBB',
   value_fr = 'DABBB',
   value_it = 'DABBB',
   value_ro = 'DABBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss horizontal',
   description_de = 'Riss horizontal',
   description_fr = 'Fissure horizontale',
   description_it = 'Spaccatura orizzontale',
   description_ro = '',
   display_en = 'DABBB',
   display_de = 'DABBB',
   display_fr = 'DABBB',
   display_it = 'DABBB',
   display_ro = 'DABBB'
WHERE code =4155;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4156,4156) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABBC',
   value_de = 'DABBC',
   value_fr = 'DABBC',
   value_it = 'DABBC',
   value_ro = 'DABBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss, komplexe Rissbildung',
   description_de = 'Riss, komplexe Rissbildung',
   description_fr = 'Fissure, formation complexe de fissures',
   description_it = 'Spaccatura, fessurazione complessa, formazione di frammenti',
   description_ro = '',
   display_en = 'DABBC',
   display_de = 'DABBC',
   display_fr = 'DABBC',
   display_it = 'DABBC',
   display_ro = 'DABBC'
WHERE code =4156;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4157,4157) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABBD',
   value_de = 'DABBD',
   value_fr = 'DABBD',
   value_it = 'DABBD',
   value_ro = 'DABBD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss, geneigte Rissbildung',
   description_de = 'Riss, geneigte Rissbildung',
   description_fr = 'Fissure, formation inclinée de fissures',
   description_it = 'Spaccatura, fessurazione inclinata',
   description_ro = '',
   display_en = 'DABBD',
   display_de = 'DABBD',
   display_fr = 'DABBD',
   display_it = 'DABBD',
   display_ro = 'DABBD'
WHERE code =4157;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8910,8910) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABBE',
   value_de = 'DABBE',
   value_fr = 'DABBE',
   value_it = 'DABBE',
   value_ro = 'DABBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss, sternförmige Rissbildung',
   description_de = 'Riss, sternförmige Rissbildung',
   description_fr = 'Fissure, fissuration en étoile',
   description_it = 'Spaccatura, fessurazione a stella',
   description_ro = 'rrr_Riss, sternförmige Rissbildung',
   display_en = 'DABBE',
   display_de = 'DABBE',
   display_fr = 'DABBE',
   display_it = 'DABBE',
   display_ro = 'DABBE'
WHERE code =8910;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4158,4158) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABCA',
   value_de = 'DABCA',
   value_fr = 'DABCA',
   value_it = 'DABCA',
   value_ro = 'DABCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, vertikal',
   description_de = 'Klaffender Riss, vertikal',
   description_fr = 'Fissure béante, verticale',
   description_it = 'Frattura aperta, verticale',
   description_ro = '',
   display_en = 'DABCA',
   display_de = 'DABCA',
   display_fr = 'DABCA',
   display_it = 'DABCA',
   display_ro = 'DABCA'
WHERE code =4158;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4159,4159) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABCB',
   value_de = 'DABCB',
   value_fr = 'DABCB',
   value_it = 'DABCB',
   value_ro = 'DABCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, horizontal',
   description_de = 'Klaffender Riss, horizontal',
   description_fr = 'Fissure béante, horizontale',
   description_it = 'Frattura aperta, orizzontale',
   description_ro = '',
   display_en = 'DABCB',
   display_de = 'DABCB',
   display_fr = 'DABCB',
   display_it = 'DABCB',
   display_ro = 'DABCB'
WHERE code =4159;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4160,4160) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABCC',
   value_de = 'DABCC',
   value_fr = 'DABCC',
   value_it = 'DABCC',
   value_ro = 'DABCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, komplexe Rissbildung',
   description_de = 'Klaffender Riss, komplexe Rissbildung',
   description_fr = 'Fissure béante, formation complexe de fissures',
   description_it = 'Frattura aperta, fessurazione complessa, formazione di frammenti',
   description_ro = '',
   display_en = 'DABCC',
   display_de = 'DABCC',
   display_fr = 'DABCC',
   display_it = 'DABCC',
   display_ro = 'DABCC'
WHERE code =4160;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4161,4161) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABCD',
   value_de = 'DABCD',
   value_fr = 'DABCD',
   value_it = 'DABCD',
   value_ro = 'DABCD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, geneigte Rissbildung',
   description_de = 'Klaffender Riss, geneigte Rissbildung',
   description_fr = 'Fissure béante, formation inclinée de fissures',
   description_it = 'Frattura aperta, fessurazione inclinata',
   description_ro = '',
   display_en = 'DABCD',
   display_de = 'DABCD',
   display_fr = 'DABCD',
   display_it = 'DABCD',
   display_ro = 'DABCD'
WHERE code =4161;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8911,8911) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DABCE',
   value_de = 'DABCE',
   value_fr = 'DABCE',
   value_it = 'DABCE',
   value_ro = 'DABCE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Klaffender Riss, sternförmige Rissbildung',
   description_de = 'Klaffender Riss, sternförmige Rissbildung',
   description_fr = 'Fissure béante, fissuration en étoile',
   description_it = 'Frattura aperta, fessurazione a stella',
   description_ro = 'rrr_Klaffender Riss, sternförmige Rissbildung',
   display_en = 'DABCE',
   display_de = 'DABCE',
   display_fr = 'DABCE',
   display_it = 'DABCE',
   display_ro = 'DABCE'
WHERE code =8911;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4162,4162) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DACA',
   value_de = 'DACA',
   value_fr = 'DACA',
   value_it = 'DACA',
   value_ro = 'DACA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_In der Lage verschobene Scherbe',
   description_de = 'In der Lage verschobene Scherbe',
   description_fr = 'Formation d’éclats',
   description_it = 'Rottura con pezzi spostati ma non mancanti',
   description_ro = '',
   display_en = 'DACA',
   display_de = 'DACA',
   display_fr = 'DACA',
   display_it = 'DACA',
   display_ro = 'DACA'
WHERE code =4162;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4163,4163) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DACB',
   value_de = 'DACB',
   value_fr = 'DACB',
   value_it = 'DACB',
   value_ro = 'DACB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Scherbe / Wandungsteil (Loch)',
   description_de = 'Fehlende Scherbe / Wandungsteil (Loch)',
   description_fr = 'Éclat / partie de paroi manquante',
   description_it = 'Mancanza di frammenti o pezzi sulla parete/(foro)',
   description_ro = '',
   display_en = 'DACB',
   display_de = 'DACB',
   display_fr = 'DACB',
   display_it = 'DACB',
   display_ro = 'DACB'
WHERE code =4163;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4164,4164) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DACC',
   value_de = 'DACC',
   value_fr = 'DACC',
   value_it = 'DACC',
   value_ro = 'DACC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Einsturz',
   description_de = 'Einsturz',
   description_fr = 'Effondrement',
   description_it = 'Rottura della condotta/crollo strutturale',
   description_ro = '',
   display_en = 'DACC',
   display_de = 'DACC',
   display_fr = 'DACC',
   display_it = 'DACC',
   display_ro = 'DACC'
WHERE code =4164;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4165,4165) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DADA',
   value_de = 'DADA',
   value_fr = 'DADA',
   value_it = 'DADA',
   value_ro = 'DADA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine verschoben',
   description_de = 'Mauerwerk defekt, Mauer- / Backsteine verschoben',
   description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie déplacés',
   description_it = 'Muratura difettosa, mattoni o pezzi di muratura spostati',
   description_ro = '',
   display_en = 'DADA',
   display_de = 'DADA',
   display_fr = 'DADA',
   display_it = 'DADA',
   display_ro = 'DADA'
WHERE code =4165;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4166,4166) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DADB',
   value_de = 'DADB',
   value_fr = 'DADB',
   value_it = 'DADB',
   value_ro = 'DADB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Mauer- / Backsteine fehlen',
   description_de = 'Mauerwerk defekt, Mauer- / Backsteine fehlen',
   description_fr = 'Maçonnerie défectueuse, briques ou éléments de maçonnerie manquants',
   description_it = 'Muratura difettosa, mattoni/mattoni o pezzi di muratura mancanti',
   description_ro = '',
   display_en = 'DADB',
   display_de = 'DADB',
   display_fr = 'DADB',
   display_it = 'DADB',
   display_ro = 'DADB'
WHERE code =4166;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4167,4167) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DADC',
   value_de = 'DADC',
   value_fr = 'DADC',
   value_it = 'DADC',
   value_ro = 'DADC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mauerwerk defekt, Einsturz',
   description_de = 'Mauerwerk defekt, Einsturz',
   description_fr = 'Maçonnerie défectueuse, effondrement',
   description_it = 'Muratura difettosa, crollo strutturale',
   description_ro = '',
   display_en = 'DADC',
   display_de = 'DADC',
   display_fr = 'DADC',
   display_it = 'DADC',
   display_ro = 'DADC'
WHERE code =4167;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4168,4168) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAE',
   value_de = 'DAE',
   value_fr = 'DAE',
   value_it = 'DAE',
   value_ro = 'DAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Mörtel aus Mauerwerk fehlt ganz oder teilweise',
   description_de = 'Mörtel aus Mauerwerk fehlt ganz oder teilweise',
   description_fr = 'Tout ou partie du mortier de la maçonnerie est manquant(e)',
   description_it = 'Manca completamente o parzialmente la malta della muratura',
   description_ro = '',
   display_en = 'DAE',
   display_de = 'DAE',
   display_fr = 'DAE',
   display_it = 'DAE',
   display_ro = 'DAE'
WHERE code =4168;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4169,4169) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFAA',
   value_de = 'DAFAA',
   value_fr = 'DAFAA',
   value_it = 'DAFAA',
   value_ro = 'DAFAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erhöhte Rauheit durch mechanische Beschädigung',
   description_de = 'Erhöhte Rauheit durch mechanische Beschädigung',
   description_fr = 'Paroi de la canalisation rugueuse par dégradation mécanique',
   description_it = 'Parete del tubo ruvida per danno meccanico',
   description_ro = '',
   display_en = 'DAFAA',
   display_de = 'DAFAA',
   display_fr = 'DAFAA',
   display_it = 'DAFAA',
   display_ro = 'DAFAA'
WHERE code =4169;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4170,4170) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFAB',
   value_de = 'DAFAB',
   value_fr = 'DAFAB',
   value_it = 'DAFAB',
   value_ro = 'DAFAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erhöhte Rauheit durch chemischen Angriff',
   description_de = 'Erhöhte Rauheit durch chemischen Angriff',
   description_fr = 'Paroi de la canalisation rugueuse par attaque chimique',
   description_it = 'Parete del tubo ruvida per aggressione chimica',
   description_ro = '',
   display_en = 'DAFAB',
   display_de = 'DAFAB',
   display_fr = 'DAFAB',
   display_it = 'DAFAB',
   display_ro = 'DAFAB'
WHERE code =4170;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4171,4171) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFAC',
   value_de = 'DAFAC',
   value_fr = 'DAFAC',
   value_it = 'DAFAC',
   value_ro = 'DAFAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erhöhte Rauheit durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Erhöhte Rauheit durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Parete del tubo ruvida per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFAC',
   display_de = 'DAFAC',
   display_fr = 'DAFAC',
   display_it = 'DAFAC',
   display_ro = 'DAFAC'
WHERE code =4171;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4172,4172) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFAD',
   value_de = 'DAFAD',
   value_fr = 'DAFAD',
   value_it = 'DAFAD',
   value_ro = 'DAFAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erhöhte Rauheit durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Erhöhte Rauheit durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Paroi de la canalisation rugueuse par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Parete del tubo ruvida per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFAD',
   display_de = 'DAFAD',
   display_fr = 'DAFAD',
   display_it = 'DAFAD',
   display_ro = 'DAFAD'
WHERE code =4172;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4173,4173) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFAE',
   value_de = 'DAFAE',
   value_fr = 'DAFAE',
   value_it = 'DAFAE',
   value_ro = 'DAFAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erhöhte Rauheit, Schadensursache nicht feststellbar',
   description_de = 'Erhöhte Rauheit, Schadensursache nicht feststellbar',
   description_fr = 'Paroi de la canalisation rugueuse, cause du dommage non définissable',
   description_it = 'Parete del tubo ruvida per cause non evidenti',
   description_ro = '',
   display_en = 'DAFAE',
   display_de = 'DAFAE',
   display_fr = 'DAFAE',
   display_it = 'DAFAE',
   display_ro = 'DAFAE'
WHERE code =4173;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8912,8912) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFAZ',
   value_de = 'DAFAZ',
   value_fr = 'DAFAZ',
   value_it = 'DAFAZ',
   value_ro = 'DAFAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Erhöhte Rauheit, andere Ursache',
   description_de = 'Erhöhte Rauheit, andere Ursache',
   description_fr = 'Paroi de la canalisation rugueuse, autre cause, (plus de détails requis dans la note)',
   description_it = 'Parete del tubo ruvida per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Erhöhte Rauheit, andere Ursache',
   display_en = 'DAFAZ',
   display_de = 'DAFAZ',
   display_fr = 'DAFAZ',
   display_it = 'DAFAZ',
   display_ro = 'DAFAZ'
WHERE code =8912;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4174,4174) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFBA',
   value_de = 'DAFBA',
   value_fr = 'DAFBA',
   value_it = 'DAFBA',
   value_ro = 'DAFBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abplatzung durch mechanische Beschädigung',
   description_de = 'Abplatzung durch mechanische Beschädigung',
   description_fr = 'Écaillage par dégradation mécanique',
   description_it = 'Sfaldamento per danno meccanico',
   description_ro = '',
   display_en = 'DAFBA',
   display_de = 'DAFBA',
   display_fr = 'DAFBA',
   display_it = 'DAFBA',
   display_ro = 'DAFBA'
WHERE code =4174;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4175,4175) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFBE',
   value_de = 'DAFBE',
   value_fr = 'DAFBE',
   value_it = 'DAFBE',
   value_ro = 'DAFBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abplatzung, Schadensursache nicht feststellbar',
   description_de = 'Abplatzung, Schadensursache nicht feststellbar',
   description_fr = 'Écaillage, cause du dommage non définissable',
   description_it = 'Sfaldamento per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAFBE',
   display_de = 'DAFBE',
   display_fr = 'DAFBE',
   display_it = 'DAFBE',
   display_ro = 'DAFBE'
WHERE code =4175;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8913,8913) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFBZ',
   value_de = 'DAFBZ',
   value_fr = 'DAFBZ',
   value_it = 'DAFBZ',
   value_ro = 'DAFBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abplatzung, andere Ursache',
   description_de = 'Abplatzung, andere Ursache',
   description_fr = 'Écaillage, autre cause',
   description_it = 'Sfaldamento per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Abplatzung, andere Ursache',
   display_en = 'DAFBZ',
   display_de = 'DAFBZ',
   display_fr = 'DAFBZ',
   display_it = 'DAFBZ',
   display_ro = 'DAFBZ'
WHERE code =8913;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4176,4176) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFCA',
   value_de = 'DAFCA',
   value_fr = 'DAFCA',
   value_it = 'DAFCA',
   value_ro = 'DAFCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch mechanische Beschädigung',
   description_de = 'Zuschlagstoffe sichtbar durch mechanische Beschädigung',
   description_fr = 'Agrégats visibles par dégradation mécanique',
   description_it = 'Materiale inerte visibile per danno meccanico',
   description_ro = '',
   display_en = 'DAFCA',
   display_de = 'DAFCA',
   display_fr = 'DAFCA',
   display_it = 'DAFCA',
   display_ro = 'DAFCA'
WHERE code =4176;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4177,4177) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFCB',
   value_de = 'DAFCB',
   value_fr = 'DAFCB',
   value_it = 'DAFCB',
   value_ro = 'DAFCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff',
   description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff',
   description_fr = 'Agrégats visibles par attaque chimique',
   description_it = 'Materiale inerte visibile per aggressione chimica',
   description_ro = '',
   display_en = 'DAFCB',
   display_de = 'DAFCB',
   display_fr = 'DAFCB',
   display_it = 'DAFCB',
   display_ro = 'DAFCB'
WHERE code =4177;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4178,4178) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFCC',
   value_de = 'DAFCC',
   value_fr = 'DAFCC',
   value_it = 'DAFCC',
   value_ro = 'DAFCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Agrégats visibles par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Materiale inerte visibile per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFCC',
   display_de = 'DAFCC',
   display_fr = 'DAFCC',
   display_it = 'DAFCC',
   display_ro = 'DAFCC'
WHERE code =4178;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4179,4179) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFCD',
   value_de = 'DAFCD',
   value_fr = 'DAFCD',
   value_it = 'DAFCD',
   value_ro = 'DAFCD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Zuschlagstoffe sichtbar durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Agrégats visibles par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Materiale inerte visibile per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFCD',
   display_de = 'DAFCD',
   display_fr = 'DAFCD',
   display_it = 'DAFCD',
   display_ro = 'DAFCD'
WHERE code =4179;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4180,4180) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFCE',
   value_de = 'DAFCE',
   value_fr = 'DAFCE',
   value_it = 'DAFCE',
   value_ro = 'DAFCE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar, Schadensursache nicht feststellbar',
   description_de = 'Zuschlagstoffe sichtbar, Schadensursache nicht feststellbar',
   description_fr = 'Agrégats visibles, cause du dommage non définissable',
   description_it = 'Materiale inerte visibile per cause non evidenti',
   description_ro = '',
   display_en = 'DAFCE',
   display_de = 'DAFCE',
   display_fr = 'DAFCE',
   display_it = 'DAFCE',
   display_ro = 'DAFCE'
WHERE code =4180;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8914,8914) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFCZ',
   value_de = 'DAFCZ',
   value_fr = 'DAFCZ',
   value_it = 'DAFCZ',
   value_ro = 'DAFCZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe sichtbar, andere Ursache',
   description_de = 'Zuschlagstoffe sichtbar, andere Ursache',
   description_fr = 'Agrégats visibles, autre cause',
   description_it = 'Materiale inerte visibile per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Zuschlagstoffe sichtbar, andere Ursache',
   display_en = 'DAFCZ',
   display_de = 'DAFCZ',
   display_fr = 'DAFCZ',
   display_it = 'DAFCZ',
   display_ro = 'DAFCZ'
WHERE code =8914;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4181,4181) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFDA',
   value_de = 'DAFDA',
   value_fr = 'DAFDA',
   value_it = 'DAFDA',
   value_ro = 'DAFDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch mechanische Beschädigung',
   description_de = 'Zuschlagstoffe einragend durch mechanische Beschädigung',
   description_fr = 'Agrégats intrusifs par dégradation mécanique',
   description_it = 'Materiale inerte sporgente per danno meccanico',
   description_ro = '',
   display_en = 'DAFDA',
   display_de = 'DAFDA',
   display_fr = 'DAFDA',
   display_it = 'DAFDA',
   display_ro = 'DAFDA'
WHERE code =4181;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4182,4182) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFDB',
   value_de = 'DAFDB',
   value_fr = 'DAFDB',
   value_it = 'DAFDB',
   value_ro = 'DAFDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff',
   description_de = 'Zuschlagstoffe einragend durch chemischen Angriff',
   description_fr = 'Agrégats intrusifs par attaque chimique',
   description_it = 'Materiale inerte sporgente per aggressione chimica',
   description_ro = '',
   display_en = 'DAFDB',
   display_de = 'DAFDB',
   display_fr = 'DAFDB',
   display_it = 'DAFDB',
   display_ro = 'DAFDB'
WHERE code =4182;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4183,4183) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFDC',
   value_de = 'DAFDC',
   value_fr = 'DAFDC',
   value_it = 'DAFDC',
   value_ro = 'DAFDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Agrégats intrusifs par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Materiale inerte visibile per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFDC',
   display_de = 'DAFDC',
   display_fr = 'DAFDC',
   display_it = 'DAFDC',
   display_ro = 'DAFDC'
WHERE code =4183;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4184,4184) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFDD',
   value_de = 'DAFDD',
   value_fr = 'DAFDD',
   value_it = 'DAFDD',
   value_ro = 'DAFDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Zuschlagstoffe einragend durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Agrégats intrusifs par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Materiale inerte visibile per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFDD',
   display_de = 'DAFDD',
   display_fr = 'DAFDD',
   display_it = 'DAFDD',
   display_ro = 'DAFDD'
WHERE code =4184;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4185,4185) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFDE',
   value_de = 'DAFDE',
   value_fr = 'DAFDE',
   value_it = 'DAFDE',
   value_ro = 'DAFDE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend, Schadensursache nicht feststellbar',
   description_de = 'Zuschlagstoffe einragend, Schadensursache nicht feststellbar',
   description_fr = 'Agrégats intrusifs, cause du dommage non définissable',
   description_it = 'Materiale inerte visibile per cause non evidenti',
   description_ro = '',
   display_en = 'DAFDE',
   display_de = 'DAFDE',
   display_fr = 'DAFDE',
   display_it = 'DAFDE',
   display_ro = 'DAFDE'
WHERE code =4185;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8915,8915) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFDZ',
   value_de = 'DAFDZ',
   value_fr = 'DAFDZ',
   value_it = 'DAFDZ',
   value_ro = 'DAFDZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe einragend, andere Ursache',
   description_de = 'Zuschlagstoffe einragend, andere Ursache',
   description_fr = 'Agrégats intrusifs, autre cause',
   description_it = 'Materiale inerte visibile per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Zuschlagstoffe einragend, andere Ursache',
   display_en = 'DAFDZ',
   display_de = 'DAFDZ',
   display_fr = 'DAFDZ',
   display_it = 'DAFDZ',
   display_ro = 'DAFDZ'
WHERE code =8915;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4186,4186) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFEA',
   value_de = 'DAFEA',
   value_fr = 'DAFEA',
   value_it = 'DAFEA',
   value_ro = 'DAFEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch mechanische Beschädigung',
   description_de = 'Zuschlagstoffe fehlen durch mechanische Beschädigung',
   description_fr = 'Granulats manquants par dégradation mécanique',
   description_it = 'Materiale mancante per danno meccanico',
   description_ro = '',
   display_en = 'DAFEA',
   display_de = 'DAFEA',
   display_fr = 'DAFEA',
   display_it = 'DAFEA',
   display_ro = 'DAFEA'
WHERE code =4186;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4187,4187) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFEB',
   value_de = 'DAFEB',
   value_fr = 'DAFEB',
   value_it = 'DAFEB',
   value_ro = 'DAFEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff',
   description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff',
   description_fr = 'Agrégats manquants par attaque chimique',
   description_it = 'Materiale mancante per aggressione chimica',
   description_ro = '',
   display_en = 'DAFEB',
   display_de = 'DAFEB',
   display_fr = 'DAFEB',
   display_it = 'DAFEB',
   display_ro = 'DAFEB'
WHERE code =4187;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4188,4188) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFEC',
   value_de = 'DAFEC',
   value_fr = 'DAFEC',
   value_it = 'DAFEC',
   value_ro = 'DAFEC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Agrégats manquants par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Materiale mancante per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFEC',
   display_de = 'DAFEC',
   display_fr = 'DAFEC',
   display_it = 'DAFEC',
   display_ro = 'DAFEC'
WHERE code =4188;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4189,4189) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFED',
   value_de = 'DAFED',
   value_fr = 'DAFED',
   value_it = 'DAFED',
   value_ro = 'DAFED',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Zuschlagstoffe fehlen durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Agrégats manquants par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Materiale mancante per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFED',
   display_de = 'DAFED',
   display_fr = 'DAFED',
   display_it = 'DAFED',
   display_ro = 'DAFED'
WHERE code =4189;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4190,4190) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFEE',
   value_de = 'DAFEE',
   value_fr = 'DAFEE',
   value_it = 'DAFEE',
   value_ro = 'DAFEE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen, Schadensursache nicht feststellbar',
   description_de = 'Zuschlagstoffe fehlen, Schadensursache nicht feststellbar',
   description_fr = 'Agrégats manquants, cause du dommage non définissable',
   description_it = 'Materiale mancante per cause non evidenti',
   description_ro = '',
   display_en = 'DAFEE',
   display_de = 'DAFEE',
   display_fr = 'DAFEE',
   display_it = 'DAFEE',
   display_ro = 'DAFEE'
WHERE code =4190;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8916,8916) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFEZ',
   value_de = 'DAFEZ',
   value_fr = 'DAFEZ',
   value_it = 'DAFEZ',
   value_ro = 'DAFEZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zuschlagstoffe fehlen, andere Ursache',
   description_de = 'Zuschlagstoffe fehlen, andere Ursache',
   description_fr = 'Agrégats manquants, autre cause ',
   description_it = 'Materiale inerte sporgente per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Zuschlagstoffe fehlen, andere Ursache',
   display_en = 'DAFEZ',
   display_de = 'DAFEZ',
   display_fr = 'DAFEZ',
   display_it = 'DAFEZ',
   display_ro = 'DAFEZ'
WHERE code =8916;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4191,4191) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFFA',
   value_de = 'DAFFA',
   value_fr = 'DAFFA',
   value_it = 'DAFFA',
   value_ro = 'DAFFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch mechanische Beschädigung',
   description_de = 'Bewehrung sichtbar durch mechanische Beschädigung',
   description_fr = 'Armature visible par dégradation mécanique',
   description_it = 'Armatura visibile per danno meccanico',
   description_ro = '',
   display_en = 'DAFFA',
   display_de = 'DAFFA',
   display_fr = 'DAFFA',
   display_it = 'DAFFA',
   display_ro = 'DAFFA'
WHERE code =4191;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4192,4192) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFFB',
   value_de = 'DAFFB',
   value_fr = 'DAFFB',
   value_it = 'DAFFB',
   value_ro = 'DAFFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff',
   description_de = 'Bewehrung sichtbar durch chemischen Angriff',
   description_fr = 'Armature visible par attaque chimique',
   description_it = 'Armatura visibile per aggressione chimica',
   description_ro = '',
   display_en = 'DAFFB',
   display_de = 'DAFFB',
   display_fr = 'DAFFB',
   display_it = 'DAFFB',
   display_ro = 'DAFFB'
WHERE code =4192;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4193,4193) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFFC',
   value_de = 'DAFFC',
   value_fr = 'DAFFC',
   value_it = 'DAFFC',
   value_ro = 'DAFFC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Bewehrung sichtbar durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Armature visible par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Armatura visibile per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFFC',
   display_de = 'DAFFC',
   display_fr = 'DAFFC',
   display_it = 'DAFFC',
   display_ro = 'DAFFC'
WHERE code =4193;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4194,4194) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFFD',
   value_de = 'DAFFD',
   value_fr = 'DAFFD',
   value_it = 'DAFFD',
   value_ro = 'DAFFD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Bewehrung sichtbar durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Armature visible par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Armatura visibile per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFFD',
   display_de = 'DAFFD',
   display_fr = 'DAFFD',
   display_it = 'DAFFD',
   display_ro = 'DAFFD'
WHERE code =4194;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4195,4195) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFFE',
   value_de = 'DAFFE',
   value_fr = 'DAFFE',
   value_it = 'DAFFE',
   value_ro = 'DAFFE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar, Schadensursache nicht feststellbar',
   description_de = 'Bewehrung sichtbar, Schadensursache nicht feststellbar',
   description_fr = 'Armature visible, cause pas clairement identifiable',
   description_it = 'Armatura visibile per cause non evidenti',
   description_ro = '',
   display_en = 'DAFFE',
   display_de = 'DAFFE',
   display_fr = 'DAFFE',
   display_it = 'DAFFE',
   display_ro = 'DAFFE'
WHERE code =4195;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8917,8917) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFFZ',
   value_de = 'DAFFZ',
   value_fr = 'DAFFZ',
   value_it = 'DAFFZ',
   value_ro = 'DAFFZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung sichtbar, andere Ursache',
   description_de = 'Bewehrung sichtbar, andere Ursache',
   description_fr = 'Armature visible, autre cause',
   description_it = 'Armatura visibile per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Bewehrung sichtbar, andere Ursache',
   display_en = 'DAFFZ',
   display_de = 'DAFFZ',
   display_fr = 'DAFFZ',
   display_it = 'DAFFZ',
   display_ro = 'DAFFZ'
WHERE code =8917;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4196,4196) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFGA',
   value_de = 'DAFGA',
   value_fr = 'DAFGA',
   value_it = 'DAFGA',
   value_ro = 'DAFGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch mechanische Beschädigung',
   description_de = 'Bewehrung einragend durch mechanische Beschädigung',
   description_fr = 'Armature dépassant de la surface par dégradation mécanique',
   description_it = 'Armatura sporgente per danno meccanico',
   description_ro = '',
   display_en = 'DAFGA',
   display_de = 'DAFGA',
   display_fr = 'DAFGA',
   display_it = 'DAFGA',
   display_ro = 'DAFGA'
WHERE code =4196;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4197,4197) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFGB',
   value_de = 'DAFGB',
   value_fr = 'DAFGB',
   value_it = 'DAFGB',
   value_ro = 'DAFGB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch chemischen Angriff',
   description_de = 'Bewehrung einragend durch chemischen Angriff',
   description_fr = 'Armature dépassant de la surface par attaque chimique',
   description_it = 'Armatura sporgente per aggressione chimica',
   description_ro = '',
   display_en = 'DAFGB',
   display_de = 'DAFGB',
   display_fr = 'DAFGB',
   display_it = 'DAFGB',
   display_ro = 'DAFGB'
WHERE code =4197;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4198,4198) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFGC',
   value_de = 'DAFGC',
   value_fr = 'DAFGC',
   value_it = 'DAFGC',
   value_ro = 'DAFGC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Bewehrung einragend durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Armatura sporgente per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFGC',
   display_de = 'DAFGC',
   display_fr = 'DAFGC',
   display_it = 'DAFGC',
   display_ro = 'DAFGC'
WHERE code =4198;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4199,4199) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFGD',
   value_de = 'DAFGD',
   value_fr = 'DAFGD',
   value_it = 'DAFGD',
   value_ro = 'DAFGD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Bewehrung einragend durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Armature dépassant de la surface par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Armatura sporgente per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFGD',
   display_de = 'DAFGD',
   display_fr = 'DAFGD',
   display_it = 'DAFGD',
   display_ro = 'DAFGD'
WHERE code =4199;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4200,4200) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFGE',
   value_de = 'DAFGE',
   value_fr = 'DAFGE',
   value_it = 'DAFGE',
   value_ro = 'DAFGE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend, Schadensursache nicht feststellbar',
   description_de = 'Bewehrung einragend, Schadensursache nicht feststellbar',
   description_fr = 'Armature dépassant de la surface, cause pas clairement identifiable',
   description_it = 'Armatura sporgente per cause non evidenti',
   description_ro = '',
   display_en = 'DAFGE',
   display_de = 'DAFGE',
   display_fr = 'DAFGE',
   display_it = 'DAFGE',
   display_ro = 'DAFGE'
WHERE code =4200;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8918,8918) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFGZ',
   value_de = 'DAFGZ',
   value_fr = 'DAFGZ',
   value_it = 'DAFGZ',
   value_ro = 'DAFGZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung einragend, andere Ursache',
   description_de = 'Bewehrung einragend, andere Ursache',
   description_fr = 'Armature dépassant de la surface, autre cause',
   description_it = 'Armatura sporgente per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Bewehrung einragend, andere Ursache',
   display_en = 'DAFGZ',
   display_de = 'DAFGZ',
   display_fr = 'DAFGZ',
   display_it = 'DAFGZ',
   display_ro = 'DAFGZ'
WHERE code =8918;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4201,4201) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFHB',
   value_de = 'DAFHB',
   value_fr = 'DAFHB',
   value_it = 'DAFHB',
   value_ro = 'DAFHB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff',
   description_de = 'Bewehrung korrodiert durch chemischen Angriff',
   description_fr = 'Armature corrodée par attaque chimique',
   description_it = 'Armatura corrosa per aggressione chimica',
   description_ro = '',
   display_en = 'DAFHB',
   display_de = 'DAFHB',
   display_fr = 'DAFHB',
   display_it = 'DAFHB',
   display_ro = 'DAFHB'
WHERE code =4201;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4202,4202) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFHC',
   value_de = 'DAFHC',
   value_fr = 'DAFHC',
   value_it = 'DAFHC',
   value_ro = 'DAFHC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Bewehrung korrodiert durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Armature corrodée par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Armatura corrosa per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFHC',
   display_de = 'DAFHC',
   display_fr = 'DAFHC',
   display_it = 'DAFHC',
   display_ro = 'DAFHC'
WHERE code =4202;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4203,4203) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFHD',
   value_de = 'DAFHD',
   value_fr = 'DAFHD',
   value_it = 'DAFHD',
   value_ro = 'DAFHD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Bewehrung korrodiert durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Armature corrodée par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Armatura corrosa per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFHD',
   display_de = 'DAFHD',
   display_fr = 'DAFHD',
   display_it = 'DAFHD',
   display_ro = 'DAFHD'
WHERE code =4203;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4204,4204) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFHE',
   value_de = 'DAFHE',
   value_fr = 'DAFHE',
   value_it = 'DAFHE',
   value_ro = 'DAFHE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bewehrung korrodiert, Schadensursache nicht feststellbar',
   description_de = 'Bewehrung korrodiert, Schadensursache nicht feststellbar',
   description_fr = 'Armature corrodée, cause pas clairement identifiable',
   description_it = 'Armatura corrosa per cause non evidenti',
   description_ro = '',
   display_en = 'DAFHE',
   display_de = 'DAFHE',
   display_fr = 'DAFHE',
   display_it = 'DAFHE',
   display_ro = 'DAFHE'
WHERE code =4204;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4205,4205) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFIA',
   value_de = 'DAFIA',
   value_fr = 'DAFIA',
   value_it = 'DAFIA',
   value_ro = 'DAFIA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Wand durch mechanische Beschädigung',
   description_de = 'Fehlende Wand durch mechanische Beschädigung',
   description_fr = 'Paroi manquante par dégradation mécanique',
   description_it = 'Parete mancante per danno meccanico',
   description_ro = '',
   display_en = 'DAFIA',
   display_de = 'DAFIA',
   display_fr = 'DAFIA',
   display_it = 'DAFIA',
   display_ro = 'DAFIA'
WHERE code =4205;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4206,4206) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFIB',
   value_de = 'DAFIB',
   value_fr = 'DAFIB',
   value_it = 'DAFIB',
   value_ro = 'DAFIB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Wand durch chemischen Angriff',
   description_de = 'Fehlende Wand durch chemischen Angriff',
   description_fr = 'Paroi manquante par attaque chimique',
   description_it = 'Parete mancante per aggressione chimica',
   description_ro = '',
   display_en = 'DAFIB',
   display_de = 'DAFIB',
   display_fr = 'DAFIB',
   display_it = 'DAFIB',
   display_ro = 'DAFIB'
WHERE code =4206;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4207,4207) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFIC',
   value_de = 'DAFIC',
   value_fr = 'DAFIC',
   value_it = 'DAFIC',
   value_ro = 'DAFIC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Wand  durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Fehlende Wand  durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Paroi manquante par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Parete mancante per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFIC',
   display_de = 'DAFIC',
   display_fr = 'DAFIC',
   display_it = 'DAFIC',
   display_ro = 'DAFIC'
WHERE code =4207;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4208,4208) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFID',
   value_de = 'DAFID',
   value_fr = 'DAFID',
   value_it = 'DAFID',
   value_ro = 'DAFID',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Wand  durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Fehlende Wand  durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Paroi manquante par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Parete mancante per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFID',
   display_de = 'DAFID',
   display_fr = 'DAFID',
   display_it = 'DAFID',
   display_ro = 'DAFID'
WHERE code =4208;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4209,4209) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFIE',
   value_de = 'DAFIE',
   value_fr = 'DAFIE',
   value_it = 'DAFIE',
   value_ro = 'DAFIE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Wand, Schadensursache nicht feststellbar',
   description_de = 'Fehlende Wand, Schadensursache nicht feststellbar',
   description_fr = 'Paroi manquante, cause pas clairement identifiable',
   description_it = 'Parete mancante per cause non evidenti',
   description_ro = '',
   display_en = 'DAFIE',
   display_de = 'DAFIE',
   display_fr = 'DAFIE',
   display_it = 'DAFIE',
   display_ro = 'DAFIE'
WHERE code =4209;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8919,8919) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFIZ',
   value_de = 'DAFIZ',
   value_fr = 'DAFIZ',
   value_it = 'DAFIZ',
   value_ro = 'DAFIZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlende Wand, andere Ursache',
   description_de = 'Fehlende Wand, andere Ursache',
   description_fr = 'Paroi manquante, autre cause',
   description_it = 'Parete mancante per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Fehlende Wand, andere Ursache',
   display_en = 'DAFIZ',
   display_de = 'DAFIZ',
   display_fr = 'DAFIZ',
   display_it = 'DAFIZ',
   display_ro = 'DAFIZ'
WHERE code =8919;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4210,4210) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFJB',
   value_de = 'DAFJB',
   value_fr = 'DAFJB',
   value_it = 'DAFJB',
   value_ro = 'DAFJB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Korrosion durch chemischen Angriff',
   description_de = 'Korrosion durch chemischen Angriff',
   description_fr = 'Corrosion par attaque chimique',
   description_it = 'Corrosione per aggressione chimica',
   description_ro = '',
   display_en = 'DAFJB',
   display_de = 'DAFJB',
   display_fr = 'DAFJB',
   display_it = 'DAFJB',
   display_ro = 'DAFJB'
WHERE code =4210;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4211,4211) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFJC',
   value_de = 'DAFJC',
   value_fr = 'DAFJC',
   value_it = 'DAFJC',
   value_ro = 'DAFJC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Korrosion durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Korrosion durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Corrosion par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Corrosione per aggressione chimica nella parte superiore del tubo o più in alto',
   description_ro = '',
   display_en = 'DAFJC',
   display_de = 'DAFJC',
   display_fr = 'DAFJC',
   display_it = 'DAFJC',
   display_ro = 'DAFJC'
WHERE code =4211;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4212,4212) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFJD',
   value_de = 'DAFJD',
   value_fr = 'DAFJD',
   value_it = 'DAFJD',
   value_ro = 'DAFJD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Korrosion durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Korrosion durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Corrosion par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Corrosione per aggressione chimica nella parte inferiore del tubo',
   description_ro = '',
   display_en = 'DAFJD',
   display_de = 'DAFJD',
   display_fr = 'DAFJD',
   display_it = 'DAFJD',
   display_ro = 'DAFJD'
WHERE code =4212;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4213,4213) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFJE',
   value_de = 'DAFJE',
   value_fr = 'DAFJE',
   value_it = 'DAFJE',
   value_ro = 'DAFJE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Korrosion, Schadensursache nicht feststellbar',
   description_de = 'Korrosion, Schadensursache nicht feststellbar',
   description_fr = 'Corrosion, cause pas clairement identifiable',
   description_it = 'Corrosione per cause non evidenti',
   description_ro = '',
   display_en = 'DAFJE',
   display_de = 'DAFJE',
   display_fr = 'DAFJE',
   display_it = 'DAFJE',
   display_ro = 'DAFJE'
WHERE code =4213;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8920,8920) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFJZ',
   value_de = 'DAFJZ',
   value_fr = 'DAFJZ',
   value_it = 'DAFJZ',
   value_ro = 'DAFJZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Korrosion, andere Ursache',
   description_de = 'Korrosion, andere Ursache',
   description_fr = 'Corrosion, autre cause ',
   description_it = 'Corrosione per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Korrosion, andere Ursache',
   display_en = 'DAFJZ',
   display_de = 'DAFJZ',
   display_fr = 'DAFJZ',
   display_it = 'DAFJZ',
   display_ro = 'DAFJZ'
WHERE code =8920;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8921,8921) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFKA',
   value_de = 'DAFKA',
   value_fr = 'DAFKA',
   value_it = 'DAFKA',
   value_ro = 'DAFKA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule durch mechanische Beschädigung',
   description_de = 'Beule durch mechanische Beschädigung',
   description_fr = 'Bosse due à des dommages mécaniques',
   description_it = 'Protuberanza per danno meccanico',
   description_ro = 'rrr_Beule durch mechanische Beschädigung',
   display_en = 'DAFKA',
   display_de = 'DAFKA',
   display_fr = 'DAFKA',
   display_it = 'DAFKA',
   display_ro = 'DAFKA'
WHERE code =8921;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8922,8922) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFKE',
   value_de = 'DAFKE',
   value_fr = 'DAFKE',
   value_it = 'DAFKE',
   value_ro = 'DAFKE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule, Schadensursache nicht feststellbar',
   description_de = 'Beule, Schadensursache nicht feststellbar',
   description_fr = 'Bosse, cause pas clairement identifiable',
   description_it = 'Protuberanza per cause non evidenti',
   description_ro = 'rrr_Beule, Schadensursache nicht feststellbar',
   display_en = 'DAFKE',
   display_de = 'DAFKE',
   display_fr = 'DAFKE',
   display_it = 'DAFKE',
   display_ro = 'DAFKE'
WHERE code =8922;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8923,8923) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFKZ',
   value_de = 'DAFKZ',
   value_fr = 'DAFKZ',
   value_it = 'DAFKZ',
   value_ro = 'DAFKZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule, andere Ursache',
   description_de = 'Beule, andere Ursache',
   description_fr = 'Bosse, autre cause',
   description_it = 'Protuberanza per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Beule, andere Ursache',
   display_en = 'DAFKZ',
   display_de = 'DAFKZ',
   display_fr = 'DAFKZ',
   display_it = 'DAFKZ',
   display_ro = 'DAFKZ'
WHERE code =8923;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4214,4214) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFZA',
   value_de = 'DAFZA',
   value_fr = 'DAFZA',
   value_it = 'DAFZA',
   value_ro = 'DAFZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Oberflächenschaden durch mechanische Beschädigung',
   description_de = 'Anderer Oberflächenschaden durch mechanische Beschädigung',
   description_fr = 'Autre dégradation de surface par dégradation mécanique',
   description_it = 'Altri danni superficiali per danno meccanico (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAFZA',
   display_de = 'DAFZA',
   display_fr = 'DAFZA',
   display_it = 'DAFZA',
   display_ro = 'DAFZA'
WHERE code =4214;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4215,4215) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFZB',
   value_de = 'DAFZB',
   value_fr = 'DAFZB',
   value_it = 'DAFZB',
   value_ro = 'DAFZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Oberflächenschaden durch chemischen Angriff',
   description_de = 'Anderer Oberflächenschaden durch chemischen Angriff',
   description_fr = 'Autre dégradation de surface par attaque chimique',
   description_it = 'Altri danni superficiali per aggressione chimica (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAFZB',
   display_de = 'DAFZB',
   display_fr = 'DAFZB',
   display_it = 'DAFZB',
   display_ro = 'DAFZB'
WHERE code =4215;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4216,4216) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFZC',
   value_de = 'DAFZC',
   value_fr = 'DAFZC',
   value_it = 'DAFZC',
   value_ro = 'DAFZC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Oberflächenschaden durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_de = 'Anderer Oberflächenschaden durch chemischen Angriff im oberen Teil des Gerinnes oder weiter oben',
   description_fr = 'Autre dégradation de surface par attaque chimique sur la partie supérieure du tuyau',
   description_it = 'Altri danni superficiali per aggressione chimica nella parte superiore del tubo o più in alto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAFZC',
   display_de = 'DAFZC',
   display_fr = 'DAFZC',
   display_it = 'DAFZC',
   display_ro = 'DAFZC'
WHERE code =4216;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4217,4217) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFZD',
   value_de = 'DAFZD',
   value_fr = 'DAFZD',
   value_it = 'DAFZD',
   value_ro = 'DAFZD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Oberflächenschaden durch chemischen Angriff im unteren Teil des Gerinnes',
   description_de = 'Anderer Oberflächenschaden durch chemischen Angriff im unteren Teil des Gerinnes',
   description_fr = 'Autre dégradation de surface par attaque chimique sur la partie inférieure du tuyau',
   description_it = 'Altri danni superficiali per aggressione chimica nella parte inferiore del tubo (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAFZD',
   display_de = 'DAFZD',
   display_fr = 'DAFZD',
   display_it = 'DAFZD',
   display_ro = 'DAFZD'
WHERE code =4217;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4218,4218) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFZE',
   value_de = 'DAFZE',
   value_fr = 'DAFZE',
   value_it = 'DAFZE',
   value_ro = 'DAFZE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Oberflächenschaden, Schadensursache nicht feststellbar',
   description_de = 'Anderer Oberflächenschaden, Schadensursache nicht feststellbar',
   description_fr = 'Autre dégradation de surface, cause pas clairement identifiable (plus de détails requis dans la note)',
   description_it = 'Altri danni superficiali per cause non evidenti (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAFZE',
   display_de = 'DAFZE',
   display_fr = 'DAFZE',
   display_it = 'DAFZE',
   display_ro = 'DAFZE'
WHERE code =4218;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8924,8924) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAFZZ',
   value_de = 'DAFZZ',
   value_fr = 'DAFZZ',
   value_it = 'DAFZZ',
   value_ro = 'DAFZZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anderer Oberflächenschaden, andere Ursache',
   description_de = 'Anderer Oberflächenschaden, andere Ursache',
   description_fr = 'Autre dégradation de surface, autre cause',
   description_it = 'Altri danni superficiali, per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Anderer Oberflächenschaden, andere Ursache',
   display_en = 'DAFZZ',
   display_de = 'DAFZZ',
   display_fr = 'DAFZZ',
   display_it = 'DAFZZ',
   display_ro = 'DAFZZ'
WHERE code =8924;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4219,4219) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAG',
   value_de = 'DAG',
   value_fr = 'DAG',
   value_it = 'DAG',
   value_ro = 'DAG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss einragend',
   description_de = 'Anschluss einragend',
   description_fr = 'Branchement pénétrant',
   description_it = 'Allacciamento sporgente',
   description_ro = '',
   display_en = 'DAG',
   display_de = 'DAG',
   display_fr = 'DAG',
   display_it = 'DAG',
   display_ro = 'DAG'
WHERE code =4219;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4220,4220) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAHA',
   value_de = 'DAHA',
   value_fr = 'DAHA',
   value_it = 'DAHA',
   value_ro = 'DAHA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss falsch eingeführt',
   description_de = 'Anschluss falsch eingeführt',
   description_fr = 'Raccordement à position incorrecte',
   description_it = 'Allacciamento inserito in modo errato',
   description_ro = '',
   display_en = 'DAHA',
   display_de = 'DAHA',
   display_fr = 'DAHA',
   display_it = 'DAHA',
   display_ro = 'DAHA'
WHERE code =4220;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4221,4221) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAHB',
   value_de = 'DAHB',
   value_fr = 'DAHB',
   value_it = 'DAHB',
   value_ro = 'DAHB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss zurückliegend',
   description_de = 'Anschluss zurückliegend',
   description_fr = 'Raccordement en retrait',
   description_it = 'Allacciamento non raccordato a filo della parte del pozzetto',
   description_ro = '',
   display_en = 'DAHB',
   display_de = 'DAHB',
   display_fr = 'DAHB',
   display_it = 'DAHB',
   display_ro = 'DAHB'
WHERE code =4221;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4222,4222) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAHC',
   value_de = 'DAHC',
   value_fr = 'DAHC',
   value_it = 'DAHC',
   value_ro = 'DAHC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss unvollständig oder nicht eingebunden',
   description_de = 'Anschluss unvollständig oder nicht eingebunden',
   description_fr = 'Raccordement incomplet ou non étanche',
   description_it = 'Allacciamento non raccordato a tenuta stagna o solo parzialmente',
   description_ro = '',
   display_en = 'DAHC',
   display_de = 'DAHC',
   display_fr = 'DAHC',
   display_it = 'DAHC',
   display_ro = 'DAHC'
WHERE code =4222;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4223,4223) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAHD',
   value_de = 'DAHD',
   value_fr = 'DAHD',
   value_it = 'DAHD',
   value_ro = 'DAHD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss beschädigt',
   description_de = 'Anschluss beschädigt',
   description_fr = 'Raccordement endommagé',
   description_it = 'Tubo di raccordo danneggiato',
   description_ro = '',
   display_en = 'DAHD',
   display_de = 'DAHD',
   display_fr = 'DAHD',
   display_it = 'DAHD',
   display_ro = 'DAHD'
WHERE code =4223;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4224,4224) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAHE',
   value_de = 'DAHE',
   value_fr = 'DAHE',
   value_it = 'DAHE',
   value_ro = 'DAHE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss verstopft',
   description_de = 'Anschluss verstopft',
   description_fr = 'Raccordement obstrué',
   description_it = 'Allacciamento ostruito',
   description_ro = '',
   display_en = 'DAHE',
   display_de = 'DAHE',
   display_fr = 'DAHE',
   display_it = 'DAHE',
   display_ro = 'DAHE'
WHERE code =4224;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4225,4225) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAHZ',
   value_de = 'DAHZ',
   value_fr = 'DAHZ',
   value_it = 'DAHZ',
   value_ro = 'DAHZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss andersartig schadhaft',
   description_de = 'Anschluss andersartig schadhaft',
   description_fr = 'Raccordement défectueux',
   description_it = 'Allacciamento danneggiato per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAHZ',
   display_de = 'DAHZ',
   display_fr = 'DAHZ',
   display_it = 'DAHZ',
   display_ro = 'DAHZ'
WHERE code =4225;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4226,4226) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAIAA',
   value_de = 'DAIAA',
   value_fr = 'DAIAA',
   value_it = 'DAIAA',
   value_ro = 'DAIAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring verschoben',
   description_de = 'Dichtring verschoben',
   description_fr = 'Joint d’étanchéité déplacé',
   description_it = 'Guarnizione spostata',
   description_ro = '',
   display_en = 'DAIAA',
   display_de = 'DAIAA',
   display_fr = 'DAIAA',
   display_it = 'DAIAA',
   display_ro = 'DAIAA'
WHERE code =4226;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4227,4227) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAIAB',
   value_de = 'DAIAB',
   value_fr = 'DAIAB',
   value_it = 'DAIAB',
   value_ro = 'DAIAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring hängend, aber nicht gebrochen',
   description_de = 'Dichtring hängend, aber nicht gebrochen ',
   description_fr = 'Joint d’étanchéité pendant, mais non rompu',
   description_it = 'Guarnizione sporgente ma non rotta',
   description_ro = '',
   display_en = 'DAIAB',
   display_de = 'DAIAB',
   display_fr = 'DAIAB',
   display_it = 'DAIAB',
   display_ro = 'DAIAB'
WHERE code =4227;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4228,4228) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAIAC',
   value_de = 'DAIAC',
   value_fr = 'DAIAC',
   value_it = 'DAIAC',
   value_ro = 'DAIAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Dichtring einragend, gebrochen',
   description_de = 'Dichtring einragend, gebrochen ',
   description_fr = 'Joint d’étanchéité apparent, rompu',
   description_it = 'Guarnizione sporgente rotta',
   description_ro = '',
   display_en = 'DAIAC',
   display_de = 'DAIAC',
   display_fr = 'DAIAC',
   display_it = 'DAIAC',
   display_ro = 'DAIAC'
WHERE code =4228;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4229,4229) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAIZ',
   value_de = 'DAIZ',
   value_fr = 'DAIZ',
   value_it = 'DAIZ',
   value_ro = 'DAIZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Einragendes Dichtungsmaterial',
   description_de = 'Einragendes Dichtungsmaterial',
   description_fr = 'Joint d’étanchéité apparent',
   description_it = 'Intrusione di materiale sigillante (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAIZ',
   display_de = 'DAIZ',
   display_fr = 'DAIZ',
   display_it = 'DAIZ',
   display_ro = 'DAIZ'
WHERE code =4229;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4230,4230) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAJA',
   value_de = 'DAJA',
   value_fr = 'DAJA',
   value_it = 'DAJA',
   value_ro = 'DAJA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Breite Schachtelementverbindung',
   description_de = 'Breite Schachtelementverbindung',
   description_fr = 'Assemblage déboîté d’éléments du regard de visite',
   description_it = 'Spostamento verticale tra gli elementi del pozzetto',
   description_ro = '',
   display_en = 'DAJA',
   display_de = 'DAJA',
   display_fr = 'DAJA',
   display_it = 'DAJA',
   display_ro = 'DAJA'
WHERE code =4230;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4231,4231) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAJB',
   value_de = 'DAJB',
   value_fr = 'DAJB',
   value_it = 'DAJB',
   value_ro = 'DAJB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schachtelement versetzt',
   description_de = 'Schachtelement versetzt',
   description_fr = 'Elément du regard de visite déplacé',
   description_it = 'Spostamento orizzontale tra gli elementi del pozzetto',
   description_ro = '',
   display_en = 'DAJB',
   display_de = 'DAJB',
   display_fr = 'DAJB',
   display_it = 'DAJB',
   display_ro = 'DAJB'
WHERE code =4231;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4232,4232) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAJC',
   value_de = 'DAJC',
   value_fr = 'DAJC',
   value_it = 'DAJC',
   value_ro = 'DAJC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schachtelemente Knick',
   description_de = 'Schachtelemente Knick',
   description_fr = 'Eléments du regard de visite déviés',
   description_it = 'Spostamento angolare tra gli elementi del pozzetto',
   description_ro = '',
   display_en = 'DAJC',
   display_de = 'DAJC',
   display_fr = 'DAJC',
   display_it = 'DAJC',
   display_ro = 'DAJC'
WHERE code =4232;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4233,4233) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKA',
   value_de = 'DAKA',
   value_fr = 'DAKA',
   value_it = 'DAKA',
   value_ro = 'DAKA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidung abgelöst',
   description_de = 'Auskleidung abgelöst',
   description_fr = 'Revêtement détaché',
   description_it = 'Rivestimento staccato',
   description_ro = '',
   display_en = 'DAKA',
   display_de = 'DAKA',
   display_fr = 'DAKA',
   display_it = 'DAKA',
   display_ro = 'DAKA'
WHERE code =4233;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4234,4234) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKB',
   value_de = 'DAKB',
   value_fr = 'DAKB',
   value_it = 'DAKB',
   value_ro = 'DAKB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidung verfärbt',
   description_de = 'Auskleidung verfärbt',
   description_fr = 'Revêtement décoloré',
   description_it = 'Rivestimento scolorito',
   description_ro = '',
   display_en = 'DAKB',
   display_de = 'DAKB',
   display_fr = 'DAKB',
   display_it = 'DAKB',
   display_ro = 'DAKB'
WHERE code =4234;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4235,4235) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKC',
   value_de = 'DAKC',
   value_fr = 'DAKC',
   value_it = 'DAKC',
   value_ro = 'DAKC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Endstelle der Auskleidung schadhaft',
   description_de = 'Endstelle der Auskleidung schadhaft',
   description_fr = 'Extrémité du revêtement défectueuse',
   description_it = 'Estremità del rivestimento difettoso',
   description_ro = '',
   display_en = 'DAKC',
   display_de = 'DAKC',
   display_fr = 'DAKC',
   display_it = 'DAKC',
   display_ro = 'DAKC'
WHERE code =4235;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4236,4236) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKDA',
   value_de = 'DAKDA',
   value_fr = 'DAKDA',
   value_it = 'DAKDA',
   value_ro = 'DAKDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Vertikale Faltenbildung in der Auskleidung',
   description_de = 'Vertikale Faltenbildung in der Auskleidung',
   description_fr = 'Revêtement ondulé verticalement',
   description_it = 'Rivestimento con grinze/pieghe verticali',
   description_ro = '',
   display_en = 'DAKDA',
   display_de = 'DAKDA',
   display_fr = 'DAKDA',
   display_it = 'DAKDA',
   display_ro = 'DAKDA'
WHERE code =4236;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4237,4237) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKDB',
   value_de = 'DAKDB',
   value_fr = 'DAKDB',
   value_it = 'DAKDB',
   value_ro = 'DAKDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Horizontale Faltenbildung in der Auskleidung',
   description_de = 'Horizontale Faltenbildung in der Auskleidung',
   description_fr = 'Revêtement ondulé horizontalement',
   description_it = 'Rivestimento con grinze/pieghe orizzontali',
   description_ro = '',
   display_en = 'DAKDB',
   display_de = 'DAKDB',
   display_fr = 'DAKDB',
   display_it = 'DAKDB',
   display_ro = 'DAKDB'
WHERE code =4237;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4238,4238) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKDC',
   value_de = 'DAKDC',
   value_fr = 'DAKDC',
   value_it = 'DAKDC',
   value_ro = 'DAKDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Komplexe Faltenbildung in der Auskleidung',
   description_de = 'Komplexe Faltenbildung in der Auskleidung',
   description_fr = 'Revêtement ondulé de façon complexe',
   description_it = 'Rivestimento con grinze/pieghe complesse',
   description_ro = '',
   display_en = 'DAKDC',
   display_de = 'DAKDC',
   display_fr = 'DAKDC',
   display_it = 'DAKDC',
   display_ro = 'DAKDC'
WHERE code =4238;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8925,8925) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKDD',
   value_de = 'DAKDD',
   value_fr = 'DAKDD',
   value_it = 'DAKDD',
   value_ro = 'DAKDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spiralförmige Faltenbildung in der Auskleidung',
   description_de = 'Spiralförmige Faltenbildung in der Auskleidung',
   description_fr = 'Revêtement ondulé en forme de spirale',
   description_it = 'Rivestimento con grinze/pieghe elicoidali',
   description_ro = 'rrr_Spiralförmige Faltenbildung in der Auskleidung',
   display_en = 'DAKDD',
   display_de = 'DAKDD',
   display_fr = 'DAKDD',
   display_it = 'DAKDD',
   display_ro = 'DAKDD'
WHERE code =8925;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4239,4239) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKE',
   value_de = 'DAKE',
   value_fr = 'DAKE',
   value_it = 'DAKE',
   value_ro = 'DAKE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Blasen / Beulen in der Auskleidung',
   description_de = 'Blasen / Beulen in der Auskleidung',
   description_fr = 'Revêtement cloqué',
   description_it = 'Rivestimento con bolle e ammaccature',
   description_ro = '',
   display_en = 'DAKE',
   display_de = 'DAKE',
   display_fr = 'DAKE',
   display_it = 'DAKE',
   display_ro = 'DAKE'
WHERE code =4239;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8926,8926) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKF',
   value_de = 'DAKF',
   value_fr = 'DAKF',
   value_it = 'DAKF',
   value_ro = 'DAKF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beule derAuskleidung nach aussen',
   description_de = 'Beule derAuskleidung nach aussen',
   description_fr = 'Revêtement cloqué vers l’extérieur',
   description_it = 'Rivestimento con bolle verso esterno',
   description_ro = 'rrr_Beule derAuskleidung nach aussen',
   display_en = 'DAKF',
   display_de = 'DAKF',
   display_fr = 'DAKF',
   display_it = 'DAKF',
   display_ro = 'DAKF'
WHERE code =8926;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8927,8927) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKG',
   value_de = 'DAKG',
   value_fr = 'DAKG',
   value_it = 'DAKG',
   value_ro = 'DAKG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablösen der Innenhaut / Beschichtung',
   description_de = 'Ablösen der Innenhaut / Beschichtung',
   description_fr = 'Décollement de la peau intérieure / du revêtement',
   description_it = 'Distacco della pellicola interna/rivestimento',
   description_ro = 'rrr_Ablösen der Innenhaut / Beschichtung',
   display_en = 'DAKG',
   display_de = 'DAKG',
   display_fr = 'DAKG',
   display_it = 'DAKG',
   display_ro = 'DAKG'
WHERE code =8927;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8928,8928) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKH',
   value_de = 'DAKH',
   value_fr = 'DAKH',
   value_it = 'DAKH',
   value_ro = 'DAKH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablösen der Abdeckung der Verbindungsnaht',
   description_de = 'Ablösen der Abdeckung der Verbindungsnaht',
   description_fr = 'Décollement de la couture de connexion',
   description_it = 'Distacco della copertura della cucitura',
   description_ro = 'rrr_Ablösen der Abdeckung der Verbindungsnaht',
   display_en = 'DAKH',
   display_de = 'DAKH',
   display_fr = 'DAKH',
   display_it = 'DAKH',
   display_ro = 'DAKH'
WHERE code =8928;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8929,8929) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKI',
   value_de = 'DAKI',
   value_fr = 'DAKI',
   value_it = 'DAKI',
   value_ro = 'DAKI',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss oder Spalt in der Innenauskleidung',
   description_de = 'Riss oder Spalt in der Innenauskleidung',
   description_fr = 'Fissure ou espace dans la doublure intérieure (y compris la soudure défectueuse)',
   description_it = 'Fessura o spaccatura del rivestimento (incl. saldatura difettosa)',
   description_ro = 'rrr_Riss oder Spalt in der Innenauskleidung',
   display_en = 'DAKI',
   display_de = 'DAKI',
   display_fr = 'DAKI',
   display_it = 'DAKI',
   display_ro = 'DAKI'
WHERE code =8929;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8930,8930) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKJ',
   value_de = 'DAKJ',
   value_fr = 'DAKJ',
   value_it = 'DAKJ',
   value_ro = 'DAKJ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Loch in der Innauskleidung',
   description_de = 'Loch in der Innauskleidung',
   description_fr = 'Trou dans la doublure',
   description_it = 'Foro nel rivestimento',
   description_ro = 'rrr_Loch in der Innauskleidung',
   display_en = 'DAKJ',
   display_de = 'DAKJ',
   display_fr = 'DAKJ',
   display_it = 'DAKJ',
   display_ro = 'DAKJ'
WHERE code =8930;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8931,8931) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKK',
   value_de = 'DAKK',
   value_fr = 'DAKK',
   value_it = 'DAKK',
   value_ro = 'DAKK',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidungsverbindung defekt',
   description_de = 'Auskleidungsverbindung defekt',
   description_fr = 'Connexion de la doublure défectueuse',
   description_it = 'Giuntura del rivestimento difettosa',
   description_ro = 'rrr_Auskleidungsverbindung defekt',
   display_en = 'DAKK',
   display_de = 'DAKK',
   display_fr = 'DAKK',
   display_it = 'DAKK',
   display_ro = 'DAKK'
WHERE code =8931;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8932,8932) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKL',
   value_de = 'DAKL',
   value_fr = 'DAKL',
   value_it = 'DAKL',
   value_ro = 'DAKL',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidungswerkstoff erscheint weich',
   description_de = 'Auskleidungswerkstoff erscheint weich',
   description_fr = 'Le matériau de la doublure semble mou',
   description_it = 'Materiale del rivestimento risulta molle',
   description_ro = 'rrr_Auskleidungswerkstoff erscheint weich',
   display_en = 'DAKL',
   display_de = 'DAKL',
   display_fr = 'DAKL',
   display_it = 'DAKL',
   display_ro = 'DAKL'
WHERE code =8932;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8933,8933) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKM',
   value_de = 'DAKM',
   value_fr = 'DAKM',
   value_it = 'DAKM',
   value_ro = 'DAKM',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Harz fehlt im Laminat',
   description_de = 'Harz fehlt im Laminat',
   description_fr = 'La résine manque dans le stratifié',
   description_it = 'Manca la resina nel laminato',
   description_ro = 'rrr_Harz fehlt im Laminat',
   display_en = 'DAKM',
   display_de = 'DAKM',
   display_fr = 'DAKM',
   display_it = 'DAKM',
   display_ro = 'DAKM'
WHERE code =8933;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8934,8934) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKN',
   value_de = 'DAKN',
   value_fr = 'DAKN',
   value_it = 'DAKN',
   value_ro = 'DAKN',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ende der Auskleidung ist nicht abgedichtet',
   description_de = 'Ende der Auskleidung ist nicht abgedichtet',
   description_fr = 'Fin de la doublure non scellée',
   description_it = 'Estremità del rivestimento non sigillato',
   description_ro = 'rrr_Ende der Auskleidung ist nicht abgedichtet',
   display_en = 'DAKN',
   display_de = 'DAKN',
   display_fr = 'DAKN',
   display_it = 'DAKN',
   display_ro = 'DAKN'
WHERE code =8934;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4240,4240) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAKZ',
   value_de = 'DAKZ',
   value_fr = 'DAKZ',
   value_it = 'DAKZ',
   value_ro = 'DAKZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Auskleidung andersartig mangelhaft',
   description_de = 'Auskleidung andersartig mangelhaft',
   description_fr = 'Revêtement défectueux',
   description_it = 'Rivestimento difettoso per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAKZ',
   display_de = 'DAKZ',
   display_fr = 'DAKZ',
   display_it = 'DAKZ',
   display_ro = 'DAKZ'
WHERE code =4240;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4241,4241) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALA',
   value_de = 'DALA',
   value_fr = 'DALA',
   value_it = 'DALA',
   value_ro = 'DALA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur mangelhaft, Wand fehlt teilweise',
   description_de = 'Reparatur mangelhaft, Wand fehlt teilweise',
   description_fr = 'Réparation défectueuse, paroi manquante',
   description_it = 'Riparazione difettosa, parte della parete mancante',
   description_ro = '',
   display_en = 'DALA',
   display_de = 'DALA',
   display_fr = 'DALA',
   display_it = 'DALA',
   display_ro = 'DALA'
WHERE code =4241;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4242,4242) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALB',
   value_de = 'DALB',
   value_fr = 'DALB',
   value_it = 'DALB',
   value_ro = 'DALB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur Loch mangelhaft',
   description_de = 'Reparatur Loch mangelhaft',
   description_fr = 'Réparation d’un trou défectueuse',
   description_it = 'Rattoppo foro difettoso',
   description_ro = '',
   display_en = 'DALB',
   display_de = 'DALB',
   display_fr = 'DALB',
   display_it = 'DALB',
   display_ro = 'DALB'
WHERE code =4242;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8935,8935) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALC',
   value_de = 'DALC',
   value_fr = 'DALC',
   value_it = 'DALC',
   value_ro = 'DALC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparaturwerkstoff löst sich von der Wand',
   description_de = 'Reparaturwerkstoff löst sich von der Wand',
   description_fr = 'Le matériau de réparation se décolle du mur',
   description_it = 'Materiale di riparazione si stacca dalla parete',
   description_ro = 'rrr_Reparaturwerkstoff löst sich von der Wand',
   display_en = 'DALC',
   display_de = 'DALC',
   display_fr = 'DALC',
   display_it = 'DALC',
   display_ro = 'DALC'
WHERE code =8935;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8936,8936) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALD',
   value_de = 'DALD',
   value_fr = 'DALD',
   value_it = 'DALD',
   value_ro = 'DALD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparaturwerkstoff fehlt an der Kontaktfläche',
   description_de = 'Reparaturwerkstoff fehlt an der Kontaktfläche',
   description_fr = 'Le matériau de réparation est manquant sur la surface de contact',
   description_it = 'Materiale di riparazione manca sulla superficie di contatto',
   description_ro = 'rrr_Reparaturwerkstoff fehlt an der Kontaktfläche',
   display_en = 'DALD',
   display_de = 'DALD',
   display_fr = 'DALD',
   display_it = 'DALD',
   display_ro = 'DALD'
WHERE code =8936;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8937,8937) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALE',
   value_de = 'DALE',
   value_fr = 'DALE',
   value_it = 'DALE',
   value_ro = 'DALE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Überschüssiger Reparaturwerkstoff, Hindernis',
   description_de = 'Überschüssiger Reparaturwerkstoff, Hindernis',
   description_fr = 'Excédent de matériel de réparation, obstacle',
   description_it = 'Materiale di riparazione in eccesso, ostacolo',
   description_ro = 'rrr_Überschüssiger Reparaturwerkstoff, Hindernis',
   display_en = 'DALE',
   display_de = 'DALE',
   display_fr = 'DALE',
   display_it = 'DALE',
   display_ro = 'DALE'
WHERE code =8937;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8938,8938) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALF',
   value_de = 'DALF',
   value_fr = 'DALF',
   value_it = 'DALF',
   value_ro = 'DALF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Loch im Reparaturwerkstoff',
   description_de = 'Loch im Reparaturwerkstoff',
   description_fr = 'Trou dans le matériau de réparation',
   description_it = 'Foro nel materiale di riparazione',
   description_ro = 'rrr_Loch im Reparaturwerkstoff',
   display_en = 'DALF',
   display_de = 'DALF',
   display_fr = 'DALF',
   display_it = 'DALF',
   display_ro = 'DALF'
WHERE code =8938;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8939,8939) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALG',
   value_de = 'DALG',
   value_fr = 'DALG',
   value_it = 'DALG',
   value_ro = 'DALG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Riss im Reparaturwerkstoff, längs',
   description_de = 'Riss im Reparaturwerkstoff, längs',
   description_fr = 'Fissure dans le matériau de réparation, longitudinal',
   description_it = 'Fessura nel materiale di riparazione, longitudinale',
   description_ro = 'rrr_Riss im Reparaturwerkstoff, längs',
   display_en = 'DALG',
   display_de = 'DALG',
   display_fr = 'DALG',
   display_it = 'DALG',
   display_ro = 'DALG'
WHERE code =8939;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4243,4243) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DALZ',
   value_de = 'DALZ',
   value_fr = 'DALZ',
   value_it = 'DALZ',
   value_ro = 'DALZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur andersartig mangelhaft',
   description_de = 'Reparatur andersartig mangelhaft',
   description_fr = 'Réparation défectueuse',
   description_it = 'Riparazione difettosa per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DALZ',
   display_de = 'DALZ',
   display_fr = 'DALZ',
   display_it = 'DALZ',
   display_ro = 'DALZ'
WHERE code =4243;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4244,4244) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAMA',
   value_de = 'DAMA',
   value_fr = 'DAMA',
   value_it = 'DAMA',
   value_ro = 'DAMA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Vertikale Schweissnaht mangelhaft',
   description_de = 'Vertikale Schweissnaht mangelhaft ',
   description_fr = 'Défaut de soudage vertical',
   description_it = 'Saldatura verticale difettosa',
   description_ro = '',
   display_en = 'DAMA',
   display_de = 'DAMA',
   display_fr = 'DAMA',
   display_it = 'DAMA',
   display_ro = 'DAMA'
WHERE code =4244;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4245,4245) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAMB',
   value_de = 'DAMB',
   value_fr = 'DAMB',
   value_it = 'DAMB',
   value_ro = 'DAMB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Horizontale Schweissnaht mangelhaft',
   description_de = 'Horizontale Schweissnaht mangelhaft ',
   description_fr = 'Défaut de soudage horizontal',
   description_it = 'Saldatura orizzontale difettosa',
   description_ro = '',
   display_en = 'DAMB',
   display_de = 'DAMB',
   display_fr = 'DAMB',
   display_it = 'DAMB',
   display_ro = 'DAMB'
WHERE code =4245;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4246,4246) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAMC',
   value_de = 'DAMC',
   value_fr = 'DAMC',
   value_it = 'DAMC',
   value_ro = 'DAMC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schweissnaht mit spiralförmigem Verlauf mangelhaft',
   description_de = 'Schweissnaht mit spiralförmigem Verlauf mangelhaft ',
   description_fr = 'Défaut de soudage hélicoïdal',
   description_it = 'Saldatura elicoidale difettosa',
   description_ro = '',
   display_en = 'DAMC',
   display_de = 'DAMC',
   display_fr = 'DAMC',
   display_it = 'DAMC',
   display_ro = 'DAMC'
WHERE code =4246;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4247,4247) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAN',
   value_de = 'DAN',
   value_fr = 'DAN',
   value_it = 'DAN',
   value_ro = 'DAN',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schachtwand porös',
   description_de = 'Schachtwand porös',
   description_fr = 'Paroi du regard de visite poreuse',
   description_it = 'Parete del pozzetto porosa',
   description_ro = '',
   display_en = 'DAN',
   display_de = 'DAN',
   display_fr = 'DAN',
   display_it = 'DAN',
   display_ro = 'DAN'
WHERE code =4247;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4248,4248) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAO',
   value_de = 'DAO',
   value_fr = 'DAO',
   value_it = 'DAO',
   value_ro = 'DAO',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_anstehender Boden sichtbar',
   description_de = 'anstehender Boden sichtbar ',
   description_fr = 'Sol visible',
   description_it = 'Suolo visibile',
   description_ro = '',
   display_en = 'DAO',
   display_de = 'DAO',
   display_fr = 'DAO',
   display_it = 'DAO',
   display_ro = 'DAO'
WHERE code =4248;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4249,4249) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAP',
   value_de = 'DAP',
   value_fr = 'DAP',
   value_it = 'DAP',
   value_ro = 'DAP',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hohlraum sichtbar',
   description_de = 'Hohlraum sichtbar ',
   description_fr = 'Vide visible',
   description_it = 'Cavità visibile',
   description_ro = '',
   display_en = 'DAP',
   display_de = 'DAP',
   display_fr = 'DAP',
   display_it = 'DAP',
   display_ro = 'DAP'
WHERE code =4249;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4250,4250) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQA',
   value_de = 'DAQA',
   value_fr = 'DAQA',
   value_it = 'DAQA',
   value_ro = 'DAQA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe locker',
   description_de = 'Steighilfe locker',
   description_fr = 'Échelon déboîté',
   description_it = 'Scalino allentato',
   description_ro = '',
   display_en = 'DAQA',
   display_de = 'DAQA',
   display_fr = 'DAQA',
   display_it = 'DAQA',
   display_ro = 'DAQA'
WHERE code =4250;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4251,4251) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQB',
   value_de = 'DAQB',
   value_fr = 'DAQB',
   value_it = 'DAQB',
   value_ro = 'DAQB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe fehlt',
   description_de = 'Steighilfe fehlt',
   description_fr = 'Échelon manquant',
   description_it = 'Scalino mancante',
   description_ro = '',
   display_en = 'DAQB',
   display_de = 'DAQB',
   display_fr = 'DAQB',
   display_it = 'DAQB',
   display_ro = 'DAQB'
WHERE code =4251;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4252,4252) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQC',
   value_de = 'DAQC',
   value_fr = 'DAQC',
   value_it = 'DAQC',
   value_ro = 'DAQC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe korrodiert',
   description_de = 'Steighilfe korrodiert',
   description_fr = 'Échelon corrodé',
   description_it = 'Scalino corroso',
   description_ro = '',
   display_en = 'DAQC',
   display_de = 'DAQC',
   display_fr = 'DAQC',
   display_it = 'DAQC',
   display_ro = 'DAQC'
WHERE code =4252;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4253,4253) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQD',
   value_de = 'DAQD',
   value_fr = 'DAQD',
   value_it = 'DAQD',
   value_ro = 'DAQD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe verbogen',
   description_de = 'Steighilfe verbogen',
   description_fr = 'Échelon plié',
   description_it = 'Scalino ricurvo',
   description_ro = '',
   display_en = 'DAQD',
   display_de = 'DAQD',
   display_fr = 'DAQD',
   display_it = 'DAQD',
   display_ro = 'DAQD'
WHERE code =4253;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4254,4254) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQE',
   value_de = 'DAQE',
   value_fr = 'DAQE',
   value_it = 'DAQE',
   value_ro = 'DAQE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe Kunststoffverkleidung gebrochen',
   description_de = 'Steighilfe Kunststoffverkleidung gebrochen',
   description_fr = 'Revêtement plastique de l''échelon brisé',
   description_it = 'Il rivestimento in plastica dello scalino è rotto',
   description_ro = '',
   display_en = 'DAQE',
   display_de = 'DAQE',
   display_fr = 'DAQE',
   display_it = 'DAQE',
   display_ro = 'DAQE'
WHERE code =4254;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4255,4255) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQF',
   value_de = 'DAQF',
   value_fr = 'DAQF',
   value_it = 'DAQF',
   value_ro = 'DAQF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe Handlauf korrodiert',
   description_de = 'Steighilfe Handlauf korrodiert',
   description_fr = 'Main-courante de l’échelle corrodée',
   description_it = 'Corrosione del corrimano della scala',
   description_ro = '',
   display_en = 'DAQF',
   display_de = 'DAQF',
   display_fr = 'DAQF',
   display_it = 'DAQF',
   display_ro = 'DAQF'
WHERE code =4255;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4256,4256) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQG',
   value_de = 'DAQG',
   value_fr = 'DAQG',
   value_it = 'DAQG',
   value_ro = 'DAQG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Absturzsicherung locker',
   description_de = 'Absturzsicherung locker',
   description_fr = 'Protection antichute déboîtée',
   description_it = 'Protezione anticaduta allentata',
   description_ro = '',
   display_en = 'DAQG',
   display_de = 'DAQG',
   display_fr = 'DAQG',
   display_it = 'DAQG',
   display_ro = 'DAQG'
WHERE code =4256;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4257,4257) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQH',
   value_de = 'DAQH',
   value_fr = 'DAQH',
   value_it = 'DAQH',
   value_ro = 'DAQH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Absturzsicherung fehlt',
   description_de = 'Absturzsicherung fehlt ',
   description_fr = 'Protection antichute manquante',
   description_it = 'Protezione anticaduta mancante',
   description_ro = '',
   display_en = 'DAQH',
   display_de = 'DAQH',
   display_fr = 'DAQH',
   display_it = 'DAQH',
   display_ro = 'DAQH'
WHERE code =4257;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4258,4258) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQI',
   value_de = 'DAQI',
   value_fr = 'DAQI',
   value_it = 'DAQI',
   value_ro = 'DAQI',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Absturzsicherung korrodiert',
   description_de = 'Absturzsicherung korrodiert',
   description_fr = 'Protection antichute corrodée',
   description_it = 'Protezione anticaduta corrosa',
   description_ro = '',
   display_en = 'DAQI',
   display_de = 'DAQI',
   display_fr = 'DAQI',
   display_it = 'DAQI',
   display_ro = 'DAQI'
WHERE code =4258;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4259,4259) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQJ',
   value_de = 'DAQJ',
   value_fr = 'DAQJ',
   value_it = 'DAQJ',
   value_ro = 'DAQJ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Leitersprossen korrodiert',
   description_de = 'Leitersprossen korrodiert',
   description_fr = 'Échelons d’échelle corrodés',
   description_it = 'Pioli della scala corrosi',
   description_ro = '',
   display_en = 'DAQJ',
   display_de = 'DAQJ',
   display_fr = 'DAQJ',
   display_it = 'DAQJ',
   display_ro = 'DAQJ'
WHERE code =4259;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4260,4260) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQK',
   value_de = 'DAQK',
   value_fr = 'DAQK',
   value_it = 'DAQK',
   value_ro = 'DAQK',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steigkasten schadhaft',
   description_de = 'Steigkasten schadhaft',
   description_fr = 'Trou d''homme défectueux',
   description_it = 'Appoggio per i piedi difettoso',
   description_ro = '',
   display_en = 'DAQK',
   display_de = 'DAQK',
   display_fr = 'DAQK',
   display_it = 'DAQK',
   display_ro = 'DAQK'
WHERE code =4260;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4261,4261) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DAQZ',
   value_de = 'DAQZ',
   value_fr = 'DAQZ',
   value_it = 'DAQZ',
   value_ro = 'DAQZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steighilfe andersweitig schadhaft',
   description_de = 'Steighilfe andersweitig schadhaft',
   description_fr = 'Échelle autrement défectueuse',
   description_it = 'Scalino o scala difettoso per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DAQZ',
   display_de = 'DAQZ',
   display_fr = 'DAQZ',
   display_it = 'DAQZ',
   display_ro = 'DAQZ'
WHERE code =4261;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4262,4262) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARA',
   value_de = 'DARA',
   value_fr = 'DARA',
   value_it = 'DARA',
   value_ro = 'DARA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Deckel gebrochen',
   description_de = 'Deckel gebrochen ',
   description_fr = 'Couvercle cassé',
   description_it = 'Chiusino rotto',
   description_ro = '',
   display_en = 'DARA',
   display_de = 'DARA',
   display_fr = 'DARA',
   display_it = 'DARA',
   display_ro = 'DARA'
WHERE code =4262;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4263,4263) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARB',
   value_de = 'DARB',
   value_fr = 'DARB',
   value_it = 'DARB',
   value_ro = 'DARB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Deckel wackelt',
   description_de = 'Deckel wackelt',
   description_fr = 'Couvercle oscillant',
   description_it = 'Chiusino traballante',
   description_ro = '',
   display_en = 'DARB',
   display_de = 'DARB',
   display_fr = 'DARB',
   display_it = 'DARB',
   display_ro = 'DARB'
WHERE code =4263;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4264,4264) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARC',
   value_de = 'DARC',
   value_fr = 'DARC',
   value_it = 'DARC',
   value_ro = 'DARC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Deckel fehlt',
   description_de = 'Deckel fehlt',
   description_fr = 'Couvercle manquant',
   description_it = 'Chiusino mancante',
   description_ro = '',
   display_en = 'DARC',
   display_de = 'DARC',
   display_fr = 'DARC',
   display_it = 'DARC',
   display_ro = 'DARC'
WHERE code =4264;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4265,4265) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARD',
   value_de = 'DARD',
   value_fr = 'DARD',
   value_it = 'DARD',
   value_ro = 'DARD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rahmen gebrochen',
   description_de = 'Rahmen gebrochen',
   description_fr = 'Cadre brisé',
   description_it = 'Telaio rotto',
   description_ro = '',
   display_en = 'DARD',
   display_de = 'DARD',
   display_fr = 'DARD',
   display_it = 'DARD',
   display_ro = 'DARD'
WHERE code =4265;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4266,4266) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARE',
   value_de = 'DARE',
   value_fr = 'DARE',
   value_it = 'DARE',
   value_ro = 'DARE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rahmen locker',
   description_de = 'Rahmen locker',
   description_fr = 'Cadre déboîté',
   description_it = 'Telaio instabile',
   description_ro = '',
   display_en = 'DARE',
   display_de = 'DARE',
   display_fr = 'DARE',
   display_it = 'DARE',
   display_ro = 'DARE'
WHERE code =4266;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4267,4267) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARF',
   value_de = 'DARF',
   value_fr = 'DARF',
   value_it = 'DARF',
   value_ro = 'DARF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rahmen fehlt',
   description_de = 'Rahmen fehlt',
   description_fr = 'Cadre manquant',
   description_it = 'Telaio mancante',
   description_ro = '',
   display_en = 'DARF',
   display_de = 'DARF',
   display_fr = 'DARF',
   display_it = 'DARF',
   display_ro = 'DARF'
WHERE code =4267;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4268,4268) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARG',
   value_de = 'DARG',
   value_fr = 'DARG',
   value_it = 'DARG',
   value_ro = 'DARG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abdeckung zu tief',
   description_de = 'Abdeckung zu tief',
   description_fr = 'Couvercle trop bas',
   description_it = 'Chiusino troppo basso',
   description_ro = '',
   display_en = 'DARG',
   display_de = 'DARG',
   display_fr = 'DARG',
   display_it = 'DARG',
   display_ro = 'DARG'
WHERE code =4268;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4269,4269) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARH',
   value_de = 'DARH',
   value_fr = 'DARH',
   value_it = 'DARH',
   value_ro = 'DARH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abdeckung zu hoch',
   description_de = 'Abdeckung zu hoch ',
   description_fr = 'Couvercle trop haut',
   description_it = 'Chiusino troppo alto',
   description_ro = '',
   display_en = 'DARH',
   display_de = 'DARH',
   display_fr = 'DARH',
   display_it = 'DARH',
   display_ro = 'DARH'
WHERE code =4269;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4270,4270) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DARZ',
   value_de = 'DARZ',
   value_fr = 'DARZ',
   value_it = 'DARZ',
   value_ro = 'DARZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abdeckung andersweitig schadhaft',
   description_de = 'Abdeckung andersweitig schadhaft',
   description_fr = 'Couvercle défectueux',
   description_it = 'Chiusino difettoso per altre cause (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DARZ',
   display_de = 'DARZ',
   display_fr = 'DARZ',
   display_it = 'DARZ',
   display_ro = 'DARZ'
WHERE code =4270;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4271,4271) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBAA',
   value_de = 'DBAA',
   value_fr = 'DBAA',
   value_it = 'DBAA',
   value_ro = 'DBAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Pfahlwurzel',
   description_de = 'Pfahlwurzel',
   description_fr = 'Grosse racine isolée',
   description_it = 'Tappo di radici',
   description_ro = '',
   display_en = 'DBAA',
   display_de = 'DBAA',
   display_fr = 'DBAA',
   display_it = 'DBAA',
   display_ro = ''
WHERE code =4271;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4272,4272) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBAB',
   value_de = 'DBAB',
   value_fr = 'DBAB',
   value_it = 'DBAB',
   value_ro = 'DBAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Einzelner, feiner Wurzeleinwuchs',
   description_de = 'Einzelner, feiner Wurzeleinwuchs',
   description_fr = 'Radicelles',
   description_it = 'Radici sottili singole',
   description_ro = '',
   display_en = 'DBAB',
   display_de = 'DBAB',
   display_fr = 'DBAB',
   display_it = 'DBAB',
   display_ro = ''
WHERE code =4272;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4273,4273) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBAC',
   value_de = 'DBAC',
   value_fr = 'DBAC',
   value_it = 'DBAC',
   value_ro = 'DBAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Komplexes Wurzelwerk',
   description_de = 'Komplexes Wurzelwerk',
   description_fr = 'Ensemble complexe de racines',
   description_it = 'Massa complessa di radici',
   description_ro = '',
   display_en = 'DBAC',
   display_de = 'DBAC',
   display_fr = 'DBAC',
   display_it = 'DBAC',
   display_ro = ''
WHERE code =4273;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4274,4274) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBBA',
   value_de = 'DBBA',
   value_fr = 'DBBA',
   value_it = 'DBBA',
   value_ro = 'DBBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inkrustation (verkalkt)',
   description_de = 'Inkrustation (verkalkt)',
   description_fr = 'Concrétions (calcifié)',
   description_it = 'Incrostazioni (calcificazione)',
   description_ro = '',
   display_en = 'DBBA',
   display_de = 'DBBA',
   display_fr = 'DBBA',
   display_it = 'DBBA',
   display_ro = ''
WHERE code =4274;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4275,4275) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBBB',
   value_de = 'DBBB',
   value_fr = 'DBBB',
   value_it = 'DBBB',
   value_ro = 'DBBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fett',
   description_de = 'Fett',
   description_fr = 'Graisse',
   description_it = 'Grasso',
   description_ro = '',
   display_en = 'DBBB',
   display_de = 'DBBB',
   display_fr = 'DBBB',
   display_it = 'DBBB',
   display_ro = ''
WHERE code =4275;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4276,4276) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBBC',
   value_de = 'DBBC',
   value_fr = 'DBBC',
   value_it = 'DBBC',
   value_ro = 'DBBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fäulnis',
   description_de = 'Fäulnis',
   description_fr = 'Moisissement',
   description_it = 'Incrostazioni organiche',
   description_ro = '',
   display_en = 'DBBC',
   display_de = 'DBBC',
   display_fr = 'DBBC',
   display_it = 'DBBC',
   display_ro = ''
WHERE code =4276;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4277,4277) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBBZ',
   value_de = 'DBBZ',
   value_fr = 'DBBZ',
   value_it = 'DBBZ',
   value_ro = 'DBBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige anhaftende Stoffe',
   description_de = 'Andersartige anhaftende Stoffe',
   description_fr = 'Autres substances adhérentes ',
   description_it = 'Altri depositi attaccati (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBBZ',
   display_de = 'DBBZ',
   display_fr = 'DBBZ',
   display_it = 'DBBZ',
   display_ro = ''
WHERE code =4277;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4278,4278) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBCA',
   value_de = 'DBCA',
   value_fr = 'DBCA',
   value_it = 'DBCA',
   value_ro = 'DBCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Lose Ablagerungen, Sand',
   description_de = 'Lose Ablagerungen, Sand',
   description_fr = 'Dépôts lâches, sable',
   description_it = 'Depositi sciolte, sabbia',
   description_ro = '',
   display_en = 'DBCA',
   display_de = 'DBCA',
   display_fr = 'DBCA',
   display_it = 'DBCA',
   display_ro = ''
WHERE code =4278;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4279,4279) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBCB',
   value_de = 'DBCB',
   value_fr = 'DBCB',
   value_it = 'DBCB',
   value_ro = 'DBCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Lose Ablagerungen, Kies',
   description_de = 'Lose Ablagerungen, Kies',
   description_fr = 'Dépôts lâches, gravier',
   description_it = 'Depositi sciolte, ghiaia',
   description_ro = '',
   display_en = 'DBCB',
   display_de = 'DBCB',
   display_fr = 'DBCB',
   display_it = 'DBCB',
   display_ro = ''
WHERE code =4279;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4280,4280) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBCC',
   value_de = 'DBCC',
   value_fr = 'DBCC',
   value_it = 'DBCC',
   value_ro = 'DBCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Harte Ablagerungen',
   description_de = 'Harte Ablagerungen',
   description_fr = 'Dépôts durs',
   description_it = 'Depositi duri',
   description_ro = '',
   display_en = 'DBCC',
   display_de = 'DBCC',
   display_fr = 'DBCC',
   display_it = 'DBCC',
   display_ro = ''
WHERE code =4280;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4281,4281) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBCZ',
   value_de = 'DBCZ',
   value_fr = 'DBCZ',
   value_it = 'DBCZ',
   value_ro = 'DBCZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Ablagerungen',
   description_de = 'Andersartige Ablagerungen',
   description_fr = 'Autres Dépôts',
   description_it = 'Altri tipi di depositi (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBCZ',
   display_de = 'DBCZ',
   display_fr = 'DBCZ',
   display_it = 'DBCZ',
   display_ro = ''
WHERE code =4281;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4282,4282) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBD',
   value_de = 'DBD',
   value_fr = 'DBD',
   value_it = 'DBD',
   value_ro = 'DBD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bodenmaterial dringt ein',
   description_de = 'Bodenmaterial dringt ein',
   description_fr = 'Entrée de terre',
   description_it = 'Penetrazione di materiale dal sottosuolo',
   description_ro = '',
   display_en = 'DBD',
   display_de = 'DBD',
   display_fr = 'DBD',
   display_it = 'DBD',
   display_ro = ''
WHERE code =4282;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4283,4283) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEA',
   value_de = 'DBEA',
   value_fr = 'DBEA',
   value_it = 'DBEA',
   value_ro = 'DBEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflusshindernis: Herausgefallener Mauer- oder Backstein',
   description_de = 'Abflusshindernis: Herausgefallener Mauer- oder Backstein',
   description_fr = 'Obstacle à l’écoulement dans la cunette: briquetage ou élément de maçonnerie délogé',
   description_it = 'Ostacolo al deflusso nella cunetta: mattoni o pezzi di muratura staccati',
   description_ro = '',
   display_en = 'DBEA',
   display_de = 'DBEA',
   display_fr = 'DBEA',
   display_it = 'DBEA',
   display_ro = ''
WHERE code =4283;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4284,4284) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEB',
   value_de = 'DBEB',
   value_fr = 'DBEB',
   value_it = 'DBEB',
   value_ro = 'DBEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflusshindernis: Herausgebrochenes Leitungsstück',
   description_de = 'Abflusshindernis: Herausgebrochenes Leitungsstück',
   description_fr = 'Obstacle à l’écoulement dans la cunette: fragment de canalisation brisé',
   description_it = 'Ostacolo al deflusso nella cunetta: pezzo di tubo rotto',
   description_ro = '',
   display_en = 'DBEB',
   display_de = 'DBEB',
   display_fr = 'DBEB',
   display_it = 'DBEB',
   display_ro = ''
WHERE code =4284;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4285,4285) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEC',
   value_de = 'DBEC',
   value_fr = 'DBEC',
   value_it = 'DBEC',
   value_ro = 'DBEC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abflusshindernis',
   description_de = 'Abflusshindernis',
   description_fr = 'Obstacle à l’écoulement dans la cunette',
   description_it = 'Ostacolo al deflusso nella cunetta',
   description_ro = '',
   display_en = 'DBEC',
   display_de = 'DBEC',
   display_fr = 'DBEC',
   display_it = 'DBEC',
   display_ro = ''
WHERE code =4285;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4286,4286) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBED',
   value_de = 'DBED',
   value_fr = 'DBED',
   value_it = 'DBED',
   value_ro = 'DBED',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ragt durch die Wand ein',
   description_de = 'Gegenstand ragt durch die Wand ein',
   description_fr = 'Obstacle dépassant de la paroi',
   description_it = 'Oggetto sporgente dalla parete',
   description_ro = '',
   display_en = 'DBED',
   display_de = 'DBED',
   display_fr = 'DBED',
   display_it = 'DBED',
   display_ro = ''
WHERE code =4286;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4287,4287) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEE',
   value_de = 'DBEE',
   value_fr = 'DBEE',
   value_it = 'DBEE',
   value_ro = 'DBEE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ist in der Schachtelementverbindung eingeklemmt',
   description_de = 'Gegenstand ist in der Schachtelementverbindung eingeklemmt',
   description_fr = 'Obstacle coincé dans l’assemblage des éléments du regard',
   description_it = 'Oggetto incuneato nel giunto tra elementi del pozzetto',
   description_ro = '',
   display_en = 'DBEE',
   display_de = 'DBEE',
   display_fr = 'DBEE',
   display_it = 'DBEE',
   display_ro = ''
WHERE code =4287;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4288,4288) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEF',
   value_de = 'DBEF',
   value_fr = 'DBEF',
   value_it = 'DBEF',
   value_ro = 'DBEF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ragt aus Anschluss',
   description_de = 'Gegenstand ragt aus Anschluss',
   description_fr = 'Obstacle dépassant du raccordement',
   description_it = 'Oggetto sporge da un allacciamento',
   description_ro = '',
   display_en = 'DBEF',
   display_de = 'DBEF',
   display_fr = 'DBEF',
   display_it = 'DBEF',
   display_ro = ''
WHERE code =4288;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4289,4289) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEG',
   value_de = 'DBEG',
   value_fr = 'DBEG',
   value_it = 'DBEG',
   value_ro = 'DBEG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fremde Werkleitungen oder Kabel durchqueren den Schacht',
   description_de = 'Fremde Werkleitungen oder Kabel durchqueren den Schacht',
   description_fr = 'Conduites externes ou câbles traversant le regard de visite',
   description_it = 'Condotte sotterranee o cavi attraversano il pozzetto',
   description_ro = '',
   display_en = 'DBEG',
   display_de = 'DBEG',
   display_fr = 'DBEG',
   display_it = 'DBEG',
   display_ro = ''
WHERE code =4289;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4290,4290) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEH',
   value_de = 'DBEH',
   value_fr = 'DBEH',
   value_it = 'DBEH',
   value_ro = 'DBEH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gegenstand ist in den Schacht eingebaut',
   description_de = 'Gegenstand ist in den Schacht eingebaut',
   description_fr = 'Obstacle intégré à la structure du regard',
   description_it = 'Oggetto inglobato nella struttura del pozzetto',
   description_ro = '',
   display_en = 'DBEH',
   display_de = 'DBEH',
   display_fr = 'DBEH',
   display_it = 'DBEH',
   display_ro = ''
WHERE code =4290;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4291,4291) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBEZ',
   value_de = 'DBEZ',
   value_fr = 'DBEZ',
   value_it = 'DBEZ',
   value_ro = 'DBEZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartiges Hindernis',
   description_de = 'Andersartiges Hindernis',
   description_fr = 'Autres obstacle',
   description_it = 'Altri ostacoli (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBEZ',
   display_de = 'DBEZ',
   display_fr = 'DBEZ',
   display_it = 'DBEZ',
   display_ro = ''
WHERE code =4291;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4292,4292) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFAA',
   value_de = 'DBFAA',
   value_fr = 'DBFAA',
   value_it = 'DBFAA',
   value_ro = 'DBFAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Schwitzen / Verkalkung an der Schachtwand',
   description_de = 'Infiltration: Schwitzen / Verkalkung an der Schachtwand',
   description_fr = 'Infiltration: suintement / entartrage de la paroi du regard de visite',
   description_it = 'Infiltrazioni: trasudamento/calcificazione alla parete del pozzetto',
   description_ro = '',
   display_en = 'DBFAA',
   display_de = 'DBFAA',
   display_fr = 'DBFAA',
   display_it = 'DBFAA',
   display_ro = ''
WHERE code =4292;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4293,4293) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFAB',
   value_de = 'DBFAB',
   value_fr = 'DBFAB',
   value_it = 'DBFAB',
   value_ro = 'DBFAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss im Sohlbereich ',
   description_de = 'Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss im Sohlbereich ',
   description_fr = 'Infiltration: suintement / entartrage de l’encastrement d’un raccordement au niveau du radier',
   description_it = 'Infiltrazioni: trasudamento/calcificazione del raccordo di un allacciamento a livello del fondo pozzetto',
   description_ro = '',
   display_en = 'DBFAB',
   display_de = 'DBFAB',
   display_fr = 'DBFAB',
   display_it = 'DBFAB',
   display_ro = ''
WHERE code =4293;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4294,4294) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFAC',
   value_de = 'DBFAC',
   value_fr = 'DBFAC',
   value_it = 'DBFAC',
   value_ro = 'DBFAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss oberhalb des Banketts',
   description_de = 'Infiltration: Schwitzen / Verkalkung der Einbindung eines Anschluss oberhalb des Banketts',
   description_fr = 'Infiltration: suintement / entartrage de l’encastrement d’un raccordement au-dessus de la banquette',
   description_it = 'Infiltrazioni: trasudamento/calcificazione del raccordo di allacciamento sopra la banchina',
   description_ro = '',
   display_en = 'DBFAC',
   display_de = 'DBFAC',
   display_fr = 'DBFAC',
   display_it = 'DBFAC',
   display_ro = ''
WHERE code =4294;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4295,4295) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFBA',
   value_de = 'DBFBA',
   value_fr = 'DBFBA',
   value_it = 'DBFBA',
   value_ro = 'DBFBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser tropft aus der Schachtwand',
   description_de = 'Infiltration: Wasser tropft aus der Schachtwand',
   description_fr = 'Infiltration: l’eau goutte de la paroi du regard de visite',
   description_it = 'Infiltrazioni: gocciolamento attraverso la parete del pozzetto',
   description_ro = '',
   display_en = 'DBFBA',
   display_de = 'DBFBA',
   display_fr = 'DBFBA',
   display_it = 'DBFBA',
   display_ro = ''
WHERE code =4295;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4296,4296) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFBB',
   value_de = 'DBFBB',
   value_fr = 'DBFBB',
   value_it = 'DBFBB',
   value_ro = 'DBFBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser tropft aus der Einbindung eines Anschluss im Sohlbereich',
   description_de = 'Infiltration: Wasser tropft aus der Einbindung eines Anschluss im Sohlbereich',
   description_fr = 'Infiltration: l’eau goutte de l’encastrement d’un raccordement au niveau du radier',
   description_it = 'Infiltrazioni: gocciolamento attraverso il raccordo del giunto di un allacciamento a livello del fondo pozzetto',
   description_ro = '',
   display_en = 'DBFBB',
   display_de = 'DBFBB',
   display_fr = 'DBFBB',
   display_it = 'DBFBB',
   display_ro = ''
WHERE code =4296;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4297,4297) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFBC',
   value_de = 'DBFBC',
   value_fr = 'DBFBC',
   value_it = 'DBFBC',
   value_ro = 'DBFBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser tropft aus der Einbindung eines Anschluss oberhalb des Banketts',
   description_de = 'Infiltration: Wasser tropft aus der Einbindung eines Anschluss oberhalb des Banketts',
   description_fr = 'Infiltration: l’eau goutte de l’encastrement d’un raccordement au-dessus de la banquette',
   description_it = 'Infiltrazioni: gocciolamento attraverso il raccordo del giunto di un allacciamento sopra la banchina',
   description_ro = '',
   display_en = 'DBFBC',
   display_de = 'DBFBC',
   display_fr = 'DBFBC',
   display_it = 'DBFBC',
   display_ro = ''
WHERE code =4297;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4298,4298) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFCA',
   value_de = 'DBFCA',
   value_fr = 'DBFCA',
   value_it = 'DBFCA',
   value_ro = 'DBFCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser fliesst aus der Schachtwand',
   description_de = 'Infiltration: Wasser fliesst aus der Schachtwand',
   description_fr = 'Infiltration: l’eau s’écoule de la paroi du regard de visite',
   description_it = 'Infiltrazioni: acqua penetra attraverso la parete del pozzetto',
   description_ro = '',
   display_en = 'DBFCA',
   display_de = 'DBFCA',
   display_fr = 'DBFCA',
   display_it = 'DBFCA',
   display_ro = ''
WHERE code =4298;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4299,4299) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFCB',
   value_de = 'DBFCB',
   value_fr = 'DBFCB',
   value_it = 'DBFCB',
   value_ro = 'DBFCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser fliesst aus der Einbindung eines Anschluss im Sohlbereich',
   description_de = 'Infiltration: Wasser fliesst aus der Einbindung eines Anschluss im Sohlbereich',
   description_fr = 'Infiltration: l’eau s’écoule de l’encastrement d’un raccordement au niveau du radier',
   description_it = 'Infiltrazioni: acqua penetra attraverso il raccordo del giunto di un allacciamento a livello del fondo pozzetto',
   description_ro = '',
   display_en = 'DBFCB',
   display_de = 'DBFCB',
   display_fr = 'DBFCB',
   display_it = 'DBFCB',
   display_ro = ''
WHERE code =4299;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4300,4300) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFCC',
   value_de = 'DBFCC',
   value_fr = 'DBFCC',
   value_it = 'DBFCC',
   value_ro = 'DBFCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser fliesst aus der Einbindung eines Anschluss oberhalb des Banketts',
   description_de = 'Infiltration: Wasser fliesst aus der Einbindung eines Anschluss oberhalb des Banketts',
   description_fr = 'Infiltration: l’eau s’écoule de l’encastrement d’un raccordement au-dessus de la banquette',
   description_it = 'Infiltrazioni: acqua penetra attraverso il raccordo del giunto di un allacciamento sopra la banchina',
   description_ro = '',
   display_en = 'DBFCC',
   display_de = 'DBFCC',
   display_fr = 'DBFCC',
   display_it = 'DBFCC',
   display_ro = ''
WHERE code =4300;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4301,4301) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFDA',
   value_de = 'DBFDA',
   value_fr = 'DBFDA',
   value_it = 'DBFDA',
   value_ro = 'DBFDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser spritzt aus der Schachtwand',
   description_de = 'Infiltration: Wasser spritzt aus der Schachtwand',
   description_fr = 'Infiltration: l’eau jaillit de la paroi du regard de visite',
   description_it = 'Infiltrazioni: zampillo dalla parete del pozzetto',
   description_ro = '',
   display_en = 'DBFDA',
   display_de = 'DBFDA',
   display_fr = 'DBFDA',
   display_it = 'DBFDA',
   display_ro = ''
WHERE code =4301;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4302,4302) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFDB',
   value_de = 'DBFDB',
   value_fr = 'DBFDB',
   value_it = 'DBFDB',
   value_ro = 'DBFDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser spritzt aus der Einbindung eines Anschluss im Sohlbereich',
   description_de = 'Infiltration: Wasser spritzt aus der Einbindung eines Anschluss im Sohlbereich',
   description_fr = 'Infiltration: l’eau jaillit de l’encastrement d’un raccordement au niveau du radier',
   description_it = 'Infiltrazioni: zampillo attraverso il raccordo del giunto di un allacciamento a livello del fondo pozzetto',
   description_ro = '',
   display_en = 'DBFDB',
   display_de = 'DBFDB',
   display_fr = 'DBFDB',
   display_it = 'DBFDB',
   display_ro = ''
WHERE code =4302;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4303,4303) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBFDC',
   value_de = 'DBFDC',
   value_fr = 'DBFDC',
   value_it = 'DBFDC',
   value_ro = 'DBFDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Infiltration: Wasser spritzt aus der Einbindung eines Anschluss oberhalb des Banketts',
   description_de = 'Infiltration: Wasser spritzt aus der Einbindung eines Anschluss oberhalb des Banketts',
   description_fr = 'Infiltration: l’eau jaillit de l’encastrement d’un raccordement au-dessus de la banquette',
   description_it = 'Infiltrazioni: zampillo attraverso il raccordo del giunto di un allacciamento sopra la banchina',
   description_ro = '',
   display_en = 'DBFDC',
   display_de = 'DBFDC',
   display_fr = 'DBFDC',
   display_it = 'DBFDC',
   display_ro = ''
WHERE code =4303;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4304,4304) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBG',
   value_de = 'DBG',
   value_fr = 'DBG',
   value_it = 'DBG',
   value_ro = 'DBG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Sichtbarer Wasseraustritt',
   description_de = 'Sichtbarer Wasseraustritt',
   description_fr = 'Fuite visible de la canalisation',
   description_it = 'Fuoriuscita visibile dal pozzetto',
   description_ro = '',
   display_en = 'DBG',
   display_de = 'DBG',
   display_fr = 'DBG',
   display_it = 'DBG',
   display_ro = ''
WHERE code =4304;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4305,4305) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHAA',
   value_de = 'DBHAA',
   value_fr = 'DBHAA',
   value_it = 'DBHAA',
   value_ro = 'DBHAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte im Schacht',
   description_de = 'Ratte im Schacht',
   description_fr = 'Rats dans le regard de visite',
   description_it = 'Ratti nel pozzetto',
   description_ro = '',
   display_en = 'DBHAA',
   display_de = 'DBHAA',
   display_fr = 'DBHAA',
   display_it = 'DBHAA',
   display_ro = ''
WHERE code =4305;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4306,4306) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHAB',
   value_de = 'DBHAB',
   value_fr = 'DBHAB',
   value_it = 'DBHAB',
   value_ro = 'DBHAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte im Anschluss',
   description_de = 'Ratte im Anschluss',
   description_fr = 'Rats dans le raccordement',
   description_it = 'Ratti in un allacciamento',
   description_ro = '',
   display_en = 'DBHAB',
   display_de = 'DBHAB',
   display_fr = 'DBHAB',
   display_it = 'DBHAB',
   display_ro = ''
WHERE code =4306;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4307,4307) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHAC',
   value_de = 'DBHAC',
   value_fr = 'DBHAC',
   value_it = 'DBHAC',
   value_ro = 'DBHAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte in der offenen Schachtelementverbindung',
   description_de = 'Ratte in der offenen Schachtelementverbindung',
   description_fr = 'Rats dans l’assemblage ouvert du regard de visite',
   description_it = 'Ratti in un elemento di giunzione aperto del pozzetto',
   description_ro = '',
   display_en = 'DBHAC',
   display_de = 'DBHAC',
   display_fr = 'DBHAC',
   display_it = 'DBHAC',
   display_ro = ''
WHERE code =4307;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4308,4308) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHAZ',
   value_de = 'DBHAZ',
   value_fr = 'DBHAZ',
   value_it = 'DBHAZ',
   value_ro = 'DBHAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ratte',
   description_de = 'Ratte',
   description_fr = 'Rats',
   description_it = 'Ratti (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBHAZ',
   display_de = 'DBHAZ',
   display_fr = 'DBHAZ',
   display_it = 'DBHAZ',
   display_ro = ''
WHERE code =4308;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4309,4309) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHBA',
   value_de = 'DBHBA',
   value_fr = 'DBHBA',
   value_it = 'DBHBA',
   value_ro = 'DBHBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlaken im Schacht',
   description_de = 'Kakerlaken im Schacht',
   description_fr = 'Cafards dans le regard de visite',
   description_it = 'Scarafaggi nel pozzetto',
   description_ro = '',
   display_en = 'DBHBA',
   display_de = 'DBHBA',
   display_fr = 'DBHBA',
   display_it = 'DBHBA',
   display_ro = ''
WHERE code =4309;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4310,4310) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHBB',
   value_de = 'DBHBB',
   value_fr = 'DBHBB',
   value_it = 'DBHBB',
   value_ro = 'DBHBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlaken im Anschluss',
   description_de = 'Kakerlaken im Anschluss',
   description_fr = 'Cafards dans le raccordement',
   description_it = 'Scarafaggi in un allacciamento',
   description_ro = '',
   display_en = 'DBHBB',
   display_de = 'DBHBB',
   display_fr = 'DBHBB',
   display_it = 'DBHBB',
   display_ro = ''
WHERE code =4310;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4311,4311) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHBC',
   value_de = 'DBHBC',
   value_fr = 'DBHBC',
   value_it = 'DBHBC',
   value_ro = 'DBHBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlaken in der offenen Schachtelementverbindung',
   description_de = 'Kakerlaken in der offenen Schachtelementverbindung',
   description_fr = 'Cafards dans l’assemblage ouvert du regard de visite',
   description_it = 'Scarafaggi in un elemento di giunzione aperto del pozzetto',
   description_ro = '',
   display_en = 'DBHBC',
   display_de = 'DBHBC',
   display_fr = 'DBHBC',
   display_it = 'DBHBC',
   display_ro = ''
WHERE code =4311;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4312,4312) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHBZ',
   value_de = 'DBHBZ',
   value_fr = 'DBHBZ',
   value_it = 'DBHBZ',
   value_ro = 'DBHBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kakerlaken',
   description_de = 'Kakerlaken',
   description_fr = 'Cafards',
   description_it = 'Scarafaggi (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBHBZ',
   display_de = 'DBHBZ',
   display_fr = 'DBHBZ',
   display_it = 'DBHBZ',
   display_ro = ''
WHERE code =4312;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4313,4313) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHZA',
   value_de = 'DBHZA',
   value_fr = 'DBHZA',
   value_it = 'DBHZA',
   value_ro = 'DBHZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier im Schacht',
   description_de = 'Tier im Schacht',
   description_fr = 'Animaux dans le regard de visite',
   description_it = 'Animali nel pozzetto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBHZA',
   display_de = 'DBHZA',
   display_fr = 'DBHZA',
   display_it = 'DBHZA',
   display_ro = ''
WHERE code =4313;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4314,4314) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHZB',
   value_de = 'DBHZB',
   value_fr = 'DBHZB',
   value_it = 'DBHZB',
   value_ro = 'DBHZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier im Anschluss',
   description_de = 'Tier im Anschluss',
   description_fr = 'Animaux dans le raccordement',
   description_it = 'Animal in un allacciamento (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBHZB',
   display_de = 'DBHZB',
   display_fr = 'DBHZB',
   display_it = 'DBHZB',
   display_ro = ''
WHERE code =4314;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4315,4315) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHZC',
   value_de = 'DBHZC',
   value_fr = 'DBHZC',
   value_it = 'DBHZC',
   value_ro = 'DBHZC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier in der offenen Schachtelementverbindung',
   description_de = 'Tier in der offenen Schachtelementverbindung',
   description_fr = 'Animaux dans l’assemblage ouvert du regard de visite',
   description_it = 'Animali in un elemento di giunzione aperto del pozzetto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBHZC',
   display_de = 'DBHZC',
   display_fr = 'DBHZC',
   display_it = 'DBHZC',
   display_ro = ''
WHERE code =4315;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4316,4316) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DBHZZ',
   value_de = 'DBHZZ',
   value_fr = 'DBHZZ',
   value_it = 'DBHZZ',
   value_ro = 'DBHZZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Tier',
   description_de = 'Tier',
   description_fr = 'Animaux',
   description_it = 'Animali in genere (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DBHZZ',
   display_de = 'DBHZZ',
   display_fr = 'DBHZZ',
   display_it = 'DBHZZ',
   display_ro = ''
WHERE code =4316;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4317,4317) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAA',
   value_de = 'DCAA',
   value_fr = 'DCAA',
   value_it = 'DCAA',
   value_ro = 'DCAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss mit Gerinne im Bankett',
   description_de = 'Anschluss mit Gerinne im Bankett',
   description_fr = 'Raccordement dans la banquette',
   description_it = 'Allacciamento con cunetta nella banchina',
   description_ro = '',
   display_en = 'DCAA',
   display_de = 'DCAA',
   display_fr = 'DCAA',
   display_it = 'DCAA',
   display_ro = 'DCAA'
WHERE code =4317;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4318,4318) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAB',
   value_de = 'DCAB',
   value_fr = 'DCAB',
   value_it = 'DCAB',
   value_ro = 'DCAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss in die Durchlaufrinne',
   description_de = 'Anschluss in die Durchlaufrinne',
   description_fr = 'Raccordement à la cunette',
   description_it = 'Allacciamento nella cunetta passante',
   description_ro = '',
   display_en = 'DCAB',
   display_de = 'DCAB',
   display_fr = 'DCAB',
   display_it = 'DCAB',
   display_ro = 'DCAB'
WHERE code =4318;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4319,4319) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAC',
   value_de = 'DCAC',
   value_fr = 'DCAC',
   value_it = 'DCAC',
   value_ro = 'DCAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss Schwanenhals',
   description_de = 'Anschluss Schwanenhals',
   description_fr = 'Raccordement au col de cygne',
   description_it = 'Allacciamento sifonato (tubo superiore)',
   description_ro = '',
   display_en = 'DCAC',
   display_de = 'DCAC',
   display_fr = 'DCAC',
   display_it = 'DCAC',
   display_ro = 'DCAC'
WHERE code =4319;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4320,4320) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAD',
   value_de = 'DCAD',
   value_fr = 'DCAD',
   value_it = 'DCAD',
   value_ro = 'DCAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss Schwanenhals innenliegend',
   description_de = 'Anschluss Schwanenhals innenliegend',
   description_fr = 'Raccordement au col de cygne interne',
   description_it = 'Allacciamento sifonato (tubo interno)',
   description_ro = '',
   display_en = 'DCAD',
   display_de = 'DCAD',
   display_fr = 'DCAD',
   display_it = 'DCAD',
   display_ro = 'DCAD'
WHERE code =4320;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4321,4321) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAE',
   value_de = 'DCAE',
   value_fr = 'DCAE',
   value_it = 'DCAE',
   value_ro = 'DCAE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss mit Schussgerinne',
   description_de = 'Anschluss mit Schussgerinne',
   description_fr = 'Raccordement incliné externe',
   description_it = 'Allacciamento con cunetta a rampa',
   description_ro = '',
   display_en = 'DCAE',
   display_de = 'DCAE',
   display_fr = 'DCAE',
   display_it = 'DCAE',
   display_ro = 'DCAE'
WHERE code =4321;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4322,4322) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAF',
   value_de = 'DCAF',
   value_fr = 'DCAF',
   value_it = 'DCAF',
   value_ro = 'DCAF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Belüftungsrohr',
   description_de = 'Belüftungsrohr',
   description_fr = 'Canalisation d’aération',
   description_it = 'Colonna di ventilazione',
   description_ro = '',
   display_en = 'DCAF',
   display_de = 'DCAF',
   display_fr = 'DCAF',
   display_it = 'DCAF',
   display_ro = 'DCAF'
WHERE code =4322;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4323,4323) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCAZ',
   value_de = 'DCAZ',
   value_fr = 'DCAZ',
   value_it = 'DCAZ',
   value_ro = 'DCAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Anschluss ',
   description_de = 'Anschluss ',
   description_fr = 'Raccordement',
   description_it = 'Altro tipo d’allacciamento (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DCAZ',
   display_de = 'DCAZ',
   display_fr = 'DCAZ',
   display_it = 'DCAZ',
   display_ro = 'DCAZ'
WHERE code =4323;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4324,4324) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBA',
   value_de = 'DCBA',
   value_fr = 'DCBA',
   value_it = 'DCBA',
   value_ro = 'DCBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, Teil der Schachtwand ausgetauscht',
   description_de = 'Reparatur, Teil der Schachtwand ausgetauscht',
   description_fr = 'Réparation, partie de la paroi du regard de visite remplacée',
   description_it = 'Riparazione, sostituzione parziale della parete del pozzetto',
   description_ro = '',
   display_en = 'DCBA',
   display_de = 'DCBA',
   display_fr = 'DCBA',
   display_it = 'DCBA',
   display_ro = 'DCBA'
WHERE code =4324;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4325,4325) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBB',
   value_de = 'DCBB',
   value_fr = 'DCBB',
   value_it = 'DCBB',
   value_ro = 'DCBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, örtlich begrenzte Innenauskleidung',
   description_de = 'Reparatur, örtlich begrenzte Innenauskleidung',
   description_fr = 'Réparation, revêtement localisé',
   description_it = 'Riparazione, rivestimento interno puntuale',
   description_ro = '',
   display_en = 'DCBB',
   display_de = 'DCBB',
   display_fr = 'DCBB',
   display_it = 'DCBB',
   display_ro = 'DCBB'
WHERE code =4325;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4326,4326) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBC',
   value_de = 'DCBC',
   value_fr = 'DCBC',
   value_it = 'DCBC',
   value_ro = 'DCBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, Injizierung',
   description_de = 'Reparatur, Injizierung',
   description_fr = 'Réparation, injection',
   description_it = 'Riparazione, iniezione',
   description_ro = '',
   display_en = 'DCBC',
   display_de = 'DCBC',
   display_fr = 'DCBC',
   display_it = 'DCBC',
   display_ro = 'DCBC'
WHERE code =4326;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8940,8940) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBD',
   value_de = 'DCBD',
   value_fr = 'DCBD',
   value_it = 'DCBD',
   value_ro = 'DCBD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Loch repariert',
   description_de = 'Loch repariert',
   description_fr = 'Trou réparé',
   description_it = 'Foro riparato',
   description_ro = 'rrr_Loch repariert',
   display_en = 'DCBD',
   display_de = 'DCBD',
   display_fr = 'DCBD',
   display_it = 'DCBD',
   display_ro = 'DCBD'
WHERE code =8940;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8941,8941) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBE',
   value_de = 'DCBE',
   value_fr = 'DCBE',
   value_it = 'DCBE',
   value_ro = 'DCBE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Reparatur, ortlich begrenzet Innenauskleidung des Anschlusses',
   description_de = 'Reparatur, ortlich begrenzet Innenauskleidung des Anschlusses',
   description_fr = 'Réparation, doublure du revêtement intérieur du raccordement localisé',
   description_it = 'Riparazione, puntuale del rivestimento interno dell’allacciamento (per es. cappuccio)',
   description_ro = 'rrr_Reparatur, ortlich begrenzet Innenauskleidung des Anschlusses',
   display_en = 'DCBE',
   display_de = 'DCBE',
   display_fr = 'DCBE',
   display_it = 'DCBE',
   display_ro = 'DCBE'
WHERE code =8941;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8942,8942) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBF',
   value_de = 'DCBF',
   value_fr = 'DCBF',
   value_it = 'DCBF',
   value_ro = 'DCBF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Reparatur des Anschlusses',
   description_de = 'Andersartige Reparatur des Anschlusses',
   description_fr = 'Réparation autre du raccordement',
   description_it = 'Diverso tipo di riparazione dell’allacciamento',
   description_ro = 'rrr_Andersartige Reparatur des Anschlusses',
   display_en = 'DCBF',
   display_de = 'DCBF',
   display_fr = 'DCBF',
   display_it = 'DCBF',
   display_ro = 'DCBF'
WHERE code =8942;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4327,4327) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCBZ',
   value_de = 'DCBZ',
   value_fr = 'DCBZ',
   value_it = 'DCBZ',
   value_ro = 'DCBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Reparatur',
   description_de = 'Andersartige Reparatur',
   description_fr = 'Réparation autre',
   description_it = 'Diverso tipo di riparazione dell’allacciamento (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = '',
   display_en = 'DCBZ',
   display_de = 'DCBZ',
   display_fr = 'DCBZ',
   display_it = 'DCBZ',
   display_ro = 'DCBZ'
WHERE code =4327;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4328,4328) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFA',
   value_de = 'DCFA',
   value_fr = 'DCFA',
   value_it = 'DCFA',
   value_ro = 'DCFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_<anderes Material> ',
   description_de = '<anderes Material> ',
   description_fr = '<autre matériau>',
   description_it = '<altro materiale>',
   description_ro = '',
   display_en = 'DCFA',
   display_de = 'DCFA',
   display_fr = 'DCFA',
   display_it = 'DCFA',
   display_ro = 'DCFA'
WHERE code =4328;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4329,4329) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFB',
   value_de = 'DCFB',
   value_fr = 'DCFB',
   value_it = 'DCFB',
   value_ro = 'DCFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Asbestzement',
   description_de = 'Asbestzement',
   description_fr = 'Béton amianté',
   description_it = 'Cemento amianto',
   description_ro = '',
   display_en = 'DCFB',
   display_de = 'DCFB',
   display_fr = 'DCFB',
   display_it = 'DCFB',
   display_ro = 'DCFB'
WHERE code =4329;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4330,4330) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFC',
   value_de = 'DCFC',
   value_fr = 'DCFC',
   value_it = 'DCFC',
   value_ro = 'DCFC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Normalbeton',
   description_de = 'Normalbeton',
   description_fr = 'Béton normal',
   description_it = 'Calcestruzzo normale',
   description_ro = '',
   display_en = 'DCFC',
   display_de = 'DCFC',
   display_fr = 'DCFC',
   display_it = 'DCFC',
   display_ro = 'DCFC'
WHERE code =4330;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4331,4331) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFD',
   value_de = 'DCFD',
   value_fr = 'DCFD',
   value_it = 'DCFD',
   value_ro = 'DCFD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ortsbeton',
   description_de = 'Ortsbeton',
   description_fr = 'Béton frais',
   description_it = 'Calcestruzzo gettato in opera',
   description_ro = '',
   display_en = 'DCFD',
   display_de = 'DCFD',
   display_fr = 'DCFD',
   display_it = 'DCFD',
   display_ro = 'DCFD'
WHERE code =4331;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4332,4332) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFE',
   value_de = 'DCFE',
   value_fr = 'DCFE',
   value_it = 'DCFE',
   value_ro = 'DCFE',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Pressrohrbeton',
   description_de = 'Pressrohrbeton',
   description_fr = 'Béton de tube de fonçage',
   description_it = 'Calcestruzzo pressato',
   description_ro = '',
   display_en = 'DCFE',
   display_de = 'DCFE',
   display_fr = 'DCFE',
   display_it = 'DCFE',
   display_ro = 'DCFE'
WHERE code =4332;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4333,4333) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFF',
   value_de = 'DCFF',
   value_fr = 'DCFF',
   value_it = 'DCFF',
   value_ro = 'DCFF',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Spezialbeton',
   description_de = 'Spezialbeton',
   description_fr = 'Béton spécial',
   description_it = 'Calcestruzzo speciale',
   description_ro = '',
   display_en = 'DCFF',
   display_de = 'DCFF',
   display_fr = 'DCFF',
   display_it = 'DCFF',
   display_ro = 'DCFF'
WHERE code =4333;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4334,4334) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFG',
   value_de = 'DCFG',
   value_fr = 'DCFG',
   value_it = 'DCFG',
   value_ro = 'DCFG',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Beton',
   description_de = 'Beton',
   description_fr = 'Béton',
   description_it = 'Calcestruzzo',
   description_ro = '',
   display_en = 'DCFG',
   display_de = 'DCFG',
   display_fr = 'DCFG',
   display_it = 'DCFG',
   display_ro = 'DCFG'
WHERE code =4334;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4335,4335) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFH',
   value_de = 'DCFH',
   value_fr = 'DCFH',
   value_it = 'DCFH',
   value_ro = 'DCFH',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Faserzement',
   description_de = 'Faserzement',
   description_fr = 'Fibrociment',
   description_it = 'Fibrocemento',
   description_ro = '',
   display_en = 'DCFH',
   display_de = 'DCFH',
   display_fr = 'DCFH',
   display_it = 'DCFH',
   display_ro = 'DCFH'
WHERE code =4335;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4336,4336) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFI',
   value_de = 'DCFI',
   value_fr = 'DCFI',
   value_it = 'DCFI',
   value_ro = 'DCFI',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gebrannte Steine',
   description_de = 'Gebrannte Steine',
   description_fr = 'Terre cuites',
   description_it = 'Laterizi',
   description_ro = '',
   display_en = 'DCFI',
   display_de = 'DCFI',
   display_fr = 'DCFI',
   display_it = 'DCFI',
   display_ro = 'DCFI'
WHERE code =4336;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4337,4337) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFJ',
   value_de = 'DCFJ',
   value_fr = 'DCFJ',
   value_it = 'DCFJ',
   value_ro = 'DCFJ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Duktiler Guss',
   description_de = 'Duktiler Guss',
   description_fr = 'Fonte ductile',
   description_it = 'Ghisa sferoidale',
   description_ro = '',
   display_en = 'DCFJ',
   display_de = 'DCFJ',
   display_fr = 'DCFJ',
   display_it = 'DCFJ',
   display_ro = 'DCFJ'
WHERE code =4337;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4338,4338) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFK',
   value_de = 'DCFK',
   value_fr = 'DCFK',
   value_it = 'DCFK',
   value_ro = 'DCFK',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Grauguss',
   description_de = 'Grauguss',
   description_fr = 'Fonte grise',
   description_it = 'Ghisa grigia',
   description_ro = '',
   display_en = 'DCFK',
   display_de = 'DCFK',
   display_fr = 'DCFK',
   display_it = 'DCFK',
   display_ro = 'DCFK'
WHERE code =4338;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4339,4339) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFL',
   value_de = 'DCFL',
   value_fr = 'DCFL',
   value_it = 'DCFL',
   value_ro = 'DCFL',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Epoxidharz',
   description_de = 'Epoxidharz',
   description_fr = 'Résine époxyde',
   description_it = 'Resina epossidica',
   description_ro = '',
   display_en = 'DCFL',
   display_de = 'DCFL',
   display_fr = 'DCFL',
   display_it = 'DCFL',
   display_ro = 'DCFL'
WHERE code =4339;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4340,4340) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFM',
   value_de = 'DCFM',
   value_fr = 'DCFM',
   value_it = 'DCFM',
   value_ro = 'DCFM',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Hartpolyethylen',
   description_de = 'Hartpolyethylen',
   description_fr = 'Polyéthylène dur',
   description_it = 'Polietilene rigido',
   description_ro = '',
   display_en = 'DCFM',
   display_de = 'DCFM',
   display_fr = 'DCFM',
   display_it = 'DCFM',
   display_ro = 'DCFM'
WHERE code =4340;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4341,4341) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFN',
   value_de = 'DCFN',
   value_fr = 'DCFN',
   value_it = 'DCFN',
   value_ro = 'DCFN',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Polyester GUP',
   description_de = 'Polyester GUP',
   description_fr = 'Polyester GUP',
   description_it = 'Poliestere GUP',
   description_ro = '',
   display_en = 'DCFN',
   display_de = 'DCFN',
   display_fr = 'DCFN',
   display_it = 'DCFN',
   display_ro = 'DCFN'
WHERE code =4341;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4342,4342) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFO',
   value_de = 'DCFO',
   value_fr = 'DCFO',
   value_it = 'DCFO',
   value_ro = 'DCFO',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Polyethylen',
   description_de = 'Polyethylen',
   description_fr = 'Polyéthylène',
   description_it = 'Polietilene',
   description_ro = '',
   display_en = 'DCFO',
   display_de = 'DCFO',
   display_fr = 'DCFO',
   display_it = 'DCFO',
   display_ro = 'DCFO'
WHERE code =4342;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4343,4343) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFP',
   value_de = 'DCFP',
   value_fr = 'DCFP',
   value_it = 'DCFP',
   value_ro = 'DCFP',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Polypropylen',
   description_de = 'Polypropylen',
   description_fr = 'Polypropylène',
   description_it = 'Polipropilene',
   description_ro = '',
   display_en = 'DCFP',
   display_de = 'DCFP',
   display_fr = 'DCFP',
   display_it = 'DCFP',
   display_ro = 'DCFP'
WHERE code =4343;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4344,4344) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFQ',
   value_de = 'DCFQ',
   value_fr = 'DCFQ',
   value_it = 'DCFQ',
   value_ro = 'DCFQ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Polyvinylchlorid',
   description_de = 'Polyvinylchlorid',
   description_fr = 'Chlorure de polyvinyle (PVC)',
   description_it = 'Polivinilcloruro',
   description_ro = '',
   display_en = 'DCFQ',
   display_de = 'DCFQ',
   display_fr = 'DCFQ',
   display_it = 'DCFQ',
   display_ro = 'DCFQ'
WHERE code =4344;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4345,4345) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFR',
   value_de = 'DCFR',
   value_fr = 'DCFR',
   value_it = 'DCFR',
   value_ro = 'DCFR',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kunststoff unbekannt',
   description_de = 'Kunststoff unbekannt',
   description_fr = 'Plastique inconnu',
   description_it = 'Materiale sintetico non identificato',
   description_ro = '',
   display_en = 'DCFR',
   display_de = 'DCFR',
   display_fr = 'DCFR',
   display_it = 'DCFR',
   display_ro = 'DCFR'
WHERE code =4345;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4346,4346) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFS',
   value_de = 'DCFS',
   value_fr = 'DCFS',
   value_it = 'DCFS',
   value_ro = 'DCFS',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Stahl',
   description_de = 'Stahl',
   description_fr = 'Acier',
   description_it = 'Acciaio',
   description_ro = '',
   display_en = 'DCFS',
   display_de = 'DCFS',
   display_fr = 'DCFS',
   display_it = 'DCFS',
   display_ro = 'DCFS'
WHERE code =4346;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4347,4347) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFT',
   value_de = 'DCFT',
   value_fr = 'DCFT',
   value_it = 'DCFT',
   value_ro = 'DCFT',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Rostfreier Stahl',
   description_de = 'Rostfreier Stahl',
   description_fr = 'Acier inoxydable',
   description_it = 'Acciaio inossidabile',
   description_ro = '',
   display_en = 'DCFT',
   display_de = 'DCFT',
   display_fr = 'DCFT',
   display_it = 'DCFT',
   display_ro = 'DCFT'
WHERE code =4347;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4348,4348) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFU',
   value_de = 'DCFU',
   value_fr = 'DCFU',
   value_it = 'DCFU',
   value_ro = 'DCFU',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Steinzeug',
   description_de = 'Steinzeug',
   description_fr = 'Grès céramique',
   description_it = 'Grès',
   description_ro = '',
   display_en = 'DCFU',
   display_de = 'DCFU',
   display_fr = 'DCFU',
   display_it = 'DCFU',
   display_ro = 'DCFU'
WHERE code =4348;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4349,4349) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFV',
   value_de = 'DCFV',
   value_fr = 'DCFV',
   value_it = 'DCFV',
   value_ro = 'DCFV',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ton',
   description_de = 'Ton',
   description_fr = 'Argile',
   description_it = 'Argilla',
   description_ro = '',
   display_en = 'DCFV',
   display_de = 'DCFV',
   display_fr = 'DCFV',
   display_it = 'DCFV',
   display_ro = 'DCFV'
WHERE code =4349;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4350,4350) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFW',
   value_de = 'DCFW',
   value_fr = 'DCFW',
   value_it = 'DCFW',
   value_ro = 'DCFW',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_unbekanntes Material',
   description_de = 'unbekanntes Material',
   description_fr = 'Matériau inconnu',
   description_it = 'Materiale non identificato',
   description_ro = '',
   display_en = 'DCFW',
   display_de = 'DCFW',
   display_fr = 'DCFW',
   display_it = 'DCFW',
   display_ro = 'DCFW'
WHERE code =4350;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4351,4351) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCFX',
   value_de = 'DCFX',
   value_fr = 'DCFX',
   value_it = 'DCFX',
   value_ro = 'DCFX',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zement',
   description_de = 'Zement',
   description_fr = 'Ciment',
   description_it = 'Cemento',
   description_ro = '',
   display_en = 'DCFX',
   display_de = 'DCFX',
   display_fr = 'DCFX',
   display_it = 'DCFX',
   display_ro = 'DCFX'
WHERE code =4351;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4352,4352) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGAA',
   value_de = 'DCGAA',
   value_fr = 'DCGAA',
   value_it = 'DCGAA',
   value_ro = 'DCGAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf Kreisprofil',
   description_de = 'Zulauf Kreisprofil',
   description_fr = 'Entrée de forme circulaire',
   description_it = 'Condotta in entrata profilo circolare',
   description_ro = '',
   display_en = 'DCGAA',
   display_de = 'DCGAA',
   display_fr = 'DCGAA',
   display_it = 'DCGAA',
   display_ro = 'DCGAA'
WHERE code =4352;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4353,4353) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGAB',
   value_de = 'DCGAB',
   value_fr = 'DCGAB',
   value_it = 'DCGAB',
   value_ro = 'DCGAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf Kreisprofil',
   description_de = 'Ablauf Kreisprofil',
   description_fr = 'Sortie de forme circulaire',
   description_it = 'Condotta in uscita profilo circolare',
   description_ro = '',
   display_en = 'DCGAB',
   display_de = 'DCGAB',
   display_fr = 'DCGAB',
   display_it = 'DCGAB',
   display_ro = 'DCGAB'
WHERE code =4353;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4354,4354) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGAC',
   value_de = 'DCGAC',
   value_fr = 'DCGAC',
   value_it = 'DCGAC',
   value_ro = 'DCGAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss Kreisprofil',
   description_de = 'Verschlossener Anschluss Kreisprofil',
   description_fr = 'Raccordement fermé de forme circulaire',
   description_it = 'Raccordo occluso profilo circolare',
   description_ro = '',
   display_en = 'DCGAC',
   display_de = 'DCGAC',
   display_fr = 'DCGAC',
   display_it = 'DCGAC',
   display_ro = 'DCGAC'
WHERE code =4354;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4355,4355) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGBA',
   value_de = 'DCGBA',
   value_fr = 'DCGBA',
   value_it = 'DCGBA',
   value_ro = 'DCGBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf Rechteckprofil',
   description_de = 'Zulauf Rechteckprofil',
   description_fr = 'Entrée de forme rectangulaire',
   description_it = 'Condotta in entrata profilo rettangolare',
   description_ro = '',
   display_en = 'DCGBA',
   display_de = 'DCGBA',
   display_fr = 'DCGBA',
   display_it = 'DCGBA',
   display_ro = 'DCGBA'
WHERE code =4355;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4356,4356) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGBB',
   value_de = 'DCGBB',
   value_fr = 'DCGBB',
   value_it = 'DCGBB',
   value_ro = 'DCGBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf Rechteckprofil',
   description_de = 'Ablauf Rechteckprofil',
   description_fr = 'Sortie de forme rectangulaire',
   description_it = 'Condotta in uscita profilo rettangolare',
   description_ro = '',
   display_en = 'DCGBB',
   display_de = 'DCGBB',
   display_fr = 'DCGBB',
   display_it = 'DCGBB',
   display_ro = 'DCGBB'
WHERE code =4356;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4357,4357) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGBC',
   value_de = 'DCGBC',
   value_fr = 'DCGBC',
   value_it = 'DCGBC',
   value_ro = 'DCGBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss Rechteckprofil',
   description_de = 'Verschlossener Anschluss Rechteckprofil',
   description_fr = 'Raccordement fermé de forme rectangulaire',
   description_it = 'Raccordo occluso profilo rettangolare',
   description_ro = '',
   display_en = 'DCGBC',
   display_de = 'DCGBC',
   display_fr = 'DCGBC',
   display_it = 'DCGBC',
   display_ro = 'DCGBC'
WHERE code =4357;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4358,4358) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGCA',
   value_de = 'DCGCA',
   value_fr = 'DCGCA',
   value_it = 'DCGCA',
   value_ro = 'DCGCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf Eiprofil',
   description_de = 'Zulauf Eiprofil',
   description_fr = 'Entrée de forme ovoïde',
   description_it = 'Condotta in entrata profilo ovoidale',
   description_ro = '',
   display_en = 'DCGCA',
   display_de = 'DCGCA',
   display_fr = 'DCGCA',
   display_it = 'DCGCA',
   display_ro = 'DCGCA'
WHERE code =4358;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4359,4359) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGCB',
   value_de = 'DCGCB',
   value_fr = 'DCGCB',
   value_it = 'DCGCB',
   value_ro = 'DCGCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf Eiprofil',
   description_de = 'Ablauf Eiprofil',
   description_fr = 'Sortie ovoïde',
   description_it = 'Condotta in uscita profilo ovoidale',
   description_ro = '',
   display_en = 'DCGCB',
   display_de = 'DCGCB',
   display_fr = 'DCGCB',
   display_it = 'DCGCB',
   display_ro = 'DCGCB'
WHERE code =4359;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4360,4360) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGCC',
   value_de = 'DCGCC',
   value_fr = 'DCGCC',
   value_it = 'DCGCC',
   value_ro = 'DCGCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss Eiprofil',
   description_de = 'Verschlossener Anschluss Eiprofil',
   description_fr = 'Raccordement fermé ovoïde',
   description_it = 'Raccordo occluso profilo ovoidale',
   description_ro = '',
   display_en = 'DCGCC',
   display_de = 'DCGCC',
   display_fr = 'DCGCC',
   display_it = 'DCGCC',
   display_ro = 'DCGCC'
WHERE code =4360;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4364,4364) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXAA',
   value_de = 'DCGXAA',
   value_fr = 'DCGXAA',
   value_it = 'DCGXAA',
   value_ro = 'DCGXAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf  Spezialprofil',
   description_de = 'Zulauf  Spezialprofil',
   description_fr = 'Entrée de forme spéciale',
   description_it = 'Condotta in entrata profilo speciale',
   description_ro = '',
   display_en = 'DCGXAA',
   display_de = 'DCGXAA',
   display_fr = 'DCGXAA',
   display_it = 'DCGXAA',
   display_ro = 'DCGXAA'
WHERE code =4364;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4365,4365) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXAB',
   value_de = 'DCGXAB',
   value_fr = 'DCGXAB',
   value_it = 'DCGXAB',
   value_ro = 'DCGXAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf  Spezialprofil',
   description_de = 'Ablauf  Spezialprofil',
   description_fr = 'Sortie de forme spéciale',
   description_it = 'Condotta in uscita profilo speciale',
   description_ro = '',
   display_en = 'DCGXAB',
   display_de = 'DCGXAB',
   display_fr = 'DCGXAB',
   display_it = 'DCGXAB',
   display_ro = 'DCGXAB'
WHERE code =4365;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4366,4366) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXAC',
   value_de = 'DCGXAC',
   value_fr = 'DCGXAC',
   value_it = 'DCGXAC',
   value_ro = 'DCGXAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss Spezialprofil',
   description_de = 'Verschlossener Anschluss Spezialprofil',
   description_fr = 'Raccordement fermé de forme spéciale',
   description_it = 'Raccordo occluso profilo speciale',
   description_ro = '',
   display_en = 'DCGXAC',
   display_de = 'DCGXAC',
   display_fr = 'DCGXAC',
   display_it = 'DCGXAC',
   display_ro = 'DCGXAC'
WHERE code =4366;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4367,4367) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXBA',
   value_de = 'DCGXBA',
   value_fr = 'DCGXBA',
   value_it = 'DCGXBA',
   value_ro = 'DCGXBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf  Maulprofil',
   description_de = 'Zulauf  Maulprofil',
   description_fr = 'Entrée de forme fer à cheval',
   description_it = 'Condotta in entrata profilo ellittico',
   description_ro = '',
   display_en = 'DCGXBA',
   display_de = 'DCGXBA',
   display_fr = 'DCGXBA',
   display_it = 'DCGXBA',
   display_ro = 'DCGXBA'
WHERE code =4367;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4368,4368) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXBB',
   value_de = 'DCGXBB',
   value_fr = 'DCGXBB',
   value_it = 'DCGXBB',
   value_ro = 'DCGXBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf  Maulprofil',
   description_de = 'Ablauf  Maulprofil',
   description_fr = 'Sortie de forme fer à cheval',
   description_it = 'Condotta in uscita profilo ellittico',
   description_ro = '',
   display_en = 'DCGXBB',
   display_de = 'DCGXBB',
   display_fr = 'DCGXBB',
   display_it = 'DCGXBB',
   display_ro = 'DCGXBB'
WHERE code =4368;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4369,4369) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXBC',
   value_de = 'DCGXBC',
   value_fr = 'DCGXBC',
   value_it = 'DCGXBC',
   value_ro = 'DCGXBC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss Maulprofil',
   description_de = 'Verschlossener Anschluss Maulprofil',
   description_fr = 'Raccordement fermé de forme fer à cheval',
   description_it = 'Raccordo occluso profilo ellittico',
   description_ro = '',
   display_en = 'DCGXBC',
   display_de = 'DCGXBC',
   display_fr = 'DCGXBC',
   display_it = 'DCGXBC',
   display_ro = 'DCGXBC'
WHERE code =4369;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4370,4370) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXCA',
   value_de = 'DCGXCA',
   value_fr = 'DCGXCA',
   value_it = 'DCGXCA',
   value_ro = 'DCGXCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf  offenes Profil',
   description_de = 'Zulauf  offenes Profil',
   description_fr = 'Entrée de forme ouverte',
   description_it = 'Condotta in entrata profilo aperto',
   description_ro = '',
   display_en = 'DCGXCA',
   display_de = 'DCGXCA',
   display_fr = 'DCGXCA',
   display_it = 'DCGXCA',
   display_ro = 'DCGXCA'
WHERE code =4370;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4371,4371) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXCB',
   value_de = 'DCGXCB',
   value_fr = 'DCGXCB',
   value_it = 'DCGXCB',
   value_ro = 'DCGXCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf  offenes Profil',
   description_de = 'Ablauf  offenes Profil',
   description_fr = 'Sortie de forme ouverte',
   description_it = 'Condotta in uscita profilo aperto',
   description_ro = '',
   display_en = 'DCGXCB',
   display_de = 'DCGXCB',
   display_fr = 'DCGXCB',
   display_it = 'DCGXCB',
   display_ro = 'DCGXCB'
WHERE code =4371;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4372,4372) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGXCC',
   value_de = 'DCGXCC',
   value_fr = 'DCGXCC',
   value_it = 'DCGXCC',
   value_ro = 'DCGXCC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss offenes Profil',
   description_de = 'Verschlossener Anschluss offenes Profil',
   description_fr = 'Raccordement fermé de forme ouverte',
   description_it = 'Raccordo occluso profilo aperto',
   description_ro = '',
   display_en = 'DCGXCC',
   display_de = 'DCGXCC',
   display_fr = 'DCGXCC',
   display_it = 'DCGXCC',
   display_ro = 'DCGXCC'
WHERE code =4372;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4373,4373) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGYA',
   value_de = 'DCGYA',
   value_fr = 'DCGYA',
   value_it = 'DCGYA',
   value_ro = 'DCGYA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf  Profil unbekannt',
   description_de = 'Zulauf  Profil unbekannt',
   description_fr = 'Entrée de forme inconnue',
   description_it = 'Condotta in entrata profilo ignoto',
   description_ro = '',
   display_en = 'DCGYA',
   display_de = 'DCGYA',
   display_fr = 'DCGYA',
   display_it = 'DCGYA',
   display_ro = 'DCGYA'
WHERE code =4373;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4374,4374) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGYB',
   value_de = 'DCGYB',
   value_fr = 'DCGYB',
   value_it = 'DCGYB',
   value_ro = 'DCGYB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf  Profil unbekannt',
   description_de = 'Ablauf  Profil unbekannt',
   description_fr = 'Sortie de forme inconnue',
   description_it = 'Condotta in uscita profilo ignoto',
   description_ro = '',
   display_en = 'DCGYB',
   display_de = 'DCGYB',
   display_fr = 'DCGYB',
   display_it = 'DCGYB',
   display_ro = 'DCGYB'
WHERE code =4374;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4375,4375) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGYC',
   value_de = 'DCGYC',
   value_fr = 'DCGYC',
   value_it = 'DCGYC',
   value_ro = 'DCGYC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss Profil unbekannt',
   description_de = 'Verschlossener Anschluss Profil unbekannt',
   description_fr = 'Raccordement fermé de forme inconnue',
   description_it = 'Raccordo occluso profilo ignoto',
   description_ro = '',
   display_en = 'DCGYC',
   display_de = 'DCGYC',
   display_fr = 'DCGYC',
   display_it = 'DCGYC',
   display_ro = 'DCGYC'
WHERE code =4375;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4376,4376) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGZA',
   value_de = 'DCGZA',
   value_fr = 'DCGZA',
   value_it = 'DCGZA',
   value_ro = 'DCGZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Zulauf anderes Profil',
   description_de = 'Zulauf anderes Profil',
   description_fr = 'Entrée d’une autre forme',
   description_it = 'Condotta in entrata altro profilo',
   description_ro = '',
   display_en = 'DCGZA',
   display_de = 'DCGZA',
   display_fr = 'DCGZA',
   display_it = 'DCGZA',
   display_ro = 'DCGZA'
WHERE code =4376;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4377,4377) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGZB',
   value_de = 'DCGZB',
   value_fr = 'DCGZB',
   value_it = 'DCGZB',
   value_ro = 'DCGZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Ablauf anderes Profil',
   description_de = 'Ablauf anderes Profil',
   description_fr = 'Sortie d’une autre forme',
   description_it = 'Condotta in uscita altro profilo',
   description_ro = '',
   display_en = 'DCGZB',
   display_de = 'DCGZB',
   display_fr = 'DCGZB',
   display_it = 'DCGZB',
   display_ro = 'DCGZB'
WHERE code =4377;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4378,4378) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCGZC',
   value_de = 'DCGZC',
   value_fr = 'DCGZC',
   value_it = 'DCGZC',
   value_ro = 'DCGZC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Verschlossener Anschluss anderes Profil',
   description_de = 'Verschlossener Anschluss anderes Profil',
   description_fr = 'Raccordement fermé d’une autre forme',
   description_it = 'Raccordo occluso altro profilo',
   description_ro = '',
   display_en = 'DCGZC',
   display_de = 'DCGZC',
   display_fr = 'DCGZC',
   display_it = 'DCGZC',
   display_ro = 'DCGZC'
WHERE code =4378;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4379,4379) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCHA',
   value_de = 'DCHA',
   value_fr = 'DCHA',
   value_it = 'DCHA',
   value_ro = 'DCHA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bankett mangelhaft',
   description_de = 'Bankett mangelhaft',
   description_fr = 'Banquette défectueuse',
   description_it = 'Banchina difettosa',
   description_ro = '',
   display_en = 'DCHA',
   display_de = 'DCHA',
   display_fr = 'DCHA',
   display_it = 'DCHA',
   display_ro = 'DCHA'
WHERE code =4379;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4382,4382) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCHB',
   value_de = 'DCHB',
   value_fr = 'DCHB',
   value_it = 'DCHB',
   value_ro = 'DCHB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Bakett nicht mangelhaft',
   description_de = 'Bakett nicht mangelhaft',
   description_fr = 'Banquette en état',
   description_it = 'Banchina non difettosa',
   description_ro = '',
   display_en = 'DCHB',
   display_de = 'DCHB',
   display_fr = 'DCHB',
   display_it = 'DCHB',
   display_ro = 'DCHB'
WHERE code =4382;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8943,8943) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCHC',
   value_de = 'DCHC',
   value_fr = 'DCHC',
   value_it = 'DCHC',
   value_ro = 'DCHC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Kein Bankett',
   description_de = 'Kein Bankett',
   description_fr = 'Pas de banquette',
   description_it = 'Banchina mancante',
   description_ro = 'rrr_Kein Bankett',
   display_en = 'DCHC',
   display_de = 'DCHC',
   display_fr = 'DCHC',
   display_it = 'DCHC',
   display_ro = 'DCHC'
WHERE code =8943;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8944,8944) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIAA',
   value_de = 'DCIAA',
   value_fr = 'DCIAA',
   value_it = 'DCIAA',
   value_ro = 'DCIAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne mangelhaft, in Fliessrichtung verengt',
   description_de = 'Durchlaufrinne mangelhaft, in Fliessrichtung verengt',
   description_fr = 'Cunette défectueuse, étranglement dans le sens de l’écoulement',
   description_it = 'Cunetta passante difettosa, restringimento in direzione del flusso',
   description_ro = 'rrr_Durchlaufrinne mangelhaft, in Fliessrichtung verengt',
   display_en = 'DCIAA',
   display_de = 'DCIAA',
   display_fr = 'DCIAA',
   display_it = 'DCIAA',
   display_ro = 'DCIAA'
WHERE code =8944;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8945,8945) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIAB',
   value_de = 'DCIAB',
   value_fr = 'DCIAB',
   value_it = 'DCIAB',
   value_ro = 'DCIAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne mangelhaft, in Fliessrichtung erweitert',
   description_de = 'Durchlaufrinne mangelhaft, in Fliessrichtung erweitert',
   description_fr = 'Cunette défectueuse, élargissement dans le sens de l’écoulement',
   description_it = 'Cunetta passante difettosa, dilatazione in direzione del flusso',
   description_ro = 'rrr_Durchlaufrinne mangelhaft, in Fliessrichtung erweitert',
   display_en = 'DCIAB',
   display_de = 'DCIAB',
   display_fr = 'DCIAB',
   display_it = 'DCIAB',
   display_ro = 'DCIAB'
WHERE code =8945;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8946,8946) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIAC',
   value_de = 'DCIAC',
   value_fr = 'DCIAC',
   value_it = 'DCIAC',
   value_ro = 'DCIAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne mangelhaft, Hochpunkt',
   description_de = 'Durchlaufrinne mangelhaft, Hochpunkt',
   description_fr = 'Cunette défectueuse, point haut',
   description_it = 'Cunetta passante difettosa, punto superiore',
   description_ro = 'rrr_Durchlaufrinne mangelhaft, Hochpunkt',
   display_en = 'DCIAC',
   display_de = 'DCIAC',
   display_fr = 'DCIAC',
   display_it = 'DCIAC',
   display_ro = 'DCIAC'
WHERE code =8946;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8947,8947) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIAD',
   value_de = 'DCIAD',
   value_fr = 'DCIAD',
   value_it = 'DCIAD',
   value_ro = 'DCIAD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne mangelhaft, Tiefpunkt',
   description_de = 'Durchlaufrinne mangelhaft, Tiefpunkt',
   description_fr = 'Cunette défectueuse, point bas',
   description_it = 'Cunetta passante difettosa, punto inferiore',
   description_ro = 'rrr_Durchlaufrinne mangelhaft, Tiefpunkt',
   display_en = 'DCIAD',
   display_de = 'DCIAD',
   display_fr = 'DCIAD',
   display_it = 'DCIAD',
   display_ro = 'DCIAD'
WHERE code =8947;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8948,8948) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIAZ',
   value_de = 'DCIAZ',
   value_fr = 'DCIAZ',
   value_it = 'DCIAZ',
   value_ro = 'DCIAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne mangelhaft',
   description_de = 'Durchlaufrinne mangelhaft',
   description_fr = 'Cunette défectueuse',
   description_it = 'Cunetta passante difettosa',
   description_ro = 'rrr_Durchlaufrinne mangelhaft',
   display_en = 'DCIAZ',
   display_de = 'DCIAZ',
   display_fr = 'DCIAZ',
   display_it = 'DCIAZ',
   display_ro = 'DCIAZ'
WHERE code =8948;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4384,4384) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIB',
   value_de = 'DCIB',
   value_fr = 'DCIB',
   value_it = 'DCIB',
   value_ro = 'DCIB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne',
   description_de = 'Durchlaufrinne',
   description_fr = 'Cunette',
   description_it = 'Cunetta passante',
   description_ro = '',
   display_en = 'DCIB',
   display_de = 'DCIB',
   display_fr = 'DCIB',
   display_it = 'DCIB',
   display_ro = 'DCIB'
WHERE code =4384;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8949,8949) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCIBY',
   value_de = 'DCIBY',
   value_fr = 'DCIBY',
   value_it = 'DCIBY',
   value_ro = 'DCIBY',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Durchlaufrinne nicht mangelhaft',
   description_de = 'Durchlaufrinne nicht mangelhaft',
   description_fr = 'Cunette non défectueux',
   description_it = 'Cunetta passante non difettosa',
   description_ro = 'rrr_Durchlaufrinne nicht mangelhaft',
   display_en = 'DCIBY',
   display_de = 'DCIBY',
   display_fr = 'DCIBY',
   display_it = 'DCIBY',
   display_ro = 'DCIBY'
WHERE code =8949;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8950,8950) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCICY',
   value_de = 'DCICY',
   value_fr = 'DCICY',
   value_it = 'DCICY',
   value_ro = 'DCICY',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Durchlaufrinne',
   description_de = 'Keine Durchlaufrinne',
   description_fr = 'Pas de cunette',
   description_it = 'Cunetta passante mancante',
   description_ro = 'rrr_Keine Durchlaufrinne',
   display_en = 'DCICY',
   display_de = 'DCICY',
   display_fr = 'DCICY',
   display_it = 'DCICY',
   display_ro = 'DCICY'
WHERE code =8950;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4385,4385) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCLAA',
   value_de = 'DCLAA',
   value_fr = 'DCLAA',
   value_it = 'DCLAA',
   value_ro = 'DCLAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ Rohrdurchführung ohne Öffnungsmöglichkeit, schadhaft',
   description_de = 'Rohrdurchführung ohne Öffnungsmöglichkeit, schadhaft',
   description_fr = 'Canalisation fermée sans accès, défectueuse',
   description_it = 'Tubazione passante senza possibilità d’apertura, difettosa',
   description_ro = '',
   display_en = 'DCLAA',
   display_de = 'DCLAA',
   display_fr = 'DCLAA',
   display_it = 'DCLAA',
   display_ro = 'DCLAA'
WHERE code =4385;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4386,4386) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCLAB',
   value_de = 'DCLAB',
   value_fr = 'DCLAB',
   value_it = 'DCLAB',
   value_ro = 'DCLAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ Rohrdurchführung ohne Öffnungsmöglichkeit',
   description_de = 'Rohrdurchführung ohne Öffnungsmöglichkeit',
   description_fr = 'Canalisation fermée sans accès',
   description_it = 'Tubazione passante senza possibilità d’apertura',
   description_ro = '',
   display_en = 'DCLAB',
   display_de = 'DCLAB',
   display_fr = 'DCLAB',
   display_it = 'DCLAB',
   display_ro = 'DCLAB'
WHERE code =4386;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4387,4387) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCLBA',
   value_de = 'DCLBA',
   value_fr = 'DCLBA',
   value_it = 'DCLBA',
   value_ro = 'DCLBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit, schadhaft',
   description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit, schadhaft',
   description_fr = 'Canalisation fermée avec accès, défectueuse',
   description_it = 'Tubazione passante con possibilità d’apertura, difettosa',
   description_ro = '',
   display_en = 'DCLBA',
   display_de = 'DCLBA',
   display_fr = 'DCLBA',
   display_it = 'DCLBA',
   display_ro = 'DCLBA'
WHERE code =4387;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4388,4388) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCLBB',
   value_de = 'DCLBB',
   value_fr = 'DCLBB',
   value_it = 'DCLBB',
   value_ro = 'DCLBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit',
   description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit',
   description_fr = 'Canalisation fermée avec accès',
   description_it = 'Tubazione passante con possibilità d’apertura',
   description_ro = '',
   display_en = 'DCLBB',
   display_de = 'DCLBB',
   display_fr = 'DCLBB',
   display_it = 'DCLBB',
   display_ro = 'DCLBB'
WHERE code =4388;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4389,4389) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCLCA',
   value_de = 'DCLCA',
   value_fr = 'DCLCA',
   value_it = 'DCLCA',
   value_ro = 'DCLCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt, schadhaft',
   description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt, schadhaft',
   description_fr = 'Canalisation fermée avec accès, fermeture manquant, défectueux',
   description_it = 'Tubazione passante con possibilità d’apertura, coperchio mancante, difettosa',
   description_ro = '',
   display_en = 'DCLCA',
   display_de = 'DCLCA',
   display_fr = 'DCLCA',
   display_it = 'DCLCA',
   display_ro = 'DCLCA'
WHERE code =4389;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4390,4390) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCLCB',
   value_de = 'DCLCB',
   value_fr = 'DCLCB',
   value_it = 'DCLCB',
   value_ro = 'DCLCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_ Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt',
   description_de = 'Rohrdurchführung mit Öffnungsmöglichkeit, Verschluss fehlt',
   description_fr = 'Canalisation fermée avec accès, tampon manquant',
   description_it = 'Tubazione passante con possibilità d’apertura, coperchio mancante',
   description_ro = '',
   display_en = 'DCLCB',
   display_de = 'DCLCB',
   display_fr = 'DCLCB',
   display_it = 'DCLCB',
   display_ro = 'DCLCB'
WHERE code =4390;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4391,4391) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCMA',
   value_de = 'DCMA',
   value_fr = 'DCMA',
   value_it = 'DCMA',
   value_ro = 'DCMA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schlammeimer vorhanden',
   description_de = 'Schlammeimer vorhanden',
   description_fr = 'sac à boues présent',
   description_it = 'Secchio raccolta fango presente',
   description_ro = '',
   display_en = 'DCMA',
   display_de = 'DCMA',
   display_fr = 'DCMA',
   display_it = 'DCMA',
   display_ro = 'DCMA'
WHERE code =4391;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4392,4392) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCMB',
   value_de = 'DCMB',
   value_fr = 'DCMB',
   value_it = 'DCMB',
   value_ro = 'DCMB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schlammeimer fehlt',
   description_de = 'Schlammeimer fehlt',
   description_fr = 'sac à boues manquant',
   description_it = 'Secchio raccolta fango mancante',
   description_ro = '',
   display_en = 'DCMB',
   display_de = 'DCMB',
   display_fr = 'DCMB',
   display_it = 'DCMB',
   display_ro = 'DCMB'
WHERE code =4392;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4393,4393) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DCMC',
   value_de = 'DCMC',
   value_fr = 'DCMC',
   value_it = 'DCMC',
   value_ro = 'DCMC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Schlammeimer defekt',
   description_de = 'Schlammeimer defekt',
   description_fr = 'sac à boues défectueux',
   description_it = 'Secchio raccolta fango difettoso',
   description_ro = '',
   display_en = 'DCMC',
   display_de = 'DCMC',
   display_fr = 'DCMC',
   display_it = 'DCMC',
   display_ro = 'DCMC'
WHERE code =4393;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4394,4394) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDA',
   value_de = 'DDA',
   value_fr = 'DDA',
   value_it = 'DDA',
   value_ro = 'DDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Allgemeinzustand, Fotobeispiel',
   description_de = 'Allgemeinzustand, Fotobeispiel',
   description_fr = 'Etat général, exemple de photo',
   description_it = 'Stato generale, esempio foto',
   description_ro = '',
   display_en = 'DDA',
   display_de = 'DDA',
   display_fr = 'DDA',
   display_it = 'DDA',
   display_ro = 'DDA'
WHERE code =4394;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4395,4395) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDB',
   value_de = 'DDB',
   value_fr = 'DDB',
   value_it = 'DDB',
   value_ro = 'DDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_    <kein Text>',
   description_de = '<kein Text>',
   description_fr = '<aucun texte>',
   description_it = 'Inserimento di testo libero per la descrizione di rilievi altrimenti non codificabili',
   description_ro = '',
   display_en = 'DDB',
   display_de = 'DDB',
   display_fr = 'DDB',
   display_it = 'DDB',
   display_ro = 'DDB'
WHERE code =4395;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8951,8951) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCAB',
   value_de = 'DDCAB',
   value_fr = 'DDCAB',
   value_it = 'DDCAB',
   value_ro = 'DDCAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht möglich: Deckel kann nicht geöffnet werden, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Inspektion nicht möglich: Deckel kann nicht geöffnet werden, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Examen incomplet: le couvercle ne peut pas être ouvert, le client renonce à une inspection supplémentaire',
   description_it = 'Ispezione non completata: apertura del chiusino impossibile, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Inspektion nicht möglich: Deckel kann nicht geöffnet werden, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'DDCAB',
   display_de = 'DDCAB',
   display_fr = 'DDCAB',
   display_it = 'DDCAB',
   display_ro = 'DDCAB'
WHERE code =8951;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8952,8952) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCAZ',
   value_de = 'DDCAZ',
   value_fr = 'DDCAZ',
   value_it = 'DDCAZ',
   value_ro = 'DDCAZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht möglich: Deckel kann nicht geöffnet werden',
   description_de = 'Inspektion nicht möglich: Deckel kann nicht geöffnet werden',
   description_fr = 'Examen incomplet: le couvercle ne peut pas être ouvert',
   description_it = 'Ispezione non completata: apertura del chiusino impossibile (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht möglich: Deckel kann nicht geöffnet werden',
   display_en = 'DDCAZ',
   display_de = 'DDCAZ',
   display_fr = 'DDCAZ',
   display_it = 'DDCAZ',
   display_ro = 'DDCAZ'
WHERE code =8952;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8953,8953) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCBA',
   value_de = 'DDCBA',
   value_fr = 'DDCBA',
   value_it = 'DDCBA',
   value_ro = 'DDCBA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Hindernis, Inspektionsziel erreicht',
   description_de = 'Inspektion nicht vollständig: Hindernis, Inspektionsziel erreicht',
   description_fr = 'Examen incomplet: obstacle, cible d’inspection atteinte',
   description_it = 'Ispezione non completata: ostacolo, obiettivo ispezione raggiunto',
   description_ro = 'rrr_Inspektion nicht vollständig: Hindernis, Inspektionsziel erreicht',
   display_en = 'DDCBA',
   display_de = 'DDCBA',
   display_fr = 'DDCBA',
   display_it = 'DDCBA',
   display_ro = 'DDCBA'
WHERE code =8953;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8954,8954) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCBB',
   value_de = 'DDCBB',
   value_fr = 'DDCBB',
   value_it = 'DDCBB',
   value_ro = 'DDCBB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Hindernis, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Inspektion nicht vollständig: Hindernis, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Examen incomplet: obstacle, le client renonce à une nouvelle inspection',
   description_it = 'Ispezione non completata: ostacolo, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Inspektion nicht vollständig: Hindernis, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'DDCBB',
   display_de = 'DDCBB',
   display_fr = 'DDCBB',
   display_it = 'DDCBB',
   display_ro = 'DDCBB'
WHERE code =8954;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8955,8955) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCBZ',
   value_de = 'DDCBZ',
   value_fr = 'DDCBZ',
   value_it = 'DDCBZ',
   value_ro = 'DDCBZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Hindernis',
   description_de = 'Inspektion nicht vollständig: Hindernis',
   description_fr = 'Examen incomplet: obstacle',
   description_it = 'Ispezione non completata: ostacolo, (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht vollständig: Hindernis',
   display_en = 'DDCBZ',
   display_de = 'DDCBZ',
   display_fr = 'DDCBZ',
   display_it = 'DDCBZ',
   display_ro = 'DDCBZ'
WHERE code =8955;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8956,8956) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCCA',
   value_de = 'DDCCA',
   value_fr = 'DDCCA',
   value_it = 'DDCCA',
   value_ro = 'DDCCA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Hoher Wasserstand, Inspektionsziel erreicht',
   description_de = 'Inspektion nicht vollständig: Hoher Wasserstand, Inspektionsziel erreicht',
   description_fr = 'Examen incomplet: niveau d’eau élevé, objectif d’inspection atteint',
   description_it = 'Ispezione non completata: livello dell’acqua alto, obiettivo ispezione raggiunto',
   description_ro = 'rrr_Inspektion nicht vollständig: Hoher Wasserstand, Inspektionsziel erreicht',
   display_en = 'DDCCA',
   display_de = 'DDCCA',
   display_fr = 'DDCCA',
   display_it = 'DDCCA',
   display_ro = 'DDCCA'
WHERE code =8956;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8957,8957) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCCB',
   value_de = 'DDCCB',
   value_fr = 'DDCCB',
   value_it = 'DDCCB',
   value_ro = 'DDCCB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Inspektion nicht vollständig: Hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Examen incomplet: niveau d’eau élevé, le client s’abstient de toute inspection ultérieure',
   description_it = 'Ispezione non completata: livello dell’acqua alto, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Inspektion nicht vollständig: Hoher Wasserstand, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'DDCCB',
   display_de = 'DDCCB',
   display_fr = 'DDCCB',
   display_it = 'DDCCB',
   display_ro = 'DDCCB'
WHERE code =8957;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8958,8958) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCCZ',
   value_de = 'DDCCZ',
   value_fr = 'DDCCZ',
   value_it = 'DDCCZ',
   value_ro = 'DDCCZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Hoher Wasserstand',
   description_de = 'Inspektion nicht vollständig: Hoher Wasserstand',
   description_fr = 'Examen incomplet: niveau d’eau élevé',
   description_it = 'Ispezione non completata: livello dell’acqua alto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht vollständig: Hoher Wasserstand',
   display_en = 'DDCCZ',
   display_de = 'DDCCZ',
   display_fr = 'DDCCZ',
   display_it = 'DDCCZ',
   display_ro = 'DDCCZ'
WHERE code =8958;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8959,8959) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCDA',
   value_de = 'DDCDA',
   value_fr = 'DDCDA',
   value_it = 'DDCDA',
   value_ro = 'DDCDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig:  Ausrüstung defekt, Inspektionsziel erreicht',
   description_de = 'Inspektion nicht vollständig:  Ausrüstung defekt, Inspektionsziel erreicht',
   description_fr = 'Examen incomplet: équipement défectueux, cible d’inspection atteinte',
   description_it = 'Ispezione non completata: guasto alle apparecchiature, obiettivo ispezione raggiunto',
   description_ro = 'rrr_Inspektion nicht vollständig:  Ausrüstung defekt, Inspektionsziel erreicht',
   display_en = 'DDCDA',
   display_de = 'DDCDA',
   display_fr = 'DDCDA',
   display_it = 'DDCDA',
   display_ro = 'DDCDA'
WHERE code =8959;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8960,8960) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCDB',
   value_de = 'DDCDB',
   value_fr = 'DDCDB',
   value_it = 'DDCDB',
   value_ro = 'DDCDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig:  Ausrüstung defekt, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Inspektion nicht vollständig:  Ausrüstung defekt, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Examen incomplet: équipement défectueux, le client renonce à une inspection supplémentaire',
   description_it = 'Ispezione non completata: guasto §alle apparecchiature, il committente rinuncia a ulteriore ispezione',
   description_ro = 'rrr_Inspektion nicht vollständig:  Ausrüstung defekt, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'DDCDB',
   display_de = 'DDCDB',
   display_fr = 'DDCDB',
   display_it = 'DDCDB',
   display_ro = 'DDCDB'
WHERE code =8960;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8961,8961) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCDZ',
   value_de = 'DDCDZ',
   value_fr = 'DDCDZ',
   value_it = 'DDCDZ',
   value_ro = 'DDCDZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig: Ausrüstung defekt',
   description_de = 'Inspektion nicht vollständig: Ausrüstung defekt',
   description_fr = 'Examen incomplet: équipement défectueux',
   description_it = 'Ispezione non completata: guasto alle apparecchiature alto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht vollständig: Ausrüstung defekt',
   display_en = 'DDCDZ',
   display_de = 'DDCDZ',
   display_fr = 'DDCDZ',
   display_it = 'DDCDZ',
   display_ro = 'DDCDZ'
WHERE code =8961;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8962,8962) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCZA',
   value_de = 'DDCZA',
   value_fr = 'DDCZA',
   value_it = 'DDCZA',
   value_ro = 'DDCZA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig, Inspektionsziel erreicht',
   description_de = 'Inspektion nicht vollständig, Inspektionsziel erreicht',
   description_fr = 'Examen incomplet, objectif d’inspection atteint (plus de détails requis dans le commentaire)',
   description_it = 'Ispezione non completata: obiettivo ispezione raggiunto (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht vollständig, Inspektionsziel erreicht',
   display_en = 'DDCZA',
   display_de = 'DDCZA',
   display_fr = 'DDCZA',
   display_it = 'DDCZA',
   display_ro = 'DDCZA'
WHERE code =8962;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8963,8963) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCZB',
   value_de = 'DDCZB',
   value_fr = 'DDCZB',
   value_it = 'DDCZB',
   value_ro = 'DDCZB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig, Auftraggeber verzichtet auf weitere Inspektion',
   description_de = 'Inspektion nicht vollständig, Auftraggeber verzichtet auf weitere Inspektion',
   description_fr = 'Examen incomplet, le client renonce à une inspection plus poussée (plus de détails requis dans le commentaire)',
   description_it = 'Ispezione non completata, il committente rinuncia a ulteriore ispezione (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht vollständig, Auftraggeber verzichtet auf weitere Inspektion',
   display_en = 'DDCZB',
   display_de = 'DDCZB',
   display_fr = 'DDCZB',
   display_it = 'DDCZB',
   display_ro = 'DDCZB'
WHERE code =8963;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8964,8964) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDCZZ',
   value_de = 'DDCZZ',
   value_fr = 'DDCZZ',
   value_it = 'DDCZZ',
   value_ro = 'DDCZZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Inspektion nicht vollständig',
   description_de = 'Inspektion nicht vollständig',
   description_fr = 'Examen incomplet',
   description_it = 'Ispezione non completata ispezione (ulteriori dettagli sono richiesti nell’osservazione)',
   description_ro = 'rrr_Inspektion nicht vollständig',
   display_en = 'DDCZZ',
   display_de = 'DDCZZ',
   display_fr = 'DDCZZ',
   display_it = 'DDCZZ',
   display_ro = 'DDCZZ'
WHERE code =8964;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4401,4401) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDD',
   value_de = 'DDD',
   value_fr = 'DDD',
   value_it = 'DDD',
   value_ro = 'DDD',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Niveau Wasserspiegel',
   description_de = 'Niveau Wasserspiegel',
   description_fr = 'Niveau d’eau',
   description_it = 'Livello dell’acqua',
   description_ro = '',
   display_en = 'DDD',
   display_de = 'DDD',
   display_fr = 'DDD',
   display_it = 'DDD',
   display_ro = 'DDD'
WHERE code =4401;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4402,4402) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEAA',
   value_de = 'DDEAA',
   value_fr = 'DDEAA',
   value_it = 'DDEAA',
   value_ro = 'DDEAA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_de = 'Fehlanschluss, Abwasserzufluss klar, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_fr = 'Mauvais raccordement, arrivées d''eaux claires, des eaux usées se déversent dans une canalisation d’eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue limpido, acque reflue entrano in acque meteoriche',
   description_ro = '',
   display_en = 'DDEAA',
   display_de = 'DDEAA',
   display_fr = 'DDEAA',
   display_it = 'DDEAA',
   display_ro = 'DDEAA'
WHERE code =4402;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4403,4403) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEAB',
   value_de = 'DDEAB',
   value_fr = 'DDEAB',
   value_it = 'DDEAB',
   value_ro = 'DDEAB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_de = 'Fehlanschluss, Abwasserzufluss klar, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux claires, des eaux pluviales se déversent dans une canalisation d’eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue limpido, acque meteoriche entrano in acque reflue',
   description_ro = '',
   display_en = 'DDEAB',
   display_de = 'DDEAB',
   display_fr = 'DDEAB',
   display_it = 'DDEAB',
   display_ro = 'DDEAB'
WHERE code =4403;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4404,4404) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEAC',
   value_de = 'DDEAC',
   value_fr = 'DDEAC',
   value_it = 'DDEAC',
   value_ro = 'DDEAC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss klar',
   description_de = 'Abwasserzufluss klar',
   description_fr = 'Arrivées d’eaux claires',
   description_it = 'Afflusso acque reflue limpido',
   description_ro = '',
   display_en = 'DDEAC',
   display_de = 'DDEAC',
   display_fr = 'DDEAC',
   display_it = 'DDEAC',
   display_ro = 'DDEAC'
WHERE code =4404;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8965,8965) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDECA',
   value_de = 'DDECA',
   value_fr = 'DDECA',
   value_it = 'DDECA',
   value_ro = 'DDECA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, eaux usées se déversant dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue torbido, acque reflue entrano in acque meteoriche',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Schmutzabwasser fliesst in Regenabwasserleitung',
   display_en = 'DDECA',
   display_de = 'DDECA',
   display_fr = 'DDECA',
   display_it = 'DDECA',
   display_ro = 'DDECA'
WHERE code =8965;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8966,8966) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDECB',
   value_de = 'DDECB',
   value_fr = 'DDECB',
   value_it = 'DDECB',
   value_ro = 'DDECB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles, des eaux pluviales se trouvant dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue torbido, acque meteoriche entrano in acque reflue',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb, Regenabwasser fliesst in Schmutzabwasserleitung ',
   display_en = 'DDECB',
   display_de = 'DDECB',
   display_fr = 'DDECB',
   display_it = 'DDECB',
   display_ro = 'DDECB'
WHERE code =8966;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8967,8967) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDECC',
   value_de = 'DDECC',
   value_fr = 'DDECC',
   value_it = 'DDECC',
   value_ro = 'DDECC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss trüb',
   description_de = 'Abwasserzufluss trüb',
   description_fr = 'Arrivées d’eaux troubles',
   description_it = 'Afflusso acque reflue torbido',
   description_ro = 'rrr_Abwasserzufluss trüb',
   display_en = 'DDECC',
   display_de = 'DDECC',
   display_fr = 'DDECC',
   display_it = 'DDECC',
   display_ro = 'DDECC'
WHERE code =8967;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8968,8968) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEDA',
   value_de = 'DDEDA',
   value_fr = 'DDEDA',
   value_it = 'DDEDA',
   value_ro = 'DDEDA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux usées se déversant dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue colorato, acque reflue entrano in acque meteoriche',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung',
   display_en = 'DDEDA',
   display_de = 'DDEDA',
   display_fr = 'DDEDA',
   display_it = 'DDEDA',
   display_ro = 'DDEDA'
WHERE code =8968;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8969,8969) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEDB',
   value_de = 'DDEDB',
   value_fr = 'DDEDB',
   value_it = 'DDEDB',
   value_ro = 'DDEDB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_de = 'Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux colorées, des eaux pluviales dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue colorato, acque meteoriche entrano in acque reflue',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ',
   display_en = 'DDEDB',
   display_de = 'DDEDB',
   display_fr = 'DDEDB',
   display_it = 'DDEDB',
   display_ro = 'DDEDB'
WHERE code =8969;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8970,8970) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEDC',
   value_de = 'DDEDC',
   value_fr = 'DDEDC',
   value_it = 'DDEDC',
   value_ro = 'DDEDC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss gefärbt',
   description_de = 'Abwasserzufluss gefärbt',
   description_fr = 'Arrivées d’eaux colorées',
   description_it = 'Afflusso acque reflue colorato',
   description_ro = 'rrr_Abwasserzufluss gefärbt',
   display_en = 'DDEDC',
   display_de = 'DDEDC',
   display_fr = 'DDEDC',
   display_it = 'DDEDC',
   display_ro = 'DDEDC'
WHERE code =8970;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8971,8971) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEEA',
   value_de = 'DDEEA',
   value_fr = 'DDEEA',
   value_it = 'DDEEA',
   value_ro = 'DDEEA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux usées se déversant dans les eaux pluviales',
   description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque reflue entrano in acque meteoriche',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Schmutzabwasser fliesst in Regenabwasserleitung',
   display_en = 'DDEEA',
   display_de = 'DDEEA',
   display_fr = 'DDEEA',
   display_it = 'DDEEA',
   display_ro = 'DDEEA'
WHERE code =8971;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8972,8972) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEEB',
   value_de = 'DDEEB',
   value_fr = 'DDEEB',
   value_it = 'DDEEB',
   value_ro = 'DDEEB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_de = 'Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ',
   description_fr = 'Mauvais raccordement, arrivées d’eaux troubles et colorées, des eaux pluviales se déversant dans les eaux usées',
   description_it = 'Collegamento errato, afflusso acque reflue torbido e colorato, acque meteoriche entrano in acque reflue',
   description_ro = 'rrr_Fehlanschluss, Abwasserzufluss trüb und gefärbt, Regenabwasser fliesst in Schmutzabwasserleitung ',
   display_en = 'DDEEB',
   display_de = 'DDEEB',
   display_fr = 'DDEEB',
   display_it = 'DDEEB',
   display_ro = 'DDEEB'
WHERE code =8972;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (8973,8973) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEEC',
   value_de = 'DDEEC',
   value_fr = 'DDEEC',
   value_it = 'DDEEC',
   value_ro = 'DDEEC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss trüb und gefärbt',
   description_de = 'Abwasserzufluss trüb und gefärbt',
   description_fr = 'Arrivées d’eaux troubles et colorées',
   description_it = 'Afflusso acque reflue torbido e colorato',
   description_ro = 'rrr_Abwasserzufluss trüb und gefärbt',
   display_en = 'DDEEC',
   display_de = 'DDEEC',
   display_fr = 'DDEEC',
   display_it = 'DDEEC',
   display_ro = 'DDEEC'
WHERE code =8973;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4408,4408) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEYA',
   value_de = 'DDEYA',
   value_fr = 'DDEYA',
   value_it = 'DDEYA',
   value_ro = 'DDEYA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_de = 'Fehlanschluss, Schmutzabwasser fliesst in Regenabwasserleitung',
   description_fr = 'Mauvais raccordement, des eaux usées se déversent dans une canalisation d’eaux pluviales',
   description_it = 'Collegamento errato, acque reflue entrano in acque meteoriche',
   description_ro = '',
   display_en = 'DDEYA',
   display_de = 'DDEYA',
   display_fr = 'DDEYA',
   display_it = 'DDEYA',
   display_ro = 'DDEYA'
WHERE code =4408;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4409,4409) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEYB',
   value_de = 'DDEYB',
   value_fr = 'DDEYB',
   value_it = 'DDEYB',
   value_ro = 'DDEYB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Fehlanschluss, Regenabwasser fliesst in Schmutzabwasserleitung',
   description_de = 'Fehlanschluss, Regenabwasser fliesst in Schmutzabwasserleitung',
   description_fr = 'Mauvais raccordement, des eaux pluviales se déversent dans une canalisation d’eaux usées',
   description_it = 'Collegamento errato, acque meteoriche entrano in acque reflue',
   description_ro = '',
   display_en = 'DDEYB',
   display_de = 'DDEYB',
   display_fr = 'DDEYB',
   display_it = 'DDEYB',
   display_ro = 'DDEYB'
WHERE code =4409;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4410,4410) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDEYY',
   value_de = 'DDEYY',
   value_fr = 'DDEYY',
   value_it = 'DDEYY',
   value_ro = 'DDEYY',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Abwasserzufluss',
   description_de = 'Abwasserzufluss',
   description_fr = 'Arrivées d’eaux usées',
   description_it = 'Afflusso acque reflue',
   description_ro = '',
   display_en = 'DDEYY',
   display_de = 'DDEYY',
   display_fr = 'DDEYY',
   display_it = 'DDEYY',
   display_ro = 'DDEYY'
WHERE code =4410;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4411,4411) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDFA',
   value_de = 'DDFA',
   value_fr = 'DDFA',
   value_it = 'DDFA',
   value_ro = 'DDFA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gefährdung vorhanden: Sauerstoffmangel',
   description_de = 'Gefährdung vorhanden: Sauerstoffmangel',
   description_fr = 'Danger existant: manque d’oxygène',
   description_it = 'Atmosfera pericolosa: mancanza di ossigeno',
   description_ro = '',
   display_en = 'DDFA',
   display_de = 'DDFA',
   display_fr = 'DDFA',
   display_it = 'DDFA',
   display_ro = 'DDFA'
WHERE code =4411;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4412,4412) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDFB',
   value_de = 'DDFB',
   value_fr = 'DDFB',
   value_it = 'DDFB',
   value_ro = 'DDFB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gefährdung vorhanden: Schwefelwasserstoff',
   description_de = 'Gefährdung vorhanden: Schwefelwasserstoff',
   description_fr = 'Danger existant: hydrogène sulfuré',
   description_it = 'Atmosfera pericolosa: idrogeno solforato',
   description_ro = '',
   display_en = 'DDFB',
   display_de = 'DDFB',
   display_fr = 'DDFB',
   display_it = 'DDFB',
   display_ro = 'DDFB'
WHERE code =4412;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4413,4413) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDFC',
   value_de = 'DDFC',
   value_fr = 'DDFC',
   value_it = 'DDFC',
   value_ro = 'DDFC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Gefährdung vorhanden: Methan',
   description_de = 'Gefährdung vorhanden: Methan',
   description_fr = 'Danger existant: méthane',
   description_it = 'Atmosfera pericolosa: metano',
   description_ro = '',
   display_en = 'DDFC',
   display_de = 'DDFC',
   display_fr = 'DDFC',
   display_it = 'DDFC',
   display_ro = 'DDFC'
WHERE code =4413;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4414,4414) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDFZ',
   value_de = 'DDFZ',
   value_fr = 'DDFZ',
   value_it = 'DDFZ',
   value_ro = 'DDFZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Andersartige Gefährdung vorhanden',
   description_de = 'Andersartige Gefährdung vorhanden',
   description_fr = 'Autres dangers présents ',
   description_it = 'Altri pericoli (ulteriori dettagli sono richiesti nella nota)',
   description_ro = '',
   display_en = 'DDFZ',
   display_de = 'DDFZ',
   display_fr = 'DDFZ',
   display_it = 'DDFZ',
   display_ro = 'DDFZ'
WHERE code =4414;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4416,4416) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDGA',
   value_de = 'DDGA',
   value_fr = 'DDGA',
   value_it = 'DDGA',
   value_ro = 'DDGA',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, Kamera unter Wasser',
   description_de = 'Keine Sicht, Kamera unter Wasser',
   description_fr = 'Absence de visibilité, caméra sous l’eau',
   description_it = 'Nessuna visibilità, telecamera immersa',
   description_ro = '',
   display_en = 'DDGA',
   display_de = 'DDGA',
   display_fr = 'DDGA',
   display_it = 'DDGA',
   display_ro = 'DDGA'
WHERE code =4416;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4417,4417) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDGB',
   value_de = 'DDGB',
   value_fr = 'DDGB',
   value_it = 'DDGB',
   value_ro = 'DDGB',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, Verschlammung',
   description_de = 'Keine Sicht, Verschlammung',
   description_fr = 'Absence de visibilité, vase',
   description_it = 'Nessuna visibilità, deposito fangoso',
   description_ro = '',
   display_en = 'DDGB',
   display_de = 'DDGB',
   display_fr = 'DDGB',
   display_it = 'DDGB',
   display_ro = 'DDGB'
WHERE code =4417;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4418,4418) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDGC',
   value_de = 'DDGC',
   value_fr = 'DDGC',
   value_it = 'DDGC',
   value_ro = 'DDGC',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht, Dampf',
   description_de = 'Keine Sicht, Dampf',
   description_fr = 'Absence de visibilité, vapeur',
   description_it = 'Nessuna visibilità, vapore',
   description_ro = '',
   display_en = 'DDGC',
   display_de = 'DDGC',
   display_fr = 'DDGC',
   display_it = 'DDGC',
   display_ro = 'DDGC'
WHERE code =4418;
--- Adapt tww_vl.damage_manhole_manhole_damage_code
 INSERT INTO tww_vl.damage_manhole_manhole_damage_code (code, vsacode) VALUES (4419,4419) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_damage_code SET
   value_en = 'DDGZ',
   value_de = 'DDGZ',
   value_fr = 'DDGZ',
   value_it = 'DDGZ',
   value_ro = 'DDGZ',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_Keine Sicht',
   description_de = 'Keine Sicht',
   description_fr = 'Absence de visibilité',
   description_it = 'Nessuna visibilità, altri motivi (ulteriori dettagli sono richiesti nella nota)',
   description_ro = '',
   display_en = 'DDGZ',
   display_de = 'DDGZ',
   display_fr = 'DDGZ',
   display_it = 'DDGZ',
   display_ro = 'DDGZ'
WHERE code =4419;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3743,3743) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'A',
   value_de = 'A',
   value_fr = 'A',
   value_it = 'A',
   value_ro = 'A',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_A Abdeckung und Rahmen',
   description_de = 'A Abdeckung und Rahmen',
   description_fr = 'A Tampon du regard et cadre',
   description_it = 'A Chiusino e telaio',
   description_ro = '',
   display_en = 'A',
   display_de = 'A',
   display_fr = 'A',
   display_it = 'A',
   display_ro = 'A'
WHERE code =3743;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3744,3744) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'B',
   value_de = 'B',
   value_fr = 'B',
   value_it = 'B',
   value_ro = 'B',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_B Schachthals',
   description_de = 'B Schachthals',
   description_fr = 'B Col du regard de visite',
   description_it = 'B Anello',
   description_ro = '',
   display_en = 'B',
   display_de = 'B',
   display_fr = 'B',
   display_it = 'B',
   display_ro = 'B'
WHERE code =3744;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3745,3745) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'D',
   value_de = 'D',
   value_fr = 'D',
   value_it = 'D',
   value_ro = 'D',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_D Konus',
   description_de = 'D Konus',
   description_fr = 'D Cône de réduction',
   description_it = 'D Cono',
   description_ro = '',
   display_en = 'D',
   display_de = 'D',
   display_fr = 'D',
   display_it = 'D',
   display_ro = 'D'
WHERE code =3745;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3746,3746) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'F',
   value_de = 'F',
   value_fr = 'F',
   value_it = 'F',
   value_ro = 'F',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_F Schachtrohre',
   description_de = 'F Schachtrohre',
   description_fr = 'F Chambre',
   description_it = 'F Pozzetto',
   description_ro = '',
   display_en = 'F',
   display_de = 'F',
   display_fr = 'F',
   display_it = 'F',
   display_ro = 'F'
WHERE code =3746;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3747,3747) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'H',
   value_de = 'H',
   value_fr = 'H',
   value_it = 'H',
   value_ro = 'H',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_H Bankett',
   description_de = 'H Bankett',
   description_fr = 'H Banquette',
   description_it = 'H Banchina',
   description_ro = '',
   display_en = 'H',
   display_de = 'H',
   display_fr = 'H',
   display_it = 'H',
   display_ro = 'H'
WHERE code =3747;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3748,3748) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'I',
   value_de = 'I',
   value_fr = 'I',
   value_it = 'I',
   value_ro = 'I',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_I Durchlaufrinne',
   description_de = 'I Durchlaufrinne',
   description_fr = 'I Cunette',
   description_it = 'I Cunetta di scorrimento',
   description_ro = '',
   display_en = 'I',
   display_de = 'I',
   display_fr = 'I',
   display_it = 'I',
   display_ro = 'I'
WHERE code =3748;
--- Adapt tww_vl.damage_manhole_manhole_shaft_area
 INSERT INTO tww_vl.damage_manhole_manhole_shaft_area (code, vsacode) VALUES (3749,3749) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.damage_manhole_manhole_shaft_area SET
   value_en = 'J',
   value_de = 'J',
   value_fr = 'J',
   value_it = 'J',
   value_ro = 'J',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'yyy_J Sohle',
   description_de = 'J Sohle',
   description_fr = 'J Radier',
   description_it = 'J Fondo',
   description_ro = '',
   display_en = 'J',
   display_de = 'J',
   display_fr = 'J',
   display_it = 'J',
   display_ro = 'J'
WHERE code =3749;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3784,3784) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
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
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code =3784;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3785,3785) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'CD',
   value_de = 'CD',
   value_fr = 'CD',
   value_it = 'CD',
   value_ro = 'CD',
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
   display_en = 'CD',
   display_de = 'CD',
   display_fr = 'CD',
   display_it = 'CD',
   display_ro = 'CD'
WHERE code =3785;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3786,3786) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'floppy_disc',
   value_de = 'Diskette',
   value_fr = 'disquette',
   value_it = 'dischetto',
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
   display_en = 'floppy_disc',
   display_de = 'Diskette',
   display_fr = 'disquette',
   display_it = '',
   display_ro = ''
WHERE code =3786;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3787,3787) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'dvd',
   value_de = 'DVD',
   value_fr = 'DVD',
   value_it = 'DVD',
   value_ro = 'DVD',
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
   display_en = 'dvd',
   display_de = 'DVD',
   display_fr = 'DVD',
   display_it = 'DVD',
   display_ro = 'DVD'
WHERE code =3787;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3788,3788) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'harddisc',
   value_de = 'Festplatte',
   value_fr = 'disque_dur',
   value_it = 'disco_fisso',
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
   display_en = 'harddisc',
   display_de = 'Festplatte',
   display_fr = 'disque dur',
   display_it = '',
   display_ro = ''
WHERE code =3788;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3789,3789) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'server',
   value_de = 'Server',
   value_fr = 'serveur',
   value_it = 'server',
   value_ro = 'server',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Local server (as opposed to Webserver)',
   description_de = 'Lokaler Server (im Gegensatz zu Webserver)',
   description_fr = 'Serveur local (par opposition à serveur web)',
   description_it = 'Server locale (rispetto all server web)',
   description_ro = 'Server local (spre deosebire de server web)',
   display_en = 'server',
   display_de = 'Server',
   display_fr = 'serveur',
   display_it = '',
   display_ro = ''
WHERE code =3789;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (3790,3790) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'videotape',
   value_de = 'Videoband',
   value_fr = 'bande_video',
   value_it = 'nastro_video',
   value_ro = 'rrr_Videoband',
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
   display_en = 'videotape',
   display_de = 'Videoband',
   display_fr = 'bande vidéo',
   display_it = '',
   display_ro = ''
WHERE code =3790;
--- Adapt tww_vl.data_media_kind
 INSERT INTO tww_vl.data_media_kind (code, vsacode) VALUES (9318,9318) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.data_media_kind SET
   value_en = 'webserver',
   value_de = 'Webserver',
   value_fr = 'serveur_web',
   value_it = 'server_web',
   value_ro = 'server_web',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'Web server with URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)',
   description_de = 'Webserver mit URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)',
   description_fr = 'Serveur web avec URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)',
   description_it = 'Server web con URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)',
   description_ro = 'Server web cu URI (https://de.wikipedia.org/wiki/Uniform_Resource_Identifier)',
   display_en = 'webserver',
   display_de = 'Webserver',
   display_fr = 'serveur web',
   display_it = '',
   display_ro = ''
WHERE code =9318;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9044,9044) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'drainless_toilet',
   value_de = 'Abflusslose_Toilette',
   value_fr = 'TOILETTE_SANS_VIDANGE',
   value_it = 'toilette_senza_scarico',
   value_ro = 'rrr_Abflusslose_Toilette',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = 'drainless toilet',
   description_de = 'Abflusslose Toilette',
   description_fr = '',
   description_it = '',
   description_ro = '',
   display_en = 'drainless_toilet',
   display_de = 'Abflusslose_Toilette',
   display_fr = 'TOILETTE_SANS_VIDANGE',
   display_it = '',
   display_ro = 'rrr_Abflusslose_Toilette'
WHERE code =9044;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9042,9042) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'disposal_without_drain',
   value_de = 'AbflussloseEntsorgung',
   value_fr = 'EVACUATION_SANS_REJET',
   value_it = 'zzz_AbflussloseEntsorgung',
   value_ro = 'rrr_AbflussloseEntsorgung',
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
   display_en = 'disposal_without_drain',
   display_de = 'AbflussloseEntsorgung',
   display_fr = 'EVACUATION_SANS_REJET',
   display_it = '',
   display_ro = ''
WHERE code =9042;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3800,3800) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'throttle_shut_off_unit',
   value_de = 'Absperr_Drosselorgan',
   value_fr = 'LIMITEUR_DEBIT',
   value_it = 'zzz_Absperr_Drosselorgan',
   value_ro = 'rrr_Absperr_Drosselorgan',
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
   display_en = 'throttle_shut_off_unit',
   display_de = 'Absperr_Drosselorgan',
   display_fr = 'LIMITEUR_DEBIT',
   display_it = '',
   display_ro = ''
WHERE code =3800;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3801,3801) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'wastewater_structure',
   value_de = 'Abwasserbauwerk',
   value_fr = 'OUVRAGE_RESEAU_AS',
   value_it = 'manufatto_smaltimento_acque',
   value_ro = 'rrr_Abwasserbauwerk',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = '',
   description_it = 'manufatto_smaltimento_acque',
   description_ro = '',
   display_en = 'wastewater_structure',
   display_de = 'Abwasserbauwerk',
   display_fr = 'OUVRAGE_RESEAU_AS',
   display_it = '',
   display_ro = ''
WHERE code =3801;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3802,3802) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'waster_water_treatment',
   value_de = 'Abwasserbehandlung',
   value_fr = 'TRAITEMENT_EAUX_USEES',
   value_it = 'zzz_Abwasserbehandlung',
   value_ro = 'rrr_Abwasserbehandlung',
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
   display_en = 'waster_water_treatment',
   display_de = 'Abwasserbehandlung',
   display_fr = 'TRAITEMENT_EAUX_USEES',
   display_it = '',
   display_ro = ''
WHERE code =3802;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3803,3803) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'wastewater_node',
   value_de = 'Abwasserknoten',
   value_fr = 'NOEUD_RESEAU',
   value_it = 'zzz_Abwasserknoten',
   value_ro = 'rrr_Abwasserknoten',
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
   display_en = 'wastewater_node',
   display_de = 'Abwasserknoten',
   display_fr = 'NOEUD_RESEAU',
   display_it = '',
   display_ro = ''
WHERE code =3803;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3804,3804) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'wastewater_networkelement',
   value_de = 'Abwassernetzelement',
   value_fr = 'ELEMENT_RESEAU_EVACUATION',
   value_it = 'zzz_Abwassernetzelement',
   value_ro = 'rrr_Abwassernetzelement',
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
   display_en = 'wastewater_networkelement',
   display_de = 'Abwassernetzelement',
   display_fr = 'ELEMENT_RESEAU_EVACUATION',
   display_it = '',
   display_ro = ''
WHERE code =3804;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3805,3805) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'waste_water_treatment_plant',
   value_de = 'Abwasserreinigungsanlage',
   value_fr = 'STATION_EPURATION',
   value_it = 'zzz_Abwasserreinigungsanlage',
   value_ro = 'rrr_Abwasserreinigungsanlage',
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
   display_en = 'waste_water_treatment_plant',
   display_de = 'Abwasserreinigungsanlage',
   display_fr = 'STATION_EPURATION',
   display_it = '',
   display_ro = ''
WHERE code =3805;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3806,3806) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'waste_water_association',
   value_de = 'Abwasserverband',
   value_fr = 'ASSOCIATION_EPURATION_EAU',
   value_it = 'consorzio_depurazione',
   value_ro = 'rrr_Abwasserverband',
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
   display_en = 'waste_water_association',
   display_de = 'Abwasserverband',
   display_fr = 'ASSOCIATION_EPURATION_EAU',
   display_it = '',
   display_ro = ''
WHERE code =3806;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3807,3807) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'administrative_office',
   value_de = 'Amt',
   value_fr = 'OFFICE',
   value_it = 'zzz_Amt',
   value_ro = 'rrr_Amt',
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
   display_en = 'administrative_office',
   display_de = 'Amt',
   display_fr = 'OFFICE',
   display_it = '',
   display_ro = ''
WHERE code =3807;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3808,3808) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'connection_object',
   value_de = 'Anschlussobjekt',
   value_fr = 'OBJET_RACCORDE',
   value_it = 'zzz_Anschlussobjekt',
   value_ro = 'rrr_Anschlussobjekt',
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
   display_en = 'connection_object',
   display_de = 'Anschlussobjekt',
   display_fr = 'OBJET_RACCORDE',
   display_it = '',
   display_ro = ''
WHERE code =3808;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3809,3809) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'wwtp_structure',
   value_de = 'ARABauwerk',
   value_fr = 'OUVRAGES_STEP',
   value_it = 'manufatto_IDA',
   value_ro = 'rrr_ARABauwerk',
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
   display_en = 'wwtp_structure',
   display_de = 'ARABauwerk',
   display_fr = 'OUVRAGES_STEP',
   display_it = '',
   display_ro = ''
WHERE code =3809;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3810,3810) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'wwtp_energy_use',
   value_de = 'ARAEnergienutzung',
   value_fr = 'CONSOMMATION_ENERGIE_STEP',
   value_it = 'zzz_ARAEnergienutzung',
   value_ro = 'rrr_ARAEnergienutzung',
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
   display_en = 'wwtp_energy_use',
   display_de = 'ARAEnergienutzung',
   display_fr = 'CONSOMMATION_ENERGIE_STEP',
   display_it = '',
   display_ro = ''
WHERE code =3810;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3811,3811) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'bathing_area',
   value_de = 'Badestelle',
   value_fr = 'LIEU_BAIGNADE',
   value_it = 'zzz_Badestelle',
   value_ro = 'rrr_Badestelle',
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
   display_en = 'bathing_area',
   display_de = 'Badestelle',
   display_fr = 'LIEU_BAIGNADE',
   display_it = '',
   display_ro = ''
WHERE code =3811;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3812,3812) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'benching',
   value_de = 'Bankett',
   value_fr = 'BANQUETTE',
   value_it = 'zzz_Bankett',
   value_ro = 'rrr_Bankett',
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
   display_en = 'benching',
   display_de = 'Bankett',
   display_fr = 'BANQUETTE',
   display_it = '',
   display_ro = ''
WHERE code =3812;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3813,3813) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'structure_part',
   value_de = 'BauwerksTeil',
   value_fr = 'ELEMENT_OUVRAGE',
   value_it = 'zzz_BauwerksTeil',
   value_ro = 'rrr_BauwerksTeil',
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
   display_en = 'structure_part',
   display_de = 'BauwerksTeil',
   display_fr = 'élement ouvrage',
   display_it = '',
   display_ro = ''
WHERE code =3813;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9038,9038) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'tank_emptying',
   value_de = 'Beckenentleerung',
   value_fr = 'VIDANGE_DE_BASSINS',
   value_it = 'vuotamento_bacino',
   value_ro = 'rrr_Beckenentleerung',
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
   display_en = 'tank_emptying',
   display_de = 'Beckenentleerung',
   display_fr = 'VIDANGE_DE_BASSINS',
   display_it = '',
   display_ro = ''
WHERE code =9038;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9039,9039) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'tank_cleaning',
   value_de = 'Beckenreinigung',
   value_fr = 'NETTOYAGE_DE_BASSINS',
   value_it = 'pulizia_bacino',
   value_ro = 'rrr_Beckenreinigung',
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
   display_en = 'tank_cleaning',
   display_de = 'Beckenreinigung',
   display_fr = 'NETTOYAGE_DE_BASSINS',
   display_it = '',
   display_ro = ''
WHERE code =9039;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9027,9027) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'bio_ecol_assessment',
   value_de = 'Biol_oekol_Gesamtbeurteilung',
   value_fr = 'EVALUATION_GENERALE_ECO_BIOL',
   value_it = 'valutazione_biol_ecol_globale',
   value_ro = 'rrr_Biol_oekol_Gesamtbeurteilung',
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
   display_en = 'bio_ecol_assessment',
   display_de = 'Biol_oekol_Gesamtbeurteilung',
   display_fr = 'EVALUATION_GENERALE_ECO_BIOL',
   display_it = '',
   display_ro = ''
WHERE code =9027;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3814,3814) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'well',
   value_de = 'Brunnen',
   value_fr = 'FONTAINE',
   value_it = 'zzz_Brunnen',
   value_ro = 'rrr_Brunnen',
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
   display_en = 'well',
   display_de = 'Brunnen',
   display_fr = 'FONTAINE',
   display_it = '',
   display_ro = ''
WHERE code =3814;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3815,3815) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'file',
   value_de = 'Datei',
   value_fr = 'FICHIER',
   value_it = 'file',
   value_ro = 'rrr_Datei',
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
   display_en = 'file',
   display_de = 'Datei',
   display_fr = 'FICHIER',
   display_it = '',
   display_ro = ''
WHERE code =3815;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3816,3816) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'data_media',
   value_de = 'Datentraeger',
   value_fr = 'SUPPORT_DONNEES',
   value_it = 'supporto_dati',
   value_ro = 'rrr_Datentraeger',
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
   display_en = 'data_media',
   display_de = 'Datentraeger',
   display_fr = 'SUPPORT_DONNEES',
   display_it = '',
   display_ro = ''
WHERE code =3816;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3817,3817) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'cover',
   value_de = 'Deckel',
   value_fr = 'COUVERCLE',
   value_it = 'zzz_Deckel',
   value_ro = 'rrr_Deckel',
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
   display_en = 'cover',
   display_de = 'Deckel',
   display_fr = 'COUVERCLE',
   display_it = '',
   display_ro = ''
WHERE code =3817;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3818,3818) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'passage',
   value_de = 'Durchlass',
   value_fr = 'PASSAGE_SOUS_TUYAU',
   value_it = 'zzz_Durchlass',
   value_ro = 'rrr_Durchlass',
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
   display_en = 'passage',
   display_de = 'Durchlass',
   display_fr = 'PASSAGE_SOUS_TUYAU',
   display_it = '',
   display_ro = ''
WHERE code =3818;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (5083,5083) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'discharge_point',
   value_de = 'Einleitstelle',
   value_fr = 'EXUTOIRE',
   value_it = 'punto_immissione',
   value_ro = 'deversor',
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
   display_en = 'discharge_point',
   display_de = 'Einleitstelle',
   display_fr = 'EXUTOIRE',
   display_it = '',
   display_ro = ''
WHERE code =5083;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3819,3819) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'access_aid',
   value_de = 'Einstiegshilfe',
   value_fr = 'DISPOSITIF_ACCES',
   value_it = 'zzz_Einstiegshilfe',
   value_ro = 'rrr_Einstiegshilfe',
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
   display_en = 'access_aid',
   display_de = 'Einstiegshilfe',
   display_fr = 'dispositif access',
   display_it = '',
   display_ro = ''
WHERE code =3819;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3820,3820) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'individual_surface',
   value_de = 'Einzelflaeche',
   value_fr = 'SURFACE_INDIVIDUELLE',
   value_it = 'zzz_Einzelflaeche',
   value_ro = 'rrr_Einzelflaeche',
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
   display_en = 'individual_surface',
   display_de = 'Einzelflaeche',
   display_fr = 'SURFACE_INDIVIDUELLE',
   display_it = '',
   display_ro = ''
WHERE code =3820;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3821,3821) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'catchment_area',
   value_de = 'Einzugsgebiet',
   value_fr = 'BASSIN_VERSANT',
   value_it = 'area_tributaria',
   value_ro = 'rrr_Einzugsgebiet',
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
   display_en = 'catchment_area',
   display_de = 'Einzugsgebiet',
   display_fr = 'BASSIN_VERSANT',
   display_it = '',
   display_ro = ''
WHERE code =3821;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3822,3822) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'electric_equipment',
   value_de = 'ElektrischeEinrichtung',
   value_fr = 'EQUIPEMENT_ELECTRIQUE',
   value_it = 'zzz_ElektrischeEinrichtung',
   value_ro = 'rrr_ElektrischeEinrichtung',
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
   display_en = 'electric_equipment',
   display_de = 'ElektrischeEinrichtung',
   display_fr = 'EQUIPEMENT_ELECTRIQUE',
   display_it = '',
   display_ro = ''
WHERE code =3822;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3823,3823) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'electromechanical_equipment',
   value_de = 'ElektromechanischeAusruestung',
   value_fr = 'EQUIPEMENT_ELECTROMECA',
   value_it = 'zzz_ElektromechanischeAusruestung',
   value_ro = 'rrr_ElektromechanischeAusruestung',
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
   display_en = 'electromechanical_equipment',
   display_de = 'ElektromechanischeAusruestung',
   display_fr = 'EQUIPEMENT_ELECTROMECA',
   display_it = '',
   display_ro = ''
WHERE code =3823;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9028,9028) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'disposal',
   value_de = 'Entsorgung',
   value_fr = 'EVACUATION',
   value_it = 'zzz_Entsorgung',
   value_ro = 'rrr_Entsorgung',
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
   display_en = 'disposal',
   display_de = 'Entsorgung',
   display_fr = 'EVACUATION',
   display_it = '',
   display_ro = ''
WHERE code =9028;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9043,9043) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'disposal_with_drain',
   value_de = 'EntsorgungMitAbfluss',
   value_fr = 'EVACUATION_AVEC_REJET',
   value_it = 'zzz_EntsorgungMitAbfluss',
   value_ro = 'rrr_EntsorgungMitAbfluss',
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
   display_en = 'disposal_with_drain',
   display_de = 'EntsorgungMitAbfluss',
   display_fr = 'EVACUATION_AVEC_REJET',
   display_it = '',
   display_ro = ''
WHERE code =9043;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3824,3824) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'drainage_system',
   value_de = 'Entwaesserungssystem',
   value_fr = 'systeme_evacuation_eaux',
   value_it = 'zzz_Entwaesserungssystem',
   value_ro = 'rrr_Entwaesserungssystem',
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
   display_en = 'drainage_system',
   display_de = 'Entwaesserungssystem',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3824;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3825,3825) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'maintenance_event',
   value_de = 'Erhaltungsereignis',
   value_fr = 'EVENEMENT_MAINTENANCE',
   value_it = 'evento_di_mantenimento',
   value_ro = 'rrr_Erhaltungsereignis',
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
   display_en = 'maintenance_event',
   display_de = 'Erhaltungsereignis',
   display_fr = 'EVENEMENT_MAINTENANCE',
   display_it = '',
   display_ro = ''
WHERE code =3825;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9029,9029) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'solids_retention',
   value_de = 'Feststoffrueckhalt',
   value_fr = 'RETENUE_DE_MATIERES_SOLIDES',
   value_it = 'ritenzione_solidi',
   value_ro = 'rrr_Feststoffrueckhalt',
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
   display_en = 'solids_retention',
   display_de = 'Feststoffrueckhalt',
   display_fr = 'RETENUE_DE_MATIERES_SOLIDES',
   display_it = '',
   display_ro = ''
WHERE code =9029;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3826,3826) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'fish_pass',
   value_de = 'Fischpass',
   value_fr = 'ECHELLE_POISSONS',
   value_it = 'zzz_Fischpass',
   value_ro = 'rrr_Fischpass',
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
   display_en = 'fish_pass',
   display_de = 'Fischpass',
   display_fr = 'échelle poissons',
   display_it = '',
   display_ro = ''
WHERE code =3826;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3827,3827) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'river',
   value_de = 'Fliessgewaesser',
   value_fr = 'COURS_EAU',
   value_it = 'zzz_Fliessgewaesser',
   value_ro = 'rrr_Fliessgewaesser',
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
   display_en = 'river',
   display_de = 'Fliessgewaesser',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3827;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3828,3828) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'pump',
   value_de = 'FoerderAggregat',
   value_fr = 'INSTALLATION_REFOULEMENT',
   value_it = 'pompaggio',
   value_ro = 'rrr_FoerderAggregat',
   abbr_en = '',
   abbr_de = '',
   abbr_fr = '',
   abbr_it = '',
   abbr_ro = '',
   description_en = '',
   description_de = '',
   description_fr = 'installation de refoulement',
   description_it = '',
   description_ro = '',
   display_en = 'pump',
   display_de = 'FoerderAggregat',
   display_fr = 'INSTALLATION_REFOULEMENT',
   display_it = '',
   display_ro = ''
WHERE code =3828;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3829,3829) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'ford',
   value_de = 'Furt',
   value_fr = 'PASSAGE_A_GUE',
   value_it = 'zzz_Furt',
   value_ro = 'rrr_Furt',
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
   display_en = 'ford',
   display_de = 'Furt',
   display_fr = 'PASSAGE_A_GUE',
   display_it = '',
   display_ro = ''
WHERE code =3829;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3830,3830) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'building',
   value_de = 'Gebaeude',
   value_fr = 'BATIMENT',
   value_it = 'zzz_Gebaeude',
   value_ro = 'rrr_Gebaeude',
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
   display_en = 'building',
   display_de = 'Gebaeude',
   display_fr = 'BATIMENT',
   display_it = '',
   display_ro = ''
WHERE code =3830;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9030,9030) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'building_group',
   value_de = 'Gebaeudegruppe',
   value_fr = 'BATIMENTS',
   value_it = 'zzz_Gebaeudegruppe',
   value_ro = 'rrr_Gebaeudegruppe',
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
   display_en = 'building_group',
   display_de = 'Gebaeudegruppe',
   display_fr = 'BATIMENTS',
   display_it = '',
   display_ro = ''
WHERE code =9030;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9031,9031) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'building_group_baugwr',
   value_de = 'Gebaeudegruppe_BAUGWR',
   value_fr = 'BATIMENTS_BAUREGBL',
   value_it = 'zzz_Gebaeudegruppe_BAUGWR',
   value_ro = 'rrr_Gebaeudegruppe_BAUGWR',
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
   display_en = 'building_group_baugwr',
   display_de = 'Gebaeudegruppe_BAUGWR',
   display_fr = 'BATIMENTS_BAUREGBL',
   display_it = '',
   display_ro = ''
WHERE code =9031;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3831,3831) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'hazard_source',
   value_de = 'Gefahrenquelle',
   value_fr = 'SOURCE_DANGER',
   value_it = 'zzz_Gefahrenquelle',
   value_ro = 'rrr_hart',
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
   display_en = 'hazard_source',
   display_de = 'Gefahrenquelle',
   display_fr = 'SOURCE_DANGER',
   display_it = '',
   display_ro = ''
WHERE code =3831;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3832,3832) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'municipality',
   value_de = 'Gemeinde',
   value_fr = 'COMMUNE',
   value_it = 'comune',
   value_ro = 'municipiul',
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
   display_en = 'municipality',
   display_de = 'Gemeinde',
   display_fr = 'COMMUNE',
   display_it = '',
   display_ro = ''
WHERE code =3832;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9032,9032) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'cooperative',
   value_de = 'Genossenschaft_Korporation',
   value_fr = 'COOPERATIVE',
   value_it = 'cooperativa_corporazione',
   value_ro = 'rrr_Genossenschaft_Korporation',
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
   display_en = 'cooperative',
   display_de = 'Genossenschaft_Korporation',
   display_fr = 'COOPERATIVE',
   display_it = '',
   display_ro = ''
WHERE code =9032;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9041,9041) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'catchment_area_totals',
   value_de = 'Gesamteinzugsgebiet',
   value_fr = 'BASSIN_VERSANT_COMPLET',
   value_it = 'area_tributaria_totale',
   value_ro = 'rrr_Gesamteinzugsgebiet',
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
   display_en = 'catchment_area_totals',
   display_de = 'Gesamteinzugsgebiet',
   display_fr = 'BASSIN_VERSANT_COMPLET',
   display_it = '',
   display_ro = ''
WHERE code =9041;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3833,3833) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'blocking_debris',
   value_de = 'Geschiebesperre',
   value_fr = 'BARRAGE_ALLUVIONS',
   value_it = 'zzz_Geschiebesperre',
   value_ro = 'rrr_Geschiebesperre',
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
   display_en = 'blocking_debris',
   display_de = 'Geschiebesperre',
   display_fr = 'BARRAGE_ALLUVIONS',
   display_it = '',
   display_ro = ''
WHERE code =3833;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3834,3834) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'water_course_segment',
   value_de = 'Gewaesserabschnitt',
   value_fr = 'TRONCON_COURS_EAU',
   value_it = 'zzz_Gewaesserabschnitt',
   value_ro = 'rrr_Gewaesserabschnitt',
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
   display_en = 'water_course_segment',
   display_de = 'Gewaesserabschnitt',
   display_fr = 'TRONCON_COURS_EAU',
   display_it = '',
   display_ro = ''
WHERE code =3834;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3835,3835) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'chute',
   value_de = 'GewaesserAbsturz',
   value_fr = 'SEUIL',
   value_it = 'zzz_GewaesserAbsturz',
   value_ro = 'rrr_GewaesserAbsturz',
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
   display_en = 'chute',
   display_de = 'GewaesserAbsturz',
   display_fr = 'SEUIL',
   display_it = '',
   display_ro = ''
WHERE code =3835;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3836,3836) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'water_body_protection_sector',
   value_de = 'Gewaesserschutzbereich',
   value_fr = 'SECTEUR_PROTECTION_EAUX',
   value_it = 'zzz_Gewaesserschutzbereich',
   value_ro = 'rrr_Gewaesserschutzbereich',
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
   display_en = 'water_body_protection_sector',
   display_de = 'Gewaesserschutzbereich',
   display_fr = 'SECTEUR_PROTECTION_EAUX',
   display_it = '',
   display_ro = ''
WHERE code =3836;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3837,3837) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'sector_water_body',
   value_de = 'Gewaessersektor',
   value_fr = 'SECTEUR_EAUX_SUP',
   value_it = 'zzz_Gewaessersektor',
   value_ro = 'rrr_Gewaessersektor',
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
   display_en = 'sector_water_body',
   display_de = 'Gewaessersektor',
   display_fr = 'SECTEUR_EAUX_SUP',
   display_it = '',
   display_ro = ''
WHERE code =3837;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3838,3838) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'river_bed',
   value_de = 'Gewaessersohle',
   value_fr = 'FOND_COURS_EAU',
   value_it = 'zzz_Gewaessersohle',
   value_ro = 'rrr_Gewaessersohle',
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
   display_en = 'river_bed',
   display_de = 'Gewaessersohle',
   display_fr = 'fond cours d''eau',
   display_it = '',
   display_ro = ''
WHERE code =3838;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3839,3839) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'water_control_structure',
   value_de = 'Gewaesserverbauung',
   value_fr = 'AMENAGEMENT_COURS_EAU',
   value_it = 'zzz_Gewaesserverbauung',
   value_ro = 'rrr_Gewaesserverbauung',
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
   display_en = 'water_control_structure',
   display_de = 'Gewaesserverbauung',
   display_fr = 'AMENAGEMENT_COURS_EAU',
   display_it = '',
   display_ro = ''
WHERE code =3839;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3840,3840) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'dam',
   value_de = 'GewaesserWehr',
   value_fr = 'OUVRAGE_RETENUE',
   value_it = 'zzz_GewaesserWehr',
   value_ro = 'rrr_GewaesserWehr',
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
   display_en = 'dam',
   display_de = 'GewaesserWehr',
   display_fr = 'OUVRAGE_RETENUE',
   display_it = '',
   display_ro = ''
WHERE code =3840;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3841,3841) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'aquifer',
   value_de = 'Grundwasserleiter',
   value_fr = 'AQUIFERE',
   value_it = 'acquifero',
   value_ro = 'rrr_Grundwasserleiter',
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
   display_en = 'aquifer',
   display_de = 'Grundwasserleiter',
   display_fr = 'AQUIFERE',
   display_it = '',
   display_ro = ''
WHERE code =3841;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3842,3842) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'ground_water_protection_perimeter',
   value_de = 'Grundwasserschutzareal',
   value_fr = 'PERIMETRE_PROT_EAUX_SOUT',
   value_it = 'zzz_Grundwasserschutzareal',
   value_ro = 'rrr_Grundwasserschutzareal',
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
   display_en = 'ground_water_protection_perimeter',
   display_de = 'Grundwasserschutzareal',
   display_fr = 'PERIMETRE_PROT_EAUX_SOUT',
   display_it = '',
   display_ro = ''
WHERE code =3842;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3843,3843) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'groundwater_protection_zone',
   value_de = 'Grundwasserschutzzone',
   value_fr = 'ZONE_PROT_EAUX_SOUT',
   value_it = 'zzz_Grundwasserschutzzone',
   value_ro = 'rrr_Grundwasserschutzzone',
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
   display_en = 'groundwater_protection_zone',
   display_de = 'Grundwasserschutzzone',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3843;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3844,3844) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'reach',
   value_de = 'Haltung',
   value_fr = 'TRONCON',
   value_it = 'tratta',
   value_ro = 'rrr_Haltung',
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
   display_en = 'reach',
   display_de = 'Haltung',
   display_fr = 'TRONCON',
   display_it = '',
   display_ro = ''
WHERE code =3844;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3845,3845) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'reach_point',
   value_de = 'Haltungspunkt',
   value_fr = 'POINT_TRONCON',
   value_it = 'punto_tratta',
   value_ro = 'rrr_Haltungspunkt',
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
   display_en = 'reach_point',
   display_de = 'Haltungspunkt',
   display_fr = 'POINT_TRONCON',
   display_it = '',
   display_ro = ''
WHERE code =3845;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3846,3846) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'hq_relation',
   value_de = 'HQ_Relation',
   value_fr = 'RELATION_HQ',
   value_it = 'zzz_HQ_Relation',
   value_ro = 'rrr_HQ_Relation',
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
   display_en = 'hq_relation',
   display_de = 'HQ_Relation',
   display_fr = 'RELATION_HQ',
   display_it = '',
   display_ro = ''
WHERE code =3846;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3847,3847) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'hydr_geometry',
   value_de = 'Hydr_Geometrie',
   value_fr = 'GEOMETRIE_HYDR',
   value_it = 'zzz_Hydr_Geometrie',
   value_ro = 'rrr_Hydr_Geometrie',
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
   display_en = 'hydr_geometry',
   display_de = 'Hydr_Geometrie',
   display_fr = 'Géométrie hydraulique',
   display_it = '',
   display_ro = ''
WHERE code =3847;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3848,3848) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'hydr_geom_relation',
   value_de = 'Hydr_GeomRelation',
   value_fr = 'RELATION_GEOM_HYDR',
   value_it = 'zzz_Hydr_GeomRelation',
   value_ro = 'rrr_Hydr_GeomRelation',
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
   display_en = 'hydr_geom_relation',
   display_de = 'Hydr_GeomRelation',
   display_fr = 'RELATION_GEOM_HYDR',
   display_it = '',
   display_ro = ''
WHERE code =3848;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9033,9033) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'hydraulic_char_data',
   value_de = 'Hydr_Kennwerte',
   value_fr = 'PARAMETRES_HYDR',
   value_it = 'zzz_Hydr_Kennwerte',
   value_ro = 'rrr_Hydr_Kennwerte',
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
   display_en = 'hydraulic_char_data',
   display_de = 'Hydr_Kennwerte',
   display_fr = 'PARAMETRES_HYDR',
   display_it = '',
   display_ro = ''
WHERE code =9033;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3849,3849) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'channel',
   value_de = 'Kanal',
   value_fr = 'CANALISATION',
   value_it = 'zzz_Kanal',
   value_ro = 'rrr_Kanal',
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
   display_en = 'channel',
   display_de = 'Kanal',
   display_fr = 'CANALISATION',
   display_it = '',
   display_ro = ''
WHERE code =3849;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3850,3850) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'damage_channel',
   value_de = 'Kanalschaden',
   value_fr = 'DOMMAGE_AUX_CANALISATIONS',
   value_it = 'zzz_Kanalschaden',
   value_ro = 'rrr_Kanalschaden',
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
   display_en = 'damage_channel',
   display_de = 'Kanalschaden',
   display_fr = 'dommage aux canalisation',
   display_it = '',
   display_ro = ''
WHERE code =3850;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3851,3851) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'canton',
   value_de = 'Kanton',
   value_fr = 'CANTON',
   value_it = 'zzz_Kanton',
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
   display_en = 'canton',
   display_de = 'Kanton',
   display_fr = 'CANTON',
   display_it = '',
   display_ro = ''
WHERE code =3851;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9034,9034) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'small_treatment_plant',
   value_de = 'KLARA',
   value_fr = 'PETITE_STEP',
   value_it = 'zzz_KLARA',
   value_ro = 'rrr_KLARA',
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
   display_en = 'small_treatment_plant',
   display_de = 'KLARA',
   display_fr = 'PETITE_STEP',
   display_it = '',
   display_ro = ''
WHERE code =9034;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9035,9035) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'farm',
   value_de = 'Landwirtschaftsbetrieb',
   value_fr = 'EXPLOITATION_AGRICOLE',
   value_it = 'zzz_Landwirtschaftsbetrieb',
   value_ro = 'rrr_Landwirtschaftsbetrieb',
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
   display_en = 'farm',
   display_de = 'Landwirtschaftsbetrieb',
   display_fr = 'EXPLOITATION_AGRICOLE',
   display_it = '',
   display_ro = ''
WHERE code =9035;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3852,3852) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'leapingweir',
   value_de = 'Leapingwehr',
   value_fr = 'LEAPING_WEIR',
   value_it = 'leaping_weir',
   value_ro = 'rrr_Leapingwehr',
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
   display_en = 'leapingweir',
   display_de = 'Leapingwehr',
   display_fr = 'LEAPING_WEIR',
   display_it = '',
   display_ro = ''
WHERE code =3852;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9036,9036) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'measure',
   value_de = 'Massnahme',
   value_fr = 'MESURE',
   value_it = 'intervento',
   value_ro = 'rrr_Massnahme',
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
   display_en = 'measure',
   display_de = 'Massnahme',
   display_fr = 'MESURE',
   display_it = '',
   display_ro = ''
WHERE code =9036;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3853,3853) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'mechanical_pretreatment',
   value_de = 'MechanischeVorreinigung',
   value_fr = 'PRETRAITEMENT_MECANIQUE',
   value_it = 'zzz_MechanischeVorreinigung',
   value_ro = 'rrr_MechanischeVorreinigung',
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
   display_en = 'mechanical_pretreatment',
   display_de = 'MechanischeVorreinigung',
   display_fr = 'PRETRAITEMENT_MECANIQUE',
   display_it = '',
   display_ro = ''
WHERE code =3853;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3854,3854) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'measurement_device',
   value_de = 'Messgeraet',
   value_fr = 'APPAREIL_MESURE',
   value_it = 'apparecchio_misura',
   value_ro = 'rrr_Messgeraet',
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
   display_en = 'measurement_device',
   display_de = 'Messgeraet',
   display_fr = 'APPAREIL_MESURE',
   display_it = '',
   display_ro = ''
WHERE code =3854;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3855,3855) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'measurement_series',
   value_de = 'Messreihe',
   value_fr = 'SERIE_MESURES',
   value_it = 'zzz_Messreihe',
   value_ro = 'rrr_Messreihe',
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
   display_en = 'measurement_series',
   display_de = 'Messreihe',
   display_fr = 'SERIE_MESURES',
   display_it = '',
   display_ro = ''
WHERE code =3855;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3856,3856) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'measurement_result',
   value_de = 'Messresultat',
   value_fr = 'RESULTAT_MESURE',
   value_it = 'zzz_Messresultat',
   value_ro = 'rrr_Messresultat',
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
   display_en = 'measurement_result',
   display_de = 'Messresultat',
   display_fr = 'RESULTAT_MESURE',
   display_it = '',
   display_ro = ''
WHERE code =3856;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3857,3857) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'measuring_point',
   value_de = 'Messstelle',
   value_fr = 'STATION_MESURE',
   value_it = 'stazione_misura',
   value_ro = 'rrr_Messstelle',
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
   display_en = 'measuring_point',
   display_de = 'Messstelle',
   display_fr = 'STATION_MESURE',
   display_it = '',
   display_ro = ''
WHERE code =3857;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3858,3858) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'standard_manhole',
   value_de = 'Normschacht',
   value_fr = 'CHAMBRE_STANDARD',
   value_it = 'zzz_Normschacht',
   value_ro = 'rrr_Normschacht',
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
   display_en = 'standard_manhole',
   display_de = 'Normschacht',
   display_fr = 'CHAMBRE_STANDARD',
   display_it = '',
   display_ro = ''
WHERE code =3858;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3859,3859) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'damage_manhole',
   value_de = 'Normschachtschaden',
   value_fr = 'DOMMAGE_CHAMBRE_STANDARD',
   value_it = 'zzz_Normschachtschaden',
   value_ro = 'rrr_Normschachtschaden',
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
   display_en = 'damage_manhole',
   display_de = 'Normschachtschaden',
   display_fr = 'dommage chambre standard',
   display_it = '',
   display_ro = ''
WHERE code =3859;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3861,3861) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'surface_runoff_parameters',
   value_de = 'Oberflaechenabflussparameter',
   value_fr = 'PARAM_ECOULEMENT_SUP',
   value_it = 'zzz_Oberflaechenabflussparameter',
   value_ro = 'rrr_Oberflaechenabflussparameter',
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
   display_en = 'surface_runoff_parameters',
   display_de = 'Oberflaechenabflussparameter',
   display_fr = 'PARAM_ECOULEMENT_SUP',
   display_it = '',
   display_ro = ''
WHERE code =3861;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3862,3862) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'surface_water_bodies',
   value_de = 'Oberflaechengewaesser',
   value_fr = 'EAUX_SUPERFICIELLES',
   value_it = 'zzz_Oberflaechengewaesser',
   value_ro = 'rrr_Oberflaechengewaesser',
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
   display_en = 'surface_water_bodies',
   display_de = 'Oberflaechengewaesser',
   display_fr = 'eaux superficielles',
   display_it = '',
   display_ro = ''
WHERE code =3862;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3863,3863) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'organisation',
   value_de = 'Organisation',
   value_fr = 'ORGANISATION',
   value_it = 'organizzazione',
   value_ro = 'rrr_Organisation',
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
   display_en = 'organisation',
   display_de = 'Organisation',
   display_fr = 'ORGANISATION',
   display_it = '',
   display_ro = ''
WHERE code =3863;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3864,3864) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'planning_zone',
   value_de = 'Planungszone',
   value_fr = 'ZONE_RESERVEE',
   value_it = 'zzz_Planungszone',
   value_ro = 'rrr_Planungszone',
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
   display_en = 'planning_zone',
   display_de = 'Planungszone',
   display_fr = 'ZONE_RESERVEE',
   display_it = '',
   display_ro = ''
WHERE code =3864;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3865,3865) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'private',
   value_de = 'Privat',
   value_fr = 'PRIVE',
   value_it = 'privato',
   value_ro = 'privata',
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
   display_en = 'private',
   display_de = 'Privat',
   display_fr = 'PRIVE',
   display_it = '',
   display_ro = 'privata'
WHERE code =3865;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3866,3866) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'cleaning_device',
   value_de = 'Reinigungseinrichtung',
   value_fr = 'DISPOSITIF_NETTOYAGE',
   value_it = 'zzz_Reinigungseinrichtung',
   value_ro = 'rrr_Reinigungseinrichtung',
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
   display_en = 'cleaning_device',
   display_de = 'Reinigungseinrichtung',
   display_fr = 'dispositif nettoyage',
   display_it = '',
   display_ro = ''
WHERE code =3866;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3867,3867) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'reservoir',
   value_de = 'Reservoir',
   value_fr = 'RESERVOIR',
   value_it = 'zzz_Reservoir',
   value_ro = 'rrr_Reservoir',
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
   display_en = 'reservoir',
   display_de = 'Reservoir',
   display_fr = 'RESERVOIR',
   display_it = '',
   display_ro = ''
WHERE code =3867;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3868,3868) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'retention_body',
   value_de = 'Retentionskoerper',
   value_fr = 'VOLUME_RETENTION',
   value_it = 'zzz_Retentionskoerper',
   value_ro = 'rrr_Retentionskoerper',
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
   display_en = 'retention_body',
   display_de = 'Retentionskoerper',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3868;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3869,3869) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'pipe_profile',
   value_de = 'Rohrprofil',
   value_fr = 'PROFIL_TUYAU',
   value_it = 'profilo_del_tubo',
   value_ro = 'rrr_Rohrprofil',
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
   display_en = 'pipe_profile',
   display_de = 'Rohrprofil',
   display_fr = 'PROFIL_TUYAU',
   display_it = '',
   display_ro = ''
WHERE code =3869;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3870,3870) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'profile_geometry',
   value_de = 'Rohrprofil_Geometrie',
   value_fr = 'PROFIL_TUYAU_GEOM',
   value_it = 'zzz_Rohrprofil_Geometrie',
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
   display_en = 'profile_geometry',
   display_de = 'Rohrprofil_Geometrie',
   display_fr = 'PROFIL_TUYAU_GEOM',
   display_it = '',
   display_ro = ''
WHERE code =3870;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9040,9040) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'backflow_prevention',
   value_de = 'Rueckstausicherung',
   value_fr = 'PROTECTION_REFOULEMENT',
   value_it = 'dispositivo_anti_rigurgito',
   value_ro = 'rrr_Rueckstausicherung',
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
   display_en = 'backflow_prevention',
   display_de = 'Rueckstausicherung',
   display_fr = 'PROTECTION_REFOULEMENT',
   display_it = '',
   display_ro = ''
WHERE code =9040;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3871,3871) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'damage',
   value_de = 'Schaden',
   value_fr = 'DOMMAGE',
   value_it = 'zzz_Schaden',
   value_ro = 'rrr_Schaden',
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
   display_en = 'damage',
   display_de = 'Schaden',
   display_fr = 'dommage',
   display_it = '',
   display_ro = ''
WHERE code =3871;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3872,3872) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'sludge_treatment',
   value_de = 'Schlammbehandlung',
   value_fr = 'TRAITEMENT_BOUES',
   value_it = 'zzz_Schlammbehandlung',
   value_ro = 'rrr_Schlammbehandlung',
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
   display_en = 'sludge_treatment',
   display_de = 'Schlammbehandlung',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3872;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3873,3873) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'lock',
   value_de = 'Schleuse',
   value_fr = 'ECLUSE',
   value_it = 'zzz_Schleuse',
   value_ro = 'rrr_Schleuse',
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
   display_en = 'lock',
   display_de = 'Schleuse',
   display_fr = 'éclues',
   display_it = '',
   display_ro = ''
WHERE code =3873;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3874,3874) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'lake',
   value_de = 'See',
   value_fr = 'LAC',
   value_it = 'lago',
   value_ro = 'rrr_See',
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
   display_en = 'lake',
   display_de = 'See',
   display_fr = 'lac',
   display_it = 'lago',
   display_ro = ''
WHERE code =3874;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3875,3875) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'rock_ramp',
   value_de = 'Sohlrampe',
   value_fr = 'RAMPE',
   value_it = 'zzz_Sohlrampe',
   value_ro = 'rrr_Sohlrampe',
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
   display_en = 'rock_ramp',
   display_de = 'Sohlrampe',
   display_fr = 'RAMPE',
   display_it = '',
   display_ro = ''
WHERE code =3875;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3876,3876) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'special_structure',
   value_de = 'Spezialbauwerk',
   value_fr = 'OUVRAGE_SPECIAL',
   value_it = 'zzz_Spezialbauwerk',
   value_ro = 'rrr_Spezialbauwerk',
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
   display_en = 'special_structure',
   display_de = 'Spezialbauwerk',
   display_fr = 'OUVRAGE_SPECIAL',
   display_it = '',
   display_ro = ''
WHERE code =3876;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9026,9026) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'flushing_nozzle',
   value_de = 'Spuelstutzen',
   value_fr = 'TETE_DE_RINCAGE',
   value_it = 'zzz_Ugello_di_lavaggio',
   value_ro = 'rrr_Spuelstutzen',
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
   display_en = 'flushing_nozzle',
   display_de = 'Spuelstutzen',
   display_fr = 'TETE_DE_RINCAGE',
   display_it = '',
   display_ro = ''
WHERE code =9026;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (9037,9037) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'log_card',
   value_de = 'Stammkarte',
   value_fr = 'FICHE_TECHNIQUE',
   value_it = 'scheda_tipo',
   value_ro = 'rrr_Stammkarte',
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
   display_en = 'log_card',
   display_de = 'Stammkarte',
   display_fr = 'FICHE_TECHNIQUE',
   display_it = '',
   display_ro = ''
WHERE code =9037;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3877,3877) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'control_center',
   value_de = 'Steuerungszentrale',
   value_fr = 'CENTRALE_COMMANDE',
   value_it = 'zzz_Steuerungszentrale',
   value_ro = 'rrr_Steuerungszentrale',
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
   display_en = 'control_center',
   display_de = 'Steuerungszentrale',
   display_fr = 'CENTRALE_COMMANDE',
   display_it = '',
   display_ro = ''
WHERE code =3877;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3878,3878) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'substance',
   value_de = 'Stoff',
   value_fr = 'SUBSTANCE',
   value_it = 'zzz_Stoff',
   value_ro = 'rrr_Stoff',
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
   display_en = 'substance',
   display_de = 'Stoff',
   display_fr = 'SUBSTANCE',
   display_it = '',
   display_ro = ''
WHERE code =3878;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3879,3879) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'prank_weir',
   value_de = 'Streichwehr',
   value_fr = 'DEVERSOIR_LATERAL',
   value_it = 'stramazzo_laterale',
   value_ro = 'rrr_Streichwehr',
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
   display_en = 'prank_weir',
   display_de = 'Streichwehr',
   display_fr = 'DEVERSOIR_LATERAL',
   display_it = '',
   display_ro = ''
WHERE code =3879;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3880,3880) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'dryweather_downspout',
   value_de = 'Trockenwetterfallrohr',
   value_fr = 'TUYAU_CHUTE',
   value_it = 'zzz_Trockenwetterfallrohr',
   value_ro = 'rrr_Trockenwetterfallrohr',
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
   display_en = 'dryweather_downspout',
   display_de = 'Trockenwetterfallrohr',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3880;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3881,3881) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'dryweather_flume',
   value_de = 'Trockenwetterrinne',
   value_fr = 'CUNETTE_DEBIT_TEMPS_SEC',
   value_it = 'zzz_Trockenwetterrinne',
   value_ro = 'rrr_Trockenwetterrinne',
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
   display_en = 'dryweather_flume',
   display_de = 'Trockenwetterrinne',
   display_fr = 'CUNETTE_DEBIT_TEMPS_SEC',
   display_it = '',
   display_ro = ''
WHERE code =3881;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3882,3882) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'overflow',
   value_de = 'Ueberlauf',
   value_fr = 'DEVERSOIR',
   value_it = 'zzz_Ueberlauf',
   value_ro = 'rrr_Ueberlauf',
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
   display_en = 'overflow',
   display_de = 'Ueberlauf',
   display_fr = 'DEVERSOIR',
   display_it = '',
   display_ro = ''
WHERE code =3882;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3883,3883) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'overflow_characteristic',
   value_de = 'Ueberlaufcharakteristik',
   value_fr = 'CARACTERISTIQUES_DEVERSOIR',
   value_it = 'zzz_Ueberlaufcharakteristik',
   value_ro = 'rrr_Ueberlaufcharakteristik',
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
   display_en = 'overflow_characteristic',
   display_de = 'Ueberlaufcharakteristik',
   display_fr = 'CARACTERISTIQUES_DEVERSOIR',
   display_it = '',
   display_ro = ''
WHERE code =3883;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3884,3884) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'shore',
   value_de = 'Ufer',
   value_fr = 'RIVE',
   value_it = 'zzz_Ufer',
   value_ro = 'rrr_Ufer',
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
   display_en = 'shore',
   display_de = 'Ufer',
   display_fr = 'RIVE',
   display_it = '',
   display_ro = ''
WHERE code =3884;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3885,3885) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'accident',
   value_de = 'Unfall',
   value_fr = 'ACCIDENT',
   value_it = 'zzz_Unfall',
   value_ro = 'rrr_Unfall',
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
   display_en = 'accident',
   display_de = 'Unfall',
   display_fr = 'ACCIDENT',
   display_it = '',
   display_ro = ''
WHERE code =3885;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3886,3886) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'examination',
   value_de = 'Untersuchung',
   value_fr = 'EXAMEN',
   value_it = 'zzz_Untersuchung',
   value_ro = 'rrr_Untersuchung',
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
   display_en = 'examination',
   display_de = 'Untersuchung',
   display_fr = 'EXAMEN',
   display_it = '',
   display_ro = ''
WHERE code =3886;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3887,3887) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'infiltration_installation',
   value_de = 'Versickerungsanlage',
   value_fr = 'INSTALLATION_INFILTRATION',
   value_it = 'impianto_infiltrazione',
   value_ro = 'rrr_Versickerungsanlage',
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
   display_en = 'infiltration_installation',
   display_de = 'Versickerungsanlage',
   display_fr = 'Installation d''infiltration',
   display_it = '',
   display_ro = ''
WHERE code =3887;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3888,3888) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'infiltration_zone',
   value_de = 'Versickerungsbereich',
   value_fr = 'ZONE_INFILTRATION',
   value_it = 'zzz_Versickerungsbereich',
   value_ro = 'rrr_Versickerungsbereich',
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
   display_en = 'infiltration_zone',
   display_de = 'Versickerungsbereich',
   display_fr = '',
   display_it = '',
   display_ro = ''
WHERE code =3888;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3890,3890) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'water_catchment',
   value_de = 'Wasserfassung',
   value_fr = 'CAPTAGE',
   value_it = 'zzz_Wasserfassung',
   value_ro = 'rrr_Wasserfassung',
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
   display_en = 'water_catchment',
   display_de = 'Wasserfassung',
   display_fr = 'CAPTAGE',
   display_it = '',
   display_ro = ''
WHERE code =3890;
--- Adapt tww_vl.file_classname
 INSERT INTO tww_vl.file_classname (code, vsacode) VALUES (3891,3891) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_classname SET
   value_en = 'zone',
   value_de = 'Zone',
   value_fr = 'ZONE',
   value_it = 'zzz_Zone',
   value_ro = 'rrr_Zone',
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
   display_en = 'zone',
   display_de = 'Zone',
   display_fr = 'ZONE',
   display_it = '',
   display_ro = ''
WHERE code =3891;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (3770,3770) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'other',
   value_de = 'andere',
   value_fr = 'autre',
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
   display_fr = 'autre',
   display_it = '',
   display_ro = ''
WHERE code =3770;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (9146,9146) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'digital_video',
   value_de = 'digitales_Video',
   value_fr = 'video_numerique',
   value_it = 'video_digitale',
   value_ro = 'rrr_digitales_Video',
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
   display_en = 'digital_video',
   display_de = 'digitales_Video',
   display_fr = 'vidéo numérique',
   display_it = '',
   display_ro = ''
WHERE code =9146;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (3772,3772) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'photo',
   value_de = 'Foto',
   value_fr = 'photo',
   value_it = 'foto',
   value_ro = 'foto',
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
   display_en = 'photo',
   display_de = 'Foto',
   display_fr = 'photo',
   display_it = '',
   display_ro = ''
WHERE code =3772;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (3773,3773) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'panoramo_film',
   value_de = 'Panoramofilm',
   value_fr = 'film_panoramique',
   value_it = 'film_panoramico',
   value_ro = 'rrr_Panoramofilm',
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
   display_en = 'panoramo_film',
   display_de = 'Panoramofilm',
   display_fr = 'film panoramique',
   display_it = '',
   display_ro = ''
WHERE code =3773;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (9147,9147) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'scan',
   value_de = 'Scan',
   value_fr = 'scan',
   value_it = 'scan',
   value_ro = 'scanare',
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
   display_en = 'scan',
   display_de = 'Scan',
   display_fr = 'scan',
   display_it = '',
   display_ro = ''
WHERE code =9147;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (8812,8812) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'sketch',
   value_de = 'Skizze',
   value_fr = 'croquis',
   value_it = 'schizzo',
   value_ro = 'schita',
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
   display_en = 'sketch',
   display_de = 'Skizze',
   display_fr = 'croquis',
   display_it = '',
   display_ro = 'Schi?a'
WHERE code =8812;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (3774,3774) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'textfile',
   value_de = 'Textdatei',
   value_fr = 'fichier_texte',
   value_it = 'file_di_testo',
   value_ro = 'rrr_Textdatei',
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
   display_en = 'textfile',
   display_de = 'Textdatei',
   display_fr = 'fichier texte',
   display_it = '',
   display_ro = ''
WHERE code =3774;
--- Adapt tww_vl.file_kind
 INSERT INTO tww_vl.file_kind (code, vsacode) VALUES (3775,3775) ON CONFLICT DO NOTHING;

 UPDATE tww_vl.file_kind SET
   value_en = 'video',
   value_de = 'Video',
   value_fr = 'video',
   value_it = 'video',
   value_ro = 'rrr_video',
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
   display_en = 'video',
   display_de = 'Video',
   display_fr = 'vidéo',
   display_it = '',
   display_ro = ''
WHERE code =3775;
