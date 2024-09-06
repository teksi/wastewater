
-----------------------------------------------------------------------
-- Enable or disable Symbology Triggers
-- To temporarily disable these cache refreshes for batch jobs like migrations
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION tww_app.alter_symbology_triggers(action_name text) RETURNS VOID AS
$DO$
DECLARE
	schdf text;
	tbldf text;
	trig text;
BEGIN
IF NOT (action_name ILIKE ANY(ARRAY['ENABLE','DISABLE'])) THEN
	RAISE NOTICE '% not a valid input',action_name;
	RETURN;
ELSE
	FOR schdf,tbldf, trig IN
		SELECT
		c.relnamespace ::regnamespace::text,
		c.relname,
		t.tgname
		FROM   pg_trigger t
		INNER JOIN pg_class c on t.tgrelid=c.oid
		INNER JOIN pg_proc p on t.tgfoid=p.oid
		WHERE p.proname  LIKE 'symbology_%'
		and p.pronamespace::regnamespace::text LIKE 'tww_ap_'
		LOOP
			EXECUTE FORMAT('ALTER TABLE %I.%I %s TRIGGER %I',schdf,tbldf,upper(action_name),trig);
		END LOOP;
		RETURN;
END IF;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;


-----------------------------------------------------------------------
-- Check if Symbology Triggers are enabled
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.check_symbology_triggers_enabled() RETURNS BOOL AS
$DO$
DECLARE _disabled_count numeric;
BEGIN
  SELECT count(*) into _disabled_count
		FROM   pg_trigger t
		INNER JOIN pg_class c on t.tgrelid=c.oid
		INNER JOIN pg_proc p on t.tgfoid=p.oid
		WHERE p.proname  LIKE 'symbology_%'
		and p.pronamespace::regnamespace::text LIKE 'tww_ap_'
		AND t.tgenabled = 'D';
  RETURN _disabled_count=0;
END;
$DO$ LANGUAGE plpgsql SECURITY DEFINER;

--------------------------------------------------------
-- UPDATE wastewater node symbology by channel
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
  PERFORM tww_app.alter_symbology_triggers('disable');
END IF;


UPDATE tww_od.wastewater_node n
SET
  _function_hierarchic = function_hierarchic,
  _usage_current = usage_current,
  _status = status
