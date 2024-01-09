--------
-- View for the swmm module class pumps
-- A pump in tww is a node but a link in SWMM
-- -> The pump is attached to the reach which goes out from the pump
-- -> inlet node is the water node where the TWW pump is located
-- -> outlet node is the water node at the end of the reach going out of the pump
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_pumps AS

SELECT
	pu.obj_id as Name,
	of.fk_wastewater_node as FromNode, -- inlet is the waternode entering the pump
	of.fk_overflow_to as ToNode, -- outlet is the waternode at the top of next reach
	concat('pump_curve@',pu.obj_id)::varchar as PumpCurve,
	'ON'::varchar as Status,
	pu.start_level as StartupDepth,
	pu.stop_level as ShutoffDepth,
	concat_ws(';',
		of.identifier,
		CASE
  		WHEN  oc.obj_id IS NULL  --'yes;
		THEN 'No curve will be created for this pump, it has no overflow_characteristic'
		-- Attribute overflow_characteristics_digital does not exist anymore in VSA-DSS 2020
		--WHEN  vl_oc_dig.vsacode != 6223  --'yes;
		--THEN 'No curve will be created for this pump, overflow_characteristic_digital not equal to yes'
		WHEN  vl_oc_ki.vsacode != 6220 --'hq;
		THEN concat(pu.obj_id, 'No curve will be created for this pump, kind_overflow_char is not equal to H/Q, Q/Q relations are not supported by SWMM')
		ELSE NULL
		END
	) as description,
	pu.obj_id::varchar as tag,
	CASE
		WHEN ws_st.vsacode IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE
		WHEN cfhi.vsacode in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM tww_od.pump pu
LEFT JOIN tww_od.overflow of ON pu.obj_id = of.obj_id
LEFT JOIN tww_od.overflow_char oc ON of.fk_overflow_char = oc.obj_id
-- LEFT JOIN tww_vl.overflow_char_overflow_characteristic_digital vl_oc_dig ON oc.overflow_characteristic_digital = vl_oc_dig.code
LEFT JOIN tww_vl.overflow_char_kind_overflow_char vl_oc_ki ON oc.kind_overflow_char = vl_oc_ki.code
LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = of.fk_wastewater_node
LEFT JOIN tww_od.wastewater_structure ws ON ws.fk_main_wastewater_node = wn.obj_id
LEFT JOIN tww_vl.wastewater_structure_status ws_st ON ws.status = ws_st.code
LEFT JOIN tww_vl.channel_function_hierarchic cfhi ON cfhi.code=wn._function_hierarchic
WHERE ws_st.vsacode IN (6530, 6533, 8493, 6529, 6526, 7959);
