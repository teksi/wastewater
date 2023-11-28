------ This file is sql code to Export QGEP (Modul SIA405Abwasser) in English to INTERLIS in German on QQIS
------ Second version using tid_generate and tid_lookup
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 15.03.2016 14:19:45
--- modified 15.8.2019 schema anpassung
--- modified 15.8.2019 sia405_base_sia405_baseclass_metaattribute -> sia405_baseclass_metaattribute
--- ST_Force2D für Geometrien eingefügt: qgep_od.wastewater_structure.detail_geometry_geometry, qgep_od.reach_point.situation_geometry, qgep_od.wastewater_node.situation_geometry, qgep_od.reach.progression_geometry, qgep_od.cover.situation_geometry

-- DELETE FROM sia405_abwasser_2015_2_d.organisation;

INSERT INTO sia405_abwasser_2015_2_d.organisation
(
t_id, bezeichnung, bemerkung, uid)
SELECT sia405_abwasser_2015_2_d.tid_lookup('organisation', obj_id), identifier, remark, uid
FROM qgep_od.organisation;

-- additional Table Assoc: Organisation_Teil_von/ no table hierarchy in qgep schema yet (check how to implement there)
-- INSERT INTO sia405_abwasser_2015_2_d.Organisation_Teil_vonassoc
-- (
-- t_id, Teil_vonref, Organisation_Teil_vonassocref)
-- SELECT sia405_abwasser_2015_2_d.tid_lookup('Organisation', obj_id), sia405_abwasser_2015_2_d.tid_lookup('Organisation', fk_part_of),sia405_abwasser_2015_2_d.tid_lookup('Organisation', obj_id)
-- FROM qgep_od.organisation;


INSERT INTO sia405_abwasser_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT sia405_abwasser_2015_2_d.tid_lookup('organisation', qgep_od.organisation.obj_id), '0', a.identifier as dataowner, b.identifier as provider, organisation.last_modification, sia405_abwasser_2015_2_d.tid_lookup('organisation', qgep_od.organisation.obj_id)
FROM qgep_od.organisation
   LEFT JOIN qgep_od.organisation as a ON organisation.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON organisation.fk_provider = b.obj_id;


INSERT INTO sia405_abwasser_2015_2_d.abwasserbauwerk
(t_id, zugaenglichkeit, baulos, detailgeometrie, finanzierung, bruttokosten, bezeichnung, inspektionsintervall, standortname, akten, bemerkung, sanierungsbedarf, wiederbeschaffungswert, wbw_basisjahr, wbw_bauart, status, baulicherzustand, subventionen, baujahr, ersatzjahr, eigentuemerref, betreiberref)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwasserbauwerk', obj_id),
CASE WHEN accessibility = 3444 THEN 'ueberdeckt' ---- 3444  covered
WHEN accessibility = 3447 THEN 'unbekannt' ---- 3447  unknown
WHEN accessibility = 3446 THEN 'unzugaenglich' ---- 3446  inaccessible
WHEN accessibility = 3445 THEN 'zugaenglich' ---- 3445  accessible
END,
contract_section,
-- detail_geometry_geometry,
ST_Force2D(detail_geometry_geometry),
CASE WHEN financing = 5510 THEN 'oeffentlich' ---- 5510  public
WHEN financing = 5511 THEN 'privat' ---- 5511  private
WHEN financing = 5512 THEN 'unbekannt' ---- 5512  unknown
END, gross_costs, identifier, inspection_interval, location_name, records, remark,
CASE WHEN renovation_necessity = 5370 THEN 'dringend' ---- 5370  urgent
WHEN renovation_necessity = 5368 THEN 'keiner' ---- 5368  none
WHEN renovation_necessity = 2 THEN 'kurzfristig' ---- 2  short_term
WHEN renovation_necessity = 4 THEN 'langfristig' ---- 4  long_term
WHEN renovation_necessity = 3 THEN 'mittelfristig' ---- 3  medium_term
WHEN renovation_necessity = 5369 THEN 'unbekannt' ---- 5369  unknown
END, replacement_value, rv_base_year,
CASE WHEN rv_construction_type = 4602 THEN 'andere' ---- 4602  other
WHEN rv_construction_type = 4603 THEN 'Feld' ---- 4603  field
WHEN rv_construction_type = 4606 THEN 'Sanierungsleitung_Bagger' ---- 4606  renovation_conduction_excavator
WHEN rv_construction_type = 4605 THEN 'Sanierungsleitung_Grabenfraese' ---- 4605  renovation_conduction_ditch_cutter
WHEN rv_construction_type = 4604 THEN 'Strasse' ---- 4604  road
WHEN rv_construction_type = 4601 THEN 'unbekannt' ---- 4601  unknown
END,
CASE WHEN status = 8493 THEN 'in_Betrieb'
WHEN status = 3027 THEN 'unbekannt'
WHEN status = 3633 THEN 'ausser_Betrieb'
END,
CASE WHEN structure_condition = 3037 THEN 'unbekannt' ---- 3037  unknown
WHEN structure_condition = 3363 THEN 'Z0' ---- 3363  Z0
WHEN structure_condition = 3359 THEN 'Z1' ---- 3359  Z1
WHEN structure_condition = 3360 THEN 'Z2' ---- 3360  Z2
WHEN structure_condition = 3361 THEN 'Z3' ---- 3361  Z3
WHEN structure_condition = 3362 THEN 'Z4' ---- 3362  Z4
END, subsidies, year_of_construction, year_of_replacement, sia405_abwasser_2015_2_d.tid_lookup('Organisation', fk_owner), sia405_abwasser_2015_2_d.tid_lookup('Organisation', fk_operator)
FROM qgep_od.wastewater_structure;


