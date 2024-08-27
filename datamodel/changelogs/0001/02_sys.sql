------ LAST MODIFIED -----
CREATE FUNCTION tww_sys.update_last_modified() RETURNS trigger AS $$
BEGIN
 NEW.last_modification := TIMEOFDAY();

 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION tww_sys.update_last_modified_parent() RETURNS trigger AS $$
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


-----------------------------------------------------------------------
-- Enable or disable Symbology Triggers
-- To temporarily disable these cache refreshes for batch jobs like migrations
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION tww_sys.alter_symbology_triggers(action_name text) RETURNS VOID AS
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
		and p.pronamespace::regnamespace::text = 'tww_app'
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

CREATE OR REPLACE FUNCTION tww_sys.check_symbology_triggers_enabled() RETURNS BOOL AS 
$DO$
DECLARE _disabled_count numeric;
BEGIN
  SELECT count(*) into _disabled_count
		FROM   pg_trigger t
		INNER JOIN pg_class c on t.tgrelid=c.oid
		INNER JOIN pg_proc p on t.tgfoid=p.oid
		WHERE p.proname  LIKE 'symbology_%'
		and p.pronamespace::regnamespace::text = 'tww_app'
		AND t.tgenabled = 'D';
  IF _disabled_count=0 THEN
    return true;
  ELSE
    return false;
  END IF;
END;
$DO$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE OR REPLACE FUNCTION tww_sys.alter_auto_updating_triggers (action_name text) RETURNS VOID AS
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
		WHERE (p.proname  LIKE 'update_last_modified%'
		AND p.pronamespace::regnamespace::text = 'tww_sys')
		OR( p.proname  LIKE 'autoupdate%'
		AND p.pronamespace::regnamespace::text = 'tww_app')
		LOOP
			EXECUTE FORMAT('ALTER TABLE %I.%I %s TRIGGER %I',schdf,tbldf,upper(action_name),trig);
		END LOOP;	
		
	RETURN;
END IF;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION tww_sys.check_auto_updating_enabled (action_name text) RETURNS BOOL AS
$DO$
DECLARE _disabled_count numeric;
BEGIN
  SELECT count(*) into _disabled_count
		FROM   pg_trigger t
		INNER JOIN pg_class c on t.tgrelid=c.oid
		INNER JOIN pg_proc p on t.tgfoid=p.oid
		WHERE(
		(p.proname  LIKE 'update_last_modified%'
		AND p.pronamespace::regnamespace::text = 'tww_sys')
		OR( p.proname  LIKE 'autoupdate%'
		AND p.pronamespace::regnamespace::text = 'tww_app')
		)
		AND t.tgenabled = 'D';
  IF _disabled_count=0 THEN
    return true;
  ELSE
    return false;
  END IF;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;
