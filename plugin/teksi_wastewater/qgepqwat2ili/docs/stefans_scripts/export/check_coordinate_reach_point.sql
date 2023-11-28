SELECT
ST_AsText(situation_geometry) as hpkoordinaten, obj_id
			FROM qgep_od.reach_point ORDER BY hpkoordinaten ASC;
