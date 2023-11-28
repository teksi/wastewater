------ This file is sql code to Export QGEP (Modul VSA-DSS) in English to INTERLIS in German on QQIS
------ Second version using tid_generate and tid_lookup
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 21.11.2016 21:07:32
------ 22.11.2016 / 26.11.2016 modified
------ 1.6.2017 Korrektur Ausfuehrende_Firma statt Aufuehrender_Firma
------ 4.7.2017  ST_Force2D(detail_geometry_geometry) ergänzt bei allen _geometry und _progression attributen

-- 22.11.2016 modified
-- INSERT INTO vsa_dss_2015_2_d.erhaltungsereignis_abwasserbauwerk
INSERT INTO vsa_dss_2015_2_d.erhaltungsereignis_abwasserbauwerkassoc
(
t_id, abwasserbauwerkref, erhaltungsereignis_abwasserbauwerkassocref)
SELECT vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis_abwasserbauwerkassoc', obj_id), vsa_dss_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure), vsa_dss_2015_2_d.tid_lookup('Erhaltungsereignis', fk_maintenance_event)
FROM qgep_od.re_maintenance_event_wastewater_structure;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq,
-- datenherr,
-- datenlieferant,
-- letzte_aenderung,
sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis_abwasserbauwerkassoc', qgep_od.re_maintenance_event_wastewater_structure.obj_id), '0',
-- a.identifier as dataowner,
-- b.identifier as provider,
-- re_maintenance_event_wastewater_structure.last_modification,
vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis_abwasserbauwerkassoc', qgep_od.re_maintenance_event_wastewater_structure.obj_id)
FROM qgep_od.re_maintenance_event_wastewater_structure;
--   LEFT JOIN qgep_od.organisation as a ON re_maintenance_event_wastewater_structure.fk_dataowner = a.obj_id
--   LEFT JOIN qgep_od.organisation as b ON re_maintenance_event_wastewater_structure.fk_provider = b.obj_id;

/*
INSERT INTO vsa_dss_2015_2_d.symbol
(
t_id, klasse, plantyp, bemerkung, symbolskalierunghoch, symbolskalierunglaengs, symbolhali, symbolori, symbolpos, symbolvali)
SELECT vsa_dss_2015_2_d.tid_lookup('symbol', obj_id), class, plantype, remark, symbol_scaling_heigth, symbol_scaling_width, symbolhali, symbolori, ST_Force2D(symbolpos_geometry), symbolvali
FROM qgep_od.symbol;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('symbol', qgep_od.symbol.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_symbol.last_modification, vsa_dss_2015_2_d.tid_lookup('symbol', qgep_od.symbol.obj_id)
FROM qgep_od.symbol
   LEFT JOIN qgep_od.organisation as a ON od_symbol.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_symbol.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.text
(
t_id, klasse, plantyp, bemerkung, textinhalt, texthali, textori, textpos, textvali)
SELECT vsa_dss_2015_2_d.tid_lookup('text', obj_id), class, plantype, remark, text, texthali, textori, ST_Force2D(textpos_geometry), textvali
FROM qgep_od.text;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('text', qgep_od.text.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_text.last_modification, vsa_dss_2015_2_d.tid_lookup('text', qgep_od.text.obj_id)
FROM qgep_od.text
   LEFT JOIN qgep_od.organisation as a ON od_text.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_text.fk_provider = b.obj_id;
*/

