-- Funktion zum Mapping der Organisations-ID

CREATE OR REPLACE FUNCTION {ext_schema}.convert_organisationid_to_vsa(oid varchar)
RETURNS varchar(16)
AS
$BODY$
DECLARE
	out_oid varchar(16);
BEGIN
	SELECT obj_id INTO out_oid FROM tww_od.organisation WHERE right(obj_id,8) = right(oid,8);
	return out_oid;
END;
$BODY$
LANGUAGE plpgsql;


-- wird für Updates von letzte_aenderung_wi/gep genutzt
CREATE TABLE IF NOT EXISTS tww_cfg.agxx_last_modification_updater(
	username varchar(200) PRIMARY KEY
	, ag_update_type varchar(4) NOT NULL
	, CONSTRAINT ag_update_type_valid CHECK (ag_update_type = ANY(ARRAY['None','WI','GEP','Both'])));

------------------
-- System tables
------------------
INSERT INTO tww_sys.dictionary_od_table (id, tablename, shortcut_en) VALUES
(2999998,'measure_text','MX'),
(2999999,'building_group_text','GX')
ON CONFLICT DO NOTHING;

-----------------------------------------------------------------------
-- Drop Symbology Triggers
-- To temporarily disable these cache refreshes for batch jobs like migrations
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tww_sys.disable_symbology_triggers() RETURNS VOID AS $$
DECLARE
	nm text;
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
  -- AG-64/96 extension
  IF EXISTS
  ( SELECT 1 FROM information_schema.triggers WHERE event_object_schema = 'tww_od'
    AND event_object_table = 'wastewater_networkelement'
    AND trigger_name = 'before_networkelement_change'
  ) THEN
    ALTER TABLE tww_od.wastewater_networkelement DISABLE TRIGGER before_networkelement_change;
  ELSE NULL;
  END IF;
    IF EXISTS
  ( SELECT 1 FROM information_schema.triggers WHERE event_object_schema = 'tww_od'
    AND event_object_table = 'overflow'
    AND trigger_name = 'before_overflow_change'
  ) THEN
     ALTER TABLE tww_od.overflow DISABLE TRIGGER before_overflow_change;
  ELSE NULL;
  END IF;
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
  -- AG-64/96 extension
  IF EXISTS
  ( SELECT 1 FROM information_schema.triggers WHERE event_object_schema = 'tww_od'
    AND event_object_table = 'wastewater_networkelement'
    AND trigger_name = 'before_networkelement_change'
  ) THEN
    ALTER TABLE tww_od.wastewater_networkelement ENABLE TRIGGER before_networkelement_change;
  ELSE NULL;
  END IF;
    IF EXISTS
  ( SELECT 1 FROM information_schema.triggers WHERE event_object_schema = 'tww_od'
    AND event_object_table = 'overflow'
    AND trigger_name = 'before_overflow_change'
  ) THEN
     ALTER TABLE tww_od.overflow ENABLE TRIGGER before_overflow_change;
  ELSE NULL;
  END IF;
  RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION tww_sys.check_symbology_triggers_enabled(
	)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
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
	-- AG-64/96 extension
	or tgname='before_networkelement_change'
	or tgname='before_overflow_change'
  ) AND tgenabled = 'D';

  IF _disabled_count=0 THEN
    return true;
  ELSE
    return false;
  END IF;

END;
$BODY$;
