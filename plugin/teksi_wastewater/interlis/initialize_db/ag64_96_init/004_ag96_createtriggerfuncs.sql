----------------
-- organisation
----------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_organisation_upsert()
RETURNS trigger AS
$BODY$
BEGIN
INSERT INTO tww_od.organisation(obj_id, 
	identifier, 
	remark, 
	uid, 
	last_modification,
	organisation_type,
	fk_dataowner, 
	fk_provider) 
	VALUES 
	(
	{ext_schema}.convert_organisationid_to_vsa(NEW.obj_id) , -- Aargauer Organisations-OID sind 20 Zeichen lang
	NEW.bezeichnung, 
	NEW.bemerkung,
	REGEXP_REPLACE(new.uid,'\1-\2.\3.','(^.{3})(.{3})(.{3})'), -- allgemeine UID Kt. Aargau, nicht AfU
	now(), 
	(array['waste_water_association'
		, 'administrative_office'
		, 'private'
		, 'canton'
		, 'municipality'
		,'cooperative'
		, 'canton'
		, 'private'])[
		  array_position(array['Abwasserverband'
					  , 'Amt'
					  , 'andere'
					  , 'Bund'
					  , 'Gemeinde'
					  , 'Genossenschaft_Kooperation'
					  , 'Kanton'
					  , 'Privat'],NEW.organisationtyp::text)],
	'ch20p3q400000000',
	'ch20p3q400000000')
ON CONFLICT (obj_id) DO 
UPDATE
SET identifier=EXCLUDED.identifier,
remark=EXCLUDED.remark,
uid=EXCLUDED.uid,
last_modification=EXCLUDED.last_modification
;

END;
$BODY$
LANGUAGE plpgsql;

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
	, fk_dataowner = vw_val.datenherr
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
    , vw_val.datenherr
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
	);
  END IF;

    CASE WHEN NEW.funktionag = 'Abwasserreinigungsanlage' THEN
    -- Deckel
  UPDATE tww_app.vw_cover co SET
 	  level = vw_val.deckelkote
	, positional_accuracy = co_posacc.code
	, situation3d_geometry = ST_Force3D(vw_val.lage)
	, fk_dataowner = vw_val.datenherr
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, last_modification = vw_val.letzte_aenderung_wi
  FROM (SELECT NEW.*) vw_val
    LEFT JOIN tww_vl.cover_positional_accuracy co_posacc ON co_posacc.value_de=vw_val.lagegenauigkeit
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
	, vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, vw_val.bezeichnung
	, vw_val.letzte_aenderung_wi
	FROM (SELECT NEW.*) vw_val
    LEFT JOIN tww_vl.cover_positional_accuracy co_posacc ON co_posacc.value_de=vw_val.lagegenauigkeit
	)
	RETURNING obj_id into co_oid;
  END IF;
  
	------------ Abwasserreinigungsanlage ------------
  UPDATE tww_app.vw_wwtp_stucture wwtp SET
  	  kind = 3032
	, accessibility = ws_acc.code
	, detail_geometry3d_geometry = ST_Force3D(vw_val.detailgeometrie)
	, financing = ws_fin.code
	, fk_dataowner = vw_val.datenherr
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
	, vw_val.datenherr
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
	);
	END IF;
    ELSE
    -- keine View, daher geht ON CONFLICT
	INSERT INTO {ext_schema}.od_unconnected_node_bwrel(
    obj_id,
	baujahr,
	baulicherzustand,
	bauwerkstatus,
	deckelkote,
    detailgeometrie2d ,
	finanzierung,
    funktionhierarchisch,
    jahr_zustandserhebung,
    lagegenauigkeit,
    sanierungsbedarf,
    zugaenglichkeit,
    betreiber,
    eigentuemer,
    gepmassnahmeref
    )
    VALUES(
    NEW.obj_id,
	NEW.baujahr,
	NEW.baulicherzustand,
	NEW.bauwerkstatus,
	NEW.deckelkote,
    NEW.detailgeometrie,
	NEW.finanzierung,
    NEW.funktionhierarchisch,
    NEW.jahr_zustandserhebung,
    NEW.lagegenauigkeit,
    NEW.sanierungsbedarf,
    NEW.zugaenglichkeit,
    NEW.betreiber,
    NEW.eigentuemer,
    NEW.gepmassnahmeref
    ) 
    ON CONFLICT (obj_id) DO UPDATE SET
	(
	  baujahr,
	  baulicherzustand,
	  bauwerkstatus,
	  deckelkote,
      detailgeometrie2d ,
	  finanzierung,
      funktionhierarchisch,
      jahr_zustandserhebung,
      lagegenauigkeit,
      sanierungsbedarf,
      zugaenglichkeit,
      betreiber,
      eigentuemer,
      gepmassnahmeref
	)
	=
	(
	  EXCLUDED.baujahr,
	  EXCLUDED.baulicherzustand,
	  EXCLUDED.bauwerkstatus,
	  EXCLUDED.deckelkote,
      EXCLUDED.detailgeometrie2d ,
	  EXCLUDED.finanzierung,
      EXCLUDED.funktionhierarchisch,
      EXCLUDED.jahr_zustandserhebung,
      EXCLUDED.lagegenauigkeit,
      EXCLUDED.sanierungsbedarf,
      EXCLUDED.zugaenglichkeit,
      EXCLUDED.betreiber,
      EXCLUDED.eigentuemer,
      EXCLUDED.gepmassnahmeref
	);
	
    END CASE;
	
  ELSE
