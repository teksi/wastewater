-----------------------------------------------
-----------------------------------------------
-- Synchronize GEOMETRY with bottom_level tww_od.wastewater_node
-----------------------------------------------
-----------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.synchronize_level_with_altitude_on_wastewater_node()
  RETURNS trigger AS
$BODY$
BEGIN
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
BEGIN
  CASE
    WHEN TG_OP = 'INSERT' THEN
      NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.level,'NaN') ), {SRID});
    WHEN TG_OP = 'UPDATE' THEN
      IF NEW.level <> OLD.level OR (NEW.level IS NULL AND OLD.level IS NOT NULL) OR (NEW.level IS NOT NULL AND OLD.level IS NULL) THEN
        NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.level,'NaN') ), {SRID});
      ELSE
        IF ST_Z(NEW.situation3d_geometry) <> ST_Z(OLD.situation3d_geometry) THEN
          NEW.level = NULLIF(ST_Z(NEW.situation3d_geometry),'NaN');
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
