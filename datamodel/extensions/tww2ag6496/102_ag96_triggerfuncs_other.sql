---------- GEPHaltung ----------
--------------------------------

CREATE OR REPLACE FUNCTION {ext_schema}.ft_gephaltung_insert()
RETURNS trigger AS
$BODY$
DECLARE
	pp_oid varchar(16);
	ws_oid varchar(16);
	rp_from_oid varchar(16);
	rp_to_oid varchar(16);
BEGIN

	WITH ppt AS (
		SELECT code, abbr_de from tww_vl.pipe_profile_profile_type ppt WHERE ppt.value_de =  NEW.profiltyp 
	) 
	SELECT obj_id into pp_oid from tww_od.pipe_profile pp 
	WHERE pp.profile_type=ppt.code AND pp.identifier = 
		CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_hoehe_ist=NEW.lichte_breite_ist
		THEN NEW.profiltyp
		ELSE
			array_to_string(
			  array[ppt.abbr_de,NEW.lichte_hoehe_ist::varchar,NEW.lichte_breite_ist::varchar]
			  ,'_' -- delimiter
			)
		END;
	
	CASE 
		WHEN pp_oid is null
		THEN
			WITH ppt AS (
				SELECT code, abbr_de from tww_vl.pipe_profile_profile_type ppt WHERE ppt.value_de =  NEW.profiltyp 
			) 
			INSERT INTO tww_od.pipe_profile
			(
			  profile_type
			, identifier
			, height_width_ratio
			, fk_provider
			) VALUES
			(
			  ppt.code
			, CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_hoehe_ist=NEW.lichte_breite_ist
				THEN NEW.profiltyp
				ELSE
			    array_to_string(
			      array[ppt.abbr_de,NEW.lichte_hoehe_ist::varchar,NEW.lichte_breite_ist::varchar]
				  ,'_' -- delimiter
				)
			  END
			, (CASE WHEN NEW.lichte_breite_ist= 0 OR vw_val.lichte_breite_ist IS NULL THEN 1
			  ELSE NEW.lichte_hoehe_ist::numeric/NEW.lichte_breite_ist END)::numeric(5,2)
			, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
			)
			RETURNING obj_id INTO pp_oid;
		ELSE
			NULL;
	END CASE;
	
	
	-- Reach 
    INSERT INTO tww_od.wastewater_networkelement( 
	  obj_id
	, identifier
	, fk_provider
	, ag64_last_modification
    , ag64_remark
	, ag64_fk_provider
	, ag96_last_modification
    , ag96_remark
	, ag96_fk_provider	
	) VALUES
	(SELECT
	  NEW.obj_id
	, NEW.bezeichnung
    , {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.letzte_aenderung_wi
    , NEW.bemerkung_wi
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.letzte_aenderung_gep
    , NEW.bemerkung_gep
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	);
	

	
	INSERT INTO tww_od.wastewater_structure
	(
	  fk_wastewater_networkelement
    , status
	, fk_owner
	, status_survey_year
    , financing
    , fk_operator
	, identifier
    , last_modification
    , renovation_necessity
    , replacement_value
    , structure_condition
    , year_of_construction
	, ag96_fk_measure
	)VALUES
	(
	  NEW.obj_id
    , (SELECT code FROM tww_vl.wastewater_structure_status WHERE value_de=NEW.bauwerkstatus)
	, {ext_schema}.convert_organisationid_to_vsa(NEW.eigentuemer)
	, NEW.jahr_zustandserhebung
    , (SELECT code FROM tww_vl.wastewater_structure_financing WHERE value_de=NEW.finanzierung)
    , {ext_schema}.convert_organisationid_to_vsa(NEW.betreiber)
	, NEW.bezeichnung
    , NEW.letzte_aenderung_wi
    , (SELECT code FROM tww_vl.wastewater_structure_renovation_necessity WHERE value_de=NEW.sanierungsbedarf)
    , NEW.wiederbeschaffungswert
    , (SELECT code FROM tww_vl.wastewater_structure_structure_condition WHERE value_de=NEW.baulicherzustand)
    , NEW.baujahr
	, NEW.gepmassnahmeref
	)
	RETURNING obj_id into ws_oid;
	
	INSERT INTO tww_od.channel
	(
	  obj_id
    , ch_usage_current
    , ch_function_hierarchic
	, ch_function_hydraulic
	, ch_usage_planned
	)VALUES
	(
	  ws_oid
    , (SELECT code FROM tww_vl.channel_usage_current_import_rel_agxx WHERE value_de=NEW.nutzungsartag_ist)
    , (SELECT code FROM tww_vl.channel_function_hierarchic WHERE value_de=NEW.funktionhierarchisch)
    , (SELECT code FROM tww_vl.channel_function_hydraulic WHERE value_de=NEW.funktionhydraulisch)
    , (SELECT code FROM tww_vl.channel_usage_planned_import_rel_agxx WHERE value_de=NEW.nutzungsartag_geplant)
	);
	
	INSERT INTO tww_od.reach_point
	(
      elevation_accuracy
	, situation3d_geometry
    , fk_provider
    , fk_wastewater_networkelement
    , last_modification
    , level
	)VALUES
	(
      (SELECT code FROM tww_vl.reach_point_elevation_accuracy WHERE value_de=NEW.hoehengenauigkeit_von)
	, ST_SetSRID(ST_MakePoint(ST_X(ST_StartPoint(NEW.verlauf)), ST_X(ST_StartPoint(NEW.verlauf))), COALESCE(NEW.kote_beginn,'nan')), 2056 )
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.startknoten
	, NEW.letzte_aenderung_wi
    , NEW.kote_beginn
	)RETURNING obj_id into rp_from_oid;

	INSERT INTO tww_od.reach_point
	(
      elevation_accuracy
	, situation3d_geometry
    , fk_provider
    , fk_wastewater_networkelement
    , last_modification
    , level
	)VALUES
	(
      (SELECT code FROM tww_vl.reach_point_elevation_accuracy WHERE value_de=NEW.hoehengenauigkeit_nach)
	, ST_SetSRID(ST_MakePoint(ST_X(ST_EndPoint(NEW.verlauf)), ST_X(ST_EndPoint(NEW.verlauf))), COALESCE(NEW.kote_ende,'nan')), 2056 )
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.endknoten
	, NEW.letzte_aenderung_wi
    , NEW.kote_ende
	)RETURNING obj_id into rp_to_oid;
	
	
	INSERT INTO tww_od.reach re
	(
	  obj_id
    , clear_height
	, ag96_clear_height_planned
	, ag96_clear_width_planned
    , material
    , fk_pipe_profile
	, hydraulic_load_current
    , length_effective
    , progression3d_geometry
    , reliner_material
    , reliner_nominal_size
    , relining_construction
    , relining_kind
	, fk_reach_point_from
	, fk_reach_point_to
	)VALUES
	(
	  NEW.obj_id
    , NEW.lichte_hoehe_ist
	, NEW.lichte_hoehe_geplant
	, NEW.lichte_breite_geplant
    , (SELECT code FROM tww_vl.reach_material WHERE value_de=NEW.material)
    , pp_oid
	, NEW.hydraulischebelastung
    , NEW.laengeeffektiv
    , ST_Force3D(NEW.verlauf)
    , (SELECT code FROM tww_vl.reach_reliner_material WHERE value_de=NEW.reliner_material)
    , NEW.reliner_nennweite
    , (SELECT code FROM tww_vl.reach_relining_construction WHERE value_de=NEW.reliner_bautechnik)
    , (SELECT code FROM tww_vl.reach_relining_kind WHERE value_de=NEW.reliner_art)
	, rp_from_oid
	, rp_to_oid
	)
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_gephaltung_update()
RETURNS trigger AS
$BODY$
DECLARE
	pipe_profile_record record;
	new_pipe_profile varchar(16);
	ws_oid_for_measure varchar(16);
