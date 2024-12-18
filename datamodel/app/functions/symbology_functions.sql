
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

CREATE OR REPLACE FUNCTION tww_app.update_wastewater_node_symbologies(_obj_ids text[], _all boolean default false)
  RETURNS VOID AS
  $BODY$
BEGIN

DELETE FROM tww_od.tww_wastewater_node_symbology
WHERE fk_wastewater_node IN(_obj_ids);

INSERT INTO tww_od.tww_wastewater_node_symbology (fk_wastewater_node,_function_hierarchic,_usage_current,_status)
  SELECT DISTINCT ON (wn.obj_id) wn.obj_id AS wn_obj_id,
      COALESCE(first_value(CH_from.function_hierarchic) OVER w
              , first_value(CH_to.function_hierarchic) OVER w) AS function_hierarchic,
      COALESCE(first_value(CH_from.usage_current) OVER w
              , first_value(CH_to.usage_current) OVER w) AS usage_current,
      COALESCE(first_value(ws_node.status) OVER w
             , first_value(ws_from.status) OVER w
             , first_value(ws_to.status) OVER w) AS status
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

    WHERE _all OR wn.obj_id =ANY(_obj_ids)
      WINDOW w AS ( PARTITION BY wn.obj_id
                    ORDER BY coalesce(vl_fct_hier_to.tww_symbology_inflow_prio,false) DESC
						   , vl_fct_hier_from.tww_symbology_order ASC NULLS LAST
                           , vl_fct_hier_to.tww_symbology_order ASC NULLS LAST

                           , vl_usg_curr_from.tww_symbology_order ASC NULLS LAST
                           , vl_usg_curr_to.tww_symbology_order ASC NULLS LAST
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);

-- by overflow
UPDATE tww_od.tww_wastewater_node_symbology n
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
	  LEFT JOIN tww_od.tww_wastewater_node_symbology wn	  	  ON ov.fk_overflow_to=wn.obj_id
      LEFT JOIN tww_od.wastewater_networkelement   ne_ov      ON ne_ov.obj_id = ov.fk_wastewater_node
      LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier	ON wn._function_hierarchic = vl_fct_hier.code
      LEFT JOIN tww_vl.channel_usage_current       vl_usg_curr	ON wn._usage_current = vl_usg_curr.code

	  LEFT JOIN tww_od.tww_wastewater_node_symbology wn_from	  ON ne_ov.obj_id = wn_from.obj_id
	  LEFT JOIN tww_vl.channel_function_hierarchic vl_fct_hier_from	ON wn_from._function_hierarchic = vl_fct_hier_from.code
      LEFT JOIN tww_vl.channel_usage_current       vl_usg_curr_from	ON wn_from._usage_current = vl_usg_curr_from.code
	  WHERE (_all OR wn.obj_id = ANY(_obj_ids))
      WINDOW w AS ( PARTITION BY wn.obj_id
                    ORDER BY coalesce(vl_fct_hier.tww_symbology_inflow_prio,false) DESC
						   , vl_fct_hier.tww_symbology_order ASC NULLS LAST
                           , vl_fct_hier_from.tww_symbology_order ASC NULLS LAST

                           , vl_usg_curr.tww_symbology_order ASC NULLS LAST
                           , vl_usg_curr_from.tww_symbology_order ASC NULLS LAST
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) symbology_ne
WHERE symbology_ne.wn_obj_id = n.fk_wastewater_node
 	  AND TRUE = ANY(array[n._function_hierarchic IS NULL
					  ,n._usage_current IS NULL
					  ,n._status IS NULL]);

END
$BODY$
LANGUAGE plpgsql
VOLATILE;




--------------------------------------------------------
-- SYMBOLOGY UPDATE ON CHANNEL TABLE CHANGES
--------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_update_by_channel()
  RETURNS trigger AS
