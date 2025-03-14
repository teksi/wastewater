----------------
-- Knoten
----------------

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gepknoten_insert()
RETURNS trigger AS
$BODY$
DECLARE
    co_oid varchar(16);
	ws_oid varchar(16);
BEGIN

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
	(
	  NEW.obj_id
	, NEW.bezeichnung
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.letzte_aenderung_wi
    , NEW.bemerkung_wi
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
    , NEW.letzte_aenderung_gep
    , NEW.bemerkung_gep
	, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
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
    , tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
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

    INSERT INTO tww_od.wastewater_node(
	  obj_id
    , backflow_level_current
	, bottom_level
	, situation3d_geometry
	, wwtp_number
	, ag96_is_gateway
	, ag64_function
	) VALUES
	(
	  NEW.obj_id
	, NEW.maxrueckstauhoehe
    , NEW.sohlenkote
    , ST_SetSRID(ST_MakePoint(ST_X(NEW.lage), ST_Y(NEW.lage), COALESCE(NEW.sohlenkote,'nan')), 2056 )
	, NEW.ara_nr
	, (SELECT code FROM tww_vl.wastewater_node_ag96_is_gateway WHERE value_de=NEW.istschnittstelle)
	, (SELECT code FROM tww_vl.wastewater_node_ag64_function WHERE value_de=NEW.funktionag)
	);

	CASE WHEN NEW.funktionag NOT IN ('Leitungsknoten','Anschluss') THEN
		-- Deckel
		INSERT INTO tww_od.structure_part(
		  fk_provider
		, identifier
		, last_modification
		) VALUES
		(
		  tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
		, NEW.bezeichnung
		, NEW.letzte_aenderung_wi
		)
		RETURNING obj_id into co_oid;

		INSERT INTO tww_od.cover(
		  obj_id
		, level
		, positional_accuracy
		, situation3d_geometry
		, ag64_fk_wastewater_node
		) VALUES
		(
		  co_oid
		, NEW.deckelkote
		, (SELECT code FROM tww_vl.cover_positional_accuracy WHERE value_de=NEW.lagegenauigkeit)
		, ST_SetSRID(ST_MakePoint(ST_X(NEW.lage), ST_Y(NEW.lage), COALESCE(NEW.deckelkote,'nan')), 2056 )
		, NEW.obj_id
		);
	ELSE NULL;
	END CASE;

    CASE WHEN COALESCE(NEW.ignore_ws,FALSE) OR NEW.funktionag IN ('Leitungsknoten','Anschluss')
	THEN NULL;
	ELSE
		INSERT INTO tww_od.wastewater_structure(
		  accessibility
		, detail_geometry3d_geometry
		, financing
		, fk_main_cover
		, fk_main_wastewater_node
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
		, ag96_fk_measure
		) VALUES
		(
		 (SELECT code FROM tww_vl.wastewater_structure_accessibility WHERE value_de=NEW.zugaenglichkeit)
		, ST_Force3D(NEW.detailgeometrie)
		, (SELECT code FROM tww_vl.wastewater_structure_financing WHERE value_de=NEW.finanzierung)
		, co_oid
		, NEW.obj_id
		, tww_app.fct_agxx_organisationid_to_vsa(NEW.betreiber)
		, tww_app.fct_agxx_organisationid_to_vsa(NEW.eigentuemer)
		, tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
		, NEW.bezeichnung
		, NEW.letzte_aenderung_wi
		, NEW.bemerkung_wi
		, (SELECT code FROM tww_vl.wastewater_structure_renovation_necessity WHERE value_de=NEW.sanierungsbedarf)
		, (SELECT code FROM tww_vl.wastewater_structure_status WHERE value_de=replace(NEW.bauwerkstatus,'.in_Betrieb',''))
		, NEW.jahr_zustandserhebung
		, (SELECT code FROM tww_vl.wastewater_structure_structure_condition WHERE value_de=NEW.baulicherzustand)
		, NEW.baujahr
		, NEW.gepmassnahmeref
		)
		RETURNING obj_id into ws_oid;

		UPDATE tww_od.wastewater_networkelement
		SET fk_wastewater_structure = ws_oid
		WHERE obj_id=NEW.obj_id;

		CASE WHEN NEW.funktionag   ='Abwasserreinigungsanlage' THEN
			------------ Abwasserreinigungsanlage ------------
			INSERT INTO tww_od.wwtp_stucture(
			  obj_id
			, kind
			)VALUES
			(
			  ws_oid
			, 3032 --unbekannt
			);
		WHEN NEW.funktionag =ANY(
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
		  ) OR (
			NEW.funktionag = ANY(ARRAY['Absturzbauwerk', 'andere', 'Be_Entlueftung', 'Kontrollschacht', 'Oelabscheider', 'Pumpwerk'
			, 'Regeneuberlauf', 'Schwimmstoffabscheider', 'Spuelschacht', 'Trennbauwerk', 'Vorbehandlung']) AND NEW.detailgeometrie IS NULL
			)  THEN
			INSERT INTO tww_od.manhole (
			  obj_id
			, function
			)VALUES
			(
			  ws_oid
			, (SELECT code FROM tww_vl.manhole_function_import_rel_agxx WHERE value_de=NEW.funktionag)
			);
		WHEN NEW.funktionag LIKE 'Versickerungsanlage%'  THEN
			INSERT INTO tww_od.infiltration_installation (
			  obj_id
			, kind
			)VALUES
			(
			  ws_oid
			, (SELECT code FROM tww_vl.infiltration_installation_kind_import_rel_agxx WHERE value_de=NEW.funktionag)
			);
		WHEN NEW.funktionag LIKE 'Einleitstelle%'  THEN
		INSERT INTO tww_od.discharge_point (
		  obj_id
		, relevance
		)VALUES
		(
		  ws_oid
		, (SELECT code FROM tww_vl.discharge_point_relevance_import_rel_agxx WHERE value_de=NEW.funktionag)
		);
		WHEN NEW.funktionag = 'Messstelle'  THEN
		INSERT INTO tww_od.manhole (
			  obj_id
			, function
			)VALUES
			(
			  ws_oid
			, 5345
			);
		INSERT INTO tww_od.measuring_point (
		  fk_wastewater_structure
		)VALUES
		(
		  ws_oid
		);
		ELSE
			INSERT INTO tww_od.special_structure (
			  obj_id
			, function
			)VALUES
			(
			  ws_oid
			, (SELECT code FROM tww_vl.special_structure_function_import_rel_agxx WHERE value_de=NEW.funktionag)
			);
		END CASE;

    END CASE;
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gepknoten_update()
RETURNS trigger AS
$BODY$
DECLARE
    co_oid varchar(16);
	ws_oid varchar(16);

BEGIN

    UPDATE tww_od.wastewater_networkelement SET
	  identifier = NEW.bezeichnung
	, fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ag64_last_modification = NEW.letzte_aenderung_wi
    , ag64_remark = NEW.bemerkung_wi
	, ag64_fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
	, ag96_last_modification = NEW.letzte_aenderung_gep
    , ag96_remark = NEW.bemerkung_gep
	, ag96_fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_gep)
	WHERE obj_id = NEW.obj_id;

    UPDATE tww_od.wastewater_node SET
	  backflow_level_current = NEW.maxrueckstauhoehe
	, bottom_level = NEW.sohlenkote
	, situation3d_geometry = ST_SetSRID(ST_MakePoint(ST_X(NEW.lage), ST_Y(NEW.lage), COALESCE(NEW.sohlenkote,'nan')), 2056)
	, wwtp_number = NEW.ara_nr
	, ag96_is_gateway = (SELECT code FROM tww_vl.wastewater_node_ag96_is_gateway WHERE value_de=NEW.istschnittstelle)
	, ag64_function = (SELECT code FROM tww_vl.wastewater_node_ag64_function WHERE value_de=NEW.funktionag)
	WHERE obj_id = NEW.obj_id;

	CASE WHEN NEW.funktionag NOT IN ('Leitungsknoten','Anschluss') THEN

		SELECT ws.obj_id,ws.fk_main_cover INTO ws_oid, co_oid FROM tww_od.wastewater_node wn
		LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id=wn.obj_id
		LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure = ws.obj_id;

		-- Deckel
		UPDATE tww_od.structure_part SET
		  fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
		, identifier = NEW.bezeichnung
		, last_modification = NEW.letzte_aenderung_wi
		WHERE obj_id = co_oid;

		UPDATE tww_od.cover SET
		  level = NEW.deckelkote
		, positional_accuracy = (SELECT code FROM tww_vl.cover_positional_accuracy WHERE value_de=NEW.lagegenauigkeit)
		, situation3d_geometry = ST_SetSRID(ST_MakePoint(ST_X(NEW.lage), ST_Y(NEW.lage), COALESCE(NEW.deckelkote,'nan')), 2056 )
		, ag64_fk_wastewater_node = NEW.obj_id
		WHERE obj_id = co_oid;

	ELSE NULL;
	END CASE;

    CASE WHEN COALESCE(NEW.ignore_ws,FALSE) OR NEW.funktionag IN ('Leitungsknoten','Anschluss')
	THEN NULL;
	ELSE
		UPDATE tww_od.wastewater_structure SET
		  accessibility = (SELECT code FROM tww_vl.wastewater_structure_accessibility WHERE value_de=NEW.zugaenglichkeit)
		, detail_geometry3d_geometry = ST_Force3D(NEW.detailgeometrie)
		, financing = (SELECT code FROM tww_vl.wastewater_structure_financing WHERE value_de=NEW.finanzierung)
		, fk_main_cover = co_oid
		, fk_main_wastewater_node = NEW.obj_id
		, fk_operator = tww_app.fct_agxx_organisationid_to_vsa(NEW.betreiber)
		, fk_owner = tww_app.fct_agxx_organisationid_to_vsa(NEW.eigentuemer)
		, fk_provider = tww_app.fct_agxx_organisationid_to_vsa(NEW.datenbewirtschafter_wi)
		, identifier = NEW.bezeichnung
		, last_modification = NEW.letzte_aenderung_wi
		, remark = NEW.bemerkung_wi
		, renovation_necessity = (SELECT code FROM tww_vl.wastewater_structure_renovation_necessity WHERE value_de=NEW.sanierungsbedarf)
		, status = (SELECT code FROM tww_vl.wastewater_structure_status WHERE value_de=replace(NEW.bauwerkstatus,'.in_Betrieb',''))
		, status_survey_year = NEW.jahr_zustandserhebung
		, structure_condition = (SELECT code FROM tww_vl.wastewater_structure_structure_condition WHERE value_de=NEW.baulicherzustand)
		, year_of_construction = NEW.baujahr
		, ag96_fk_measure = NEW.gepmassnahmeref
		WHERE obj_id = ws_oid;



		CASE WHEN NEW.funktionag   ='Abwasserreinigungsanlage'
		THEN
			CASE WHEN OLD.ws_type = 'wwtp_structure'
			THEN NULL;
			ELSE
				------------ Abwasserreinigungsanlage ------------
				INSERT INTO tww_od.wwtp_structure(
				  obj_id, kind
				)VALUES
				(
				  ws_oid, 3032 --unbekannt
				);
				DELETE FROM tww_od.manhole WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.special_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.infiltration_installation WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.discharge_point WHERE obj_id = OLD.obj_id;
			END CASE;
		WHEN NEW.funktionag =ANY(
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
		  ) OR (
			NEW.funktionag = ANY(ARRAY['Absturzbauwerk', 'andere', 'Be_Entlueftung', 'Kontrollschacht', 'Oelabscheider', 'Pumpwerk'
			, 'Regeneuberlauf', 'Schwimmstoffabscheider', 'Spuelschacht', 'Trennbauwerk', 'Vorbehandlung']) AND NEW.detailgeometrie IS NULL
			)  THEN
			CASE WHEN OLD.ws_type = 'manhole' THEN
				UPDATE tww_od.manhole SET
				function = (SELECT code FROM tww_vl.manhole_function_import_rel_agxx WHERE value_de=NEW.funktionag)
				WHERE obj_id = ws_oid
				;
			ELSE
				------------ Normschacht ------------
				INSERT INTO tww_od.manhole (
				  obj_id
				, function
				)VALUES
				(
				  ws_oid
				, (SELECT code FROM tww_vl.manhole_function_import_rel_agxx WHERE value_de=NEW.funktionag)
				);
				DELETE FROM tww_od.wwtp_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.special_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.infiltration_installation WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.discharge_point WHERE obj_id = OLD.obj_id;
			END CASE;
		WHEN NEW.funktionag LIKE 'Versickerungsanlage%'  THEN
			CASE WHEN OLD.ws_type = 'infiltration_installation' THEN
				UPDATE tww_od.infiltration_installation SET
				kind = (SELECT code FROM tww_vl.infiltration_installation_kind_import_rel_agxx WHERE value_de=NEW.funktionag)
				WHERE obj_id = ws_oid
				;
			ELSE
				------------ Versickerungsanlage ------------
				INSERT INTO tww_od.infiltration_installation (
				  obj_id
				, kind
				)VALUES
				(
				  ws_oid
				, (SELECT code FROM tww_vl.infiltration_installation_kind_import_rel_agxx WHERE value_de=NEW.funktionag)
				);
				DELETE FROM tww_od.wwtp_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.special_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.manhole WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.discharge_point WHERE obj_id = OLD.obj_id;
			END CASE;
		WHEN NEW.funktionag LIKE 'Einleitstelle%'  THEN
			CASE WHEN OLD.ws_type = 'discharge_point' THEN
				UPDATE tww_od.discharge_point SET
				relevance = (SELECT code FROM tww_vl.discharge_point_relevance_import_rel_agxx WHERE value_de=NEW.funktionag)
				WHERE obj_id = ws_oid;
			ELSE
				------------ Einleitstelle ------------
				INSERT INTO tww_od.discharge_point (
				  obj_id
				, kind
				)VALUES
				(
				  ws_oid
				, (SELECT code FROM tww_vl.discharge_point_relevance_import_rel_agxx WHERE value_de=NEW.funktionag)
				);
				DELETE FROM tww_od.wwtp_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.special_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.manhole WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.infiltration_installation WHERE obj_id = OLD.obj_id;
			END CASE;
		ELSE
			CASE WHEN OLD.ws_type = 'special_structure' THEN
				UPDATE tww_od.special_structure SET
				function = (SELECT code FROM tww_vl.special_structure_function_import_rel_agxx WHERE value_de=NEW.funktionag)
				WHERE obj_id = ws_oid;
			ELSE
				------------ Spezialbauwerk ------------
				INSERT INTO tww_od.special_structure (
				  obj_id
				, kind
				)VALUES
				(
				  ws_oid
				, (SELECT code FROM tww_vl.special_structure_function_import_rel_agxx WHERE value_de=NEW.funktionag)
				);
				DELETE FROM tww_od.wwtp_structure WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.discharge_point WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.manhole WHERE obj_id = OLD.obj_id;
				DELETE FROM tww_od.infiltration_installation WHERE obj_id = OLD.obj_id;
			END CASE;
		END CASE;
    END CASE;
  RETURN NEW;
 END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_agxx_gepknoten_delete()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM tww_app.vw_tww_wastewater_structure where wn_obj_id=old.obj_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;
