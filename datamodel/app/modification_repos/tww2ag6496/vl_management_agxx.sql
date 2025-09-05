UPDATE tww_vl.catchment_area_drainage_system_planned SET active = not({activate})  where code = ANY( ARRAY[
5193 	-- ModifiziertesSystem
, 8692 	-- vorbereitetes_Trennsystem
, 9067 	-- Drainagesystem
]);

UPDATE tww_vl.catchment_area_drainage_system_current SET active = not({activate})  where code = ANY( ARRAY[
5188 	-- ModifiziertesSystem
, 8693 	-- vorbereitetes_Trennsystem
, 9068 	-- Drainagesystem
]);

UPDATE tww_vl.manhole_function SET active = not({activate})  WHERE code = ANY(Array[
  8828	-- Entwaesserungsrinne_mit_Schlammsack
, 8601	-- Fettabscheider
--, 8654  -- Kombischacht
, 8702  -- Behandlungsanlage
--, 8736  -- Kontroll-Einstiegschacht,
--, 8703  -- Vorbehandlungsanlage
]);

UPDATE tww_vl.special_structure_function SET active = not({activate})  WHERE code = ANY(Array[
  8704  -- Behandlungsanlage
, 8600 	-- Fettabscheider
, 8657	-- Havariebecken
--, 9302  -- Kombischacht
--, 8739  -- Kontroll-Einstiegschacht,
--, 9089  -- Vorbehandlungsanlage
]);

UPDATE tww_vl.infiltration_installation_kind SET active = not({activate})  where code = ANY( ARRAY[
  3279 	-- Flaechenfoermige_Versickerung
, 3280 	-- Versickerung_ueber_die_Schulter
, 3281 	-- MuldenRigolenversickerung
, 3282 	-- andere_mit_Bodenpassage
--, 3283 	-- Versickerungsstrang_Galerie
--, 3284 	-- Kombination_Schacht_Strang
, 3285 	-- andere_ohne_Bodenpassage
]);

UPDATE tww_vl.measure_category SET active = not({activate})  where code = ANY( ARRAY[
9144 	-- ALR
, 8706 	-- Erhaltung_Erneuerung
--, 8648 	-- Erhaltung_Reinigung
, 8646	-- Erhaltung_Renovierung_Reparatur
, 8647	-- Erhaltung_unbekannt
, 4662  -- Kontrolle_und_Ueberwachung
, 8639  -- Massnahme_im_Gewaesser
-- , 8649  -- Abflussvermeidung_Retention_Versickerung
, 8707  -- Sonderbauwerk_Anpassung
--, 8705  -- Sonderbauwerk_Neubau
]);

UPDATE tww_vl.measure_priority SET active = not({activate})  where code = ANY( ARRAY[
4763 	-- M4
]);

UPDATE tww_vl.infiltration_zone_infiltration_capacity SET active = not({activate})  where code = ANY( ARRAY[
371 	-- gut
, 372 	-- maessig
]);

UPDATE tww_vl.building_group_renovation_necessity SET active = not({activate})  where code = ANY( ARRAY[
  8799 	-- unbekannt
]);

UPDATE tww_vl.value_list_base SET active = {activate}  where code < 2000000 AND code > 1999000;
