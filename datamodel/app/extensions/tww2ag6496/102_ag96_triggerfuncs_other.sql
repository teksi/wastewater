---------- GEPHaltung ----------
--------------------------------

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gephaltung_insert()
RETURNS trigger AS
$BODY$
DECLARE
	hw_ratio numeric(5,2);
	pp_oid varchar(16);
	ws_oid varchar(16);
	rp_from_oid varchar(16);
	rp_to_oid varchar(16);
BEGIN
	SELECT (CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_breite_ist IS NULL THEN 1
	  ELSE NEW.lichte_hoehe_ist::numeric/NEW.lichte_breite_ist END) INTO hw_ratio;

	SELECT fk_pipe_profile INTO pp_oid
	FROM tww_app.vw_agxx_rohrprofile_aux
	WHERE value_de =  NEW.profiltyp
	AND height_width_ratio = hw_ratio;
	IF NOT FOUND THEN
	INSERT INTO tww_od.pipe_profile
	(
	  profile_type
	, identifier
	, height_width_ratio
	, fk_provider
	) VALUES
	(
	  (SELECT code FROM tww_vl.pipe_profile_profile_type ppt WHERE value_de=NEW.profiltyp)
	, CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_hoehe_ist=NEW.lichte_breite_ist
		THEN NEW.profiltyp
		ELSE
		array_to_string(
		  array[(SELECT abbr_de FROM tww_vl.pipe_profile_profile_type ppt WHERE value_de=NEW.profiltyp)
		  ,NEW.lichte_hoehe_ist::varchar,NEW.lichte_breite_ist::varchar]
		  ,'_' -- delimiter
		)
	  END
	, hw_ratio
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	)RETURNING obj_id INTO pp_oid;
	ELSE NULL;
	END IF;


	INSERT INTO tww_od.wastewater_structure
	(
      status
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
	)VALUES
	(
	  (SELECT code FROM tww_vl.wastewater_structure_status WHERE value_de=replace(NEW.bauwerkstatus,'.in_Betrieb',''))
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.eigentuemer)
	, NEW.jahr_zustandserhebung
    , (SELECT code FROM tww_vl.wastewater_structure_financing WHERE value_de=NEW.finanzierung)
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.betreiber)
	, NEW.bezeichnung
    , NEW.letzte_aenderung_wi
    , (SELECT code FROM tww_vl.wastewater_structure_renovation_necessity WHERE value_de=NEW.sanierungsbedarf)
    , NEW.wiederbeschaffungswert
    , (SELECT code FROM tww_vl.wastewater_structure_structure_condition WHERE value_de=NEW.baulicherzustand)
    , NEW.baujahr
	)
	RETURNING obj_id into ws_oid;

	INSERT INTO tww_od.agxx_wastewater_structure
	(
      fk_wastewater_structure
	, ag96_fk_measure
	)VALUES
	(
	  ws_oid
	, NEW.gepmassnahmeref
	);

	INSERT INTO tww_od.channel
	(
	  obj_id
    , usage_current
    , function_hierarchic
	, function_hydraulic
	, usage_planned
	)VALUES
	(
	  ws_oid
    , (SELECT code FROM tww_vl.channel_usage_current_import_rel_agxx WHERE value_de=NEW.nutzungsartag_ist)
    , (SELECT code FROM tww_vl.channel_function_hierarchic WHERE value_de=NEW.funktionhierarchisch)
    , (SELECT code FROM tww_vl.channel_function_hydraulic WHERE value_de=NEW.funktionhydraulisch)
    , (SELECT code FROM tww_vl.channel_usage_planned_import_rel_agxx WHERE value_de=NEW.nutzungsartag_geplant)
	);

    INSERT INTO tww_od.wastewater_networkelement(
	  obj_id
	, identifier
	, fk_provider
	, fk_wastewater_structure
	) VALUES
	(
	  NEW.obj_id
	, NEW.bezeichnung
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ws_oid
	);

	INSERT INTO tww_od.agxx_wastewater_networkelement(
	  fk_wastewater_networkelement
    , ag64_remark
	, ag64_fk_provider
    , ag96_remark
	, ag96_fk_provider
	) VALUES
	(
	  NEW.obj_id
    , NEW.bemerkung_wi
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.bemerkung_gep
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	);

	INSERT INTO tww_od.agxx_last_modification(
	  fk_element
	, ag64_last_modification
	, ag96_last_modification
	) VALUES
	(
	  NEW.obj_id
    , NEW.letzte_aenderung_wi
    , NEW.letzte_aenderung_gep
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
	, ST_SetSRID(ST_MakePoint(ST_X(ST_StartPoint(NEW.verlauf)), ST_X(ST_StartPoint(NEW.verlauf)), COALESCE(NEW.kote_beginn,'nan')), 2056 )
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
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
	, ST_SetSRID(ST_MakePoint(ST_X(ST_EndPoint(NEW.verlauf)), ST_X(ST_EndPoint(NEW.verlauf)), COALESCE(NEW.kote_ende,'nan')), 2056 )
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.endknoten
	, NEW.letzte_aenderung_wi
    , NEW.kote_ende
	)RETURNING obj_id into rp_to_oid;


	INSERT INTO tww_od.reach
	(
	  obj_id
    , clear_height
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
	);

	INSERT INTO tww_od.agxx_reach
	(
	  fk_reach
	, ag96_clear_height_planned
	, ag96_clear_width_planned
	)VALUES
	(
	  NEW.obj_id
	, NEW.lichte_hoehe_geplant
	, NEW.lichte_breite_geplant
	);
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gephaltung_update()
RETURNS trigger AS
$BODY$
DECLARE
	hw_ratio numeric(5,2);
	pp_oid varchar(16);
	ws_oid varchar(16);
	rp_from_oid varchar(16);
	rp_to_oid varchar(16);
