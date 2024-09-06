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
    EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;



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
  _ws_obj_id = OLD.obj_id;
  SELECT tww_app.update_wastewater_structure_label(_ws_obj_id) INTO NEW._label;

  IF OLD.fk_main_cover != NEW.fk_main_cover THEN
    EXECUTE tww_app.update_depth(_ws_obj_id);
  END IF;


  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

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

  FOR _ws_obj_id IN
    SELECT ws.obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = rp.fk_wastewater_networkelement
      WHERE rp.obj_id = ANY ( rp_obj_ids )
  LOOP
    EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);
    EXECUTE tww_app.update_depth(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;


--------------------------------------------------
-- ON REACH DELETE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_reach_delete()
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

--------------------------------------------------
-- ON WASTEWATER NODE CHANGE
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.symbology_on_wastewater_node_change()
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

  SELECT ne.fk_wastewater_structure INTO affected_sp
  FROM tww_od.wastewater_networkelement ne
  WHERE obj_id = co_obj_id;

  EXECUTE tww_app.update_depth(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.update_wastewater_structure_label(affected_sp.fk_wastewater_structure);

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

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

  EXECUTE tww_app.update_wastewater_structure_label(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.update_depth(affected_sp.fk_wastewater_structure);
  EXECUTE tww_app.wastewater_structure_update_fk_main_cover(affected_sp.fk_wastewater_structure);

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

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
      SELECT ws.obj_id INTO _ws_obj_id
      FROM tww_od.wastewater_structure ws
      LEFT JOIN tww_od.wastewater_networkelement ne ON ws.obj_id = ne.fk_wastewater_structure
      LEFT JOIN tww_od.reach_point rp ON ne.obj_id = ne_obj_id;

      EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);
      EXECUTE tww_app.update_depth(_ws_obj_id);
  END LOOP;

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------
-- CALCULATE REACH LENGTH
--------------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.autoupdate_calculate_reach_length()
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


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
    EXECUTE PROCEDURE tww_app.symbology_on_reach_delete();

  CREATE TRIGGER calculate_reach_length
  BEFORE INSERT OR UPDATE
    ON tww_od.reach
  FOR EACH ROW
    EXECUTE PROCEDURE tww_app.autoupdate_calculate_reach_length();

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
