----------------
-- Knoten
----------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_gepknoten_upsert()
RETURNS trigger AS
$BODY$
DECLARE
    co_oid varchar(16);
	ws_oid varchar(16);
	wn_oid varchar(16);
	sp_oids varchar(16)[];
BEGIN

  CASE WHEN NEW.funktionag = ANY(ARRAY['Abwasserreinigungsanlage','Anschluss','Leitungsknoten']) THEN
  -- Knoten
  UPDATE tww_app.vw_wastewater_node wn
  SET
  	 identifier= vw_val.bezeichnung
    , backflow_level_current = vw_val.maxrueckstauhoehe
	, bottom_level = vw_val.sohlenkote
	, situation3d_geometry = ST_Force3D(vw_val.lage)
	, wwtp_number = vw_val.ara_nr
	, ag96_is_gateway = gate.code
	, ag64_function = wn_fct.code
	, fk_dataowner = downr.obj_id
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, ag64_last_modification = vw_val.letzte_aenderung_wi
    , ag64_remark = vw_val.bemerkung_wi
	, ag64_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, ag96_last_modification = vw_val.letzte_aenderung_gep
    , ag96_remark = vw_val.bemerkung_gep
	, ag96_fk_provider	= {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
  FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.wastewater_node_ag96_is_gateway gate ON gate.value_de=vw_val.istschnittstelle
	LEFT JOIN tww_vl.wastewater_node_ag64_function wn_fct ON wn_fct.value_de=vw_val.funktionag
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
  WHERE wn.obj_id=vw_val.obj_id;
  IF NOT FOUND THEN
    INSERT INTO tww_app.vw_wastewater_node( 
	  obj_id
	, identifier
    , backflow_level_current
	, bottom_level
	, situation3d_geometry
	, wwtp_number
	, ag96_is_gateway
	, ag64_function
	, fk_dataowner
	, fk_provider
	, ag64_last_modification
    , ag64_remark
	, ag64_fk_provider
	, ag96_last_modification
    , ag96_remark
	, ag96_fk_provider	
	) 
	(SELECT
	  vw_val.obj_id
	, vw_val.bezeichnung
	, vw_val.maxrueckstauhoehe
    , vw_val.sohlenkote
    , ST_Force3D(vw_val.lage)
	, vw_val.ara_nr
	, gate.code
	, wn_fct.code
    , downr.obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , vw_val.letzte_aenderung_wi
    , vw_val.bemerkung_wi
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , vw_val.letzte_aenderung_gep
    , vw_val.bemerkung_gep
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)

	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.wastewater_node_ag96_is_gateway gate ON gate.value_de=vw_val.istschnittstelle
	LEFT JOIN tww_vl.wastewater_node_ag64_function wn_fct ON wn_fct.value_de=vw_val.funktionag
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
	);
  END IF;

   CASE WHEN NEW.funktionag = 'Abwasserreinigungsanlage' THEN
    -- Deckel
  UPDATE tww_app.vw_cover co SET
 	  level = vw_val.deckelkote
	, positional_accuracy = co_posacc.code
	, situation3d_geometry = ST_Force3D(vw_val.lage)
	, fk_dataowner = downr.obj_id
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, last_modification = vw_val.letzte_aenderung_wi
  FROM (SELECT NEW.*) vw_val
    LEFT JOIN tww_vl.cover_positional_accuracy co_posacc ON co_posacc.value_de=vw_val.lagegenauigkeit
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
  WHERE co.identifier=vw_val.bezeichnung
  RETURNING co.obj_id into co_oid;
  IF NOT FOUND THEN
    INSERT INTO tww_app.vw_cover(
	  level
	, positional_accuracy
	, situation3d_geometry
	, fk_dataowner
	, fk_provider
	, identifier
	, last_modification
    )
	(SELECT 
  	  vw_val.deckelkote
	, co_posacc.code
	, ST_Force3D(vw_val.lage)
	, downr.obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, vw_val.bezeichnung
	, vw_val.letzte_aenderung_wi
	FROM (SELECT NEW.*) vw_val
    LEFT JOIN tww_vl.cover_positional_accuracy co_posacc ON co_posacc.value_de=vw_val.lagegenauigkeit
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
	)
	RETURNING obj_id into co_oid;
  END IF;
  
	------------ Abwasserreinigungsanlage ------------
  UPDATE tww_app.vw_wwtp_stucture wwtp SET
  	  kind = 3032
	, accessibility = ws_acc.code
	, detail_geometry3d_geometry = ST_Force3D(vw_val.detailgeometrie)
	, financing = ws_fin.code
	, fk_dataowner = downr.obj_id
	, fk_main_cover = co_oid
	, fk_operator = {ext_schema}.convert_organisationid_to_vsa(vw_val.betreiber)
	, fk_owner = {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, last_modification = vw_val.letzte_aenderung_wi
	, remark = vw_val.bemerkung_wi
	, renovation_necessity = ws_rn.code
	, status = ws_st.code
	, status_survey_year = vw_val.jahr_zustandserhebung
	, structure_condition = vw_val.baulicherzustand
	, year_of_construction = vw_val.baujahr
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.wastewater_structure_accessibility ws_acc ON ws_acc.value_de=vw_val.zugaenglichkeit
	LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.value_de=vw_val.baulicherzustand
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.value_de=vw_val.sanierungsbedarf
	LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.value_de=vw_val.finanzierung
	LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.value_de=vw_val.bauwerkstatus
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
  WHERE wwtp.identifier = vw_val.bezeichnung;
  IF NOT FOUND THEN
	INSERT INTO tww_app.vw_wwtp_stucture(
	  kind
	, accessibility
	, detail_geometry3d_geometry
	, financing
	, fk_dataowner
	, fk_main_cover
	, fk_operator
	, fk_owner
	, fk_provider
	, identifier
	, last_modification
	, remark
	, renovation_necessity
	, status
	, status_survey_year
	, structure_condition
	, year_of_construction
    )
	(SELECT 
  	  3032 --unbekannt
	, ws_acc.code
	, ST_Force3D(vw_val.detailgeometrie)
	, ws_fin.code
	, downr.obj_id
	, co_oid
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.betreiber)
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, vw_val.bezeichnung
	, vw_val.letzte_aenderung_wi
	, vw_val.bemerkung_wi
	, ws_rn.code
	, ws_st.code
	, vw_val.jahr_zustandserhebung
	, vw_val.baulicherzustand
	, vw_val.baujahr
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.wastewater_structure_accessibility ws_acc ON ws_acc.value_de=vw_val.zugaenglichkeit
	LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.value_de=vw_val.baulicherzustand
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.value_de=vw_val.sanierungsbedarf
	LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.value_de=vw_val.finanzierung
	LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.value_de=vw_val.bauwerkstatus
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
	);
	END IF;
    ELSE
    -- keine View, daher geht ON CONFLICT
	-- Rückfallebene für Knoten ohne Topologische Verknüpfung
  INSERT INTO tww_od.agxx_unconnected_node_bwrel (
	obj_id,
	year_of_construction,
	structure_condition,
	status,
	co_level,
    detail_geometry3d_geometry,
	financing,
    ch_function_hierarchic,
    status_survey_year,
    co_positional_accuracy,
    renovation_necessity,
    accessibility,
    fk_operator,
    fk_owner,
    ag96_fk_measure)
	
	SELECT vw_val.obj_id,
	vw_val.baujahr,
	sc.code,
	st.code,
	vw_val.deckelkote,
	ST_Force3D(vw_val.detailgeometrie2d),
	fin.code,
	fhi.code,
	vw_val.jahr_zustandserhebung,
	co_pa.code,
	rn.code,
	acc.code,
	tww_ag6496.convert_organisationid_to_vsa(betreiber),
	tww_ag6496.convert_organisationid_to_vsa(eigentuemer),
	vw_val.gepmassnahmeref
	
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.wastewater_structure_structure_condition sc ON sc.value_de=vw_val.baulicherzustand
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity rn ON rn.value_de=vw_val.sanierungsbedarf
	LEFT JOIN tww_vl.wastewater_structure_financing fin ON fin.value_de=vw_val.finanzierung
	LEFT JOIN tww_vl.wastewater_structure_status st ON st.value_de=vw_val.bauwerkstatus
	LEFT JOIN tww_vl.wastewater_structure_accessibility acc ON acc.value_de=vw_val.zugaenglichkeit
	LEFT JOIN tww_vl.channel_function_hierarchic fhi ON fhi.value_de=(vw_val.funktionhierarchisch||'.unbekannt')
	LEFT JOIN tww_vl.cover_positional_accuracy co_pa ON co_pa.value_de=vw_val.lagegenauigkeit
    ) 
    ON CONFLICT (obj_id) DO UPDATE SET
	(
	  year_of_construction,
	  structure_condition,
	  status,
	  co_level,
      detail_geometry3d_geometry,
	  financing,
      ch_function_hierarchic,
      status_survey_year,
      co_positional_accuracy,
      renovation_necessity,
      accessibility,
      fk_operator,
      fk_owner,
      ag96_fk_measure
	)
	=
	(
	  EXCLUDED.year_of_construction,
	  EXCLUDED.structure_condition,
	  EXCLUDED.status,
	  EXCLUDED.co_level,
	  EXCLUDED.detail_geometry3d_geometry,
	  EXCLUDED.financing,
	  EXCLUDED.ch_function_hierarchic,
	  EXCLUDED.status_survey_year,
	  EXCLUDED.co_positional_accuracy,
	  EXCLUDED.renovation_necessity,
	  EXCLUDED.accessibility,
	  EXCLUDED.fk_operator,
	  EXCLUDED.fk_owner,
	  EXCLUDED.ag96_fk_measure
	);
	
    END CASE;
	
  ELSE
