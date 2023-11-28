------ This file is sql code to Import INTERLIS (Modul SIA405Abwasser) in German to QGEP in Englisch on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 22.02.2017 21:04:50 / 11.7.2019 adapted to new schema
-- 12.7.2019 - datenlieferant / datenherr angepasst
-- Datenherr, datenlieferant
-- abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
-- abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)

-- 1. loeschen vorhandener daten
DELETE FROM qgep_od.organisation;
DELETE FROM qgep_od.wastewater_structure;
DELETE FROM qgep_od.wastewater_structure_text;
DELETE FROM qgep_od.wastewater_structure_symbol;
DELETE FROM qgep_od.channel;
DELETE FROM qgep_od.manhole;
DELETE FROM qgep_od.discharge_point;
DELETE FROM qgep_od.special_structure;
DELETE FROM qgep_od.infiltration_installation;
DELETE FROM qgep_od.pipe_profile;
DELETE FROM qgep_od.wastewater_networkelement;
DELETE FROM qgep_od.reach_point;
DELETE FROM qgep_od.wastewater_node;
DELETE FROM qgep_od.reach;
DELETE FROM qgep_od.reach_text;
DELETE FROM qgep_od.structure_part;
DELETE FROM qgep_od.dryweather_downspout;
DELETE FROM qgep_od.access_aid;
DELETE FROM qgep_od.dryweather_flume;
DELETE FROM qgep_od.cover;
DELETE FROM qgep_od.benching;


-- 2. kopieren von ili2pg schema nach qgep schema - klasse organisation zuerst, da neu auch verknüpft mit datenherr / datenlieferant

INSERT INTO qgep_od.organisation
(
obj_id, identifier, remark, uid, last_modification, fk_dataowner, fk_provider)
SELECT obj_id, bezeichnung, bemerkung, uid, Letzte_Aenderung, Datenherr, datenlieferant
--falls nicht schon umgesetzt als OBJ_ID
--abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
--abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)
FROM abwa_2015neu_3122.Organisation
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Organisation.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.wastewater_structure
(
obj_id, accessibility, contract_section, detail_geometry_geometry, financing, gross_costs, identifier, inspection_interval, location_name, records, remark, renovation_necessity, replacement_value, rv_base_year, rv_construction_type, status, structure_condition, subsidies, year_of_construction, year_of_replacement, fk_owner, fk_operator, last_modification, fk_dataowner, fk_provider)
SELECT obj_id,
CASE WHEN Zugaenglichkeit = 'ueberdeckt' THEN 3444 ---- 3444  covered
WHEN Zugaenglichkeit = 'unbekannt' THEN 3447 ---- 3447  unknown
WHEN Zugaenglichkeit = 'unzugaenglich' THEN 3446 ---- 3446  inaccessible
WHEN Zugaenglichkeit = 'zugaenglich' THEN 3445 ---- 3445  accessible
END AS Zugaenglichkeit, baulos, ST_Force3D(detailgeometrie),
CASE WHEN Finanzierung = 'oeffentlich' THEN 5510 ---- 5510  public
WHEN Finanzierung = 'privat' THEN 5511 ---- 5511  private
WHEN Finanzierung = 'unbekannt' THEN 5512 ---- 5512  unknown
END AS Finanzierung, bruttokosten, bezeichnung, inspektionsintervall, standortname, akten, bemerkung,
CASE WHEN Sanierungsbedarf = 'dringend' THEN 5370 ---- 5370  urgent
WHEN Sanierungsbedarf = 'keiner' THEN 5368 ---- 5368  none
WHEN Sanierungsbedarf = 'kurzfristig' THEN 2 ---- 2  short_term
WHEN Sanierungsbedarf = 'langfristig' THEN 4 ---- 4  long_term
WHEN Sanierungsbedarf = 'mittelfristig' THEN 3 ---- 3  medium_term
WHEN Sanierungsbedarf = 'unbekannt' THEN 5369 ---- 5369  unknown
END AS Sanierungsbedarf, wiederbeschaffungswert, wbw_basisjahr,
CASE WHEN WBW_Bauart = 'andere' THEN 4602 ---- 4602  other
WHEN WBW_Bauart = 'Feld' THEN 4603 ---- 4603  field
WHEN WBW_Bauart = 'Sanierungsleitung_Bagger' THEN 4606 ---- 4606  renovation_conduction_excavator
WHEN WBW_Bauart = 'Sanierungsleitung_Grabenfraese' THEN 4605 ---- 4605  renovation_conduction_ditch_cutter
WHEN WBW_Bauart = 'Strasse' THEN 4604 ---- 4604  road
WHEN WBW_Bauart = 'unbekannt' THEN 4601 ---- 4601  unknown
END AS WBW_Bauart,
CASE WHEN Status = 'ausser_Betrieb' THEN 3633 ---- 3633  inoperative
WHEN Status = 'in_Betrieb' THEN 8493 ---- 8493  operational
WHEN Status = 'in_Betrieb.provisorisch' THEN 6530 ---- 6530  operational.tentative
WHEN Status = 'in_Betrieb.wird_aufgehoben' THEN 6533 ---- 6533  operational.will_be_suspended
WHEN Status = 'tot.aufgehoben_nicht_verfuellt' THEN 6523 ---- 6523  abanndoned.suspended_not_filled
WHEN Status = 'tot.aufgehoben_unbekannt' THEN 6524 ---- 6524  abanndoned.suspended_unknown
WHEN Status = 'tot.verfuellt' THEN 6532 ---- 6532  abanndoned.filled
WHEN Status = 'unbekannt' THEN 3027 ---- 3027  unknown
WHEN Status = 'weitere.Berechnungsvariante' THEN 6526 ---- 6526  other.calculation_alternative
WHEN Status = 'weitere.geplant' THEN 7959 ---- 7959  other.planned
WHEN Status = 'weitere.Projekt' THEN 6529 ---- 6529  other.project
END AS Status,
CASE WHEN BaulicherZustand = 'unbekannt' THEN 3037 ---- 3037  unknown
WHEN BaulicherZustand = 'Z0' THEN 3363 ---- 3363  Z0
WHEN BaulicherZustand = 'Z1' THEN 3359 ---- 3359  Z1
WHEN BaulicherZustand = 'Z2' THEN 3360 ---- 3360  Z2
WHEN BaulicherZustand = 'Z3' THEN 3361 ---- 3361  Z3
WHEN BaulicherZustand = 'Z4' THEN 3362 ---- 3362  Z4
END AS BaulicherZustand, subventionen, baujahr, ersatzjahr, abwa_2015neu_3122.objid_lookup('Organisation', eigentuemerref::int), abwa_2015neu_3122.objid_lookup('Organisation', betreiberref::int), Letzte_Aenderung,
--Datenherr, datenlieferant
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)
FROM abwa_2015neu_3122.Abwasserbauwerk
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Abwasserbauwerk.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.wastewater_structure_text
(
obj_id, fk_wastewater_structure, plantype, text, remark, textori, texthali, textvali, textpos_geometry, last_modification)
SELECT
--abwa_2015neu_3122.objid_lookup('Abwasserbauwerk', Abwasserbauwerkref::int) as obj_id,
qgep_sys.generate_oid('qgep_od','txt_text'),
abwa_2015neu_3122.objid_lookup('Abwasserbauwerk', abwasserbauwerkref::int) as abwasserbauwerkref,
CASE WHEN a.Plantyp = 'Leitungskataster' THEN 7844 ---- 7844  pipeline_registry
WHEN a.Plantyp = 'Uebersichtsplan.UeP10' THEN 7846 ---- 7846  overviewmap.om10
WHEN a.Plantyp = 'Uebersichtsplan.UeP2' THEN 7847 ---- 7847  overviewmap.om2
WHEN a.Plantyp = 'Uebersichtsplan.UeP5' THEN 7848 ---- 7848  overviewmap.om5
WHEN a.Plantyp = 'Werkplan' THEN 7845 ---- 7845  network_plan
END AS Plantyp,
a.textinhalt, a.bemerkung,
b.textori,
CASE WHEN b.textvali = 'TOP' THEN 0
WHEN b.textvali = 'CAP' THEN 1
WHEN b.textvali = 'HALF' THEN 2
WHEN b.textvali = 'BASE' THEN 3
END AS textvali,
CASE WHEN b.texthali = 'LEFT' THEN 0
WHEN b.texthali = 'CENTER' THEN 1
WHEN b.texthali = 'RIGHT' THEN 2
END AS texthali,
--ST_FORCE3D(b.textpos),
(b.textpos),
Letzte_Aenderung
FROM abwa_2015neu_3122.Abwasserbauwerk_text
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Abwasserbauwerk_text.t_id = vw_sia405_baseclass_metaattribute.t_id
    LEFT JOIN abwa_2015neu_3122.sia405_textpos as a ON abwa_2015neu_3122.Abwasserbauwerk_text.t_id = a.t_id
    LEFT JOIN abwa_2015neu_3122.textpos as b ON abwa_2015neu_3122.Abwasserbauwerk_text.t_id = b.t_id;

