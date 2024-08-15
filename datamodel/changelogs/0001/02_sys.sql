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
-- Drop Symbology Triggers
-- To temporarily disable these cache refreshes for batch jobs like migrations
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_sys.disable_symbology_triggers() RETURNS VOID AS $$
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

-----------------------------------------------------------------------
-- Check if Symbology Triggers are enabled
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_sys.check_symbology_triggers_enabled() RETURNS BOOL AS $$
DECLARE _disabled_count numeric;
BEGIN

  SELECT count(*) into _disabled_count FROM pg_trigger WHERE (
    tgname='on_reach_point_update' or
    tgname='on_reach_2_change' or
    tgname='on_reach_1_delete' or
    tgname='on_wastewater_structure_update' or
    tgname='ws_label_update_by_wastewater_networkelement' or
    tgname='on_structure_part_change' or
    tgname='on_cover_change' or
    tgname='on_wasterwaternode_change' or
    tgname='ws_symbology_update_by_reach' or
    tgname='ws_symbology_update_by_channel' or
    tgname='ws_symbology_update_by_reach_point' or
    tgname='calculate_reach_length'
  ) AND tgenabled = 'D';

  IF _disabled_count=0 THEN
    return true;
  ELSE
    return false;
  END IF;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE OR REPLACE FUNCTION tww_sys.alter_last_modification_triggers (action_name text) RETURNS VOID AS
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
		WHERE p.proname  LIKE 'update_last_modified%'
		and p.pronamespace::regnamespace::text = 'tww_sys'
		LOOP
			EXECUTE FORMAT('ALTER TABLE %I.%I %I TRIGGER %I',schdf,tbldf,upper(action_name),trig);
		END LOOP;
		RETURN;
END IF;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION tww_sys.check_last_modification_enabled (action_name text) RETURNS BOOL AS
$DO$
DECLARE _disabled_count numeric;
BEGIN
  SELECT count(*) into _disabled_count
		FROM   pg_trigger t
		INNER JOIN pg_class c on t.tgrelid=c.oid
		INNER JOIN pg_proc p on t.tgfoid=p.oid
		WHERE p.proname  LIKE 'update_last_modified%'
		and p.pronamespace::regnamespace::text = 'tww_sys'
		AND t.tgenabled = 'D';
  IF _disabled_count=0 THEN
    return true;
  ELSE
    return false;
  END IF;
END IF;
END;
$DO$
LANGUAGE plpgsql SECURITY DEFINER;