------------ Basic wastewater_structure ------------
  UPDATE tww_app.vw_tww_wastewater_structure ws SET
      identifier = vw_val.bezeichnung
    , ws_type = CASE
		WHEN vw_val.funktionag LIKE 'Einleitstelle%' THEN 'discharge_point'
		WHEN vw_val.funktionag LIKE 'Versickerungsanlage%' THEN 'infiltration_installation'
		WHEN vw_val.detailgeometrie IS NOT NULL THEN 'special_structure'
		ELSE 'manhole' 
	  END
    , ma_function = CASE WHEN  vw_val.detailgeometrie IS NULL THEN coalesce(ma_fu.code, ma_fu2.code) ELSE NULL END
    , ss_function = CASE WHEN vw_val.detailgeometrie IS NOT NULL THEN coalesce(ss_fu.code, ss_fu2.code) ELSE NULL END
    , fk_owner = {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
    , status = ws_st.code
    , accessibility = ws_acc.code
    , financing = ws_fin.code
	, status_survey_year = vw_val.jahr_zustandserhebung
    , fk_dataowner = vw_val.datenherr
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
    , wn_fk_dataowner = vw_val.datenherr
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
			WHEN vw_val.detailgeometrie IS NOT NULL THEN 'special_structure'
			ELSE 'manhole' 
		  END
		, CASE WHEN vw_val.detailgeometrie IS NULL THEN coalesce(ma_fu.code, ma_fu2.code) ELSE NULL END
		, CASE WHEN vw_val.detailgeometrie IS NOT NULL THEN coalesce(ss_fu.code, ss_fu2.code) ELSE NULL END
		, {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
		, ws_st.code
		, ws_acc.code
		, ws_fin.code
		, vw_val.jahr_zustandserhebung
		, vw_val.datenherr
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
		, vw_val.datenherr
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
	  );
    END IF;  

  END CASE;


------------ fk_wastewater_structure ------------
/*
	Einerseits werden die Abwasserknoten neu attributiert, andererseits die Deckel
*/
	  UPDATE tww_od.wastewater_structure 
		SET detail_geometry3d_geometry =ST_force3D(NEW.detailgeometrie)
		WHERE fk_main_wastewater_node = NEW.obj_id;


    SELECT ws.obj_id, wn.obj_id, array_agg(sp.obj_id) INTO STRICT ws_oid, wn_oid, sp_oids
	  FROM tww_od.wastewater_node wn 
	  LEFT JOIN  
	    (SELECT ws.obj_id, st_buffer(detail_geometry3d_geometry,0.1)as detail_geometry3d_geometry 
		 FROM tww_od.wastewater_structure ws
		 LEFT JOIN tww_od.channel ch on ws.obj_id=ch.obj_id
		 WHERE ws.detail_geometry3d_geometry IS NOT NULL
		 AND ch.obj_id is NULL
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
        WHERE obj_id IN (sp_oids);
		
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




--------------------------------
---------- GEPHaltung ----------
--------------------------------



CREATE OR REPLACE FUNCTION {ext_schema}.ft_gephaltung_upsert()
RETURNS trigger AS
$BODY$
DECLARE
	pipe_profile_record record;
	new_pipe_profile varchar(16);
	ws_oid_for_measure varchar(16);
BEGIN

	-- insert pipe profile if not exists
	SELECT
	  ppt.code
	, pp.obj_id
	INTO pipe_profile_record
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.pipe_profile_profile_type ppt ON ppt.value_de =  vw_val.profiltyp 
	LEFT JOIN tww_od.pipe_profile pp ON pp.profile_type=ppt.code 
									 AND (vw_val.lichte_breite_ist = 0 OR
										 pp.height_width_ratio=vw_val.lichte_hoehe_ist/vw_val.lichte_breite_ist
										 ) 
	;
	
	CASE 
		WHEN pipe_profile_record.obj_id is null
		THEN
			INSERT INTO tww_od.pipe_profile
			(
			  obj_id
			, profile_type
			, identifier
			, height_width_ratio
			, fk_dataowner
			, fk_provider
			)
			(SELECT
			  tww_sys.generate_oid('tww_od'::text, 'pipe_profile'::text)
			, ppt.code
			, array_to_string(
			    array[ppt.abbr_de,vw_val.lichte_hoehe_ist::varchar,vw_val.lichte_breite_ist::varchar]
				,'_' -- delimiter
				)
			, vw_val.lichte_hoehe_ist/vw_val.lichte_breite_ist
			, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenherr)
			, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
			FROM (SELECT NEW.*) vw_val
			LEFT JOIN tww_vl.pipe_profile_profile_type ppt ON ppt.value_de =  vw_val.profiltyp 
			)
			RETURNING obj_id INTO new_pipe_profile;
		ELSE
			new_pipe_profile:=pipe_profile_record.obj_id;
	END CASE;
	
	-- Reach 
	UPDATE tww_app.vw_tww_reach re SET
      clear_height = vw_val.lichte_hoehe_ist
	, ag96_clear_height_planned = vw_val.lichte_hoehe_geplant
	, ag96_clear_width_planned = vw_val.lichte_breite_geplant
    , material = re_mat.code
    , ch_usage_current = coalesce(ch_uc.code,ch_uc2.code)
    , ch_function_hierarchic = ch_fhi.code
    , ws_status = ws_st.code
    , ws_fk_owner = {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
	, ws_status_survey_year = vw_val.jahr_zustandserhebung
    , ch_function_hydraulic = ch_fhy.code
    , fk_pipe_profile = new_pipe_profile
	, hydraulic_load_current = vw_val.hydraulischebelastung
    , length_effective = vw_val.laengeeffektiv
    , progression3d_geometry = ST_Force3D(vw_val.verlauf)
    , reliner_material = re_rm.code
    , reliner_nominal_size = vw_val.reliner_nennweite
    , relining_construction = re_rc.code
    , relining_kind = re_rk.code
    , fk_dataowner = vw_val.datenherr
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , identifier = vw_val.bezeichnung
    , last_modification = vw_val.letzte_aenderung_wi
    , remark = vw_val.bemerkung_wi
    , ch_usage_planned = coalesce(ch_up.code,ch_up2.code)
    , ws_financing = ws_fin.code
    , ws_fk_operator = {ext_schema}.convert_organisationid_to_vsa(vw_val.betreiber)
    , ws_identifier = vw_val.bezeichnung
    , ws_last_modification = vw_val.letzte_aenderung_wi
    , ws_remark = vw_val.bemerkung_wi
    , ws_renovation_necessity = ws_rn.code
    , ws_replacement_value = vw_val.wiederbeschaffungswert
    , ws_rv_base_year = vw_val.wbw_basisjahr
    , ws_structure_condition = ws_sc.code
    , ws_year_of_construction = vw_val.baujahr
    , rp_from_elevation_accuracy = rp_ea_fr.code
    , rp_from_fk_dataowner = vw_val.datenherr
    , rp_from_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , rp_from_fk_wastewater_networkelement = vw_val.startknoten
    , rp_from_last_modification = vw_val.letzte_aenderung_wi
    , rp_from_level = vw_val.kote_beginn
    , rp_to_elevation_accuracy = rp_ea_to.code
    , rp_to_fk_dataowner = vw_val.datenherr
    , rp_to_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , rp_to_fk_wastewater_networkelement = vw_val.endknoten
    , rp_to_last_modification = vw_val.letzte_aenderung_wi
    , rp_to_level = vw_val.kote_ende
	, ag64_last_modification = vw_val.letzte_aenderung_wi
    , ag64_remark = vw_val.bemerkung_wi
	, ag64_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, ag96_last_modification = vw_val.letzte_aenderung_gep
    , ag96_remark = vw_val.bemerkung_gep
	, ag96_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.reach_material re_mat ON re_mat.value_de=vw_val.material
	LEFT JOIN tww_vl.channel_usage_current ch_uc ON ch_uc.value_de=vw_val.nutzungsartag_ist
	LEFT JOIN {ext_schema}.vl_channel_usage_current ch_uc2 ON ch_uc2.value_agxx=vw_val.nutzungsartag_ist
	LEFT JOIN tww_vl.channel_function_hierarchic ch_fhi ON ch_fhi.value_de=vw_val.funktionhierarchisch
	LEFT JOIN tww_vl.channel_function_hydraulic ch_fhy ON ch_fhy.value_de=vw_val.funktionhydraulisch
	LEFT JOIN tww_vl.channel_usage_planned ch_up ON ch_up.value_de=vw_val.nutzungsartag_geplant
	LEFT JOIN {ext_schema}.vl_channel_usage_planned ch_up2 ON ch_up2.value_agxx=vw_val.nutzungsartag_geplant
	LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.value_de=vw_val.bauwerkstatus
	LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.value_de=vw_val.baulicherzustand
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.value_de=vw_val.sanierungsbedarf
	LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.value_de=vw_val.finanzierung
	LEFT JOIN tww_vl.reach_reliner_material re_rm ON re_rm.value_de=vw_val.reliner_material
	LEFT JOIN tww_vl.reach_relining_construction re_rc ON re_rc.value_de=vw_val.reliner_bautechnik
	LEFT JOIN tww_vl.reach_relining_kind re_rk ON re_rk.value_de=vw_val.reliner_art
	LEFT JOIN tww_vl.reach_point_elevation_accuracy rp_ea_fr ON rp_ea_fr.value_de=vw_val.hoehengenauigkeit_von
	LEFT JOIN tww_vl.reach_point_elevation_accuracy rp_ea_to ON rp_ea_to.value_de=vw_val.hoehengenauigkeit_nach
	WHERE vw_val.obj_id=re.obj_id
	RETURNING ws_obj_id INTO ws_oid_for_measure;
	IF NOT FOUND THEN
	INSERT INTO tww_app.vw_tww_reach
	(
	  obj_id
    , clear_height
	, ag96_clear_height_planned
	, ag96_clear_width_planned
    , material
    , ch_usage_current
    , ch_function_hierarchic
    , ws_status
    , ws_fk_owner
	, ws_status_survey_year
    , ch_function_hydraulic
    , fk_pipe_profile
	, hydraulic_load_current
    , length_effective
    , progression3d_geometry
    , reliner_material
    , reliner_nominal_size
    , relining_construction
    , relining_kind
    , fk_dataowner
    , fk_provider
    , identifier
    , last_modification
    , remark
    , ch_usage_planned
    , ws_financing
    , ws_fk_operator
    , ws_identifier
    , ws_last_modification
    , ws_remark
    , ws_renovation_necessity
    , ws_replacement_value
    , ws_rv_base_year
    , ws_structure_condition
    , ws_year_of_construction
    , rp_from_elevation_accuracy
    , rp_from_fk_dataowner
    , rp_from_fk_provider
    , rp_from_fk_wastewater_networkelement
    , rp_from_last_modification
    , rp_from_level
    , rp_to_elevation_accuracy
    , rp_to_fk_dataowner
    , rp_to_fk_provider
    , rp_to_fk_wastewater_networkelement
    , rp_to_last_modification
    , rp_to_level
	, ag64_last_modification
    , ag64_remark
	, ag64_fk_provider
	, ag96_last_modification
    , ag96_remark
	, ag96_fk_provider
	)
	( SELECT 
	  vw_val.obj_id
    , vw_val.lichte_hoehe_ist
	, vw_val.lichte_hoehe_geplant
	, vw_val.lichte_breite_geplant
    , re_mat.code
    , coalesce(ch_uc.code,ch_uc2.code)
    , ch_fhi.code
    , ws_st.code
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.eigentuemer)
	, vw_val.jahr_zustandserhebung
    , ch_fhy.code
    , new_pipe_profile
	, vw_val.hydraulischebelastung
    , vw_val.laengeeffektiv
    , ST_Force3D(vw_val.verlauf)
    , re_rm.code
    , vw_val.reliner_nennweite
    , re_rc.code
    , re_rk.code
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , vw_val.bezeichnung
    , vw_val.letzte_aenderung_wi
    , vw_val.bemerkung_wi
    , coalesce(ch_up.code,ch_up2.code)
    , ws_fin.code
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.betreiber)
    , vw_val.bezeichnung
    , vw_val.letzte_aenderung_wi
    , vw_val.bemerkung_wi
    , ws_rn.code
    , vw_val.wiederbeschaffungswert
    , vw_val.wbw_basisjahr
    , ws_sc.code
    , vw_val.baujahr
    , rp_ea_fr.code
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , vw_val.startknoten
    , vw_val.letzte_aenderung_wi
    , vw_val.kote_beginn
    , rp_ea_to.code
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , vw_val.endknoten
    , vw_val.letzte_aenderung_wi
    , vw_val.kote_ende
	, vw_val.letzte_aenderung_wi
    , vw_val.bemerkung_wi
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
	, vw_val.letzte_aenderung_gep
    , vw_val.bemerkung_gep
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.reach_material re_mat ON re_mat.value_de=vw_val.material
	LEFT JOIN tww_vl.channel_usage_current ch_uc ON ch_uc.value_de=vw_val.nutzungsartag_ist
	LEFT JOIN {ext_schema}.vl_channel_usage_current ch_uc2 ON ch_uc2.value_agxx=vw_val.nutzungsartag_ist
	LEFT JOIN tww_vl.channel_function_hierarchic ch_fhi ON ch_fhi.value_de=vw_val.funktionhierarchisch
	LEFT JOIN tww_vl.channel_function_hydraulic ch_fhy ON ch_fhy.value_de=vw_val.funktionhydraulisch
	LEFT JOIN tww_vl.channel_usage_planned ch_up ON ch_up.value_de=vw_val.nutzungsartag_geplant
	LEFT JOIN {ext_schema}.vl_channel_usage_planned ch_up2 ON ch_up2.value_agxx=vw_val.nutzungsartag_geplant
	LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws_st.value_de=vw_val.bauwerkstatus
	LEFT JOIN tww_vl.wastewater_structure_structure_condition ws_sc ON ws_sc.value_de=vw_val.baulicherzustand
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity ws_rn ON ws_rn.value_de=vw_val.sanierungsbedarf
	LEFT JOIN tww_vl.wastewater_structure_financing ws_fin ON ws_fin.value_de=vw_val.finanzierung
	LEFT JOIN tww_vl.reach_reliner_material re_rm ON re_rm.value_de=vw_val.reliner_material
	LEFT JOIN tww_vl.reach_relining_construction re_rc ON re_rc.value_de=vw_val.reliner_bautechnik
	LEFT JOIN tww_vl.reach_relining_kind re_rk ON re_rk.value_de=vw_val.reliner_art
	LEFT JOIN tww_vl.reach_point_elevation_accuracy rp_ea_fr ON rp_ea_fr.value_de=vw_val.hoehengenauigkeit_von
	LEFT JOIN tww_vl.reach_point_elevation_accuracy rp_ea_to ON rp_ea_to.value_de=vw_val.hoehengenauigkeit_nach
	)	RETURNING ws_obj_id INTO ws_oid_for_measure;
	END IF;
	------------ GEPMassnahme ------------ 
	UPDATE tww_od.wastewater_structure
        SET ag96_fk_measure = coalesce(NEW.gepmassnahmeref,ag96_fk_measure)
        WHERE obj_id = ws_oid_for_measure;

	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_gephaltung_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_app.vw_tww_reach where obj_id=old.obj_id;
	RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;





