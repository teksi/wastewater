-- only update -> insert and delete are handled by reach trigger
  CREATE TRIGGER on_reach_point_update
  AFTER UPDATE
    ON tww_od.reach_point
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_on_reach_point_update();

  CREATE TRIGGER on_reach_2_change
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_on_reach_change();

  CREATE TRIGGER on_reach_1_delete
  AFTER DELETE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.modification_on_reach_delete();

  CREATE TRIGGER calculate_reach_length
  BEFORE INSERT OR UPDATE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_calculate_reach_length();

  CREATE TRIGGER ws_symbology_update_by_reach
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.ws_symbology_update_by_reach();

  CREATE TRIGGER on_wastewater_structure_update
  AFTER UPDATE
    ON tww_od.wastewater_structure
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_on_wastewater_structure_update();

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

  CREATE TRIGGER on_cover_change
  AFTER INSERT OR UPDATE OR DELETE
    ON tww_od.cover
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_on_cover_change();

  CREATE TRIGGER on_wasterwaternode_change
  AFTER INSERT OR UPDATE
    ON tww_od.wastewater_node
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_on_wastewater_node_change();

  CREATE TRIGGER ws_symbology_update_by_channel
  AFTER INSERT OR UPDATE OR DELETE
  ON tww_od.channel
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.symbology_update_by_channel();

  -- only update -> insert and delete are handled by reach trigger
  CREATE TRIGGER ws_symbology_update_by_reach_point
  AFTER UPDATE
    ON tww_od.reach_point
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.symbology_update_by_reach_point();
