----------------
-- organisation
----------------
DROP VIEW IF EXISTS tww_app.vw_agxx_organisation;
CREATE VIEW tww_app.vw_agxx_organisation
AS
SELECT
concat_ws('','ch113jqg0000',right(obj_id,8)) AS obj_id,
REGEXP_REPLACE(uid,'(^.{{3}})(.{{3}})(.{{3}})','\1-\2.\3.') AS uid,
identifier AS bezeichnung,
identifier_short AS kurzbezeichnung,
'AfU Aargau' AS datenbewirtschafter_kt,
ot.value_de  AS organisationtyp,
last_modification  AS letzte_aenderung,
remark AS bemerkung
FROM tww_od.organisation org
LEFT JOIN tww_vl.organisation_organisation_type ot ON ot.code = org.organisation_type
WHERE tww_active
;

----------------
-- Hilfs-View für Rohrprofile
----------------
DROP VIEW IF EXISTS tww_app.vw_agxx_rohrprofile_aux;
CREATE VIEW tww_app.vw_agxx_rohrprofile_aux
AS
SELECT ppt.value_de
	, ppt.abbr_de
	, height_width_ratio
	, fk_provider
	, fk_dataowner
    , (array_agg(obj_id))[1] as fk_pipe_profile
FROM tww_od.pipe_profile
LEFT JOIN tww_vl.pipe_profile_profile_type ppt on ppt.code =  profile_type
GROUP BY ppt.value_de
	, ppt.abbr_de
	, height_width_ratio
	, fk_provider
	, fk_dataowner
;

------------------
-- GEPKnoten
------------------

-- Mapping:
/*
FunktionBauwerkAG =   (
	  abflussloseGrube, 							--> special_structure
	  Absturzbauwerk,  								--> detailgeometrie
      Abwasserfaulraum,              				--> special_structure
	  andere, 										--> detailgeometrie
	  Be_Entlueftung,  								--> detailgeometrie
	  Dachwasserschacht,							--> manhole
	  Duekerkammer, 								--> special_structure
	  Duekeroberhaupt, 								--> special_structure
	  Einlaufschacht,  								--> manhole
	  Einleitstelle_gewaesserrelevant,           	--> discharge_point
	  Einleitstelle_nicht_gewaesserrelevant,     	--> discharge_point
	  Entwaesserungsrinne, 							--> manhole
      Faulgrube,                         			--> special_structure
	  Gelaendemulde,                   				--> special_structure
	  Geleiseschacht,								--> manhole
	  Geschiebefang,                   				--> special_structure
	  Guellegrube,                    				--> special_structure
      Klaergrube,                      				--> special_structure
      Kontrollschacht,  							--> detailgeometrie
	  Leitungsknoten,                               --> wastewater_node
	  Messstelle,                                   --> detailgeometrie, measurement
	  Oelabscheider,       							--> detailgeometrie
	  Pumpwerk,                   					--> detailgeometrie
	  Regenbecken_Durchlaufbecken,               	--> special_structure
	  Regenbecken_Fangbecken,                      	--> special_structure
	  Regenbecken_Fangkanal,                      	--> special_structure
	  Regenbecken_Regenklaerbecken,               	--> special_structure
	  Regenbecken_Regenrueckhaltebecken,           	--> special_structure
	  Regenbecken_Regenrueckhaltekanal,            	--> special_structure
	  Regenbecken_Stauraumkanal,                   	--> special_structure
	  Regenbecken_Verbundbecken,                   	--> special_structure
	  Regenueberlauf,        						--> detailgeometrie
	  Schlammsammler,       						--> manhole
	  Schwimmstoffabscheider,    					--> detailgeometrie
	  seitlicherZugang,        		             	--> special_structure
	  Spuelschacht,    								--> detailgeometrie
	  Trennbauwerk,         						--> detailgeometrie
	  unbekannt, 									--> detailgeometrie
	  Versickerungsanlage (              		 	--> infiltration_installation
	    Versickerungsbecken,
		Kieskoerper,
		Versickerungsschacht,
		Versickerungsstrang,
		Versickerungsschacht_Strang,
		Retentionsfilterbecken,
		andere,
		unbekannt),
	  Wirbelfallschacht,    		             	--> special_structure
	  Abwasserreinigungsanlage,   		           	--> wastewater_node, wwtp
	  Anschluss,                   		           	--> wastewater_node, ag64_function
	  Bodenablauf,                                	--> manhole
	  Oelrueckhaltebecken,                         	--> special_structure
	  Regenwasserrechen,                          	--> special_structure.other
	  Regenwassersieb,                             	--> special_structure.other
	  Rohrbruecke,                                 	--> special_structure.other
	  Schlammfang,                         			--> manhole
	  Strassenwasserbehandlungsanlage,             	--> special_structure
	  Vorbehandlung              					--> detailgeometrie
	);


*/
DROP MATERIALIZED VIEW  IF EXISTS tww_app.vw_agxx_knoten_bauwerksattribute CASCADE;