BEGIN

	SELECT (CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_breite_ist IS NULL THEN 1
	  ELSE NEW.lichte_hoehe_ist::numeric/NEW.lichte_breite_ist END) INTO hw_ratio;

	SELECT fk_pipe_profile INTO pp_oid
	FROM tww_app.vw_agxx_rohrprofile_aux
	WHERE value_de =  NEW.profiltyp
	AND height_width_ratio = hw_ratio;
	IF NOT FOUND THEN
	INSERT INTO tww_od.pipe_profile
	(
	  profile_type
	, identifier
	, height_width_ratio
	, fk_provider
	) VALUES
	(
	  (SELECT code FROM ppt)
	, CASE WHEN NEW.lichte_breite_ist= 0 OR NEW.lichte_hoehe_ist=NEW.lichte_breite_ist
		THEN NEW.profiltyp
		ELSE
		array_to_string(
		  array[(SELECT abbr_de FROM ppt),NEW.lichte_hoehe_ist::varchar,NEW.lichte_breite_ist::varchar]
		  ,'_' -- delimiter
		)
	  END
	, hw_ratio
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	)RETURNING obj_id INTO pp_oid;
	ELSE NULL;
	END IF;

	UPDATE tww_od.wastewater_networkelement SET
	  identifier = NEW.bezeichnung
	, fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	WHERE obj_id = NEW.obj_id
	RETURNING fk_wastewater_structure into ws_oid;

	UPDATE tww_od.agxx_wastewater_networkelement SET
	  ag64_remark = NEW.bemerkung_wi
	, ag64_fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , ag96_remark = NEW.bemerkung_gep
	, ag96_fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE fk_wastewater_networkelement = NEW.obj_id;

	UPDATE tww_od.agxx_last_modification SET
	  ag64_last_modification = NEW.letzte_aenderung_wi
	, ag96_last_modification = NEW.letzte_aenderung_gep
	WHERE fk_element = NEW.obj_id;

	UPDATE tww_od.wastewater_structure SET
      status = (SELECT code FROM tww_vl.wastewater_structure_status WHERE value_de=replace(NEW.bauwerkstatus,'.in_Betrieb',''))
	, fk_owner = tww_app.fct_agxx_organisationid_to_vsa(NEW.eigentuemer)
	, status_survey_year = NEW.jahr_zustandserhebung
    , financing = (SELECT code FROM tww_vl.wastewater_structure_financing WHERE value_de=NEW.finanzierung)
    , fk_operator = tww_app.fct_agxx_organisationid_to_vsa(NEW.betreiber)
	, identifier = NEW.bezeichnung
    , last_modification = NEW.letzte_aenderung_wi
    , renovation_necessity = (SELECT code FROM tww_vl.wastewater_structure_renovation_necessity WHERE value_de=NEW.sanierungsbedarf)
    , replacement_value = NEW.wiederbeschaffungswert
    , structure_condition = (SELECT code FROM tww_vl.wastewater_structure_structure_condition WHERE value_de=NEW.baulicherzustand)
    , year_of_construction = NEW.baujahr
	WHERE obj_id = ws_oid;

	UPDATE tww_od.agxx_wastewater_structure SET
	  ag96_fk_measure = NEW.gepmassnahmeref
	WHERE fk_wastewater_structure = ws_oid;

	UPDATE tww_od.channel SET
      usage_current = (SELECT code FROM tww_vl.channel_usage_current_import_rel_agxx WHERE value_de=NEW.nutzungsartag_ist)
    , function_hierarchic = (SELECT code FROM tww_vl.channel_function_hierarchic WHERE value_de=NEW.funktionhierarchisch)
	, function_hydraulic = (SELECT code FROM tww_vl.channel_function_hydraulic WHERE value_de=NEW.funktionhydraulisch)
	, usage_planned = (SELECT code FROM tww_vl.channel_usage_planned_import_rel_agxx WHERE value_de=NEW.nutzungsartag_geplant)
	WHERE obj_id = ws_oid;

	SELECT fk_reach_point_from,fk_reach_point_to INTO rp_from_oid,rp_to_oid
	FROM tww_od.reach
	WHERE obj_id = OLD.obj_id;


	UPDATE tww_od.reach_point SET
      elevation_accuracy = (SELECT code FROM tww_vl.reach_point_elevation_accuracy WHERE value_de=NEW.hoehengenauigkeit_von)
	, situation3d_geometry = ST_SetSRID(ST_MakePoint(ST_X(ST_StartPoint(NEW.verlauf)), ST_X(ST_StartPoint(NEW.verlauf)), COALESCE(NEW.kote_beginn,'nan')), 2056 )
    , fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , fk_wastewater_networkelement = NEW.startknoten
    , last_modification = NEW.letzte_aenderung_wi
    , level = NEW.kote_beginn
	WHERE obj_id = rp_from_oid;

	UPDATE tww_od.reach_point SET
      elevation_accuracy = (SELECT code FROM tww_vl.reach_point_elevation_accuracy WHERE value_de=NEW.hoehengenauigkeit_von)
	, situation3d_geometry = ST_SetSRID(ST_MakePoint(ST_X(ST_EndPoint(NEW.verlauf)), ST_X(ST_EndPoint(NEW.verlauf)), COALESCE(NEW.kote_ende,'nan')), 2056 )
    , fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , fk_wastewater_networkelement = NEW.endknoten
    , last_modification = NEW.letzte_aenderung_wi
    , level = NEW.kote_ende
	WHERE obj_id = rp_to_oid;

	UPDATE tww_od.reach re SET
	  clear_height = NEW.lichte_hoehe_ist
    , material = (SELECT code FROM tww_vl.reach_material WHERE value_de=NEW.material)
    , fk_pipe_profile = pp_oid
	, hydraulic_load_current = NEW.hydraulischebelastung
    , length_effective = NEW.laengeeffektiv
    , progression3d_geometry = ST_Force3D(NEW.verlauf)
    , reliner_material = (SELECT code FROM tww_vl.reach_reliner_material WHERE value_de=NEW.reliner_material)
    , reliner_nominal_size = NEW.reliner_nennweite
    , relining_construction = (SELECT code FROM tww_vl.reach_relining_construction WHERE value_de=NEW.reliner_bautechnik)
    , relining_kind = (SELECT code FROM tww_vl.reach_relining_kind WHERE value_de=NEW.reliner_art)
	WHERE re.obj_id=NEW.obj_id;

	UPDATE tww_od.agxx_reach re SET
	  ag96_clear_height_planned = NEW.lichte_hoehe_geplant
	, ag96_clear_width_planned = NEW.lichte_breite_geplant
	WHERE re.fk_reach=NEW.obj_id;

	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gephaltung_delete()
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
CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gepmassnahme_upsert()
RETURNS trigger AS
$BODY$
BEGIN
    UPDATE tww_od.measure msr
	SET
	  category = (SELECT code FROM tww_vl.measure_category_import_rel_agxx WHERE value_de = NEW.kategorie)
    , date_entry = NEW.datum_eingang
    , description = NEW.beschreibung
    , identifier = NEW.bezeichnung
    , intervention_demand = NEW.handlungsbedarf
    , line_geometry = NEW.ausdehnung
    , link = NEW.verweis
    , perimeter_geometry = NEW.perimeter
    , priority = (SELECT code FROM tww_vl.measure_priority WHERE value_de = NEW.prioritaetag)
    , remark = NEW.bemerkung_gep
    , status = (SELECT code FROM tww_vl.measure_status WHERE value_de = NEW.status)
    , symbolpos_geometry = NEW.symbolpos
    , total_cost = NEW.gesamtkosten
    , year_implementation_effective = NEW.jahr_umsetzung_effektiv
    , year_implementation_planned = NEW.jahr_umsetzung_geplant
    , last_modification = NEW.letzte_aenderung_gep