INSERT INTO qgep_od.wastewater_structure_symbol
(
obj_id, fk_wastewater_structure, plantype, symbol_scaling_heigth, symbol_scaling_width, symbolori, symbolpos_geometry, last_modification)
SELECT
--abwa_2015neu_3122.objid_lookup('Abwasserbauwerk', Abwasserbauwerkref::int) as obj_id,
qgep_sys.generate_oid('qgep_od','txt_symbol'),
abwa_2015neu_3122.objid_lookup('Abwasserbauwerk', abwasserbauwerkref::int) as abwasserbauwerkref,
CASE WHEN a.Plantyp = 'Leitungskataster' THEN 7874 ---- 7874  pipeline_registry
WHEN a.Plantyp = 'Uebersichtsplan.UeP10' THEN 7876 ---- 7876  overviewmap.om10
WHEN a.Plantyp = 'Uebersichtsplan.UeP2' THEN 7877 ---- 7877  overviewmap.om2
WHEN a.Plantyp = 'Uebersichtsplan.UeP5' THEN 7878 ---- 7878  overviewmap.om5
WHEN a.Plantyp = 'Werkplan' THEN 7875 ---- 7875  network_plan
END AS Plantyp,
a.symbolskalierunghoch, a.symbolskalierunglaengs,
b.symbolori,
ST_Force3D(b.symbolpos),
Letzte_Aenderung
FROM abwa_2015neu_3122.Abwasserbauwerk_symbol
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Abwasserbauwerk_symbol.t_id = vw_sia405_baseclass_metaattribute.t_id
    LEFT JOIN abwa_2015neu_3122.sia405_symbolpos as a ON abwa_2015neu_3122.Abwasserbauwerk_symbol.t_id = a.t_id
    LEFT JOIN abwa_2015neu_3122.symbolpos as b ON abwa_2015neu_3122.Abwasserbauwerk_symbol.t_id = b.t_id;

