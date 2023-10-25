--------
-- View for the swmm module class dividers
-- Question attribute Diverted Link: Name of link which receives the diverted flow. overflow > fk_overflow_to
CREATE OR REPLACE VIEW qgep_swmm.vw_dividers AS

SELECT
	ma.obj_id as Name,
	coalesce(wn.bottom_level,0)  as Elevation,
	'???' as diverted_link,
	'CUTOFF' as Type,
	0 as CutoffFlow,
	0 as MaxDepth,
	0 as InitialDepth,
	0 as SurchargeDepth,
	0 as PondedArea,
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
LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.cover co on ws.fk_main_cover = co.obj_id
LEFT JOIN qgep_vl.manhole_function mf on ma.function = mf.code
WHERE function = 4798 -- separating_structure
AND status IN (6530, 6533, 8493, 6529, 6526, 7959)

UNION ALL

SELECT
	ss.obj_id as Name,
	coalesce(wn.bottom_level,0) as Elevation,
	'???' as diverted_link,
	'CUTOFF' as Type,
	0 as CutoffFlow,
	0 as MaxDepth,
	0 as InitialDepth,
	0 as SurchargeDepth,
	0 as PondedArea,
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
LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN qgep_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN qgep_od.cover co on ws.fk_main_cover = co.obj_id
LEFT JOIN qgep_vl.special_structure_function ssf on ss.function = ssf.code
WHERE function  = 4799 -- separating_structure
AND status IN (6530, 6533, 8493, 6529, 6526, 7959);
