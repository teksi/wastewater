-- Creates subarea related to the subcatchment
CREATE OR REPLACE VIEW qgep_swmm.vw_subareas AS
SELECT
  concat(replace(ca.obj_id, ' ', '_'), '_', state) as Subcatchment,
  0.01 as NImperv, -- default value, Manning's n for overland flow over the impervious portion of the subcatchment 
  0.1 as NPerv,-- default value, Manning's n for overland flow over the pervious portion of the subcatchment
  CASE
	WHEN surface_storage IS NOT NULL THEN surface_storage	
	ELSE 0.05 -- default value
  END as SImperv,-- Depth of depression storage on the impervious portion of the subcatchment (inches or millimeters)
    CASE
	WHEN surface_storage IS NOT NULL THEN surface_storage	
	ELSE 0.05 -- default value
  END as SPerv,-- Depth of depression storage on the pervious portion of the subcatchment (inches or millimeters)
  25 as PctZero,-- default value, Percent of the impervious area with no depression storage.
  'OUTLET'::varchar as RouteTo,
  NULL::float as PctRouted,
  ca.identifier as description,
  ca.obj_id::varchar as tag,
  state as state,
  CASE 
		WHEN _function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
  wn_obj_id as obj_id
FROM 
(
SELECT ca.*, sr.surface_storage, 'rw_current' as state, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.surface_runoff_parameters sr ON ca.obj_id = sr.fk_catchment_area
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_current
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_rw_current IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*, sr.surface_storage, 'ww_current' as state, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.surface_runoff_parameters sr ON ca.obj_id = sr.fk_catchment_area
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_ww_current
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_ww_current IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*, sr.surface_storage, 'rw_planned' as state, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.surface_runoff_parameters sr ON ca.obj_id = sr.fk_catchment_area
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_planned
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_rw_planned IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*, sr.surface_storage, 'ww_planned' as state, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.surface_runoff_parameters sr ON ca.obj_id = sr.fk_catchment_area
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_ww_planned
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_ww_planned IS NOT NULL -- to avoid unconnected catchments
) as ca;