INSERT INTO qgep_od.channel
(
obj_id, bedding_encasement, connection_type, function_hierarchic, function_hydraulic, jetting_interval, pipe_length, usage_current, usage_planned)
SELECT obj_id,
CASE WHEN Bettung_Umhuellung = 'andere' THEN 5325 ---- 5325  other
WHEN Bettung_Umhuellung = 'erdverlegt' THEN 5332 ---- 5332  in_soil
WHEN Bettung_Umhuellung = 'in_Kanal_aufgehaengt' THEN 5328 ---- 5328  in_channel_suspended
WHEN Bettung_Umhuellung = 'in_Kanal_einbetoniert' THEN 5339 ---- 5339  in_channel_concrete_casted
WHEN Bettung_Umhuellung = 'in_Leitungsgang' THEN 5331 ---- 5331  in_walk_in_passage
WHEN Bettung_Umhuellung = 'in_Vortriebsrohr_Beton' THEN 5337 ---- 5337  in_jacking_pipe_concrete
WHEN Bettung_Umhuellung = 'in_Vortriebsrohr_Stahl' THEN 5336 ---- 5336  in_jacking_pipe_steel
WHEN Bettung_Umhuellung = 'Sand' THEN 5335 ---- 5335  sand
WHEN Bettung_Umhuellung = 'SIA_Typ1' THEN 5333 ---- 5333  sia_type_1
WHEN Bettung_Umhuellung = 'SIA_Typ2' THEN 5330 ---- 5330  sia_type_2
WHEN Bettung_Umhuellung = 'SIA_Typ3' THEN 5334 ---- 5334  sia_type_3
WHEN Bettung_Umhuellung = 'SIA_Typ4' THEN 5340 ---- 5340  sia_type_4
WHEN Bettung_Umhuellung = 'Sohlbrett' THEN 5327 ---- 5327  bed_plank
WHEN Bettung_Umhuellung = 'unbekannt' THEN 5329 ---- 5329  unknown
END AS Bettung_Umhuellung,
CASE WHEN Verbindungsart = 'andere' THEN 5341 ---- 5341  other
WHEN Verbindungsart = 'Elektroschweissmuffen' THEN 190 ---- 190  electric_welded_sleeves
WHEN Verbindungsart = 'Flachmuffen' THEN 187 ---- 187  flat_sleeves
WHEN Verbindungsart = 'Flansch' THEN 193 ---- 193  flange
WHEN Verbindungsart = 'Glockenmuffen' THEN 185 ---- 185  bell_shaped_sleeves
WHEN Verbindungsart = 'Kupplung' THEN 192 ---- 192  coupling
WHEN Verbindungsart = 'Schraubmuffen' THEN 194 ---- 194  screwed_sleeves
WHEN Verbindungsart = 'spiegelgeschweisst' THEN 189 ---- 189  butt_welded
WHEN Verbindungsart = 'Spitzmuffen' THEN 186 ---- 186  beaked_sleeves
WHEN Verbindungsart = 'Steckmuffen' THEN 191 ---- 191  push_fit_sleeves
WHEN Verbindungsart = 'Ueberschiebmuffen' THEN 188 ---- 188  slip_on_sleeves
WHEN Verbindungsart = 'unbekannt' THEN 3036 ---- 3036  unknown
WHEN Verbindungsart = 'Vortriebsrohrkupplung' THEN 3666 ---- 3666  jacking_pipe_coupling
END AS Verbindungsart,
CASE WHEN FunktionHierarchisch = 'PAA.andere' THEN 5066 ---- 5066  pwwf.other
WHEN FunktionHierarchisch = 'PAA.Gewaesser' THEN 5068 ---- 5068  pwwf.water_bodies
WHEN FunktionHierarchisch = 'PAA.Hauptsammelkanal' THEN 5069 ---- 5069  pwwf.main_drain
WHEN FunktionHierarchisch = 'PAA.Hauptsammelkanal_regional' THEN 5070 ---- 5070  pwwf.main_drain_regional
WHEN FunktionHierarchisch = 'PAA.Liegenschaftsentwaesserung' THEN 5064 ---- 5064  pwwf.residential_drainage
WHEN FunktionHierarchisch = 'PAA.Sammelkanal' THEN 5071 ---- 5071  pwwf.collector_sewer
WHEN FunktionHierarchisch = 'PAA.Sanierungsleitung' THEN 5062 ---- 5062  pwwf.renovation_conduction
WHEN FunktionHierarchisch = 'PAA.Strassenentwaesserung' THEN 5072 ---- 5072  pwwf.road_drainage
WHEN FunktionHierarchisch = 'PAA.unbekannt' THEN 5074 ---- 5074  pwwf.unknown
WHEN FunktionHierarchisch = 'SAA.andere' THEN 5067 ---- 5067  swwf.other
WHEN FunktionHierarchisch = 'SAA.Liegenschaftsentwaesserung' THEN 5065 ---- 5065  swwf.residential_drainage
WHEN FunktionHierarchisch = 'SAA.Sanierungsleitung' THEN 5063 ---- 5063  swwf.renovation_conduction
WHEN FunktionHierarchisch = 'SAA.Strassenentwaesserung' THEN 5073 ---- 5073  swwf.road_drainage
WHEN FunktionHierarchisch = 'SAA.unbekannt' THEN 5075 ---- 5075  swwf.unknown
END AS FunktionHierarchisch,
CASE WHEN FunktionHydraulisch = 'andere' THEN 5320 ---- 5320  other
WHEN FunktionHydraulisch = 'Drainagetransportleitung' THEN 2546 ---- 2546  drainage_transportation_pipe
WHEN FunktionHydraulisch = 'Drosselleitung' THEN 22 ---- 22  restriction_pipe
WHEN FunktionHydraulisch = 'Duekerleitung' THEN 3610 ---- 3610  inverted_syphon
WHEN FunktionHydraulisch = 'Freispiegelleitung' THEN 367 ---- 367  gravity_pipe
WHEN FunktionHydraulisch = 'Pumpendruckleitung' THEN 23 ---- 23  pump_pressure_pipe
WHEN FunktionHydraulisch = 'Sickerleitung' THEN 145 ---- 145  seepage_water_drain
WHEN FunktionHydraulisch = 'Speicherleitung' THEN 21 ---- 21  retention_pipe
WHEN FunktionHydraulisch = 'Spuelleitung' THEN 144 ---- 144  jetting_pipe
WHEN FunktionHydraulisch = 'unbekannt' THEN 5321 ---- 5321  unknown
WHEN FunktionHydraulisch = 'Vakuumleitung' THEN 3655 ---- 3655  vacuum_pipe
END AS FunktionHydraulisch, spuelintervall, rohrlaenge,
CASE WHEN Nutzungsart_Ist = 'andere' THEN 5322 ---- 5322  other
WHEN Nutzungsart_Ist = 'Bachwasser' THEN 4518 ---- 4518  creek_water
WHEN Nutzungsart_Ist = 'entlastetes_Mischabwasser' THEN 4516 ---- 4516  discharged_combined_wastewater
WHEN Nutzungsart_Ist = 'Industrieabwasser' THEN 4524 ---- 4524  industrial_wastewater
WHEN Nutzungsart_Ist = 'Mischabwasser' THEN 4522 ---- 4522  combined_wastewater
WHEN Nutzungsart_Ist = 'Regenabwasser' THEN 4520 ---- 4520  rain_wastewater
WHEN Nutzungsart_Ist = 'Reinabwasser' THEN 4514 ---- 4514  clean_wastewater
WHEN Nutzungsart_Ist = 'Schmutzabwasser' THEN 4526 ---- 4526  wastewater
WHEN Nutzungsart_Ist = 'unbekannt' THEN 4571 ---- 4571  unknown
END AS Nutzungsart_Ist,
CASE WHEN Nutzungsart_geplant = 'andere' THEN 5323 ---- 5323  other
WHEN Nutzungsart_geplant = 'Bachwasser' THEN 4519 ---- 4519  creek_water
WHEN Nutzungsart_geplant = 'entlastetes_Mischabwasser' THEN 4517 ---- 4517  discharged_combined_wastewater
WHEN Nutzungsart_geplant = 'Industrieabwasser' THEN 4525 ---- 4525  industrial_wastewater
WHEN Nutzungsart_geplant = 'Mischabwasser' THEN 4523 ---- 4523  combined_wastewater
WHEN Nutzungsart_geplant = 'Regenabwasser' THEN 4521 ---- 4521  rain_wastewater
WHEN Nutzungsart_geplant = 'Reinabwasser' THEN 4515 ---- 4515  clean_wastewater
WHEN Nutzungsart_geplant = 'Schmutzabwasser' THEN 4527 ---- 4527  wastewater
WHEN Nutzungsart_geplant = 'unbekannt' THEN 4569 ---- 4569  unknown
END AS Nutzungsart_geplant
FROM abwa_2015neu_3122.Kanal
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Kanal.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.manhole
(
obj_id, dimension1, dimension2, function, material, surface_inflow)
SELECT obj_id, dimension1, dimension2,
CASE WHEN Funktion = 'Absturzbauwerk' THEN 4532 ---- 4532  drop_structure
WHEN Funktion = 'andere' THEN 5344 ---- 5344  other
WHEN Funktion = 'Be_Entlueftung' THEN 4533 ---- 4533  venting
WHEN Funktion = 'Dachwasserschacht' THEN 3267 ---- 3267  rain_water_manhole
WHEN Funktion = 'Einlaufschacht' THEN 3266 ---- 3266  gully
WHEN Funktion = 'Entwaesserungsrinne' THEN 3472 ---- 3472  drainage_channel
WHEN Funktion = 'Geleiseschacht' THEN 228 ---- 228  rail_track_gully
WHEN Funktion = 'Kontrollschacht' THEN 204 ---- 204  manhole
WHEN Funktion = 'Oelabscheider' THEN 1008 ---- 1008  oil_separator
WHEN Funktion = 'Pumpwerk' THEN 4536 ---- 4536  pump_station
WHEN Funktion = 'Regenueberlauf' THEN 5346 ---- 5346  stormwater_overflow
WHEN Funktion = 'Schlammsammler' THEN 2742 ---- 2742  slurry_collector
WHEN Funktion = 'Schwimmstoffabscheider' THEN 5347 ---- 5347  floating_material_separator
WHEN Funktion = 'Spuelschacht' THEN 4537 ---- 4537  jetting_manhole
WHEN Funktion = 'Trennbauwerk' THEN 4798 ---- 4798  separating_structure
WHEN Funktion = 'unbekannt' THEN 5345 ---- 5345  unknown
END AS Funktion,
CASE WHEN Material = 'andere' THEN 4540 ---- 4540  other
WHEN Material = 'Beton' THEN 4541 ---- 4541  concrete
WHEN Material = 'Kunststoff' THEN 4542 ---- 4542  plastic
WHEN Material = 'unbekannt' THEN 4543 ---- 4543  unknown
END AS Material,
CASE WHEN Oberflaechenzulauf = 'andere' THEN 5342 ---- 5342  other
WHEN Oberflaechenzulauf = 'keiner' THEN 2741 ---- 2741  none
WHEN Oberflaechenzulauf = 'Rost' THEN 2739 ---- 2739  grid
WHEN Oberflaechenzulauf = 'unbekannt' THEN 5343 ---- 5343  unknown
WHEN Oberflaechenzulauf = 'Zulauf_seitlich' THEN 2740 ---- 2740  intake_from_side
END AS Oberflaechenzulauf
FROM abwa_2015neu_3122.Normschacht
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Normschacht.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.discharge_point
(
obj_id, highwater_level, relevance, terrain_level, waterlevel_hydraulic
-- fuer sia405 auskommentiert
-- , fk_sector_water_body
)
SELECT obj_id, hochwasserkote,
CASE WHEN Relevanz = 'gewaesserrelevant' THEN 5580 ---- 5580  relevant_for_water_course
WHEN Relevanz = 'nicht_gewaesserrelevant' THEN 5581 ---- 5581  non_relevant_for_water_course
END AS Relevanz, terrainkote, wasserspiegel_hydraulik
-- fuer sia405 auskommentiert
-- , abwa_2015neu_3122.objid_lookup('Gewaessersektor', gewaessersektorref::int)
FROM abwa_2015neu_3122.Einleitstelle
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Einleitstelle.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.special_structure
(
obj_id, bypass, emergency_spillway, function, stormwater_tank_arrangement)
SELECT obj_id,
CASE WHEN Bypass = 'nicht_vorhanden' THEN 2682 ---- 2682  inexistent
WHEN Bypass = 'unbekannt' THEN 3055 ---- 3055  unknown
WHEN Bypass = 'vorhanden' THEN 2681 ---- 2681  existent
END AS Bypass,
CASE WHEN Notueberlauf = 'andere' THEN 5866 ---- 5866  other
WHEN Notueberlauf = 'inMischabwasserkanalisation' THEN 5864 ---- 5864  in_combined_waste_water_drain
WHEN Notueberlauf = 'inRegenabwasserkanalisation' THEN 5865 ---- 5865  in_rain_waste_water_drain
WHEN Notueberlauf = 'inSchmutzabwasserkanalisation' THEN 5863 ---- 5863  in_waste_water_drain
WHEN Notueberlauf = 'keiner' THEN 5878 ---- 5878  none
WHEN Notueberlauf = 'unbekannt' THEN 5867 ---- 5867  unknown
END AS Notueberlauf,
CASE WHEN Funktion = 'abflussloseGrube' THEN 6397 ---- 6397  pit_without_drain
WHEN Funktion = 'Absturzbauwerk' THEN 245 ---- 245  drop_structure
WHEN Funktion = 'Abwasserfaulraum' THEN 6398 ---- 6398  hydrolizing_tank
WHEN Funktion = 'andere' THEN 5371 ---- 5371  other
WHEN Funktion = 'Be_Entlueftung' THEN 386 ---- 386  venting
WHEN Funktion = 'Duekerkammer' THEN 3234 ---- 3234  inverse_syphon_chamber
WHEN Funktion = 'Duekeroberhaupt' THEN 5091 ---- 5091  syphon_head
WHEN Funktion = 'Faulgrube' THEN 6399 ---- 6399  septic_tank_two_chambers
WHEN Funktion = 'Gelaendemulde' THEN 3348 ---- 3348  terrain_depression
WHEN Funktion = 'Geschiebefang' THEN 336 ---- 336  bolders_bedload_catchement_dam
WHEN Funktion = 'Guellegrube' THEN 5494 ---- 5494  cesspit
WHEN Funktion = 'Klaergrube' THEN 6478 ---- 6478  septic_tank
WHEN Funktion = 'Kontrollschacht' THEN 2998 ---- 2998  manhole
WHEN Funktion = 'Oelabscheider' THEN 2768 ---- 2768  oil_separator
WHEN Funktion = 'Pumpwerk' THEN 246 ---- 246  pump_station
WHEN Funktion = 'Regenbecken_Durchlaufbecken' THEN 3673 ---- 3673  stormwater_tank_with_overflow
WHEN Funktion = 'Regenbecken_Fangbecken' THEN 3674 ---- 3674  stormwater_tank_retaining_first_flush
WHEN Funktion = 'Regenbecken_Fangkanal' THEN 5574 ---- 5574  stormwater_retaining_channel
WHEN Funktion = 'Regenbecken_Regenklaerbecken' THEN 3675 ---- 3675  stormwater_sedimentation_tank
WHEN Funktion = 'Regenbecken_Regenrueckhaltebecken' THEN 3676 ---- 3676  stormwater_retention_tank
WHEN Funktion = 'Regenbecken_Regenrueckhaltekanal' THEN 5575 ---- 5575  stormwater_retention_channel
WHEN Funktion = 'Regenbecken_Stauraumkanal' THEN 5576 ---- 5576  stormwater_storage_channel
WHEN Funktion = 'Regenbecken_Verbundbecken' THEN 3677 ---- 3677  stormwater_composite_tank
WHEN Funktion = 'Regenueberlauf' THEN 5372 ---- 5372  stormwater_overflow
WHEN Funktion = 'Schwimmstoffabscheider' THEN 5373 ---- 5373  floating_material_separator
WHEN Funktion = 'seitlicherZugang' THEN 383 ---- 383  side_access
WHEN Funktion = 'Spuelschacht' THEN 227 ---- 227  jetting_manhole
WHEN Funktion = 'Trennbauwerk' THEN 4799 ---- 4799  separating_structure
WHEN Funktion = 'unbekannt' THEN 3008 ---- 3008  unknown
WHEN Funktion = 'Wirbelfallschacht' THEN 2745 ---- 2745  vortex_manhole
END AS Funktion,
CASE WHEN Regenbecken_Anordnung = 'Hauptschluss' THEN 4608 ---- 4608  main_connection
WHEN Regenbecken_Anordnung = 'Nebenschluss' THEN 4609 ---- 4609  side_connection
WHEN Regenbecken_Anordnung = 'unbekannt' THEN 4610 ---- 4610  unknown
END AS Regenbecken_Anordnung
FROM abwa_2015neu_3122.Spezialbauwerk
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Spezialbauwerk.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.infiltration_installation
(
obj_id, absorption_capacity, defects, dimension1, dimension2, distance_to_aquifer, effective_area, emergency_spillway, kind, labeling, seepage_utilization, vehicle_access, watertightness
-- fuer sia405 auskommentiert
--, fk_aquifier
)
SELECT obj_id, schluckvermoegen,
CASE WHEN Maengel = 'keine' THEN 5361 ---- 5361  none
WHEN Maengel = 'unwesentliche' THEN 3276 ---- 3276  marginal
WHEN Maengel = 'wesentliche' THEN 3275 ---- 3275  substantial
END AS Maengel, dimension1, dimension2, gwdistanz, wirksameflaeche,
CASE WHEN Notueberlauf = 'inMischwasserkanalisation' THEN 5365 ---- 5365  in_combined_waste_water_drain
WHEN Notueberlauf = 'inRegenwasserkanalisation' THEN 3307 ---- 3307  in_rain_waste_water_drain
WHEN Notueberlauf = 'inVorfluter' THEN 3304 ---- 3304  in_water_body
WHEN Notueberlauf = 'keiner' THEN 3303 ---- 3303  none
WHEN Notueberlauf = 'oberflaechlichausmuendend' THEN 3305 ---- 3305  surface_discharge
WHEN Notueberlauf = 'unbekannt' THEN 3308 ---- 3308  unknown
END AS Notueberlauf,
CASE WHEN Art = 'andere_mit_Bodenpassage' THEN 3282 ---- 3282  with_soil_passage
WHEN Art = 'andere_ohne_Bodenpassage' THEN 3285 ---- 3285  without_soil_passage
WHEN Art = 'Flaechenfoermige_Versickerung' THEN 3279 ---- 3279  surface_infiltration
WHEN Art = 'Kieskoerper' THEN 277 ---- 277  gravel_formation
WHEN Art = 'Kombination_Schacht_Strang' THEN 3284 ---- 3284  combination_manhole_pipe
WHEN Art = 'MuldenRigolenversickerung' THEN 3281 ---- 3281  swale_french_drain_infiltration
WHEN Art = 'unbekannt' THEN 3087 ---- 3087  unknown
WHEN Art = 'Versickerung_ueber_die_Schulter' THEN 3280 ---- 3280  percolation_over_the_shoulder
WHEN Art = 'Versickerungsbecken' THEN 276 ---- 276  infiltration_basin
WHEN Art = 'Versickerungsschacht' THEN 278 ---- 278  adsorbing_well
WHEN Art = 'Versickerungsstrang_Galerie' THEN 3283 ---- 3283  infiltration_pipe_sections_gallery
END AS Art,
CASE WHEN Beschriftung = 'beschriftet' THEN 5362 ---- 5362  labeled
WHEN Beschriftung = 'nichtbeschriftet' THEN 5363 ---- 5363  not_labeled
WHEN Beschriftung = 'unbekannt' THEN 5364 ---- 5364  unknown
END AS Beschriftung,
CASE WHEN Versickerungswasser = 'Regenabwasser' THEN 274 ---- 274  rain_water
WHEN Versickerungswasser = 'Reinabwasser' THEN 273 ---- 273  clean_water
WHEN Versickerungswasser = 'unbekannt' THEN 5359 ---- 5359  unknown
END AS Versickerungswasser,
CASE WHEN Saugwagen = 'unbekannt' THEN 3289 ---- 3289  unknown
WHEN Saugwagen = 'unzugaenglich' THEN 3288 ---- 3288  inaccessible
WHEN Saugwagen = 'zugaenglich' THEN 3287 ---- 3287  accessible
END AS Saugwagen,
CASE WHEN Wasserdichtheit = 'nichtwasserdicht' THEN 3295 ---- 3295  not_watertight
WHEN Wasserdichtheit = 'unbekannt' THEN 5360 ---- 5360  unknown
WHEN Wasserdichtheit = 'wasserdicht' THEN 3294 ---- 3294  watertight
END AS Wasserdichtheit
-- fuer sia405 auskommentiert
--, abwa_2015neu_3122.objid_lookup('Grundwasserleiter', grundwasserleiterref::int)
FROM abwa_2015neu_3122.Versickerungsanlage
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Versickerungsanlage.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.pipe_profile
(
obj_id, height_width_ratio, identifier, profile_type, remark, last_modification, fk_dataowner, fk_provider)
SELECT obj_id, hoehenbreitenverhaeltnis, bezeichnung,
CASE WHEN Profiltyp = 'Eiprofil' THEN 3351 ---- 3351  egg
WHEN Profiltyp = 'Kreisprofil' THEN 3350 ---- 3350  circle
WHEN Profiltyp = 'Maulprofil' THEN 3352 ---- 3352  mouth
WHEN Profiltyp = 'offenes_Profil' THEN 3354 ---- 3354  open
WHEN Profiltyp = 'Rechteckprofil' THEN 3353 ---- 3353  rectangular
WHEN Profiltyp = 'Spezialprofil' THEN 3355 ---- 3355  special
WHEN Profiltyp = 'unbekannt' THEN 3357 ---- 3357  unknown
END AS Profiltyp, bemerkung, Letzte_Aenderung,
--Datenherr, datenlieferant
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)
FROM abwa_2015neu_3122.Rohrprofil
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Rohrprofil.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.wastewater_networkelement
(
obj_id, identifier, remark, fk_wastewater_structure, last_modification, fk_dataowner, fk_provider)
SELECT obj_id, bezeichnung, bemerkung, abwa_2015neu_3122.objid_lookup('Abwasserbauwerk', abwasserbauwerkref::int), Letzte_Aenderung,
--Datenherr, datenlieferant
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)
FROM abwa_2015neu_3122.Abwassernetzelement
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Abwassernetzelement.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.reach_point
(
obj_id, elevation_accuracy, identifier, level, outlet_shape, position_of_connection, remark, situation_geometry, fk_wastewater_networkelement, last_modification, fk_dataowner, fk_provider)
SELECT obj_id,
CASE WHEN Hoehengenauigkeit = 'groesser_6cm' THEN 3248 ---- 3248  more_than_6cm
WHEN Hoehengenauigkeit = 'plusminus_1cm' THEN 3245 ---- 3245  plusminus_1cm
WHEN Hoehengenauigkeit = 'plusminus_3cm' THEN 3246 ---- 3246  plusminus_3cm
WHEN Hoehengenauigkeit = 'plusminus_6cm' THEN 3247 ---- 3247  plusminus_6cm
WHEN Hoehengenauigkeit = 'unbekannt' THEN 5376 ---- 5376  unknown
END AS Hoehengenauigkeit, bezeichnung, kote,
CASE WHEN Auslaufform = 'abgerundet' THEN 5374 ---- 5374  round_edged
WHEN Auslaufform = 'blendenfoermig' THEN 298 ---- 298  orifice
WHEN Auslaufform = 'keine_Querschnittsaenderung' THEN 3358 ---- 3358  no_cross_section_change
WHEN Auslaufform = 'scharfkantig' THEN 286 ---- 286  sharp_edged
WHEN Auslaufform = 'unbekannt' THEN 5375 ---- 5375  unknown
END AS Auslaufform, lage_anschluss, bemerkung, ST_Force3D(lage), abwa_2015neu_3122.objid_lookup('Abwassernetzelement', abwassernetzelementref::int), Letzte_Aenderung, --Datenherr, datenlieferant
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)
FROM abwa_2015neu_3122.Haltungspunkt
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Haltungspunkt.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.wastewater_node
(
obj_id, backflow_level, bottom_level, situation_geometry
-- rausgenommen für sia405 abwasser
--, fk_hydr_geometry
)
SELECT obj_id, rueckstaukote, sohlenkote, ST_Force3D(lage)
--, abwa_2015neu_3122.objid_lookup('Hydr_Geometrie', hydr_geometrieref::int)
FROM abwa_2015neu_3122.Abwasserknoten
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Abwasserknoten.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.reach
(
obj_id, clear_height, coefficient_of_friction, horizontal_positioning, inside_coating, length_effective, material, progression_geometry, reliner_material, reliner_nominal_size, relining_construction, relining_kind, ring_stiffness, slope_building_plan, wall_roughness, fk_reach_point_from, fk_reach_point_to, fk_pipe_profile)
SELECT obj_id, lichte_hoehe, reibungsbeiwert,
CASE WHEN Lagebestimmung = 'genau' THEN 5378 ---- 5378  accurate
WHEN Lagebestimmung = 'unbekannt' THEN 5379 ---- 5379  unknown
WHEN Lagebestimmung = 'ungenau' THEN 5380 ---- 5380  inaccurate
END AS Lagebestimmung,
CASE WHEN Innenschutz = 'andere' THEN 5383 ---- 5383  other
WHEN Innenschutz = 'Anstrich_Beschichtung' THEN 248 ---- 248  coating
WHEN Innenschutz = 'Kanalklinkerauskleidung' THEN 250 ---- 250  brick_lining
WHEN Innenschutz = 'Steinzeugauskleidung' THEN 251 ---- 251  stoneware_lining
WHEN Innenschutz = 'unbekannt' THEN 5384 ---- 5384  unknown
WHEN Innenschutz = 'Zementmoertelauskleidung' THEN 249 ---- 249  cement_mortar_lining
END AS Innenschutz, laengeeffektiv,
CASE WHEN Material = 'andere' THEN 5381 ---- 5381  other
WHEN Material = 'Asbestzement' THEN 2754 ---- 2754  asbestos_cement
WHEN Material = 'Beton_Normalbeton' THEN 3638 ---- 3638  concrete_normal
WHEN Material = 'Beton_Ortsbeton' THEN 3639 ---- 3639  concrete_insitu
WHEN Material = 'Beton_Pressrohrbeton' THEN 3640 ---- 3640  concrete_presspipe
WHEN Material = 'Beton_Spezialbeton' THEN 3641 ---- 3641  concrete_special
WHEN Material = 'Beton_unbekannt' THEN 3256 ---- 3256  concrete_unknown
WHEN Material = 'Faserzement' THEN 147 ---- 147  fiber_cement
WHEN Material = 'Gebrannte_Steine' THEN 2755 ---- 2755  bricks
WHEN Material = 'Guss_duktil' THEN 148 ---- 148  cast_ductile_iron
WHEN Material = 'Guss_Grauguss' THEN 3648 ---- 3648  cast_gray_iron
WHEN Material = 'Kunststoff_Epoxydharz' THEN 5076 ---- 5076  plastic_epoxy_resin
WHEN Material = 'Kunststoff_Hartpolyethylen' THEN 5077 ---- 5077  plastic_highdensity_polyethylene
WHEN Material = 'Kunststoff_Polyester_GUP' THEN 5078 ---- 5078  plastic_polyester_GUP
WHEN Material = 'Kunststoff_Polyethylen' THEN 5079 ---- 5079  plastic_polyethylene
WHEN Material = 'Kunststoff_Polypropylen' THEN 5080 ---- 5080  plastic_polypropylene
WHEN Material = 'Kunststoff_Polyvinilchlorid' THEN 5081 ---- 5081  plastic_PVC
WHEN Material = 'Kunststoff_unbekannt' THEN 5382 ---- 5382  plastic_unknown
WHEN Material = 'Stahl' THEN 153 ---- 153  steel
WHEN Material = 'Stahl_rostfrei' THEN 3654 ---- 3654  steel_stainless
WHEN Material = 'Steinzeug' THEN 154 ---- 154  stoneware
WHEN Material = 'Ton' THEN 2761 ---- 2761  clay
WHEN Material = 'unbekannt' THEN 3016 ---- 3016  unknown
WHEN Material = 'Zement' THEN 2762 ---- 2762  cement
END AS Material, ST_Force3D(verlauf),
CASE WHEN Reliner_Material = 'andere' THEN 6459 ---- 6459  other
WHEN Reliner_Material = 'Epoxidharz_Glasfaserlaminat' THEN 6461 ---- 6461  epoxy_resin_glass_fibre_laminate
WHEN Reliner_Material = 'Epoxidharz_Kunststofffilz' THEN 6460 ---- 6460  epoxy_resin_plastic_felt
WHEN Reliner_Material = 'GUP_Rohr' THEN 6483 ---- 6483  GUP_pipe
WHEN Reliner_Material = 'HDPE' THEN 6462 ---- 6462  HDPE
WHEN Reliner_Material = 'Isocyanatharze_Glasfaserlaminat' THEN 6484 ---- 6484  isocyanate_resin_glass_fibre_laminate
WHEN Reliner_Material = 'Isocyanatharze_Kunststofffilz' THEN 6485 ---- 6485  isocyanate_resin_plastic_felt
WHEN Reliner_Material = 'Polyesterharz_Glasfaserlaminat' THEN 6464 ---- 6464  polyester_resin_glass_fibre_laminate
WHEN Reliner_Material = 'Polyesterharz_Kunststofffilz' THEN 6463 ---- 6463  polyester_resin_plastic_felt
WHEN Reliner_Material = 'Polypropylen' THEN 6482 ---- 6482  polypropylene
WHEN Reliner_Material = 'Polyvinilchlorid' THEN 6465 ---- 6465  PVC
WHEN Reliner_Material = 'Sohle_mit_Schale_aus_Polyesterbeton' THEN 6466 ---- 6466  bottom_with_polyester_concret_shell
WHEN Reliner_Material = 'unbekannt' THEN 6467 ---- 6467  unknown
WHEN Reliner_Material = 'UP_Harz_LED_Synthesefaserliner' THEN 6486 ---- 6486  UP_resin_LED_synthetic_fibre_liner
WHEN Reliner_Material = 'Vinylesterharz_Glasfaserlaminat' THEN 6468 ---- 6468  vinyl_ester_resin_glass_fibre_laminate
WHEN Reliner_Material = 'Vinylesterharz_Kunststofffilz' THEN 6469 ---- 6469  vinyl_ester_resin_plastic_felt
END AS Reliner_Material, reliner_nennweite,
CASE WHEN Reliner_Bautechnik = 'andere' THEN 6448 ---- 6448  other
WHEN Reliner_Bautechnik = 'Close_Fit_Relining' THEN 6479 ---- 6479  close_fit_relining
WHEN Reliner_Bautechnik = 'Kurzrohrrelining' THEN 6449 ---- 6449  relining_short_tube
WHEN Reliner_Bautechnik = 'Noppenschlauchrelining' THEN 6481 ---- 6481  grouted_in_place_lining
WHEN Reliner_Bautechnik = 'Partieller_Liner' THEN 6452 ---- 6452  partial_liner
WHEN Reliner_Bautechnik = 'Rohrstrangrelining' THEN 6450 ---- 6450  pipe_string_relining
WHEN Reliner_Bautechnik = 'Schlauchrelining' THEN 6451 ---- 6451  hose_relining
WHEN Reliner_Bautechnik = 'unbekannt' THEN 6453 ---- 6453  unknown
WHEN Reliner_Bautechnik = 'Wickelrohrrelining' THEN 6480 ---- 6480  spiral_lining
END AS Reliner_Bautechnik,
CASE WHEN Reliner_Art = 'ganze_Haltung' THEN 6455 ---- 6455  full_reach
WHEN Reliner_Art = 'partiell' THEN 6456 ---- 6456  partial
WHEN Reliner_Art = 'unbekannt' THEN 6457 ---- 6457  unknown
END AS Reliner_Art, ringsteifigkeit, plangefaelle, wandrauhigkeit, abwa_2015neu_3122.objid_lookup('Haltungspunkt', vonhaltungspunktref::int), abwa_2015neu_3122.objid_lookup('Haltungspunkt', nachhaltungspunktref::int), abwa_2015neu_3122.objid_lookup('Rohrprofil', rohrprofilref::int)
FROM abwa_2015neu_3122.Haltung
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Haltung.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.reach_text
(
obj_id, fk_reach, plantype, text, remark, textori, texthali, textvali, textpos_geometry, last_modification)
SELECT
-- abwa_2015neu_3122.objid_lookup('Haltung', Haltungref::int) as obj_id,
qgep_sys.generate_oid('qgep_od','txt_text'),
 abwa_2015neu_3122.objid_lookup('Haltung', haltungref::int) as haltungref,
