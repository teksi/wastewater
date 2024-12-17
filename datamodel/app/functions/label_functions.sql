--------------------------------------------------------
-- UPDATE reach point label
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------


CREATE OR REPLACE FUNCTION tww_app.update_reach_point_labels(_obj_ids text[],
	_all boolean default false
	)
  RETURNS VOID AS
 $BODY$

  BEGIN
  -- Updates the reach_point labels of the wastewater_structure
  -- Function inputs
  -- _obj_id: obj_id of the associated wastewater structure
  -- _all: optional boolean to update all reach points
  --
DELETE FROM tww_od.tww_reach_point_label where _all or fk_wastewater_structure=ANY(_obj_ids);
-- Outflow
    WITH outs as(
	  SELECT
		rp.obj_id,
		ne.fk_wastewater_structure,
		row_number() 
		  OVER(
		    PARTITION BY ne.fk_wastewater_structure
			ORDER BY(
			  rp.fk_wastewater_networkelement=ws_nd.fk_main_wastewater_node)::int*-1,-- prioritise main wastewater node, invert due to asc order
			  fh.tww_symbology_order,
			  uc.tww_symbology_order,
			  ST_Azimuth(rp.situation3d_geometry,ST_PointN(ST_CurveToLine(re_from.progression3d_geometry),2))
			  ASC) 
			AS idx,
		  ST_Azimuth(rp.situation3d_geometry,ST_PointN(re_from.progression3d_geometry,2)) AS azimuth,
		  count (*) OVER(PARTITION BY ne.fk_wastewater_structure ) as max_idx
		  FROM tww_od.reach_point rp
		  INNER JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
		  INNER JOIN (SELECT ws.obj_id, fk_main_wastewater_node FROM tww_od.wastewater_structure ws
		  WHERE NOT EXISTS(SELECT 1 from tww_od.channel ch WHERE ws.obj_id = ch.obj_id LIMIT 1)
					 ) ws_nd ON ne.fk_wastewater_structure = ws_nd.obj_id
		  -- network element from
		  INNER JOIN tww_od.reach re_from ON rp.obj_id = re_from.fk_reach_point_from
		  INNER JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id::text = re_from.obj_id::text
		  INNER JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure::text = ws.obj_id::text
		  INNER JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
		  INNER JOIN tww_vl.channel_function_hierarchic fh ON ch.function_hierarchic  = fh.code
		  INNER JOIN tww_vl.channel_usage_current uc ON ch.usage_current = uc.code
		  INNER JOIN tww_vl.wastewater_structure_status st ON ws.status = st.code
			WHERE fh.tww_use_in_labels
			AND st.tww_use_in_labels
			AND _all OR ws_nd.obj_id=ANY(_obj_ids))
	INSERT INTO tww_od.tww_reach_point_label(fk_reach_point,fk_wastewater_structure,label_text,azimuth)
    SELECT obj_id,fk_wastewater_structure, 'O'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END,azimuth FROM outs;
		
	With
		inputs AS (
		SELECT
			ne.fk_wastewater_structure,
			rp.obj_id,
			row_number() OVER(PARTITION BY ne.fk_wastewater_structure
						ORDER BY (mod((2*pi()+(ST_Azimuth(RP.situation3d_geometry,ST_PointN(RE_to.progression3d_geometry,-2))-coalesce(outs.azimuth,0)))::numeric , 2*pi()::numeric)) ASC) AS idx,
		  count (*) OVER(PARTITION BY ne.fk_wastewater_structure ) as max_idx
		  FROM tww_od.reach_point rp
		  INNER JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
		  -- network element from
		  INNER JOIN tww_od.reach re_to ON rp.obj_id = re_to.fk_reach_point_to
		  INNER JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id::text = re_to.obj_id::text
		  INNER JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure::text = ws.obj_id::text
		  INNER JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
		  INNER JOIN tww_vl.channel_function_hierarchic fh ON ch.function_hierarchic  = fh.code
		  INNER JOIN tww_vl.channel_usage_current uc ON ch.usage_current = uc.code
		  INNER JOIN tww_vl.wastewater_structure_status st ON ws.status = st.code
	      LEFT JOIN tww_od.tww_reach_point_label outs on outs.fk_wastewater_structure = ne.fk_wastewater_structure AND label_text=ANY(ARRAY['O','O1'])
			WHERE fh.tww_use_in_labels
			AND st.tww_use_in_labels
			AND (_all OR ne.fk_wastewater_structure = _obj_id)
		),
	null_label as(
     SELECT
    ne.fk_wastewater_structure
    , rp.obj_id
      FROM tww_od.reach_point rp
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      INNER JOIN tww_od.reach re ON rp.obj_id IN(re.fk_reach_point_to,re.fk_reach_point_from)
      LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id = re.obj_id
      LEFT JOIN tww_od.channel ch ON ne_re.fk_wastewater_structure = ch.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure = ws.obj_id
	  LEFT JOIN tww_vl.channel_function_hierarchic fh ON ch.function_hierarchic  = fh.code
	  LEFT JOIN tww_vl.wastewater_structure_status st ON ws.status = st.code
	  WHERE NOT(fh.tww_use_in_labels
			AND st.tww_use_in_labels)
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id))
  INSERT INTO tww_od.tww_reach_point_label (fk_reach_point,fk_wastewater_structure,label_text)
  SELECT obj_id
  	  , 'I'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END
	  , fk_wastewater_structure
	  FROM inputs
	  UNION
	  SELECT 
	    obj_id
	  , NULL
	  , fk_wastewater_structure
	  FROM null_label;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater structure label
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------

