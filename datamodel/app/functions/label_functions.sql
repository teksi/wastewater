
--------------------------------------------------------
-- UPDATE reach point label
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------


CREATE OR REPLACE FUNCTION tww_app.update_reach_point_label(_obj_id text,
	_all boolean default false
	)
  RETURNS VOID AS
 $BODY$

  BEGIN
  -- Updates the reach_point labels of the wastewater_structure
  -- Function inputs
  -- _obj_id: obj_id of the associated wastewater structure
  -- _all: optional boolean to update all reach points

  -- Function Variables
  -- _labeled_ws_status: codes of the ws_status to be labeled.
  -- _labeled_ch_func_hier: codes of the ch_function_hierarchic to be labeled.
  --

-- check value lists for label inclusion
	With
		inputs AS (
		SELECT
			ne.fk_wastewater_structure ws,
			rp.obj_id,
			row_number() OVER(PARTITION BY NE.fk_wastewater_structure
						ORDER BY (mod((2*pi()+(ST_Azimuth(RP.situation3d_geometry,ST_PointN(RE_to.progression3d_geometry,-2))-coalesce(outs.azimuth,0)))::numeric , 2*pi()::numeric)) ASC) AS idx,
		  count (*) OVER(PARTITION BY NE.fk_wastewater_structure ) as max_idx
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
	      LEFT JOIN tww_app.vw_labels_outflow outs on outs.ws = ne.fk_wastewater_structure AND outs.idx=1
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
			  OR ne.fk_wastewater_structure= _obj_id)),
	rp_label as
	  (
	  SELECT 'I'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END as new_label
	  , obj_id
	  FROM inp
	  UNION
	  SELECT 'O'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END as new_label
	  , obj_id
	  FROM tww_app.vw_labels_outflow
	  UNION
	  SELECT NULL as new_label
	  , obj_id
	  FROM null_label)

 --Upsert reach_point labels
  INSERT INTO tww_od.tww_labels (fk_parent_obj_id,label_def)
  SELECT rp_label.obj_id,jsonb_build_object('main',rp_label.new_label)
  FROM rp_label
  ON CONFLICT ON CONSTRAINT pkey_tww_od_labels_fk_parent_obj_id
  DO UPDATE
  SET label_def=EXCLUDED.label_def;

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