CASE WHEN a.Plantyp = 'Leitungskataster' THEN 7844 ---- 7844  pipeline_registry
WHEN a.Plantyp = 'Uebersichtsplan.UeP10' THEN 7846 ---- 7846  overviewmap.om10
WHEN a.Plantyp = 'Uebersichtsplan.UeP2' THEN 7847 ---- 7847  overviewmap.om2
WHEN a.Plantyp = 'Uebersichtsplan.UeP5' THEN 7848 ---- 7848  overviewmap.om5
WHEN a.Plantyp = 'Werkplan' THEN 7845 ---- 7845  network_plan
END AS Plantyp,
a.textinhalt, a.bemerkung,
b.textori,
CASE WHEN b.textvali = 'TOP' THEN 0
WHEN b.textvali = 'CAP' THEN 1
WHEN b.textvali = 'HALF' THEN 2
WHEN b.textvali = 'BASE' THEN 3
END AS textvali,
CASE WHEN b.texthali = 'LEFT' THEN 0
WHEN b.texthali = 'CENTER' THEN 1
WHEN b.texthali = 'RIGHT' THEN 2
END AS texthali,
--ST_FORCE3D(b.textpos),
b.textpos,
Letzte_Aenderung
FROM abwa_2015neu_3122.Haltung_text
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Haltung_text.t_id = vw_sia405_baseclass_metaattribute.t_id
    LEFT JOIN abwa_2015neu_3122.sia405_textpos as a ON abwa_2015neu_3122.Haltung_text.t_id = a.t_id
    LEFT JOIN abwa_2015neu_3122.textpos as b ON abwa_2015neu_3122.Haltung_text.t_id = b.t_id;