BEGIN

	WITH ppt AS (
		SELECT code, abbr_de from tww_vl.pipe_profile_profile_type ppt WHERE ppt.value_de =  NEW.profiltyp 
	) 
	SELECT obj_id into pp_oid from tww_od.pipe_profile pp 
	WHERE pp.profile_type=ppt.code AND pp.identifier = 
		CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_hoehe_ist=NEW.lichte_breite_ist
		THEN NEW.profiltyp
		ELSE
			array_to_string(
			  array[ppt.abbr_de,NEW.lichte_hoehe_ist::varchar,NEW.lichte_breite_ist::varchar]
			  ,'_' -- delimiter
			)
		END;
	
	CASE 
		WHEN pp_oid is null
		THEN
			WITH ppt AS (
				SELECT code, abbr_de from tww_vl.pipe_profile_profile_type ppt WHERE ppt.value_de =  NEW.profiltyp 
			) 
			INSERT INTO tww_od.pipe_profile
			(
			  profile_type
			, identifier
			, height_width_ratio
			, fk_provider
			) VALUES
			(
			  ppt.code
			, CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_hoehe_ist=NEW.lichte_breite_ist
				THEN NEW.profiltyp
				ELSE
			    array_to_string(
			      array[ppt.abbr_de,NEW.lichte_hoehe_ist::varchar,NEW.lichte_breite_ist::varchar]
				  ,'_' -- delimiter
				)
			  END
			, (CASE WHEN NEW.lichte_breite_ist= 0 OR vw_val.lichte_breite_ist IS NULL THEN 1
			  ELSE NEW.lichte_hoehe_ist::numeric/NEW.lichte_breite_ist END)::numeric(5,2)
			, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
			)
			RETURNING obj_id INTO pp_oid;
		ELSE
			NULL;
	END CASE;
	
	UPDATE tww_od.wastewater_networkelement SET
	  identifier = NEW.bezeichnung
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ag64_last_modification = NEW.letzte_aenderung_wi
    , ag64_remark = NEW.bemerkung_wi
	, ag64_fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ag96_last_modification = NEW.letzte_aenderung_gep
    , ag96_remark = NEW.bemerkung_gep
	, ag96_fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE obj_id = NEW.obj_id;
	
	UPDATE tww_od.wastewater_structure SET 
      status = (SELECT code FROM tww_vl.wastewater_structure_status WHERE value_de=NEW.bauwerkstatus)
	, fk_owner = {ext_schema}.convert_organisationid_to_vsa(NEW.eigentuemer)
	, status_survey_year = NEW.jahr_zustandserhebung
    , financing = (SELECT code FROM tww_vl.wastewater_structure_financing WHERE value_de=NEW.finanzierung)
    , fk_operator = {ext_schema}.convert_organisationid_to_vsa(NEW.betreiber)
	, identifier = NEW.bezeichnung
    , last_modification = NEW.letzte_aenderung_wi
    , renovation_necessity = (SELECT code FROM tww_vl.wastewater_structure_renovation_necessity WHERE value_de=NEW.sanierungsbedarf)
    , replacement_value = NEW.wiederbeschaffungswert
    , structure_condition = (SELECT code FROM tww_vl.wastewater_structure_structure_condition WHERE value_de=NEW.baulicherzustand)
    , year_of_construction = NEW.baujahr
	, ag96_fk_measure = NEW.gepmassnahmeref
	WHERE fk_wastewater_networkelement = NEW.obj_id
	RETURNING obj_id into ws_oid;
	
	UPDATE tww_od.channel SET 
    , ch_usage_current = (SELECT code FROM tww_vl.channel_usage_current_import_rel_agxx WHERE value_de=NEW.nutzungsartag_ist)
    , ch_function_hierarchic = (SELECT code FROM tww_vl.channel_function_hierarchic WHERE value_de=NEW.funktionhierarchisch)
	, ch_function_hydraulic = (SELECT code FROM tww_vl.channel_function_hydraulic WHERE value_de=NEW.funktionhydraulisch)
	, ch_usage_planned = (SELECT code FROM tww_vl.channel_usage_planned_import_rel_agxx WHERE value_de=NEW.nutzungsartag_geplant)
	WHERE obj_id = ws_oid;
	
	SELECT fk_reach_point_from,fk_reach_point_to INTO rp_from_oid,rp_to_oid 
	FROM tww_od.reach
	WHERE obj_id = OLD.obj_id
	
	
	UPDATE tww_od.reach_point SET 
      elevation_accuracy = (SELECT code FROM tww_vl.reach_point_elevation_accuracy WHERE value_de=NEW.hoehengenauigkeit_von)
	, situation3d_geometry = ST_SetSRID(ST_MakePoint(ST_X(ST_StartPoint(NEW.verlauf)), ST_X(ST_StartPoint(NEW.verlauf))), COALESCE(NEW.kote_beginn,'nan')), 2056 )
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , fk_wastewater_networkelement = NEW.startknoten
    , last_modification = NEW.letzte_aenderung_wi
    , level = NEW.kote_beginn
	WHERE obj_id = rp_from_oid;

	UPDATE tww_od.reach_point SET 
      elevation_accuracy = (SELECT code FROM tww_vl.reach_point_elevation_accuracy WHERE value_de=NEW.hoehengenauigkeit_von)
	, situation3d_geometry = ST_SetSRID(ST_MakePoint(ST_X(ST_EndPoint(NEW.verlauf)), ST_X(ST_EndPoint(NEW.verlauf))), COALESCE(NEW.kote_ende,'nan')), 2056 )
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , fk_wastewater_networkelement = NEW.endknoten
    , last_modification = NEW.letzte_aenderung_wi
    , level = NEW.kote_ende
	WHERE obj_id = rp_to_oid;
	
	UPDATE tww_od.reach re SET
	  clear_height = NEW.lichte_hoehe_ist
	, ag96_clear_height_planned = NEW.lichte_hoehe_geplant
	, ag96_clear_width_planned = NEW.lichte_breite_geplant
    , material = (SELECT code FROM tww_vl.reach_material WHERE value_de=NEW.material)
    , fk_pipe_profile = pp_oid
	, hydraulic_load_current = NEW.hydraulischebelastung
    , length_effective = NEW.laengeeffektiv
    , progression3d_geometry = ST_Force3D(NEW.verlauf)
    , reliner_material = (SELECT code FROM tww_vl.reach_reliner_material WHERE value_de=NEW.reliner_material)
    , reliner_nominal_size = NEW.reliner_nennweite
    , relining_construction = (SELECT code FROM tww_vl.reach_relining_construction WHERE value_de=NEW.reliner_bautechnik)
    , relining_kind = (SELECT code FROM tww_vl.reach_relining_kind WHERE value_de=NEW.reliner_art)
	
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
    , remark = vw_val.bemerkung_gep
    , status = msr_st.code
    , symbolpos_geometry = vw_val.symbolpos
    , total_cost = vw_val.gesamtkosten
    , year_implementation_effective = vw_val.jahr_umsetzung_effektiv
    , year_implementation_planned = vw_val.jahr_umsetzung_planned
    , last_modification = vw_val.letzte_aenderung_gep
