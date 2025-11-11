--------
-- View for the swmm module class outfalls
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_outfalls AS

SELECT
  wn.obj_id as Name,
  coalesce(wn.bottom_level,0) as InvertElev,
  CASE 
    WHEN waterlevel_hydraulic NOT IS NULL THEN 'FIXED'
    ELSE 'FREE'
  END as Type, -- Type of outfall boundary condition: FREE: outfall stage determined by minimum of critical flow depth and normal flow depth in the connecting conduit. NORMAL: outfall stage based on normal flow depth in the connecting conduit. FIXED: outfall stage set to a fixed value. TIDAL: outfall stage given by a table of tide elevation versus time of day. TIMESERIES: outfall stage supplied from a time series of elevations
  CASE 
    WHEN waterlevel_hydraulic NOT IS NULL THEN waterlevel_hydraulic
    ELSE 0
  END as StageData,
  'NO'::varchar as tide_gate,
  '0'::varchar as RouteTo,
  ws.identifier as description,
  dp.obj_id::varchar as tag,
  wn.situation3d_geometry as geom,
	CASE
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
  CASE
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM tww_od.discharge_point as dp
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id::text = dp.obj_id::text
LEFT JOIN tww_od.wastewater_networkelement we ON we.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = we.obj_id
LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE wn.obj_id IS NOT NULL
AND ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959)

UNION

SELECT
  wn.obj_id as Name,
  coalesce(wn.bottom_level,0) as InvertElev,
  CASE 
    WHEN waterlevel_hydraulic IS NOT NULL THEN 'FIXED'
    ELSE 'FREE'
  END as Type, -- Type of outfall boundary condition: FREE: outfall stage determined by minimum of critical flow depth and normal flow depth in the connecting conduit. NORMAL: outfall stage based on normal flow depth in the connecting conduit. FIXED: outfall stage set to a fixed value. TIDAL: outfall stage given by a table of tide elevation versus time of day. TIMESERIES: outfall stage supplied from a time series of elevations
  CASE 
    WHEN waterlevel_hydraulic IS NOT NULL THEN waterlevel_hydraulic
    ELSE 0
  END as StageData,
  'NO'::varchar as tide_gate,
  '0'::varchar as RouteTo,
  ws.identifier as description,
  ii.obj_id::varchar as tag,
  wn.situation3d_geometry as geom,
	CASE
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
  CASE
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM tww_od.infiltration_installation as ii
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id::text = ii.obj_id::text
LEFT JOIN tww_od.wastewater_networkelement we ON we.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = we.obj_id
LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE wn.obj_id IS NOT NULL
AND ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959)
;
