

-----------------
-- Organisation
-----------------
INSERT INTO tww_vl.organisation_organisation_type (code,vsacode,value_de,value_en,active) VALUES
(1999952,8605,'Amt','government_office',true)  -- VSA mapping auf Kanton
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-----------------
-- Einzugsgebiet
-----------------

-- Entwaesserungssystem_geplant
INSERT INTO tww_vl.catchment_area_drainage_system_planned (code,vsacode,value_de,value_en,active) VALUES
(1999994,5193,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',true),
(1999995,5193,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',true),
(1999996,5193,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
UPDATE tww_vl.catchment_area_drainage_system_planned SET active = FALSE where code = ANY( ARRAY[
5193 	-- ModifiziertesSystem
, 8692 	-- vorbereitetes_Trennsystem
, 9067 	-- Drainagesystem
]);

CREATE TABLE IF NOT EXISTS tww_vl.catchment_area_drainage_system_planned_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_catchment_area_drainage_system_planned_bwrel_agxx_code PRIMARY KEY (code)); 

INSERT INTO tww_vl.catchment_area_drainage_system_planned_bwrel_agxx (code,value_agxx) VALUES
(5193,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser'), 	
(8692,'Trennsystem'), 	
(9067,'unbekannt')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;



-- Entwaesserungssystem_ist
INSERT INTO tww_vl.catchment_area_drainage_system_current (code,vsacode,value_de,value_en,active) VALUES
(1999997,5188,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',true),
(1999998,5188,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',true),
(1999999,5188,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
UPDATE tww_vl.catchment_area_drainage_system_current SET active = FALSE where code = ANY( ARRAY[
5188 	-- ModifiziertesSystem
, 8693 	-- vorbereitetes_Trennsystem
, 9068 	-- Drainagesystem
]);

CREATE TABLE IF NOT EXISTS tww_vl.catchment_area_drainage_system_current_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_catchment_area_drainage_system_current_bwrel_agxx_code PRIMARY KEY (code)); 

INSERT INTO tww_vl.catchment_area_drainage_system_current_bwrel_agxx (code,value_agxx) VALUES
(5188,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser'), 	
(8693,'Trennsystem'), 	
(9068,'unbekannt')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;


-----------------
-- Knoten
-----------------



-- Ist_Schnittstelle
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_node_ag96_is_gateway (CONSTRAINT pkey_tww_vl_wastewater_node_ag96_is_gateway PRIMARY KEY (code)) INHERITS (tww_vl.value_list_base); --Werteliste
ALTER TABLE tww_vl.wastewater_node_ag96_is_gateway DROP CONSTRAINT IF EXISTS pkey_tww_vl_wastewater_node_ag96_is_gateway CASCADE;
ALTER TABLE tww_vl.wastewater_node_ag96_is_gateway ADD CONSTRAINT pkey_tww_vl_wastewater_node_ag96_is_gateway PRIMARY KEY (code);
INSERT INTO tww_vl.wastewater_node_ag96_is_gateway (code,vsacode,value_de,value_en,active) VALUES
(1999951,1999951,'Schnittstelle','gateway',true),  
(1999950,1999950,'keine_Schnittstelle','no_gateway',true),  
(1999949,1999949,'unbekannt','unknown',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;


-- FunktionAG Anschluss
CREATE TABLE IF NOT EXISTS tww_vl.wastewater_node_ag64_function (CONSTRAINT pkey_tww_vl_wastewater_node_ag64_function PRIMARY KEY (code)) INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.wastewater_node_ag64_function DROP CONSTRAINT IF EXISTS pkey_tww_vl_wastewater_node_ag64_function CASCADE;
ALTER TABLE tww_vl.wastewater_node_ag64_function ADD CONSTRAINT pkey_tww_vl_wastewater_node_ag64_function PRIMARY KEY (code);
INSERT INTO tww_vl.wastewater_node_ag64_function (code,vsacode,value_de,active) VALUES
(1999948,1999948,'Anschluss',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

--FunktionAG Normschacht
INSERT INTO tww_vl.manhole_function (code,vsacode,value_de,value_en,active) VALUES
(1999968,2742,'Schlammfang','sludge_trap',true),		-- Schlammsammler
(1999937,8736,'Kontrollschacht','manhole',true),  
(1999936,8703,'Vorbehandlung','pretreatment',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
UPDATE tww_vl.manhole_function SET active = false WHERE code = ANY(Array[
  8828	-- Entwaesserungsrinne_mit_Schlammsack
, 8601	-- Fettabscheider
, 8654  -- Kombischacht
, 8702  -- Behandlungsanlage  
, 8736  -- Kontroll-Einstiegschacht,  
, 8703  -- Vorbehandlungsanlage
]);

CREATE TABLE IF NOT EXISTS tww_vl.manhole_function_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_manhole_function_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.manhole_function_bwrel_agxx (code,value_agxx) VALUES
(8828,'Entwaesserungsrinne'),  
(8601,'Schwimmstoffabscheider'),
(8654,'Kontrollschacht'),
(8702,'Vorbehandlung'),
(8736,'Kontrollschacht'),
(8703,'Vorbehandlung')  
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;

--FunktionAG Spezialbawerk
INSERT INTO tww_vl.special_structure_function (code,vsacode,value_de,value_en,active) VALUES
(1999967,8704,'Oelrueckhaltebecken','oil_retention_basin',true),  -- Mappt auf Behandlungsanlage
(1999940,8704,'Strassenwasserbehandlungsanlage','streetwater_treatment_plant',true),  
(1999935,8739,'Kontrollschacht','manhole',true),  
(1999934,8704,'Vorbehandlung','pretreatment',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
UPDATE tww_vl.special_structure_function SET active = false WHERE code = ANY(Array[
  8600 	-- Fettabscheider
, 8657	-- Havariebecken
, 8704  -- Behandlungsanlage  
, 8739  -- Kontroll-Einstiegschacht,  
, 9089  -- Vorbehandlungsanlage
]);

CREATE TABLE IF NOT EXISTS tww_vl.special_structure_function_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_special_structure_function_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.special_structure_function_bwrel_agxx (code,value_agxx) VALUES
(8600,'Schwimmstoffabscheider'),  
(8657,'andere'),
(8704,'Vorbehandlung'),
(8739,'Kontrollschacht'),
(9089,'Vorbehandlung')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;

--FunktionAG Versickerungsanlage
INSERT INTO tww_vl.infiltration_installation_kind (code,vsacode,value_de,value_en,active) VALUES
(1999966,3087,'andere','other',true),  -- Mappt auf unbekannt
(1999965,3282,'Retentionsfilterbecken','retention_filter_basin',true),  -- Mappt auf andere_mit_Bodenpassage
(1999942,3283,'Versickerungsstrang','infiltration_pipe',true),  -- andere_mit_Bodenpassage
(1999941,3284,'Versickerungsschacht_Strang','infiltration_pipe_manhole',true) -- Kombination_Schacht_Strang
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
UPDATE tww_vl.infiltration_installation_kind SET active = FALSE where code = ANY( ARRAY[
  3283 	-- Versickerungsstrang_Galerie
, 3284 	-- Kombination_Schacht_Strang
]);

CREATE TABLE IF NOT EXISTS tww_vl.infiltration_installation_kind_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_infiltration_installation_kind_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.infiltration_installation_kind_bwrel_agxx (code,value_agxx) VALUES
(3283,'Versickerungsstrang'), 	
(3284,'Versickerungsschacht_Strang')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;

-----------------
-- Haltung
-----------------
--NutzungsartAG_ist
INSERT INTO tww_vl.channel_usage_current (code,vsacode,value_de,value_en,active) VALUES
(1999993,9023,'Platzwasser','square_water',true),
(1999989,9023,'Strassenwasser','street_water',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

UPDATE tww_vl.channel_usage_current
SET order_usage_current=
 array_position(
	 ARRAY[
		  4526 --wastewater
  	     ,4522 --combined_wastewater
		 ,4516 --discharged_combined_wastewater
		 ,1999989 --street_water
		 ,1999993 -- square_water
		 ,4524 --clean_wastewater
		 ,4514 --clean_wastewater
		 ,9023 --surface_water
		 ,4518 --creek_water
		 ,4571 --other
		 ,5322 --unknown
		 ]
	 ,code);


-- DSS-Nutzungsarten werden nur rückwärts gematcht, damit die Visualisierungen übernommen werden können
CREATE TABLE IF NOT EXISTS tww_vl.channel_usage_current_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_channel_usage_current_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.channel_usage_current_bwrel_agxx (code,value_agxx) VALUES
(4522,'Mischwasser'),  
(4514,'Fremdwasser'),
(9023,'Sauberwasser'),
(4518,'Gewaesser'),
(4516,'Entlastetes_Mischwasser'),
(4526,'Schmutzwasser')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;

--NutzungsartAG_geplant
INSERT INTO tww_vl.channel_usage_planned (code,vsacode,value_de,value_en,active) VALUES
(1999992,9024,'Platzwasser','square_water',true),
(1999990,9024,'Strassenwasser','street_water',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-- DSS-Nutzungsarten werden nur rückwärts gematcht, damit die Visualisierungen übernommen werden können
CREATE TABLE IF NOT EXISTS tww_vl.channel_usage_planned_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_channel_usage_planned_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.channel_usage_planned_bwrel_agxx (code,value_agxx) VALUES
(4523,'Mischwasser'),  
(4515,'Fremdwasser'),
(9022,'Sauberwasser'),
(4519,'Gewaesser'),
(4517,'Entlastetes_Mischwasser'),
(4527,'Schmutzwasser')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;


--Kanal_FunktionHierarchisch
INSERT INTO tww_vl.channel_function_hierarchic (code,vsacode,value_de,value_en,active) VALUES
(1999991,5071,'PAA.Arealentwaesserung','pwwf.site_drainage',true)
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

UPDATE tww_vl.channel_function_hierarchic
SET order_fct_hierarchic=
 array_position(
	 ARRAY[
		 5068 --pwwf.water_bodies
  	     ,5070 --pwwf.main_drain_regional
		 ,5069 --pwwf.main_drain
		 ,5071 --pwwf.collector_sewer
		 ,1999991 --pwwf.site_drainage
		 ,5062 --pwwf.renovation_conduction
		 ,5064 --pwwf.residential_drainage
		 ,5072 --pwwf.road_drainage
		 ,5066 --pwwf.other
		 ,5074 --pwwf.unknown
		 ,5063 --swwf.renovation_conduction
		 ,5065 --swwf.residential_drainage
		 ,5073 --swwf.road_drainage
		 ,5067 --swwf.other
		 ,5075 --swwf.unknown
		 ]
	 ,code);

--Profiltyp
INSERT INTO tww_vl.pipe_profile_profile_type (code,vsacode,value_de,value_en,active) VALUES
(1999947,3357,'andere','other',true) -- 3357 = unbekannt 
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;


-----------------
-- GEPMassnahme
-----------------

-- Kategorie
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
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
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

CREATE TABLE IF NOT EXISTS tww_vl.measure_category_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_measure_category_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.measure_category_bwrel_agxx (code,value_agxx) VALUES
(9144,'andere'),
(8706,'andere'),
(8648,'Reinigung'),
(8646,'Renovierung'),
(8647,'andere'),
(4662,'Untersuchung.unbekannt'),
(8639,'Bachsanierung'),
(8649,'andere'),
(8707,'Sonderbauwerk.Anpassung_hydraulisch'),
(8705,'Sonderbauwerk.Neubau')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;


--Priorität
UPDATE tww_vl.measure_priority SET active = FALSE where code = ANY( ARRAY[
4763 	-- M4
]);
CREATE TABLE IF NOT EXISTS tww_vl.measure_priority_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_measure_priority_bwrel_agxx_code PRIMARY KEY (code));
INSERT INTO tww_vl.measure_priority_bwrel_agxx (code,value_agxx) VALUES
(4763,'unbekannt')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;


-----------------
-- VersickerungsbereichAG
-----------------

INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code,vsacode,value_de,value_en,active) VALUES
(1999946,371,'gut.Anlagenwahl_nicht_eingeschraenkt','good.free_choice',true), -- 371 = gut 
(1999945,371,'gut.Anlagenwahl_eingeschraenkt','good.restricted_choice',true), -- 371 = gut 
(1999944,371,'mittel.Anlagenwahl_nicht_eingeschraenkt','medium.free_choice',true), -- 372 = maessig  
(1999943,371,'mittel.Anlagenwahl_eingeschraenkt','medium.restricted_choice',true)  -- 372 = maessig 
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;
UPDATE tww_vl.infiltration_zone_infiltration_capacity SET active = FALSE where code = ANY( ARRAY[
371 	-- gut
, 372 	-- maessig
]);

CREATE TABLE IF NOT EXISTS tww_vl.infiltration_zone_infiltration_capacity_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_infiltration_zone_infiltration_capacity_bwrel_agxx_code PRIMARY KEY (code)); 
INSERT INTO tww_vl.infiltration_zone_infiltration_capacity_bwrel_agxx (code,value_agxx) VALUES
(371,'gut.Anlagenwahl_nicht_eingeschraenkt'),  
(372,'mittel.Anlagenwahl_nicht_eingeschraenkt')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;


-----------------
-- BautenAusserhalbBaugebiet
-----------------

-- EntsorgungsArt
CREATE TABLE IF NOT EXISTS tww_vl.building_group_ag96_disposal_type (CONSTRAINT pkey_tww_vl_building_group_ag96_disposal_type PRIMARY KEY (code)) INHERITS (tww_vl.value_list_base);
ALTER TABLE tww_vl.building_group_ag96_disposal_type DROP CONSTRAINT IF EXISTS pkey_tww_vl_building_group_ag96_disposal_type CASCADE;
ALTER TABLE tww_vl.building_group_ag96_disposal_type ADD CONSTRAINT pkey_tww_vl_building_group_ag96_disposal_type PRIMARY KEY (code);
INSERT INTO tww_vl.building_group_ag96_disposal_type (code,vsacode,value_de,value_en,active) VALUES
(1999964,1999964,'Ableitung_Verwertung','drainage',true),  -- kein VSA mapping
(1999963,1999963,'Klaereinrichtung_Speicherung','clearing_storing',true),  -- kein VSA mapping
(1999962,1999962,'keinBedarf','noDemand',true),  -- kein VSA mapping
(1999961,1999961,'pendent','pending',true)  -- kein VSA mapping
ON CONFLICT (code) DO UPDATE SET 
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-- Sanierungsbedarf nicht Matchbar
UPDATE tww_vl.building_group_renovation_necessity SET active = FALSE where code = ANY( ARRAY[
  8799 	-- unbekannt
]);
/*
Bautenausserhalbbaugebiet nicht 100% matchbar
CREATE TABLE IF NOT EXISTS tww_vl.building_group_renovation_necessity_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_building_group_renovation_necessity_bwrel_agxx_code PRIMARY KEY (code)); 
INSERT INTO tww_vl.building_group_renovation_necessity_bwrel_agxx (code,value_agxx) VALUES
  (8799,NULL) -- unbekannt, kann nicht auf Ja oder Nein gemappt werden
ON CONFLICT DO NOTHING;*/

CREATE TABLE IF NOT EXISTS tww_vl.building_group_function_bwrel_agxx (code integer, value_agxx TEXT, CONSTRAINT pkey_building_group_function_bwrel_agxx_code PRIMARY KEY (code)); 
INSERT INTO tww_vl.building_group_function_bwrel_agxx (code,value_agxx) VALUES
(4823,'andere'),  
(4820,'Ferienhaus'),
(4821,'Gewerbegebiet'),
(4822,'Landwirtschaftsgebiet'),
(4818,'andere'),
(4819,'Wohnhaus')
ON CONFLICT (code) DO UPDATE SET 
  value_agxx = EXCLUDED.value_agxx;

--------------
-- Texte
--------------
CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_plantype (
    CONSTRAINT pkey_tww_vl_building_group_text_plantype_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.building_group_text_plantype 
SELECT * FROM tww_vl.wastewater_structure_text_plantype
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_texthali (
    CONSTRAINT pkey_tww_vl_building_group_text_texthali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.building_group_text_texthali
SELECT * FROM tww_vl.wastewater_structure_text_texthali
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.building_group_text_textvali (
    CONSTRAINT pkey_tww_vl_building_group_text_textvali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.building_group_text_textvali 
SELECT * FROM tww_vl.wastewater_structure_text_textvali
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_plantype (
    CONSTRAINT pkey_tww_vl_measure_text_plantype_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.measure_text_plantype
SELECT * FROM tww_vl.wastewater_structure_text_plantype
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_texthali (
    CONSTRAINT pkey_tww_vl_measure_text_texthali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.measure_text_texthali 
SELECT * FROM tww_vl.wastewater_structure_text_texthali
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS tww_vl.measure_text_textvali (
    CONSTRAINT pkey_tww_vl_measure_text_textvali_code PRIMARY KEY (code)
)
    INHERITS (tww_vl.value_list_base)
TABLESPACE pg_default;
INSERT INTO tww_vl.measure_text_textvali
SELECT * FROM tww_vl.wastewater_structure_text_textvali
ON CONFLICT DO NOTHING;