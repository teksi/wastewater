-----------------
-- Organisation
-----------------
INSERT INTO tww_vl.organisation_organisation_type (code,vsacode,value_de,value_en,active) VALUES
(1999952,8605,'Amt','government_office',false)  -- VSA mapping auf Kanton
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
(1999994,5193,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',false),
(1999995,5193,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',false),
(1999996,5193,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-- Entwaesserungssystem_ist
INSERT INTO tww_vl.catchment_area_drainage_system_current (code,vsacode,value_de,value_en,active) VALUES
(1999997,5188,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',false),
(1999998,5188,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',false),
(1999999,5188,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-----------------
-- Knoten
-----------------



--FunktionAG Normschacht
INSERT INTO tww_vl.manhole_function (code,vsacode,value_de,value_en,active) VALUES
(1999968,2742,'Schlammfang','sludge_trap',false)		-- Schlammsammler
-- (1999937,8736,'Kontrollschacht','manhole',false),     -- Wird auf Kontroll-Einstiegschacht gemappt
--(1999936,8703,'Vorbehandlung','pretreatment',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

--FunktionAG Spezialbawerk
INSERT INTO tww_vl.special_structure_function (code,vsacode,value_de,value_en,active) VALUES
(1999967,8704,'Oelrueckhaltebecken','oil_retention_basin',false),  -- Mappt auf Behandlungsanlage
(1999940,8704,'Strassenwasserbehandlungsanlage','streetwater_treatment_plant',false)
-- (1999935,8739,'Kontrollschacht','manhole',false),  -- Wird auf Kontroll-Einstiegschacht gemappt
-- (1999934,8704,'Vorbehandlung','pretreatment',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

--FunktionAG Versickerungsanlage
INSERT INTO tww_vl.infiltration_installation_kind (code,vsacode,value_de,value_en,active) VALUES
(1999966,3087,'andere','other',false),  -- Mappt auf unbekannt
(1999965,3282,'Retentionsfilterbecken','retention_filter_basin',false)  -- Mappt auf andere_mit_Bodenpassage
--(1999942,3283,'Versickerungsstrang','infiltration_pipe',false),  -- Versickerungsstrang_Galerie
--(1999941,3284,'Versickerungsschacht_Strang','infiltration_pipe_manhole',false) -- Kombination_Schacht_Strang
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-----------------
-- Haltung
-----------------
--NutzungsartAG_ist
INSERT INTO tww_vl.channel_usage_current (code,vsacode,value_de,value_en,active) VALUES
(1999993,9023,'Platzwasser','square_water',false),
(1999989,9023,'Strassenwasser','street_water',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;


--NutzungsartAG_geplant
INSERT INTO tww_vl.channel_usage_planned (code,vsacode,value_de,value_en,active) VALUES
(1999992,9024,'Platzwasser','square_water',false),
(1999990,9024,'Strassenwasser','street_water',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

--Kanal_FunktionHierarchisch
INSERT INTO tww_vl.channel_function_hierarchic (code,vsacode,value_de,value_en,active) VALUES
(1999991,5071,'PAA.Arealentwaesserung','pwwf.site_drainage',false)
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

--Profiltyp
INSERT INTO tww_vl.pipe_profile_profile_type (code,vsacode,value_de,value_en,active) VALUES
(1999947,3357,'andere','other',false) -- 3357 = unbekannt
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
(1999988,8639,'Bachrenaturierung','creek_renaturalisation',false), -- 8639 = Massnahme_im_Gewaesser
(1999987,8639,'Bachsanierung','creek_renovation',false), -- 8639 = Massnahme_im_Gewaesser
(1999986,8707,'Einstellung_anpassen_hydraulisch','alter_hydr_settings',false), -- 8707 = Sonderbauwerk_Anpassung
(1999985,4660,'GEP_Vorbereitungsarbeiten','GEP_preparations',false) , -- 4660 = GEP_Bearbeitung
(1999984,8706,'Leitungsersatz_diverse_Gruende','reach_replacement_other',false) , -- 8706 = Erhaltung_Erneuerung
(1999983,8706,'Leitungsersatz_hydraulisch','reach_replacement_hydraulic',false) , -- 8706 = Erhaltung_Erneuerung
(1999982,8706,'Leitungsersatz_Zustand','reach_replacement_condition',false) , -- 8706 = Erhaltung_Erneuerung
--(1999981,8648,'Reinigung','maintenance_cleaning',false) , -- 8648 = Erhaltung_Reinigung
(1999980,8646,'Renovierung','maintenance_renovation_renovation',false) , -- 8646 = Erhaltung_Renovierung_Reparatur
(1999979,8646,'Reparatur','maintenance_renovation_repair',false) , -- 8646 = Erhaltung_Renovierung_Reparatur
-- (1999978,8649,'Retention','runoff_prevention_retention_infiltration',false) , -- 8649 = Abflussvermeidung_Retention_Versickerung
-- (1999977,8705,'Sonderbauwerk.Neubau','special_construction_new_buildung',false) , -- 8705 = Sonderbauwerk_Neubau
(1999976,8707,'Sonderbauwerk.Aus_Umbau','special_construction_extension',false) , -- 8707 = Sonderbauwerk_Anpassung
(1999975,8707,'Sonderbauwerk.Anpassung_hydraulisch','special_construction_customization_hydraulic',false) , -- 8707 = Sonderbauwerk_Anpassung
(1999974,4654,'Sonderbauwerk.Rueckbau','special_construction_abolishment',false) , -- 4654 = Aufhebung
(1999973,4662,'Untersuchung.andere','control_and_surveillance_other',false) , -- 4662 = Kontrolle_und_Ueberwachung
(1999972,4662,'Untersuchung.Begehung','control_and_surveillance_site_inspection',false) , -- 4662 = Kontrolle_und_Ueberwachung
(1999971,4662,'Untersuchung.Dichtheitspruefung','control_and_surveillance_tightness_check',false) , -- 4662 = Kontrolle_und_Ueberwachung
(1999970,4662,'Untersuchung.Kanalfernsehen','control_and_surveillance_TV',false) , -- 4662 = Kontrolle_und_Ueberwachung
(1999969,4662,'Untersuchung.unbekannt','control_and_surveillance_unknown',false) -- 4662 = Kontrolle_und_Ueberwachung
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;

-----------------
-- VersickerungsbereichAG
-----------------

INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code,vsacode,value_de,value_en,active) VALUES
(1999946,371,'gut.Anlagenwahl_nicht_eingeschraenkt','good.free_choice',false), -- 371 = gut
(1999945,371,'gut.Anlagenwahl_eingeschraenkt','good.restricted_choice',false), -- 371 = gut
(1999944,372,'mittel.Anlagenwahl_nicht_eingeschraenkt','medium.free_choice',false), -- 372 = maessig
(1999943,372,'mittel.Anlagenwahl_eingeschraenkt','medium.restricted_choice',false)  -- 372 = maessig
ON CONFLICT (code) DO UPDATE SET
  vsacode = EXCLUDED.vsacode
, value_de = EXCLUDED.value_de
, value_en = EXCLUDED.value_en
, active = EXCLUDED.active
;