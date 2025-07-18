--------
-- View for the swmm module class vertices
-- - Depends on tww_app.swmm_vw_conduits
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_vertices AS

SELECT
  link,
  ROUND(ST_X((dp).geom)::numeric,2) as X_Coord,
  ROUND(ST_Y((dp).geom)::numeric,2) as Y_Coord,
  state,
  hierarchy,
  obj_id
FROM (
  SELECT
    Name As Link,
    ST_DumpPoints(geom) AS dp,
    ST_NPoints(geom) as nvert,
    state,
    hierarchy,
    obj_id
  FROM tww_app.swmm_vw_conduits
  ) as foo
WHERE (dp).path[1] != 1		-- dont select first vertice
AND (dp).path[1] != nvert;	-- dont select last vertice
