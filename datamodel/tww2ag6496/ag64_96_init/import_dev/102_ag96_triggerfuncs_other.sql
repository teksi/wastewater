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
			, CASE WHEN vw_val.lichte_breite_ist= 0 OR vw_val.lichte_hoehe_ist=vw_val.lichte_breite_ist
				THEN ppt.value_de
				ELSE
			    array_to_string(
			      array[ppt.abbr_de,vw_val.lichte_hoehe_ist::varchar,vw_val.lichte_breite_ist::varchar]
				  ,'_' -- delimiter
				)
			  END
			, (CASE WHEN vw_val.lichte_breite_ist= 0 THEN 1
			  ELSE vw_val.lichte_hoehe_ist::numeric/vw_val.lichte_breite_ist END)::numeric(5,2)
			, downr.obj_id
			, {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
			FROM (SELECT NEW.*) vw_val
			LEFT JOIN tww_vl.pipe_profile_profile_type ppt ON ppt.value_de =  vw_val.profiltyp 
			LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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
    , fk_dataowner = downr.obj_id
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
    , rp_from_fk_dataowner = downr.obj_id
    , rp_from_fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , rp_from_fk_wastewater_networkelement = vw_val.startknoten
    , rp_from_last_modification = vw_val.letzte_aenderung_wi
    , rp_from_level = vw_val.kote_beginn
    , rp_to_elevation_accuracy = rp_ea_to.code
    , rp_to_fk_dataowner = downr.obj_id
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
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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
    , downr.obj_id
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
    , downr.obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_wi)
    , vw_val.startknoten
    , vw_val.letzte_aenderung_wi
    , vw_val.kote_beginn
    , rp_ea_to.code
    , downr.obj_id
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
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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
    , remark = vw_val.bemerkung_gep
    , status = msr_st.code
    , symbolpos_geometry = vw_val.symbolpos
    , total_cost = vw_val.gesamtkosten
    , year_implementation_effective = vw_val.jahr_umsetzung_effektiv
    , year_implementation_planned = vw_val.jahr_umsetzung_planned
    , last_modification = vw_val.letzte_aenderung_gep
    , fk_dataowner = downr.obj_id
    , fk_provider = {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , fk_responsible_entity = {ext_schema}.convert_organisationid_to_vsa(vw_val.traegerschaft)
    , fk_responsible_start = {ext_schema}.convert_organisationid_to_vsa(vw_val.verantwortlich_ausloesung)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.measure_category msr_cat on msr_cat.value_de=vw_val.kategorie
	LEFT JOIN tww_vl.measure_priority msr_pri on msr_pri.value_de = vw_val.prioritaetag
	LEFT JOIN tww_vl.measure_status msr_st on msr_st.value_de = vw_val.status
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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
    , downr.obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.traegerschaft)
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.verantwortlich_ausloesung)
	FROM (SELECT NEW.*) vw_val
	LEFT JOIN tww_vl.measure_category msr_cat on msr_cat.value_de=vw_val.kategorie
	LEFT JOIN tww_vl.measure_priority msr_pri on msr_pri.value_de = vw_val.prioritaetag
	LEFT JOIN tww_vl.measure_status msr_st on msr_st.value_de = vw_val.status
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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
    , downr.obj_id
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
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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
    , coalesce(bg_fct_ag96.code,bg_fct.code)
    , vw_val.bezeichnung
    , vw_val.einwohnergleichwert
    , vw_val.anzstaendigeeinwohner
    , vw_val.bemerkung_gep
    , vw_val.sanierungsdatum
    , bg_rn.code
    , vw_val.sanierungskonzept
    , vw_val.lage
    , vw_val.letzte_aenderung_gep
    , downr.obj_id
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
	LEFT JOIN tww_vl.building_group_renovation_necessity bg_rn on bg_rn.value_de = lower(vw_val.sanierungsbedarf)
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_ww ON bg_dt_ww.value_de = vw_val.beseitigung_haeusliches_abwasser 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_iw ON bg_dt_iw.value_de = vw_val.beseitigung_gewerbliches_abwasser 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_sw ON bg_dt_sw.value_de = vw_val.beseitigung_platzentwaesserung 
	LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_rw ON bg_dt_rw.value_de = vw_val.beseitigung_dachentwaesserung 
	LEFT JOIN {ext_schema}.vsadss_dataowner downr ON 1=1
	)
	ON CONFLICT(obj_id) DO UPDATE SET
	(
      function
    , identifier
    , ag96_population
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
    , EXCLUDED.ag96_population
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
    , downr.obj_id
    , {ext_schema}.convert_organisationid_to_vsa(vw_val.datenbewirtschafter_gep)
    , vw_val.einleitstelleref
    , hcd_oid
    , vw_val.fremdwasseranfall_geplant
    , vw_val.schmutzabwasseranfall_geplant
	FROM (SELECT NEW.*) as vw_val
	LEFT JOIN tww_od.hydraulic_char_data hcd on hcd.obj_id = cat.fk_hydraulic_char_data
	LEFT JOIN tww_od.wastewater_node wn on hcd.fk_wastewater_node=wn.obj_id
	LEFT JOIN {ext_schema}.vsadss_dataowner downr on 1=1
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