INSERT INTO sia405_abwasser_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwasserbauwerk', qgep_od.wastewater_structure.obj_id), '0', a.identifier as dataowner, b.identifier as provider, wastewater_structure.last_modification, sia405_abwasser_2015_2_d.tid_lookup('abwasserbauwerk', qgep_od.wastewater_structure.obj_id)
FROM qgep_od.wastewater_structure
   LEFT JOIN qgep_od.organisation as a ON wastewater_structure.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON wastewater_structure.fk_provider = b.obj_id;

INSERT INTO sia405_abwasser_2015_2_d.kanal
(
t_id, bettung_umhuellung, verbindungsart, funktionhierarchisch, funktionhydraulisch, spuelintervall, rohrlaenge, nutzungsart_ist, nutzungsart_geplant)
SELECT sia405_abwasser_2015_2_d.tid_lookup('kanal', obj_id),
CASE WHEN bedding_encasement = 5325 THEN 'andere' ---- 5325  other
WHEN bedding_encasement = 5332 THEN 'erdverlegt' ---- 5332  in_soil
WHEN bedding_encasement = 5328 THEN 'in_Kanal_aufgehaengt' ---- 5328  in_channel_suspended
WHEN bedding_encasement = 5339 THEN 'in_Kanal_einbetoniert' ---- 5339  in_channel_concrete_casted
WHEN bedding_encasement = 5331 THEN 'in_Leitungsgang' ---- 5331  in_walk_in_passage
WHEN bedding_encasement = 5337 THEN 'in_Vortriebsrohr_Beton' ---- 5337  in_jacking_pipe_concrete
WHEN bedding_encasement = 5336 THEN 'in_Vortriebsrohr_Stahl' ---- 5336  in_jacking_pipe_steel
WHEN bedding_encasement = 5335 THEN 'Sand' ---- 5335  sand
WHEN bedding_encasement = 5333 THEN 'SIA_Typ1' ---- 5333  sia_type_1
WHEN bedding_encasement = 5330 THEN 'SIA_Typ2' ---- 5330  sia_type_2
WHEN bedding_encasement = 5334 THEN 'SIA_Typ3' ---- 5334  sia_type_3
WHEN bedding_encasement = 5340 THEN 'SIA_Typ4' ---- 5340  sia_type_4
WHEN bedding_encasement = 5327 THEN 'Sohlbrett' ---- 5327  bed_plank
WHEN bedding_encasement = 5329 THEN 'unbekannt' ---- 5329  unknown
END,
CASE WHEN connection_type = 5341 THEN 'andere' ---- 5341  other
WHEN connection_type = 190 THEN 'Elektroschweissmuffen' ---- 190  electric_welded_sleeves
WHEN connection_type = 187 THEN 'Flachmuffen' ---- 187  flat_sleeves
WHEN connection_type = 193 THEN 'Flansch' ---- 193  flange
WHEN connection_type = 185 THEN 'Glockenmuffen' ---- 185  bell_shaped_sleeves
WHEN connection_type = 192 THEN 'Kupplung' ---- 192  coupling
WHEN connection_type = 194 THEN 'Schraubmuffen' ---- 194  screwed_sleeves
WHEN connection_type = 189 THEN 'spiegelgeschweisst' ---- 189  butt_welded
WHEN connection_type = 186 THEN 'Spitzmuffen' ---- 186  beaked_sleeves
WHEN connection_type = 191 THEN 'Steckmuffen' ---- 191  push_fit_sleeves
WHEN connection_type = 188 THEN 'Ueberschiebmuffen' ---- 188  slip_on_sleeves
WHEN connection_type = 3036 THEN 'unbekannt' ---- 3036  unknown
WHEN connection_type = 3666 THEN 'Vortriebsrohrkupplung' ---- 3666  jacking_pipe_coupling
END,
CASE WHEN function_hierarchic = 5069 THEN 'PAA.Hauptsammelkanal'
WHEN function_hierarchic = 5070 THEN 'andere'
END,
CASE WHEN function_hydraulic = 5320 THEN 'andere' ---- 5320  other
WHEN function_hydraulic = 2546 THEN 'Drainagetransportleitung' ---- 2546  drainage_transportation_pipe
WHEN function_hydraulic = 22 THEN 'Drosselleitung' ---- 22  restriction_pipe
WHEN function_hydraulic = 3610 THEN 'Duekerleitung' ---- 3610  inverted_syphon
WHEN function_hydraulic = 367 THEN 'Freispiegelleitung' ---- 367  gravity_pipe
WHEN function_hydraulic = 23 THEN 'Pumpendruckleitung' ---- 23  pump_pressure_pipe
WHEN function_hydraulic = 145 THEN 'Sickerleitung' ---- 145  seepage_water_drain
WHEN function_hydraulic = 21 THEN 'Speicherleitung' ---- 21  retention_pipe
WHEN function_hydraulic = 144 THEN 'Spuelleitung' ---- 144  jetting_pipe
WHEN function_hydraulic = 5321 THEN 'unbekannt' ---- 5321  unknown
WHEN function_hydraulic = 3655 THEN 'Vakuumleitung' ---- 3655  vacuum_pipe
END, jetting_interval, pipe_length,
CASE WHEN usage_current = 5322 THEN 'andere' ---- 5322  other
WHEN usage_current = 4518 THEN 'Bachwasser' ---- 4518  creek_water
WHEN usage_current = 4516 THEN 'entlastetes_Mischabwasser' ---- 4516  discharged_combined_wastewater
WHEN usage_current = 4524 THEN 'Industrieabwasser' ---- 4524  industrial_wastewater
WHEN usage_current = 4522 THEN 'Mischabwasser' ---- 4522  combined_wastewater
WHEN usage_current = 4520 THEN 'Regenabwasser' ---- 4520  rain_wastewater
WHEN usage_current = 4514 THEN 'Reinabwasser' ---- 4514  clean_wastewater
WHEN usage_current = 4526 THEN 'Schmutzabwasser' ---- 4526  wastewater
WHEN usage_current = 4571 THEN 'unbekannt' ---- 4571  unknown
END,
CASE WHEN usage_planned = 5323 THEN 'andere' ---- 5323  other
WHEN usage_planned = 4519 THEN 'Bachwasser' ---- 4519  creek_water
WHEN usage_planned = 4517 THEN 'entlastetes_Mischabwasser' ---- 4517  discharged_combined_wastewater
WHEN usage_planned = 4525 THEN 'Industrieabwasser' ---- 4525  industrial_wastewater
WHEN usage_planned = 4523 THEN 'Mischabwasser' ---- 4523  combined_wastewater
WHEN usage_planned = 4521 THEN 'Regenabwasser' ---- 4521  rain_wastewater
WHEN usage_planned = 4515 THEN 'Reinabwasser' ---- 4515  clean_wastewater
WHEN usage_planned = 4527 THEN 'Schmutzabwasser' ---- 4527  wastewater
WHEN usage_planned = 4569 THEN 'unbekannt' ---- 4569  unknown
END
FROM qgep_od.channel;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'kanal'
FROM
   sia405_abwasser_2015_2_d.kanal a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.normschacht
