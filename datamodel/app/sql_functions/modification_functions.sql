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

-- default organisation

CREATE FUNCTION tww_app.modification_default_orgs_referencing() RETURNS trigger AS $$
DECLARE
 _schema_name TEXT;
 _table_name TEXT;
 _provider TEXT;
 _dataowner TEXT;
 parent_tbl TEXT;
BEGIN
 _schema_name := TG_ARGV[0];
 parent_tbl := TG_ARGV[1];
 fk_name := TG_ARGV[2];

 IF _schema_name IS NULL THEN
  _schema_name := 'tww_od';
 ELSE NULL;
 END IF;

 IF parent_tbl IS NOT NULL THEN
  EXECUTE FORMAT("SELECT fk_provider, fk_dataowner
  FROM %I.%I WHERE obj_id=NEW.obj_id",_schema_name,parent_tbl
  )
  INTO _provider, _dataowner;
 ELSE
  _provider := NEW.fk_provider;
  _dataowner := NEW.fk_dataowner;
 END IF;

 IF fk_name IS NULL THEN
  fk_name := 'fk_'||TG_TABLE_NAME;
  ELSE
  NULL;
 END IF;

 FOR _table_name IN unnest(TG_ARGV[1:array_length(TG_ARGV, 1)]) LOOP
 		_table_name := trim(_table_name);
        BEGIN
            EXECUTE format('
                UPDATE %I.%I
                SET fk_provider = %L,
                    fk_dataowner = %L
                WHERE %I = %L
            ',

                _schema_name,
                _table_name,
                _provider,
                _dataowner,
                fk_name,
                NEW.obj_id
            );
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Trigger %: Failed to update table %: %', TG_NAME, table_name, SQLERRM;
        END;
 END LOOP;
 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

COMMENT ON tww_app.modification_default_orgs_referencing()
IS 'accepts a parent table name as a first argument (if the caller is a child table) and all potential tables that might cascade from it as further argument';

CREATE FUNCTION tww_app.modification_default_orgs_referenced() RETURNS trigger AS $$
DECLARE
 _schema_name TEXT;
 _table_name TEXT;
 _provider TEXT;
 _dataowner TEXT;
 parent_tbl TEXT;
BEGIN
 _schema_name := TG_ARGV[0];
 parent_tbl := TG_ARGV[1];
 child_name := TG_ARGV[2];

 IF _schema_name IS NULL THEN
  _schema_name := 'tww_od';
 ELSE NULL;
 END IF;

 IF parent_tbl IS NOT NULL THEN
  EXECUTE FORMAT("SELECT fk_provider, fk_dataowner
  FROM %I.%I WHERE obj_id=NEW.obj_id",_schema_name,parent_tbl
  )
  INTO _provider, _dataowner;
 ELSE
  _provider := NEW.fk_provider;
  _dataowner := NEW.fk_dataowner;
 END IF;




 FOR _table_name IN unnest(TG_ARGV[3:array_length(TG_ARGV, 1)]) LOOP
 		_table_name := trim(_table_name);
     IF child_name IS NULL THEN
      FORMAT("SELECT fk_%
  FROM %I.%I WHERE obj_id=NEW.obj_id",_table_name, _schema_name, TG_TABLE_NAME
  )
      ELSE
        EXECUTE FORMAT("SELECT fk_provider, fk_dataowner
  FROM %I.%I WHERE obj_id=NEW.obj_id",_table_name, _schema_name, child_name
  )
  INTO _provider, _dataowner;
 END IF;
        BEGIN
            EXECUTE format('
                UPDATE %I.%I
                SET fk_provider = %L,
                    fk_dataowner = %L
                WHERE obj_id = NEW.fk_%I
            ',
                _schema_name,
                _table_name,
                _provider,
                _dataowner,
                fk_name
            );
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Trigger %: Failed to update table %.%: %', TG_NAME, _schema_name, _table_name, SQLERRM;
        END;
 END LOOP;
 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

COMMENT ON tww_app.modification_default_orgs_referenced()
IS 'accepts the following arguments:
1. schema name
2. parent_table: table in which the default values are taken (when TG_TABLE_NAME is a child table)
3. child_table:  table over which the default values are mapped (when TG_TABLE_NAME is a parent table)
4.+ all tables whose default values should be overwritten';
