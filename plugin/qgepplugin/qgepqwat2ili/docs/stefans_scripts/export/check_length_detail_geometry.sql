SELECT,
ST_AsText(detail_geometry_geometry) as koordinatendetailgeometrie,
            st_length(detail_geometry_geometry) AS length_full, obj_id
			FROM qgep_od.wastewater_structure ORDER BY length_full ASC;