(
t_id, dimension1, dimension2, funktion, material, oberflaechenzulauf)
SELECT sia405_abwasser_2015_2_d.tid_lookup('normschacht', obj_id), dimension1, dimension2,
CASE WHEN function = 4532 THEN 'Absturzbauwerk' ---- 4532  drop_structure
WHEN function = 5344 THEN 'andere' ---- 5344  other
WHEN function = 4533 THEN 'Be_Entlueftung' ---- 4533  venting
WHEN function = 3267 THEN 'Dachwasserschacht' ---- 3267  rain_water_manhole
WHEN function = 3266 THEN 'Einlaufschacht' ---- 3266  gully
WHEN function = 3472 THEN 'Entwaesserungsrinne' ---- 3472  drainage_channel
WHEN function = 228 THEN 'Geleiseschacht' ---- 228  rail_track_gully
WHEN function = 204 THEN 'Kontrollschacht' ---- 204  manhole
WHEN function = 1008 THEN 'Oelabscheider' ---- 1008  oil_separator
WHEN function = 4536 THEN 'Pumpwerk' ---- 4536  pump_station
WHEN function = 5346 THEN 'Regenueberlauf' ---- 5346  stormwater_overflow
WHEN function = 2742 THEN 'Schlammsammler' ---- 2742  slurry_collector
WHEN function = 5347 THEN 'Schwimmstoffabscheider' ---- 5347  floating_material_separator
WHEN function = 4537 THEN 'Spuelschacht' ---- 4537  jetting_manhole
WHEN function = 4798 THEN 'Trennbauwerk' ---- 4798  separating_structure
WHEN function = 5345 THEN 'unbekannt' ---- 5345  unknown
END,
CASE WHEN material = 4540 THEN 'andere' ---- 4540  other
WHEN material = 4541 THEN 'Beton' ---- 4541  concrete
WHEN material = 4542 THEN 'Kunststoff' ---- 4542  plastic
WHEN material = 4543 THEN 'unbekannt' ---- 4543  unknown
END,
CASE WHEN surface_inflow = 5342 THEN 'andere' ---- 5342  other
WHEN surface_inflow = 2741 THEN 'keiner' ---- 2741  none
WHEN surface_inflow = 2739 THEN 'Rost' ---- 2739  grid
WHEN surface_inflow = 5343 THEN 'unbekannt' ---- 5343  unknown
WHEN surface_inflow = 2740 THEN 'Zulauf_seitlich' ---- 2740  intake_from_side
END
FROM qgep_od.manhole;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'normschacht'
FROM
   sia405_abwasser_2015_2_d.normschacht a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.einleitstelle
(
t_id, hochwasserkote, relevanz, terrainkote, wasserspiegel_hydraulik)
SELECT sia405_abwasser_2015_2_d.tid_lookup('einleitstelle', obj_id), highwater_level,
CASE WHEN relevance = 5580 THEN 'gewaesserrelevant' ---- 5580  relevant_for_water_course
WHEN relevance = 5581 THEN 'nicht_gewaesserrelevant' ---- 5581  non_relevant_for_water_course
END, terrain_level, waterlevel_hydraulic
FROM qgep_od.discharge_point;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'einleitstelle'
FROM
   sia405_abwasser_2015_2_d.einleitstelle a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.spezialbauwerk