CREATE MATERIALIZED VIEW tww_app.vw_agxx_knoten_bauwerksattribute
AS
WITH re_meta AS(
	SELECT re.obj_id,
	re.fk_reach_point_from,
	re.fk_reach_point_to,
	ws.year_of_construction,
	ws.structure_condition,
	ws.financing,
	ws.status,
	ws.status_survey_year,
	ws.renovation_necessity,
	ws.fk_owner,
	ws.fk_operator,
	CH.function_hierarchic as ch_function_hierarchic,
	tww_symbology_order,
	ag96_fk_measure
	FROM
	(SELECT obj_id,
	 fk_reach_point_from,
	 fk_reach_point_to from tww_od.reach) re
	LEFT JOIN (SELECT obj_id, fk_wastewater_structure
				 FROM tww_od.wastewater_networkelement)   ne ON ne.obj_id = re.obj_id
      LEFT JOIN (SELECT obj_id, function_hierarchic
				 FROM tww_od.channel)                    CH ON CH.obj_id = ne.fk_wastewater_structure
      LEFT JOIN (SELECT obj_id,
				 year_of_construction,
				 structure_condition,
				 financing,
				 status,
				 status_survey_year,
				 renovation_necessity,
				 fk_owner,
				 fk_operator
				 FROM tww_od.wastewater_structure  )      ws ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN (SELECT fk_wastewater_structure,
				ag96_fk_measure
				FROM tww_od.agxx_wastewater_structure  )      ws1 ON ws.obj_id = ws1.fk_wastewater_structure
	  LEFT JOIN (SELECT code, tww_symbology_order
				 FROM tww_vl.channel_function_hierarchic) vl_fct_hier	ON CH.function_hierarchic = vl_fct_hier.code )
	SELECT DISTINCT ON (wn.obj_id) wn.obj_id AS obj_id,
	  COALESCE(first_value(ws.year_of_construction) OVER w
             , first_value(re_from.year_of_construction) OVER w
             , first_value(re_to.year_of_construction) OVER w
			 , first_value(unc.year_of_construction) OVER w) AS year_of_construction,
	  COALESCE( first_value(ws.structure_condition) OVER w
		      , first_value(re_from.structure_condition) OVER w
              , first_value(re_to.structure_condition) OVER w
			  , first_value(unc.structure_condition) OVER w) AS structure_condition,
	  COALESCE( first_value(ws.status) OVER w
		      , first_value(re_from.status) OVER w
              , first_value(re_to.status) OVER w
			  , first_value(unc.status) OVER w) AS status,
      COALESCE(first_value(ws.financing) OVER w
             , first_value(re_from.financing) OVER w
             , first_value(re_to.financing) OVER w
			 , first_value(unc.financing) OVER w) AS financing,
	  COALESCE(first_value(ws.status_survey_year) OVER w
             , first_value(re_from.status_survey_year) OVER w
             , first_value(re_to.status_survey_year) OVER w
			 , first_value(unc.status_survey_year) OVER w) AS status_survey_year,
      COALESCE(first_value(ws.renovation_necessity) OVER w
		      , first_value(re_from.renovation_necessity) OVER w
              , first_value(re_to.renovation_necessity) OVER w
			  , first_value(unc.renovation_necessity) OVER w) AS renovation_necessity,
	  COALESCE(first_value(ws.fk_owner) OVER w
             , first_value(re_from.fk_owner) OVER w
             , first_value(re_to.fk_owner) OVER w
			 , first_value(unc.fk_owner) OVER w) AS fk_owner,
	  COALESCE(first_value(ws.fk_operator) OVER w
             , first_value(re_from.fk_operator) OVER w
             , first_value(re_to.fk_operator) OVER w
			 , first_value(unc.fk_operator) OVER w) AS fk_operator,
	  COALESCE( first_value(re_from.ch_function_hierarchic) OVER w
             , first_value(re_to.ch_function_hierarchic) OVER w
			 , first_value(unc.ch_function_hierarchic) OVER w) AS ch_function_hierarchic,
			 ws.fk_main_cover,
			 ws.accessibility,
	  COALESCE(first_value(ws1.ag96_fk_measure) OVER w
             , first_value(re_from.ag96_fk_measure) OVER w
             , first_value(re_to.ag96_fk_measure) OVER w
			 , first_value(unc.ag96_fk_measure) OVER w) AS ag96_fk_measure

    FROM
      tww_od.wastewater_node wn
	  LEFT JOIN (SELECT obj_id, fk_wastewater_structure
				 FROM tww_od.wastewater_networkelement)   ne  ON ne.obj_id = wn.obj_id
	  LEFT JOIN (SELECT obj_id,
				 year_of_construction,
				 structure_condition,
				 financing,
				 status,
				 status_survey_year,
				 renovation_necessity,
				 fk_owner,
				 fk_operator,
				 fk_main_cover,
				 accessibility
				 FROM tww_od.wastewater_structure )  ws  ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN (SELECT fk_wastewater_structure,
				ag96_fk_measure
				FROM tww_od.agxx_wastewater_structure  )      ws1 ON ws.obj_id = ws1.fk_wastewater_structure
	  LEFT JOIN (SELECT obj_id, fk_wastewater_networkelement
				 FROM tww_od.reach_point)               rp      ON wn.obj_id = rp.fk_wastewater_networkelement
	  LEFT JOIN re_meta AS re_from ON re_from.fk_reach_point_from = rp.obj_id
	  LEFT JOIN re_meta AS re_to ON re_to.fk_reach_point_to = rp.obj_id
	  LEFT JOIN (SELECT obj_id,
				 year_of_construction,
				 structure_condition,
				 financing,
				 status,
				 status_survey_year,
				 renovation_necessity,
				 fk_owner,
				 fk_operator,
				 ch_function_hierarchic,
				 ag96_fk_measure
				 FROM tww_od.agxx_unconnected_node_bwrel) unc ON unc.obj_id=wn.obj_id
	  LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier_unc 	ON unc.ch_function_hierarchic = vl_fct_hier_unc.code
	  WINDOW w AS ( PARTITION BY wn.obj_id
                    ORDER BY re_from.tww_symbology_order ASC NULLS LAST
                           , re_to.tww_symbology_order ASC NULLS LAST
                          , vl_fct_hier_unc.tww_symbology_order ASC NULLS LAST
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)

