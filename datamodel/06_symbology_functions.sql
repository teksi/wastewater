--------------------------------------------------------
-- UPDATE wastewater structure symbology
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.update_wastewater_structure_symbology(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
BEGIN
UPDATE qgep_od.wastewater_structure ws
SET
  _function_hierarchic = function_hierarchic,
  _usage_current = usage_current
FROM(
  SELECT DISTINCT ON (ws.obj_id) ws.obj_id AS ws_obj_id,
      COALESCE(first_value(CH_from.function_hierarchic) OVER w, first_value(CH_to.function_hierarchic) OVER w) AS function_hierarchic,
      COALESCE(first_value(CH_from.usage_current) OVER w, first_value(CH_to.usage_current) OVER w) AS usage_current,
      rank() OVER w AS hierarchy_rank
    FROM
      qgep_od.wastewater_structure ws
      LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.fk_wastewater_structure = ws.obj_id
      LEFT JOIN qgep_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      LEFT JOIN qgep_od.reach                       re_from           ON re_from.fk_reach_point_from = rp.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement   ne_from           ON ne_from.obj_id = re_from.obj_id
      LEFT JOIN qgep_od.channel                     CH_from           ON CH_from.obj_id = ne_from.fk_wastewater_structure
      LEFT JOIN qgep_vl.channel_function_hierarchic vl_fct_hier_from  ON CH_from.function_hierarchic = vl_fct_hier_from.code
      LEFT JOIN qgep_vl.channel_usage_current       vl_usg_curr_from  ON CH_from.usage_current = vl_usg_curr_from.code
      LEFT JOIN qgep_od.reach                       re_to          ON re_to.fk_reach_point_to = rp.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement   ne_to          ON ne_to.obj_id = re_to.obj_id
      LEFT JOIN qgep_od.channel                     CH_to          ON CH_to.obj_id = ne_to.fk_wastewater_structure
      LEFT JOIN qgep_vl.channel_function_hierarchic vl_fct_hier_to ON CH_to.function_hierarchic = vl_fct_hier_to.code
      LEFT JOIN qgep_vl.channel_usage_current       vl_usg_curr_to ON CH_to.usage_current = vl_usg_curr_to.code
    WHERE _all OR ws.obj_id = _obj_id
      WINDOW w AS ( PARTITION BY ws.obj_id ORDER BY vl_fct_hier_from.order_fct_hierarchic ASC NULLS LAST, vl_fct_hier_to.order_fct_hierarchic ASC NULLS LAST,
                                vl_usg_curr_from.order_usage_current ASC NULLS LAST, vl_usg_curr_to.order_usage_current ASC NULLS LAST ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) symbology_ws
WHERE symbology_ws.ws_obj_id = ws.obj_id;
END
$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater node symbology
-- Argument:
--  * obj_id of wastewater networkelement or NULL to update all
--------------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.update_wastewater_node_symbology(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
BEGIN

-- Otherwise this will result in very slow query due to on_structure_part_change_networkelement
-- being triggered for all rows. See https://github.com/QGEP/datamodel/pull/166#issuecomment-760245405
IF _all THEN
  RAISE INFO 'Temporarily disabling symbology triggers';
  PERFORM qgep_sys.drop_symbology_triggers();
END IF;


UPDATE qgep_od.wastewater_node n
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
      qgep_od.wastewater_networkelement ne
      LEFT JOIN qgep_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      LEFT JOIN qgep_od.reach                       re_from           	ON re_from.fk_reach_point_from = rp.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement   ne_from           	ON ne_from.obj_id = re_from.obj_id
      LEFT JOIN qgep_od.channel                     CH_from           	ON CH_from.obj_id = ne_from.fk_wastewater_structure
      LEFT JOIN qgep_od.wastewater_structure        ws_from           	ON ws_from.obj_id = ne_from.fk_wastewater_structure
      LEFT JOIN qgep_vl.channel_function_hierarchic vl_fct_hier_from	ON CH_from.function_hierarchic = vl_fct_hier_from.code
      LEFT JOIN qgep_vl.channel_usage_current       vl_usg_curr_from	ON CH_from.usage_current = vl_usg_curr_from.code

      LEFT JOIN qgep_od.reach                       re_to          	ON re_to.fk_reach_point_to = rp.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement   ne_to          	ON ne_to.obj_id = re_to.obj_id
      LEFT JOIN qgep_od.channel                     CH_to          	ON CH_to.obj_id = ne_to.fk_wastewater_structure
      LEFT JOIN qgep_od.wastewater_structure        ws_to           	ON ws_to.obj_id = ne_to.fk_wastewater_structure
      LEFT JOIN qgep_vl.channel_function_hierarchic vl_fct_hier_to 	ON CH_to.function_hierarchic = vl_fct_hier_to.code
      LEFT JOIN qgep_vl.channel_usage_current       vl_usg_curr_to 	ON CH_to.usage_current = vl_usg_curr_to.code
    WHERE _all OR ne.obj_id = _obj_id
      WINDOW w AS ( PARTITION BY ne.obj_id ORDER BY vl_fct_hier_from.order_fct_hierarchic ASC NULLS LAST, vl_fct_hier_to.order_fct_hierarchic ASC NULLS LAST,
                                vl_usg_curr_from.order_usage_current ASC NULLS LAST, vl_usg_curr_to.order_usage_current ASC NULLS LAST ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) symbology_ne
WHERE symbology_ne.ne_obj_id = n.obj_id;

-- See above
IF _all THEN
  RAISE INFO 'Reenabling symbology triggers';
  PERFORM qgep_sys.create_symbology_triggers();
END IF;

END
$BODY$
LANGUAGE plpgsql
VOLATILE;


  -------------------- SYMBOLOGY UPDATE ON CHANNEL TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION qgep_od.ws_symbology_update_by_channel()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_from_id TEXT;
  _ne_from_id TEXT;
  _ws_to_id TEXT;
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
    SELECT ws.obj_id, ne.obj_id INTO _ws_from_id, _ne_from_id
      FROM qgep_od.wastewater_networkelement ch_ne
      LEFT JOIN qgep_od.reach re ON ch_ne.obj_id = re.obj_id
      LEFT JOIN qgep_od.reach_point rp ON re.fk_reach_point_from = rp.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      LEFT JOIN qgep_od.wastewater_structure ws ON ne.fk_wastewater_structure = ws.obj_id
      WHERE ch_ne.fk_wastewater_structure = ch_obj_id;
    EXECUTE qgep_od.update_wastewater_structure_symbology(_ws_from_id);
    EXECUTE qgep_od.update_wastewater_node_symbology(_ne_from_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_channel. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in QGEP.';
  END;
  
  BEGIN
    SELECT ws.obj_id, ne.obj_id INTO _ws_to_id, _ne_to_id
      FROM qgep_od.wastewater_networkelement ch_ne
      LEFT JOIN qgep_od.reach re ON ch_ne.obj_id = re.obj_id
      LEFT JOIN qgep_od.reach_point rp ON re.fk_reach_point_to = rp.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      LEFT JOIN qgep_od.wastewater_structure ws ON ne.fk_wastewater_structure = ws.obj_id
      WHERE ch_ne.fk_wastewater_structure = ch_obj_id;
    EXECUTE qgep_od.update_wastewater_structure_symbology(_ws_to_id);
    EXECUTE qgep_od.update_wastewater_node_symbology(_ne_to_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_channel. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in QGEP.';
  END;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;


  -------------------- SYMBOLOGY UPDATE ON REACH POINT TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION qgep_od.ws_symbology_update_by_reach_point()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_id TEXT;
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
    SELECT ws.obj_id, ne.obj_id INTO STRICT _ws_id, _ne_id
      FROM qgep_od.wastewater_structure ws
      LEFT JOIN qgep_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN qgep_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = rp_obj_id;

    EXECUTE qgep_od.update_wastewater_structure_symbology(_ws_id);
    EXECUTE qgep_od.update_wastewater_node_symbology(_ne_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_reach_point. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in QGEP.';
  END;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

  -------------------- SYMBOLOGY UPDATE ON REACH TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION qgep_od.ws_symbology_update_by_reach()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_from_id TEXT;
  _ne_from_id TEXT;
  _ws_to_id TEXT;
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
    SELECT ws.obj_id, ne.obj_id INTO STRICT _ws_from_id, _ne_from_id
      FROM qgep_od.reach re
      LEFT JOIN qgep_od.reach_point rp ON rp.obj_id = re.fk_reach_point_from
      LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
      LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
      WHERE re.obj_id = re_obj_id;
    EXECUTE qgep_od.update_wastewater_structure_symbology(_ws_from_id);
    EXECUTE qgep_od.update_wastewater_node_symbology(_ne_from_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_reach. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in QGEP.';
  END;

  BEGIN
    SELECT ws.obj_id, ne.obj_id INTO STRICT _ws_to_id, _ne_to_id
      FROM qgep_od.reach re
      LEFT JOIN qgep_od.reach_point rp ON rp.obj_id = re.fk_reach_point_to
      LEFT JOIN qgep_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
      LEFT JOIN qgep_od.wastewater_structure ws ON ws.obj_id = ne.fk_wastewater_structure
      WHERE re.obj_id = re_obj_id;
    EXECUTE qgep_od.update_wastewater_structure_symbology(_ws_to_id);
    EXECUTE qgep_od.update_wastewater_node_symbology(_ne_to_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- DO NOTHING, THIS CAN HAPPEN
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'TRIGGER ERROR ws_symbology_update_by_reach. Subquery shoud return exactly one row. This is not supposed to happen and indicates an isue with the trigger. The issue must be fixed in QGEP.';
  END;


  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater structure depth
-- Argument:
--  * obj_id of wastewater structure
--  * all True to update all
--------------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.update_depth(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
  UPDATE qgep_od.wastewater_structure ws
  SET _depth = depth
  FROM (
    SELECT WS.obj_id, CO.level - COALESCE(MIN(NO.bottom_level), MIN(RP.level)) as depth
      FROM qgep_od.wastewater_structure WS
      LEFT JOIN qgep_od.cover CO on WS.fk_main_cover = CO.obj_id
      LEFT JOIN qgep_od.wastewater_networkelement NE ON NE.fk_wastewater_structure = WS.obj_id
      RIGHT JOIN qgep_od.wastewater_node NO on NO.obj_id = NE.obj_id
      LEFT JOIN qgep_od.reach_point RP ON RP.fk_wastewater_networkelement = NE.obj_id
      WHERE _all OR WS.obj_id = _obj_id
      GROUP BY WS.obj_id, CO.level
  ) ws_depths
  where ws.obj_id = ws_depths.obj_id;
END

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
      				 


CREATE OR REPLACE FUNCTION qgep_od.update_wastewater_structure_label(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
UPDATE qgep_od.wastewater_structure ws
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
    FROM qgep_od.wastewater_structure WS

    LEFT JOIN (      
      SELECT coalesce(round(CO.level, 2)::text, '?') AS co_level, NULL::text AS rpi_level, NULL::text AS rpo_level, SP.fk_wastewater_structure ws, SP.obj_id, row_number() OVER(PARTITION BY SP.fk_wastewater_structure) AS idx, NULL::text AS bottom_level
      FROM qgep_od.structure_part SP
      RIGHT JOIN qgep_od.cover CO ON CO.obj_id = SP.obj_id
      WHERE _all OR SP.fk_wastewater_structure = _obj_id
      -- Inputs
      UNION
      SELECT NULL AS co_level, coalesce(round(RP.level, 2)::text, '?') AS rpi_level, NULL::text AS rpo_level, NE.fk_wastewater_structure ws, RP.obj_id, row_number() OVER(PARTITION BY NE.fk_wastewater_structure ORDER BY ST_Azimuth(RP.situation_geometry,ST_PointN(RE_to.progression_geometry,-2))/pi()*180 ASC), NULL::text AS bottom_level
      FROM qgep_od.reach_point RP
      LEFT JOIN qgep_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
      INNER JOIN qgep_od.reach RE_to ON RP.obj_id = RE_to.fk_reach_point_to
      LEFT JOIN qgep_od.wastewater_networkelement NE_to ON NE_to.obj_id = RE_to.obj_id
      LEFT JOIN qgep_od.channel CH_to ON NE_to.fk_wastewater_structure = CH_to.obj_id
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and CH_to.function_hierarchic in (5062,5064,5066,5068,5069,5070,5071,5072,5074)  ----label only reaches with function_hierarchic=pwwf.*
      -- Outputs
      UNION
      SELECT NULL AS co_level, NULL::text AS rpi_level, 
		coalesce(round(RP.level, 2)::text, '?') AS rpo_level, 
		NE.fk_wastewater_structure ws, RP.obj_id, 
		row_number() OVER(PARTITION BY NE.fk_wastewater_structure 
						  ORDER BY array_position(ARRAY[4522,4526,4524,4516,4514,4518,520,4571,5322], ch.usage_current),
						  ST_Azimuth(RP.situation_geometry,ST_PointN(RE_from.progression_geometry,2))/pi()*180 ASC), 
		NULL::text AS bottom_level
      FROM qgep_od.reach_point RP
      LEFT JOIN qgep_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
      INNER JOIN qgep_od.reach RE_from ON RP.obj_id = RE_from.fk_reach_point_from
	  LEFT JOIN qgep_od.wastewater_networkelement NE_RE ON NE_RE.obj_id::text = RE_from.obj_id::text
	  LEFT JOIN qgep_od.wastewater_structure ws ON NE_RE.fk_wastewater_structure::text = ws.obj_id::text
      LEFT JOIN qgep_od.channel ch ON ch.obj_id::text = ws.obj_id::text
      WHERE CASE WHEN _obj_id IS NULL THEN TRUE ELSE NE.fk_wastewater_structure = _obj_id END
      -- Bottom
      UNION
      SELECT NULL AS co_level, NULL::text AS rpi_level, NULL::text AS rpo_level, ws1.obj_id ws, NULL, NULL, round(wn.bottom_level, 2)::text AS wn_bottom_level
      FROM qgep_od.wastewater_structure ws1
      LEFT JOIN qgep_od.wastewater_node wn ON wn.obj_id = ws1.fk_main_wastewater_node
      WHERE _all OR ws1.obj_id = _obj_id
	)AS parts ON ws = ws.obj_id
    WHERE _all OR ws.obj_id = _obj_id
	  ) parts
  GROUP BY ws_obj_id, COALESCE(ws_identifier, '')
) labeled_ws
WHERE ws.obj_id = labeled_ws.ws_obj_id;

END

$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------
-- ON COVER CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_cover_change()
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
  FROM qgep_od.structure_part SP
  WHERE obj_id = co_obj_id;

  EXECUTE qgep_od.update_wastewater_structure_label(affected_sp.fk_wastewater_structure);
  EXECUTE qgep_od.update_depth(affected_sp.fk_wastewater_structure);

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;




--------------------------------------------------
-- ON STRUCTURE PART / NETWORKELEMENT CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_structure_part_change_networkelement()
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
    EXECUTE qgep_od.update_wastewater_structure_label(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;



--------------------------------------------------
-- ON WASTEWATER STRUCTURE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_wastewater_structure_update()
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
  SELECT qgep_od.update_wastewater_structure_label(_ws_obj_id) INTO NEW._label;

  IF OLD.fk_main_cover != NEW.fk_main_cover THEN
    EXECUTE qgep_od.update_depth(_ws_obj_id);
  END IF;


  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- ON REACH CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_reach_change()
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
      FROM qgep_od.wastewater_structure ws
      LEFT JOIN qgep_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN qgep_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = ANY ( rp_obj_ids )
  LOOP
    EXECUTE qgep_od.update_wastewater_structure_label(_ws_obj_id);
    EXECUTE qgep_od.update_depth(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;


--------------------------------------------------
-- ON REACH DELETE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_reach_delete()
  RETURNS trigger AS
$BODY$
DECLARE
  channel_id text;
  reach_count integer;
BEGIN
  -- get channel obj_id
  SELECT fk_wastewater_structure INTO channel_id
    FROM qgep_od.wastewater_networkelement
    WHERE wastewater_networkelement.obj_id = OLD.obj_id;

  DELETE FROM qgep_od.wastewater_networkelement WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep_od.reach_point WHERE obj_id = OLD.fk_reach_point_from;
  DELETE FROM qgep_od.reach_point WHERE obj_id = OLD.fk_reach_point_to;

  -- delete channel if no reach left
  SELECT COUNT(fk_wastewater_structure) INTO reach_count
    FROM qgep_od.wastewater_networkelement
    WHERE fk_wastewater_structure = channel_id;
  IF reach_count = 0 THEN
    RAISE NOTICE 'Removing channel (%) since no reach is left', channel_id;
    DELETE FROM qgep_od.channel WHERE obj_id = channel_id;
    DELETE FROM qgep_od.wastewater_structure WHERE obj_id = channel_id;
  END IF;
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- ON WASTEWATER NODE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_wasterwaternode_change()
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
  FROM qgep_od.wastewater_networkelement ne
  WHERE obj_id = co_obj_id;

  EXECUTE qgep_od.update_depth(affected_sp.fk_wastewater_structure);
  EXECUTE qgep_od.update_wastewater_structure_label(affected_sp.fk_wastewater_structure);

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- ON REACH POINT CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.on_reach_point_update()
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


  UPDATE qgep_od.reach
    SET progression_geometry = progression_geometry
    WHERE fk_reach_point_from = rp_obj_id OR fk_reach_point_to = rp_obj_id; --To retrigger the calculate_length trigger on reach update

  FOREACH ne_obj_id IN ARRAY ne_obj_ids
  LOOP
      SELECT ws.obj_id INTO _ws_obj_id
      FROM qgep_od.wastewater_structure ws
      LEFT JOIN qgep_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN qgep_od.reach_point rp ON ne.obj_id = ne_obj_id;

      EXECUTE qgep_od.update_wastewater_structure_label(_ws_obj_id);
      EXECUTE qgep_od.update_depth(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- CALCULATE REACH LENGTH
--------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_od.calculate_reach_length()
  RETURNS trigger AS
$BODY$

DECLARE
	_rp_from_level numeric(7,3);
	_rp_to_level numeric(7,3);

BEGIN

  SELECT rp_from.level INTO _rp_from_level
  FROM qgep_od.reach_point rp_from
  WHERE NEW.fk_reach_point_from = rp_from.obj_id;

  SELECT rp_to.level INTO _rp_to_level
  FROM qgep_od.reach_point rp_to
  WHERE NEW.fk_reach_point_to = rp_to.obj_id;

  NEW.length_effective = COALESCE(sqrt((_rp_from_level - _rp_to_level)^2 + ST_Length(NEW.progression_geometry)^2), ST_Length(NEW.progression_geometry) );

  RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-----------------------------------------------------------------------
-- Drop Symbology Triggers
-- To temporarily disable these cache refreshes for batch jobs like migrations
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_sys.drop_symbology_triggers() RETURNS VOID AS $$
BEGIN
  DROP TRIGGER IF EXISTS on_reach_point_update ON qgep_od.reach_point;
  DROP TRIGGER IF EXISTS on_reach_2_change ON qgep_od.reach;
  DROP TRIGGER IF EXISTS on_reach_1_delete ON qgep_od.reach;
  DROP TRIGGER IF EXISTS on_wastewater_structure_update ON qgep_od.wastewater_structure;
  DROP TRIGGER IF EXISTS ws_label_update_by_wastewater_networkelement ON qgep_od.wastewater_networkelement;
  DROP TRIGGER IF EXISTS on_structure_part_change ON qgep_od.structure_part;
  DROP TRIGGER IF EXISTS on_cover_change ON qgep_od.cover;
  DROP TRIGGER IF EXISTS on_wasterwaternode_change ON qgep_od.wastewater_node;
  DROP TRIGGER IF EXISTS ws_symbology_update_by_reach ON qgep_od.reach;
  DROP TRIGGER IF EXISTS ws_symbology_update_by_channel ON qgep_od.channel;
  DROP TRIGGER IF EXISTS ws_symbology_update_by_reach_point ON qgep_od.reach_point;
  DROP TRIGGER IF EXISTS calculate_reach_length ON qgep_od.reach;
  RETURN;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------
-- Create Symbology Triggers
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION qgep_sys.create_symbology_triggers() RETURNS VOID AS $$
BEGIN
  -- only update -> insert and delete are handled by reach trigger
  CREATE TRIGGER on_reach_point_update
  AFTER UPDATE
    ON qgep_od.reach_point
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_reach_point_update();

  CREATE TRIGGER on_reach_2_change
  AFTER INSERT OR UPDATE OR DELETE
    ON qgep_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_reach_change();

  CREATE TRIGGER on_reach_1_delete
  AFTER DELETE
    ON qgep_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_reach_delete();

  CREATE TRIGGER calculate_reach_length
  BEFORE INSERT OR UPDATE
    ON qgep_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.calculate_reach_length();

  CREATE TRIGGER ws_symbology_update_by_reach
  AFTER INSERT OR UPDATE OR DELETE
    ON qgep_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.ws_symbology_update_by_reach();

  CREATE TRIGGER on_wastewater_structure_update
  AFTER UPDATE
    ON qgep_od.wastewater_structure
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_wastewater_structure_update();

  CREATE TRIGGER ws_label_update_by_wastewater_networkelement
  AFTER INSERT OR UPDATE OR DELETE
    ON qgep_od.wastewater_networkelement
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_structure_part_change_networkelement();

  CREATE TRIGGER on_structure_part_change
  AFTER INSERT OR UPDATE OR DELETE
    ON qgep_od.structure_part
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_structure_part_change_networkelement();

  CREATE TRIGGER on_cover_change
  AFTER INSERT OR UPDATE OR DELETE
    ON qgep_od.cover
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_cover_change();

  CREATE TRIGGER on_wasterwaternode_change
  AFTER INSERT OR UPDATE
    ON qgep_od.wastewater_node
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.on_wasterwaternode_change();

  CREATE TRIGGER ws_symbology_update_by_channel
  AFTER INSERT OR UPDATE OR DELETE
  ON qgep_od.channel
  FOR EACH ROW
  EXECUTE PROCEDURE qgep_od.ws_symbology_update_by_channel();

  -- only update -> insert and delete are handled by reach trigger
  CREATE TRIGGER ws_symbology_update_by_reach_point
  AFTER UPDATE
    ON qgep_od.reach_point
  FOR EACH ROW
    EXECUTE PROCEDURE qgep_od.ws_symbology_update_by_reach_point();


  RETURN;
END;
$$ LANGUAGE plpgsql;

-- Activate triggers by default
SELECT qgep_sys.create_symbology_triggers();