--    , fk_dataowner = downr.value_obj_id
    , fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
    , fk_responsible_entity = tww_app.fct_agxx_organisationid_to_vsa(NEW.traegerschaft)
    , fk_responsible_start = tww_app.fct_agxx_organisationid_to_vsa(NEW.verantwortlich_ausloesung)
	WHERE msr.obj_id=NEW.obj_id;

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
    , fk_provider
    , fk_responsible_entity
    , fk_responsible_start
	)VALUES
	(
	  NEW.obj_id
    , (SELECT code FROM tww_vl.measure_category_import_rel_agxx WHERE value_de = NEW.kategorie)
    , NEW.datum_eingang
    , NEW.beschreibung
    , NEW.bezeichnung
    , NEW.handlungsbedarf
    , NEW.ausdehnung
    , NEW.verweis
    , NEW.perimeter
    , (SELECT code FROM tww_vl.measure_priority WHERE value_de = NEW.prioritaetag)
    , NEW.bemerkung_gep
    , (SELECT code FROM tww_vl.measure_status WHERE value_de = NEW.status)
    , NEW.symbolpos
    , NEW.gesamtkosten
    , NEW.jahr_umsetzung_effektiv
    , NEW.jahr_umsetzung_geplant
    , NEW.letzte_aenderung_gep
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.traegerschaft)
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.verantwortlich_ausloesung)
	);
	END IF
	;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gepmassnahme_delete()
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

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_einzugsgebiet_upsert()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_od.catchment_area ca SET
      direct_discharge_current = (SELECT code FROM tww_vl.catchment_area_direct_discharge_current WHERE value_de = NEW.direkteinleitung_in_gewaesser_ist)
    , direct_discharge_planned = (SELECT code FROM tww_vl.catchment_area_direct_discharge_planned WHERE value_de = NEW.direkteinleitung_in_gewaesser_geplant)
    , discharge_coefficient_rw_current = NEW.abflussbeiwert_rw_ist
    , discharge_coefficient_rw_planned = NEW.abflussbeiwert_rw_geplant
    , discharge_coefficient_ww_current = NEW.abflussbeiwert_sw_ist
    , discharge_coefficient_ww_planned = NEW.abflussbeiwert_sw_geplant
    , drainage_system_current = (SELECT code FROM tww_vl.catchment_area_drainage_system_current_import_rel_agxx WHERE value_de = NEW.entwaesserungssystemag_ist)
    , drainage_system_planned = (SELECT code FROM tww_vl.catchment_area_drainage_system_planned_import_rel_agxx WHERE value_de = NEW.entwaesserungssystemag_geplant)
    , identifier = NEW.bezeichnung
    , infiltration_current = (SELECT code FROM tww_vl.catchment_area_infiltration_current WHERE value_de = NEW.versickerung_ist)
    , infiltration_planned = (SELECT code FROM tww_vl.catchment_area_infiltration_planned WHERE value_de = NEW.versickerung_geplant)
    , perimeter_geometry = NEW.perimeter
    , population_density_current = NEW.einwohnerdichte_ist
    , population_density_planned = NEW.einwohnerdichte_geplant
    , remark = NEW.bemerkung_gep
    , retention_current = (SELECT code FROM tww_vl.catchment_area_retention_current WHERE value_de = NEW.retention_ist)
    , retention_planned = (SELECT code FROM tww_vl.catchment_area_retention_planned WHERE value_de = NEW.retention_geplant)
    , runoff_limit_current = NEW.abflussbegrenzung_ist
    , runoff_limit_planned = NEW.abflussbegrenzung_geplant
    , seal_factor_rw_current = NEW.befestigungsgrad_rw_ist
    , seal_factor_rw_planned = NEW.befestigungsgrad_rw_geplant
    , seal_factor_ww_current = NEW.befestigungsgrad_sw_ist
    , seal_factor_ww_planned = NEW.befestigungsgrad_sw_geplant
    , sewer_infiltration_water_production_current = NEW.fremdwasseranfall_ist
    , sewer_infiltration_water_production_planned = NEW.fremdwasseranfall_geplant
    , surface_area = NEW.flaeche
    , waste_water_production_current = NEW.schmutzabwasseranfall_ist
    , waste_water_production_planned = NEW.schmutzabwasseranfall_geplant
    , last_modification = NEW.letzte_aenderung_gep
    , fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
    , fk_wastewater_networkelement_rw_current = NEW.gepknoten_rw_istref
    , fk_wastewater_networkelement_rw_planned = NEW.gepknoten_rw_geplantref
    , fk_wastewater_networkelement_ww_planned = NEW.gepknoten_sw_geplantref
    , fk_wastewater_networkelement_ww_current = NEW.gepknoten_sw_istref
	WHERE ca.obj_id = NEW.obj_id;
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
    , fk_provider
    , fk_wastewater_networkelement_rw_current
    , fk_wastewater_networkelement_rw_planned
    , fk_wastewater_networkelement_ww_planned
    , fk_wastewater_networkelement_ww_current
	)VALUES
	(
	  NEW.obj_id
    , (SELECT code FROM tww_vl.catchment_area_direct_discharge_current WHERE value_de = NEW.direkteinleitung_in_gewaesser_ist)
    , (SELECT code FROM tww_vl.catchment_area_direct_discharge_planned WHERE value_de = NEW.direkteinleitung_in_gewaesser_geplant)
    , NEW.abflussbeiwert_rw_ist
    , NEW.abflussbeiwert_rw_geplant
    , NEW.abflussbeiwert_sw_ist
    , NEW.abflussbeiwert_sw_geplant
    , (SELECT code FROM tww_vl.catchment_area_drainage_system_current_import_rel_agxx WHERE value_de = NEW.entwaesserungssystemag_ist)
    , (SELECT code FROM tww_vl.catchment_area_drainage_system_planned_import_rel_agxx WHERE value_de = NEW.entwaesserungssystemag_geplant)
    , NEW.bezeichnung
    , (SELECT code FROM tww_vl.catchment_area_infiltration_current WHERE value_de = NEW.versickerung_ist)
    , (SELECT code FROM tww_vl.catchment_area_infiltration_planned WHERE value_de = NEW.versickerung_geplant)
    , NEW.perimeter
    , NEW.einwohnerdichte_ist
    , NEW.einwohnerdichte_geplant
    , NEW.bemerkung_gep
    , (SELECT code FROM tww_vl.catchment_area_retention_current WHERE value_de = NEW.retention_ist)
    , (SELECT code FROM tww_vl.catchment_area_retention_planned WHERE value_de = NEW.retention_geplant)
    , NEW.abflussbegrenzung_ist
    , NEW.abflussbegrenzung_geplant
    , NEW.befestigungsgrad_rw_ist
    , NEW.befestigungsgrad_rw_geplant
    , NEW.befestigungsgrad_sw_ist
    , NEW.befestigungsgrad_sw_geplant
    , NEW.fremdwasseranfall_ist
    , NEW.fremdwasseranfall_geplant
    , NEW.flaeche
    , NEW.schmutzabwasseranfall_ist
    , NEW.schmutzabwasseranfall_geplant
    , NEW.letzte_aenderung_gep
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
    , NEW.gepknoten_rw_istref
    , NEW.gepknoten_rw_geplantref
    , NEW.gepknoten_sw_geplantref
    , NEW.gepknoten_sw_istref
	)
	;
	END IF;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_einzugsgebiet_delete()
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