--------------------------------
--------- GEPMassnahme ---------
--------------------------------
CREATE OR REPLACE FUNCTION {ext_schema}.ft_gepmassnahme_upsert()
RETURNS trigger AS
$BODY$
BEGIN
    UPDATE tww_od.measure msr
	SET
	  category = msr_cat.code
    , date_entry = vw_val.datum_eingang
    , description = vw_val.beschreibung
    , identifier = vw_val.bezeichnung
    , intervention_demand = vw_val.handlungsbedarf
    , line_geometry = vw_val.ausdehnung
    , link = vw_val.verweis
    , perimeter_geometry = vw_val.perimeter
    , priority = msr_pri.code
    , remark = vw_val.bemerkung
    , status = msr_st.code
    , symbolpos_geometry = vw_val.symbolpos
    , total_cost = vw_val.gesamtkosten
    , year_implementation_effective = vw_val.jahr_umsetzung_effektiv
    , year_implementation_planned = vw_val.jahr_umsetzung_geplant
    , last_modification = vw_val.letzte_aenderung_gep
    , fk_dataowner = vw_val.datenherr
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , fk_responsible_entity = {ext_schema}.convert_organisationid_to_vsa(vw_val.traegerschaft)
    , fk_responsible_start = {ext_schema}.convert_organisationid_to_vsa(vw_val.verantwortlich_ausloesung)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.measure_category msr_cat on msr_cat.value_de=vw_val.kategorie
	LEFT JOIN tww_vl.measure_priority msr_pri on msr_pri.value_de = vw_val.prioritaetag
	LEFT JOIN tww_vl.measure_status msr_st on msr_st.value_de = vw_val.status
	WHERE msr.obj_id=vw_val.obj_id;
	IF NOT FOUND THEN
	INSERT INTO tww_od.measure(
	obj_id
    , category
    , date_entry
    , description
    , identifier
    , intervention_demand
    , line_geometry
    , link
    , perimeter_geometry
    , priority
    , remark
    , status
    , symbolpos_geometry
    , total_cost
    , year_implementation_effective
    , year_implementation_planned
    , last_modification
    , fk_dataowner
    , fk_provider
    , fk_responsible_entity
    , fk_responsible_start
	)
	(SELECT
	  vw_val.obj_id
    , msr_cat.code
    , vw_val.datum_eingang
    , vw_val.beschreibung
    , vw_val.bezeichnung
    , vw_val.handlungsbedarf
    , vw_val.ausdehnung
    , vw_val.verweis
    , vw_val.perimeter
    , msr_pri.code
    , vw_val.bemerkung
    , msr_st.code
    , vw_val.symbolpos
    , vw_val.gesamtkosten
    , vw_val.jahr_umsetzung_effektiv
    , vw_val.jahr_umsetzung_geplant
    , vw_val.letzte_aenderung_gep
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.traegerschaft)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.verantwortlich_ausloesung)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.measure_category msr_cat on msr_cat.value_de=vw_val.kategorie
	LEFT JOIN tww_vl.measure_priority msr_pri on msr_pri.value_de = vw_val.prioritaetag
	LEFT JOIN tww_vl.measure_status msr_st on msr_st.value_de = vw_val.status
	);
	END IF
	;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_gepmassnahme_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_od.measure where obj_id=old.obj_id;
	  RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;





