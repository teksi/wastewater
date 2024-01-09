
--------
-- View for the swmm module class subcatchments
--------

CREATE OR REPLACE VIEW tww_app.swmm_vw_subcatchments AS
SELECT
  concat(replace(ca.obj_id, ' ', '_'), '_', state) as Name,
  concat('raingage@', replace(ca.obj_id, ' ', '_'))::varchar as RainGage,
  CASE
    WHEN state = 'rw_current' then fk_wastewater_networkelement_rw_current
    WHEN state = 'rw_planned'  then fk_wastewater_networkelement_rw_planned
    WHEN state = 'ww_current' then fk_wastewater_networkelement_ww_current
    WHEN state = 'ww_planned'  then fk_wastewater_networkelement_ww_planned
    ELSE replace(ca.obj_id, ' ', '_')
  END as Outlet,
  CASE
            WHEN ca.surface_area IS NULL THEN st_area(ca.perimeter_geometry)/10000
            WHEN ca.surface_area < 0.01 THEN st_area(ca.perimeter_geometry)/10000
            ELSE (ca.surface_area::numeric)::double precision
  END AS Area,
  CASE
    WHEN state = 'rw_current' then discharge_coefficient_rw_current
    WHEN state = 'rw_planned'  then discharge_coefficient_rw_planned
    WHEN state = 'ww_current' then discharge_coefficient_ww_current
    WHEN state = 'ww_planned'  then discharge_coefficient_ww_planned
    ELSE 0
  END as percImperv, -- take from catchment_area instead of default value
  CASE
    WHEN wn_geom IS NOT NULL
    THEN
    (
    st_maxdistance(wn_geom, ST_ExteriorRing(perimeter_geometry))
    + st_distance(wn_geom, ST_ExteriorRing(perimeter_geometry))
    )/2
    ELSE
    (
    st_maxdistance(st_centroid(perimeter_geometry), ST_ExteriorRing(perimeter_geometry))
    + st_distance(st_centroid(perimeter_geometry), ST_ExteriorRing(perimeter_geometry))
    )/2
  END as Width, -- Width of overland flow path estimation
  0.5 as percSlope, -- default value
  0 as CurbLen, -- default value
  NULL::varchar as SnowPack, -- default value
  CASE
		WHEN fk_wastewater_networkelement_ww_current is not null
		THEN
			CASE
				WHEN waste_water_production_current IS NOT NULL THEN concat('catchment_area: ', ca.obj_id,': DWF baseline is computed from waste_water_production_current')
				ELSE
					CASE
						WHEN (surface_area IS NOT NULL AND surface_area != 0) THEN concat('catchment_area: ', ca.obj_id,': DWF baseline is computed from surface_area, population_density_current and a default production of 160 Litre / inhabitant /day')
						ELSE concat('catchment_area: ', ca.obj_id,': DWF baseline is computed from the geometric area, population_density_current and a default production of 160 Litre / inhabitant /day')
					END
			END
		WHEN fk_wastewater_networkelement_ww_planned is not null
		THEN
			CASE
				WHEN waste_water_production_planned IS NOT NULL THEN concat('catchment_area: ', ca.obj_id,': DWF baseline is computed from waste_water_production_planned')
				ELSE
					CASE
						WHEN (surface_area IS NOT NULL AND surface_area != 0) THEN concat('catchment_area: ', ca.obj_id,': DWF baseline is computed from surface_area, population_density_planned and a default production of 160 Litre / inhabitant /day')
						ELSE concat('catchment_area: ', ca.obj_id,': DWF baseline is computed from the geometric area, population_density_planned and a default production of 160 Litre / inhabitant /day')
					END
			END
		WHEN fk_wastewater_networkelement_rw_current is not null
		THEN NULL
		WHEN fk_wastewater_networkelement_rw_planned is not null
		THEN NULL
	END as description,
  ca.obj_id as tag,
  ST_CurveToLine(perimeter_geometry)::geometry(Polygon, %(SRID)s) as geom,
  CASE
    WHEN state = 'rw_current' OR state = 'ww_current' THEN 'current'
    WHEN state = 'rw_planned' OR state = 'ww_planned' THEN 'planned'
    ELSE 'planned'
  END as state,
  CASE
		WHEN _function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn_obj_id as obj_id
FROM (
  SELECT ca.*, wn.situation3d_geometry as wn_geom, 'rw_current' as state, wn.obj_id as wn_obj_id, wn._function_hierarchic
  FROM tww_od.catchment_area as ca
  INNER JOIN tww_od.wastewater_networkelement ne on ne.obj_id = ca.fk_wastewater_networkelement_rw_current
  LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
  UNION ALL
  SELECT ca.*, wn.situation3d_geometry as wn_geom, 'rw_planned' as state, wn.obj_id as wn_obj_id, wn._function_hierarchic
  FROM tww_od.catchment_area as ca
  INNER JOIN tww_od.wastewater_networkelement ne on ne.obj_id = ca.fk_wastewater_networkelement_rw_planned
  LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
  UNION ALL
  SELECT ca.*, wn.situation3d_geometry as wn_geom, 'ww_current' as state, wn.obj_id as wn_obj_id, wn._function_hierarchic
  FROM tww_od.catchment_area as ca
  INNER JOIN tww_od.wastewater_networkelement ne on ne.obj_id = ca.fk_wastewater_networkelement_ww_current
  LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
  UNION ALL
  SELECT ca.*, wn.situation3d_geometry as wn_geom,'ww_planned' as state, wn.obj_id as wn_obj_id, wn._function_hierarchic
  FROM tww_od.catchment_area as ca
  INNER JOIN tww_od.wastewater_networkelement ne on ne.obj_id = ca.fk_wastewater_networkelement_ww_planned
  LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
) as ca;
