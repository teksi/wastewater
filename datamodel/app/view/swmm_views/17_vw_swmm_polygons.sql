--------
-- View for the swmm module class polygons
-- - Depends on tww_app.swmm_vw_subcatchments
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_polygons AS

SELECT
  Subcatchment,
  round(ST_X((dp).geom)::numeric,2) as X_Coord,
  round(ST_Y((dp).geom)::numeric,2) as Y_Coord,
  state,
  hierarchy,
  obj_id
  FROM (
    SELECT
      Name As Subcatchment,
      ST_DumpPoints(geom) AS dp,
      ST_NPoints(geom) as nvert,
      state,
      hierarchy,
      obj_id
      FROM tww_app.swmm_vw_subcatchments
    ) as foo
WHERE (dp).path[2] != nvert;	-- dont select last vertex