--------------------------------
-------- Einzugsgebiet ---------
--------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_einzugsgebiet_upsert()
RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO tww_od.catchment_area(
	  obj_id
    , direct_discharge_current
    , direct_discharge_planned
    , discharge_coefficient_rw_current
    , discharge_coefficient_rw_planned
    , discharge_coefficient_ww_current
    , discharge_coefficient_ww_planned
    , drainage_system_current
    , drainage_system_planned
    , identifier
    , infiltration_current
    , infiltration_planned
    , perimeter_geometry
    , population_density_current
    , population_density_planned
    , remark
    , retention_current
    , retention_planned
    , runoff_limit_current
    , runoff_limit_planned
    , seal_factor_rw_current
    , seal_factor_rw_planned
    , seal_factor_ww_current
    , seal_factor_ww_planned
    , sewer_infiltration_water_production_current
    , sewer_infiltration_water_production_planned
    , surface_area
    , waste_water_production_current
    , waste_water_production_planned
    , last_modification
    , fk_dataowner
    , fk_provider
    , fk_wastewater_networkelement_rw_current
    , fk_wastewater_networkelement_rw_planned
    , fk_wastewater_networkelement_ww_planned
    , fk_wastewater_networkelement_ww_current
	)
	(
	SELECT
	  obj_id
    , ddc.code
    , ddp.code
    , vw_val.abflussbeiwert_rw_ist
    , vw_val.abflussbeiwert_rw_geplant
    , vw_val.abflussbeiwert_sw_ist
    , vw_val.abflussbeiwert_sw_geplant
    , dsc.code
    , dsp.code
    , vw_val.bezeichnung
    , ic.code
    , ip.code
    , vw_val.perimeter
    , vw_val.einwohnerdichte_ist
    , vw_val.einwohnerdichte_geplant
    , vw_val.bemerkung_gep
    , rc.code
    , rp.code
    , vw_val.abflussbegrenzung_ist
    , vw_val.abflussbegrenzung_geplant
    , vw_val.befestigungsgrad_rw_ist
    , vw_val.befestigungsgrad_rw_geplant
    , vw_val.befestigungsgrad_sw_ist
    , vw_val.befestigungsgrad_sw_geplant
    , vw_val.fremdwasseranfall_ist
    , vw_val.fremdwasseranfall_geplant
    , vw_val.flaeche
    , vw_val.abwasseranfall_ist
    , vw_val.abwasseranfall_geplant
    , vw_val.letzte_aenderung_gep
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.gepknoten_rw_istref
    , vw_val.gepknoten_rw_geplantref
    , vw_val.gepknoten_sw_geplantref
    , vw_val.gepknoten_sw_istref
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.catchment_area_direct_discharge_current ddc on ddc.code = vw_val.direkteinleitung_in_gewaesser_ist
	LEFT JOIN tww_vl.catchment_area_direct_discharge_planned ddp on ddp.code = vw_val.direkteinleitung_in_gewaesser_geplant
	LEFT JOIN tww_vl.catchment_area_drainage_system_current dsc on dsc.code = vw_val.entwaesserungssystemag_ist
	LEFT JOIN tww_vl.catchment_area_drainage_system_planned dsp on dsp.code = vw_val.entwaesserungssystemag_geplant
	LEFT JOIN tww_vl.catchment_area_infiltration_current ic on ic.code = vw_val.versickerung_ist
	LEFT JOIN tww_vl.catchment_area_infiltration_planned ip on ip.code = vw_val.versickerung_geplant
	LEFT JOIN tww_vl.catchment_area_retention_current rc on rc.code = vw_val.retention_ist
	LEFT JOIN tww_vl.catchment_area_retention_planned rp on rp.code = vw_val.retention_geplant	
	)
	ON CONFLICT (obj_id)  DO UPDATE SET
	(
	 direct_discharge_current
    , direct_discharge_planned
    , discharge_coefficient_rw_current
    , discharge_coefficient_rw_planned
    , discharge_coefficient_ww_current
    , discharge_coefficient_ww_planned
    , drainage_system_current
    , drainage_system_planned
    , identifier
    , infiltration_current
    , infiltration_planned
    , perimeter_geometry
    , population_density_current
    , population_density_planned
    , remark
    , retention_current
    , retention_planned
    , runoff_limit_current
    , runoff_limit_planned
    , seal_factor_rw_current
    , seal_factor_rw_planned
    , seal_factor_ww_current
    , seal_factor_ww_planned
    , sewer_infiltration_water_production_current
    , sewer_infiltration_water_production_planned
    , surface_area
    , waste_water_production_current
    , waste_water_production_planned
    , last_modification
    , fk_dataowner
    , fk_provider
    , fk_wastewater_networkelement_rw_current
    , fk_wastewater_networkelement_rw_planned
    , fk_wastewater_networkelement_ww_planned
    , fk_wastewater_networkelement_ww_current
	)
	=
	(
	  EXCLUDED.direct_discharge_current
    , EXCLUDED.direct_discharge_planned
    , EXCLUDED.discharge_coefficient_rw_current
    , EXCLUDED.discharge_coefficient_rw_planned
    , EXCLUDED.discharge_coefficient_ww_current
    , EXCLUDED.discharge_coefficient_ww_planned
    , EXCLUDED.drainage_system_current
    , EXCLUDED.drainage_system_planned
    , EXCLUDED.identifier
    , EXCLUDED.infiltration_current
    , EXCLUDED.infiltration_planned
    , EXCLUDED.perimeter_geometry
    , EXCLUDED.population_density_current
    , EXCLUDED.population_density_planned
    , EXCLUDED.remark
    , EXCLUDED.retention_current
    , EXCLUDED.retention_planned
    , EXCLUDED.runoff_limit_current
    , EXCLUDED.runoff_limit_planned
    , EXCLUDED.seal_factor_rw_current
    , EXCLUDED.seal_factor_rw_planned
    , EXCLUDED.seal_factor_ww_current
    , EXCLUDED.seal_factor_ww_planned
    , EXCLUDED.sewer_infiltration_water_production_current
    , EXCLUDED.sewer_infiltration_water_production_planned
    , EXCLUDED.surface_area
    , EXCLUDED.waste_water_production_current
    , EXCLUDED.waste_water_production_planned
    , EXCLUDED.last_modification
    , EXCLUDED.fk_dataowner
    , EXCLUDED.fk_provider
    , EXCLUDED.fk_wastewater_networkelement_rw_current
    , EXCLUDED.fk_wastewater_networkelement_rw_planned
    , EXCLUDED.fk_wastewater_networkelement_ww_planned
    , EXCLUDED.fk_wastewater_networkelement_ww_current
	)
	;
	  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_einzugsgebiet_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_od.catchment_area where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;


