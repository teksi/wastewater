--------
-- View for the swmm module class coordinate
-- Depends on:
-- - tww_app.swmm_vw_junctions
-- - tww_app.swmm_vw_outfalls
-- - tww_app.swmm_vw_dividers
-- - tww_app.swmm_vw_storages
-- - tww_app.swmm_vw_raingages
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_coordinates AS

SELECT
	Name as Node,
	ROUND(ST_X(geom)::numeric,2) as X_Coord,
	ROUND(ST_Y(geom)::numeric,2) as Y_Coord,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_junctions
WHERE geom IS NOT NULL

UNION

SELECT
	Name as Node,
	ROUND(ST_X(geom)::numeric,2) as X_Coord,
	ROUND(ST_Y(geom)::numeric,2) as Y_Coord,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_outfalls
WHERE geom IS NOT NULL

UNION

SELECT
	Name as Node,
	ROUND(ST_X(geom)::numeric,2) as X_Coord,
	ROUND(ST_Y(geom)::numeric,2) as Y_Coord,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_dividers
WHERE geom IS NOT NULL

UNION

SELECT
	Name as Node,
	ROUND(ST_X(geom)::numeric,2) as X_Coord,
	ROUND(ST_Y(geom)::numeric,2) as Y_Coord,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_storages
WHERE geom IS NOT NULL

UNION

SELECT
	Name as Node,
	ROUND(ST_X(geom)::numeric,2) as X_Coord,
	ROUND(ST_Y(geom)::numeric,2) as Y_Coord,
	state,
	hierarchy,
	obj_id
FROM tww_app.swmm_vw_raingages
WHERE geom IS NOT NULL;
