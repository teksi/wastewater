
CREATE OR REPLACE VIEW qgep_swmm.node_results AS
SELECT ws.obj_id AS ws_obj_id, ma.function AS ma_function, ss.function AS ss_function,
mp.obj_id AS mp_obj_id, mp.remark AS swmm_simulation_name,
md.obj_id AS md_obj_id,
ms.obj_id AS ms_obj_id, ms.dimension, ms.remark AS swmm_parameter,
mr.obj_id AS mr_obj_id, mr.measuring_duration, mr.time, mr.value,
wn.situation_geometry AS geom
FROM qgep_od.wastewater_structure ws
JOIN qgep_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
LEFT JOIN qgep_od.manhole ma ON ma.obj_id = ws.obj_id
LEFT JOIN qgep_od.special_structure ss ON ss.obj_id = ws.obj_id
LEFT JOIN  qgep_od.measuring_point mp  ON mp.fk_wastewater_structure = ws.obj_id
LEFT JOIN qgep_od.measuring_device md ON md.fk_measuring_point = mp.obj_id
LEFT JOIN qgep_od.measurement_series ms ON ms.fk_measuring_point = mp.obj_id
LEFT JOIN qgep_od.measurement_result mr ON mr.fk_measurement_series = ms.obj_id
WHERE md.remark = 'SWMM Simulation'
ORDER BY mp.obj_id, mr.time;

CREATE OR REPLACE VIEW qgep_swmm.link_results AS
SELECT ne.fk_wastewater_structure AS ws_obj_id, re.obj_id AS re_obj_id,
re.clear_height, re.material,
mp.obj_id AS mp_obj_id, mp.remark AS swmm_simulation_name,
md.obj_id AS md_obj_id,
ms.obj_id AS ms_obj_id, ms.dimension, ms.remark AS swmm_parameter,
mr.obj_id AS mr_obj_id, mr.measuring_duration, mr.time, mr.value,
re.progression_geometry AS geom
FROM qgep_od.reach re
JOIN qgep_od.wastewater_networkelement ne ON re.obj_id= ne.obj_id
LEFT JOIN qgep_od.measuring_point mp ON  mp.fk_wastewater_structure = ne.fk_wastewater_structure
LEFT JOIN qgep_od.measuring_device md ON md.fk_measuring_point = mp.obj_id
LEFT JOIN qgep_od.measurement_series ms ON ms.fk_measuring_point = mp.obj_id
LEFT JOIN qgep_od.measurement_result mr ON mr.fk_measurement_series = ms.obj_id
WHERE md.remark = 'SWMM Simulation'
ORDER BY mp.obj_id, mr.time;