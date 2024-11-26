CREATE VIEW tww_app.vw_labels_outflow
AS
SELECT
			ne.fk_wastewater_structure ws,
			rp.obj_id,
			row_number() OVER(PARTITION BY ne.fk_wastewater_structure
							  ORDER BY
							  (rp.fk_wastewater_networkelement=ws_nd.fk_main_wastewater_node)::int*-1,-- prioritise main wastewater node, invert due to asc order
							  fh.tww_symbology_order,
							  uc.tww_symbology_order,
							  ST_Azimuth(rp.situation3d_geometry,ST_PointN(ST_CurveToLine(re_from.progression3d_geometry),2)) ASC) AS idx,
		  ST_Azimuth(rp.situation3d_geometry,ST_PointN(re_from.progression3d_geometry,2)) AS azimuth,
		  count (*) OVER(PARTITION BY ne.fk_wastewater_structure ) as max_idx
		  FROM tww_od.reach_point rp
		  INNER JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
		  INNER JOIN (SELECT ws.obj_id, fk_main_wastewater_node FROM tww_od.wastewater_structure ws
		  WHERE NOT EXISTS(SELECT 1 from tww_od.channel ch WHERE ws.obj_id = ch.obj_id LIMIT 1)
					 ) ws_nd ON ne.fk_wastewater_structure = ws_nd.obj_id
		  -- network element from
		  INNER JOIN tww_od.reach re_from ON rp.obj_id = re_from.fk_reach_point_from
		  INNER JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id::text = re_from.obj_id::text
		  INNER JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure::text = ws.obj_id::text
		  INNER JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
		  INNER JOIN tww_vl.channel_function_hierarchic fh ON ch.function_hierarchic  = fh.code
		  INNER JOIN tww_vl.channel_usage_current uc ON ch.usage_current = uc.code
		  INNER JOIN tww_vl.wastewater_structure_status st ON ws.status = st.code
			WHERE fh.tww_use_in_labels
			AND st.tww_use_in_labels
;
