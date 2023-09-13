--------
-- View for the swmm module class junction
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_junctions AS

-- manholes
SELECT
	wn.obj_id as Name,
	coalesce(wn.bottom_level,0) as InvertElev,
	(co.level-wn.bottom_level) as MaxDepth,
	NULL::float as InitDepth,
	NULL::float as SurchargeDepth,
	NULL::float as PondedArea,
	ws.identifier::text as description,
	CONCAT_WS(',', 'manhole', mf.value_en) as tag,
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
FROM qgep_od.manhole ma
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id::text = ma.obj_id::text
LEFT JOIN qgep_od.wastewater_networkelement we ON we.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = we.obj_id
LEFT JOIN qgep_od.cover co on ws.fk_main_cover = co.obj_id
LEFT JOIN qgep_vl.manhole_function mf on ma.function = mf.code
WHERE wn.obj_id IS NOT NULL
AND status IN (6530, 6533, 8493, 6529, 6526, 7959)

UNION

-- special structures
SELECT
	wn.obj_id as Name,
	coalesce(wn.bottom_level,0) as InvertElev,
	(co.level-wn.bottom_level) as MaxDepth,
	NULL::float as InitDepth,
	NULL::float as SurchargeDepth,
	NULL::float as PondedArea,
	ws.identifier::text as description,
	CONCAT_WS(',','special_structure', ssf.value_en) as tag,
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
FROM qgep_od.special_structure ss
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id::text = ss.obj_id::text
LEFT JOIN qgep_od.wastewater_networkelement we ON we.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = we.obj_id
LEFT JOIN qgep_od.cover co on ws.fk_main_cover = co.obj_id
LEFT JOIN qgep_vl.special_structure_function ssf on ss.function = ssf.code
WHERE wn.obj_id IS NOT NULL
AND status IN (6530, 6533, 8493, 6529, 6526, 7959)
AND function NOT IN ( -- must be the same list in vw_swmm_storages
6397, --"pit_without_drain"
-- 245, --"drop_structure"
6398, --"hydrolizing_tank"
-- 5371, --"other"
-- 386, --"venting"
-- 3234, --"inverse_syphon_chamber"
-- 5091, --"syphon_head"
-- 6399, --"septic_tank_two_chambers"
3348, --"terrain_depression"
336, --"bolders_bedload_catchement_dam"
-- 5494, --"cesspit"
6478, --"septic_tank"
-- 2998, --"manhole"
-- 2768, --"oil_separator"
-- 246, --"pump_station"
3673, --"stormwater_tank_with_overflow"
3674, --"stormwater_tank_retaining_first_flush"
5574, --"stormwater_retaining_channel"
3675, --"stormwater_sedimentation_tank"
3676, --"stormwater_retention_tank"
5575, --"stormwater_retention_channel"
5576, --"stormwater_storage_channel"
3677 --"stormwater_composite_tank"
-- 5372 -- "stormwater_overflow"
-- 5373, --"floating_material_separator"
-- 383	, --"side_access"
-- 227, --"jetting_manhole"
-- 4799, --"separating_structure"
-- 3008, --"unknown"
-- 2745, --"vortex_manhole"
)

UNION

-- wastewater_node not linked to wastewater structures
SELECT
	coalesce(from_wn.obj_id, concat('from_node@',re.obj_id)) as Name,
	coalesce(from_wn.bottom_level, 0) as InvertElev,
	0 as MaxDepth,
	NULL::float as InitDepth,
	NULL::float as SurchargeDepth,
	NULL::float as PondedArea,
	coalesce(from_wn.obj_id, concat('from_node@',re.obj_id)) as description,
	'junction without structure' as tag,
	coalesce(from_wn.situation_geometry,  ST_StartPoint(re.progression_geometry)) as geom,
	CASE 
		WHEN ws.status IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN ch.function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	coalesce(from_wn.obj_id, re.obj_id)  as obj_id
FROM qgep_od.reach as re
LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.obj_id::text = re.obj_id::text
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN qgep_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
LEFT JOIN qgep_od.wastewater_node from_wn on from_wn.obj_id = rp_from.fk_wastewater_networkelement
LEFT JOIN qgep_od.channel ch on ch.obj_id::text = ws.obj_id::text
-- Get wastewater structure linked to the from node
LEFT JOIN qgep_od.wastewater_networkelement we ON from_wn.obj_id = we.obj_id
LEFT JOIN qgep_od.wastewater_structure ws_node ON we.fk_wastewater_structure::text = ws_node.obj_id::text
-- select only operationals and "planned"
WHERE ws.status IN (6530, 6533, 8493, 6529, 6526, 7959)
and ws_node is null

UNION

SELECT
	coalesce(to_wn.obj_id, concat('to_node@',re.obj_id)) as Name,
	coalesce(to_wn.bottom_level, 0) as InvertElev,
	0 as MaxDepth,
	NULL::float as InitDepth,
	NULL::float as SurchargeDepth,
	NULL::float as PondedArea,
	coalesce(to_wn.obj_id, concat('to_node@',re.obj_id)) as description,
	'junction without structure' as tag,
	coalesce(to_wn.situation_geometry,  ST_EndPoint(re.progression_geometry)) as geom,
	CASE 
		WHEN ws.status IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN ch.function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	coalesce(to_wn.obj_id, re.obj_id) as obj_id
FROM qgep_od.reach as re
LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.obj_id::text = re.obj_id::text
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
LEFT JOIN qgep_od.reach_point rp_to ON rp_to.obj_id::text = re.fk_reach_point_to::text
LEFT JOIN qgep_od.wastewater_node to_wn on to_wn.obj_id = rp_to.fk_wastewater_networkelement
LEFT JOIN qgep_od.channel ch on ch.obj_id::text = ws.obj_id::text
-- Get wastewater structure linked to the to node
LEFT JOIN qgep_od.wastewater_networkelement we ON to_wn.obj_id = we.obj_id
LEFT JOIN qgep_od.wastewater_structure ws_node ON we.fk_wastewater_structure::text = ws_node.obj_id::text
-- select only operationals and "planned"
WHERE ws.status IN (6530, 6533, 8493, 6529, 6526, 7959)
and ws_node is null;