(
t_id, bypass, notueberlauf, funktion, regenbecken_anordnung)
SELECT sia405_abwasser_2015_2_d.tid_lookup('spezialbauwerk', obj_id),
CASE WHEN bypass = 2682 THEN 'nicht_vorhanden' ---- 2682  inexistent
WHEN bypass = 3055 THEN 'unbekannt' ---- 3055  unknown
WHEN bypass = 2681 THEN 'vorhanden' ---- 2681  existent
END,
CASE WHEN emergency_spillway = 5866 THEN 'andere' ---- 5866  other
WHEN emergency_spillway = 5864 THEN 'inMischabwasserkanalisation' ---- 5864  in_combined_waste_water_drain
WHEN emergency_spillway = 5865 THEN 'inRegenabwasserkanalisation' ---- 5865  in_rain_waste_water_drain
WHEN emergency_spillway = 5863 THEN 'inSchmutzabwasserkanalisation' ---- 5863  in_waste_water_drain
WHEN emergency_spillway = 5878 THEN 'keiner' ---- 5878  none
WHEN emergency_spillway = 5867 THEN 'unbekannt' ---- 5867  unknown
END,
CASE WHEN function = 6397 THEN 'abflussloseGrube' ---- 6397  pit_without_drain
WHEN function = 245 THEN 'Absturzbauwerk' ---- 245  drop_structure
WHEN function = 6398 THEN 'Abwasserfaulraum' ---- 6398  hydrolizing_tank
WHEN function = 5371 THEN 'andere' ---- 5371  other
WHEN function = 386 THEN 'Be_Entlueftung' ---- 386  venting
WHEN function = 3234 THEN 'Duekerkammer' ---- 3234  inverse_syphon_chamber
WHEN function = 5091 THEN 'Duekeroberhaupt' ---- 5091  syphon_head
WHEN function = 6399 THEN 'Faulgrube' ---- 6399  septic_tank_two_chambers
WHEN function = 3348 THEN 'Gelaendemulde' ---- 3348  terrain_depression
WHEN function = 336 THEN 'Geschiebefang' ---- 336  bolders_bedload_catchement_dam
WHEN function = 5494 THEN 'Guellegrube' ---- 5494  cesspit
WHEN function = 6478 THEN 'Klaergrube' ---- 6478  septic_tank
WHEN function = 2998 THEN 'Kontrollschacht' ---- 2998  manhole
WHEN function = 2768 THEN 'Oelabscheider' ---- 2768  oil_separator
WHEN function = 246 THEN 'Pumpwerk' ---- 246  pump_station
WHEN function = 3673 THEN 'Regenbecken_Durchlaufbecken' ---- 3673  stormwater_tank_with_overflow
WHEN function = 3674 THEN 'Regenbecken_Fangbecken' ---- 3674  stormwater_tank_retaining_first_flush
WHEN function = 5574 THEN 'Regenbecken_Fangkanal' ---- 5574  stormwater_retaining_channel
WHEN function = 3675 THEN 'Regenbecken_Regenklaerbecken' ---- 3675  stormwater_sedimentation_tank
WHEN function = 3676 THEN 'Regenbecken_Regenrueckhaltebecken' ---- 3676  stormwater_retention_tank
WHEN function = 5575 THEN 'Regenbecken_Regenrueckhaltekanal' ---- 5575  stormwater_retention_channel
WHEN function = 5576 THEN 'Regenbecken_Stauraumkanal' ---- 5576  stormwater_storage_channel
WHEN function = 3677 THEN 'Regenbecken_Verbundbecken' ---- 3677  stormwater_composite_tank
WHEN function = 5372 THEN 'Regenueberlauf' ---- 5372  stormwater_overflow
WHEN function = 5373 THEN 'Schwimmstoffabscheider' ---- 5373  floating_material_separator
WHEN function = 383 THEN 'seitlicherZugang' ---- 383  side_access
WHEN function = 227 THEN 'Spuelschacht' ---- 227  jetting_manhole
WHEN function = 4799 THEN 'Trennbauwerk' ---- 4799  separating_structure
WHEN function = 3008 THEN 'unbekannt' ---- 3008  unknown
WHEN function = 2745 THEN 'Wirbelfallschacht' ---- 2745  vortex_manhole
END,
CASE WHEN stormwater_tank_arrangement = 4608 THEN 'Hauptschluss' ---- 4608  main_connection
WHEN stormwater_tank_arrangement = 4609 THEN 'Nebenschluss' ---- 4609  side_connection
WHEN stormwater_tank_arrangement = 4610 THEN 'unbekannt' ---- 4610  unknown
END
FROM qgep_od.special_structure;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'spezialbauwerk'
FROM
   sia405_abwasser_2015_2_d.spezialbauwerk a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.versickerungsanlage
