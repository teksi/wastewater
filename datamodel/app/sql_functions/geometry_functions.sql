-----------------------------------------------
-----------------------------------------------
-- Synchronize GEOMETRY with bottom_level tww_od.wastewater_node
-----------------------------------------------
-----------------------------------------------
CREATE OR REPLACE FUNCTION tww_app.synchronize_co_depth_by_wastewater_networkelement(_obj_id text, _all boolean default false)
  RETURNS void AS
$BODY$
DECLARE
  co_obj_ids varchar(16)[];
  ws_oid varchar(16);
  wn_recs record;
  min_level numeric;
  i int;
BEGIN

  SELECT ws.obj_id into ws_oid FROM tww_od.wastewater_structure ws
  JOIN tww_od.wastewater_networkelement ne on ws.obj_id=ne.fk_wastewater_structure AND ne.obj_id=_obj_id;

  with ws_agg AS
  (
  SELECT DISTINCT ON (ws.obj_id)
  ws.obj_id as ws_oid,
  min(wn.bottom_level) OVER w as wn_min_level,
  wn.bottom_level
  FROM tww_od.wastewater_structure ws
  JOIN tww_od.wastewater_networkelement ne ON ws.obj_id=ne.fk_wastewater_structure
  JOIN tww_od.wastewater_node wn ON wn.obj_id = ne.obj_id
  JOIN tww_od.structure_part sp ON ws.obj_id=sp.fk_wastewater_structure
  JOIN tww_od.cover co ON sp.obj_id=co.obj_id
  WHERE
  (_all or ne.fk_wastewater_structure = ws_oid) AND
  NULLIF(wn.bottom_level, 0) IS NOT NULL
  AND ne.fk_wastewater_structure IS NOT NULL
  WINDOW w AS (PARTITION BY ne.fk_wastewater_structure ORDER BY wn.bottom_level ASC)
  ),
  co_agg AS (
    SELECT
      sp.fk_wastewater_structure AS ws_oid,
      array_agg(co.obj_id) AS co_oids
    FROM tww_od.structure_part sp
    JOIN tww_od.cover co ON sp.obj_id = co.obj_id
    GROUP BY sp.fk_wastewater_structure
  )
  SELECT
    co.co_oids,
    ws.wn_min_level
  INTO co_obj_ids,min_level
  FROM ws_agg ws
  JOIN co_agg co ON ws.ws_oid = co.ws_oid;


  IF NULLIF(min_level,0) IS NULL THEN
    FOR i IN 1..array_length(co_obj_ids, 1) LOOP
      EXECUTE format('UPDATE tww_od.cover SET _depth = NULL WHERE obj_id = %%L;', co_obj_ids[i]);
    END LOOP;
  ELSE
    FOR i IN 1..array_length(co_obj_ids, 1) LOOP
      EXECUTE format('UPDATE tww_od.cover SET _depth = level - %%s WHERE obj_id = %%L;', min_level, co_obj_ids[i]);
    END LOOP;
  END IF;
  RETURN;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;


CREATE OR REPLACE FUNCTION tww_app.synchronize_level_with_altitude_on_wastewater_node()
  RETURNS trigger AS
$BODY$
BEGIN

  CASE
    WHEN TG_OP = 'INSERT' THEN
      NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.bottom_level,'NaN') ), {SRID});
      SELECT tww_app.synchronize_co_depth_by_wastewater_networkelement(NEW.obj_id);
    WHEN TG_OP = 'UPDATE' THEN
      IF NEW.bottom_level <> OLD.bottom_level OR (NEW.bottom_level IS NULL AND OLD.bottom_level IS NOT NULL) OR (NEW.bottom_level IS NOT NULL AND OLD.bottom_level IS NULL) THEN
        NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.bottom_level,'NaN') ), {SRID});
      ELSE
        IF ST_Z(NEW.situation3d_geometry) <> ST_Z(OLD.situation3d_geometry) THEN
          NEW.bottom_level = NULLIF(ST_Z(NEW.situation3d_geometry),'NaN');
        END IF;
      END IF;
      SELECT tww_app.synchronize_co_depth_by_wastewater_networkelement(OLD.obj_id);
    ELSE
      NULL;
  END CASE;
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
      NEW._depth = NEW.level - wn_level;
    WHEN TG_OP = 'UPDATE' THEN
      IF NEW.level <> OLD.level OR (NEW.level IS NULL AND OLD.level IS NOT NULL) OR (NEW.level IS NOT NULL AND OLD.level IS NULL) THEN
        NEW.situation3d_geometry = ST_SetSRID( ST_MakePoint( ST_X(NEW.situation3d_geometry), ST_Y(NEW.situation3d_geometry), COALESCE(NEW.level,'NaN') ), {SRID});
      ELSE
        IF ST_Z(NEW.situation3d_geometry) <> ST_Z(OLD.situation3d_geometry) THEN
          NEW.level = NULLIF(ST_Z(NEW.situation3d_geometry),'NaN');
          NEW._depth = NEW.level - wn_level;
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