CREATE OR REPLACE FUNCTION tww_app.ft_agxx_ueberlauf_foerderaggregat_insert()
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
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, NEW.bemerkung_wi
	, NEW.bezeichnung
	, NEW.letzte_aenderung_wi
	, NEW.letzte_aenderung_wi
	, NEW.bemerkung_wi
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, NEW.letzte_aenderung_gep
	, NEW.bemerkung_gep
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	);

	INSERT INTO tww_od.agxx_overflow (
	  fk_overflow
    , ag64_remark
	, ag64_fk_provider
    , ag96_remark
	, ag96_fk_provider
	)
	VALUES
	(
	  NEW.obj_id
	, NEW.bemerkung_wi
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, NEW.bemerkung_gep
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	);

	INSERT INTO tww_od.agxx_last_modification (
	  fk_element
	, ag64_last_modification
	, ag96_last_modification
	)
	VALUES
	(
	  NEW.obj_id
	, NEW.letzte_aenderung_wi
	, NEW.letzte_aenderung_gep
	);

	CASE WHEN NEW.art  = 'Foerderaggregat' THEN
		INSERT INTO tww_od.pump (obj_id) VALUES (NEW.obj_id);
	WHEN NEW.art  = 'Leapingwehr' THEN
		INSERT INTO tww_od.leapingweir (obj_id) VALUES (NEW.obj_id);
	WHEN NEW.art  = 'Streichwehr' THEN
		INSERT INTO tww_od.prank_weir (obj_id) VALUES (NEW.obj_id);
	ELSE NULL;
	END CASE;

  RETURN NEW;