WITH DATA;

CREATE INDEX in_app_vw_agxx_knoten_bauwerksattribute_obj_id
    ON tww_app.vw_agxx_knoten_bauwerksattribute USING btree
    (obj_id)
    TABLESPACE pg_default;

DROP VIEW IF EXISTS tww_app.vw_agxx_gepknoten;
CREATE VIEW tww_app.vw_agxx_gepknoten
AS
SELECT
	  wn.obj_id AS obj_id
	, COALESCE(wn.wwtp_number,unc.wwtp_number) AS ara_nr
	, COALESCE(ws.year_of_construction,1800) AS baujahr
	, COALESCE(sc.value_de,'unbekannt') AS baulicherzustand
	, CASE WHEN st.value_de = 'in_Betrieb' THEN 'in_Betrieb.in_Betrieb' ELSE COALESCE(st.value_de,'unbekannt') END AS bauwerkstatus
	, ne_agxx.ag64_remark AS bemerkung_wi
	, ne.identifier AS bezeichnung
	, COALESCE(co.level,main_co.level,unc.co_level) AS deckelkote
	, ST_Force2D(COALESCE(main_ws.detail_geometry3d_geometry,unc.detail_geometry3d_geometry)) AS detailgeometrie
	, COALESCE(fi.value_de,'unbekannt') AS finanzierung
	, COALESCE(
		CASE
		when
			meas_pt.obj_id IS NOT NULL
			AND ss_fu.value_de NOT LIKE ANY (ARRAY['Regenbecken%','Regenueberlauf','Pumpwerk','Dueker%','Versickerungsanlage%'])
		THEN
			'Messstelle'
		when wn_agxx.ag64_function IS NOT NULL THEN 'Anschluss'
		when wwtp.obj_id IS NOT NULL THEN 'Abwasserreinigungsanlage'
		ELSE NULL
		END
		, ma_fu_rev.value_de
		, ma_fu.value_de
		, ss_fu_rev.value_de
		, ss_fu.value_de
		,'Einleitstelle_'||dp_rel.value_de
		,'Versickerungsanlage.'||ii_ki_rev.value_de --Versickerungsanlage.andere wird auf unbekannt gemappt
		,'Versickerungsanlage.'||ii_ki.value_de --Versickerungsanlage.andere wird auf unbekannt gemappt
		, 'Leitungsknoten'
		) AS funktionag
	, COALESCE(left(fhi.value_de,3),'SAA')  AS funktionhierarchisch
	, COALESCE(isgate.value_de,'unbekannt') AS istschnittstelle
	, COALESCE(ws.status_survey_year,1800) AS jahr_zustandserhebung
	, ST_Force2D(COALESCE(co.situation3d_geometry,wn.situation3d_geometry)) AS lage
	, ne_agxx_lm.ag64_last_modification AS letzte_aenderung_wi
	, co_pa.value_de AS lagegenauigkeit
	, wn.backflow_level_current AS maxrueckstauhoehe
	, COALESCE(rn.value_de,'unbekannt') AS sanierungsbedarf
	, wn.bottom_level AS sohlenkote
	, COALESCE(ac.value_de,'unbekannt') AS zugaenglichkeit
	, concat_ws('','ch113jqg0000',right(COALESCE(ws.fk_operator,'00000107'),8)) AS betreiber
	, concat_ws('','ch113jqg0000',right(COALESCE(ne_agxx.ag64_fk_provider,'00000107'),8)) AS datenbewirtschafter_wi
	, concat_ws('','ch113jqg0000',right(COALESCE(ws.fk_owner,'00000107'),8)) AS eigentuemer
	, ws_agxx.ag96_fk_measure AS gepmassnahmeref
	, concat_ws('','ch113jqg0000',right(COALESCE(ne_agxx.ag96_fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, ne_agxx.ag96_remark AS bemerkung_gep
	, COALESCE(ne_agxx_lm.ag96_last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep
  , NULL::boolean AS ignore_ws
  , CASE
      WHEN ma.obj_id IS NOT NULL THEN 'manhole'
      WHEN ss.obj_id IS NOT NULL THEN 'special_structure'
      WHEN dp.obj_id IS NOT NULL THEN 'discharge_point'
      WHEN ii.obj_id IS NOT NULL THEN 'infiltration_installation'
      WHEN wwtp.obj_id IS NOT NULL THEN 'wwtp_structure'
      ELSE 'unknown'
    END AS ws_type


FROM (
	SELECT obj_id, wwtp_number, situation3d_geometry, backflow_level_current, bottom_level,_function_hierarchic FROM tww_od.wastewater_node wn
	UNION (
		SELECT obj_id, wwtp_number, situation3d_geometry, backflow_level_current, bottom_level, ch_function_hierarchic as _function_hierarchic
		FROM tww_od.agxx_unconnected_node_bwrel un
		EXCEPT
		SELECT obj_id, wwtp_number, situation3d_geometry, backflow_level_current, bottom_level,ch_function_hierarchic as _function_hierarchic
		FROM tww_od.agxx_unconnected_node_bwrel un
		WHERE un.obj_id IN (SELECT obj_id FROM tww_od.wastewater_node wn)
	)
) wn
LEFT JOIN tww_od.wastewater_networkelement ne ON wn.obj_id = ne.obj_id
LEFT JOIN tww_app.vw_agxx_knoten_bauwerksattribute ws ON wn.obj_id=ws.obj_id
LEFT JOIN tww_od.wastewater_structure main_ws ON wn.obj_id=main_ws.fk_main_wastewater_node

LEFT JOIN tww_od.agxx_wastewater_node wn_agxx ON wn_agxx.fk_wastewater_node = wn.obj_id
LEFT JOIN tww_od.agxx_wastewater_networkelement ne_agxx ON ne_agxx.fk_wastewater_networkelement = ne.obj_id
LEFT JOIN tww_od.agxx_last_modification ne_agxx_lm ON ne_agxx_lm.fk_element = ne.obj_id
LEFT JOIN tww_od.agxx_wastewater_structure ws_agxx ON ws_agxx.fk_wastewater_structure = ws.obj_id
LEFT JOIN tww_od.measuring_point meas_pt ON main_ws.obj_id=meas_pt.fk_wastewater_structure
LEFT JOIN tww_od.wwtp_structure wwtp ON main_ws.obj_id=wwtp.obj_id --tbd: Filtern, dass nur ARA-Zulauf gemappt wird

LEFT JOIN tww_vl.wastewater_node_ag96_is_gateway isgate ON wn_agxx.ag96_is_gateway=isgate.code
LEFT JOIN (SELECT
		   obj_id,
		   co_level,
		   detail_geometry3d_geometry,
		   co_positional_accuracy,
		   wwtp_number
		   FROM
		   tww_od.agxx_unconnected_node_bwrel) unc ON unc.obj_id=wn.obj_id

LEFT JOIN tww_vl.wastewater_structure_status st ON st.code=ws.status

LEFT JOIN tww_od.manhole ma ON main_ws.obj_id = ma.obj_id
LEFT JOIN tww_vl.manhole_function ma_fu ON ma_fu.code=ma.function
LEFT JOIN tww_vl.manhole_function_export_rel_agxx ma_fu_rev ON ma_fu_rev.code=ma.function
LEFT JOIN tww_od.special_structure ss ON main_ws.obj_id = ss.obj_id
LEFT JOIN tww_vl.special_structure_function ss_fu ON ss_fu.code=ss.function
LEFT JOIN tww_vl.special_structure_function_export_rel_agxx ss_fu_rev ON ss_fu_rev.code=ss.function
LEFT JOIN tww_od.infiltration_installation ii ON main_ws.obj_id = ii.obj_id
LEFT JOIN tww_vl.infiltration_installation_kind ii_ki ON ii_ki.code=ii.kind
LEFT JOIN tww_vl.infiltration_installation_kind_export_rel_agxx ii_ki_rev ON ii_ki_rev.code=ii.kind
LEFT JOIN tww_od.discharge_point dp ON main_ws.obj_id = dp.obj_id
LEFT JOIN tww_vl.discharge_point_relevance dp_rel ON dp_rel.code=dp.relevance

LEFT JOIN tww_vl.wastewater_structure_structure_condition sc ON sc.code=ws.structure_condition
LEFT JOIN tww_vl.wastewater_structure_renovation_necessity rn ON rn.code=ws.renovation_necessity
LEFT JOIN tww_vl.wastewater_structure_financing fi ON fi.code=ws.financing
LEFT JOIN tww_vl.channel_function_hierarchic fhi ON fhi.code=wn._function_hierarchic

LEFT JOIN tww_od.agxx_cover co_agxx ON co_agxx.ag64_fk_wastewater_node = wn.obj_id -- only overwrite position of main wn
LEFT JOIN tww_od.cover co on co.obj_id=co_agxx.fk_cover
LEFT JOIN tww_od.cover main_co ON main_co.obj_id=ws.fk_main_cover
LEFT JOIN tww_vl.cover_positional_accuracy co_pa ON co_pa.code=coalesce(co.positional_accuracy,main_co.positional_accuracy,unc.co_positional_accuracy)
LEFT JOIN tww_vl.wastewater_structure_accessibility  ac ON ac.code=ws.accessibility
;

------------------
-- GEPHaltung
------------------

DROP VIEW IF EXISTS tww_app.vw_agxx_gephaltung;
CREATE OR REPLACE VIEW tww_app.vw_agxx_gephaltung
AS

SELECT
	  re.obj_id AS obj_id
	, ws.year_of_construction AS baujahr
	, sc.value_de AS baulicherzustand
	, CASE WHEN st.value_de = 'in_Betrieb' THEN 'in_Betrieb.in_Betrieb' ELSE st.value_de END AS bauwerkstatus
	, ne_agxx.ag64_remark AS bemerkung_wi
	, ne.identifier AS bezeichnung
	, fi.value_de AS finanzierung
	, fhi.value_de AS funktionhierarchisch
	, fhy.value_de AS funktionhydraulisch
	, ea_to.value_de AS hoehengenauigkeit_nach
	, ea_from.value_de AS hoehengenauigkeit_von
	, re.hydraulic_load_current AS hydraulischebelastung
	, ws.status_survey_year AS jahr_zustandserhebung
	, NULLIF(rp_from.level,0) AS kote_beginn
	, NULLIF(rp_to.level,0)AS kote_ende
	, ne_agxx_lm.ag64_last_modification AS letzte_aenderung_wi
	, re_agxx.ag96_clear_width_planned AS lichte_breite_geplant
	, CASE
            WHEN pp.height_width_ratio IS NOT NULL THEN round(re.clear_height::numeric / pp.height_width_ratio)::smallint::integer
            ELSE re.clear_height
      END AS lichte_breite_ist
	, re_agxx.ag96_clear_height_planned AS lichte_hoehe_geplant
	, re.clear_height AS lichte_hoehe_ist
	, re.length_effective AS laengeeffektiv
	, mat.value_de AS material
	, ppt.value_de AS profiltyp
	, COALESCE (up_rev.value_de,up.value_de) AS nutzungsartag_geplant
	, COALESCE (uc_rev.value_de, uc.value_de) AS nutzungsartag_ist
	, relkind.value_de AS reliner_art
	, relcons.value_de AS reliner_bautechnik
	, relmat.value_de AS reliner_material
	, re.reliner_nominal_size  AS reliner_nennweite
	, rn.value_de  AS sanierungsbedarf
	, ST_Force2D(re.progression3d_geometry) AS verlauf
	, ws.rv_base_year AS wbw_basisjahr
	, ws.replacement_value AS wiederbeschaffungswert
	, concat_ws('','ch113jqg0000',right(COALESCE(ws.fk_operator,'00000107'),8)) AS betreiber
	, concat_ws('','ch113jqg0000',right(COALESCE(ne_agxx.ag64_fk_provider,'00000107'),8)) AS datenbewirtschafter_wi
	, concat_ws('','ch113jqg0000',right(COALESCE(ws.fk_owner,'00000107'),8)) AS eigentuemer
	, coalesce(agxx_rp_to.ag64_fk_wastewater_node, rp_to.fk_wastewater_networkelement)  AS endknoten
	, coalesce(agxx_rp_from.ag64_fk_wastewater_node,rp_from.fk_wastewater_networkelement) AS startknoten
	, ws_agxx.ag96_fk_measure AS gepmassnahmeref
	, concat_ws('','ch113jqg0000',right(COALESCE(ne_agxx.ag96_fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, ne_agxx.ag96_remark AS bemerkung_gep
	, COALESCE(ne_agxx_lm.ag96_last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep

FROM tww_od.reach re
	LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = re.obj_id
    LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id = re.fk_reach_point_from
    LEFT JOIN tww_od.agxx_reach_point agxx_rp_from ON rp_from.obj_id = agxx_rp_from.fk_reach_point
    LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id = re.fk_reach_point_to
    LEFT JOIN tww_od.agxx_reach_point agxx_rp_to ON rp_to.obj_id = agxx_rp_to.fk_reach_point
    LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure = ws.obj_id
    LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
    LEFT JOIN tww_od.pipe_profile pp ON re.fk_pipe_profile = pp.obj_id

	LEFT JOIN tww_vl.reach_reliner_material relmat ON relmat.code=re.reliner_material
	LEFT JOIN tww_vl.reach_relining_construction relcons ON relcons.code=re.relining_construction
	LEFT JOIN tww_vl.reach_relining_kind relkind ON relkind.code=re.relining_kind
	LEFT JOIN tww_vl.reach_point_elevation_accuracy ea_from ON ea_from.code=rp_from.elevation_accuracy
	LEFT JOIN tww_vl.reach_point_elevation_accuracy ea_to ON ea_to.code=rp_to.elevation_accuracy
	LEFT JOIN tww_vl.wastewater_structure_financing fi ON fi.code=ws.financing
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity rn ON rn.code=ws.renovation_necessity
	LEFT JOIN tww_vl.wastewater_structure_structure_condition sc ON sc.code=ws.structure_condition

	LEFT JOIN tww_vl.channel_function_hierarchic fhi ON fhi.code=ch.function_hierarchic
	LEFT JOIN tww_vl.channel_function_hydraulic fhy ON fhy.code=ch.function_hydraulic
	LEFT JOIN tww_vl.reach_material mat ON mat.code=re.material
	LEFT JOIN tww_vl.pipe_profile_profile_type ppt ON ppt.code=pp.profile_type
	LEFT JOIN tww_vl.wastewater_structure_status st ON st.code=ws.status
	LEFT JOIN tww_vl.channel_usage_current uc ON uc.code=ch.usage_current
	LEFT JOIN tww_vl.channel_usage_current_export_rel_agxx uc_rev ON uc_rev.code=ch.usage_current
	LEFT JOIN tww_vl.channel_usage_planned up ON up.code=ch.usage_planned
	LEFT JOIN tww_vl.channel_usage_planned_export_rel_agxx up_rev ON up_rev.code=ch.usage_planned

    LEFT JOIN tww_od.agxx_reach re_agxx ON re_agxx.fk_reach = re.obj_id
    LEFT JOIN tww_od.agxx_wastewater_networkelement ne_agxx ON ne_agxx.fk_wastewater_networkelement = ne.obj_id
    LEFT JOIN tww_od.agxx_last_modification ne_agxx_lm ON ne_agxx_lm.fk_element = ne.obj_id
	LEFT JOIN tww_od.agxx_wastewater_structure ws_agxx ON ws_agxx.fk_wastewater_structure = ws.obj_id

;


------------------
-- GEPMassnahme
------------------
DROP VIEW IF EXISTS tww_app.vw_agxx_gepmassnahme;
CREATE VIEW tww_app.vw_agxx_gepmassnahme
AS
SELECT
	  msr.obj_id
	, msr.line_geometry AS ausdehnung
	, msr.description AS beschreibung
	, msr.identifier AS bezeichnung
	, msr.date_entry AS datum_eingang
	, msr.total_cost AS gesamtkosten
	, msr.intervention_demand AS handlungsbedarf
	, msr.year_implementation_effective AS jahr_umsetzung_effektiv
	, msr.year_implementation_planned AS jahr_umsetzung_geplant
	, msr_ct.value_de AS kategorie
	, msr.perimeter_geometry AS perimeter
	, msr_pri.value_de AS prioritaetag
	, msr_st.value_de AS status
	, msr.symbolpos_geometry AS symbolpos
	, msr.link AS verweis
	, concat_ws('','ch113jqg0000',right(COALESCE(msr.fk_responsible_entity,'00000107'),8)) AS traegerschaft
	, concat_ws('','ch113jqg0000',right(COALESCE(msr.fk_responsible_start,'00000107'),8)) AS verantwortlich_ausloesung
	, concat_ws('','ch113jqg0000',right(COALESCE(msr.fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, msr.remark AS bemerkung_gep
	, COALESCE(msr.last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep

FROM tww_od.measure msr
	LEFT JOIN tww_vl.measure_category msr_ct ON msr_ct.code = msr.category
	 LEFT JOIN tww_vl.measure_category_export_rel_agxx ag_ct ON msr_ct.code = ag_ct.code
     LEFT JOIN tww_vl.measure_priority msr_pri ON msr_pri.code = msr.priority
	 LEFT JOIN tww_vl.measure_priority_export_rel_agxx ag_pri ON msr_pri.code = ag_pri.code
     LEFT JOIN tww_vl.measure_status msr_st ON msr_st.code = msr.status
	;


------------------
-- Einzugsgebiet
------------------
DROP VIEW IF EXISTS tww_app.vw_agxx_einzugsgebiet;
CREATE VIEW tww_app.vw_agxx_einzugsgebiet
AS
SELECT
	  ca.obj_id
	, ca.runoff_limit_planned AS abflussbegrenzung_geplant
	, ca.runoff_limit_current AS abflussbegrenzung_ist
	, ca.discharge_coefficient_rw_planned AS abflussbeiwert_rw_geplant
	, ca.discharge_coefficient_rw_current AS abflussbeiwert_rw_ist
	, ca.discharge_coefficient_ww_planned AS abflussbeiwert_sw_geplant
	, ca.discharge_coefficient_ww_current AS abflussbeiwert_sw_ist
	, ca.seal_factor_rw_planned AS befestigungsgrad_rw_geplant
	, ca.seal_factor_rw_current AS befestigungsgrad_rw_ist
	, ca.seal_factor_ww_planned AS befestigungsgrad_sw_geplant
	, ca.seal_factor_ww_current AS befestigungsgrad_sw_ist
	, ca.identifier AS bezeichnung
	, ddp.value_de AS direkteinleitung_in_gewaesser_geplant
	, ddc.value_de AS direkteinleitung_in_gewaesser_ist
	, ca.population_density_planned AS einwohnerdichte_geplant
	, ca.population_density_current AS einwohnerdichte_ist
	, COALESCE (dsp_rev.value_de,dsp.value_de) AS entwaesserungssystemag_geplant
	, COALESCE (dsc_rev.value_de,dsc.value_de) AS entwaesserungssystemag_ist
	, ca.surface_area AS flaeche
	, ca.sewer_infiltration_water_production_planned AS fremdwasseranfall_geplant
	, ca.sewer_infiltration_water_production_current AS fremdwasseranfall_ist
	, ca.perimeter_geometry AS perimeter
	, 'Berechnungspunkt' AS perimetertyp
	, rp.value_de AS retention_geplant
	, rc.value_de AS retention_ist
	, ca.waste_water_production_planned AS schmutzabwasseranfall_geplant
	, ca.waste_water_production_current AS schmutzabwasseranfall_ist
	, ip.value_de AS versickerung_geplant
	, ic.value_de AS versickerung_ist
	, ca.fk_wastewater_networkelement_rw_planned AS gepknoten_rw_geplantref
	, ca.fk_wastewater_networkelement_rw_current AS gepknoten_rw_istref
	, ca.fk_wastewater_networkelement_ww_planned AS gepknoten_sw_geplantref
	, ca.fk_wastewater_networkelement_ww_current AS gepknoten_sw_istref
	, concat_ws('','ch113jqg0000',right(COALESCE(ca.fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, ca.remark AS bemerkung_gep
	, COALESCE(ca.last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep

FROM tww_od.catchment_area ca
	LEFT JOIN tww_vl.catchment_area_direct_discharge_current ddc ON ddc.code = ca.direct_discharge_current
	LEFT JOIN tww_vl.catchment_area_direct_discharge_planned ddp ON ddp.code = ca.direct_discharge_planned
	LEFT JOIN tww_vl.catchment_area_drainage_system_current dsc ON dsc.code = ca.drainage_system_current
	LEFT JOIN tww_vl.catchment_area_drainage_system_planned dsp ON dsp.code = ca.drainage_system_planned
	LEFT JOIN tww_vl.catchment_area_infiltration_current ic ON ic.code = ca.infiltration_current
	LEFT JOIN tww_vl.catchment_area_infiltration_planned ip ON ip.code = ca.infiltration_planned
	LEFT JOIN tww_vl.catchment_area_retention_current rc ON rc.code = ca.retention_current
	LEFT JOIN tww_vl.catchment_area_retention_planned rp ON rp.code = ca.retention_planned
	LEFT JOIN tww_vl.catchment_area_drainage_system_planned_export_rel_agxx dsp_rev ON dsp_rev.code = ca.drainage_system_planned
	LEFT JOIN tww_vl.catchment_area_drainage_system_current_export_rel_agxx dsc_rev ON dsc_rev.code = ca.drainage_system_current
;


----------------------------
-- Ueberlauf_Foerderaggregat
----------------------------
DROP VIEW IF EXISTS tww_app.vw_agxx_ueberlauf_foerderaggregat;
CREATE VIEW tww_app.vw_agxx_ueberlauf_foerderaggregat
AS
SELECT
	  ov.obj_id
	, CASE
	  WHEN pu.obj_id IS NOT NULL THEN 'Foerderaggregat'
	  WHEN lw.obj_id IS NOT NULL THEN 'Leapingwehr'
	  WHEN pw.obj_id IS NOT NULL THEN 'Streichwehr'
	  END AS art
	, ov.identifier AS bezeichnung
	, ov.fk_wastewater_node AS knotenref
	, ov.fk_overflow_to AS knoten_nachref
	, concat_ws('','ch113jqg0000',right(COALESCE(ov_agxx.ag64_fk_provider,'00000107'),8)) AS datenbewirtschafter_wi
	, ov_agxx.ag64_remark AS bemerkung_wi
	, ov_agxx_lm.ag64_last_modification AS letzte_aenderung_wi
	, concat_ws('','ch113jqg0000',right(COALESCE(ov_agxx.ag96_fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, ov_agxx.ag96_remark AS bemerkung_gep
	, COALESCE(ov_agxx_lm.ag96_last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep
	, CASE
		WHEN pu.obj_id IS NOT NULL THEN 'pump'::text
		WHEN lw.obj_id IS NOT NULL THEN 'leapingweir'::text
		WHEN pw.obj_id IS NOT NULL THEN 'prank_weir'::text
		ELSE 'unknown'::text
	END AS ov_type

FROM tww_od.overflow ov
    LEFT JOIN tww_od.agxx_overflow ov_agxx ON ov_agxx.fk_overflow = ov.obj_id
    LEFT JOIN tww_od.agxx_last_modification ov_agxx_lm ON ov_agxx_lm.fk_element = ov.obj_id
    LEFT JOIN tww_od.pump pu ON ov.obj_id = pu.obj_id
	LEFT JOIN tww_od.leapingweir lw ON ov.obj_id = lw.obj_id
	LEFT JOIN tww_od.prank_weir pw ON ov.obj_id = pw.obj_id
;


----------------------------
-- Bautenausserhalbbaugebiet
----------------------------
DROP VIEW IF EXISTS tww_app.vw_agxx_bautenausserhalbbaugebiet;
CREATE OR REPLACE VIEW tww_app.vw_agxx_bautenausserhalbbaugebiet
AS
SELECT
	  bg.obj_id
	, bg_agxx.ag96_population AS anzstaendigeeinwohner
	, COALESCE(bg_fct_rev.value_de, bg_fct.value_de) AS arealnutzung
	, bg_dt_ww.value_de AS beseitigung_haeusliches_abwasser
	, bg_dt_iw.value_de AS beseitigung_gewerbliches_abwasser
	, bg_dt_sw.value_de AS beseitigung_platzentwaesserung
	, bg_dt_rw.value_de AS beseitigung_dachentwaesserung
	, bg.identifier AS bezeichnung
	, bg_agxx.ag96_owner_address AS eigentuemeradresse
	, bg_agxx.ag96_owner_name AS eigentuemername
	, bg.population_equivalent AS einwohnergleichwert
	, bg.situation_geometry AS lage
	, bg_agxx.ag96_label_number AS nummer
	, INITCAP(bg_rn.value_de) AS sanierungsbedarf
	, bg.renovation_date AS sanierungsdatum
	, bg.restructuring_concept AS sanierungskonzept
	, concat_ws('','ch113jqg0000',right(COALESCE(bg.fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, bg.remark AS bemerkung_gep
	, COALESCE(bg.last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep
FROM tww_od.building_group bg
	LEFT JOIN tww_od.agxx_building_group bg_agxx ON bg_agxx.fk_building_group = bg.obj_id
	LEFT JOIN tww_vl.building_group_function bg_fct ON bg_fct.code = bg.function
	LEFT JOIN tww_vl.building_group_function_export_rel_agxx bg_fct_rev ON bg_fct_rev.code = bg.function
	LEFT JOIN tww_vl.building_group_renovation_necessity bg_rn ON bg_rn.code = bg.renovation_necessity
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_ww ON bg_dt_ww.code = bg_agxx.ag96_disposal_wastewater
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_iw ON bg_dt_iw.code = bg_agxx.ag96_disposal_industrial_wastewater
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_sw ON bg_dt_sw.code = bg_agxx.ag96_disposal_square_water
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_rw ON bg_dt_rw.code = bg_agxx.ag96_disposal_roof_water
;


----------------------------
-- SBW_Einzugsgebiet
----------------------------
DROP VIEW IF EXISTS tww_app.vw_agxx_sbw_einzugsgebiet;
CREATE OR REPLACE VIEW tww_app.vw_agxx_sbw_einzugsgebiet
 AS
 SELECT cat.obj_id,
    cat.identifier AS bezeichnung,
    cat.population_dim AS einwohner_geplant,
    cat.population AS einwohner_ist,
    cat.surface_dim AS flaeche_geplant,
    cat.surface_area AS flaeche_ist,
    cat.surface_imp_dim AS flaeche_befestigt_geplant,
    cat.surface_imp AS flaeche_befestigt_ist,
    cat.surface_red_dim AS flaeche_reduziert_geplant,
    cat.surface_red AS flaeche_reduziert_ist,
    cat_agxx.ag96_sewer_infiltration_water_dim AS fremdwasseranfall_geplant,
    cat.sewer_infiltration_water AS fremdwasseranfall_ist,
    cat_agxx.ag96_perimeter_geometry AS perimeter_ist,
    cat_agxx.ag96_waste_water_production_dim AS schmutzabwasseranfall_geplant,
    cat.waste_water_production AS schmutzabwasseranfall_ist,
    cat.fk_discharge_point AS einleitstelleref,
    wn.obj_id AS sonderbauwerk_ref,
    concat_ws('', 'ch113jqg0000', right(COALESCE(cat.fk_provider, '00000107'), 8)) AS datenbewirtschafter_gep,
    hcd.remark AS bemerkung_gep,
    COALESCE(cat.last_modification, to_timestamp('1800-01-01', 'YYYY-MM-DD')) AS letzte_aenderung_gep
   FROM tww_od.catchment_area_totals cat
     LEFT JOIN tww_od.agxx_catchment_area_totals cat_agxx ON cat_agxx.fk_catchment_area_totals = cat.obj_id
     LEFT JOIN tww_od.hydraulic_char_data hcd ON hcd.obj_id = cat.fk_hydraulic_char_data
     LEFT JOIN tww_od.wastewater_node wn ON hcd.fk_wastewater_node = wn.obj_id
;


----------------------------
-- VersickerungsbereichAG
----------------------------
DROP VIEW IF EXISTS tww_app.vw_agxx_versickerungsbereichag;
CREATE VIEW tww_app.vw_agxx_versickerungsbereichag
AS
SELECT
	  iz.obj_id
	, zo.identifier AS bezeichnung
	, iz_agxx.ag96_permeability AS durchlaessigkeit
	, iz_agxx.ag96_limitation AS einschraenkung
	, iz_agxx.ag96_thickness AS maechtigkeit
	, iz.perimeter_geometry AS perimeter
	, iz_agxx.ag96_q_check as q_check
	, COALESCE (iz_ic_rev.value_de,iz_ic.value_de) AS versickerungsmoeglichkeitag
	, concat_ws('','ch113jqg0000',right(COALESCE(zo.fk_provider,'00000107'),8)) AS datenbewirtschafter_gep
	, zo.remark AS bemerkung_gep
	, COALESCE(zo.last_modification,TO_TIMESTAMP('1800-01-01','YYYY-MM-DD')) AS letzte_aenderung_gep
FROM tww_od.infiltration_zone iz
  LEFT JOIN tww_od.agxx_infiltration_zone iz_agxx ON iz_agxx.fk_infiltration_zone = iz.obj_id
  LEFT JOIN tww_od.zone zo ON zo.obj_id = iz.obj_id
  LEFT JOIN tww_vl.infiltration_zone_infiltration_capacity iz_ic ON iz_ic.code = iz.infiltration_capacity
  LEFT JOIN tww_vl.infiltration_zone_infiltration_capacity_export_rel_agxx iz_ic_rev ON iz_ic_rev.code = iz.infiltration_capacity;
