CREATE OR REPLACE VIEW qgep_swmm.vw_orifices AS

SELECT
NULL::text as Name,
NULL::text as FromNode,
NULL::text as ToNode,
'SIDE'::text as Type,
0::text as Offset,
0.65::text as Qcoeff,
'NO'::text as Gated,
0 ::text as CloseTime,
NULL::text as state,
NULL::text as hierarchy,
NULL::text as obj_id
LIMIT 0;