END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_ueberlauf_foerderaggregat_update()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_od.overflow
	SET
	 fk_wastewater_node = NEW.knotenref
	, fk_overflow_to = NEW.knoten_nachref
	, fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, remark = NEW.bemerkung_wi
	, identifier = NEW.bezeichnung
	, last_modification = NEW.letzte_aenderung_wi
	WHERE obj_id=NEW.obj_id;

	UPDATE tww_od.agxx_overflow
	SET
      ag64_remark = NEW.bemerkung_wi
	, ag64_fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , ag96_remark = NEW.bemerkung_gep
	, ag96_fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE fk_overflow=NEW.obj_id;

	UPDATE tww_od.agxx_last_modification
	SET
	  ag64_last_modification = NEW.letzte_aenderung_wi
	, ag96_last_modification = NEW.letzte_aenderung_gep
	WHERE fk_element=NEW.obj_id;

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

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_ueberlauf_foerderaggregat_delete()
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

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_bautenausserhalbbaugebiet_upsert()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_od.building_group bg
	SET
	  function = (SELECT code FROM tww_vl.building_group_function_import_rel_agxx WHERE value_de = NEW.arealnutzung)
    , identifier = NEW.bezeichnung
    , population_equivalent = NEW.einwohnergleichwert
    , remark = NEW.bemerkung_gep
    , renovation_date = NEW.sanierungsdatum
    , renovation_necessity = (SELECT code FROM tww_vl.building_group_renovation_necessity WHERE lower(value_de) = lower(NEW.sanierungsbedarf))
    , restructuring_concept = NEW.sanierungskonzept
    , situation_geometry = NEW.lage
    , last_modification = NEW.letzte_aenderung_gep
    , fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE bg.obj_id=NEW.obj_id;
	IF NOT FOUND THEN
	INSERT INTO tww_od.building_group
	(
	  obj_id
    , function
    , identifier
    , population_equivalent
    , remark
    , renovation_date
    , renovation_necessity
    , restructuring_concept
    , situation_geometry
    , last_modification
    , fk_provider
	)
	(
	SELECT
	  NEW.obj_id
    , (SELECT code FROM tww_vl.building_group_function_import_rel_agxx WHERE value_de = NEW.arealnutzung)
    , NEW.bezeichnung
    , NEW.einwohnergleichwert
    , NEW.bemerkung_gep
    , NEW.sanierungsdatum
    , (SELECT code FROM tww_vl.building_group_renovation_necessity WHERE lower(value_de) = lower(NEW.sanierungsbedarf))
    , NEW.sanierungskonzept
    , NEW.lage
    , NEW.letzte_aenderung_gep
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	);
	END IF;

	UPDATE tww_od.agxx_building_group bg
	SET
	  ag96_population = NEW.anzstaendigeeinwohner
	, ag96_owner_address = NEW.eigentuemeradresse
    , ag96_owner_name = NEW.eigentuemername
    , ag96_label_number = NEW.nummer
    , ag96_disposal_wastewater = (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_haeusliches_abwasser)
    , ag96_disposal_industrial_wastewater = (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_gewerbliches_abwasser)
    , ag96_disposal_square_water = (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_platzentwaesserung)
    , ag96_disposal_roof_water = (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_dachentwaesserung)
	WHERE bg.fk_building_group=NEW.obj_id;
	IF NOT FOUND THEN
	INSERT INTO tww_od.agxx_building_group
	(
	  fk_building_group
	, ag96_population
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
	  NEW.obj_id
    , NEW.anzstaendigeeinwohner
    , NEW.eigentuemeradresse
    , NEW.eigentuemername
    , NEW.nummer
    , (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_haeusliches_abwasser)
    , (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_gewerbliches_abwasser)
    , (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_platzentwaesserung)
    , (SELECT code FROM tww_vl.building_group_ag96_disposal_type WHERE value_de = NEW.beseitigung_dachentwaesserung)
	);
	END IF;

  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_bautenausserhalbbaugebiet_delete()
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


