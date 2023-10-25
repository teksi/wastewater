--------
-- View for the swmm module class vertices
-- - Depends on qgep_swmm.vw_conduits
--------
CREATE OR REPLACE VIEW qgep_swmm.vw_vertices AS

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
  FROM qgep_swmm.vw_conduits
  ) as foo
WHERE (dp).path[1] != 1		-- dont select first vertice
AND (dp).path[1] != nvert;	-- dont select last vertice