INSERT INTO qgep_od.structure_part
(
obj_id, identifier, remark, renovation_demand, fk_wastewater_structure, last_modification, fk_dataowner, fk_provider)
SELECT obj_id, bezeichnung, bemerkung,
CASE WHEN Instandstellung = 'nicht_notwendig' THEN 138 ---- 138  not_necessary
WHEN Instandstellung = 'notwendig' THEN 137 ---- 137  necessary
WHEN Instandstellung = 'unbekannt' THEN 5358 ---- 5358  unknown
END AS Instandstellung, abwa_2015neu_3122.objid_lookup('Abwasserbauwerk', abwasserbauwerkref::int), Letzte_Aenderung,
--Datenherr, datenlieferant
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(Datenherr),
abwa_2015neu_3122.obj_id_identifer_organisation_lookup(datenlieferant)
FROM abwa_2015neu_3122.BauwerksTeil
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.BauwerksTeil.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.dryweather_downspout
(
obj_id, diameter)
SELECT obj_id, durchmesser
FROM abwa_2015neu_3122.Trockenwetterfallrohr
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Trockenwetterfallrohr.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.access_aid
(
obj_id, kind)
SELECT obj_id,
CASE WHEN Art = 'andere' THEN 5357 ---- 5357  other
WHEN Art = 'Drucktuere' THEN 243 ---- 243  pressurized_door
WHEN Art = 'keine' THEN 92 ---- 92  none
WHEN Art = 'Leiter' THEN 240 ---- 240  ladder
WHEN Art = 'Steigeisen' THEN 241 ---- 241  step_iron
WHEN Art = 'Treppe' THEN 3473 ---- 3473  staircase
WHEN Art = 'Trittnischen' THEN 91 ---- 91  footstep_niches
WHEN Art = 'Tuere' THEN 3230 ---- 3230  door
WHEN Art = 'unbekannt' THEN 3048 ---- 3048  unknown
END AS Art
FROM abwa_2015neu_3122.Einstiegshilfe
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Einstiegshilfe.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.dryweather_flume
(
obj_id, material)
SELECT obj_id,
CASE WHEN Material = 'andere' THEN 3221 ---- 3221  other
WHEN Material = 'kombiniert' THEN 354 ---- 354  combined
WHEN Material = 'Kunststoff' THEN 5356 ---- 5356  plastic
WHEN Material = 'Steinzeug' THEN 238 ---- 238  stoneware
WHEN Material = 'unbekannt' THEN 3017 ---- 3017  unknown
WHEN Material = 'Zementmoertel' THEN 237 ---- 237  cement_mortar
END AS Material
FROM abwa_2015neu_3122.Trockenwetterrinne
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Trockenwetterrinne.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.cover
(
obj_id, brand, cover_shape, diameter, fastening, level, material, positional_accuracy, situation_geometry, sludge_bucket, venting)
SELECT obj_id, fabrikat,
CASE WHEN Deckelform = 'andere' THEN 5353 ---- 5353  other
WHEN Deckelform = 'eckig' THEN 3499 ---- 3499  rectangular
WHEN Deckelform = 'rund' THEN 3498 ---- 3498  round
WHEN Deckelform = 'unbekannt' THEN 5354 ---- 5354  unknown
END AS Deckelform, durchmesser,
CASE WHEN Verschluss = 'nicht_verschraubt' THEN 5350 ---- 5350  not_bolted
WHEN Verschluss = 'unbekannt' THEN 5351 ---- 5351  unknown
WHEN Verschluss = 'verschraubt' THEN 5352 ---- 5352  bolted
END AS Verschluss, kote,
CASE WHEN Material = 'andere' THEN 5355 ---- 5355  other
WHEN Material = 'Beton' THEN 234 ---- 234  concrete
WHEN Material = 'Guss' THEN 233 ---- 233  cast_iron
WHEN Material = 'Guss_mit_Belagsfuellung' THEN 5547 ---- 5547  cast_iron_with_pavement_filling
WHEN Material = 'Guss_mit_Betonfuellung' THEN 235 ---- 235  cast_iron_with_concrete_filling
WHEN Material = 'unbekannt' THEN 3015 ---- 3015  unknown
END AS Material,
CASE WHEN Lagegenauigkeit = 'groesser_50cm' THEN 3243 ---- 3243  more_than_50cm
WHEN Lagegenauigkeit = 'plusminus_10cm' THEN 3241 ---- 3241  plusminus_10cm
WHEN Lagegenauigkeit = 'plusminus_3cm' THEN 3236 ---- 3236  plusminus_3cm
WHEN Lagegenauigkeit = 'plusminus_50cm' THEN 3242 ---- 3242  plusminus_50cm
WHEN Lagegenauigkeit = 'unbekannt' THEN 5349 ---- 5349  unknown
END AS Lagegenauigkeit, ST_Force3D(lage),
CASE WHEN Schlammeimer = 'nicht_vorhanden' THEN 423 ---- 423  inexistent
WHEN Schlammeimer = 'unbekannt' THEN 3066 ---- 3066  unknown
WHEN Schlammeimer = 'vorhanden' THEN 422 ---- 422  existent
END AS Schlammeimer,
CASE WHEN Entlueftung = 'entlueftet' THEN 229 ---- 229  vented
WHEN Entlueftung = 'nicht_entlueftet' THEN 230 ---- 230  not_vented
WHEN Entlueftung = 'unbekannt' THEN 5348 ---- 5348  unknown
END AS Entlueftung
FROM abwa_2015neu_3122.Deckel
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Deckel.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;

INSERT INTO qgep_od.benching
(
obj_id, kind)
SELECT obj_id,
CASE WHEN Art = 'andere' THEN 5319 ---- 5319  other
WHEN Art = 'beidseitig' THEN 94 ---- 94  double_sided
WHEN Art = 'einseitig' THEN 93 ---- 93  one_sided
WHEN Art = 'kein' THEN 3231 ---- 3231  none
WHEN Art = 'unbekannt' THEN 3033 ---- 3033  unknown
END AS Art
FROM abwa_2015neu_3122.Bankett
    LEFT JOIN abwa_2015neu_3122.vw_sia405_baseclass_metaattribute ON abwa_2015neu_3122.Bankett.t_id = vw_sia405_baseclass_metaattribute.t_id
WHERE NOT obj_id isNull;