---------------------------------
--- Ueberlauf_Foerderaggregat ---
---------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_upsert()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_app.vw_tww_overflow ov
	SET
	  overflow_type  = CASE WHEN NEW.art  = 'Foerderaggregat' THEN 'pump'::tww_app.overflow_type
	    WHEN NEW.art  = 'Leapingwehr' THEN 'leapingweir'::tww_app.overflow_type
	    WHEN NEW.art  = 'Streichwehr' THEN 'prank_weir'::tww_app.overflow_type
	    ELSE 'overflow'::tww_app.overflow_type
	    END
	, fk_wastewater_node = NEW.knotenref
	, fk_overflow_to = NEW.knoten_nachref
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, fk_dataowner = (SELECT obj_id FROM {ext_schema}.vsadss_dataowner downr)
	, remark = NEW.bemerkung_wi
	, identifier = NEW.bezeichnung
	, last_modification = NEW.letzte_aenderung_wi
	, ag64_last_modification = NEW.letzte_aenderung_wi
    , ag64_remark = NEW.bemerkung_wi
	, ag64_fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ag96_last_modification = NEW.letzte_aenderung_gep
    , ag96_remark = NEW.bemerkung_gep
	, ag96_fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE ov.obj_id=NEW.obj_id;
	IF NOT FOUND THEN 
	INSERT INTO tww_app.vw_tww_overflow (
	  obj_id
	, overflow_type  
	, fk_wastewater_node
	, fk_overflow_to
	, fk_provider
	, fk_dataowner
	, remark
	, identifier
	, last_modification
	, ag64_last_modification
    , ag64_remark
	, ag64_fk_provider
	, ag96_last_modification
    , ag96_remark
	, ag96_fk_provider
	)
	VALUES
	(	
	  NEW.obj_id
	, CASE WHEN NEW.art  = 'Foerderaggregat' THEN 'pump'::tww_app.overflow_type
	    WHEN NEW.art  = 'Leapingwehr' THEN 'leapingweir'::tww_app.overflow_type
	    WHEN NEW.art  = 'Streichwehr' THEN 'prank_weir'::tww_app.overflow_type
	    ELSE 'overflow'::tww_app.overflow_type
	    END
	, NEW.knotenref
	, NEW.knoten_nachref
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, (SELECT obj_id FROM {ext_schema}.vsadss_dataowner downr)
	, NEW.bemerkung_wi
	, NEW.bezeichnung
	, NEW.letzte_aenderung_wi
	, NEW.letzte_aenderung_wi
	, NEW.bemerkung_wi
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, NEW.letzte_aenderung_gep
	, NEW.bemerkung_gep
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	);
	END IF;
  RETURN NEW;	

