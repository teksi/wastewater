--------
-- View for the swmm module class outfalls
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_outfalls AS

SELECT
  wn.obj_id as Name,
  coalesce(wn.bottom_level,0) as InvertElev,
  'FREE'::varchar as Type,
  NULL as StageData,
  'NO'::varchar as tide_gate,
  NULL::varchar as RouteTo,
  ws.identifier as description,
  dp.obj_id::varchar as tag,
  wn.situation_geometry as geom,
	CASE 
		WHEN status IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
  CASE 
		WHEN ws._function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM qgep_od.discharge_point as dp
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id::text = dp.obj_id::text
LEFT JOIN qgep_od.wastewater_networkelement we ON we.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = we.obj_id
WHERE wn.obj_id IS NOT NULL
AND status IN (6530, 6533, 8493, 6529, 6526, 7959)
;