--    , fk_dataowner = downr.value_obj_id
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , fk_responsible_entity = {ext_schema}.convert_organisationid_to_vsa(vw_val.traegerschaft)
    , fk_responsible_start = {ext_schema}.convert_organisationid_to_vsa(vw_val.verantwortlich_ausloesung)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.measure_category_import_rel_agxx msr_cat on msr_cat.value_de=vw_val.kategorie
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
    , vw_val.bemerkung_gep
    , msr_st.code
    , vw_val.symbolpos
    , vw_val.gesamtkosten
    , vw_val.jahr_umsetzung_effektiv
    , vw_val.jahr_umsetzung_planned
    , vw_val.letzte_aenderung_gep
    , downr.value_obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.traegerschaft)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.verantwortlich_ausloesung)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.measure_category_import_rel_agxx msr_cat on msr_cat.value_de=vw_val.kategorie
	LEFT JOIN tww_vl.measure_priority msr_pri on msr_pri.value_de = vw_val.prioritaetag
	LEFT JOIN tww_vl.measure_status msr_st on msr_st.value_de = vw_val.status
	LEFT JOIN tww_od.default_values downr on fieldname = 'fk_dataowner'
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
	UPDATE tww_od.catchment_area ca SET
      direct_discharge_current = ddc.code
    , direct_discharge_planned = ddp.code
    , discharge_coefficient_rw_current = vw_val.abflussbeiwert_rw_ist
    , discharge_coefficient_rw_planned = vw_val.abflussbeiwert_rw_geplant
    , discharge_coefficient_ww_current = vw_val.abflussbeiwert_sw_ist
    , discharge_coefficient_ww_planned = vw_val.abflussbeiwert_sw_geplant
    , drainage_system_current = dsc.code
    , drainage_system_planned = dsp.code
    , identifier = vw_val.bezeichnung
    , infiltration_current = ic.code
    , infiltration_planned = ip.code
    , perimeter_geometry = vw_val.perimeter
    , population_density_current = vw_val.einwohnerdichte_ist
    , population_density_planned = vw_val.einwohnerdichte_geplant
    , remark = vw_val.bemerkung_gep
    , retention_current = rc.code
    , retention_planned = rp.code
    , runoff_limit_current = vw_val.abflussbegrenzung_ist
    , runoff_limit_planned = vw_val.abflussbegrenzung_geplant
    , seal_factor_rw_current = vw_val.befestigungsgrad_rw_ist
    , seal_factor_rw_planned = vw_val.befestigungsgrad_rw_geplant
    , seal_factor_ww_current = vw_val.befestigungsgrad_sw_ist
    , seal_factor_ww_planned = vw_val.befestigungsgrad_sw_geplant
    , sewer_infiltration_water_production_current = vw_val.fremdwasseranfall_ist
    , sewer_infiltration_water_production_planned = vw_val.fremdwasseranfall_geplant
    , surface_area = vw_val.flaeche
    , waste_water_production_current = vw_val.schmutzabwasseranfall_ist
    , waste_water_production_planned = vw_val.schmutzabwasseranfall_geplant
    , last_modification = vw_val.letzte_aenderung_gep
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , fk_wastewater_networkelement_rw_current = vw_val.gepknoten_rw_istref
    , fk_wastewater_networkelement_rw_planned = vw_val.gepknoten_rw_geplantref
    , fk_wastewater_networkelement_ww_planned = vw_val.gepknoten_sw_geplantref
    , fk_wastewater_networkelement_ww_current = vw_val.gepknoten_sw_istref
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.catchment_area_direct_discharge_current ddc on ddc.value_de = vw_val.direkteinleitung_in_gewaesser_ist
	LEFT JOIN tww_vl.catchment_area_direct_discharge_planned ddp on ddp.value_de = vw_val.direkteinleitung_in_gewaesser_geplant
	LEFT JOIN tww_vl.catchment_area_drainage_system_current_import_rel_agxx dsc on dsc.value_de = vw_val.entwaesserungssystemag_ist
	LEFT JOIN tww_vl.catchment_area_drainage_system_planned_import_rel_agxx dsp on dsp.value_de = vw_val.entwaesserungssystemag_geplant
	LEFT JOIN tww_vl.catchment_area_infiltration_current ic on ic.value_de = vw_val.versickerung_ist
	LEFT JOIN tww_vl.catchment_area_infiltration_planned ip on ip.value_de = vw_val.versickerung_geplant
	LEFT JOIN tww_vl.catchment_area_retention_current rc on rc.value_de = vw_val.retention_ist
	LEFT JOIN tww_vl.catchment_area_retention_planned rp on rp.value_de = vw_val.retention_geplant
	WHERE ca.obj_id = vw_val.obj_id;
	IF NOT FOUND THEN
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
    , vw_val.schmutzabwasseranfall_ist
    , vw_val.schmutzabwasseranfall_geplant
    , vw_val.letzte_aenderung_gep
    , downr.value_obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.gepknoten_rw_istref
    , vw_val.gepknoten_rw_geplantref
    , vw_val.gepknoten_sw_geplantref
    , vw_val.gepknoten_sw_istref
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.catchment_area_direct_discharge_current ddc on ddc.value_de = vw_val.direkteinleitung_in_gewaesser_ist
	LEFT JOIN tww_vl.catchment_area_direct_discharge_planned ddp on ddp.value_de = vw_val.direkteinleitung_in_gewaesser_geplant
	LEFT JOIN tww_vl.catchment_area_drainage_system_current_import_rel_agxx dsc on dsc.value_de = vw_val.entwaesserungssystemag_ist
	LEFT JOIN tww_vl.catchment_area_drainage_system_planned_import_rel_agxx dsp on dsp.value_de = vw_val.entwaesserungssystemag_geplant
	LEFT JOIN tww_vl.catchment_area_infiltration_current ic on ic.value_de = vw_val.versickerung_ist
	LEFT JOIN tww_vl.catchment_area_infiltration_planned ip on ip.value_de = vw_val.versickerung_geplant
	LEFT JOIN tww_vl.catchment_area_retention_current rc on rc.value_de = vw_val.retention_ist
	LEFT JOIN tww_vl.catchment_area_retention_planned rp on rp.value_de = vw_val.retention_geplant
	LEFT JOIN tww_od.default_values downr on fieldname = 'fk_dataowner'
	);
	END IF;
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