FROM(
  SELECT DISTINCT ON (wn.obj_id) wn.obj_id AS wn_obj_id,
      COALESCE(first_value(CH_from.function_hierarchic) OVER w
              , first_value(CH_to.function_hierarchic) OVER w) AS function_hierarchic,
      COALESCE(first_value(CH_from.usage_current) OVER w
              , first_value(CH_to.usage_current) OVER w) AS usage_current,
      COALESCE(first_value(ws_node.status) OVER w
             , first_value(ws_from.status) OVER w
             , first_value(ws_to.status) OVER w) AS status,
      rank() OVER w AS hierarchy_rank
    FROM
      tww_od.wastewater_node wn
      LEFT JOIN tww_od.wastewater_networkelement   ne                   ON ne.obj_id = wn.obj_id
	  LEFT JOIN tww_od.wastewater_structure        ws_node              ON ws_node.obj_id = ne.fk_wastewater_structure

	  LEFT JOIN tww_od.reach_point                 rp                   ON wn.obj_id = rp.fk_wastewater_networkelement
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

    WHERE _all OR wn.obj_id = _obj_id
      WINDOW w AS ( PARTITION BY wn.obj_id
                    ORDER BY vl_fct_hier_from.tww_symbology_order ASC NULLS LAST
                           , vl_fct_hier_to.tww_symbology_order ASC NULLS LAST

                           , vl_usg_curr_from.tww_symbology_order ASC NULLS LAST
                           , vl_usg_curr_to.tww_symbology_order ASC NULLS LAST
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) symbology_ne
WHERE symbology_ne.wn_obj_id = n.obj_id;

EXECUTE tww_app.update_wn_symbology_by_overflow(_obj_id, _all);

-- See above
IF _all THEN
  RAISE INFO 'Reenabling symbology triggers';
  PERFORM tww_app.alter_symbology_triggers('enable');
END IF;

END
$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater node symbology by overflow
-- Argument:
--  * obj_id of wastewater networkelement or NULL to update all
--------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.update_wn_symbology_by_overflow(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
BEGIN

-- Otherwise this will result in very slow query due to on_structure_part_change_networkelement
-- being triggered for all rows. See https://github.com/QGEP/datamodel/pull/166#issuecomment-760245405 //skip-keyword-check
IF _all THEN
  RAISE INFO 'Temporarily disabling symbology triggers';
  PERFORM tww_app.alter_symbology_triggers('disable');
END IF;


UPDATE tww_od.wastewater_node n
SET
  _function_hierarchic = function_hierarchic,
  _usage_current = usage_current,
  _status = status
FROM(
        SELECT DISTINCT ON (wn.obj_id) wn.obj_id AS wn_obj_id,
      COALESCE(first_value(wn._function_hierarchic) OVER w
              , first_value(wn_from._function_hierarchic) OVER w) AS function_hierarchic,
      COALESCE(first_value(wn._usage_current) OVER w
              , first_value(wn_from._usage_current) OVER w) AS usage_current,
      COALESCE(first_value(wn._status) OVER w
             , first_value(wn_from._status) OVER w) AS status
    FROM
	  tww_od.overflow                    ov
	  LEFT JOIN tww_od.wastewater_node 			   wn	  	  ON ov.fk_overflow_to=wn.obj_id
      LEFT JOIN tww_od.wastewater_networkelement   ne_ov      ON ne_ov.obj_id = ov.fk_wastewater_node
      LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier	ON wn._function_hierarchic = vl_fct_hier.code
      LEFT JOIN tww_vl.channel_usage_current       vl_usg_curr	ON wn._usage_current = vl_usg_curr.code

	  LEFT JOIN tww_od.wastewater_node			   wn_from	  ON ne_ov.obj_id = wn_from.obj_id
	  LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier_from	ON wn_from._function_hierarchic = vl_fct_hier_from.code
      LEFT JOIN tww_vl.channel_usage_current       vl_usg_curr_from	ON wn_from._usage_current = vl_usg_curr_from.code
	  WHERE (_all OR wn.obj_id = _obj_id)
      WINDOW w AS ( PARTITION BY wn.obj_id
                    ORDER BY vl_fct_hier.tww_symbology_order ASC NULLS LAST
                           , vl_fct_hier_from.tww_symbology_order ASC NULLS LAST

                           , vl_usg_curr.tww_symbology_order ASC NULLS LAST
                           , vl_usg_curr_from.tww_symbology_order ASC NULLS LAST
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) symbology_ne
WHERE symbology_ne.wn_obj_id = n.obj_id
 	  AND TRUE = ANY(array[n._function_hierarchic IS NULL
					  ,n._usage_current IS NULL
					  ,n._status IS NULL]);

-- See above
IF _all THEN
  RAISE INFO 'Reenabling symbology triggers';
  PERFORM tww_app.alter_symbology_triggers('enable');
END IF;

END
$BODY$
LANGUAGE plpgsql
VOLATILE;

  -------------------- SYMBOLOGY UPDATE ON CHANNEL TABLE CHANGES ----------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_update_by_channel()
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

CREATE OR REPLACE FUNCTION tww_app.symbology_update_by_reach_point()
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
--  * obj_id of wastewater structure. No change if fk_main_cover is not null
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
      WHERE ch.obj_id IS NULL AND (_all OR ((ws.obj_id = _obj_id OR (NOT _all AND _obj_id is NULL)) AND ws.fk_main_cover IS NULL))
  ) ws_covers
  WHERE ws.obj_id = ws_covers.obj_id;
END

$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------------
-- UPDATE wastewater structure fk_main_wastewater_node
-- Argument:
--  * obj_id of wastewater structure. No change if fk_main_wastewater_node is not null
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
      WHERE ch.obj_id IS NULL AND (_all OR ((ws.obj_id = _obj_id OR (NOT _all AND _obj_id is NULL)) AND ws.fk_main_wastewater_node IS NULL))
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

