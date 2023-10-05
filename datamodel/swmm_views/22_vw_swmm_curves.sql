--------
-- View for the swmm module class curves
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_curves AS

-- Pump curves
(SELECT
	concat('pump_curve@',pu.obj_id)::varchar as Name,
	CASE 
		WHEN ROW_NUMBER () OVER (PARTITION BY pu.obj_id ORDER BY pu.obj_id, hq.altitude) = 1
		THEN 'Pump4'
		ELSE NULL
	END as type,
	hq.altitude as XValue,
	hq.flow as YValue,
	CASE 
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM qgep_od.hq_relation hq
LEFT JOIN qgep_od.overflow_char oc ON hq.fk_overflow_characteristic = oc.obj_id
LEFT JOIN qgep_vl.overflow_char_overflow_characteristic_digital vl_oc_dig ON oc.overflow_characteristic_digital = vl_oc_dig.code
LEFT JOIN qgep_vl.overflow_char_kind_overflow_characteristic vl_oc_ki ON oc.kind_overflow_characteristic = vl_oc_ki.code
LEFT JOIN qgep_od.overflow of ON of.fk_overflow_characteristic = oc.obj_id
LEFT JOIN qgep_od.pump pu ON pu.obj_id = of.obj_id
LEFT JOIN qgep_od.wastewater_node wn ON wn.obj_id = of.fk_wastewater_node
LEFT JOIN qgep_od.wastewater_structure ws ON ws.fk_main_wastewater_node = wn.obj_id
LEFT JOIN qgep_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN qgep_vl.channel_function_hierarchic cfhi ON cfhi.code=ws._function_hierarchic
WHERE ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959)
AND vl_oc_dig.vsacode = 6223  --'yes;
AND vl_oc_ki.vsacode = 6220 -- h/q relations (Q/Q relations are not supported by SWMM) 
AND pu.obj_id IS NOT NULL
ORDER BY pu.obj_id, hq.altitude)

UNION ALL

-- Prank weir curves
(SELECT
	concat('prank_weir_curve@',pw.obj_id)::varchar as Name,
	CASE 
		WHEN ROW_NUMBER () OVER (PARTITION BY pw.obj_id ORDER BY pw.obj_id, hq.altitude) = 1
		THEN 'Rating'
		ELSE NULL
	END as type,
	hq.altitude as XValue,
	hq.flow as YValue,
	CASE 
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM qgep_od.hq_relation hq
LEFT JOIN qgep_od.overflow_char oc ON hq.fk_overflow_characteristic = oc.obj_id
LEFT JOIN qgep_vl.overflow_char_overflow_characteristic_digital vl_oc_dig ON oc.overflow_characteristic_digital = vl_oc_dig.code
LEFT JOIN qgep_vl.overflow_char_kind_overflow_characteristic vl_oc_ki ON oc.kind_overflow_characteristic = vl_oc_ki.code
LEFT JOIN qgep_od.overflow of ON of.fk_overflow_characteristic = oc.obj_id
LEFT JOIN qgep_od.prank_weir pw ON pw.obj_id = of.obj_id
LEFT JOIN qgep_od.wastewater_node wn ON wn.obj_id = of.fk_wastewater_node
LEFT JOIN qgep_od.wastewater_structure ws ON ws.fk_main_wastewater_node = wn.obj_id
LEFT JOIN qgep_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN qgep_vl.channel_function_hierarchic cfhi ON cfhi.code=ws._function_hierarchic
WHERE ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959)
AND vl_oc_dig.vsacode = 6223  --'yes;
AND vl_oc_ki.vsacode = 6220 -- h/q relations (Q/Q relations are not supported by SWMM) 
AND pw.obj_id IS NOT NULL
ORDER BY pw.obj_id, hq.altitude)

UNION ALL

-- storage curves
(SELECT
	concat('storageCurve@',wn.obj_id)::varchar as Name,
	CASE 
		WHEN ROW_NUMBER () OVER (PARTITION BY wn.obj_id ORDER BY wn.obj_id, hr.water_depth) = 1
		THEN 'Storage'
		ELSE NULL
	END as type,
	hr.water_depth as XValue,
	hr.water_surface as YValue,
	CASE 
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM qgep_od.hydr_geom_relation hr
LEFT JOIN qgep_od.hydr_geometry hg on hg.obj_id = hr.fk_hydr_geometry
LEFT JOIN qgep_od.wastewater_node wn on hg.obj_id = wn.fk_hydr_geometry
LEFT JOIN qgep_od.wastewater_structure ws ON ws.fk_main_wastewater_node = wn.obj_id
LEFT JOIN qgep_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN qgep_vl.channel_function_hierarchic cfhi ON cfhi.code=ws._function_hierarchic
ORDER BY wn.obj_id, hr.water_depth)