CREATE OR REPLACE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_insert()
RETURNS trigger AS
$BODY$
BEGIN

	INSERT INTO tww_od.overflow (
	  obj_id
	, fk_wastewater_node
	, fk_overflow_to
	, fk_provider
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
	, NEW.knotenref
	, NEW.knoten_nachref
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
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
	
	CASE WHEN NEW.art  = 'Foerderaggregat' THEN 
		INSERT INTO tww_od.pump (obj_id) VALUES (NEW.obj_id);
	WHEN NEW.art  = 'Leapingwehr' THEN 
		INSERT INTO tww_od.leapingweir (obj_id) VALUES (NEW.obj_id);
	WHEN NEW.art  = 'Streichwehr' THEN
		INSERT INTO tww_od.prank_weir (obj_id) VALUES (NEW.obj_id);
	ELSE NULL;
	CASE;
	
  RETURN NEW;	

END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_update()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_od.overflow
	SET
	 fk_wastewater_node = NEW.knotenref
	, fk_overflow_to = NEW.knoten_nachref
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, remark = NEW.bemerkung_wi
	, identifier = NEW.bezeichnung
	, last_modification = NEW.letzte_aenderung_wi
	, ag64_last_modification = NEW.letzte_aenderung_wi
    , ag64_remark = NEW.bemerkung_wi
	, ag64_fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ag96_last_modification = NEW.letzte_aenderung_gep
    , ag96_remark = NEW.bemerkung_gep
	, ag96_fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE obj_id=NEW.obj_id;
	
	CASE WHEN NEW.art  = 'Foerderaggregat' AND OLD.ov_type != 'pump' THEN
		INSERT INTO tww_od.pump (obj_id) VALUES (NEW.obj_id);
		DELETE FROM tww_od.leapingweir WHERE obj_id = OLD.obj_id;
		DELETE FROM tww_od.prank_weir WHERE obj_id = OLD.obj_id;
	WHEN NEW.art  = 'Leapingwehr'  AND OLD.ov_type != 'leapingweir' THEN
		INSERT INTO tww_od.leapingweir (obj_id) VALUES (NEW.obj_id);
		DELETE FROM tww_od.pump WHERE obj_id = OLD.obj_id;
		DELETE FROM tww_od.prank_weir WHERE obj_id = OLD.obj_id;
	WHEN NEW.art  = 'Streichwehr' AND OLD.ov_type != 'prank_weir' THEN
		INSERT INTO tww_od.prank_weir (obj_id) VALUES (NEW.obj_id);
		DELETE FROM tww_od.leapingweir WHERE obj_id = OLD.obj_id;
		DELETE FROM tww_od.pump WHERE obj_id = OLD.obj_id;
	ELSE NULL;
	END CASE;
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
	UPDATE tww_od.building_group bg
	SET 
	  function = bg_fct.code
    , identifier = vw_val.bezeichnung
    , population_equivalent = vw_val.einwohnergleichwert
	, ag96_population = vw_val.anzstaendigeeinwohner
    , remark = vw_val.bemerkung_gep
    , renovation_date = vw_val.sanierungsdatum
    , renovation_necessity = bg_rn.code
    , restructuring_concept = vw_val.sanierungskonzept
    , situation_geometry = vw_val.lage
    , last_modification = vw_val.letzte_aenderung_gep
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , ag96_owner_address = vw_val.eigentuemeradresse 
    , ag96_owner_name = vw_val.eigentuemername
    , ag96_label_number = vw_val.nummer
    , ag96_disposal_wastewater = bg_dt_ww.code
    , ag96_disposal_industrial_wastewater = bg_dt_iw.code
    , ag96_disposal_square_water = bg_dt_sw.code
    , ag96_disposal_roof_water = bg_dt_rw.code
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.building_group_function_import_rel_agxx bg_fct on bg_fct.value_de = vw_val.arealnutzung
	LEFT JOIN tww_vl.building_group_renovation_necessity bg_rn on bg_rn.value_de = lower(vw_val.sanierungsbedarf)
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_ww ON bg_dt_ww.value_de = vw_val.beseitigung_haeusliches_abwasser 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_iw ON bg_dt_iw.value_de = vw_val.beseitigung_gewerbliches_abwasser 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_sw ON bg_dt_sw.value_de = vw_val.beseitigung_platzentwaesserung 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_rw ON bg_dt_rw.value_de = vw_val.beseitigung_dachentwaesserung 
	LEFT JOIN tww_od.default_values downr on fieldname = 'fk_dataowner'
	WHERE bg.obj_id=vw_val.obj_id;
	IF NOT FOUND THEN
	INSERT INTO tww_od.building_group
	(
	  obj_id
    , function
    , identifier
    , population_equivalent
	, ag96_population
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
    , bg_fct.code
    , vw_val.bezeichnung
    , vw_val.einwohnergleichwert
    , vw_val.anzstaendigeeinwohner
    , vw_val.bemerkung_gep
    , vw_val.sanierungsdatum
    , bg_rn.code
    , vw_val.sanierungskonzept
    , vw_val.lage
    , vw_val.letzte_aenderung_gep
    , downr.value_obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.eigentuemeradresse
    , vw_val.eigentuemername
    , vw_val.nummer
    , bg_dt_ww.code
    , bg_dt_iw.code
    , bg_dt_sw.code
    , bg_dt_rw.code
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_vl.building_group_function_import_rel_agxx bg_fct on bg_fct.value_de = vw_val.arealnutzung
	LEFT JOIN tww_vl.building_group_renovation_necessity bg_rn on bg_rn.value_de = lower(vw_val.sanierungsbedarf)
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_ww ON bg_dt_ww.value_de = vw_val.beseitigung_haeusliches_abwasser 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_iw ON bg_dt_iw.value_de = vw_val.beseitigung_gewerbliches_abwasser 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_sw ON bg_dt_sw.value_de = vw_val.beseitigung_platzentwaesserung 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_rw ON bg_dt_rw.value_de = vw_val.beseitigung_dachentwaesserung 
	LEFT JOIN tww_od.default_values downr on fieldname = 'fk_dataowner'
	);
	END IF;
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
	WHERE fk_wastewater_node=NEW.sonderbauwerk_ref
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
		  tww_sys.generate_oid('tww_od','hydraulic_char_data')
		, NEW.bemerkung_gep
		, NEW.sonderbauwerk_ref
		, 6372
		)
		RETURNING obj_id into hcd_oid;
	END IF;
	UPDATE tww_od.catchment_area_totals cat
	SET 
	  identifier = vw_val.bezeichnung
    , population = vw_val.einwohner_ist
    , population_dim = vw_val.einwohner_geplant
    , sewer_infiltration_water = vw_val.fremdwasseranfall_ist
    , surface_area = vw_val.flaeche_ist
    , surface_dim = vw_val.flaeche_geplant
    , surface_imp = vw_val.flaeche_befestigt_ist
    , surface_imp_dim = vw_val.flaeche_befestigt_geplant
    , surface_red = vw_val.flaeche_reduziert_ist
    , surface_red_dim = vw_val.flaeche_reduziert_geplant
    , waste_water_production = vw_val.schmutzabwasseranfall_ist
    , last_modification = vw_val.letzte_aenderung_gep
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , fk_discharge_point = vw_val.einleitstelleref
    , fk_hydraulic_char_data = hcd_oid
    , ag96_sewer_infiltration_water_dim = vw_val.fremdwasseranfall_geplant
    , ag96_waste_water_production_dim = vw_val.schmutzabwasseranfall_geplant
	, ag96_perimeter_geometry = vw_val.perimeter_ist
	FROM (SELECT NEW.*) as vw_val
	WHERE cat.obj_id = vw_val.obj_id;
	IF NOT FOUND THEN
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
	, ag96_perimeter_geometry
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
    , downr.value_obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.einleitstelleref
    , hcd_oid
    , vw_val.fremdwasseranfall_geplant
    , vw_val.schmutzabwasseranfall_geplant
	, vw_val.perimeter_ist
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_od.default_values downr on fieldname = 'fk_dataowner'
	);
	END IF;
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