------------ Basic wastewater_structure ------------
  UPDATE tww_app.vw_tww_wastewater_structure ws SET
      identifier = vw_val.bezeichnung
    , ws_type = CASE
		WHEN vw_val.funktionag LIKE 'Einleitstelle%' THEN 'discharge_point'
		WHEN vw_val.funktionag LIKE 'Versickerungsanlage%' THEN 'infiltration_installation'
		WHEN vw_val.funktionag = ANY(
		  ARRAY[
		      'Bodenablauf'
		    , 'Dachwasserschacht'
			, 'Einlaufschacht'
			, 'Entwaesserungsrinne'
			, 'Faulgrube'
			, 'Geleiseschacht'
			, 'Schlammfang'
			, 'Schlammsammler'
			]
		  ) THEN 'manhole' 
		WHEN vw_val.funktionag = ANY(
		  ARRAY[
		      'Absturzbauwerk'
			, 'andere'
			, 'Be_Entlueftung'
			, 'Kontrollschacht'
			, 'Oelabscheider'
			, 'Pumpwerk'
			, 'Regeneuberlauf'
			, 'Schwimmstoffabscheider'
			, 'Spuelschacht'
			, 'Trennbauwerk'
			, 'Vorbehandlung'
			]
		  ) AND vw_val.detailgeometrie IS NULL THEN 'manhole' 
		ELSE 'special_structure' 
	  END
    , ma_function = coalesce(ma_fu.code, ma_fu2.code) -- wird nur angewandt, wenn ws_type = manhole 
    , ss_function = coalesce(ss_fu.code, ss_fu2.code) -- wird nur angewandt, wenn ws_type = special_structure
    , fk_owner = {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
    , status = ws_st.code
    , accessibility = ws_acc.code
    , financing = ws_fin.code
	, status_survey_year = vw_val.jahr_zustandserhebung
    , fk_dataowner = downr.obj_id
    , fk_operator = {ext_schema}.convert_organisationid_to_vsa(vw_val.betreiber)
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , renovation_necessity = ws_rn.code
    , structure_condition = ws_sc.code
    , year_of_construction = vw_val.baujahr
    , co_level = vw_val.deckelkote
	, co_positional_accuracy = co_posacc.code
    , situation3d_geometry = vw_val.lage
    , ii_kind = coalesce(ii_ki.code, ii_ki2.code)
    , dp_relevance = dp_rel.code
	, wn_wwtp_number = vw_val.ara_nr
    , wn_backflow_level_current = vw_val.maxrueckstauhoehe
    , wn_bottom_level = vw_val.sohlenkote
    , wn_fk_dataowner = downr.obj_id
    , wn_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , wn_identifier = vw_val.bezeichnung
    , wn_ag64_last_modification = vw_val.letzte_aenderung_wi
    , wn_ag64_remark = vw_val.letzte_aenderung_wi
	, wn_ag64_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, wn_ag96_last_modification = vw_val.letzte_aenderung_gep
    , wn_ag96_remark = vw_val.bemerkung_gep
	, wn_ag96_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
	, wn_ag96_is_gateway = gate.code
  FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.wastewater_node_ag96_is_gateway gate on gate.value_de=vw_val.istschnittstelle
	LEFT JOIN tww_vl.discharge_point_relevance dp_rel ON dp_rel.value_de=replace(vw_val.funktionag,'Einleitstelle_','')
	LEFT JOIN tww_vl.cover_positional_accuracy co_posacc ON co_posacc.value_de=vw_val.lagegenauigkeit
	LEFT JOIN tww_vl.infiltration_installation_kind ii_ki ON ii_ki.value_de=replace(vw_val.funktionag,'Versickerungsanlage','')
	LEFT JOIN {ext_schema}.vl_infiltration_installation_kind ii_ki2 ON ii_ki2.value_agxx=vw_val.funktionag
	LEFT JOIN tww_vl.special_structure_function ss_fu ON ss_fu.value_de=vw_val.funktionag
	LEFT JOIN {ext_schema}.vl_special_structure_function ss_fu2 ON ss_fu2.value_agxx=vw_val.funktionag
	LEFT JOIN tww_vl.manhole_function ma_fu ON ma_fu.value_de=vw_val.funktionag
	LEFT JOIN {ext_schema}.vl_manhole_function ma_fu2 ON ma_fu2.value_agxx=vw_val.funktionag
	LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.value_de=vw_val.baulicherzustand
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.value_de=vw_val.sanierungsbedarf
	LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.value_de=vw_val.finanzierung
	LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.value_de=vw_val.bauwerkstatus
	LEFT JOIN tww_vl.wastewater_structure_accessibility ws_acc ON ws_acc.value_de=vw_val.zugaenglichkeit
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
  WHERE ws.co_obj_id=vw_val.obj_id;
  IF NOT FOUND THEN
    INSERT INTO tww_app.vw_tww_wastewater_structure(
		  identifier
		, ws_type
		, ma_function
		, ss_function
		, fk_owner
		, status
		, accessibility
		, financing
		, status_survey_year
		, fk_dataowner
		, fk_operator
		, fk_provider
		, renovation_necessity
		, structure_condition
		, year_of_construction
		, co_level
		, co_positional_accuracy
		, situation3d_geometry
		, ii_kind
		, dp_relevance
		, wn_obj_id
		, wn_wwtp_number
		, wn_backflow_level_current
		, wn_bottom_level
		, wn_fk_dataowner
		, wn_fk_provider
		, wn_identifier
		, wn_ag64_last_modification
		, wn_ag64_remark
		, wn_ag64_fk_provider
		, wn_ag96_last_modification
		, wn_ag96_remark
		, wn_ag96_fk_provider
		, wn_ag96_is_gateway
		) 
	  (
	  SELECT
		  vw_val.bezeichnung
		, CASE
			WHEN vw_val.funktionag LIKE 'Einleitstelle%' THEN 'discharge_point'
		WHEN vw_val.funktionag LIKE 'Versickerungsanlage%' THEN 'infiltration_installation'
		WHEN vw_val.funktionag = ANY(
		  ARRAY[
		      'Bodenablauf'
		    , 'Dachwasserschacht'
			, 'Einlaufschacht'
			, 'Entwaesserungsrinne'
			, 'Faulgrube'
			, 'Geleiseschacht'
			, 'Schlammfang'
			, 'Schlammsammler'
			]
		  ) THEN 'manhole' 
		WHEN vw_val.funktionag = ANY(
		  ARRAY[
		      'Absturzbauwerk'
			, 'andere'
			, 'Be_Entlueftung'
			, 'Kontrollschacht'
			, 'Oelabscheider'
			, 'Pumpwerk'
			, 'Regeneuberlauf'
			, 'Schwimmstoffabscheider'
			, 'Spuelschacht'
			, 'Trennbauwerk'
			, 'Vorbehandlung'
			]
		  ) AND vw_val.detailgeometrie IS NULL THEN 'manhole' 
		ELSE 'special_structure' 
	  END
		, coalesce(ma_fu.code, ma_fu2.code) -- wird nur angewandt, wenn ws_type = manhole
		, coalesce(ss_fu.code, ss_fu2.code) -- wird nur angewandt, wenn ws_type = special_structure
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
		, ws_st.code
		, ws_acc.code
		, ws_fin.code
		, vw_val.jahr_zustandserhebung
		, downr.obj_id
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.betreiber)
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
		, ws_rn.code
		, ws_sc.code
		, vw_val.baujahr
		, vw_val.deckelkote
		, co_posacc.code
		, vw_val.lage
		, coalesce(ii_ki.code, ii_ki2.code)
		, dp_rel.code
		, vw_val.obj_id
		, vw_val.ara_nr
		, vw_val.maxrueckstauhoehe
		, vw_val.sohlenkote
		, downr.obj_id
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
		, vw_val.bezeichnung
		, vw_val.letzte_aenderung_wi
		, vw_val.bemerkung_wi
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
		, vw_val.letzte_aenderung_gep
		, vw_val.bemerkung_gep
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
		, gate.code
	  FROM (SELECT NEW.*) vw_val
	  LEFT JOIN tww_vl.wastewater_node_ag96_is_gateway gate on gate.value_de=vw_val.istschnittstelle
	  LEFT JOIN tww_vl.discharge_point_relevance dp_rel ON dp_rel.value_de=replace(vw_val.funktionag,'Einleitstelle_','')
	  LEFT JOIN tww_vl.cover_positional_accuracy co_posacc ON co_posacc.value_de=vw_val.lagegenauigkeit
	  LEFT JOIN tww_vl.infiltration_installation_kind ii_ki ON ii_ki.value_de=replace(vw_val.funktionag,'Versickerungsanlage','')
	  LEFT JOIN {ext_schema}.vl_infiltration_installation_kind ii_ki2 ON ii_ki2.value_agxx=vw_val.funktionag
	  LEFT JOIN tww_vl.special_structure_function ss_fu ON ss_fu.value_de=vw_val.funktionag
	  LEFT JOIN {ext_schema}.vl_special_structure_function ss_fu2 ON ss_fu2.value_agxx=vw_val.funktionag
  	  LEFT JOIN tww_vl.manhole_function ma_fu ON ma_fu.value_de=vw_val.funktionag
	  LEFT JOIN {ext_schema}.vl_manhole_function ma_fu2 ON ma_fu2.value_agxx=vw_val.funktionag
	  LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.value_de=vw_val.baulicherzustand
	  LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.value_de=vw_val.sanierungsbedarf
	  LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.value_de=vw_val.finanzierung
	  LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.value_de=vw_val.bauwerkstatus
	  LEFT JOIN tww_vl.wastewater_structure_accessibility ws_acc ON ws_acc.value_de=vw_val.zugaenglichkeit
	  LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
	  );
    END IF;  

  END CASE;