END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_app.vw_tww_overflow where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;


---------------------------------
--- Bautenausserhalbbaugebiet ---
---------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_bautenausserhalbbaugebiet_upsert()
RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO tww_od.building_group
	(
	  obj_id
    , function
    , identifier
    , other_usage_population_equivalent
    , population_equivalent
    , remark
    , renovation_date
    , renovation_necessity
    , restructuring_concept
    , situation_geometry
    , last_modification
    , fk_dataowner
    , fk_provider
    , ag96_owner_address
    , ag96_owner_name
    , ag96_label_number
    , ag96_disposal_wastewater
    , ag96_disposal_industrial_wastewater
    , ag96_disposal_square_water
    , ag96_disposal_roof_water
	)
	(
	SELECT
	  vw_val.obj_id
    , coalesce(bg_fct_ag96.code,bg_fct.code)
    , vw_val.bezeichnung
    , vw_val.einwohnergleichwert
    , vw_val.other_usage_type
    , vw_val.anzstaendigeeinwohner
    , vw_val.bemerkung_gep
    , vw_val.sanierungsdatum
    , rn.code
    , vw_val.sanierungskonzept
    , vw_val.lage
    , vw_val.letzte_aenderung_gep
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.eigentuemeradresse
    , vw_val.eigentuemername
    , vw_val.nummer
    , bg_dt_ww.code
    , bg_dt_iw.code
    , bg_dt_sw.code
    , bg_dt_rw.code
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.building_group_function bg_fct on bg_fct.value_de = vw_val.arealnutzung
	LEFT JOIN {ext_schema}.vl_building_group_function bg_fct_ag96 on bg_fct_ag96.value_agxx = vw_val.arealnutzung
	LEFT JOIN tww_vl.building_group_renovation_necessity bg_rn on bg_rn.value_de = vw_val.sanierungsbedarf
	LEFT JOIN {ext_schema}.vl_building_group_disposal_type bg_dt_ww ON bg_dt_ww.value_de = vw_val.beseitigung_haeusliches_abwasser 
	LEFT JOIN {ext_schema}.vl_building_group_disposal_type bg_dt_iw ON bg_dt_iw.value_de = vw_val.beseitigung_gewerbliches_abwasser 
	LEFT JOIN {ext_schema}.vl_building_group_disposal_type bg_dt_sw ON bg_dt_sw.value_de = vw_val.beseitigung_platzentwaesserung 
	LEFT JOIN {ext_schema}.vl_building_group_disposal_type bg_dt_rw ON bg_dt_rw.value_de = vw_val.beseitigung_dachentwaesserung 
	LEFT JOIN {ext_schema}.vsadss_dataowner downr ON 1=1
	)
	ON CONFLICT(obj_id) DO UPDATE SET
	(
      function
    , identifier
    , other_usage_population_equivalent
    , population_equivalent
    , remark
    , renovation_date
    , renovation_necessity
    , restructuring_concept
    , situation_geometry
    , last_modification
    , fk_dataowner
    , fk_provider
    , ag96_owner_address
    , ag96_owner_name
    , ag96_label_number
    , ag96_disposal_wastewater
    , ag96_disposal_industrial_wastewater
    , ag96_disposal_square_water
    , ag96_disposal_roof_water
	)
	=
	(
      EXCLUDED.function
    , EXCLUDED.identifier
    , EXCLUDED.other_usage_population_equivalent
    , EXCLUDED.population_equivalent
    , EXCLUDED.remark
    , EXCLUDED.renovation_date
    , EXCLUDED.renovation_necessity
    , EXCLUDED.restructuring_concept
    , EXCLUDED.situation_geometry
    , EXCLUDED.last_modification
    , EXCLUDED.fk_dataowner
    , EXCLUDED.fk_provider
    , EXCLUDED.ag96_owner_address
    , EXCLUDED.ag96_owner_name
    , EXCLUDED.ag96_label_number
    , EXCLUDED.ag96_disposal_wastewater
    , EXCLUDED.ag96_disposal_industrial_wastewater
    , EXCLUDED.ag96_disposal_square_water
    , EXCLUDED.ag96_disposal_roof_water
	)
	;
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_bautenausserhalbbaugebiet_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_od.building_group where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;