CREATE OR REPLACE FUNCTION {ext_schema}.ft_versickerungsbereichag_insert()
RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO tww_od.zone
	(
	  obj_id
	, identifier
	, fk_provider
	, remark
	, last_modification
	)
	(
	SELECT
	  NEW.obj_id
	, NEW.bezeichnung
	, {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	, NEW.bemerkung_gep
	, NEW.letzte_aenderung_gep
	);
	INSERT INTO tww_od.infiltration_zone
	(
	  obj_id
	, ag96_permeability
	, ag96_limitation
	, ag96_thickness
	, perimeter_geometry
	, ag96_q_check
	, infiltration_capacity
	)
	(
	SELECT
	  NEW.obj_id
	, NEW.durchlaessigkeit
	, NEW.einschraenkung
	, NEW.maechtigkeit
	, NEW.perimeter
	, NEW.q_check
	, (SELECT code FROM tww_vl.infiltration_zone_infiltration_capacity WHERE value_de = NEW.versickerungsmoeglichkeitag) 
	);
  RETURN NEW;	
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_versickerungsbereichag_update()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_od.zone
	SET
	  identifier = NEW.bezeichnung
	, fk_provider = {ext_schema}.convert_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	, remark = NEW.bemerkung_gep
	, last_modification = NEW.letzte_aenderung_gep
	WHERE obj_id=NEW.obj_id;
	
	UPDATE tww_od.infiltration_zone
	SET
	   ag96_permeability = NEW.bezeichnung
	, ag96_limitation = NEW.einschraenkung
	, ag96_thickness = NEW.maechtigkeit
	, perimeter_geometry = NEW.perimeter
	, ag96_q_check = NEW.q_check
	, infiltration_capacity = (SELECT code FROM tww_vl.infiltration_zone_infiltration_capacity WHERE value_de = NEW.versickerungsmoeglichkeitag) 
	WHERE obj_id=vw_val.obj_id;
  RETURN NEW;	
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION {ext_schema}.ft_versickerungsbereichag_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_od.infiltration_zone where obj_id=old.obj_id;
	DELETE FROM tww_od.zone where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;
