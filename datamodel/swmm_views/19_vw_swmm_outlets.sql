CREATE OR REPLACE VIEW qgep_swmm.vw_outlets AS

SELECT
	concat('outlet@',pw.obj_id) as Name,
	of.fk_wastewater_node as FromNode, -- inlet is the waternode entering the pump
	of.fk_overflow_to as ToNode, -- outlet is the waternode at the top of next reach
	0 as Offset,
	'TABULAR/DEPTH' as type,
    concat('prank_weir_curve@',pw.obj_id) as QTable_Qcoeff,
	NULL as Qexpon,
    'NO' as Gated,
	CASE 
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM qgep_od.prank_weir pw
LEFT JOIN qgep_od.overflow of ON pw.obj_id = of.obj_id
LEFT JOIN qgep_od.overflow_char oc ON of.fk_overflow_characteristic = oc.obj_id
LEFT JOIN qgep_vl.overflow_char_overflow_characteristic_digital vL_oc_dig ON oc.overflow_characteristic_digital = vL_oc_dig.code
LEFT JOIN qgep_vl.overflow_char_kind_overflow_characteristic vl_oc_ki ON oc.kind_overflow_characteristic = vl_oc_ki.code
LEFT JOIN qgep_od.wastewater_node wn ON wn.obj_id = of.fk_wastewater_node
LEFT JOIN qgep_od.wastewater_structure ws ON ws.fk_main_wastewater_node = wn.obj_id
LEFT JOIN qgep_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN qgep_vl.channel_function_hierarchic cfhi ON cfhi.code=ws._function_hierarchic
WHERE ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959)
AND vL_oc_dig.vsacode = 6223  --'yes;
AND vl_oc_ki.vsacode = 6220; -- h/q relations (Q/Q relations are not supported by SWMM) 