(
t_id, schluckvermoegen, maengel, dimension1, dimension2, gwdistanz, wirksameflaeche, notueberlauf, art, beschriftung, versickerungswasser, saugwagen, wasserdichtheit)
SELECT sia405_abwasser_2015_2_d.tid_lookup('versickerungsanlage', obj_id), absorption_capacity,
CASE WHEN defects = 5361 THEN 'keine' ---- 5361  none
WHEN defects = 3276 THEN 'unwesentliche' ---- 3276  marginal
WHEN defects = 3275 THEN 'wesentliche' ---- 3275  substantial
END, dimension1, dimension2, distance_to_aquifer, effective_area,
CASE WHEN emergency_spillway = 5365 THEN 'inMischwasserkanalisation' ---- 5365  in_combined_waste_water_drain
WHEN emergency_spillway = 3307 THEN 'inRegenwasserkanalisation' ---- 3307  in_rain_waste_water_drain
WHEN emergency_spillway = 3304 THEN 'inVorfluter' ---- 3304  in_water_body
WHEN emergency_spillway = 3303 THEN 'keiner' ---- 3303  none
WHEN emergency_spillway = 3305 THEN 'oberflaechlichausmuendend' ---- 3305  surface_discharge
WHEN emergency_spillway = 3308 THEN 'unbekannt' ---- 3308  unknown
END,
CASE WHEN kind = 3282 THEN 'andere_mit_Bodenpassage' ---- 3282  with_soil_passage
WHEN kind = 3285 THEN 'andere_ohne_Bodenpassage' ---- 3285  without_soil_passage
WHEN kind = 3279 THEN 'Flaechenfoermige_Versickerung' ---- 3279  surface_infiltration
WHEN kind = 277 THEN 'Kieskoerper' ---- 277  gravel_formation
WHEN kind = 3284 THEN 'Kombination_Schacht_Strang' ---- 3284  combination_manhole_pipe
WHEN kind = 3281 THEN 'MuldenRigolenversickerung' ---- 3281  swale_french_drain_infiltration
WHEN kind = 3087 THEN 'unbekannt' ---- 3087  unknown
WHEN kind = 3280 THEN 'Versickerung_ueber_die_Schulter' ---- 3280  percolation_over_the_shoulder
WHEN kind = 276 THEN 'Versickerungsbecken' ---- 276  infiltration_basin
WHEN kind = 278 THEN 'Versickerungsschacht' ---- 278  adsorbing_well
WHEN kind = 3283 THEN 'Versickerungsstrang_Galerie' ---- 3283  infiltration_pipe_sections_gallery
END,
CASE WHEN labeling = 5362 THEN 'beschriftet' ---- 5362  labeled
WHEN labeling = 5363 THEN 'nichtbeschriftet' ---- 5363  not_labeled
WHEN labeling = 5364 THEN 'unbekannt' ---- 5364  unknown
END,
CASE WHEN seepage_utilization = 274 THEN 'Regenabwasser' ---- 274  rain_water
WHEN seepage_utilization = 273 THEN 'Reinabwasser' ---- 273  clean_water
WHEN seepage_utilization = 5359 THEN 'unbekannt' ---- 5359  unknown
END,
CASE WHEN vehicle_access = 3289 THEN 'unbekannt' ---- 3289  unknown
WHEN vehicle_access = 3288 THEN 'unzugaenglich' ---- 3288  inaccessible
WHEN vehicle_access = 3287 THEN 'zugaenglich' ---- 3287  accessible
END,
CASE WHEN watertightness = 3295 THEN 'nichtwasserdicht' ---- 3295  not_watertight
WHEN watertightness = 5360 THEN 'unbekannt' ---- 5360  unknown
WHEN watertightness = 3294 THEN 'wasserdicht' ---- 3294  watertight
END
FROM qgep_od.infiltration_installation;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'versickerungsanlage'
FROM
   sia405_abwasser_2015_2_d.versickerungsanlage a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.rohrprofil
(
t_id, hoehenbreitenverhaeltnis, bezeichnung, profiltyp, bemerkung)
SELECT sia405_abwasser_2015_2_d.tid_lookup('rohrprofil', obj_id), height_width_ratio, identifier,
CASE WHEN profile_type = 3351 THEN 'Eiprofil' ---- 3351  egg
WHEN profile_type = 3350 THEN 'Kreisprofil' ---- 3350  circle
WHEN profile_type = 3352 THEN 'Maulprofil' ---- 3352  mouth
WHEN profile_type = 3354 THEN 'offenes_Profil' ---- 3354  open
WHEN profile_type = 3353 THEN 'Rechteckprofil' ---- 3353  rectangular
WHEN profile_type = 3355 THEN 'Spezialprofil' ---- 3355  special
WHEN profile_type = 3357 THEN 'unbekannt' ---- 3357  unknown
END, remark
FROM qgep_od.pipe_profile;

INSERT INTO sia405_abwasser_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT sia405_abwasser_2015_2_d.tid_lookup('rohrprofil', qgep_od.pipe_profile.obj_id), '0', a.identifier as dataowner, b.identifier as provider, pipe_profile.last_modification, sia405_abwasser_2015_2_d.tid_lookup('rohrprofil', qgep_od.pipe_profile.obj_id)
FROM qgep_od.pipe_profile
   LEFT JOIN qgep_od.organisation as a ON pipe_profile.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON pipe_profile.fk_provider = b.obj_id;

INSERT INTO sia405_abwasser_2015_2_d.abwassernetzelement
(
t_id, bezeichnung, bemerkung, abwasserbauwerkref)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwassernetzelement', obj_id), identifier, remark, sia405_abwasser_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure)
FROM qgep_od.wastewater_networkelement;

INSERT INTO sia405_abwasser_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwassernetzelement', qgep_od.wastewater_networkelement.obj_id), '0', a.identifier as dataowner, b.identifier as provider, wastewater_networkelement.last_modification, sia405_abwasser_2015_2_d.tid_lookup('abwassernetzelement', qgep_od.wastewater_networkelement.obj_id)
FROM qgep_od.wastewater_networkelement
   LEFT JOIN qgep_od.organisation as a ON wastewater_networkelement.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON wastewater_networkelement.fk_provider = b.obj_id;