CREATE OR REPLACE FUNCTION tww_app.update_wastewater_structure_label(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
UPDATE tww_od.wastewater_structure ws
SET _label = label,
    _cover_label = cover_label,
    _bottom_label = bottom_label,
    _input_label = input_label,
    _output_label = output_label
    FROM(

SELECT   ws_obj_id,
          COALESCE(ws_identifier, '') as label,
          CASE WHEN count(co_level)<2 THEN array_to_string(array_agg(E'\nC' || '=' || co_level ORDER BY idx DESC), '', '') ELSE
		  array_to_string(array_agg(E'\nC' || idx || '=' || co_level ORDER BY idx ASC), '', '') END as cover_label,
          array_to_string(array_agg(E'\nB' || '=' || bottom_level), '', '') as bottom_label,
          CASE WHEN count(rpi_level)<2 THEN array_to_string(array_agg(E'\nI' || '=' || rpi_level ORDER BY idx DESC), '', '') ELSE
		  array_to_string(array_agg(E'\nI' || idx || '=' || rpi_level ORDER BY idx ASC), '', '') END as input_label,
          CASE WHEN count(rpo_level)<2 THEN array_to_string(array_agg(E'\nO' || '=' || rpo_level ORDER BY idx DESC), '', '') ELSE
		  array_to_string(array_agg(E'\nO' || idx || '=' || rpo_level ORDER BY idx ASC), '', '') END as output_label
  FROM (
		  SELECT ws.obj_id AS ws_obj_id, ws.identifier AS ws_identifier, parts.co_level AS co_level, parts.rpi_level AS rpi_level, parts.rpo_level AS rpo_level, parts.obj_id, idx, bottom_level AS bottom_level
    FROM tww_od.wastewater_structure WS

    LEFT JOIN (
		--cover
      SELECT
		coalesce(round(CO.level, 2)::text, '?') AS co_level
		, SP.fk_wastewater_structure ws
		, SP.obj_id
		, row_number() OVER(PARTITION BY SP.fk_wastewater_structure) AS idx
		, NULL::text AS bottom_level
		, NULL::text AS rpi_level
		, NULL::text  AS rpo_level
		, NULL::text as rpi_label
		, NULL::text  AS rpo_label
      FROM tww_od.structure_part SP
      RIGHT JOIN tww_od.cover CO ON CO.obj_id = SP.obj_id
      WHERE _all OR SP.fk_wastewater_structure = _obj_id
      -- Bottom
      UNION
      SELECT
		NULL AS co_level
		, ws1.obj_id ws
		, NULL as obj_id
		, NULL as idx
		, coalesce(round(wn.bottom_level, 2)::text, '?') AS wn_bottom_level
		, NULL::text AS rpi_level
		, NULL::text  AS rpo_level
		, NULL::text as rpi_label
		, NULL::text  AS rpo_label
      FROM tww_od.wastewater_structure ws1
	  LEFT JOIN tww_od.channel ch1 ON ch1.obj_id=ws1.obj_id
      LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws1.fk_main_wastewater_node
      WHERE (_all AND ch1.obj_id IS NULL) OR ws1.obj_id = _obj_id
	  UNION
	  --input
      SELECT
		NULL AS co_level
		, NE.fk_wastewater_structure ws
		, RP.obj_id
		,NULL as idx
		, NULL::text AS bottom_level
		, coalesce(round(RP.level, 2)::text, '?') AS rpi_level
		, NULL::text AS rpo_level
		, lb.label_def ->> 'main' as rpi_label
		,  NULL::text AS rpo_label
      FROM tww_od.reach_point RP
      LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
	  LEFT JOIN tww_od.tww_labels lb on RP.obj_id=lb.fk_parent_obj_id
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and left(lb.label_def ->> 'main',1) = 'I'::text
      -- output
      UNION
      SELECT
		NULL AS co_level
		, NE.fk_wastewater_structure ws
		, RP.obj_id
		,NULL as idx
		, NULL::text AS bottom_level
		, NULL::text AS rpi_level
		, coalesce(round(RP.level, 2)::text, '?') AS rpo_level
		,  NULL::text AS rpio_label
		, lb.label_def ->> 'main' as rpo_label
      FROM tww_od.reach_point RP
      LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
	  LEFT JOIN tww_od.tww_labels lb on RP.obj_id=lb.fk_parent_obj_id
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and left(lb.label_def ->> 'main',1) = 'O'::text
	) parts ON parts.ws = ws.obj_id
    WHERE _all  OR ws.obj_id = _obj_id
    ) all_parts
	GROUP BY ws_obj_id, COALESCE(ws_identifier, '')
),
updated as(
	UPDATE tww_od.tww_labels SET label_def = jbo
	FROM(
	SELECT
      obj_id
    , jsonb_build_object(
	      'main', main_lbl
		, 'cover', cover_lbl
		, 'bottom', bottom_lbl
		, 'input', input_lbl
		, 'output', output_lbl
		) as jbo
  FROM labeled_ws) lws
  WHERE fk_parent_obj_id = lws.obj_id
)
  INSERT INTO tww_od.tww_labels (fk_parent_obj_id,label_def)
  SELECT
      lws.obj_id
    , jsonb_build_object(
	      'main', main_lbl
		, 'cover', cover_lbl
		, 'bottom', bottom_lbl
		, 'input', input_lbl
		, 'output', output_lbl
		)
  FROM labeled_ws lws
  LEFT JOIN tww_od.tww_labels lbls ON lbls.fk_parent_obj_id=lws.obj_id
  WHERE lbls.fk_parent_obj_id IS NULL;

END

$BODY$
LANGUAGE plpgsql
VOLATILE;