---------------------------------
------- SBW_Einzugsgebiet -------
---------------------------------	


CREATE OR REPLACE FUNCTION {ext_schema}.ft_sbw_einzugsgebiet_upsert()
RETURNS trigger AS
$BODY$
DECLARE
	hcd_oid varchar(16);
BEGIN
	UPDATE tww_od.hydraulic_char_data
	SET remark=NEW.bemerkung_gep
	WHERE fk_wastewater_node=NEW.sonderbauwerkref
	AND status = 6372 --Ist
	RETURNING obj_id into hcd_oid;
	
	IF NOT FOUND THEN
		INSERT INTO tww_od.hydraulic_char_data
		(
		  obj_id
		, remark
		, fk_wastewater_node
		, status
		)
		VALUES
		(
		  tww_sys.generate_oid('tww_od',hydraulic_char_data)
		, NEW.bemerkung_gep
		, NEW.sonderbauwerkref
		, 6372
		)
		RETURNING obj_id into hcd_oid;
	END IF;

	INSERT INTO tww_od.catchment_area_totals
	(
	  obj_id
    , identifier
    , population
    , population_dim
    , sewer_infiltration_water
    , surface_area
    , surface_dim
    , surface_imp
    , surface_imp_dim
    , surface_red
    , surface_red_dim
    , waste_water_production
    , last_modification
    , fk_dataowner
    , fk_provider
    , fk_discharge_point
    , fk_hydraulic_char_data
    , ag96_sewer_infiltration_water_dim
    , ag96_waste_water_production_dim
	)
	(SELECT
	  vw_val.obj_id
    , vw_val.bezeichnung
    , vw_val.einwohner_ist
    , vw_val.einwohner_geplant
    , vw_val.fremdwasseranfall_ist
    , vw_val.flaeche_ist
    , vw_val.flaeche_geplant
    , vw_val.flaeche_befestigt_ist
    , vw_val.flaeche_befestigt_geplant
    , vw_val.flaeche_reduziert_ist
    , vw_val.flaeche_reduziert_geplant
    , vw_val.schmutzabwasseranfall_ist
    , vw_val.letzte_aenderung_gep
    , vw_val.datenherr
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.einleitstelleref
    , hcd_oid
    , vw_val.fremdwasseranfall_geplant
    , vw_val.schmutzabwasseranfall_geplant
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_od.hydraulic_char_data hcd on hcd.obj_id = cat.fk_hydraulic_char_data
	LEFT JOIN tww_od.wastewater_node wn on hcd.fk_wastewater_node=wn.obj_id
	)
	ON CONFLICT(obj_id) DO UPDATE SET
	(
	  identifier
    , population
    , population_dim
    , sewer_infiltration_water
    , surface_area
    , surface_dim
    , surface_imp
    , surface_imp_dim
    , surface_red
    , surface_red_dim
    , waste_water_production
    , last_modification
    , fk_dataowner
    , fk_provider
    , fk_discharge_point
    , fk_hydraulic_char_data
    , ag96_sewer_infiltration_water_dim
    , ag96_waste_water_production_dim
	)
	=
	(
	  EXCLUDED.identifier
    , EXCLUDED.population
    , EXCLUDED.population_dim
    , EXCLUDED.sewer_infiltration_water
    , EXCLUDED.surface_area
    , EXCLUDED.surface_dim
    , EXCLUDED.surface_imp
    , EXCLUDED.surface_imp_dim
    , EXCLUDED.surface_red
    , EXCLUDED.surface_red_dim
    , EXCLUDED.waste_water_production
    , EXCLUDED.last_modification
    , EXCLUDED.fk_dataowner
    , EXCLUDED.fk_provider
    , EXCLUDED.fk_discharge_point
    , EXCLUDED.fk_hydraulic_char_data
    , EXCLUDED.ag96_sewer_infiltration_water_dim
    , EXCLUDED.ag96_waste_water_production_dim
	)
	;
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_sbw_einzugsgebiet_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_od.catchment_area_totals where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;