INSERT INTO sia405_abwasser_2015_2_d.haltungspunkt
(
t_id, hoehengenauigkeit, bezeichnung, kote, auslaufform, lage_anschluss, bemerkung, lage, abwassernetzelementref)
SELECT sia405_abwasser_2015_2_d.tid_lookup('haltungspunkt', obj_id),
CASE WHEN elevation_accuracy = 3248 THEN 'groesser_6cm' ---- 3248  more_than_6cm
WHEN elevation_accuracy = 3245 THEN 'plusminus_1cm' ---- 3245  plusminus_1cm
WHEN elevation_accuracy = 3246 THEN 'plusminus_3cm' ---- 3246  plusminus_3cm
WHEN elevation_accuracy = 3247 THEN 'plusminus_6cm' ---- 3247  plusminus_6cm
WHEN elevation_accuracy = 5376 THEN 'unbekannt' ---- 5376  unknown
END, identifier, level,
CASE WHEN outlet_shape = 5374 THEN 'abgerundet' ---- 5374  round_edged
WHEN outlet_shape = 298 THEN 'blendenfoermig' ---- 298  orifice
WHEN outlet_shape = 3358 THEN 'keine_Querschnittsaenderung' ---- 3358  no_cross_section_change
WHEN outlet_shape = 286 THEN 'scharfkantig' ---- 286  sharp_edged
WHEN outlet_shape = 5375 THEN 'unbekannt' ---- 5375  unknown
END, position_of_connection, remark,
--situation_geometry,
ST_Force2D(situation_geometry),
sia405_abwasser_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement)
FROM qgep_od.reach_point;

INSERT INTO sia405_abwasser_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT sia405_abwasser_2015_2_d.tid_lookup('haltungspunkt', qgep_od.reach_point.obj_id), '0', a.identifier as dataowner, b.identifier as provider, reach_point.last_modification, sia405_abwasser_2015_2_d.tid_lookup('haltungspunkt', qgep_od.reach_point.obj_id)
FROM qgep_od.reach_point
   LEFT JOIN qgep_od.organisation as a ON reach_point.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON reach_point.fk_provider = b.obj_id;

INSERT INTO sia405_abwasser_2015_2_d.abwasserknoten
(
t_id, rueckstaukote, sohlenkote, lage)
SELECT sia405_abwasser_2015_2_d.tid_lookup('abwasserknoten', obj_id), backflow_level, bottom_level,
--situation_geometry
ST_Force2D(situation_geometry)
FROM qgep_od.wastewater_node;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'abwasserknoten'
FROM
   sia405_abwasser_2015_2_d.abwasserknoten a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.haltung
