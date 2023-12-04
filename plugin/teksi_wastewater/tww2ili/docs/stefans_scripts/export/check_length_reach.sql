SELECT
ST_AsText(progression_geometry) as koordinaten,
            st_length(progression_geometry) AS length_full, obj_id
			FROM tww_od.reach ORDER BY length_full ASC;
