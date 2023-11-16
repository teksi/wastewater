--------
-- View for the swmm module class dividers
-- Question attribute Diverted Link: Name of link which receives the diverted flow. overflow > fk_overflow_to
CREATE OR REPLACE VIEW tww_app.swmm_vw_dividers AS

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
FROM tww_od.manhole ma
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id::text = ma.obj_id::text
LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=ws._function_hierarchic
LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN tww_od.cover co on ws.fk_main_cover = co.obj_id
LEFT JOIN tww_vl.manhole_function mf on ma.function = mf.code
WHERE mf.vsacode = 4798 -- separating_structure
AND ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959)

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
FROM tww_od.special_structure ss
LEFT JOIN tww_od.wastewater_structure ws ON ws.obj_id::text = ss.obj_id::text
LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=ws._function_hierarchic
LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure::text = ws.obj_id::text
LEFT JOIN tww_od.wastewater_node wn on wn.obj_id = ne.obj_id
LEFT JOIN tww_od.cover co on ws.fk_main_cover = co.obj_id
LEFT JOIN tww_vl.special_structure_function ssf on ss.function = ssf.code
WHERE ssf.vsacode  = 4799 -- separating_structure
AND ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959);