(
t_id, lichte_hoehe, reibungsbeiwert, lagebestimmung, innenschutz, laengeeffektiv, material, verlauf, reliner_material, reliner_nennweite, reliner_bautechnik, reliner_art, ringsteifigkeit, plangefaelle, wandrauhigkeit, vonhaltungspunktref, nachhaltungspunktref, rohrprofilref)
SELECT sia405_abwasser_2015_2_d.tid_lookup('haltung', obj_id), clear_height, coefficient_of_friction,
CASE WHEN horizontal_positioning = 5378 THEN 'genau' ---- 5378  accurate
WHEN horizontal_positioning = 5379 THEN 'unbekannt' ---- 5379  unknown
WHEN horizontal_positioning = 5380 THEN 'ungenau' ---- 5380  inaccurate
END,
CASE WHEN inside_coating = 5383 THEN 'andere' ---- 5383  other
WHEN inside_coating = 248 THEN 'Anstrich_Beschichtung' ---- 248  coating
WHEN inside_coating = 250 THEN 'Kanalklinkerauskleidung' ---- 250  brick_lining
WHEN inside_coating = 251 THEN 'Steinzeugauskleidung' ---- 251  stoneware_lining
WHEN inside_coating = 5384 THEN 'unbekannt' ---- 5384  unknown
WHEN inside_coating = 249 THEN 'Zementmoertelauskleidung' ---- 249  cement_mortar_lining
END, length_effective,
CASE WHEN material = 5381 THEN 'andere' ---- 5381  other
WHEN material = 2754 THEN 'Asbestzement' ---- 2754  asbestos_cement
WHEN material = 3638 THEN 'Beton_Normalbeton' ---- 3638  concrete_normal
WHEN material = 3639 THEN 'Beton_Ortsbeton' ---- 3639  concrete_insitu
WHEN material = 3640 THEN 'Beton_Pressrohrbeton' ---- 3640  concrete_presspipe
WHEN material = 3641 THEN 'Beton_Spezialbeton' ---- 3641  concrete_special
WHEN material = 3256 THEN 'Beton_unbekannt' ---- 3256  concrete_unknown
WHEN material = 147 THEN 'Faserzement' ---- 147  fiber_cement
WHEN material = 2755 THEN 'Gebrannte_Steine' ---- 2755  bricks
WHEN material = 148 THEN 'Guss_duktil' ---- 148  cast_ductile_iron
WHEN material = 3648 THEN 'Guss_Grauguss' ---- 3648  cast_gray_iron
WHEN material = 5076 THEN 'Kunststoff_Epoxydharz' ---- 5076  plastic_epoxy_resin
WHEN material = 5077 THEN 'Kunststoff_Hartpolyethylen' ---- 5077  plastic_highdensity_polyethylene
WHEN material = 5078 THEN 'Kunststoff_Polyester_GUP' ---- 5078  plastic_polyester_GUP
WHEN material = 5079 THEN 'Kunststoff_Polyethylen' ---- 5079  plastic_polyethylene
WHEN material = 5080 THEN 'Kunststoff_Polypropylen' ---- 5080  plastic_polypropylene
WHEN material = 5081 THEN 'Kunststoff_Polyvinilchlorid' ---- 5081  plastic_PVC
WHEN material = 5382 THEN 'Kunststoff_unbekannt' ---- 5382  plastic_unknown
WHEN material = 153 THEN 'Stahl' ---- 153  steel
WHEN material = 3654 THEN 'Stahl_rostfrei' ---- 3654  steel_stainless
WHEN material = 154 THEN 'Steinzeug' ---- 154  stoneware
WHEN material = 2761 THEN 'Ton' ---- 2761  clay
WHEN material = 3016 THEN 'unbekannt' ---- 3016  unknown
WHEN material = 2762 THEN 'Zement' ---- 2762  cement
END,
--progression_geometry,
ST_Force2D(progression_geometry),
CASE WHEN reliner_material = 6459 THEN 'andere' ---- 6459  other
WHEN reliner_material = 6461 THEN 'Epoxidharz_Glasfaserlaminat' ---- 6461  epoxy_resin_glass_fibre_laminate
WHEN reliner_material = 6460 THEN 'Epoxidharz_Kunststofffilz' ---- 6460  epoxy_resin_plastic_felt
WHEN reliner_material = 6483 THEN 'GUP_Rohr' ---- 6483  GUP_pipe
WHEN reliner_material = 6462 THEN 'HDPE' ---- 6462  HDPE
WHEN reliner_material = 6484 THEN 'Isocyanatharze_Glasfaserlaminat' ---- 6484  isocyanate_resin_glass_fibre_laminate
WHEN reliner_material = 6485 THEN 'Isocyanatharze_Kunststofffilz' ---- 6485  isocyanate_resin_plastic_felt
WHEN reliner_material = 6464 THEN 'Polyesterharz_Glasfaserlaminat' ---- 6464  polyester_resin_glass_fibre_laminate
WHEN reliner_material = 6463 THEN 'Polyesterharz_Kunststofffilz' ---- 6463  polyester_resin_plastic_felt
WHEN reliner_material = 6482 THEN 'Polypropylen' ---- 6482  polypropylene
WHEN reliner_material = 6465 THEN 'Polyvinilchlorid' ---- 6465  PVC
WHEN reliner_material = 6466 THEN 'Sohle_mit_Schale_aus_Polyesterbeton' ---- 6466  bottom_with_polyester_concret_shell
WHEN reliner_material = 6467 THEN 'unbekannt' ---- 6467  unknown
WHEN reliner_material = 6486 THEN 'UP_Harz_LED_Synthesefaserliner' ---- 6486  UP_resin_LED_synthetic_fibre_liner
WHEN reliner_material = 6468 THEN 'Vinylesterharz_Glasfaserlaminat' ---- 6468  vinyl_ester_resin_glass_fibre_laminate
WHEN reliner_material = 6469 THEN 'Vinylesterharz_Kunststofffilz' ---- 6469  vinyl_ester_resin_plastic_felt
END, reliner_nominal_size,
CASE WHEN relining_construction = 6448 THEN 'andere' ---- 6448  other
WHEN relining_construction = 6479 THEN 'Close_Fit_Relining' ---- 6479  close_fit_relining
WHEN relining_construction = 6449 THEN 'Kurzrohrrelining' ---- 6449  relining_short_tube
WHEN relining_construction = 6481 THEN 'Noppenschlauchrelining' ---- 6481  grouted_in_place_lining
WHEN relining_construction = 6452 THEN 'Partieller_Liner' ---- 6452  partial_liner
WHEN relining_construction = 6450 THEN 'Rohrstrangrelining' ---- 6450  pipe_string_relining
WHEN relining_construction = 6451 THEN 'Schlauchrelining' ---- 6451  hose_relining
WHEN relining_construction = 6453 THEN 'unbekannt' ---- 6453  unknown
WHEN relining_construction = 6480 THEN 'Wickelrohrrelining' ---- 6480  spiral_lining
END,
CASE WHEN relining_kind = 6455 THEN 'ganze_Haltung' ---- 6455  full_reach
WHEN relining_kind = 6456 THEN 'partiell' ---- 6456  partial
WHEN relining_kind = 6457 THEN 'unbekannt' ---- 6457  unknown
END, ring_stiffness, slope_building_plan, wall_roughness, sia405_abwasser_2015_2_d.tid_lookup('Haltungspunkt', fk_reach_point_from), sia405_abwasser_2015_2_d.tid_lookup('Haltungspunkt', fk_reach_point_to), sia405_abwasser_2015_2_d.tid_lookup('Rohrprofil', fk_pipe_profile)
FROM qgep_od.reach;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'haltung'
FROM
   sia405_abwasser_2015_2_d.haltung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.bauwerksteil
(
t_id, bezeichnung, bemerkung, instandstellung, abwasserbauwerkref)
SELECT sia405_abwasser_2015_2_d.tid_lookup('bauwerksteil', obj_id), identifier, remark,
CASE WHEN renovation_demand = 138 THEN 'nicht_notwendig' ---- 138  not_necessary
WHEN renovation_demand = 137 THEN 'notwendig' ---- 137  necessary
WHEN renovation_demand = 5358 THEN 'unbekannt' ---- 5358  unknown
END, sia405_abwasser_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure)
FROM qgep_od.structure_part;

INSERT INTO sia405_abwasser_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT sia405_abwasser_2015_2_d.tid_lookup('bauwerksteil', qgep_od.structure_part.obj_id), '0', a.identifier as dataowner, b.identifier as provider, structure_part.last_modification, sia405_abwasser_2015_2_d.tid_lookup('bauwerksteil', qgep_od.structure_part.obj_id)
FROM qgep_od.structure_part
   LEFT JOIN qgep_od.organisation as a ON structure_part.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON structure_part.fk_provider = b.obj_id;

INSERT INTO sia405_abwasser_2015_2_d.trockenwetterfallrohr
(
t_id, durchmesser)
SELECT sia405_abwasser_2015_2_d.tid_lookup('trockenwetterfallrohr', obj_id), diameter
FROM qgep_od.dryweather_downspout;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'trockenwetterfallrohr'
FROM
   sia405_abwasser_2015_2_d.trockenwetterfallrohr a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.einstiegshilfe