------ 14.9.2022 index labels by wastewater structure for VSA-DSS compliance /cymed
------ 14.9.2022 use idx only when more than one entry /cymed
------ 15.8.2018 uk adapted label display only for primary wastwater system
------ WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and CH_to.function_hierarchic in (5062,5064,5066,5068,5069,5070,5071,5072,5074)  ----label only reaches with function_hierarchic=pwwf.*


CREATE OR REPLACE FUNCTION tww_app.update_wastewater_structure_labels(_obj_ids text[], _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN

EXECUTE tww_app.update_reach_point_labels(_obj_ids,_all);
DELETE FROM tww_od.tww_wastewater_structure_label where _all or fk_wastewater_structure=ANY(_obj_ids);

WITH labeled_ws AS(
SELECT   ws_obj_id,
           COALESCE(ws_identifier, '')  as main_lbl,
          CASE WHEN count(co_level)<2 THEN array_to_string(array_agg(E'\nC' || '=' || co_level ORDER BY idx DESC), '', '') ELSE
		  array_to_string(array_agg(E'\nC' || idx || '=' || co_level ORDER BY idx ASC), '', '') END as cover_lbl,
          array_to_string(array_agg(E'\nB' || '=' || bottom_level), '', '') as bottom_lbl,
		  array_to_string(array_agg(E'\n'||rp_label|| '=' || rp_level ORDER BY rp_label ASC), '', '')  as rp_lbl
  FROM (
		  SELECT ws.obj_id AS ws_obj_id
		  , ws.identifier AS ws_identifier
		  , parts.co_level AS co_level
		  , parts.rp_level AS rp_level
		  , parts.rp_label AS rp_label
		  , parts.obj_id, idx
		  , parts.bottom_level AS bottom_level
    FROM tww_od.wastewater_structure WS

    LEFT JOIN (
	  --cover
      SELECT
		coalesce(round(CO.level, 2)::text, '?') AS co_level
		, SP.fk_wastewater_structure ws
		, SP.obj_id
		, row_number() OVER(PARTITION BY SP.fk_wastewater_structure) AS idx
		, NULL::text AS bottom_level
		, NULL::text AS rp_level
		, NULL::text as rp_label
      FROM tww_od.structure_part SP
      RIGHT JOIN tww_od.cover CO ON CO.obj_id = SP.obj_id
      WHERE _all OR SP.fk_wastewater_structure =ANY(_obj_ids)
      -- Bottom
      UNION
      SELECT
		NULL AS co_level
		, ws1.obj_id ws
		, NULL as obj_id
		, NULL as idx
		, coalesce(round(wn.bottom_level, 2)::text, '?') AS wn_bottom_level
		, NULL::text AS rp_level
		, NULL::text as rp_label
      FROM tww_od.wastewater_structure ws1
	  LEFT JOIN tww_od.channel ch1 ON ch1.obj_id=ws1.obj_id
      LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws1.fk_main_wastewater_node
      WHERE (_all AND ch1.obj_id IS NULL) OR ws1.obj_id =ANY(_obj_ids)
	  UNION
	  --reach points
      SELECT
		NULL AS co_level
		, lb.fk_wastewater_structure ws
		, RP.obj_id
		,NULL as idx
		, NULL::text AS bottom_level
		, coalesce(round(RP.level, 2)::text, '?') AS rp_level
		, lb.label_text as rp_label
      FROM tww_od.reach_point RP
	  LEFT JOIN tww_od.tww_reach_point_label lb on RP.obj_id=lb.fk_reach_point
      WHERE (_all OR lb.fk_wastewater_structure =ANY(_obj_ids))
	) parts ON parts.ws = ws.obj_id
    WHERE _all  OR ws.obj_id =ANY(_obj_ids)
    ) all_parts
	GROUP BY ws_obj_id, COALESCE(ws_identifier, '')
)
  INSERT INTO tww_od.tww_wastewater_structure_label (fk_wastewater_structure,label_text_c,label_text_b,label_text_rp)
  SELECT
      ws_obj_id
    ,  cover_lbl
	, bottom_lbl
	, rp_lbl
  FROM labeled_ws;

END

$BODY$
LANGUAGE plpgsql
VOLATILE;