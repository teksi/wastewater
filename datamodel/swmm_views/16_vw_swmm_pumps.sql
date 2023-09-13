--------
-- View for the swmm module class pumps
-- A pump in qgep is a node but a link in SWMM
-- -> The pump is attached to the reach which goes out from the pump
-- -> inlet node is the water node where the QGEP pump is located
-- -> outlet node is the water node at the end of the reach going out of the pump
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_pumps AS

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
		WHEN  oc.overflow_characteristic_digital != 6223  --'yes;
		THEN 'No curve will be created for this pump, overflow_characteristic_digital not equal to yes'
		WHEN  oc.kind_overflow_characteristic != 6220 --'hq;
		THEN concat(pu.obj_id, 'No curve will be created for this pump, kind_overflow_characteristic is not equal to H/Q, Q/Q relations are not supported by SWMM')
		ELSE NULL
		END
	) as description,
	pu.obj_id::varchar as tag,
	CASE 
		WHEN status IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
	CASE 
		WHEN ws._function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	wn.obj_id as obj_id
FROM qgep_od.pump pu
LEFT JOIN qgep_od.overflow of ON pu.obj_id = of.obj_id
LEFT JOIN qgep_od.overflow_char oc ON of.fk_overflow_characteristic = oc.obj_id
LEFT JOIN qgep_od.wastewater_node wn ON wn.obj_id = of.fk_wastewater_node
LEFT JOIN qgep_od.wastewater_structure ws ON ws.fk_main_wastewater_node = wn.obj_id
WHERE status IN (6530, 6533, 8493, 6529, 6526, 7959);