------------ fk_wastewater_structure ------------
/*
	Einerseits werden die Abwasserknoten neu attributiert, andererseits die Deckel
*/
	  UPDATE tww_od.wastewater_structure 
		SET detail_geometry3d_geometry =ST_Force3D(NEW.detailgeometrie)
		WHERE fk_main_wastewater_node = NEW.obj_id;


    SELECT ws.obj_id, wn.obj_id, array_agg(sp.obj_id) INTO STRICT ws_oid, wn_oid, sp_oids
	  FROM tww_od.wastewater_node wn 
	  LEFT JOIN  
	    (SELECT ws.obj_id, st_buffer(detail_geometry3d_geometry,0.0001)as detail_geometry3d_geometry 
		 FROM tww_od.wastewater_structure ws
		 LEFT JOIN tww_od.channel ch on ws.obj_id=ch.obj_id
		 WHERE ws.detail_geometry3d_geometry IS NOT NULL
		 AND ch.obj_id is NULL LIMIT 1
		) ws ON 
		ST_CoveredBy(ST_Force2D(wn.situation3d_geometry)
		  , ST_Force2D(ws.detail_geometry3d_geometry))
	  LEFT JOIN tww_od.wastewater_networkelement ne on ne.obj_id=wn.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws_old on ne.fk_wastewater_structure=ws_old.obj_id
	  LEFT JOIN tww_od.structure_part sp on sp.fk_wastewater_structure=ws_old.obj_id
	  WHERE wn.obj_id = NEW.obj_id
	  GROUP BY ws.obj_id, wn.obj_id;
			
	CASE WHEN ws_oid is not NULL THEN
	  UPDATE tww_od.wastewater_networkelement
        SET fk_wastewater_structure = ws_oid
        WHERE obj_id = wn_oid;

      UPDATE tww_od.structure_part
        SET fk_wastewater_structure = ws_oid
        WHERE obj_id = ANY(sp_oids);
		
	ELSE NULL;
	END CASE;

------------ GEPMassnahme ------------ 
	UPDATE tww_od.wastewater_structure
        SET ag96_fk_measure = coalesce(NEW.gepmassnahmeref,ag96_fk_measure)
        WHERE fk_main_wastewater_node = NEW.obj_id;

  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION {ext_schema}.ft_gepknoten_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_app.vw_tww_wastewater_structure where wn_obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;