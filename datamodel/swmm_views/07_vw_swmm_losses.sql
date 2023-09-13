--------
-- View for the swmm module class losses
-- 20190329 qgep code sprint SB, TP
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_losses AS

SELECT DISTINCT
  re.obj_id as Link,
  0::float as Kentry,
  0::float as Kexit,
  0::float as Kavg,
  CASE
    WHEN ts.obj_id IS NOT NULL THEN 'YES'
    ELSE 'NO'
  END as flap_gate,
  0::float as Seepage,
	CASE 
		WHEN status IN (7959, 6529, 6526) THEN 'planned'
		ELSE 'current'
	END as state,
  CASE 
		WHEN ws._function_hierarchic in (5062, 5064, 5066, 5068, 5069, 5070, 5071, 5072, 5074) THEN 'primary'
		ELSE 'secondary'
	END as hierarchy,
	re.obj_id as obj_id
FROM qgep_od.reach re
LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.obj_id::text = re.obj_id::text
LEFT JOIN qgep_od.pipe_profile pp on pp.obj_id = re.fk_pipe_profile
LEFT JOIN qgep_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
LEFT JOIN qgep_od.wastewater_node from_wn on from_wn.obj_id = rp_from.fk_wastewater_networkelement
LEFT JOIN qgep_od.throttle_shut_off_unit ts ON ts.fk_wastewater_node = from_wn.obj_id
LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
WHERE status IN (6530, 6533, 8493, 6529, 6526, 7959)
;  -- wastewater node of the downstream wastewater node
