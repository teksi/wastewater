--------
-- View for the swmm module class tags
-- Depends on:
-- - qgep_swmm.vw_junctions
-- - qgep_swmm.vw_outfalls
-- - qgep_swmm.vw_storages
-- - qgep_swmm.vw_conduits
-- - qgep_swmm.vw_pumps
-- - qgep_swmm.vw_subcatchments
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_tags AS

SELECT
	'Node' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_junctions
WHERE tag IS NOT NULL

UNION

SELECT
	'Node' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_outfalls
WHERE tag IS NOT NULL

UNION

SELECT
	'Node' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_storages
WHERE tag IS NOT NULL

UNION

SELECT
	'Link' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_conduits
WHERE tag IS NOT NULL

UNION

SELECT
	'Link' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_pumps
WHERE tag IS NOT NULL

UNION

SELECT
	'Subcatch' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_subcatchments
WHERE tag IS NOT NULL;
