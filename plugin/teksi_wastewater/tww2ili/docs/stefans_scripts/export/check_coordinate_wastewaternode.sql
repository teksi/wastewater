SELECT
ST_AsText(situation_geometry) as abwasserknotenkoordinaten, obj_id
			FROM tww_od.wastewater_node ORDER BY abwasserknotenkoordinaten ASC;
