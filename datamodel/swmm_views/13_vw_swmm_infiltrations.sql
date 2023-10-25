-- Creates default infiltration for each subcatchment
CREATE OR REPLACE VIEW qgep_swmm.vw_infiltration AS
SELECT
  CASE 
    WHEN state = 'current' THEN concat(replace(ca.obj_id, ' ', '_'), '_', 'rw_current')
    WHEN state = 'planned' THEN concat(replace(ca.obj_id, ' ', '_'), '_', 'rw_planned')
  END as Subcatchment,
  3 as MaxRate,
  0.5 as MinRate,
  4 as Decay,
  7 as DryTime,
  0 as MaxInfil,
  state,
  CASE 
		WHEN _function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
  wn_obj_id as obj_id
FROM 
(
SELECT ca.*,'current' as state, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_current
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_rw_current IS NOT NULL -- to avoid unconnected catchments
UNION ALL
SELECT ca.*,'planned' as state, wn.obj_id as wn_obj_id, ws._function_hierarchic
FROM qgep_od.catchment_area as ca
LEFT JOIN qgep_od.wastewater_networkelement ne on ne.obj_id = fk_wastewater_networkelement_rw_planned
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE fk_wastewater_networkelement_rw_planned IS NOT NULL -- to avoid unconnected catchments
) as ca;