CREATE OR REPLACE FUNCTION tww_app.ft_agxx_sbw_einzugsgebiet_upsert()
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
		  remark
		, fk_wastewater_node
		, status
		)
		VALUES
		(
		  NEW.bemerkung_gep
		, NEW.sonderbauwerk_ref
		, 6372
		)
		RETURNING obj_id into hcd_oid;
	END IF;


	UPDATE tww_od.catchment_area_totals cat
	SET
	  identifier = NEW.bezeichnung
    , population = NEW.einwohner_ist
    , population_dim = NEW.einwohner_geplant
    , sewer_infiltration_water = NEW.fremdwasseranfall_ist
    , surface_area = NEW.flaeche_ist
    , surface_dim = NEW.flaeche_geplant
    , surface_imp = NEW.flaeche_befestigt_ist
    , surface_imp_dim = NEW.flaeche_befestigt_geplant
    , surface_red = NEW.flaeche_reduziert_ist
    , surface_red_dim = NEW.flaeche_reduziert_geplant
    , waste_water_production = NEW.schmutzabwasseranfall_ist
    , last_modification = NEW.letzte_aenderung_gep
    , fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
    , fk_discharge_point = NEW.einleitstelleref
    , fk_hydraulic_char_data = hcd_oid
	WHERE cat.obj_id = NEW.obj_id;
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
    , fk_provider
    , fk_discharge_point
    , fk_hydraulic_char_data
	)VALUES
	(
	  NEW.obj_id
    , NEW.bezeichnung
    , NEW.einwohner_ist
    , NEW.einwohner_geplant
    , NEW.fremdwasseranfall_ist
    , NEW.flaeche_ist
    , NEW.flaeche_geplant
    , NEW.flaeche_befestigt_ist
    , NEW.flaeche_befestigt_geplant
    , NEW.flaeche_reduziert_ist
    , NEW.flaeche_reduziert_geplant
    , NEW.schmutzabwasseranfall_ist
    , NEW.letzte_aenderung_gep
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
    , NEW.einleitstelleref
    , hcd_oid
	);
	END IF;

	UPDATE tww_od.agxx_catchment_area_totals cat
	SET
      ag96_sewer_infiltration_water_dim = NEW.fremdwasseranfall_geplant
    , ag96_waste_water_production_dim = NEW.schmutzabwasseranfall_geplant
	, ag96_perimeter_geometry = NEW.perimeter_ist
	WHERE cat.fk_catchment_area_totals = NEW.obj_id;
	IF NOT FOUND THEN
	INSERT INTO tww_od.agxx_catchment_area_totals
	(
	  fk_catchment_area_totals
    , ag96_sewer_infiltration_water_dim
    , ag96_waste_water_production_dim
	, ag96_perimeter_geometry
	)VALUES
	(
	  NEW.obj_id
    , NEW.fremdwasseranfall_geplant
    , NEW.schmutzabwasseranfall_geplant
	, NEW.perimeter_ist
	);
	END IF;
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_sbw_einzugsgebiet_delete()
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

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_versickerungsbereichag_insert()
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
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	, NEW.bemerkung_gep
	, NEW.letzte_aenderung_gep
	);

	INSERT INTO tww_od.infiltration_zone
	(
	  obj_id
	, perimeter_geometry
	, infiltration_capacity
	)
	(
	SELECT
	  NEW.obj_id
	, NEW.perimeter
	, (SELECT code FROM tww_vl.infiltration_zone_infiltration_capacity WHERE value_de = NEW.versickerungsmoeglichkeitag)
	);

	INSERT INTO tww_od.agxx_infiltration_zone
	(
	  fk_infiltration_zone
	, ag96_permeability
	, ag96_limitation
	, ag96_thickness
	, ag96_q_check
	)
	(
	SELECT
	  NEW.obj_id
	, NEW.durchlaessigkeit
	, NEW.einschraenkung
	, NEW.maechtigkeit
	, NEW.q_check
	);
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_versickerungsbereichag_update()
RETURNS trigger AS
$BODY$
BEGIN
	UPDATE tww_od.zone
	SET
	  identifier = NEW.bezeichnung
	, fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	, remark = NEW.bemerkung_gep
	, last_modification = NEW.letzte_aenderung_gep
	WHERE obj_id=NEW.obj_id;

	UPDATE tww_od.infiltration_zone
	SET
	  perimeter_geometry = NEW.perimeter
	, infiltration_capacity = (SELECT code FROM tww_vl.infiltration_zone_infiltration_capacity WHERE value_de = NEW.versickerungsmoeglichkeitag)
	WHERE obj_id=NEW.obj_id;

	UPDATE tww_od.agxx_infiltration_zone
	SET
	  ag96_permeability = NEW.bezeichnung
	, ag96_limitation = NEW.einschraenkung
	, ag96_thickness = NEW.maechtigkeit
	, ag96_q_check = NEW.q_check
	WHERE fk_infiltration_zone=NEW.obj_id;
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_versickerungsbereichag_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_od.infiltration_zone where obj_id=old.obj_id;
	DELETE FROM tww_od.zone where obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;