INSERT INTO vsa_dss_2015_2_d.mutation
(
t_id, attribut, klasse, mutationsdatum, aufnahmedatum, art, letzter_wert, objekt, aufnehmer, bemerkung, systembenutzer)
SELECT vsa_dss_2015_2_d.tid_lookup('mutation', obj_id), attribute, class, date_mutation, date_time,
CASE WHEN kind = 5523 THEN 'erstellt' ---- 5523  created
WHEN kind = 5582 THEN 'geaendert' ---- 5582  changed
WHEN kind = 5583 THEN 'geloescht' ---- 5583  deleted
END, last_value, object, recorded_by, remark, system_user
FROM qgep_od.mutation;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('mutation', qgep_od.mutation.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_mutation.last_modification, vsa_dss_2015_2_d.tid_lookup('mutation', qgep_od.mutation.obj_id)
FROM qgep_od.mutation
   LEFT JOIN qgep_od.organisation as a ON od_mutation.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_mutation.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.grundwasserleiter
(
t_id, mittlerergwspiegel, bezeichnung, maxgwspiegel, mingwspiegel, perimeter, bemerkung)
SELECT vsa_dss_2015_2_d.tid_lookup('grundwasserleiter', obj_id), average_groundwater_level, identifier, maximal_groundwater_level, minimal_groundwater_level, ST_Force2D(perimeter_geometry), remark
FROM qgep_od.aquifier;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('grundwasserleiter', qgep_od.aquifier.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_aquifier.last_modification, vsa_dss_2015_2_d.tid_lookup('grundwasserleiter', qgep_od.aquifier.obj_id)
FROM qgep_od.aquifier
   LEFT JOIN qgep_od.organisation as a ON od_aquifier.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_aquifier.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.oberflaechengewaesser
(
t_id, bezeichnung, bemerkung)
SELECT vsa_dss_2015_2_d.tid_lookup('oberflaechengewaesser', obj_id), identifier, remark
FROM qgep_od.surface_water_bodies;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('oberflaechengewaesser', qgep_od.surface_water_bodies.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_surface_water_bodies.last_modification, vsa_dss_2015_2_d.tid_lookup('oberflaechengewaesser', qgep_od.surface_water_bodies.obj_id)
FROM qgep_od.surface_water_bodies
   LEFT JOIN qgep_od.organisation as a ON od_surface_water_bodies.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_surface_water_bodies.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.fliessgewaesser
(
t_id, art)
SELECT vsa_dss_2015_2_d.tid_lookup('fliessgewaesser', obj_id),
CASE WHEN kind = 3397 THEN 'Gletscherbach' ---- 3397  englacial_river
WHEN kind = 3399 THEN 'Moorbach' ---- 3399  moor_creek
WHEN kind = 3398 THEN 'Seeausfluss' ---- 3398  lake_outflow
WHEN kind = 3396 THEN 'Travertinbach' ---- 3396  travertine_river
WHEN kind = 3400 THEN 'unbekannt' ---- 3400  unknown
END
FROM qgep_od.river;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'fliessgewaesser'
FROM
   vsa_dss_2015_2_d.fliessgewaesser a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.see
(
t_id, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('see', obj_id), ST_Force2D(perimeter_geometry)
FROM qgep_od.lake;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'see'
FROM
   vsa_dss_2015_2_d.see a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.gewaesserabschnitt
(
t_id, algenbewuchs, hoehenstufe, sohlenbreite, totholz, tiefenvariabilitaet, abflussregime, oekom_klassifizierung, von, bezeichnung, art, laengsprofil, makrophytenbewuchs, bemerkung, linienfuehrung, groesse, gefaelle, bis, nutzung, wasserhaerte, breitenvariabilitaet, fliessgewaesserref)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserabschnitt', obj_id),
CASE WHEN algae_growth = 2623 THEN 'kein_gering' ---- 2623  none_or_marginal
WHEN algae_growth = 2624 THEN 'maessig_stark' ---- 2624  moderate_to_strong
WHEN algae_growth = 2625 THEN 'uebermaessig_wuchernd' ---- 2625  excessive_rampant
WHEN algae_growth = 3050 THEN 'unbekannt' ---- 3050  unknown
END,
CASE WHEN altitudinal_zone = 320 THEN 'alpin' ---- 320  alpine
WHEN altitudinal_zone = 294 THEN 'kollin' ---- 294  foothill_zone
WHEN altitudinal_zone = 295 THEN 'montan' ---- 295  montane
WHEN altitudinal_zone = 319 THEN 'subalpin' ---- 319  subalpine
WHEN altitudinal_zone = 3020 THEN 'unbekannt' ---- 3020  unknown
END, bed_with,
CASE WHEN dead_wood = 2629 THEN 'Ansammlungen' ---- 2629  accumulations
WHEN dead_wood = 2631 THEN 'kein_vereinzelt' ---- 2631  none_or_sporadic
WHEN dead_wood = 3052 THEN 'unbekannt' ---- 3052  unknown
WHEN dead_wood = 2630 THEN 'zerstreut' ---- 2630  scattered
END,
CASE WHEN depth_variability = 2617 THEN 'ausgepraegt' ---- 2617  pronounced
WHEN depth_variability = 2619 THEN 'keine' ---- 2619  none
WHEN depth_variability = 2618 THEN 'maessig' ---- 2618  moderate
WHEN depth_variability = 3049 THEN 'unbekannt' ---- 3049  unknown
END,
CASE WHEN discharge_regime = 297 THEN 'beeintraechtigt' ---- 297  compromised
WHEN discharge_regime = 428 THEN 'kuenstlich' ---- 428  artificial
WHEN discharge_regime = 427 THEN 'naturfern' ---- 427  hardly_natural
WHEN discharge_regime = 296 THEN 'naturnah' ---- 296  close_to_natural
WHEN discharge_regime = 3091 THEN 'unbekannt' ---- 3091  unknown
END,
CASE WHEN ecom_classification = 3496 THEN 'eingedolt' ---- 3496  covered
WHEN ecom_classification = 3495 THEN 'kuenstlich_naturfremd' ---- 3495  artificial
WHEN ecom_classification = 3492 THEN 'natuerlich_naturnah' ---- 3492  natural_or_seminatural
WHEN ecom_classification = 3491 THEN 'nicht_klassiert' ---- 3491  not_classified
WHEN ecom_classification = 3494 THEN 'stark_beeintraechtigt' ---- 3494  heavily_compromised
WHEN ecom_classification = 3493 THEN 'wenig_beeintraechtigt' ---- 3493  partially_compromised
END, ST_Force2D(from_geometry), identifier,
CASE WHEN kind = 2710 THEN 'eingedolt' ---- 2710  covered
WHEN kind = 2709 THEN 'offen' ---- 2709  open
WHEN kind = 3058 THEN 'unbekannt' ---- 3058  unknown
END,
CASE WHEN length_profile = 97 THEN 'kaskadenartig' ---- 97  downwelling
WHEN length_profile = 3602 THEN 'Schnellen_Kolke' ---- 3602  rapids_or_potholes
WHEN length_profile = 99 THEN 'stetig' ---- 99  continuous
WHEN length_profile = 3035 THEN 'unbekannt' ---- 3035  unknown
END,
CASE WHEN macrophyte_coverage = 2626 THEN 'kein_gering' ---- 2626  none_or_marginal
WHEN macrophyte_coverage = 2627 THEN 'maessig_stark' ---- 2627  moderate_to_strong
WHEN macrophyte_coverage = 2628 THEN 'uebermaessig_wuchernd' ---- 2628  excessive_rampant
WHEN macrophyte_coverage = 3051 THEN 'unbekannt' ---- 3051  unknown
END, remark,
CASE WHEN section_morphology = 4575 THEN 'gerade' ---- 4575  straight
WHEN section_morphology = 4580 THEN 'leichtbogig' ---- 4580  moderately_bent
WHEN section_morphology = 4579 THEN 'maeandrierend' ---- 4579  meandering
WHEN section_morphology = 4578 THEN 'starkbogig' ---- 4578  heavily_bent
WHEN section_morphology = 4576 THEN 'unbekannt' ---- 4576  unknown
END, size,
CASE WHEN slope = 291 THEN 'flach' ---- 291  shallow_dipping
WHEN slope = 292 THEN 'mittel' ---- 292  moderate_slope
WHEN slope = 293 THEN 'steil' ---- 293  steep
WHEN slope = 3019 THEN 'unbekannt' ---- 3019  unknown
END, ST_Force2D(to_geometry),
CASE WHEN utilisation = 384 THEN 'Erholung' ---- 384  recreation
WHEN utilisation = 429 THEN 'Fischerei' ---- 429  fishing
WHEN utilisation = 385 THEN 'Stauanlage' ---- 385  dam
WHEN utilisation = 3039 THEN 'unbekannt' ---- 3039  unknown
END,
CASE WHEN water_hardness = 321 THEN 'Kalk' ---- 321  limestone
WHEN water_hardness = 322 THEN 'Silikat' ---- 322  silicate
WHEN water_hardness = 3024 THEN 'unbekannt' ---- 3024  unknown
END,
CASE WHEN width_variability = 176 THEN 'ausgepraegt' ---- 176  pronounced
WHEN width_variability = 177 THEN 'eingeschraenkt' ---- 177  limited
WHEN width_variability = 178 THEN 'keine' ---- 178  none
WHEN width_variability = 3078 THEN 'unbekannt' ---- 3078  unknown
END, vsa_dss_2015_2_d.tid_lookup('Fliessgewaesser', fk_watercourse)
FROM qgep_od.water_course_segment;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserabschnitt', qgep_od.water_course_segment.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_water_course_segment.last_modification, vsa_dss_2015_2_d.tid_lookup('gewaesserabschnitt', qgep_od.water_course_segment.obj_id)
FROM qgep_od.water_course_segment
   LEFT JOIN qgep_od.organisation as a ON od_water_course_segment.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_water_course_segment.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.wasserfassung
(
t_id, bezeichnung, art, bemerkung, lage, grundwasserleiterref, oberflaechengewaesserref)
SELECT vsa_dss_2015_2_d.tid_lookup('wasserfassung', obj_id), identifier,
CASE WHEN kind = 24 THEN 'Brauchwasser' ---- 24  process_water
WHEN kind = 25 THEN 'Trinkwasser' ---- 25  drinking_water
WHEN kind = 3075 THEN 'unbekannt' ---- 3075  unknown
END, remark, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Grundwasserleiter', fk_aquifier), vsa_dss_2015_2_d.tid_lookup('Oberflaechengewaesser', fk_chute)
FROM qgep_od.water_catchment;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('wasserfassung', qgep_od.water_catchment.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_water_catchment.last_modification, vsa_dss_2015_2_d.tid_lookup('wasserfassung', qgep_od.water_catchment.obj_id)
FROM qgep_od.water_catchment
   LEFT JOIN qgep_od.organisation as a ON od_water_catchment.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_water_catchment.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.ufer
(
t_id, verbauungsgrad, bezeichnung, bemerkung, verbauungsart, uferbereich, seite, umlandnutzung, vegetation, breite, gewaesserabschnittref)
SELECT vsa_dss_2015_2_d.tid_lookup('ufer', obj_id),
CASE WHEN control_grade_of_river = 341 THEN 'keine' ---- 341  none
WHEN control_grade_of_river = 2612 THEN 'maessig' ---- 2612  moderate
WHEN control_grade_of_river = 2613 THEN 'stark' ---- 2613  strong
WHEN control_grade_of_river = 2614 THEN 'ueberwiegend' ---- 2614  predominantly
WHEN control_grade_of_river = 3026 THEN 'unbekannt' ---- 3026  unknown
WHEN control_grade_of_river = 2611 THEN 'vereinzelt' ---- 2611  sporadic
WHEN control_grade_of_river = 2615 THEN 'vollstaendig' ---- 2615  complete
END, identifier, remark,
CASE WHEN river_control_type = 3489 THEN 'andere_dicht' ---- 3489  other_impermeable
WHEN river_control_type = 3486 THEN 'Betongitterstein_dicht' ---- 3486  concrete_chequer_brick_impermeable
WHEN river_control_type = 3485 THEN 'Holz_durchlaessig' ---- 3485  wood_permeable
WHEN river_control_type = 3482 THEN 'keine_Verbauung' ---- 3482  no_control_structure
WHEN river_control_type = 3483 THEN 'Lebendverbau_durchlaessig' ---- 3483  living_control_structure_permeable
WHEN river_control_type = 3488 THEN 'Mauer_dicht' ---- 3488  wall_impermeable
WHEN river_control_type = 3487 THEN 'Naturstein_dicht' ---- 3487  natural_stone_impermeable
WHEN river_control_type = 3484 THEN 'Naturstein_locker_durchlaessig' ---- 3484  loose_natural_stone_permeable
WHEN river_control_type = 3080 THEN 'unbekannt' ---- 3080  unknown
END,
CASE WHEN shores = 404 THEN 'gewaesserfremd' ---- 404  inappropriate_to_river
WHEN shores = 403 THEN 'gewaessergerecht' ---- 403  appropriate_to_river
WHEN shores = 405 THEN 'kuenstlich' ---- 405  artificial
WHEN shores = 3081 THEN 'unbekannt' ---- 3081  unknown
END,
CASE WHEN side = 420 THEN 'links' ---- 420  left
WHEN side = 421 THEN 'rechts' ---- 421  right
WHEN side = 3065 THEN 'unbekannt' ---- 3065  unknown
END,
CASE WHEN utilisation_of_shore_surroundings = 424 THEN 'Bebauungen' ---- 424  developed_area
WHEN utilisation_of_shore_surroundings = 425 THEN 'Gruenland' ---- 425  grassland
WHEN utilisation_of_shore_surroundings = 3068 THEN 'unbekannt' ---- 3068  unknown
WHEN utilisation_of_shore_surroundings = 426 THEN 'Wald' ---- 426  forest
END,
CASE WHEN vegetation = 325 THEN 'fehlend' ---- 325  missing
WHEN vegetation = 323 THEN 'standorttypisch' ---- 323  typical_for_habitat
WHEN vegetation = 324 THEN 'standortuntypisch' ---- 324  atypical_for_habitat
WHEN vegetation = 3025 THEN 'unbekannt' ---- 3025  unknown
END, width, vsa_dss_2015_2_d.tid_lookup('Gewaesserabschnitt', fk_water_course_segment)
FROM qgep_od.river_bank;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('ufer', qgep_od.river_bank.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_river_bank.last_modification, vsa_dss_2015_2_d.tid_lookup('ufer', qgep_od.river_bank.obj_id)
FROM qgep_od.river_bank
   LEFT JOIN qgep_od.organisation as a ON od_river_bank.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_river_bank.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.gewaessersohle
(
t_id, verbauungsgrad, bezeichnung, art, bemerkung, verbauungsart, breite, gewaesserabschnittref)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaessersohle', obj_id),
CASE WHEN control_grade_of_river = 142 THEN 'keine' ---- 142  none
WHEN control_grade_of_river = 2607 THEN 'maessig' ---- 2607  moderate
WHEN control_grade_of_river = 2608 THEN 'stark' ---- 2608  heavily
WHEN control_grade_of_river = 2609 THEN 'ueberwiegend' ---- 2609  predominantly
WHEN control_grade_of_river = 3085 THEN 'unbekannt' ---- 3085  unknown
WHEN control_grade_of_river = 2606 THEN 'vereinzelt' ---- 2606  sporadic
WHEN control_grade_of_river = 2610 THEN 'vollstaendig' ---- 2610  complete
END, identifier,
CASE WHEN kind = 290 THEN 'hart' ---- 290  hard
WHEN kind = 3089 THEN 'unbekannt' ---- 3089  unknown
WHEN kind = 289 THEN 'weich' ---- 289  soft
END, remark,
CASE WHEN river_control_type = 3481 THEN 'andere_dicht' ---- 3481  other_impermeable
WHEN river_control_type = 338 THEN 'Betongittersteine' ---- 338  concrete_chequer_brick
WHEN river_control_type = 3479 THEN 'Holz' ---- 3479  wood
WHEN river_control_type = 3477 THEN 'keine_Verbauung' ---- 3477  no_control_structure
WHEN river_control_type = 3478 THEN 'Steinschuettung_Blockwurf' ---- 3478  rock_fill_or_loose_boulders
WHEN river_control_type = 3079 THEN 'unbekannt' ---- 3079  unknown
END, width, vsa_dss_2015_2_d.tid_lookup('Gewaesserabschnitt', fk_water_course_segment)
FROM qgep_od.river_bed;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaessersohle', qgep_od.river_bed.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_river_bed.last_modification, vsa_dss_2015_2_d.tid_lookup('gewaessersohle', qgep_od.river_bed.obj_id)
FROM qgep_od.river_bed
   LEFT JOIN qgep_od.organisation as a ON od_river_bed.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_river_bed.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.gewaessersektor
(
t_id, bwg_code, bezeichnung, art, kilomo, kilomu, verlauf, reflaenge, bemerkung, oberflaechengewaesserref)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaessersektor', obj_id), code_bwg, identifier,
CASE WHEN kind = 2657 THEN 'Gewaesser' ---- 2657  waterbody
WHEN kind = 2729 THEN 'ParallelerAbschnitt' ---- 2729  parallel_section
WHEN kind = 2728 THEN 'Seetraverse' ---- 2728  lake_traversal
WHEN kind = 2656 THEN 'Ufer' ---- 2656  shore
WHEN kind = 3054 THEN 'unbekannt' ---- 3054  unknown
END, km_down, km_up, ST_Force2D(progression_geometry), ref_length, remark, vsa_dss_2015_2_d.tid_lookup('Oberflaechengewaesser', fk_chute)
FROM qgep_od.sector_water_body;

-- additional Table Assoc: Gewaessersektor_VorherigerSektor/ no table hierarchy in qgep schema yet (check how to implement there)
-- INSERT INTO vsa_dss_2015_2_d.Gewaessersektor_VorherigerSektorassoc
-- (
-- t_id, VorherigerSektorref, Gewaessersektor_VorherigerSektorassocref)
-- SELECT vsa_dss_2015_2_d.tid_lookup('Gewaessersektor', obj_id), vsa_dss_2015_2_d.tid_lookup('Gewaessersektor', fk_sector_previous),vsa_dss_2015_2_d.tid_lookup('Gewaessersektor', obj_id)
-- FROM qgep_od.gewaessersektor;


INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaessersektor', qgep_od.sector_water_body.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_sector_water_body.last_modification, vsa_dss_2015_2_d.tid_lookup('gewaessersektor', qgep_od.sector_water_body.obj_id)
FROM qgep_od.sector_water_body
   LEFT JOIN qgep_od.organisation as a ON od_sector_water_body.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_sector_water_body.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.organisation
(
t_id, bezeichnung, bemerkung, uid)
SELECT vsa_dss_2015_2_d.tid_lookup('organisation', obj_id), identifier, remark, uid
FROM qgep_od.organisation;

-- additional Table Assoc: Organisation_Teil_von/ no table hierarchy in qgep schema yet (check how to implement there)
-- INSERT INTO vsa_dss_2015_2_d.Organisation_Teil_vonassoc
-- (
-- t_id, Teil_vonref, Organisation_Teil_vonassocref)
-- SELECT vsa_dss_2015_2_d.tid_lookup('Organisation', obj_id), vsa_dss_2015_2_d.tid_lookup('Organisation', fk_part_of),vsa_dss_2015_2_d.tid_lookup('Organisation', obj_id)
-- FROM qgep_od.organisation;


INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('organisation', qgep_od.organisation.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_organisation.last_modification, vsa_dss_2015_2_d.tid_lookup('organisation', qgep_od.organisation.obj_id)
FROM qgep_od.organisation
   LEFT JOIN qgep_od.organisation as a ON od_organisation.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_organisation.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.genossenschaft_korporation
(
t_id)
SELECT vsa_dss_2015_2_d.tid_lookup('genossenschaft_korporation', obj_id)
FROM qgep_od.cooperative;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'genossenschaft_korporation'
FROM
   vsa_dss_2015_2_d.genossenschaft_korporation a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.kanton
(
t_id, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('kanton', obj_id), ST_Force2D(perimeter_geometry)
FROM qgep_od.canton;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'kanton'
FROM
   vsa_dss_2015_2_d.kanton a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.abwasserverband
(
t_id)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserverband', obj_id)
FROM qgep_od.waste_water_association;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'abwasserverband'
FROM
   vsa_dss_2015_2_d.abwasserverband a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.gemeinde
(
t_id, hoehe, gep_jahr, gemeindenummer, perimeter, einwohner, flaeche)
SELECT vsa_dss_2015_2_d.tid_lookup('gemeinde', obj_id), altitude, gwdp_year, municipality_number, ST_Force2D(perimeter_geometry), population, total_surface
FROM qgep_od.municipality;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'gemeinde'
FROM
   vsa_dss_2015_2_d.gemeinde a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.amt
(
t_id)
SELECT vsa_dss_2015_2_d.tid_lookup('amt', obj_id)
FROM qgep_od.administrative_office;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'amt'
FROM
   vsa_dss_2015_2_d.amt a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.abwasserreinigungsanlage
(
t_id, bsb5, csb, eliminationcsb, eliminationn, eliminationnh4, eliminationp, anlagenummer, art, nh4, inbetriebnahme)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserreinigungsanlage', obj_id), bod5, cod, elimination_cod, elimination_n, elimination_nh4, elimination_p, installation_number, kind, nh4, start_year
FROM qgep_od.waste_water_treatment_plant;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'abwasserreinigungsanlage'
FROM
   vsa_dss_2015_2_d.abwasserreinigungsanlage a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.privat
(
t_id, art)
SELECT vsa_dss_2015_2_d.tid_lookup('privat', obj_id), kind
FROM qgep_od.private;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'privat'
FROM
   vsa_dss_2015_2_d.privat a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.abwasserbauwerk
(
t_id, zugaenglichkeit, baulos, detailgeometrie, finanzierung, bruttokosten, bezeichnung, inspektionsintervall, standortname, akten, bemerkung, sanierungsbedarf, wiederbeschaffungswert, wbw_basisjahr, wbw_bauart, status, baulicherzustand, subventionen, baujahr, ersatzjahr, eigentuemerref, betreiberref)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserbauwerk', obj_id),
CASE WHEN accessibility = 3444 THEN 'ueberdeckt' ---- 3444  covered
WHEN accessibility = 3447 THEN 'unbekannt' ---- 3447  unknown
WHEN accessibility = 3446 THEN 'unzugaenglich' ---- 3446  inaccessible
WHEN accessibility = 3445 THEN 'zugaenglich' ---- 3445  accessible
END, contract_section, ST_Force2D(detail_geometry_geometry),
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
END, status,
CASE WHEN structure_condition = 3037 THEN 'unbekannt' ---- 3037  unknown
WHEN structure_condition = 3363 THEN 'Z0' ---- 3363  Z0
WHEN structure_condition = 3359 THEN 'Z1' ---- 3359  Z1
WHEN structure_condition = 3360 THEN 'Z2' ---- 3360  Z2
WHEN structure_condition = 3361 THEN 'Z3' ---- 3361  Z3
WHEN structure_condition = 3362 THEN 'Z4' ---- 3362  Z4
END, subsidies, year_of_construction, year_of_replacement, vsa_dss_2015_2_d.tid_lookup('Organisation', fk_owner), vsa_dss_2015_2_d.tid_lookup('Organisation', fk_operator)
FROM qgep_od.wastewater_structure;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserbauwerk', qgep_od.wastewater_structure.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_wastewater_structure.last_modification, vsa_dss_2015_2_d.tid_lookup('abwasserbauwerk', qgep_od.wastewater_structure.obj_id)
FROM qgep_od.wastewater_structure
   LEFT JOIN qgep_od.organisation as a ON od_wastewater_structure.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_wastewater_structure.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.kanal
(
t_id, bettung_umhuellung, verbindungsart, funktionhierarchisch, funktionhydraulisch, spuelintervall, rohrlaenge, nutzungsart_ist, nutzungsart_geplant)
SELECT vsa_dss_2015_2_d.tid_lookup('kanal', obj_id),
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
END, function_hierarchic,
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

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'kanal'
FROM
   vsa_dss_2015_2_d.kanal a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.normschacht
(
t_id, dimension1, dimension2, funktion, material, oberflaechenzulauf)
SELECT vsa_dss_2015_2_d.tid_lookup('normschacht', obj_id), dimension1, dimension2,
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

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'normschacht'
FROM
   vsa_dss_2015_2_d.normschacht a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.einleitstelle
(
t_id, hochwasserkote, relevanz, terrainkote, wasserspiegel_hydraulik, gewaessersektorref)
SELECT vsa_dss_2015_2_d.tid_lookup('einleitstelle', obj_id), highwater_level,
CASE WHEN relevance = 5580 THEN 'gewaesserrelevant' ---- 5580  relevant_for_water_course
WHEN relevance = 5581 THEN 'nicht_gewaesserrelevant' ---- 5581  non_relevant_for_water_course
END, terrain_level, waterlevel_hydraulic, vsa_dss_2015_2_d.tid_lookup('Gewaessersektor', fk_sector_water_body)
FROM qgep_od.discharge_point;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'einleitstelle'
FROM
   vsa_dss_2015_2_d.einleitstelle a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.spezialbauwerk
(
t_id, bypass, notueberlauf, funktion, regenbecken_anordnung)
SELECT vsa_dss_2015_2_d.tid_lookup('spezialbauwerk', obj_id),
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

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'spezialbauwerk'
FROM
   vsa_dss_2015_2_d.spezialbauwerk a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.versickerungsanlage
(
t_id, schluckvermoegen, maengel, dimension1, dimension2, gwdistanz, wirksameflaeche, notueberlauf, art, beschriftung, versickerungswasser, saugwagen, wasserdichtheit, grundwasserleiterref)
SELECT vsa_dss_2015_2_d.tid_lookup('versickerungsanlage', obj_id), absorption_capacity,
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
END, vsa_dss_2015_2_d.tid_lookup('Grundwasserleiter', fk_aquifier)
FROM qgep_od.infiltration_installation;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'versickerungsanlage'
FROM
   vsa_dss_2015_2_d.versickerungsanlage a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.arabauwerk
(
t_id, art)
SELECT vsa_dss_2015_2_d.tid_lookup('arabauwerk', obj_id),
CASE WHEN kind = 331 THEN 'Absetzbecken' ---- 331  sedimentation_basin
WHEN kind = 2974 THEN 'andere' ---- 2974  other
WHEN kind = 327 THEN 'Belebtschlammbecken' ---- 327  aeration_tank
WHEN kind = 329 THEN 'Festbettreaktor' ---- 329  fixed_bed_reactor
WHEN kind = 330 THEN 'Tauchtropfkoerper' ---- 330  submerged_trickling_filter
WHEN kind = 328 THEN 'Tropfkoerper' ---- 328  trickling_filter
WHEN kind = 3032 THEN 'unbekannt' ---- 3032  unknown
WHEN kind = 326 THEN 'Vorklaerbecken' ---- 326  primary_clarifier
END
FROM qgep_od.wwtp_structure;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'arabauwerk'
FROM
   vsa_dss_2015_2_d.arabauwerk a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.erhaltungsereignis
(
t_id, datengrundlage, kosten, detaildaten, dauer, bezeichnung, art, ausfuehrender, grund, bemerkung, ergebnis, status, zeitpunkt,
--abwasserbauwerkref,
--ausfuehrender_firmaref)
ausfuehrende_firmaref)
SELECT vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis', obj_id), base_data, cost, data_details, duration, identifier,
CASE WHEN kind = 2982 THEN 'andere' ---- 2982  other
WHEN kind = 120 THEN 'Erneuerung' ---- 120  replacement
WHEN kind = 28 THEN 'Reinigung' ---- 28  cleaning
WHEN kind = 4529 THEN 'Renovierung' ---- 4529  renovation
WHEN kind = 4528 THEN 'Reparatur' ---- 4528  repair
WHEN kind = 4530 THEN 'Sanierung' ---- 4530  restoration
WHEN kind = 3045 THEN 'unbekannt' ---- 3045  unknown
WHEN kind = 4564 THEN 'Untersuchung' ---- 4564  examination
END, operator, reason, remark, result,
CASE WHEN status = 2550 THEN 'ausgefuehrt' ---- 2550  accomplished
WHEN status = 2549 THEN 'geplant' ---- 2549  planned
WHEN status = 3678 THEN 'nicht_moeglich' ---- 3678  not_possible
WHEN status = 3047 THEN 'unbekannt' ---- 3047  unknown
END, time_point,
--vsa_dss_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure),
vsa_dss_2015_2_d.tid_lookup('Organisation', fk_operating_company)
FROM qgep_od.maintenance_event;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis', qgep_od.maintenance_event.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_maintenance_event.last_modification, vsa_dss_2015_2_d.tid_lookup('erhaltungsereignis', qgep_od.maintenance_event.obj_id)
FROM qgep_od.maintenance_event
   LEFT JOIN qgep_od.organisation as a ON od_maintenance_event.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_maintenance_event.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.zone
(
t_id, bezeichnung, bemerkung)
SELECT vsa_dss_2015_2_d.tid_lookup('zone', obj_id), identifier, remark
FROM qgep_od.zone;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('zone', qgep_od.zone.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_zone.last_modification, vsa_dss_2015_2_d.tid_lookup('zone', qgep_od.zone.obj_id)
FROM qgep_od.zone
   LEFT JOIN qgep_od.organisation as a ON od_zone.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_zone.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.planungszone
(
t_id, art, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('planungszone', obj_id),
CASE WHEN kind = 2990 THEN 'andere' ---- 2990  other
WHEN kind = 31 THEN 'Gewerbezone' ---- 31  commercial_zone
WHEN kind = 32 THEN 'Industriezone' ---- 32  industrial_zone
WHEN kind = 30 THEN 'Landwirtschaftszone' ---- 30  agricultural_zone
WHEN kind = 3077 THEN 'unbekannt' ---- 3077  unknown
WHEN kind = 29 THEN 'Wohnzone' ---- 29  residential_zone
END, ST_Force2D(perimeter_geometry)
FROM qgep_od.planning_zone;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'planungszone'
FROM
   vsa_dss_2015_2_d.planungszone a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.versickerungsbereich
(
t_id, versickerungsmoeglichkeit, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('versickerungsbereich', obj_id),
CASE WHEN infiltration_capacity = 371 THEN 'gut' ---- 371  good
WHEN infiltration_capacity = 374 THEN 'keine' ---- 374  none
WHEN infiltration_capacity = 372 THEN 'maessig' ---- 372  moderate
WHEN infiltration_capacity = 373 THEN 'schlecht' ---- 373  bad
WHEN infiltration_capacity = 3073 THEN 'unbekannt' ---- 3073  unknown
WHEN infiltration_capacity = 2996 THEN 'unzulaessig' ---- 2996  not_allowed
END, ST_Force2D(perimeter_geometry)
FROM qgep_od.infiltration_zone;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'versickerungsbereich'
FROM
   vsa_dss_2015_2_d.versickerungsbereich a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.entwaesserungssystem
(
t_id, art, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('entwaesserungssystem', obj_id),
CASE WHEN kind = 4783 THEN 'Melioration' ---- 4783  amelioration
WHEN kind = 2722 THEN 'Mischsystem' ---- 2722  mixed_system
WHEN kind = 2724 THEN 'ModifiziertesSystem' ---- 2724  modified_system
WHEN kind = 4544 THEN 'nicht_angeschlossen' ---- 4544  not_connected
WHEN kind = 2723 THEN 'Trennsystem' ---- 2723  separated_system
WHEN kind = 3060 THEN 'unbekannt' ---- 3060  unknown
END, ST_Force2D(perimeter_geometry)
FROM qgep_od.drainage_system;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'entwaesserungssystem'
FROM
   vsa_dss_2015_2_d.entwaesserungssystem a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.gewaesserschutzbereich
(
t_id, art, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserschutzbereich', obj_id),
CASE WHEN kind = 430 THEN 'A' ---- 430  A
WHEN kind = 3652 THEN 'Ao' ---- 3652  Ao
WHEN kind = 3649 THEN 'Au' ---- 3649  Au
WHEN kind = 431 THEN 'B' ---- 431  B
WHEN kind = 432 THEN 'C' ---- 432  C
WHEN kind = 3069 THEN 'unbekannt' ---- 3069  unknown
WHEN kind = 3651 THEN 'Zo' ---- 3651  Zo
WHEN kind = 3650 THEN 'Zu' ---- 3650  Zu
END, ST_Force2D(perimeter_geometry)
FROM qgep_od.water_body_protection_sector;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'gewaesserschutzbereich'
FROM
   vsa_dss_2015_2_d.gewaesserschutzbereich a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.grundwasserschutzareal
(
t_id, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('grundwasserschutzareal', obj_id), ST_Force2D(perimeter_geometry)
FROM qgep_od.ground_water_protection_perimeter;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'grundwasserschutzareal'
FROM
   vsa_dss_2015_2_d.grundwasserschutzareal a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.grundwasserschutzzone
(
t_id, art, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('grundwasserschutzzone', obj_id),
CASE WHEN kind = 440 THEN 'S1' ---- 440  S1
WHEN kind = 441 THEN 'S2' ---- 441  S2
WHEN kind = 442 THEN 'S3' ---- 442  S3
WHEN kind = 3040 THEN 'unbekannt' ---- 3040  unknown
END, ST_Force2D(perimeter_geometry)
FROM qgep_od.groundwater_protection_zone;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'grundwasserschutzzone'
FROM
   vsa_dss_2015_2_d.grundwasserschutzzone a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.rohrprofil
(
t_id, hoehenbreitenverhaeltnis, bezeichnung, profiltyp, bemerkung)
SELECT vsa_dss_2015_2_d.tid_lookup('rohrprofil', obj_id), height_width_ratio, identifier,
CASE WHEN profile_type = 3351 THEN 'Eiprofil' ---- 3351  egg
WHEN profile_type = 3350 THEN 'Kreisprofil' ---- 3350  circle
WHEN profile_type = 3352 THEN 'Maulprofil' ---- 3352  mouth
WHEN profile_type = 3354 THEN 'offenes_Profil' ---- 3354  open
WHEN profile_type = 3353 THEN 'Rechteckprofil' ---- 3353  rectangular
WHEN profile_type = 3355 THEN 'Spezialprofil' ---- 3355  special
WHEN profile_type = 3357 THEN 'unbekannt' ---- 3357  unknown
END, remark
FROM qgep_od.pipe_profile;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('rohrprofil', qgep_od.pipe_profile.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_pipe_profile.last_modification, vsa_dss_2015_2_d.tid_lookup('rohrprofil', qgep_od.pipe_profile.obj_id)
FROM qgep_od.pipe_profile
   LEFT JOIN qgep_od.organisation as a ON od_pipe_profile.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_pipe_profile.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.araenergienutzung
(
t_id, gasmotor, waermepumpe, bezeichnung, bemerkung, turbinierung, abwasserreinigungsanlageref)
SELECT vsa_dss_2015_2_d.tid_lookup('araenergienutzung', obj_id), gas_motor, heat_pump, identifier, remark, turbining, vsa_dss_2015_2_d.tid_lookup('Abwasserreinigungsanlage', fk_waste_water_treatment_plant)
FROM qgep_od.wwtp_energy_use;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('araenergienutzung', qgep_od.wwtp_energy_use.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_wwtp_energy_use.last_modification, vsa_dss_2015_2_d.tid_lookup('araenergienutzung', qgep_od.wwtp_energy_use.obj_id)
FROM qgep_od.wwtp_energy_use
   LEFT JOIN qgep_od.organisation as a ON od_wwtp_energy_use.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_wwtp_energy_use.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.abwasserbehandlung
(
t_id, bezeichnung, art, bemerkung, abwasserreinigungsanlageref)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserbehandlung', obj_id), identifier,
CASE WHEN kind = 3210 THEN 'andere' ---- 3210  other
WHEN kind = 387 THEN 'biologisch' ---- 387  biological
WHEN kind = 388 THEN 'chemisch' ---- 388  chemical
WHEN kind = 389 THEN 'Filtration' ---- 389  filtration
WHEN kind = 366 THEN 'mechanisch' ---- 366  mechanical
WHEN kind = 3076 THEN 'unbekannt' ---- 3076  unknown
END, remark, vsa_dss_2015_2_d.tid_lookup('Abwasserreinigungsanlage', fk_waste_water_treatment_plant)
FROM qgep_od.waste_water_treatment;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserbehandlung', qgep_od.waste_water_treatment.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_waste_water_treatment.last_modification, vsa_dss_2015_2_d.tid_lookup('abwasserbehandlung', qgep_od.waste_water_treatment.obj_id)
FROM qgep_od.waste_water_treatment
   LEFT JOIN qgep_od.organisation as a ON od_waste_water_treatment.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_waste_water_treatment.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.schlammbehandlung
(
t_id, kompostierung, entwaesserung, faulschlammverbrennung, trocknung, frischschlammverbrennung, hygienisierung, bezeichnung, ueberschusschlammvoreindickung, mischschlammvoreindickung, primaerschlammvoreindickung, bemerkung, stabilisierung, entwaessertklaerschlammstapelung, fluessigklaerschlammstapelung, abwasserreinigungsanlageref)
SELECT vsa_dss_2015_2_d.tid_lookup('schlammbehandlung', obj_id), composting, dehydration, digested_sludge_combustion, drying, fresh_sludge_combustion, hygenisation, identifier, predensification_of_excess_sludge, predensification_of_mixed_sludge, predensification_of_primary_sludge, remark,
CASE WHEN stabilisation = 141 THEN 'aerobkalt' ---- 141  aerob_cold
WHEN stabilisation = 332 THEN 'aerobthermophil' ---- 332  aerobthermophil
WHEN stabilisation = 333 THEN 'anaerobkalt' ---- 333  anaerob_cold
WHEN stabilisation = 334 THEN 'anaerobmesophil' ---- 334  anaerob_mesophil
WHEN stabilisation = 335 THEN 'anaerobthermophil' ---- 335  anaerob_thermophil
WHEN stabilisation = 2994 THEN 'andere' ---- 2994  other
WHEN stabilisation = 3004 THEN 'unbekannt' ---- 3004  unknown
END, stacking_of_dehydrated_sludge, stacking_of_liquid_sludge, vsa_dss_2015_2_d.tid_lookup('Abwasserreinigungsanlage', fk_waste_water_treatment_plant)
FROM qgep_od.sludge_treatment;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('schlammbehandlung', qgep_od.sludge_treatment.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_sludge_treatment.last_modification, vsa_dss_2015_2_d.tid_lookup('schlammbehandlung', qgep_od.sludge_treatment.obj_id)
FROM qgep_od.sludge_treatment
   LEFT JOIN qgep_od.organisation as a ON od_sludge_treatment.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_sludge_treatment.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.steuerungszentrale
(
t_id, bezeichnung, lage)
SELECT vsa_dss_2015_2_d.tid_lookup('steuerungszentrale', obj_id), identifier, ST_Force2D(situation_geometry)
FROM qgep_od.control_center;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('steuerungszentrale', qgep_od.control_center.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_control_center.last_modification, vsa_dss_2015_2_d.tid_lookup('steuerungszentrale', qgep_od.control_center.obj_id)
FROM qgep_od.control_center
   LEFT JOIN qgep_od.organisation as a ON od_control_center.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_control_center.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.gewaesserverbauung
(
t_id, bezeichnung, bemerkung, lage, gewaesserabschnittref)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserverbauung', obj_id), identifier, remark, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Gewaesserabschnitt', fk_water_course_segment)
FROM qgep_od.water_control_structure;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserverbauung', qgep_od.water_control_structure.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_water_control_structure.last_modification, vsa_dss_2015_2_d.tid_lookup('gewaesserverbauung', qgep_od.water_control_structure.obj_id)
FROM qgep_od.water_control_structure
   LEFT JOIN qgep_od.organisation as a ON od_water_control_structure.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_water_control_structure.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.furt
(
t_id)
SELECT vsa_dss_2015_2_d.tid_lookup('furt', obj_id)
FROM qgep_od.ford;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'furt'
FROM
   vsa_dss_2015_2_d.furt a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.gewaesserabsturz
(
t_id, typ, material, absturzhoehe)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserabsturz', obj_id),
CASE WHEN kind = 3591 THEN 'kuenstlich' ---- 3591  artificial
WHEN kind = 3592 THEN 'natuerlich' ---- 3592  natural
WHEN kind = 3593 THEN 'unbekannt' ---- 3593  unknown
END,
CASE WHEN material = 2633 THEN 'andere' ---- 2633  other
WHEN material = 409 THEN 'Beton_Steinpflaesterung' ---- 409  concrete_or_rock_pavement
WHEN material = 411 THEN 'Fels_Steinbloecke' ---- 411  rocks_or_boulders
WHEN material = 408 THEN 'Holz' ---- 408  wood
WHEN material = 410 THEN 'natuerlich_kein' ---- 410  natural_none
WHEN material = 3061 THEN 'unbekannt' ---- 3061  unknown
END, vertical_drop
FROM qgep_od.chute;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'gewaesserabsturz'
FROM
   vsa_dss_2015_2_d.gewaesserabsturz a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.schleuse
(
t_id, absturzhoehe)
SELECT vsa_dss_2015_2_d.tid_lookup('schleuse', obj_id), vertical_drop
FROM qgep_od.lock;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'schleuse'
FROM
   vsa_dss_2015_2_d.schleuse a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.durchlass
(
t_id)
SELECT vsa_dss_2015_2_d.tid_lookup('durchlass', obj_id)
FROM qgep_od.passage;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'durchlass'
FROM
   vsa_dss_2015_2_d.durchlass a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.geschiebesperre
(
t_id, absturzhoehe)
SELECT vsa_dss_2015_2_d.tid_lookup('geschiebesperre', obj_id), vertical_drop
FROM qgep_od.blocking_debris;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'geschiebesperre'
FROM
   vsa_dss_2015_2_d.geschiebesperre a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.gewaesserwehr
(
t_id, art, absturzhoehe)
SELECT vsa_dss_2015_2_d.tid_lookup('gewaesserwehr', obj_id),
CASE WHEN kind = 416 THEN 'Stauwehr' ---- 416  retaining_weir
WHEN kind = 417 THEN 'Streichwehr' ---- 417  spillway
WHEN kind = 419 THEN 'Talsperre' ---- 419  dam
WHEN kind = 418 THEN 'Tirolerwehr' ---- 418  tyrolean_weir
WHEN kind = 3064 THEN 'unbekannt' ---- 3064  unknown
END, vertical_drop
FROM qgep_od.dam;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'gewaesserwehr'
FROM
   vsa_dss_2015_2_d.gewaesserwehr a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.sohlrampe
(
t_id, befestigung, absturzhoehe)
SELECT vsa_dss_2015_2_d.tid_lookup('sohlrampe', obj_id),
CASE WHEN stabilisation = 2635 THEN 'andere_glatt' ---- 2635  other_smooth
WHEN stabilisation = 2634 THEN 'andere_rauh' ---- 2634  other_rough
WHEN stabilisation = 415 THEN 'Betonrinne' ---- 415  concrete_channel
WHEN stabilisation = 412 THEN 'Blockwurf' ---- 412  rocks_or_boulders
WHEN stabilisation = 413 THEN 'gepflaestert' ---- 413  paved
WHEN stabilisation = 414 THEN 'Holzbalken' ---- 414  wooden_beam
WHEN stabilisation = 3063 THEN 'unbekannt' ---- 3063  unknown
END, vertical_drop
FROM qgep_od.rock_ramp;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'sohlrampe'
FROM
   vsa_dss_2015_2_d.sohlrampe a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.fischpass
(
t_id, bezeichnung, bemerkung, absturzhoehe, gewaesserverbauungref)
SELECT vsa_dss_2015_2_d.tid_lookup('fischpass', obj_id), identifier, remark, vertical_drop, vsa_dss_2015_2_d.tid_lookup('Gewaesserverbauung', fk_water_control_structure)
FROM qgep_od.fish_pass;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('fischpass', qgep_od.fish_pass.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_fish_pass.last_modification, vsa_dss_2015_2_d.tid_lookup('fischpass', qgep_od.fish_pass.obj_id)
FROM qgep_od.fish_pass
   LEFT JOIN qgep_od.organisation as a ON od_fish_pass.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_fish_pass.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.badestelle
(
t_id, bezeichnung, bemerkung, lage, oberflaechengewaesserref)
SELECT vsa_dss_2015_2_d.tid_lookup('badestelle', obj_id), identifier, remark, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Oberflaechengewaesser', fk_chute)
FROM qgep_od.bathing_area;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('badestelle', qgep_od.bathing_area.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_bathing_area.last_modification, vsa_dss_2015_2_d.tid_lookup('badestelle', qgep_od.bathing_area.obj_id)
FROM qgep_od.bathing_area
   LEFT JOIN qgep_od.organisation as a ON od_bathing_area.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_bathing_area.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.hydr_geometrie
(
t_id, bezeichnung, bemerkung, stauraum, nutzinhalt_fangteil, nutzinhalt_klaerteil, nutzinhalt, volumen_pumpensumpf)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_geometrie', obj_id), identifier, remark, storage_volume, usable_capacity_storage, usable_capacity_treatment, utilisable_capacity, volume_pump_sump
FROM qgep_od.hydr_geometry;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_geometrie', qgep_od.hydr_geometry.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_hydr_geometry.last_modification, vsa_dss_2015_2_d.tid_lookup('hydr_geometrie', qgep_od.hydr_geometry.obj_id)
FROM qgep_od.hydr_geometry
   LEFT JOIN qgep_od.organisation as a ON od_hydr_geometry.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_hydr_geometry.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.abwassernetzelement
(
t_id, bezeichnung, bemerkung, abwasserbauwerkref)
SELECT vsa_dss_2015_2_d.tid_lookup('abwassernetzelement', obj_id), identifier, remark, vsa_dss_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure)
FROM qgep_od.wastewater_networkelement;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('abwassernetzelement', qgep_od.wastewater_networkelement.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_wastewater_networkelement.last_modification, vsa_dss_2015_2_d.tid_lookup('abwassernetzelement', qgep_od.wastewater_networkelement.obj_id)
FROM qgep_od.wastewater_networkelement
   LEFT JOIN qgep_od.organisation as a ON od_wastewater_networkelement.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_wastewater_networkelement.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.haltungspunkt
(
t_id, hoehengenauigkeit, bezeichnung, kote, auslaufform, lage_anschluss, bemerkung, lage, abwassernetzelementref)
SELECT vsa_dss_2015_2_d.tid_lookup('haltungspunkt', obj_id),
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
END, position_of_connection, remark, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement)
FROM qgep_od.reach_point;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('haltungspunkt', qgep_od.reach_point.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_reach_point.last_modification, vsa_dss_2015_2_d.tid_lookup('haltungspunkt', qgep_od.reach_point.obj_id)
FROM qgep_od.reach_point
   LEFT JOIN qgep_od.organisation as a ON od_reach_point.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_reach_point.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.abwasserknoten
(
t_id, rueckstaukote, sohlenkote, lage, hydr_geometrieref)
SELECT vsa_dss_2015_2_d.tid_lookup('abwasserknoten', obj_id), backflow_level, bottom_level, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Hydr_Geometrie', fk_hydr_geometry)
FROM qgep_od.wastewater_node;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'abwasserknoten'
FROM
   vsa_dss_2015_2_d.abwasserknoten a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.haltung
(
t_id, lichte_hoehe, reibungsbeiwert, lagebestimmung, innenschutz, laengeeffektiv, material, verlauf, reliner_material, reliner_nennweite, reliner_bautechnik, reliner_art, ringsteifigkeit, plangefaelle, wandrauhigkeit, vonhaltungspunktref, nachhaltungspunktref, rohrprofilref)
SELECT vsa_dss_2015_2_d.tid_lookup('haltung', obj_id), clear_height, coefficient_of_friction,
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
END, ST_Force2D(progression_geometry),
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
END, ring_stiffness, slope_building_plan, wall_roughness, vsa_dss_2015_2_d.tid_lookup('Haltungspunkt', fk_reach_point_from), vsa_dss_2015_2_d.tid_lookup('Haltungspunkt', fk_reach_point_to), vsa_dss_2015_2_d.tid_lookup('Rohrprofil', fk_pipe_profile)
FROM qgep_od.reach;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'haltung'
FROM
   vsa_dss_2015_2_d.haltung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.rohrprofil_geometrie
(
t_id, aposition, x, y, rohrprofilref)
SELECT vsa_dss_2015_2_d.tid_lookup('rohrprofil_geometrie', obj_id), position, x, y, vsa_dss_2015_2_d.tid_lookup('Rohrprofil', fk_pipe_profile)
FROM qgep_od.profile_geometry;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('rohrprofil_geometrie', qgep_od.profile_geometry.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_profile_geometry.last_modification, vsa_dss_2015_2_d.tid_lookup('rohrprofil_geometrie', qgep_od.profile_geometry.obj_id)
FROM qgep_od.profile_geometry
   LEFT JOIN qgep_od.organisation as a ON od_profile_geometry.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_profile_geometry.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.hydr_geomrelation
(
t_id, wassertiefe, wasseroberflaeche, benetztequerschnittsflaeche, hydr_geometrieref)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_geomrelation', obj_id), water_depth, water_surface, wet_cross_section_area, vsa_dss_2015_2_d.tid_lookup('Hydr_Geometrie', fk_hydr_geometry)
FROM qgep_od.hydr_geom_relation;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_geomrelation', qgep_od.hydr_geom_relation.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_hydr_geom_relation.last_modification, vsa_dss_2015_2_d.tid_lookup('hydr_geomrelation', qgep_od.hydr_geom_relation.obj_id)
FROM qgep_od.hydr_geom_relation
   LEFT JOIN qgep_od.organisation as a ON od_hydr_geom_relation.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_hydr_geom_relation.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.mechanischevorreinigung
(
t_id, bezeichnung, art, bemerkung, versickerungsanlageref, abwasserbauwerkref)
SELECT vsa_dss_2015_2_d.tid_lookup('mechanischevorreinigung', obj_id), identifier,
CASE WHEN kind = 3317 THEN 'Filtersack' ---- 3317  filter_bag
WHEN kind = 3319 THEN 'KuenstlicherAdsorber' ---- 3319  artificial_adsorber
WHEN kind = 3318 THEN 'MuldenRigolenSystem' ---- 3318  swale_french_drain_system
WHEN kind = 3320 THEN 'Schlammsammler' ---- 3320  slurry_collector
WHEN kind = 3321 THEN 'Schwimmstoffabscheider' ---- 3321  floating_matter_separator
WHEN kind = 3322 THEN 'unbekannt' ---- 3322  unknown
END, remark, vsa_dss_2015_2_d.tid_lookup('Versickerungsanlage', fk_infiltration_installation), vsa_dss_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure)
FROM qgep_od.mechanical_pretreatment;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('mechanischevorreinigung', qgep_od.mechanical_pretreatment.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_mechanical_pretreatment.last_modification, vsa_dss_2015_2_d.tid_lookup('mechanischevorreinigung', qgep_od.mechanical_pretreatment.obj_id)
FROM qgep_od.mechanical_pretreatment
   LEFT JOIN qgep_od.organisation as a ON od_mechanical_pretreatment.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_mechanical_pretreatment.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.retentionskoerper
(
t_id, bezeichnung, art, bemerkung, retention_volumen, versickerungsanlageref)
SELECT vsa_dss_2015_2_d.tid_lookup('retentionskoerper', obj_id), identifier,
CASE WHEN kind = 2992 THEN 'andere' ---- 2992  other
WHEN kind = 346 THEN 'Biotop' ---- 346  retention_in_habitat
WHEN kind = 345 THEN 'Dachretention' ---- 345  roof_retention
WHEN kind = 348 THEN 'Parkplatz' ---- 348  parking_lot
WHEN kind = 347 THEN 'Staukanal' ---- 347  accumulation_channel
WHEN kind = 3031 THEN 'unbekannt' ---- 3031  unknown
END, remark, volume, vsa_dss_2015_2_d.tid_lookup('Versickerungsanlage', fk_infiltration_installation)
FROM qgep_od.retention_body;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('retentionskoerper', qgep_od.retention_body.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_retention_body.last_modification, vsa_dss_2015_2_d.tid_lookup('retentionskoerper', qgep_od.retention_body.obj_id)
FROM qgep_od.retention_body
   LEFT JOIN qgep_od.organisation as a ON od_retention_body.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_retention_body.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.ueberlaufcharakteristik
(
t_id, bezeichnung, kennlinie_typ, kennlinie_digital, bemerkung)
SELECT vsa_dss_2015_2_d.tid_lookup('ueberlaufcharakteristik', obj_id), identifier,
CASE WHEN kind_overflow_characteristic = 6220 THEN 'HQ' ---- 6220  hq
WHEN kind_overflow_characteristic = 6221 THEN 'QQ' ---- 6221  qq
WHEN kind_overflow_characteristic = 6228 THEN 'unbekannt' ---- 6228  unknown
END,
CASE WHEN overflow_characteristic_digital = 6223 THEN 'ja' ---- 6223  yes
WHEN overflow_characteristic_digital = 6224 THEN 'nein' ---- 6224  no
WHEN overflow_characteristic_digital = 6225 THEN 'unbekannt' ---- 6225  unknown
END, remark
FROM qgep_od.overflow_characteristic;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('ueberlaufcharakteristik', qgep_od.overflow_characteristic.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_overflow_characteristic.last_modification, vsa_dss_2015_2_d.tid_lookup('ueberlaufcharakteristik', qgep_od.overflow_characteristic.obj_id)
FROM qgep_od.overflow_characteristic
   LEFT JOIN qgep_od.organisation as a ON od_overflow_characteristic.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_overflow_characteristic.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.hq_relation
(
t_id, hoehe, abfluss, zufluss, ueberlaufcharakteristikref)
SELECT vsa_dss_2015_2_d.tid_lookup('hq_relation', obj_id), altitude, flow, flow_from, vsa_dss_2015_2_d.tid_lookup('Ueberlaufcharakteristik', fk_overflow_characteristic)
FROM qgep_od.hq_relation;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('hq_relation', qgep_od.hq_relation.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_hq_relation.last_modification, vsa_dss_2015_2_d.tid_lookup('hq_relation', qgep_od.hq_relation.obj_id)
FROM qgep_od.hq_relation
   LEFT JOIN qgep_od.organisation as a ON od_hq_relation.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_hq_relation.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.bauwerksteil
(
t_id, bezeichnung, bemerkung, instandstellung, abwasserbauwerkref)
SELECT vsa_dss_2015_2_d.tid_lookup('bauwerksteil', obj_id), identifier, remark,
CASE WHEN renovation_demand = 138 THEN 'nicht_notwendig' ---- 138  not_necessary
WHEN renovation_demand = 137 THEN 'notwendig' ---- 137  necessary
WHEN renovation_demand = 5358 THEN 'unbekannt' ---- 5358  unknown
END, vsa_dss_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure)
FROM qgep_od.structure_part;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('bauwerksteil', qgep_od.structure_part.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_structure_part.last_modification, vsa_dss_2015_2_d.tid_lookup('bauwerksteil', qgep_od.structure_part.obj_id)
FROM qgep_od.structure_part
   LEFT JOIN qgep_od.organisation as a ON od_structure_part.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_structure_part.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.trockenwetterfallrohr
(
t_id, durchmesser)
SELECT vsa_dss_2015_2_d.tid_lookup('trockenwetterfallrohr', obj_id), diameter
FROM qgep_od.dryweather_downspout;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'trockenwetterfallrohr'
FROM
   vsa_dss_2015_2_d.trockenwetterfallrohr a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.einstiegshilfe
(
t_id, art)
SELECT vsa_dss_2015_2_d.tid_lookup('einstiegshilfe', obj_id),
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

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'einstiegshilfe'
FROM
   vsa_dss_2015_2_d.einstiegshilfe a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.trockenwetterrinne
(
t_id, material)
SELECT vsa_dss_2015_2_d.tid_lookup('trockenwetterrinne', obj_id),
CASE WHEN material = 3221 THEN 'andere' ---- 3221  other
WHEN material = 354 THEN 'kombiniert' ---- 354  combined
WHEN material = 5356 THEN 'Kunststoff' ---- 5356  plastic
WHEN material = 238 THEN 'Steinzeug' ---- 238  stoneware
WHEN material = 3017 THEN 'unbekannt' ---- 3017  unknown
WHEN material = 237 THEN 'Zementmoertel' ---- 237  cement_mortar
END
FROM qgep_od.dryweather_flume;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'trockenwetterrinne'
FROM
   vsa_dss_2015_2_d.trockenwetterrinne a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.deckel
(
t_id, fabrikat, deckelform, durchmesser, verschluss, kote, material, lagegenauigkeit, lage, schlammeimer, entlueftung)
SELECT vsa_dss_2015_2_d.tid_lookup('deckel', obj_id), brand,
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
END, ST_Force2D(situation_geometry),
CASE WHEN sludge_bucket = 423 THEN 'nicht_vorhanden' ---- 423  inexistent
WHEN sludge_bucket = 3066 THEN 'unbekannt' ---- 3066  unknown
WHEN sludge_bucket = 422 THEN 'vorhanden' ---- 422  existent
END,
CASE WHEN venting = 229 THEN 'entlueftet' ---- 229  vented
WHEN venting = 230 THEN 'nicht_entlueftet' ---- 230  not_vented
WHEN venting = 5348 THEN 'unbekannt' ---- 5348  unknown
END
FROM qgep_od.cover;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'deckel'
FROM
   vsa_dss_2015_2_d.deckel a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.elektrischeeinrichtung
(
t_id, bruttokosten, art, ersatzjahr)
SELECT vsa_dss_2015_2_d.tid_lookup('elektrischeeinrichtung', obj_id), gross_costs,
CASE WHEN kind = 2980 THEN 'andere' ---- 2980  other
WHEN kind = 376 THEN 'Beleuchtung' ---- 376  illumination
WHEN kind = 3255 THEN 'Fernwirkanlage' ---- 3255  remote_control_system
WHEN kind = 378 THEN 'Funk' ---- 378  radio_unit
WHEN kind = 377 THEN 'Telephon' ---- 377  phone
WHEN kind = 3038 THEN 'unbekannt' ---- 3038  unknown
END, year_of_replacement
FROM qgep_od.electric_equipment;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'elektrischeeinrichtung'
FROM
   vsa_dss_2015_2_d.elektrischeeinrichtung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.elektromechanischeausruestung
(
t_id, bruttokosten, art, ersatzjahr)
SELECT vsa_dss_2015_2_d.tid_lookup('elektromechanischeausruestung', obj_id), gross_costs,
CASE WHEN kind = 2981 THEN 'andere' ---- 2981  other
WHEN kind = 380 THEN 'Leckwasserpumpe' ---- 380  leakage_water_pump
WHEN kind = 337 THEN 'Luftentfeuchter' ---- 337  air_dehumidifier
WHEN kind = 381 THEN 'Raeumeinrichtung' ---- 381  scraper_installation
WHEN kind = 3072 THEN 'unbekannt' ---- 3072  unknown
END, year_of_replacement
FROM qgep_od.electromechanical_equipment;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'elektromechanischeausruestung'
FROM
   vsa_dss_2015_2_d.elektromechanischeausruestung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.bankett
(
t_id, art)
SELECT vsa_dss_2015_2_d.tid_lookup('bankett', obj_id),
CASE WHEN kind = 5319 THEN 'andere' ---- 5319  other
WHEN kind = 94 THEN 'beidseitig' ---- 94  double_sided
WHEN kind = 93 THEN 'einseitig' ---- 93  one_sided
WHEN kind = 3231 THEN 'kein' ---- 3231  none
WHEN kind = 3033 THEN 'unbekannt' ---- 3033  unknown
END
FROM qgep_od.benching;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'bankett'
FROM
   vsa_dss_2015_2_d.bankett a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.anschlussobjekt
(
t_id, bezeichnung, bemerkung, fremdwasseranfall, abwassernetzelementref, eigentuemerref, betreiberref)
SELECT vsa_dss_2015_2_d.tid_lookup('anschlussobjekt', obj_id), identifier, remark, sewer_infiltration_water_production, vsa_dss_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement), vsa_dss_2015_2_d.tid_lookup('Organisation', fk_owner), vsa_dss_2015_2_d.tid_lookup('Organisation', fk_operator)
FROM qgep_od.connection_object;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('anschlussobjekt', qgep_od.connection_object.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_connection_object.last_modification, vsa_dss_2015_2_d.tid_lookup('anschlussobjekt', qgep_od.connection_object.obj_id)
FROM qgep_od.connection_object
   LEFT JOIN qgep_od.organisation as a ON od_connection_object.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_connection_object.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.gebaeude
(
t_id, hausnummer, standortname, perimeter, referenzpunkt)
SELECT vsa_dss_2015_2_d.tid_lookup('gebaeude', obj_id), house_number, location_name, ST_Force2D(perimeter_geometry), ST_Force2D(reference_point_geometry)
FROM qgep_od.building;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'gebaeude'
FROM
   vsa_dss_2015_2_d.gebaeude a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.reservoir
(
t_id, standortname, lage)
SELECT vsa_dss_2015_2_d.tid_lookup('reservoir', obj_id), location_name, ST_Force2D(situation_geometry)
FROM qgep_od.reservoir;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'reservoir'
FROM
   vsa_dss_2015_2_d.reservoir a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.einzelflaeche
(
t_id, funktion, neigung, befestigung, perimeter)
SELECT vsa_dss_2015_2_d.tid_lookup('einzelflaeche', obj_id),
CASE WHEN function = 2979 THEN 'andere' ---- 2979  other
WHEN function = 3466 THEN 'Bahnanlagen' ---- 3466  railway_site
WHEN function = 3461 THEN 'DachflaecheIndustrieundGewerbebetriebe' ---- 3461  roof_industrial_or_commercial_building
WHEN function = 3460 THEN 'DachflaecheWohnundBuerogebaeude' ---- 3460  roof_residential_or_office_building
WHEN function = 3464 THEN 'Erschliessungs_Sammelstrassen' ---- 3464  access_or_collecting_road
WHEN function = 3467 THEN 'Parkplaetze' ---- 3467  parking_lot
WHEN function = 3462 THEN 'UmschlagundLagerplaetze' ---- 3462  transfer_site_or_stockyard
WHEN function = 3029 THEN 'unbekannt' ---- 3029  unknown
WHEN function = 3465 THEN 'Verbindungs_Hauptverkehrs_Hochleistungsstrassen' ---- 3465  connecting_or_principal_or_major_road
WHEN function = 3463 THEN 'VorplaetzeZufahrten' ---- 3463  forecourt_and_access_road
END, inclination,
CASE WHEN pavement = 2978 THEN 'andere' ---- 2978  other
WHEN pavement = 2031 THEN 'befestigt' ---- 2031  paved
WHEN pavement = 2032 THEN 'bestockt' ---- 2032  forested
WHEN pavement = 2033 THEN 'humusiert' ---- 2033  soil_covered
WHEN pavement = 3030 THEN 'unbekannt' ---- 3030  unknown
WHEN pavement = 2034 THEN 'vegetationslos' ---- 2034  barren
END, ST_Force2D(perimeter_geometry)
FROM qgep_od.individual_surface;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'einzelflaeche'
FROM
   vsa_dss_2015_2_d.einzelflaeche a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.brunnen
(
t_id, standortname, lage)
SELECT vsa_dss_2015_2_d.tid_lookup('brunnen', obj_id), location_name, ST_Force2D(situation_geometry)
FROM qgep_od.fountain;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'brunnen'
FROM
   vsa_dss_2015_2_d.brunnen a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.gefahrenquelle
(
t_id, bezeichnung, bemerkung, lage, anschlussobjektref, eigentuemerref)
SELECT vsa_dss_2015_2_d.tid_lookup('gefahrenquelle', obj_id), identifier, remark, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Anschlussobjekt', fk_connection_object), vsa_dss_2015_2_d.tid_lookup('Organisation', fk_owner)
FROM qgep_od.hazard_source;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('gefahrenquelle', qgep_od.hazard_source.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_hazard_source.last_modification, vsa_dss_2015_2_d.tid_lookup('gefahrenquelle', qgep_od.hazard_source.obj_id)
FROM qgep_od.hazard_source
   LEFT JOIN qgep_od.organisation as a ON od_hazard_source.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_hazard_source.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.unfall
(
t_id, datum, bezeichnung, ort, bemerkung, verursacher, lage, gefahrenquelleref)
SELECT vsa_dss_2015_2_d.tid_lookup('unfall', obj_id), date, identifier, place, remark, responsible, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Gefahrenquelle', fk_hazard_source)
FROM qgep_od.accident;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('unfall', qgep_od.accident.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_accident.last_modification, vsa_dss_2015_2_d.tid_lookup('unfall', qgep_od.accident.obj_id)
FROM qgep_od.accident
   LEFT JOIN qgep_od.organisation as a ON od_accident.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_accident.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.stoff
(
t_id, bezeichnung, art, bemerkung, lagerung, gefahrenquelleref)
SELECT vsa_dss_2015_2_d.tid_lookup('stoff', obj_id), identifier, kind, remark, stockage, vsa_dss_2015_2_d.tid_lookup('Gefahrenquelle', fk_hazard_source)
FROM qgep_od.substance;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('stoff', qgep_od.substance.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_substance.last_modification, vsa_dss_2015_2_d.tid_lookup('stoff', qgep_od.substance.obj_id)
FROM qgep_od.substance
   LEFT JOIN qgep_od.organisation as a ON od_substance.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_substance.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.einzugsgebiet
(
t_id, direkteinleitung_in_gewaesser_ist, direkteinleitung_in_gewaesser_geplant, abflussbeiwert_rw_ist, abflussbeiwert_rw_geplant, abflussbeiwert_sw_ist, abflussbeiwert_sw_geplant, entwaesserungssystem_ist, entwaesserungssystem_geplant, bezeichnung, versickerung_ist, versickerung_geplant, perimeter, einwohnerdichte_ist, einwohnerdichte_geplant, bemerkung, retention_ist, retention_geplant, abflussbegrenzung_ist, abflussbegrenzung_geplant, befestigungsgrad_rw_ist, befestigungsgrad_rw_geplant, befestigungsgrad_sw_ist, befestigungsgrad_sw_geplant, fremdwasseranfall_ist, fremdwasseranfall_geplant, flaeche, schmutzabwasseranfall_ist, schmutzabwasseranfall_geplant, abwassernetzelement_rw_istref, abwassernetzelement_rw_geplantref, abwassernetzelement_sw_geplantref, abwassernetzelement_sw_istref)
SELECT vsa_dss_2015_2_d.tid_lookup('einzugsgebiet', obj_id),
CASE WHEN direct_discharge_current = 5457 THEN 'ja' ---- 5457  yes
WHEN direct_discharge_current = 5458 THEN 'nein' ---- 5458  no
WHEN direct_discharge_current = 5463 THEN 'unbekannt' ---- 5463  unknown
END,
CASE WHEN direct_discharge_planned = 5459 THEN 'ja' ---- 5459  yes
WHEN direct_discharge_planned = 5460 THEN 'nein' ---- 5460  no
WHEN direct_discharge_planned = 5464 THEN 'unbekannt' ---- 5464  unknown
END, discharge_coefficient_rw_current, discharge_coefficient_rw_planned, discharge_coefficient_ww_current, discharge_coefficient_ww_planned,
CASE WHEN drainage_system_current = 5186 THEN 'Mischsystem' ---- 5186  mixed_system
WHEN drainage_system_current = 5188 THEN 'ModifiziertesSystem' ---- 5188  modified_system
WHEN drainage_system_current = 5185 THEN 'nicht_angeschlossen' ---- 5185  not_connected
WHEN drainage_system_current = 5537 THEN 'nicht_entwaessert' ---- 5537  not_drained
WHEN drainage_system_current = 5187 THEN 'Trennsystem' ---- 5187  separated_system
WHEN drainage_system_current = 5189 THEN 'unbekannt' ---- 5189  unknown
END,
CASE WHEN drainage_system_planned = 5191 THEN 'Mischsystem' ---- 5191  mixed_system
WHEN drainage_system_planned = 5193 THEN 'ModifiziertesSystem' ---- 5193  modified_system
WHEN drainage_system_planned = 5194 THEN 'nicht_angeschlossen' ---- 5194  not_connected
WHEN drainage_system_planned = 5536 THEN 'nicht_entwaessert' ---- 5536  not_drained
WHEN drainage_system_planned = 5192 THEN 'Trennsystem' ---- 5192  separated_system
WHEN drainage_system_planned = 5195 THEN 'unbekannt' ---- 5195  unknown
END, identifier,
CASE WHEN infiltration_current = 5452 THEN 'ja' ---- 5452  yes
WHEN infiltration_current = 5453 THEN 'nein' ---- 5453  no
WHEN infiltration_current = 5165 THEN 'unbekannt' ---- 5165  unknown
END,
CASE WHEN infiltration_planned = 5461 THEN 'ja' ---- 5461  yes
WHEN infiltration_planned = 5462 THEN 'nein' ---- 5462  no
WHEN infiltration_planned = 5170 THEN 'unbekannt' ---- 5170  unknown
END, ST_Force2D(perimeter_geometry), population_density_current, population_density_planned, remark,
CASE WHEN retention_current = 5467 THEN 'ja' ---- 5467  yes
WHEN retention_current = 5468 THEN 'nein' ---- 5468  no
WHEN retention_current = 5469 THEN 'unbekannt' ---- 5469  unknown
END,
CASE WHEN retention_planned = 5470 THEN 'ja' ---- 5470  yes
WHEN retention_planned = 5471 THEN 'nein' ---- 5471  no
WHEN retention_planned = 5472 THEN 'unbekannt' ---- 5472  unknown
END, runoff_limit_current, runoff_limit_planned, seal_factor_rw_current, seal_factor_rw_planned, seal_factor_ww_current, seal_factor_ww_planned, sewer_infiltration_water_production_current, sewer_infiltration_water_production_planned, surface_area, waste_water_production_current, waste_water_production_planned, vsa_dss_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement_rw_current), vsa_dss_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement_rw_planned), vsa_dss_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement_ww_planned), vsa_dss_2015_2_d.tid_lookup('Abwassernetzelement', fk_wastewater_networkelement_ww_current)
FROM qgep_od.catchment_area;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('einzugsgebiet', qgep_od.catchment_area.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_catchment_area.last_modification, vsa_dss_2015_2_d.tid_lookup('einzugsgebiet', qgep_od.catchment_area.obj_id)
FROM qgep_od.catchment_area
   LEFT JOIN qgep_od.organisation as a ON od_catchment_area.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_catchment_area.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.oberflaechenabflussparameter
(
t_id, verdunstungsverlust, bezeichnung, versickerungsverlust, bemerkung, muldenverlust, benetzungsverlust, einzugsgebietref)
SELECT vsa_dss_2015_2_d.tid_lookup('oberflaechenabflussparameter', obj_id), evaporation_loss, identifier, infiltration_loss, remark, surface_storage, wetting_loss, vsa_dss_2015_2_d.tid_lookup('Einzugsgebiet', fk_catchment_area)
FROM qgep_od.surface_runoff_parameters;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('oberflaechenabflussparameter', qgep_od.surface_runoff_parameters.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_surface_runoff_parameters.last_modification, vsa_dss_2015_2_d.tid_lookup('oberflaechenabflussparameter', qgep_od.surface_runoff_parameters.obj_id)
FROM qgep_od.surface_runoff_parameters
   LEFT JOIN qgep_od.organisation as a ON od_surface_runoff_parameters.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_surface_runoff_parameters.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.messstelle
(
t_id, staukoerper, bezeichnung, art, zweck, bemerkung, lage, betreiberref, abwasserreinigungsanlageref, abwasserbauwerkref, gewaesserabschnittref)
SELECT vsa_dss_2015_2_d.tid_lookup('messstelle', obj_id),
CASE WHEN damming_device = 5720 THEN 'andere' ---- 5720  other
WHEN damming_device = 5721 THEN 'keiner' ---- 5721  none
WHEN damming_device = 5722 THEN 'Ueberfallwehr' ---- 5722  overflow_weir
WHEN damming_device = 5724 THEN 'unbekannt' ---- 5724  unknown
WHEN damming_device = 5723 THEN 'Venturieinschnuerung' ---- 5723  venturi_necking
END, identifier, kind,
CASE WHEN purpose = 4595 THEN 'beides' ---- 4595  both
WHEN purpose = 4593 THEN 'Kostenverteilung' ---- 4593  cost_sharing
WHEN purpose = 4594 THEN 'technischer_Zweck' ---- 4594  technical_purpose
WHEN purpose = 4592 THEN 'unbekannt' ---- 4592  unknown
END, remark, ST_Force2D(situation_geometry), vsa_dss_2015_2_d.tid_lookup('Organisation', fk_operator), vsa_dss_2015_2_d.tid_lookup('Abwasserreinigungsanlage', fk_waste_water_treatment_plant), vsa_dss_2015_2_d.tid_lookup('Abwasserbauwerk', fk_wastewater_structure), vsa_dss_2015_2_d.tid_lookup('Gewaesserabschnitt', fk_water_course_segment)
FROM qgep_od.measuring_point;

-- additional Table Assoc: Messstelle_Referenzstelle/ no table hierarchy in qgep schema yet (check how to implement there)
-- INSERT INTO vsa_dss_2015_2_d.Messstelle_Referenzstelleassoc
-- (
-- t_id, Referenzstelleref, Messstelle_Referenzstelleassocref)
-- SELECT vsa_dss_2015_2_d.tid_lookup('Messstelle', obj_id), vsa_dss_2015_2_d.tid_lookup('Messstelle', fk_reference_station),vsa_dss_2015_2_d.tid_lookup('Messstelle', obj_id)
-- FROM qgep_od.messstelle;


INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('messstelle', qgep_od.measuring_point.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_measuring_point.last_modification, vsa_dss_2015_2_d.tid_lookup('messstelle', qgep_od.measuring_point.obj_id)
FROM qgep_od.measuring_point
   LEFT JOIN qgep_od.organisation as a ON od_measuring_point.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_measuring_point.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.messgeraet
(
t_id, fabrikat, bezeichnung, art, bemerkung, seriennummer, messstelleref)
SELECT vsa_dss_2015_2_d.tid_lookup('messgeraet', obj_id), brand, identifier,
CASE WHEN kind = 5702 THEN 'andere' ---- 5702  other
WHEN kind = 5703 THEN 'Drucksonde' ---- 5703  static_sounding_stick
WHEN kind = 5704 THEN 'Lufteinperlung' ---- 5704  bubbler_system
WHEN kind = 5705 THEN 'MID_teilgefuellt' ---- 5705  EMF_partly_filled
WHEN kind = 5706 THEN 'MID_vollgefuellt' ---- 5706  EMF_filled
WHEN kind = 5707 THEN 'Radar' ---- 5707  radar
WHEN kind = 5708 THEN 'Schwimmer' ---- 5708  float
WHEN kind = 6322 THEN 'Ultraschall' ---- 6322  ultrasound
WHEN kind = 5709 THEN 'unbekannt' ---- 5709  unknown
END, remark, serial_number, vsa_dss_2015_2_d.tid_lookup('Messstelle', fk_measuring_point)
FROM qgep_od.measuring_device;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('messgeraet', qgep_od.measuring_device.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_measuring_device.last_modification, vsa_dss_2015_2_d.tid_lookup('messgeraet', qgep_od.measuring_device.obj_id)
FROM qgep_od.measuring_device
   LEFT JOIN qgep_od.organisation as a ON od_measuring_device.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_measuring_device.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.messreihe
(
t_id, dimension, bezeichnung, art, bemerkung, messstelleref)
SELECT vsa_dss_2015_2_d.tid_lookup('messreihe', obj_id), dimension, identifier,
CASE WHEN kind = 3217 THEN 'andere' ---- 3217  other
WHEN kind = 2646 THEN 'kontinuierlich' ---- 2646  continuous
WHEN kind = 2647 THEN 'Regenwetter' ---- 2647  rain_weather
WHEN kind = 3053 THEN 'unbekannt' ---- 3053  unknown
END, remark, vsa_dss_2015_2_d.tid_lookup('Messstelle', fk_measuring_point)
FROM qgep_od.measurement_series;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('messreihe', qgep_od.measurement_series.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_measurement_series.last_modification, vsa_dss_2015_2_d.tid_lookup('messreihe', qgep_od.measurement_series.obj_id)
FROM qgep_od.measurement_series
   LEFT JOIN qgep_od.organisation as a ON od_measurement_series.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_measurement_series.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.messresultat
(
t_id, bezeichnung, messart, messdauer, bemerkung, zeit, wert, messgeraetref, messreiheref)
SELECT vsa_dss_2015_2_d.tid_lookup('messresultat', obj_id), identifier,
CASE WHEN measurement_type = 5732 THEN 'andere' ---- 5732  other
WHEN measurement_type = 5733 THEN 'Durchfluss' ---- 5733  flow
WHEN measurement_type = 5734 THEN 'Niveau' ---- 5734  level
WHEN measurement_type = 5735 THEN 'unbekannt' ---- 5735  unknown
END, measuring_duration, remark, time, value, vsa_dss_2015_2_d.tid_lookup('Messgeraet', fk_measuring_device), vsa_dss_2015_2_d.tid_lookup('Messreihe', fk_measurement_series)
FROM qgep_od.measurement_result;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('messresultat', qgep_od.measurement_result.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_measurement_result.last_modification, vsa_dss_2015_2_d.tid_lookup('messresultat', qgep_od.measurement_result.obj_id)
FROM qgep_od.measurement_result
   LEFT JOIN qgep_od.organisation as a ON od_measurement_result.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_measurement_result.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.ueberlauf
(
t_id, antrieb, verstellbarkeit, fabrikat, steuerung, einleitstelle, funktion, bruttokosten, bezeichnung, qan_dim, bemerkung, signaluebermittlung, subventionen, abwasserknotenref, ueberlaufnachref, ueberlaufcharakteristikref, steuerungszentraleref)
SELECT vsa_dss_2015_2_d.tid_lookup('ueberlauf', obj_id),
CASE WHEN actuation = 3667 THEN 'andere' ---- 3667  other
WHEN actuation = 301 THEN 'Benzinmotor' ---- 301  gaz_engine
WHEN actuation = 302 THEN 'Dieselmotor' ---- 302  diesel_engine
WHEN actuation = 303 THEN 'Elektromotor' ---- 303  electric_engine
WHEN actuation = 433 THEN 'hydraulisch' ---- 433  hydraulic
WHEN actuation = 300 THEN 'keiner' ---- 300  none
WHEN actuation = 305 THEN 'manuell' ---- 305  manual
WHEN actuation = 304 THEN 'pneumatisch' ---- 304  pneumatic
WHEN actuation = 3005 THEN 'unbekannt' ---- 3005  unknown
END,
CASE WHEN adjustability = 355 THEN 'fest' ---- 355  fixed
WHEN adjustability = 3021 THEN 'unbekannt' ---- 3021  unknown
WHEN adjustability = 356 THEN 'verstellbar' ---- 356  adjustable
END, brand,
CASE WHEN control = 308 THEN 'geregelt' ---- 308  closed_loop_control
WHEN control = 307 THEN 'gesteuert' ---- 307  open_loop_control
WHEN control = 306 THEN 'keine' ---- 306  none
WHEN control = 3028 THEN 'unbekannt' ---- 3028  unknown
END, discharge_point,
CASE WHEN function = 3228 THEN 'andere' ---- 3228  other
WHEN function = 3384 THEN 'intern' ---- 3384  internal
WHEN function = 217 THEN 'Notentlastung' ---- 217  emergency_overflow
WHEN function = 5544 THEN 'Regenueberlauf' ---- 5544  stormwater_overflow
WHEN function = 5546 THEN 'Trennueberlauf' ---- 5546  internal_overflow
WHEN function = 3010 THEN 'unbekannt' ---- 3010  unknown
END, gross_costs, identifier, qon_dim, remark,
CASE WHEN signal_transmission = 2694 THEN 'empfangen' ---- 2694  receiving
WHEN signal_transmission = 2693 THEN 'senden' ---- 2693  sending
WHEN signal_transmission = 2695 THEN 'senden_empfangen' ---- 2695  sending_receiving
WHEN signal_transmission = 3056 THEN 'unbekannt' ---- 3056  unknown
END, subsidies, vsa_dss_2015_2_d.tid_lookup('Abwasserknoten', fk_wastewater_node), vsa_dss_2015_2_d.tid_lookup('Abwasserknoten', fk_overflow_to), vsa_dss_2015_2_d.tid_lookup('Ueberlaufcharakteristik', fk_overflow_characteristic), vsa_dss_2015_2_d.tid_lookup('Steuerungszentrale', fk_control_center)
FROM qgep_od.overflow;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('ueberlauf', qgep_od.overflow.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_overflow.last_modification, vsa_dss_2015_2_d.tid_lookup('ueberlauf', qgep_od.overflow.obj_id)
FROM qgep_od.overflow
   LEFT JOIN qgep_od.organisation as a ON od_overflow.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_overflow.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.absperr_drosselorgan
(
t_id, antrieb, verstellbarkeit, steuerung, querschnitt, wirksamer_qs, bruttokosten, bezeichnung, art, fabrikat, bemerkung, signaluebermittlung, subventionen, drosselorgan_oeffnung_ist, drosselorgan_oeffnung_ist_optimiert, abwasserknotenref, steuerungszentraleref, ueberlaufref)
SELECT vsa_dss_2015_2_d.tid_lookup('absperr_drosselorgan', obj_id),
CASE WHEN actuation = 3213 THEN 'andere' ---- 3213  other
WHEN actuation = 3154 THEN 'Benzinmotor' ---- 3154  gaz_engine
WHEN actuation = 3155 THEN 'Dieselmotor' ---- 3155  diesel_engine
WHEN actuation = 3156 THEN 'Elektromotor' ---- 3156  electric_engine
WHEN actuation = 3152 THEN 'hydraulisch' ---- 3152  hydraulic
WHEN actuation = 3153 THEN 'keiner' ---- 3153  none
WHEN actuation = 3157 THEN 'manuell' ---- 3157  manual
WHEN actuation = 3158 THEN 'pneumatisch' ---- 3158  pneumatic
WHEN actuation = 3151 THEN 'unbekannt' ---- 3151  unknown
END,
CASE WHEN adjustability = 3159 THEN 'fest' ---- 3159  fixed
WHEN adjustability = 3161 THEN 'unbekannt' ---- 3161  unknown
WHEN adjustability = 3160 THEN 'verstellbar' ---- 3160  adjustable
END,
CASE WHEN control = 3162 THEN 'geregelt' ---- 3162  closed_loop_control
WHEN control = 3163 THEN 'gesteuert' ---- 3163  open_loop_control
WHEN control = 3165 THEN 'keine' ---- 3165  none
WHEN control = 3164 THEN 'unbekannt' ---- 3164  unknown
END, cross_section, effective_cross_section, gross_costs, identifier,
CASE WHEN kind = 2973 THEN 'andere' ---- 2973  other
WHEN kind = 2746 THEN 'Blende' ---- 2746  orifice
WHEN kind = 2691 THEN 'Dammbalken' ---- 2691  stop_log
WHEN kind = 252 THEN 'Drosselklappe' ---- 252  throttle_flap
WHEN kind = 135 THEN 'Drosselschieber' ---- 135  throttle_valve
WHEN kind = 6490 THEN 'Drosselstrecke' ---- 6490  throttle_section
WHEN kind = 6491 THEN 'Leapingwehr' ---- 6491  leapingweir
WHEN kind = 6492 THEN 'Pumpe' ---- 6492  pomp
WHEN kind = 2690 THEN 'Rueckstauklappe' ---- 2690  backflow_flap
WHEN kind = 2688 THEN 'Schieber' ---- 2688  valve
WHEN kind = 134 THEN 'Schlauchdrossel' ---- 134  tube_throttle
WHEN kind = 2689 THEN 'Schuetze' ---- 2689  sliding_valve
WHEN kind = 5755 THEN 'Stauschild' ---- 5755  gate_shield
WHEN kind = 3046 THEN 'unbekannt' ---- 3046  unknown
WHEN kind = 133 THEN 'Wirbeldrossel' ---- 133  whirl_throttle
END, manufacturer, remark,
CASE WHEN signal_transmission = 3171 THEN 'empfangen' ---- 3171  receiving
WHEN signal_transmission = 3172 THEN 'senden' ---- 3172  sending
WHEN signal_transmission = 3169 THEN 'senden_empfangen' ---- 3169  sending_receiving
WHEN signal_transmission = 3170 THEN 'unbekannt' ---- 3170  unknown
END, subsidies, throttle_unit_opening_current, throttle_unit_opening_current_optimized, vsa_dss_2015_2_d.tid_lookup('Abwasserknoten', fk_wastewater_node), vsa_dss_2015_2_d.tid_lookup('Steuerungszentrale', fk_control_center), vsa_dss_2015_2_d.tid_lookup('Ueberlauf', fk_overflow)
FROM qgep_od.throttle_shut_off_unit;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('absperr_drosselorgan', qgep_od.throttle_shut_off_unit.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_throttle_shut_off_unit.last_modification, vsa_dss_2015_2_d.tid_lookup('absperr_drosselorgan', qgep_od.throttle_shut_off_unit.obj_id)
FROM qgep_od.throttle_shut_off_unit
   LEFT JOIN qgep_od.organisation as a ON od_throttle_shut_off_unit.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_throttle_shut_off_unit.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.streichwehr
(
t_id, hydrueberfalllaenge, kotemax, kotemin, ueberfallkante, wehr_art)
SELECT vsa_dss_2015_2_d.tid_lookup('streichwehr', obj_id), hydraulic_overflow_length, level_max, level_min,
CASE WHEN weir_edge = 2995 THEN 'andere' ---- 2995  other
WHEN weir_edge = 351 THEN 'rechteckig' ---- 351  rectangular
WHEN weir_edge = 350 THEN 'rund' ---- 350  round
WHEN weir_edge = 349 THEN 'scharfkantig' ---- 349  sharp_edged
WHEN weir_edge = 3014 THEN 'unbekannt' ---- 3014  unknown
END,
CASE WHEN weir_kind = 5772 THEN 'hochgezogen' ---- 5772  raised
WHEN weir_kind = 5771 THEN 'niedrig' ---- 5771  low
END
FROM qgep_od.prank_weir;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'streichwehr'
FROM
   vsa_dss_2015_2_d.streichwehr a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.foerderaggregat
(
t_id, bauart, arbeitspunkt, aufstellungantrieb, aufstellungfoerderaggregat, foerderstrommax_einzel, foerderstrommin_einzel, kotestart, kotestop, nutzungsart_ist)
SELECT vsa_dss_2015_2_d.tid_lookup('foerderaggregat', obj_id),
CASE WHEN contruction_type = 2983 THEN 'andere' ---- 2983  other
WHEN contruction_type = 2662 THEN 'Druckluftanlage' ---- 2662  compressed_air_system
WHEN contruction_type = 314 THEN 'Kolbenpumpe' ---- 314  piston_pump
WHEN contruction_type = 309 THEN 'Kreiselpumpe' ---- 309  centrifugal_pump
WHEN contruction_type = 310 THEN 'Schneckenpumpe' ---- 310  screw_pump
WHEN contruction_type = 3082 THEN 'unbekannt' ---- 3082  unknown
WHEN contruction_type = 2661 THEN 'Vakuumanlage' ---- 2661  vacuum_system
END, operating_point,
CASE WHEN placement_of_actuation = 318 THEN 'nass' ---- 318  wet
WHEN placement_of_actuation = 311 THEN 'trocken' ---- 311  dry
WHEN placement_of_actuation = 3070 THEN 'unbekannt' ---- 3070  unknown
END,
CASE WHEN placement_of_pump = 362 THEN 'horizontal' ---- 362  horizontal
WHEN placement_of_pump = 3071 THEN 'unbekannt' ---- 3071  unknown
WHEN placement_of_pump = 363 THEN 'vertikal' ---- 363  vertical
END, pump_flow_max_single, pump_flow_min_single, start_level, stop_level,
CASE WHEN usage_current = 6325 THEN 'andere' ---- 6325  other
WHEN usage_current = 6202 THEN 'Bachwasser' ---- 6202  creek_water
WHEN usage_current = 6203 THEN 'entlastetes_Mischabwasser' ---- 6203  discharged_combined_wastewater
WHEN usage_current = 6204 THEN 'Industrieabwasser' ---- 6204  industrial_wastewater
WHEN usage_current = 6201 THEN 'Mischabwasser' ---- 6201  combined_wastewater
WHEN usage_current = 6205 THEN 'Regenabwasser' ---- 6205  rain_wastewater
WHEN usage_current = 6200 THEN 'Reinabwasser' ---- 6200  clean_wastewater
WHEN usage_current = 6206 THEN 'Schmutzabwasser' ---- 6206  wastewater
WHEN usage_current = 6326 THEN 'unbekannt' ---- 6326  unknown
END
FROM qgep_od.pump;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'foerderaggregat'
FROM
   vsa_dss_2015_2_d.foerderaggregat a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.leapingwehr
(
t_id, laenge, oeffnungsform, breite)
SELECT vsa_dss_2015_2_d.tid_lookup('leapingwehr', obj_id), length,
CASE WHEN opening_shape = 3581 THEN 'andere' ---- 3581  other
WHEN opening_shape = 3582 THEN 'Kreis' ---- 3582  circle
WHEN opening_shape = 3585 THEN 'Parabel' ---- 3585  parable
WHEN opening_shape = 3583 THEN 'Rechteck' ---- 3583  rectangular
WHEN opening_shape = 3584 THEN 'unbekannt' ---- 3584  unknown
END, width
FROM qgep_od.leapingweir;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'leapingwehr'
FROM
   vsa_dss_2015_2_d.leapingwehr a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.hydr_kennwerte
(
t_id, aggregatezahl, foerderhoehe_geodaetisch, bezeichnung, springt_an, hauptwehrart, mehrbelastung, ueberlaufdauer, ueberlauffracht, ueberlaufhaeufigkeit, ueberlaufmenge, pumpenregime, foerderstrommax, foerderstrommin, foerderaggregat_nutzungsart_ist, qab, qan, bemerkung, status, abwasserknotenref, ueberlaufcharakteristikref)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_kennwerte', obj_id), aggregate_number, delivery_height_geodaetic, identifier,
CASE WHEN is_overflowing = 5774 THEN 'ja' ---- 5774  yes
WHEN is_overflowing = 5775 THEN 'nein' ---- 5775  no
WHEN is_overflowing = 5778 THEN 'unbekannt' ---- 5778  unknown
END,
CASE WHEN main_weir_kind = 6422 THEN 'Leapingwehr' ---- 6422  leapingweir
WHEN main_weir_kind = 6420 THEN 'Streichwehr_hochgezogen' ---- 6420  spillway_raised
WHEN main_weir_kind = 6421 THEN 'Streichwehr_niedrig' ---- 6421  spillway_low
END, overcharge, overflow_duration, overflow_freight, overflow_frequency, overflow_volume,
CASE WHEN pump_characteristics = 6374 THEN 'alternierend' ---- 6374  alternating
WHEN pump_characteristics = 6375 THEN 'andere' ---- 6375  other
WHEN pump_characteristics = 6376 THEN 'einzeln' ---- 6376  single
WHEN pump_characteristics = 6377 THEN 'parallel' ---- 6377  parallel
WHEN pump_characteristics = 6378 THEN 'unbekannt' ---- 6378  unknown
END, pump_flow_max, pump_flow_min,
CASE WHEN pump_usage_current = 6361 THEN 'andere' ---- 6361  other
WHEN pump_usage_current = 6362 THEN 'Bachwasser' ---- 6362  creek_water
WHEN pump_usage_current = 6363 THEN 'entlastetes_Mischabwasser' ---- 6363  discharged_combined_wastewater
WHEN pump_usage_current = 6364 THEN 'Industrieabwasser' ---- 6364  industrial_wastewater
WHEN pump_usage_current = 6365 THEN 'Mischabwasser' ---- 6365  combined_wastewater
WHEN pump_usage_current = 6366 THEN 'Regenabwasser' ---- 6366  rain_wastewater
WHEN pump_usage_current = 6367 THEN 'Reinabwasser' ---- 6367  clean_wastewater
WHEN pump_usage_current = 6368 THEN 'Schmutzabwasser' ---- 6368  wastewater
WHEN pump_usage_current = 6369 THEN 'unbekannt' ---- 6369  unknown
END, q_discharge, qon, remark,
CASE WHEN status = 6371 THEN 'geplant' ---- 6371  planned
WHEN status = 6372 THEN 'Ist' ---- 6372  current
WHEN status = 6373 THEN 'Ist_optimiert' ---- 6373  current_optimized
END, vsa_dss_2015_2_d.tid_lookup('Abwasserknoten', fk_wastewater_node), vsa_dss_2015_2_d.tid_lookup('Ueberlaufcharakteristik', fk_overflow_characteristic)
FROM qgep_od.hydraulic_characteristic_data;

INSERT INTO vsa_dss_2015_2_d.metaattribute
(
t_id, t_seq, datenherr, datenlieferant, letzte_aenderung, sia405_baseclass_metaattribute)
SELECT vsa_dss_2015_2_d.tid_lookup('hydr_kennwerte', qgep_od.hydraulic_characteristic_data.obj_id), '0', a.identifier as dataowner, b.identifier as provider, od_hydraulic_characteristic_data.last_modification, vsa_dss_2015_2_d.tid_lookup('hydr_kennwerte', qgep_od.hydraulic_characteristic_data.obj_id)
FROM qgep_od.hydraulic_characteristic_data
   LEFT JOIN qgep_od.organisation as a ON od_hydraulic_characteristic_data.fk_dataowner = a.obj_id
   LEFT JOIN qgep_od.organisation as b ON od_hydraulic_characteristic_data.fk_provider = b.obj_id;

INSERT INTO vsa_dss_2015_2_d.rueckstausicherung
(
t_id, bruttokosten, art, ersatzjahr, absperr_drosselorganref, foerderaggregatref)
SELECT vsa_dss_2015_2_d.tid_lookup('rueckstausicherung', obj_id), gross_costs,
CASE WHEN kind = 5760 THEN 'andere' ---- 5760  other
WHEN kind = 5759 THEN 'Pumpe' ---- 5759  pump
WHEN kind = 5757 THEN 'Rueckstauklappe' ---- 5757  backflow_flap
WHEN kind = 5758 THEN 'Stauschild' ---- 5758  gate_shield
END, year_of_replacement, vsa_dss_2015_2_d.tid_lookup('Absperr_Drosselorgan', fk_throttle_shut_off_unit), vsa_dss_2015_2_d.tid_lookup('FoerderAggregat', fk_pump)
FROM qgep_od.backflow_prevention;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'rueckstausicherung'
FROM
   vsa_dss_2015_2_d.rueckstausicherung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.feststoffrueckhalt
(
t_id, dimensionierungswert, bruttokosten, anspringkote, art, ersatzjahr)
SELECT vsa_dss_2015_2_d.tid_lookup('feststoffrueckhalt', obj_id), dimensioning_value, gross_costs, overflow_level,
CASE WHEN type = 5664 THEN 'andere' ---- 5664  other
WHEN type = 5665 THEN 'Feinrechen' ---- 5665  fine_screen
WHEN type = 5666 THEN 'Grobrechen' ---- 5666  coarse_screen
WHEN type = 5667 THEN 'Sieb' ---- 5667  sieve
WHEN type = 5668 THEN 'Tauchwand' ---- 5668  scumboard
WHEN type = 5669 THEN 'unbekannt' ---- 5669  unknown
END, year_of_replacement
FROM qgep_od.solids_retention;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'feststoffrueckhalt'
FROM
   vsa_dss_2015_2_d.feststoffrueckhalt a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.beckenreinigung
(
t_id, bruttokosten, art, ersatzjahr)
SELECT vsa_dss_2015_2_d.tid_lookup('beckenreinigung', obj_id), gross_costs,
CASE WHEN type = 5621 THEN 'Air_Jet' ---- 5621  airjet
WHEN type = 5620 THEN 'andere' ---- 5620  other
WHEN type = 5622 THEN 'keine' ---- 5622  none
WHEN type = 5623 THEN 'Schwallspuelung' ---- 5623  surge_flushing
WHEN type = 5624 THEN 'Spuelkippe' ---- 5624  tipping_bucket
END, year_of_replacement
FROM qgep_od.tank_cleaning;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'beckenreinigung'
FROM
   vsa_dss_2015_2_d.beckenreinigung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.beckenentleerung
(
t_id, leistung, bruttokosten, art, ersatzjahr, absperr_drosselorganref, ueberlaufref)
SELECT vsa_dss_2015_2_d.tid_lookup('beckenentleerung', obj_id), flow, gross_costs,
CASE WHEN type = 5626 THEN 'andere' ---- 5626  other
WHEN type = 5627 THEN 'keine' ---- 5627  none
WHEN type = 5628 THEN 'Pumpe' ---- 5628  pump
WHEN type = 5629 THEN 'Schieber' ---- 5629  valve
END, year_of_replacement, vsa_dss_2015_2_d.tid_lookup('Absperr_Drosselorgan', fk_throttle_shut_off_unit), vsa_dss_2015_2_d.tid_lookup('FoerderAggregat', fk_overflow)
FROM qgep_od.tank_emptying;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'beckenentleerung'
FROM
   vsa_dss_2015_2_d.beckenentleerung a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.ezg_parameter_allg
(
t_id, trockenwetteranfall, fliessweglaenge, fliessweggefaelle, einwohnergleichwert, flaeche)
SELECT vsa_dss_2015_2_d.tid_lookup('ezg_parameter_allg', obj_id), dry_wheather_flow, flow_path_length, flow_path_slope, population_equivalent, surface_ca
FROM qgep_od.param_ca_general;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'ezg_parameter_allg'
FROM
   vsa_dss_2015_2_d.ezg_parameter_allg a
WHERE
   baseclass.t_id =  a.t_id;

INSERT INTO vsa_dss_2015_2_d.ezg_parameter_mouse1
(
t_id, trockenwetteranfall, fliessweglaenge, fliessweggefaelle, einwohnergleichwert, flaeche, nutzungsart)
SELECT vsa_dss_2015_2_d.tid_lookup('ezg_parameter_mouse1', obj_id), dry_wheather_flow, flow_path_length, flow_path_slope, population_equivalent, surface_ca_mouse, usage
FROM qgep_od.param_ca_mouse1;

UPDATE vsa_dss_2015_2_d.baseclass SET t_type = 'ezg_parameter_mouse1'
FROM
   vsa_dss_2015_2_d.ezg_parameter_mouse1 a
WHERE
   baseclass.t_id =  a.t_id;

--- import_basket aktualisieren
SELECT vsa_dss_2015_2_d.basket_update();

COMMIT;
