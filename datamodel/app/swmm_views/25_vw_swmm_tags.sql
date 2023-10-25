--------
-- View for the swmm module class tags
-- Depends on:
-- - tww_app.swmm_vw_junctions
-- - tww_app.swmm_vw_outfalls
-- - tww_app.swmm_vw_storages
-- - tww_app.swmm_vw_conduits
-- - tww_app.swmm_vw_pumps
-- - tww_app.swmm_vw_subcatchments
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_tags AS

SELECT
	'Node' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_junctions
WHERE tag IS NOT NULL

UNION

SELECT
	'Node' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_outfalls
WHERE tag IS NOT NULL

UNION

SELECT
	'Node' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_storages
WHERE tag IS NOT NULL

UNION

SELECT
	'Link' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_conduits
WHERE tag IS NOT NULL

UNION

SELECT
	'Link' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_pumps
WHERE tag IS NOT NULL

UNION

SELECT
	'Subcatch' as type,
	name as name,
	tag as value,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_subcatchments
WHERE tag IS NOT NULL;
