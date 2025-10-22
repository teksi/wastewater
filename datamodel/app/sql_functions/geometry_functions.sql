-----------------------------------------------
-----------------------------------------------
-- Synchronize GEOMETRY with bottom_level tww_od.wastewater_node
-----------------------------------------------
-----------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.synchronize_level_with_altitude_on_wastewater_node()
  RETURNS trigger AS
$BODY$
DECLARE
  co_obj_ids varchar(16)[];
  min_level numeric;
  i int;
BEGIN
  SELECT array_agg(co.obj_id), min(wn.bottom_level) INTO co_obj_ids,min_level
  FROM tww_od.cover co
  JOIN tww_od.structure_part sp on sp.obj_id=co.obj_id
  JOIN tww_od.wastewater_networkelement ne on sp.fk_wastewater_structure=ne.fk_wastewater_structure AND ne.obj_id=NEW.obj_id
  JOIN tww_od.wastewater_node wn on wn.obj_id=ne.obj_id;

  CASE
    WHEN TG_OP = 'INSERT' THEN
      NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.bottom_level,'NaN') ), {SRID});
    WHEN TG_OP = 'UPDATE' THEN
      IF NEW.bottom_level <> OLD.bottom_level OR (NEW.bottom_level IS NULL AND OLD.bottom_level IS NOT NULL) OR (NEW.bottom_level IS NOT NULL AND OLD.bottom_level IS NULL) THEN
        NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.bottom_level,'NaN') ), {SRID});
      ELSE
        IF ST_Z(NEW.situation3d_geometry) <> ST_Z(OLD.situation3d_geometry) THEN
          NEW.bottom_level = NULLIF(ST_Z(NEW.situation3d_geometry),'NaN');
        END IF;
      END IF;
  END CASE;

  FOR i IN 1..array_length(co_obj_ids, 1) LOOP
    EXECUTE format('UPDATE tww_od.cover SET _depth = level - %%s WHERE obj_id = %%L;', min_level, co_obj_ids[i]);
  END LOOP;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

DROP TRIGGER IF EXISTS synchronize_level_with_altitude ON tww_od.wastewater_node;

CREATE TRIGGER synchronize_level_with_altitude
  BEFORE INSERT OR UPDATE
  ON tww_od.wastewater_node
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.synchronize_level_with_altitude_on_wastewater_node();


-----------------------------------------------
-----------------------------------------------
-- Synchronize GEOMETRY with level tww_od.cover
-----------------------------------------------
-----------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.synchronize_level_with_altitude_on_cover()
  RETURNS trigger AS
$BODY$
DECLARE
wn_level numeric;
BEGIN
  SELECT min(wn.bottom_level) INTO wn_level
  FROM tww_od.wastewater_structure ws
  JOIN tww_od.structure_part sp on sp.fk_wastewater_structure=ws.obj_id AND sp.obj_id=NEW.obj_id
  JOIN tww_od.wastewater_node wn ON ws.fk_main_wastewater_node = wn.obj_id;

  CASE
    WHEN TG_OP = 'INSERT' THEN
      NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.level,'NaN') ), {SRID});
      NEW._depth = NEW.level - wn_level
    WHEN TG_OP = 'UPDATE' THEN
      IF NEW.level <> OLD.level OR (NEW.level IS NULL AND OLD.level IS NOT NULL) OR (NEW.level IS NOT NULL AND OLD.level IS NULL) THEN
        NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.level,'NaN') ), {SRID});
      ELSE
        IF ST_Z(NEW.situation3d_geometry) <> ST_Z(OLD.situation3d_geometry) THEN
          NEW.level = NULLIF(ST_Z(NEW.situation3d_geometry),'NaN');
          NEW._depth = NEW.level - wn_level
        END IF;
      END IF;
  END CASE;

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

DROP TRIGGER IF EXISTS synchronize_level_with_altitude ON tww_od.cover;

CREATE TRIGGER synchronize_level_with_altitude
  BEFORE INSERT OR UPDATE
  ON tww_od.cover
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.synchronize_level_with_altitude_on_cover();


-----------------------------------------------
-----------------------------------------------
-- Synchronize reach and reach_point GEOMETRY with level tww_app.vw_tww_reach is implemented in vw_tww_reach.sql
-----------------------------------------------
-----------------------------------------------