(
t_id, art)
SELECT sia405_abwasser_2015_2_d.tid_lookup('einstiegshilfe', obj_id),
CASE WHEN kind = 5357 THEN 'andere' ---- 5357  other
WHEN kind = 243 THEN 'Drucktuere' ---- 243  pressurized_door
WHEN kind = 92 THEN 'keine' ---- 92  none
WHEN kind = 240 THEN 'Leiter' ---- 240  ladder
WHEN kind = 241 THEN 'Steigeisen' ---- 241  step_iron
WHEN kind = 3473 THEN 'Treppe' ---- 3473  staircase
WHEN kind = 91 THEN 'Trittnischen' ---- 91  footstep_niches
WHEN kind = 3230 THEN 'Tuere' ---- 3230  door
WHEN kind = 3048 THEN 'unbekannt' ---- 3048  unknown
END
FROM qgep_od.access_aid;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'einstiegshilfe'
FROM
   sia405_abwasser_2015_2_d.einstiegshilfe a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.trockenwetterrinne
(
t_id, material)
SELECT sia405_abwasser_2015_2_d.tid_lookup('trockenwetterrinne', obj_id),
CASE WHEN material = 3221 THEN 'andere' ---- 3221  other
WHEN material = 354 THEN 'kombiniert' ---- 354  combined
WHEN material = 5356 THEN 'Kunststoff' ---- 5356  plastic
WHEN material = 238 THEN 'Steinzeug' ---- 238  stoneware
WHEN material = 3017 THEN 'unbekannt' ---- 3017  unknown
WHEN material = 237 THEN 'Zementmoertel' ---- 237  cement_mortar
END
FROM qgep_od.dryweather_flume;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'trockenwetterrinne'
FROM
   sia405_abwasser_2015_2_d.trockenwetterrinne a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.deckel
(
t_id, fabrikat, deckelform, durchmesser, verschluss, kote, material, lagegenauigkeit, lage, schlammeimer, entlueftung)
SELECT sia405_abwasser_2015_2_d.tid_lookup('deckel', obj_id), brand,
CASE WHEN cover_shape = 5353 THEN 'andere' ---- 5353  other
WHEN cover_shape = 3499 THEN 'eckig' ---- 3499  rectangular
WHEN cover_shape = 3498 THEN 'rund' ---- 3498  round
WHEN cover_shape = 5354 THEN 'unbekannt' ---- 5354  unknown
END, diameter,
CASE WHEN fastening = 5350 THEN 'nicht_verschraubt' ---- 5350  not_bolted
WHEN fastening = 5351 THEN 'unbekannt' ---- 5351  unknown
WHEN fastening = 5352 THEN 'verschraubt' ---- 5352  bolted
END, level,
CASE WHEN material = 5355 THEN 'andere' ---- 5355  other
WHEN material = 234 THEN 'Beton' ---- 234  concrete
WHEN material = 233 THEN 'Guss' ---- 233  cast_iron
WHEN material = 5547 THEN 'Guss_mit_Belagsfuellung' ---- 5547  cast_iron_with_pavement_filling
WHEN material = 235 THEN 'Guss_mit_Betonfuellung' ---- 235  cast_iron_with_concrete_filling
WHEN material = 3015 THEN 'unbekannt' ---- 3015  unknown
END,
CASE WHEN positional_accuracy = 3243 THEN 'groesser_50cm' ---- 3243  more_than_50cm
WHEN positional_accuracy = 3241 THEN 'plusminus_10cm' ---- 3241  plusminus_10cm
WHEN positional_accuracy = 3236 THEN 'plusminus_3cm' ---- 3236  plusminus_3cm
WHEN positional_accuracy = 3242 THEN 'plusminus_50cm' ---- 3242  plusminus_50cm
WHEN positional_accuracy = 5349 THEN 'unbekannt' ---- 5349  unknown
END,
--situation_geometry,
ST_Force2D(situation_geometry),
CASE WHEN sludge_bucket = 423 THEN 'nicht_vorhanden' ---- 423  inexistent
WHEN sludge_bucket = 3066 THEN 'unbekannt' ---- 3066  unknown
WHEN sludge_bucket = 422 THEN 'vorhanden' ---- 422  existent
END,
CASE WHEN venting = 229 THEN 'entlueftet' ---- 229  vented
WHEN venting = 230 THEN 'nicht_entlueftet' ---- 230  not_vented
WHEN venting = 5348 THEN 'unbekannt' ---- 5348  unknown
END
FROM qgep_od.cover;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'deckel'
FROM
   sia405_abwasser_2015_2_d.deckel a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO sia405_abwasser_2015_2_d.bankett
(
t_id, art)
SELECT sia405_abwasser_2015_2_d.tid_lookup('bankett', obj_id),
CASE WHEN kind = 5319 THEN 'andere' ---- 5319  other
WHEN kind = 94 THEN 'beidseitig' ---- 94  double_sided
WHEN kind = 93 THEN 'einseitig' ---- 93  one_sided
WHEN kind = 3231 THEN 'kein' ---- 3231  none
WHEN kind = 3033 THEN 'unbekannt' ---- 3033  unknown
END
FROM qgep_od.benching;

UPDATE sia405_abwasser_2015_2_d.baseclass SET t_type = 'bankett'
FROM
   sia405_abwasser_2015_2_d.bankett a
WHERE
   baseclass.t_id =  a.t_id;
