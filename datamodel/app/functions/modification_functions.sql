--------------------------------------------------
-- Alter modification triggers
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.alter_modification_triggers(action_name text) RETURNS VOID AS
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
		WHERE p.proname  LIKE 'modification_%'
		AND p.pronamespace::regnamespace::text = 'tww_app'
		LOOP
			EXECUTE FORMAT('ALTER TABLE %I.%I %s TRIGGER %I',schdf,tbldf,upper(action_name),trig);
		END LOOP;

	RETURN;
END IF;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;

--------------------------------------------------
-- Check if modification triggers are enabled
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.check_modification_enabled() RETURNS BOOL AS
$DO$
DECLARE _disabled_count numeric;
BEGIN
  SELECT count(*) into _disabled_count
		FROM   pg_trigger t
		INNER JOIN pg_class c on t.tgrelid=c.oid
		INNER JOIN pg_proc p on t.tgfoid=p.oid
		WHERE
		p.proname  LIKE 'modification_%'
		AND p.pronamespace::regnamespace::text = 'tww_app'

		AND t.tgenabled = 'D';
  RETURN _disabled_count=0;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;

--------------------------------------------------
-- ON REACH DELETE
--------------------------------------------------
-- Remove linked network element and reach points
-- Remove channel if no reach is left
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.modification_on_reach_delete()
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

CREATE TRIGGER on_reach_1_delete
AFTER DELETE
  ON tww_od.reach
 FOR EACH ROW
  EXECUTE PROCEDURE tww_app.modification_on_reach_delete();

--------------------------------------------------
-- LAST MODIFIED
--------------------------------------------------

CREATE FUNCTION tww_app.modification_last_modified() RETURNS trigger AS $$
BEGIN
 NEW.last_modification := TIMEOFDAY();

 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION tww_app.modification_last_modified_parent() RETURNS trigger AS $$
DECLARE
 table_name TEXT;
BEGIN
 table_name = TG_ARGV[0];

 EXECUTE '
 UPDATE ' || table_name || '
 SET last_modification = TIMEOFDAY()::timestamp
 WHERE obj_id = ''' || NEW.obj_id || '''
';
 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

