------------------
-- System tables
------------------
INSERT INTO tww_sys.dictionary_od_table (id, tablename, shortcut_en) VALUES
(2999998,'measure_text','MX'),
(2999999,'building_group_text','GX')
ON CONFLICT DO NOTHING;


------------------
-- Organisation extension
------------------

-- 05.03.2024: Neuer OID-Prefix für Mapping durch Waldburger bestellt: ch24eax1

INSERT INTO tww_od.organisation(
	obj_id, identifier, remark, uid, last_modification, fk_dataowner, fk_provider,organisation_type,status,_local_extension)
	VALUES 
	('ch24eax100000000',  'AfU Aargau',  'bei Import AG-64/AG-96 generiert','CHE114809310', now(), 'ch24eax100000000','ch24eax100000000',8605,9047,TRUE),
	('ch24eax100000154', 'Gemeinde Wettingen', NULL, 'CHE115075438', '2016-02-05', 'ch24eax100000000', 'ch24eax100000000',8604,9047,TRUE),
	('ch24eax100000315', 'Avia Tanklager Beteiligungs AG, Mellingen', NULL, 'CHE102501414', '2017-09-29', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000333', 'Kernkraftwerk Leibstadt AG', 'für_AraKKW_Leibstadt', 'CHE101719293', '2017-10-30', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000335', 'Axpo Power AG', 'u.a. für Ara Beznau', 'CHE105781196', '2017-10-30', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000343', 'Recyclingcenter Freiamt AG', NULL, 'CHE102501414', '2018-11-28', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE),
	('ch24eax100000348', 'PDAG-Fonds-Verein', 'Areal Königsfelden', 'CHE116398921', '2020-07-02', 'ch24eax100000000', 'ch24eax100000000',8606,9047,TRUE)
	ON CONFLICT DO NOTHING;

------------------
-- value list extensions
------------------


-- Einzugsgebiet_Entwaesserungssystem
INSERT INTO tww_vl.catchment_area_drainage_system_planned (code,vsacode,value_de,value_en,active) VALUES
(1999994,5193,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',true),
(1999995,5193,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',true),
(1999996,5193,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',true)
ON CONFLICT DO NOTHING;
INSERT INTO tww_vl.catchment_area_drainage_system_current (code,vsacode,value_de,value_en,active) VALUES
(1999997,5188,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',true),
(1999998,5188,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',true),
(1999999,5188,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',true)
ON CONFLICT DO NOTHING;

-- Kanal_Nutzungsart	
INSERT INTO tww_vl.channel_usage_planned (code,vsacode,value_de,value_en,active) VALUES
(1999992,9024,'Platzwasser','square_water',true) ON CONFLICT DO NOTHING; -- 9024 = Niederschlagsabwasser
INSERT INTO tww_vl.channel_usage_current (code,vsacode,value_de,value_en,active) VALUES
(1999993,9023,'Platzwasser','square_water',true) ON CONFLICT DO NOTHING; -- 9023 = Niederschlagsabwasser
INSERT INTO tww_vl.channel_usage_planned (code,vsacode,value_de,value_en,active) VALUES
(1999990,9024,'Strassenwasser','street_water',true) ON CONFLICT DO NOTHING; -- 9024 = Niederschlagsabwasser
INSERT INTO tww_vl.channel_usage_current (code,vsacode,value_de,value_en,active) VALUES
(1999989,9023,'Strassenwasser','street_water',true) ON CONFLICT DO NOTHING; -- 9023 = Niederschlagsabwasser
--Kanal_FunktionHierarchisch
INSERT INTO tww_vl.channel_function_hierarchic (code,vsacode,value_de,value_en,active) VALUES
(1999991,5071,'PAA.Arealentwaesserung','pwwf.site_drainage',true)ON CONFLICT DO NOTHING;

-- Massnahme
INSERT INTO tww_vl.measure_category (code,vsacode,value_de,value_en,active) VALUES
(1999988,8639,'Bachrenaturierung','creek_renaturalisation',true), -- 8639 = Massnahme_im_Gewaesser 
(1999987,8639,'Bachsanierung','creek_renovation',true), -- 8639 = Massnahme_im_Gewaesser 
(1999986,8707,'Einstellung_anpassen_hydraulisch','alter_hydr_settings',true), -- 8707 = Sonderbauwerk_Anpassung 
(1999985,4660,'GEP_Vorbereitungsarbeiten','GEP_preparations',true) , -- 4660 = GEP_Bearbeitung 
(1999984,8706,'Leitungsersatz_diverse_Gruende','reach_replacement_other',true) , -- 8706 = Erhaltung_Erneuerung 
(1999983,8706,'Leitungsersatz_hydraulisch','reach_replacement_hydraulic',true) , -- 8706 = Erhaltung_Erneuerung 
(1999982,8706,'Leitungsersatz_Zustand','reach_replacement_condition',true) , -- 8706 = Erhaltung_Erneuerung 
(1999981,8648,'Reinigung','maintenance_cleaning',true) , -- 8648 = Erhaltung_Reinigung 
(1999980,8646,'Renovierung','maintenance_renovation_renovation',true) , -- 8646 = Erhaltung_Renovierung_Reparatur 
(1999979,8646,'Reparatur','maintenance_renovation_repair',true) , -- 8646 = Erhaltung_Renovierung_Reparatur 
(1999978,8649,'Retention','runoff_prevention_retention_infiltration',true) , -- 8649 = Abflussvermeidung_Retention_Versickerung 
(1999977,8705,'Sonderbauwerk.Neubau','special_construction_new_buildung',true) , -- 8705 = Sonderbauwerk_Neubau 
(1999976,8707,'Sonderbauwerk.Aus_Umbau','special_construction_extension',true) , -- 8707 = Sonderbauwerk_Anpassung 
(1999975,8707,'Sonderbauwerk.Anpassung_hydraulisch','special_construction_customization_hydraulic',true) , -- 8707 = Sonderbauwerk_Anpassung 
(1999974,4654,'Sonderbauwerk.Rueckbau','special_construction_abolishment',true) , -- 4654 = Aufhebung 
(1999973,4662,'Untersuchung.andere','control_and_surveillance_other',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999972,4662,'Untersuchung.Begehung','control_and_surveillance_site_inspection',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999971,4662,'Untersuchung.Dichtheitspruefung','control_and_surveillance_tightness_check',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999970,4662,'Untersuchung.Kanalfernsehen','control_and_surveillance_TV',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999969,4662,'Untersuchung.unbekannt','control_and_surveillance_unknown',true) -- 4662 = Kontrolle_und_Ueberwachung 
ON CONFLICT DO NOTHING;



UPDATE tww_vl.measure_category SET active = FALSE where code = ANY( ARRAY[
9144 	-- ALR
, 8706 	-- Erhaltung_Erneuerung
, 8648 	-- Erhaltung_Reinigung
, 8646	-- Erhaltung_Renovierung_Reparatur
, 8647	-- Erhaltung_unbekannt
, 4662  -- Kontrolle_und_Ueberwachung
, 8639  -- Massnahme_im_Gewaesser 
, 8649  -- Abflussvermeidung_Retention_Versickerung
, 8707  -- Sonderbauwerk_Anpassung 
, 8705  -- Sonderbauwerk_Neubau 
]);


INSERT INTO tww_vl.manhole_function (code,vsacode,value_de,value_en,active) VALUES
(1999968,2742,'Schlammfang','sludge_trap',true),		-- Schlammsammler
(1999937,8736,'Kontrollschacht','manhole',true),  
(1999936,8703,'Vorbehandlung','pretreatment',true)
ON CONFLICT DO NOTHING;

UPDATE tww_vl.manhole_function SET active = false WHERE code = ANY(Array[
  8828	-- Entwaesserungsrinne_mit_Schlammsack
, 8601	-- Fettabscheider
, 8654  -- Kombischacht
, 8702  -- Behandlungsanlage  
, 8736  -- Kontroll-Einstiegschacht,  
, 8703  -- Vorbehandlungsanlage
]);


INSERT INTO tww_vl.special_structure_function (code,vsacode,value_de,value_en,active) VALUES
(1999967,8704,'Oelrueckhaltebecken','oil_retention_basin',true),  -- Mappt auf Behandlungsanlage
(1999940,8704,'Strassenwasserbehandlungsanlage','streetwater_treatment_plant',true),  
(1999935,8739,'Kontrollschacht','manhole',true),  
(1999934,8704,'Vorbehandlung','pretreatment',true)
ON CONFLICT DO NOTHING;

UPDATE tww_vl.special_structure_function SET active = false WHERE code = ANY(Array[
  8600 	-- Fettabscheider
, 8657	-- Havariebecken
, 8704  -- Behandlungsanlage  
, 8739  -- Kontroll-Einstiegschacht,  
, 9089  -- Vorbehandlungsanlage
]);
INSERT INTO tww_vl.infiltration_installation_kind (code,vsacode,value_de,value_en,active) VALUES
(1999966,3087,'andere','other',true),  -- Mappt auf unbekannt
(1999965,3282,'Retentionsfilterbecken','retention_filter_basin',true),  -- Mappt auf andere_mit_Bodenpassage
(1999942,3283,'Versickerungsstrang','infiltration_pipe',true),  -- andere_mit_Bodenpassage
(1999941,3284,'Versickerungsschacht_Strang','infiltration_pipe_manhole',true) -- Kombination_Schacht_Strang
ON CONFLICT DO NOTHING;

UPDATE tww_vl.infiltration_installation_kind SET active = FALSE where code = ANY( ARRAY[
  3283 	-- Versickerungsstrang_Galerie
, 3284 	-- Kombination_Schacht_Strang
]);



INSERT INTO tww_vl.building_group_ag96_disposal_type (code,vsacode,value_de,value_en,active) VALUES
(1999964,1999964,'Ableitung_Verwertung','drainage',true),  -- kein VSA mapping
(1999963,1999963,'Klaereinrichtung_Speicherung','clearing_storing',true),  -- kein VSA mapping
(1999962,1999962,'keinBedarf','noDemand',true),  -- kein VSA mapping
(1999961,1999961,'pendent','pending',true)  -- kein VSA mapping
ON CONFLICT DO NOTHING;


INSERT INTO tww_vl.organisation_organisation_type (code,vsacode,value_de,active) VALUES
(1999952,8605,'Amt',true)  -- VSA mapping auf Kanton
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.wastewater_node_ag96_is_gateway (code,vsacode,value_de,active) VALUES
(1999951,1999951,'Schnittstelle',true),  
(1999950,1999950,'keine_Schnittstelle',true),  
(1999949,1999949,'unbekannt',true)
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.wastewater_node_ag64_function (code,vsacode,value_de,active) VALUES
(1999948,1999948,'Anschluss',true)
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.pipe_profile_profile_type (code,vsacode,value_de,value_en,active) VALUES
(1999947,3357,'andere','other',true) -- 3357 = unbekannt 
ON CONFLICT DO NOTHING;


-- Versickerungsbereich
INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code,vsacode,value_de,value_en,active) VALUES
(1999946,371,'gut.Anlagenwahl_nicht_eingeschraenkt','good.free_choice',true), -- 371 = gut 
(1999945,371,'gut.Anlagenwahl_eingeschraenkt','good.restricted_choice',true), -- 371 = gut 
(1999944,371,'mittel.Anlagenwahl_nicht_eingeschraenkt','medium.free_choice',true), -- 372 = maessig  
(1999943,371,'mittel.Anlagenwahl_eingeschraenkt','medium.restricted_choice',true)  -- 372 = maessig 
ON CONFLICT DO NOTHING;

UPDATE tww_vl.infiltration_zone_infiltration_capacity SET active = FALSE where code = ANY( ARRAY[
371 	-- gut
, 372 	-- maessig
]);

--------------
-- Plantyp --
--------------

INSERT INTO tww_vl.building_group_text_plantype 
SELECT * FROM tww_vl.wastewater_structure_text_plantype;

INSERT INTO tww_vl.building_group_text_texthali
SELECT * FROM tww_vl.wastewater_structure_text_texthali;

INSERT INTO tww_vl.building_group_text_textvali 
SELECT * FROM tww_vl.wastewater_structure_text_textvali;

INSERT INTO tww_vl.measure_text_plantype
SELECT * FROM tww_vl.wastewater_structure_text_plantype;

INSERT INTO tww_vl.measure_text_texthali 
SELECT * FROM tww_vl.wastewater_structure_text_texthali;


INSERT INTO tww_vl.measure_text_textvali
SELECT * FROM tww_vl.wastewater_structure_text_textvali;

------------------------
-- Backwards Matching --
------------------------
INSERT INTO {ext_schema}.vl_manhole_function (code,value_agxx) VALUES
(8654,'Kontrollschacht') -- Kombischacht
ON CONFLICT DO NOTHING;

-- Nutzungsarten werden nicht gematcht, damit die Visualilserungen übernommen werden können
INSERT INTO {ext_schema}.vl_channel_usage_current (code,value_agxx) VALUES
(4522,'Mischwasser'),  
(4514,'Fremdwasser'),
(9023,'Sauberwasser'),
(4518,'Gewaesser'),
(4516,'Entlastetes_Mischwasser'),
(4526,'Schmutzwasser')
ON CONFLICT DO NOTHING;

INSERT INTO {ext_schema}.vl_channel_usage_planned (code,value_agxx) VALUES
(4523,'Mischwasser'),  
(4515,'Fremdwasser'),
(9022,'Sauberwasser'),
(4519,'Gewaesser'),
(4517,'Entlastetes_Mischwasser'),
(4527,'Schmutzwasser')
ON CONFLICT DO NOTHING;

INSERT INTO {ext_schema}.vl_building_group_function (code,value_agxx) VALUES
(4823,'andere'),  
(4820,'Ferienhaus'),
(4821,'Gewerbegebiet'),
(4822,'Landwirtschaftsgebiet'),
(4818,'andere'),
(4819,'Wohnhaus')
ON CONFLICT DO NOTHING;