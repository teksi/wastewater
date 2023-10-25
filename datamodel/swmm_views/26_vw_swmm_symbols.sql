--------
-- View for the swmm module class symbols (rain gages locations)
-- - This view depends on qgep_swmm.vw_raingages
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_symbols AS

SELECT
	Name as Gage,
	st_x(geom) as Xcoord,
	st_y(geom) as Ycoord,
    state as state,
	hierarchy,
	obj_id
FROM qgep_swmm.vw_raingages
