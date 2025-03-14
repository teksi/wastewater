-- Funktion zum Mapping der Organisations-ID

CREATE OR REPLACE FUNCTION tww_app.fct_agxx_organisationid_to_vsa(oid varchar)
RETURNS varchar(16)
AS
$BODY$
DECLARE
	out_oid varchar(16);
BEGIN
	SELECT obj_id INTO out_oid FROM tww_od.organisation WHERE right(obj_id,8) = right(oid,8);
	return out_oid;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.fct_agxx_linkup_secondary_nodes(oid varchar)
RETURNS VOID
AS
$BODY$
DECLARE
DECLARE
	ws_oid varchar(16);
	wn_oids varchar(16)[];
	sp_oids varchar(16)[];
BEGIN
     SELECT ws.obj_id, array_agg(wn.obj_id) INTO  ws_oid, wn_oids
	  FROM (SELECT ws.obj_id,
			st_buffer(detail_geometry3d_geometry,0.0001)
			as detail_geometry2d_geometry
		 FROM tww_od.wastewater_structure ws
		 LEFT JOIN tww_od.channel ch on ws.obj_id=ch.obj_id
		 WHERE ws.detail_geometry3d_geometry IS NOT NULL
		 AND ch.obj_id is NULL) ws
	  LEFT JOIN  (SELECT obj_id,situation3d_geometry
				  from tww_od.wastewater_node) wn ON
		ST_CoveredBy(wn.situation3d_geometry
		  , detail_geometry2d_geometry)
	  LEFT JOIN (SELECT obj_id,fk_wastewater_structure FROM tww_od.wastewater_networkelement) ne on ne.obj_id=wn.obj_id
	  WHERE ne.fk_wastewater_structure IS NULL
	  GROUP BY ws.obj_id;

	SELECT array_agg(co.obj_id) INTO sp_oids
	  FROM tww_od.agxx_wastewater_node wn
	  LEFT JOIN tww_od.agxx_cover co on co.ag64_fk_wastewater_node=wn.obj_id
	  WHERE wn.obj_id = any(wn_oids)
	  GROUP BY wn.obj_id;

	CASE WHEN ws_oid is not NULL THEN
	  UPDATE tww_od.wastewater_networkelement
        SET fk_wastewater_structure = ws_oid
        WHERE obj_id = wn_oid;

      UPDATE tww_od.structure_part
        SET fk_wastewater_structure = ws_oid
        WHERE obj_id = ANY(sp_oids);

	ELSE NULL;
	END CASE;
	RETURN;
END;
$BODY$
LANGUAGE plpgsql;