$BODY$
DECLARE

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

    INSERT INTO tww_od.tww_symbology_quarantine(obj_id)
    SELECT ne.obj_id
      FROM tww_od.wastewater_networkelement ch_ne
      LEFT JOIN tww_od.reach re ON ch_ne.obj_id = re.obj_id
      LEFT JOIN tww_od.reach_point rp ON re.fk_reach_point_from = rp.obj_id
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      WHERE ch_ne.fk_wastewater_structure = ch_obj_id
    UNION
    SELECT ne.obj_id
      FROM tww_od.wastewater_networkelement ch_ne
      LEFT JOIN tww_od.reach re ON ch_ne.obj_id = re.obj_id
      LEFT JOIN tww_od.reach_point rp ON re.fk_reach_point_to = rp.obj_id
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      WHERE ch_ne.fk_wastewater_structure = ch_obj_id
    ON CONFLICT DO NOTHING;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER ws_symbology_update_by_channel
AFTER INSERT OR UPDATE OR DELETE
ON tww_od.channel
FOR EACH ROW
EXECUTE PROCEDURE tww_app.symbology_update_by_channel();


--------------------------------------------------------
-- SYMBOLOGY UPDATE ON REACH POINT TABLE CHANGES
--------------------------------------------------------

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

    INSERT INTO tww_od.tww_symbology_quarantine(obj_id)
	SELECT ne.obj_id INTO STRICT _ne_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = rp_obj_id
    ON CONFLICT DO NOTHING;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

-- only update -> insert and delete are handled by reach trigger
CREATE TRIGGER ws_symbology_update_by_reach_point
AFTER UPDATE
  ON tww_od.reach_point
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_update_by_reach_point();



--------------------------------------------------------
-- SYMBOLOGY UPDATE ON REACH TABLE CHANGES
--------------------------------------------------------

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

    INSERT INTO tww_od.tww_symbology_quarantine(obj_id)
	SELECT ne.obj_id
      FROM tww_od.reach re
      LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_from
      LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE re.obj_id = re_obj_id
	UNION
    SELECT ne.obj_id INTO STRICT _ne_to_id
      FROM tww_od.reach re
      LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_to
      LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE re.obj_id = re_obj_id
   ON CONFLICT DO NOTHING;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER ws_symbology_update_by_reach
AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.reach
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.ws_symbology_update_by_reach();

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

