-- Creates Dry Weather Flow related to the catchment area
CREATE OR REPLACE VIEW qgep_swmm.vw_dwf AS
SELECT
	CASE 
		WHEN type_ca = 'rw_current' THEN fk_wastewater_networkelement_rw_current
		WHEN type_ca = 'rw_planned' THEN fk_wastewater_networkelement_rw_planned
		WHEN type_ca = 'ww_current' THEN fk_wastewater_networkelement_ww_current
		WHEN type_ca = 'ww_planned' THEN fk_wastewater_networkelement_ww_planned
	END as Node, -- id of the junction
	'FLOW'::varchar as Constituent,
	CASE
		WHEN fk_wastewater_networkelement_ww_current is not null
		THEN 
			CASE 
				WHEN waste_water_production_current IS NOT NULL THEN waste_water_production_current 
				ELSE
					CASE 
						WHEN (surface_area IS NOT NULL AND surface_area != 0) THEN coalesce(population_density_current,0) * surface_area * 160 / (24 * 60 * 60)
						ELSE coalesce(population_density_current,0) * ST_Area(perimeter_geometry) / 10000 * 160 / (24 * 60 * 60)
					END
			END
		WHEN fk_wastewater_networkelement_ww_planned is not null
		THEN 
			CASE 
				WHEN waste_water_production_planned IS NOT NULL THEN waste_water_production_planned
				ELSE
					CASE 
						WHEN (surface_area IS NOT NULL AND surface_area != 0) THEN coalesce(population_density_planned,0) * surface_area * 160 / (24 * 60 * 60)
						ELSE coalesce(population_density_planned,0) * ST_Area(perimeter_geometry) / 10000 * 160 / (24 * 60 * 60)
					END
			END
		WHEN fk_wastewater_networkelement_rw_current is not null
		THEN 0
		WHEN fk_wastewater_networkelement_rw_planned is not null
		THEN 0
	END as Baseline, -- 160 Litre / inhabitant /day
	'dailyPatternDWF'::varchar as Patterns,
	state as state,
  CASE 
		WHEN _function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
  wn_obj_id as obj_id
FROM 
(
SELECT ca.*,'current' as state, 'rw_current' as type_ca, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_current
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_rw_current IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*,'planned' as state, 'rw_planned' as type_ca, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_planned
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_rw_planned IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*,'current' as state, 'ww_current' as type_ca, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_ww_current
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_ww_current IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*,'planned' as state, 'ww_planned' as type_ca, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_ww_planned
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_ww_planned IS NOT NULL -- to avoid unconnected catchments
) as ca;
