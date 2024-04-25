--------------------------------------------------------
-- UPDATE wastewater node symbology
-- Argument:
--  * obj_id of wastewater networkelement or NULL to update all
--------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.update_wastewater_node_symbology(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
BEGIN

-- Otherwise this will result in very slow query due to on_structure_part_change_networkelement
-- being triggered for all rows. See https://github.com/QGEP/datamodel/pull/166#issuecomment-760245405 //skip-keyword-check
IF _all THEN
  RAISE INFO 'Temporarily disabling symbology triggers';
  PERFORM tww_sys.disable_symbology_triggers();
END IF;


UPDATE tww_od.wastewater_node n
SET
  _function_hierarchic = function_hierarchic,
  _usage_current = usage_current,
  _status = status
FROM(
  SELECT DISTINCT ON (ne.obj_id) ne.obj_id AS ne_obj_id,
      COALESCE(first_value(CH_from.function_hierarchic) OVER w, first_value(CH_to.function_hierarchic) OVER w) AS function_hierarchic,
      COALESCE(first_value(CH_from.usage_current) OVER w, first_value(CH_to.usage_current) OVER w) AS usage_current,
      COALESCE(first_value(ws_from.status) OVER w, first_value(ws_to.status) OVER w) AS status,
      rank() OVER w AS hierarchy_rank
    FROM
      tww_od.wastewater_networkelement ne
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      LEFT JOIN tww_od.reach                       re_from           	ON re_from.fk_reach_point_from = rp.obj_id
      LEFT JOIN tww_od.wastewater_networkelement   ne_from           	ON ne_from.obj_id = re_from.obj_id
      LEFT JOIN tww_od.channel                     CH_from           	ON CH_from.obj_id = ne_from.fk_wastewater_structure
      LEFT JOIN tww_od.wastewater_structure        ws_from           	ON ws_from.obj_id = ne_from.fk_wastewater_structure
      LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier_from	ON CH_from.function_hierarchic = vl_fct_hier_from.code
      LEFT JOIN tww_vl.channel_usage_current       vl_usg_curr_from	ON CH_from.usage_current = vl_usg_curr_from.code

      LEFT JOIN tww_od.reach                       re_to          	ON re_to.fk_reach_point_to = rp.obj_id
      LEFT JOIN tww_od.wastewater_networkelement   ne_to          	ON ne_to.obj_id = re_to.obj_id
      LEFT JOIN tww_od.channel                     CH_to          	ON CH_to.obj_id = ne_to.fk_wastewater_structure
      LEFT JOIN tww_od.wastewater_structure        ws_to           	ON ws_to.obj_id = ne_to.fk_wastewater_structure
      LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier_to 	ON CH_to.function_hierarchic = vl_fct_hier_to.code
      LEFT JOIN tww_vl.channel_usage_current       vl_usg_curr_to 	ON CH_to.usage_current = vl_usg_curr_to.code
    WHERE _all OR ne.obj_id = _obj_id
      WINDOW w AS ( PARTITION BY ne.obj_id ORDER BY vl_fct_hier_from.order_fct_hierarchic ASC NULLS LAST, vl_fct_hier_to.order_fct_hierarchic ASC NULLS LAST,
                                vl_usg_curr_from.order_usage_current ASC NULLS LAST, vl_usg_curr_to.order_usage_current ASC NULLS LAST ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) symbology_ne
WHERE symbology_ne.ne_obj_id = n.obj_id;

-- See above
IF _all THEN
  RAISE INFO 'Reenabling symbology triggers';
  PERFORM tww_sys.enable_symbology_triggers();
END IF;

END
$BODY$
LANGUAGE plpgsql
VOLATILE;

  -------------------- SYMBOLOGY UPDATE ON CHANNEL TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION tww_app.ws_symbology_update_by_channel()
  RETURNS trigger AS
$BODY$
DECLARE
  _ne_from_id TEXT;
  _ne_to_id TEXT;
  ch_obj_id TEXT;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      ch_obj_id = OLD.obj_id;
    WHEN TG_OP = 'INSERT' THEN
      ch_obj_id = NEW.obj_id;
    WHEN TG_OP = 'DELETE' THEN
      ch_obj_id = OLD.obj_id;
  END CASE;

  BEGIN
    SELECT ne.obj_id INTO  _ne_from_id
      FROM tww_od.wastewater_networkelement ch_ne
      LEFT JOIN tww_od.reach re ON ch_ne.obj_id = re.obj_id
      LEFT JOIN tww_od.reach_point rp ON re.fk_reach_point_from = rp.obj_id
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      WHERE ch_ne.fk_wastewater_structure = ch_obj_id;
    EXECUTE tww_app.update_wastewater_node_symbology(_ne_from_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_channel. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in TWW.';
  END;

  BEGIN
    SELECT ne.obj_id INTO _ne_to_id
      FROM tww_od.wastewater_networkelement ch_ne
      LEFT JOIN tww_od.reach re ON ch_ne.obj_id = re.obj_id
      LEFT JOIN tww_od.reach_point rp ON re.fk_reach_point_to = rp.obj_id
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      WHERE ch_ne.fk_wastewater_structure = ch_obj_id;
    EXECUTE tww_app.update_wastewater_node_symbology(_ne_to_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_channel. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in TWW.';
  END;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;


  -------------------- SYMBOLOGY UPDATE ON REACH POINT TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION tww_app.ws_symbology_update_by_reach_point()
  RETURNS trigger AS
$BODY$
DECLARE
  _ne_id TEXT;
  rp_obj_id TEXT;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      rp_obj_id = OLD.obj_id;
    WHEN TG_OP = 'INSERT' THEN
      rp_obj_id = NEW.obj_id;
    WHEN TG_OP = 'DELETE' THEN
      rp_obj_id = OLD.obj_id;
  END CASE;

  BEGIN
    SELECT ne.obj_id INTO STRICT _ne_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = rp_obj_id;
    EXECUTE tww_app.update_wastewater_node_symbology(_ne_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_reach_point. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in TWW.';
  END;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

  -------------------- SYMBOLOGY UPDATE ON REACH TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION tww_app.ws_symbology_update_by_reach()
  RETURNS trigger AS
$BODY$
DECLARE
  _ne_from_id TEXT;
  _ne_to_id TEXT;
  symb_attribs RECORD;
  re_obj_id TEXT;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      re_obj_id = OLD.obj_id;
    WHEN TG_OP = 'INSERT' THEN
      re_obj_id = NEW.obj_id;
    WHEN TG_OP = 'DELETE' THEN
      re_obj_id = OLD.obj_id;
  END CASE;

  BEGIN
    SELECT ne.obj_id INTO STRICT _ne_from_id
      FROM tww_od.reach re
      LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_from
      LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE re.obj_id = re_obj_id;
    EXECUTE tww_app.update_wastewater_node_symbology(_ne_from_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_reach. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in TWW.';
  END;

  BEGIN
    SELECT ne.obj_id INTO STRICT _ne_to_id
      FROM tww_od.reach re
      LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_to
      LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE re.obj_id = re_obj_id;
    EXECUTE tww_app.update_wastewater_node_symbology(_ne_to_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_reach. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in TWW.';
  END;


  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater structure fk_main_cover
-- Argument:
--  * obj_id of wastewater structure
--  * all True to update all
--  * omit both arguments to update all where fk_main_cover is null
--------------------------------------------------------
CREATE OR REPLACE FUNCTION tww_app.wastewater_structure_update_fk_main_cover(_obj_id text default NULL, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
  UPDATE tww_od.wastewater_structure ws
  SET fk_main_cover = ws_covers.co_obj_id
  FROM (
    SELECT ws.obj_id, min(co.obj_id) OVER (PARTITION BY ws.obj_id) AS co_obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.structure_part sp ON sp.fk_wastewater_structure = ws.obj_id
      LEFT JOIN tww_od.cover co ON sp.obj_id = co.obj_id
      LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
      WHERE ch.obj_id IS NULL AND (_all OR ws.obj_id = _obj_id OR ( NOT _all AND _obj_id is NULL AND ws.fk_main_cover IS NULL))
  ) ws_covers
  WHERE ws.obj_id = ws_covers.obj_id;
END

$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater structure fk_main_wastewater_node
-- Argument:
--  * obj_id of wastewater structure
--  * all True to update all
--  * omit both arguments to update all where fk_main_wastewater_node is null
--------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.wastewater_structure_update_fk_main_wastewater_node(_obj_id text default NULL, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
  UPDATE tww_od.wastewater_structure ws
  SET fk_main_wastewater_node = ws_nodes.wn_obj_id
  FROM (
    SELECT ws.obj_id, min(wn.obj_id) OVER (PARTITION BY ws.obj_id) AS wn_obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
      LEFT JOIN tww_od.wastewater_node wn ON ne.obj_id = wn.obj_id
      LEFT JOIN tww_od.channel ch ON ch.obj_id = ws.obj_id
      WHERE ch.obj_id IS NULL AND (_all OR ws.obj_id = _obj_id OR ( NOT _all AND _obj_id is NULL AND ws.fk_main_wastewater_node IS NULL))
  ) ws_nodes
  WHERE ws.obj_id = ws_nodes.obj_id;
END

$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater structure depth
-- Argument:
--  * obj_id of wastewater structure
--  * all True to update all
--------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.update_depth(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
  UPDATE tww_od.wastewater_structure ws
  SET _depth = depth
  FROM (
    SELECT WS.obj_id, CO.level - COALESCE(MIN(NO.bottom_level), MIN(RP.level)) as depth
      FROM tww_od.wastewater_structure WS
      LEFT JOIN tww_od.cover CO on WS.fk_main_cover = CO.obj_id
      LEFT JOIN tww_od.wastewater_networkelement NE ON NE.fk_wastewater_structure = WS.obj_id
      RIGHT JOIN tww_od.wastewater_node NO on NO.obj_id = NE.obj_id
      LEFT JOIN tww_od.reach_point RP ON RP.fk_wastewater_networkelement = NE.obj_id
      WHERE _all OR WS.obj_id = _obj_id
      GROUP BY WS.obj_id, CO.level
  ) ws_depths
  where ws.obj_id = ws_depths.obj_id;
END

$BODY$
LANGUAGE plpgsql
VOLATILE;

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
  DECLARE
  _labeled_ws_status bigint[] ;
  _labeled_ch_func_hier bigint[];

  BEGIN
  -- Updates the reach_point labels of the wastewater_structure
  -- Function inputs
  -- _obj_id: obj_id of the associatied wastewater structure
  -- _all: optional boolean to update all reach points

  -- Function Variables
  -- _labeled_ws_status: codes of the ws_status to be labeled.
  -- _labeled_ch_func_hier: codes of the ch_function_hierarchic to be labeled.
  --

-- check value lists for label inclusion
SELECT array_agg(code) INTO _labeled_ws_status
FROM tww_vl.wastewater_structure_status
WHERE tww_include_in_ws_labels;

SELECT array_agg(code) INTO _labeled_ch_func_hier
FROM tww_vl.channel_function_hierarchic
WHERE tww_include_in_ws_labels;

    with
	--outputs
	outp as( SELECT
    ne.fk_wastewater_structure
    , rp.obj_id
	, ST_Azimuth(rp.situation3d_geometry,ST_PointN(re.progression3d_geometry,2)) as azimuth
    , row_number() OVER(PARTITION BY NE.fk_wastewater_structure
			ORDER BY (rp.fk_wastewater_networkelement=ws_nd.fk_main_wastewater_node)::int*-1 -- prioritise main wastewater node, invert due to asc order
	    			, vl_fh.order_fct_hierarchic
				, vl_uc.order_usage_current
	    			, ST_Azimuth(rp.situation3d_geometry
	    				, ST_PointN(ST_CurveToLine(re.progression3d_geometry),2))/pi()*180 ASC)
					as idx
    , count	(*) OVER(PARTITION BY NE.fk_wastewater_structure ) as max_idx
      FROM tww_od.reach_point rp
	  -- node
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
	  LEFT JOIN tww_od.wastewater_node wn ON ne.obj_id = wn.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws_nd ON ne.fk_wastewater_structure = ws_nd.obj_id
	  LEFT JOIN tww_od.channel ch_nd ON ne.fk_wastewater_structure = ch_nd.obj_id
	  -- network element from
      INNER JOIN tww_od.reach re ON rp.obj_id = re.fk_reach_point_from
      LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id = re.obj_id
      LEFT JOIN tww_od.channel ch ON ne_re.fk_wastewater_structure = ch.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure = ws.obj_id
	  LEFT JOIN tww_vl.channel_function_hierarchic vl_fh ON vl_fh.code = ch.function_hierarchic
	  LEFT JOIN tww_vl.channel_usage_current vl_uc ON vl_uc.code = ch.usage_current
	    WHERE ch_nd.obj_id is null -- do not label channels
	  AND ch.function_hierarchic= ANY(_labeled_ch_func_hier)
			AND ws.status = ANY(_labeled_ws_status)
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id)) ,

	--inputs
	inp as( SELECT
    ne.fk_wastewater_structure
    , rp.obj_id
    , row_number() OVER(PARTITION BY NE.fk_wastewater_structure
					ORDER BY (mod((((ST_Azimuth(rp.situation3d_geometry
												,ST_PointN(ST_CurveToLine(re.progression3d_geometry),-2)
											   )
									 - coalesce(o.azimuth,0))/pi()*180)+360)::numeric
								  ,360::numeric)
							 ) ASC
					   )
					as idx
    , count	(*) OVER(PARTITION BY NE.fk_wastewater_structure ) as max_idx
      FROM tww_od.reach_point rp
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      INNER JOIN tww_od.reach re ON rp.obj_id = re.fk_reach_point_to
      LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id = re.obj_id
      LEFT JOIN tww_od.channel ch ON ne_re.fk_wastewater_structure = ch.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure = ws.obj_id
	  LEFT JOIN outp o on o.fk_wastewater_structure=ne.fk_wastewater_structure AND o.idx=1
	  WHERE ch.function_hierarchic= ANY(_labeled_ch_func_hier)
			AND ws.status = ANY(_labeled_ws_status)
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id)),

  -- non-labeled rp
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
	  WHERE NOT(ch.function_hierarchic = ANY(_labeled_ch_func_hier)
			AND ws.status = ANY(_labeled_ws_status))
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id)),

  -- actual labels
  rp_label as
  (
  SELECT 'I'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END as new_label
  , obj_id
  FROM inp
  UNION
  SELECT 'O'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END as new_label
  , obj_id
  FROM outp
  UNION
  SELECT NULL as new_label
  , obj_id
  FROM null_label)
 --Upsert reach_point labels
  INSERT INTO tww_od.tww_labels (fk_parent_obj_id,label_type,label_text)
  SELECT  rp_label.obj_id,'main',rp_label.new_label
  FROM rp_label
  ON CONFLICT ON CONSTRAINT unique_tww_od_labels
  DO UPDATE
  SET label_text=EXCLUDED.label_text;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE;


--------------------------------------------------------
-- UPDATE wastewater structure label
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------


CREATE OR REPLACE FUNCTION tww_app.update_wastewater_structure_label(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN

EXECUTE tww_app.update_reach_point_label(_obj_id,_all);

WITH labeled_ws as
(

    SELECT   ws_obj_id as obj_id,
          Array[COALESCE(ws_identifier, '') ,
          CASE WHEN count(co_level)<2 THEN array_to_string(array_agg(E'\nC' || '=' || co_level ORDER BY idx DESC), '', '') ELSE
		  array_to_string(array_agg(E'\nC' || idx || '=' || co_level ORDER BY idx ASC), '', '') END,
          array_to_string(array_agg(E'\nB' || '=' || bottom_level), '', ''),
		  array_to_string(array_agg(E'\n'||rpi_label|| '=' || rpi_level ORDER BY rpi_label ASC), '', '') ,
		  array_to_string(array_agg(E'\n'||rpo_label|| '=' || rpo_level ORDER BY rpo_label ASC), '', '')] as label_array
		  FROM (
		  SELECT ws.obj_id AS ws_obj_id
		  , ws.identifier AS ws_identifier
		  , parts.co_level AS co_level
		  , parts.rpi_level AS rpi_level
		  , parts.rpo_level AS rpo_level
		  , parts.rpi_label AS rpi_label
		  , parts.rpo_label AS rpo_label
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
		, lb.label_text as rpi_label
		,  NULL::text AS rpo_label
      FROM tww_od.reach_point RP
      LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
	  LEFT JOIN tww_od.tww_labels lb on RP.obj_id=lb.fk_parent_obj_id and lb.label_type='main'
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and left(lb.label_text,1)='I'
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
		,  NULL::text AS rpo_label
		, lb.label_text as rpo_label
      FROM tww_od.reach_point RP
      LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
	  LEFT JOIN tww_od.tww_labels lb on RP.obj_id=lb.fk_parent_obj_id and lb.label_type='main'
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and left(lb.label_text,1)='O'
	) parts ON parts.ws = ws.obj_id
    WHERE _all  OR ws.obj_id =_obj_id
    ) all_parts
	GROUP BY ws_obj_id, COALESCE(ws_identifier, '')
)
  INSERT INTO tww_od.tww_labels (fk_parent_obj_id,label_type,label_text)
  SELECT
      obj_id
    , unnest(
      Array[
	      'main'
		, 'cover'
		, 'bottom'
		, 'input'
		, 'output'
		]
	  )
	, unnest(label_array)
  FROM labeled_ws
  ON CONFLICT ON CONSTRAINT unique_tww_od_labels
  DO UPDATE
  SET label_text=EXCLUDED.label_text;

END

$BODY$
LANGUAGE plpgsql
VOLATILE;


--------------------------------------------------
-- ON COVER CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_cover_change()
  RETURNS trigger AS
$BODY$
DECLARE
  co_obj_id TEXT;
  affected_sp RECORD;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      co_obj_id = OLD.obj_id;
    WHEN TG_OP = 'INSERT' THEN
      co_obj_id = NEW.obj_id;
    WHEN TG_OP = 'DELETE' THEN
      co_obj_id = OLD.obj_id;
  END CASE;

  SELECT SP.fk_wastewater_structure INTO affected_sp
  FROM tww_od.structure_part SP
  WHERE obj_id = co_obj_id;

  EXECUTE tww_app.update_wastewater_structure_label(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.update_depth(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.wastewater_structure_update_fk_main_cover(affected_sp.fk_wastewater_structure);

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;




--------------------------------------------------
-- ON STRUCTURE PART / NETWORKELEMENT CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_structure_part_change_networkelement()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_obj_ids TEXT[];
  _ws_obj_id TEXT;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      _ws_obj_ids = ARRAY[OLD.fk_wastewater_structure, NEW.fk_wastewater_structure];
    WHEN TG_OP = 'INSERT' THEN
      _ws_obj_ids = ARRAY[NEW.fk_wastewater_structure];
    WHEN TG_OP = 'DELETE' THEN
      _ws_obj_ids = ARRAY[OLD.fk_wastewater_structure];
  END CASE;

  FOREACH _ws_obj_id IN ARRAY _ws_obj_ids
  LOOP
    EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;



--------------------------------------------------
-- ON WASTEWATER STRUCTURE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_wastewater_structure_update()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_obj_id TEXT;
BEGIN
  -- Prevent recursion
  IF COALESCE(OLD.identifier, '') = COALESCE(NEW.identifier, '') THEN
    RETURN NEW;
  END IF;
  _ws_obj_id = OLD.obj_id;
  EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);

  IF OLD.fk_main_cover != NEW.fk_main_cover THEN
    EXECUTE tww_app.update_depth(_ws_obj_id);
  END IF;


  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- ON REACH CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_reach_change()
  RETURNS trigger AS
$BODY$
DECLARE
  rp_obj_ids TEXT[];
  _ws_obj_id TEXT;
  rps RECORD;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      rp_obj_ids = ARRAY[OLD.fk_reach_point_from, OLD.fk_reach_point_to];
    WHEN TG_OP = 'INSERT' THEN
      rp_obj_ids = ARRAY[NEW.fk_reach_point_from, NEW.fk_reach_point_to];
    WHEN TG_OP = 'DELETE' THEN
      rp_obj_ids = ARRAY[OLD.fk_reach_point_from, OLD.fk_reach_point_to];
  END CASE;

  FOR _ws_obj_id IN
    SELECT ws.obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = ANY ( rp_obj_ids )
  LOOP
    EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);
    EXECUTE tww_app.update_depth(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;


--------------------------------------------------
-- ON REACH DELETE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_reach_delete()
  RETURNS trigger AS
$BODY$
DECLARE
  channel_id text;
  reach_count integer;
BEGIN
  -- get channel obj_id
  SELECT fk_wastewater_structure INTO channel_id
    FROM tww_od.wastewater_networkelement
    WHERE wastewater_networkelement.obj_id = OLD.obj_id;

  DELETE FROM tww_od.wastewater_networkelement WHERE obj_id = OLD.obj_id;
  DELETE FROM tww_od.reach_point WHERE obj_id = OLD.fk_reach_point_from;
  DELETE FROM tww_od.reach_point WHERE obj_id = OLD.fk_reach_point_to;

  -- delete channel if no reach left
  SELECT COUNT(fk_wastewater_structure) INTO reach_count
    FROM tww_od.wastewater_networkelement
    WHERE fk_wastewater_structure = channel_id;
  IF reach_count = 0 THEN
    RAISE NOTICE 'Removing channel (%) since no reach is left', channel_id;
    DELETE FROM tww_od.channel WHERE obj_id = channel_id;
    DELETE FROM tww_od.wastewater_structure WHERE obj_id = channel_id;
  END IF;
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- ON WASTEWATER NODE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_wasterwaternode_change()
  RETURNS trigger AS
$BODY$
DECLARE
  co_obj_id TEXT;
  affected_sp RECORD;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      co_obj_id = OLD.obj_id;
    WHEN TG_OP = 'INSERT' THEN
      co_obj_id = NEW.obj_id;
    WHEN TG_OP = 'DELETE' THEN
      co_obj_id = OLD.obj_id;
  END CASE;

  SELECT ne.fk_wastewater_structure INTO affected_sp
  FROM tww_od.wastewater_networkelement ne
  WHERE obj_id = co_obj_id;

  EXECUTE tww_app.update_depth(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.update_wastewater_structure_label(affected_sp.fk_wastewater_structure);

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- ON REACH POINT CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.on_reach_point_update()
  RETURNS trigger AS
$BODY$
DECLARE
  rp_obj_id text;
  _ws_obj_id text;
  ne_obj_ids text[];
  ne_obj_id text;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      IF (NEW.fk_wastewater_networkelement = OLD.fk_wastewater_networkelement) THEN
        RETURN NEW;
      END IF;
      rp_obj_id = OLD.obj_id;
      ne_obj_ids := ARRAY[OLD.fk_wastewater_networkelement, NEW.fk_wastewater_networkelement];
    WHEN TG_OP = 'INSERT' THEN
      rp_obj_id = NEW.obj_id;
      ne_obj_ids := ARRAY[NEW.fk_wastewater_networkelement];
    WHEN TG_OP = 'DELETE' THEN
      rp_obj_id = OLD.obj_id;
      ne_obj_ids := ARRAY[OLD.fk_wastewater_networkelement];
  END CASE;


  UPDATE tww_od.reach
    SET progression3d_geometry = progression3d_geometry
    WHERE fk_reach_point_from = rp_obj_id OR fk_reach_point_to = rp_obj_id; --To retrigger the calculate_length trigger on reach update

  FOREACH ne_obj_id IN ARRAY ne_obj_ids
  LOOP
      SELECT ws.obj_id INTO _ws_obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = ne_obj_id;

      EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);
      EXECUTE tww_app.update_depth(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- CALCULATE REACH LENGTH
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.calculate_reach_length()
  RETURNS trigger AS
$BODY$

DECLARE
	_rp_from_level numeric(7,3);
	_rp_to_level numeric(7,3);

BEGIN

  SELECT rp_from.level INTO _rp_from_level
  FROM tww_od.reach_point rp_from
  WHERE NEW.fk_reach_point_from = rp_from.obj_id;

  SELECT rp_to.level INTO _rp_to_level
  FROM tww_od.reach_point rp_to
  WHERE NEW.fk_reach_point_to = rp_to.obj_id;

  NEW.length_effective = COALESCE(sqrt((_rp_from_level - _rp_to_level)^2 + ST_Length(NEW.progression3d_geometry)^2), ST_Length(NEW.progression3d_geometry) );

  RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-----------------------------------------------------------------------
-- Drop Symbology Triggers
-- To temporarily disable these cache refreshes for batch jobs like migrations
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_sys.disable_symbology_triggers() RETURNS VOID AS $$
DECLARE
    tbl text;
	trig text;
BEGIN
  ALTER TABLE tww_od.reach_point DISABLE TRIGGER on_reach_point_update;
  ALTER TABLE tww_od.reach DISABLE TRIGGER on_reach_2_change;
  ALTER TABLE tww_od.reach DISABLE TRIGGER on_reach_1_delete;
  ALTER TABLE tww_od.wastewater_structure DISABLE TRIGGER on_wastewater_structure_update;
  ALTER TABLE tww_od.wastewater_networkelement DISABLE TRIGGER ws_label_update_by_wastewater_networkelement;
  ALTER TABLE tww_od.structure_part DISABLE TRIGGER on_structure_part_change;
  ALTER TABLE tww_od.cover DISABLE TRIGGER on_cover_change;
  ALTER TABLE tww_od.wastewater_node DISABLE TRIGGER on_wasterwaternode_change;
  ALTER TABLE tww_od.reach DISABLE TRIGGER ws_symbology_update_by_reach;
  ALTER TABLE tww_od.channel DISABLE TRIGGER ws_symbology_update_by_channel;
  ALTER TABLE tww_od.reach_point DISABLE TRIGGER ws_symbology_update_by_reach_point;
  ALTER TABLE tww_od.reach DISABLE TRIGGER calculate_reach_length;
  RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-----------------------------------------------------------------------
-- Create Symbology Triggers
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_sys.enable_symbology_triggers() RETURNS VOID AS $$
DECLARE
    tbl text;
	trig text;
BEGIN
  ALTER TABLE tww_od.reach_point ENABLE TRIGGER on_reach_point_update;
  ALTER TABLE tww_od.reach ENABLE TRIGGER on_reach_2_change;
  ALTER TABLE tww_od.reach ENABLE TRIGGER on_reach_1_delete;
  ALTER TABLE tww_od.wastewater_structure ENABLE TRIGGER on_wastewater_structure_update;
  ALTER TABLE tww_od.wastewater_networkelement ENABLE TRIGGER ws_label_update_by_wastewater_networkelement;
  ALTER TABLE tww_od.structure_part ENABLE TRIGGER on_structure_part_change;
  ALTER TABLE tww_od.cover ENABLE TRIGGER on_cover_change;
  ALTER TABLE tww_od.wastewater_node ENABLE TRIGGER on_wasterwaternode_change;
  ALTER TABLE tww_od.reach ENABLE TRIGGER ws_symbology_update_by_reach;
  ALTER TABLE tww_od.channel ENABLE TRIGGER ws_symbology_update_by_channel;
  ALTER TABLE tww_od.reach_point ENABLE TRIGGER ws_symbology_update_by_reach_point;
  ALTER TABLE tww_od.reach ENABLE TRIGGER calculate_reach_length;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- only update -> insert and delete are handled by reach trigger
  CREATE TRIGGER on_reach_point_update
  AFTER UPDATE
    ON tww_od.reach_point
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_reach_point_update();

  CREATE TRIGGER on_reach_2_change
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_reach_change();

  CREATE TRIGGER on_reach_1_delete
  AFTER DELETE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_reach_delete();

  CREATE TRIGGER calculate_reach_length
  BEFORE INSERT OR UPDATE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.calculate_reach_length();

  CREATE TRIGGER ws_symbology_update_by_reach
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.ws_symbology_update_by_reach();

  CREATE TRIGGER on_wastewater_structure_update
  AFTER UPDATE
    ON tww_od.wastewater_structure
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_wastewater_structure_update();

  CREATE TRIGGER ws_label_update_by_wastewater_networkelement
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.wastewater_networkelement
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_structure_part_change_networkelement();

  CREATE TRIGGER on_structure_part_change
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.structure_part
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_structure_part_change_networkelement();

  CREATE TRIGGER on_cover_change
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.cover
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_cover_change();

  CREATE TRIGGER on_wasterwaternode_change
  AFTER INSERT OR UPDATE
    ON tww_od.wastewater_node
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.on_wasterwaternode_change();

  CREATE TRIGGER ws_symbology_update_by_channel
  AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.channel
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.ws_symbology_update_by_channel();

  -- only update -> insert and delete are handled by reach trigger
  CREATE TRIGGER ws_symbology_update_by_reach_point
  AFTER UPDATE
    ON tww_od.reach_point
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.ws_symbology_update_by_reach_point();
