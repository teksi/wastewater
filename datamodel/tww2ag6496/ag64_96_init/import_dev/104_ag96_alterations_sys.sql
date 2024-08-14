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
  -- AG-64/96 extension
  ALTER TABLE tww_od.wastewater_networkelement DISABLE TRIGGER before_networkelement_change;
  ALTER TABLE tww_od.overflow DISABLE TRIGGER before_overflow_change;
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
  ALTER TABLE tww_od.wastewater_networkelement ENABLE TRIGGER before_networkelement_change;
  ALTER TABLE tww_od.overflow ENABLE TRIGGER before_overflow_change;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;