CREATE OR REPLACE FUNCTION tww_app.update_depth(_obj_id, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN
  UPDATE tww_od.wastewater_structure ws
  SET _depth = calc_depth
  FROM (
    SELECT WS.obj_id, CO.level - COALESCE(MIN(NO.bottom_level), MIN(RP.level)) as calc_depth
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


--------------------------------------------------
-- ON COVER CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_cover_change()
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

  INSERT INTO tww_od.tww_symbology_quarantine(obj_id) VALUES (affected_sp.fk_wastewater_structure) ON CONFLICT DO NOTHING;
  EXECUTE tww_app.wastewater_structure_update_fk_main_cover(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.update_depth(affected_sp.fk_wastewater_structure);
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_cover_change
AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.cover
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_cover_change();


--------------------------------------------------
-- ON STRUCTURE PART / NETWORKELEMENT CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_structure_part_change_networkelement()
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
    INSERT INTO tww_od.tww_symbology_quarantine(obj_id) VALUES (_ws_obj_id) ON CONFLICT DO NOTHING;
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER ws_label_update_by_wastewater_networkelement
AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.wastewater_networkelement
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_structure_part_change_networkelement();

CREATE TRIGGER on_structure_part_change
AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.structure_part
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_structure_part_change_networkelement();


--------------------------------------------------
-- ON WASTEWATER STRUCTURE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_wastewater_structure_update()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_obj_id TEXT;
BEGIN
  -- Prevent recursion
  IF COALESCE(OLD.identifier, '') = COALESCE(NEW.identifier, '') THEN
    RETURN NEW;
  END IF;
  IF NOT EXISTS(SELECT 1 FROM tww_od.channel WHERE obj_id=OLD.obj_id) THEN
    _ws_obj_id= OLD.obj_id;
    INSERT INTO tww_od.tww_symbology_quarantine(obj_id) VALUES (_ws_obj_id) ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_wastewater_structure_update
AFTER UPDATE
  ON tww_od.wastewater_structure
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_wastewater_structure_update();

--------------------------------------------------
-- ON REACH CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_reach_change()
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

  INSERT INTO tww_od.tww_symbology_quarantine(obj_id) VALUES (_ws_obj_id);
    SELECT ws.obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = ANY ( rp_obj_ids )
  ON CONFLICT DO NOTHING;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_reach_2_change
AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.reach
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_reach_change();


--------------------------------------------------
-- ON WASTEWATER NODE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_wastewater_node_change()
  RETURNS trigger AS
$BODY$
DECLARE
  wn_obj_id TEXT;
  affected_ws RECORD;
BEGIN
  CASE
    WHEN TG_OP = 'UPDATE' THEN
      wn_obj_id = OLD.obj_id;
    WHEN TG_OP = 'INSERT' THEN
      wn_obj_id = NEW.obj_id;
    WHEN TG_OP = 'DELETE' THEN
      wn_obj_id = OLD.obj_id;
  END CASE;

  SELECT ne.fk_wastewater_structure INTO affected_ws
  FROM tww_od.wastewater_networkelement ne
  WHERE obj_id = wn_obj_id;

  INSERT INTO tww_od.tww_symbology_quarantine(obj_id) VALUES
  (affected_ws.fk_wastewater_structure),
  (wn_obj_id)
  ON CONFLICT DO NOTHING;

  EXECUTE tww_app.update_depth(affected_ws.fk_wastewater_structure);
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER on_wastewaternode_change
AFTER INSERT OR UPDATE
  ON tww_od.wastewater_node
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_wastewater_node_change();

--------------------------------------------------
-- ON REACH POINT CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_reach_point_update()
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
      INSERT INTO tww_od.tww_symbology_quarantine(obj_id)
	  SELECT ws.obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = ne_obj_id
	  ON CONFLICT DO NOTHING;
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

-- only update -> insert and delete are handled by reach trigger
CREATE TRIGGER on_reach_point_update
AFTER UPDATE
  ON tww_od.reach_point
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_on_reach_point_update();

--------------------------------------------------
-- CALCULATE REACH LENGTH
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_calculate_reach_length()
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

  IF _rp_from_level=0 OR _rp_to_level=0 THEN
    NEW.length_effective = ST_Length(NEW.progression3d_geometry);
  ELSE
    NEW.length_effective = COALESCE(sqrt((_rp_from_level - _rp_to_level)^2 + ST_Length(NEW.progression3d_geometry)^2), ST_Length(NEW.progression3d_geometry) );
  END IF;
  RETURN NEW;

END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER calculate_reach_length
BEFORE INSERT OR UPDATE
  ON tww_od.reach
FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_calculate_reach_length();


--------------------------------------------------
-- Recalculate symbologies and labels
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_recalculate()
  RETURNS trigger AS
$BODY$

DECLARE
	_wn_to_update text[];
	_ws_to_update text[];

BEGIN

  SELECT quarantine.obj_id INTO _wn_to_update
  FROM tww_od.tww_symbology_quarantine quarantine
  INNER JOIN tww_od.wastewater_node wn on wn.obj_id=quarantine.obj_id;

  EXECUTE tww_app.update_wastewater_node_symbologies(_wn_to_update);
  DELETE FROM tww_od.tww_symbology_quarantine WHERE obj_id=ANY(_wn_to_update);

  SELECT quarantine.obj_id INTO _ws_to_update
  FROM tww_od.tww_symbology_quarantine quarantine
  INNER JOIN tww_od.wastewater_structure ws on ws.obj_id=quarantine.obj_id;

  EXECUTE tww_app.update_wastewater_structure_labels(_ws_to_update);
  DELETE FROM tww_od.tww_symbology_quarantine WHERE obj_id=ANY(_ws_to_update);

END; $BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER recalculate_symbology
AFTER INSERT
  ON tww_od.tww_symbology_quarantine
FOR EACH STATEMENT
  EXECUTE PROCEDURE tww_app.symbology_recalculate();