---------------------------------
---- Versickerungsbereichag -----
---------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_versickerungsbereichag_upsert()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_app.vw_infiltration_zone iz
	SET
	  identifier = vw_val.bezeichnung
	, ag96_permeability = vw_val.bezeichnung
	, ag96_limitation = vw_val.einschraenkung
	, ag96_thickness = vw_val.maechtigkeit
	, perimeter_geometry = vw_val.perimeter
	, ag96_q_check = vw_val.q_check
	, infiltration_possibility = ia_ip.code 
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
	, remark = vw_val.bemerkung_gep
	, last_modification = vw_val.letzte_aenderung_gep
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.infiltration_area_infiltration_possibility ia_ip on ia_ip.value_de = vw_val.versickerungsmoeglichkeitag
	WHERE iz.obj_id=vw_val.obj_id;
	IF NOT FOUND THEN
	INSERT INTO tww_app.vw_infiltration_zone
	(
	  obj_id
	, identifier
	, ag96_permeability
	, ag96_limitation
	, ag96_thickness
	, perimeter_geometry
	, ag96_q_check
	, infiltration_possibility
	, fk_provider
	, remark
	, last_modification
	)
	(
	SELECT
	  vw_val.obj_id
	, vw_val.bezeichnung
	, vw_val.durchlaessigkeit
	, vw_val.einschraenkung
	, vw_val.maechtigkeit
	, vw_val.perimeter
	, vw_val.q_check
	, ia_ip.code 
	, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
	, vw_val.bemerkung_gep
	, vw_val.letzte_aenderung_gep
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.infiltration_area_infiltration_possibility ia_ip on ia_ip.value_de = vw_val.versickerungsmoeglichkeitag
	);
	END IF;
  RETURN NEW;	
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_versickerungsbereichag_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM {ext_schema}.infiltration_area where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;

	

---------------------------------
-------- Metainformation --------
---------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.update_last_ag_modification()
RETURNS trigger AS
$BODY$
  DECLARE
	update_type varchar(3);
  BEGIN
    BEGIN
	  SELECT 
	   ag_update_type
	  INTO STRICT update_type 
	  FROM {ext_schema}.update_manager
	  WHERE username=current_user;
	  CASE 
	   WHEN update_type ='wi' THEN NEW.ag64_last_modification=now();
	   WHEN update_type ='gep' THEN NEW.ag96_last_modification=now();
	   ELSE NULL;
	  END CASE;
	  EXCEPTION
        WHEN NO_DATA_FOUND THEN
		  RAISE WARNING 'Nutzer % existiert in Tabelle "{ext_schema}.update_manager" nicht. Letzte_Aenderung_WI resp. _GEP wurde nicht aktualisiert.', current_user;
	    WHEN TOO_MANY_ROWS THEN
          RAISE WARNING 'Nutzer % in {ext_schema}.update_manager nicht eindeutig', current_user;
	END;
	RETURN NEW;
  END;
$BODY$
LANGUAGE plpgsql;