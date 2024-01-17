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


CREATE TABLE tww_sys.symbology_triggers( 
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4()
  , table_name text
  , trigger_name text);
COMMENT ON TABLE tww_sys.symbology_triggers IS 'Lists all symbology triggers to be disabled/enabled';
INSERT INTO tww_sys.symbology_triggers(table_name, trigger_name)
VALUES 
    ('tww_od.reach_point','on_reach_point_update')
  , ('tww_od.reach','on_reach_2_change')
  , ('tww_od.reach','on_reach_2_change')
  , ('tww_od.wastewater_structure','on_wastewater_structure_update')
  , ('tww_od.wastewater_networkelement','ws_label_update_by_wastewater_networkelement')
  , ('tww_od.structure_part','on_structure_part_change')
  , ('tww_od.cover','on_cover_change')
  , ('tww_od.wastewater_node','on_wasterwaternode_change')
  , ('tww_od.reach','ws_symbology_update_by_reach')
  , ('tww_od.channel','ws_symbology_update_by_channel')
  , ('tww_od.reach_point','ws_symbology_update_by_reach_point')
  , ('tww_od.reach','calculate_reach_length')
  