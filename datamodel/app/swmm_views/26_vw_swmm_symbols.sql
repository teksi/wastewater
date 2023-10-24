--------
-- View for the swmm module class symbols (rain gages locations)
-- - This view depends on tww_app.swmm.vw_raingages
--------
CREATE OR REPLACE VIEW tww_app.swmm.vw_symbols AS

SELECT
	Name as Gage,
	st_x(geom) as Xcoord,
	st_y(geom) as Ycoord,
    state as state,
	hierarchy,
	obj_id
FROM tww_app.swmm.vw_raingages
