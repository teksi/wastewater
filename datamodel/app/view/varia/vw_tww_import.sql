-- create mobile view

CREATE OR REPLACE VIEW tww_app.import_vw_manhole AS
 SELECT DISTINCT ON (ws.obj_id) ws.obj_id,
    ws.identifier,
    COALESCE(wn.situation3d_geometry, main_co.situation3d_geometry)::geometry(POINTZ, {SRID}) AS situation_geometry,
    main_co.cover_shape as co_shape,
    main_co.diameter as co_diameter,
    main_co.material as co_material,
    main_co.positional_accuracy as co_positional_accuracy,
    main_co.level as co_level,
    ws._depth::numeric(6, 3) AS _depth,
    wn._usage_current AS _channel_usage_current,
    ma.material as ma_material,
    ma.dimension1 as ma_dimension1,
    ma.dimension2 as ma_dimension2,
    CASE
          WHEN ma.obj_id IS NOT NULL THEN 'manhole'
          WHEN ss.obj_id IS NOT NULL THEN 'special_structure'
          WHEN dp.obj_id IS NOT NULL THEN 'discharge_point'
          WHEN ii.obj_id IS NOT NULL THEN 'infiltration_installation'
          ELSE 'unknown'
        END AS ws_type,
    ma.function as ma_function,
    ss.function as ss_function,
    ne.remark,
    wn.bottom_level as wn_bottom_level,
    NULL::text AS photo1,
    NULL::text AS photo2,
    NULL::smallint AS inlet_3_material,
    NULL::integer AS inlet_3_clear_height,
    NULL::numeric(7, 3) AS inlet_3_depth_m,
    NULL::smallint AS inlet_4_material,
    NULL::integer AS inlet_4_clear_height,
    NULL::numeric(7, 3) AS inlet_4_depth_m,
    NULL::smallint AS inlet_5_material,
    NULL::integer AS inlet_5_clear_height,
    NULL::numeric(7, 3) AS inlet_5_depth_m,
    NULL::smallint AS inlet_6_material,
    NULL::integer AS inlet_6_clear_height,
    NULL::numeric(7, 3) AS inlet_6_depth_m,
    NULL::smallint AS inlet_7_material,
    NULL::integer AS inlet_7_clear_height,
    NULL::numeric(7, 3) AS inlet_7_depth_m,
    NULL::smallint AS outlet_1_material,
    NULL::integer AS outlet_1_clear_height,
    NULL::numeric(7, 3) AS outlet_1_depth_m,
    NULL::smallint AS outlet_2_material,
    NULL::integer AS outlet_2_clear_height,
    NULL::numeric(7, 3) AS outlet_2_depth_m,
    FALSE::boolean AS verified,
    (q.obj_id IS NOT NULL) AS in_quarantine,
    FALSE::boolean AS deleted

    FROM tww_od.wastewater_structure ws
    LEFT JOIN tww_od.cover main_co ON main_co.obj_id = ws.fk_main_cover
    LEFT JOIN tww_od.manhole ma ON ma.obj_id = ws.obj_id
    LEFT JOIN tww_od.special_structure ss ON ss.obj_id = ws.obj_id
    LEFT JOIN tww_od.discharge_point dp ON dp.obj_id = ws.obj_id
    LEFT JOIN tww_od.infiltration_installation ii ON ii.obj_id = ws.obj_id
	LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id = ws.fk_main_wastewater_node
    LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws.fk_main_wastewater_node
	LEFT JOIN (SELECT DISTINCT obj_id
				, max(quarantine_serial)  as maximum
				FROM tww_od.import_manhole_quarantine
			    GROUP BY obj_id
			  	) q ON q.obj_id = ws.obj_id
   ;


-- create trigger function and trigger for mobile view

CREATE OR REPLACE FUNCTION tww_app.import_vw_manhole_insert_into_quarantine_or_delete() RETURNS trigger AS $BODY$
BEGIN
  IF NEW.verified IS TRUE THEN
    IF NEW.deleted IS TRUE THEN
      -- delete this entry
      DELETE FROM tww_app.vw_tww_wastewater_structure
      WHERE obj_id = NEW.obj_id;
    ELSE
      -- insert data into quarantine
      INSERT INTO tww_od.import_manhole_quarantine
      (
      obj_id,
      identifier,
      situation_geometry,
      co_shape,
      co_diameter,
      co_material,
      co_positional_accuracy,
      co_level,
      _depth,
      _channel_usage_current,
      ma_material,
      ma_dimension1,
      ma_dimension2,
      ws_type,
      ma_function,
      ss_function,
      remark,
      wn_bottom_level,
      photo1,
      photo2,
      inlet_3_material,
      inlet_3_clear_height,
      inlet_3_depth_m,
      inlet_4_material,
      inlet_4_clear_height,
      inlet_4_depth_m,
      inlet_5_material,
      inlet_5_clear_height,
      inlet_5_depth_m,
      inlet_6_material,
      inlet_6_clear_height,
      inlet_6_depth_m,
      inlet_7_material,
      inlet_7_clear_height,
      inlet_7_depth_m,
      outlet_1_material,
      outlet_1_clear_height,
      outlet_1_depth_m,
      outlet_2_material,
      outlet_2_clear_height,
      outlet_2_depth_m
      )
      VALUES
      (
      NEW.obj_id,
      NEW.identifier,
      NEW.situation_geometry,
      NEW.co_shape,
      NEW.co_diameter,
      NEW.co_material,
      NEW.co_positional_accuracy,
      NEW.co_level,
      NEW._depth,
      NEW._channel_usage_current,
      NEW.ma_material,
      NEW.ma_dimension1,
      NEW.ma_dimension2,
      NEW.ws_type,
      NEW.ma_function,
      NEW.ss_function,
      NEW.remark,
      NEW.wn_bottom_level,
      NEW.photo1,
      NEW.photo2,
      NEW.inlet_3_material,
      NEW.inlet_3_clear_height,
      NEW.inlet_3_depth_m,
      NEW.inlet_4_material,
      NEW.inlet_4_clear_height,
      NEW.inlet_4_depth_m,
      NEW.inlet_5_material,
      NEW.inlet_5_clear_height,
      NEW.inlet_5_depth_m,
      NEW.inlet_6_material,
      NEW.inlet_6_clear_height,
      NEW.inlet_6_depth_m,
      NEW.inlet_7_material,
      NEW.inlet_7_clear_height,
      NEW.inlet_7_depth_m,
      NEW.outlet_1_material,
      NEW.outlet_1_clear_height,
      NEW.outlet_1_depth_m,
      NEW.outlet_2_material,
      NEW.outlet_2_clear_height,
      NEW.outlet_2_depth_m
      );
    END IF;
  END IF;
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_mutation_make_insert_or_delete ON tww_app.import_vw_manhole;

CREATE TRIGGER on_mutation_make_insert_or_delete
  INSTEAD OF INSERT OR UPDATE
  ON tww_app.import_vw_manhole
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.import_vw_manhole_insert_into_quarantine_or_delete();


-- logic for tww_od.import_manhole_quarantine

-- create trigger functions and triggers for quarantine table
-- SELECT set_config('tww.srid', :SRID::text, false);
DO $DO$
BEGIN
EXECUTE format($TRIGGER$
CREATE OR REPLACE FUNCTION tww_app.import_manhole_quarantine_try_structure_update() RETURNS trigger AS $BODY$
BEGIN

  -- in case there is a depth, but no refercing value - it should stay in quarantene
  IF( NEW._depth IS NOT NULL AND NEW.co_level IS NULL AND NEW.wn_bottom_level IS NULL ) THEN
    RAISE EXCEPTION 'No referencing value for calculation with depth';
  END IF;

  -- tww_od.wastewater_structure
  IF( SELECT TRUE FROM tww_app.vw_tww_wastewater_structure WHERE obj_id = NEW.obj_id ) THEN
    UPDATE tww_app.vw_tww_wastewater_structure SET
    identifier = NEW.identifier,
    situation_geometry = ST_Force2D(NEW.situation_geometry),
    co_shape = NEW.co_shape,
    co_diameter = NEW.co_diameter,
    co_material = NEW.co_material,
    co_positional_accuracy = NEW.co_positional_accuracy,
    co_level =
      (CASE WHEN NEW.co_level IS NULL AND NEW.wn_bottom_level IS NOT NULL AND NEW._depth IS NOT NULL
      THEN NEW.wn_bottom_level + NEW._depth
      ELSE NEW.co_level
      END),
    _depth = NEW._depth,
    _channel_usage_current = NEW._channel_usage_current,
    ma_material = NEW.ma_material,
    ma_dimension1 = NEW.ma_dimension1,
    ma_dimension2 = NEW.ma_dimension2,
    ws_type = NEW.ws_type,
    ma_function = NEW.ma_function,
    ss_function = NEW.ss_function,
    remark = NEW.remark,
    wn_bottom_level =
      (CASE WHEN NEW.wn_bottom_level IS NULL AND NEW.co_level IS NOT NULL AND NEW._depth IS NOT NULL
      THEN NEW.co_level - NEW._depth
      ELSE NEW.wn_bottom_level
      END)
    WHERE obj_id = NEW.obj_id;
    RAISE NOTICE 'Updated row in tww_app.vw_tww_wastewater_structure';
  ELSE
    INSERT INTO tww_app.vw_tww_wastewater_structure
    (
    obj_id,
    identifier,
    situation_geometry,
    co_shape,
    co_diameter,
    co_material,
    co_positional_accuracy,
    co_level,
    _depth,
    _channel_usage_current,
    ma_material,
    ma_dimension1,
    ma_dimension2,
    ws_type,
    ma_function,
    ss_function,
    remark,
    wn_bottom_level
    )
    VALUES
    (
    NEW.obj_id,
    NEW.identifier,
    ST_Force2D(NEW.situation_geometry),
    NEW.co_shape,
    NEW.co_diameter,
    NEW.co_material,
    NEW.co_positional_accuracy,
      (CASE WHEN NEW.co_level IS NULL AND NEW.wn_bottom_level IS NOT NULL AND NEW._depth IS NOT NULL
      THEN NEW.wn_bottom_level + NEW._depth
      ELSE NEW.co_level
      END),
    NEW._depth,
    NEW._channel_usage_current,
    NEW.ma_material,
    NEW.ma_dimension1,
    NEW.ma_dimension2,
    NEW.ws_type,
    NEW.ma_function,
    NEW.ss_function,
    NEW.remark,
      (CASE WHEN NEW.wn_bottom_level IS NULL AND NEW.co_level IS NOT NULL AND NEW._depth IS NOT NULL
      THEN NEW.co_level - NEW._depth
      ELSE NEW.wn_bottom_level
      END)
      );
    RAISE NOTICE 'Inserted row in tww_app.vw_tww_wastewater_structure';
  END IF;

  -- photo1 insert
  IF (NEW.photo1 IS NOT NULL) THEN
    INSERT INTO tww_od.file
    (
      object,
      identifier
    )
    VALUES
    (
      NEW.obj_id,
      NEW.photo1
    );
    RAISE NOTICE 'Inserted row in tww_od.file';
  END IF;

  -- photo2 insert
  IF (NEW.photo2 IS NOT NULL) THEN
    INSERT INTO tww_od.file
    (
      object,
      identifier
    )
    VALUES
    (
      NEW.obj_id,
      NEW.photo2
    );
    RAISE NOTICE 'Inserted row in tww_od.file';
  END IF;

  -- set structure okay
  UPDATE tww_od.import_manhole_quarantine
  SET structure_okay = true
  WHERE quarantine_serial = NEW.quarantine_serial;
  RETURN NEW;

  -- catch
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'EXCEPTION: %%', SQLERRM;
    RETURN NEW;
END; $BODY$
LANGUAGE plpgsql;
$TRIGGER$, {SRID});
END
$DO$;

DROP TRIGGER IF EXISTS after_update_try_structure_update ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_update_try_structure_update
  AFTER UPDATE
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  WHEN ( ( NEW.structure_okay IS NOT TRUE )
  AND NOT( OLD.inlet_okay IS NOT TRUE AND NEW.inlet_okay IS TRUE )
  AND NOT( OLD.outlet_okay IS NOT TRUE AND NEW.outlet_okay IS TRUE ) )
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_try_structure_update({SRID});

DROP TRIGGER IF EXISTS after_insert_try_structure_update ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_insert_try_structure_update
  AFTER INSERT
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_try_structure_update({SRID});

-- Some information:
-- 1. new lets 0 - old lets 0 -> do nothing
-- 2. new lets 0 - old lets 1 -> manual deletion needed (or not, depending on if it's on purpose or not)
-- 3. new lets 0 - old lets n -> manual deletion needed (or not, depending on if it's on purpose or not)
-- 4. new lets 1 - old lets 0 -> manual creation needed
-- 5. new lets 1 - old lets 1 -> update let
-- 6. new lets 1 - old lets n -> manual update needed
-- 7. new lets n - old lets 0 -> manual creation needed
-- 8. new lets n - old lets 1 -> manual update needed
-- 9. new lets n - old lets n -> manual update needed

CREATE OR REPLACE FUNCTION tww_app.import_manhole_quarantine_try_let_update() RETURNS trigger AS $BODY$
  DECLARE
    let_kind text;
    new_lets integer;
    old_lets integer;
BEGIN
  let_kind := TG_ARGV[0];

  -- count new lets
  IF let_kind='inlet' AND ( NEW.inlet_3_material IS NOT NULL OR NEW.inlet_3_depth_m IS NOT NULL OR NEW.inlet_3_clear_height IS NOT NULL )
   OR let_kind='outlet' AND ( NEW.outlet_1_material IS NOT NULL OR NEW.outlet_1_depth_m IS NOT NULL OR NEW.outlet_1_clear_height IS NOT NULL ) THEN
    IF let_kind='inlet' AND ( NEW.inlet_4_material IS NOT NULL OR NEW.inlet_4_depth_m IS NOT NULL OR NEW.inlet_4_clear_height IS NOT NULL )
     OR let_kind='outlet' AND ( NEW.outlet_2_material IS NOT NULL OR NEW.outlet_2_depth_m IS NOT NULL OR NEW.outlet_2_clear_height IS NOT NULL ) THEN
      new_lets = 2; -- it's possibly more, but at least > 1
    ELSE
      new_lets = 1;
    END IF;
  ELSE
    new_lets = 0;
  END IF;
  -- count old lets
  old_lets = ( SELECT COUNT (*)
    FROM tww_od.reach re
    LEFT JOIN tww_od.reach_point rp ON let_kind='inlet' AND rp.obj_id = re.fk_reach_point_to OR let_kind='outlet' AND rp.obj_id = re.fk_reach_point_from
    LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
    LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
    WHERE ws.obj_id = NEW.obj_id );

  -- handle inlets
  IF ( new_lets > 1 AND old_lets > 0 ) OR old_lets > 1 THEN
    -- request for update because new lets are bigger 1 (and old lets not 0 ) or old lets are bigger 1
    RAISE NOTICE 'Impossible to assign %s - manual edit needed.', let_kind;
  ELSE
    IF new_lets = 0 AND old_lets > 0 THEN
      -- request for delete because no new lets but old lets
      RAISE NOTICE 'No new %s but old ones - manual delete needed.', let_kind;
    ELSIF new_lets > 0 AND old_lets = 0 THEN
      -- request for create because no old lets but new lets
      RAISE NOTICE 'No old %s but new ones - manual create needed.', let_kind;
    ELSE
      IF new_lets = 1 AND old_lets = 1 THEN
        IF let_kind='inlet' THEN
          -- update material and dimension on reach
          UPDATE tww_od.reach
          SET material = NEW.inlet_3_material,
          clear_height = NEW.inlet_3_clear_height
          WHERE obj_id = ( SELECT re.obj_id
            FROM tww_od.reach re
            LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_to
            LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
            WHERE ws.obj_id = NEW.obj_id );

          -- update depth_m on reach_point
          UPDATE tww_od.reach_point
          SET level = NEW.co_level - NEW.inlet_3_depth_m
          WHERE obj_id = ( SELECT rp.obj_id
            FROM tww_od.reach re
            LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_to
            LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
            WHERE ws.obj_id = NEW.obj_id );
        ELSE
          -- update material on reach
          UPDATE tww_od.reach
          SET material = NEW.outlet_1_material,
          clear_height = NEW.outlet_1_clear_height
          WHERE obj_id = ( SELECT re.obj_id
            FROM tww_od.reach re
            LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_from
            LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
            WHERE ws.obj_id = NEW.obj_id );

          -- update depth_m on reach_point
          UPDATE tww_od.reach_point
          SET level = NEW.co_level - NEW.outlet_1_depth_m
          WHERE obj_id = ( SELECT rp.obj_id
            FROM tww_od.reach re
            LEFT JOIN tww_od.reach_point rp ON rp.obj_id = re.fk_reach_point_from
            LEFT JOIN tww_od.wastewater_networkelement wn ON wn.obj_id = rp.fk_wastewater_networkelement
            LEFT JOIN tww_app.vw_tww_wastewater_structure ws ON ws.obj_id = wn.fk_wastewater_structure
            WHERE ws.obj_id = NEW.obj_id );
        END IF;

        RAISE NOTICE '%s updated', let_kind;
      ELSE
        -- do nothing
        RAISE NOTICE 'No %s - nothing to do', let_kind;
      END IF;

      IF let_kind='inlet' THEN
        -- set inlet okay
        UPDATE tww_od.import_manhole_quarantine
        SET inlet_okay = true
        WHERE quarantine_serial = NEW.quarantine_serial;
      ELSE
        -- set outlet okay
        UPDATE tww_od.import_manhole_quarantine
        SET outlet_okay = true
        WHERE quarantine_serial = NEW.quarantine_serial;
      END IF;

    END IF;
  END IF;
  RETURN NEW;

  -- catch
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'EXCEPTION: %', SQLERRM;
    RETURN NEW;
END; $BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS after_update_try_inlet_update ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_update_try_inlet_update
  AFTER UPDATE
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  WHEN ( ( NEW.inlet_okay IS NOT TRUE )
  AND NOT( OLD.outlet_okay IS NOT TRUE AND NEW.outlet_okay IS TRUE )
  AND NOT( OLD.structure_okay IS NOT TRUE AND NEW.structure_okay IS TRUE ) )
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_try_let_update( 'inlet' );

DROP TRIGGER IF EXISTS after_insert_try_inlet_update ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_insert_try_inlet_update
  AFTER INSERT
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_try_let_update( 'inlet' );

DROP TRIGGER IF EXISTS after_update_try_outlet_update ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_update_try_outlet_update
  AFTER UPDATE
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  WHEN ( ( NEW.outlet_okay IS NOT TRUE )
  AND NOT( OLD.inlet_okay IS NOT TRUE AND NEW.inlet_okay IS TRUE )
  AND NOT( OLD.structure_okay IS NOT TRUE AND NEW.structure_okay IS TRUE ) )
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_try_let_update( 'outlet' );

DROP TRIGGER IF EXISTS after_insert_try_outlet_update ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_insert_try_outlet_update
  AFTER INSERT
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_try_let_update( 'outlet' );


CREATE OR REPLACE FUNCTION tww_app.import_manhole_quarantine_delete_entry() RETURNS trigger AS $BODY$
BEGIN
  DELETE FROM tww_od.import_manhole_quarantine
  WHERE quarantine_serial = NEW.quarantine_serial;
  RAISE NOTICE 'Deleted row in tww_od.import_manhole_quarantine';
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS after_mutation_delete_when_okay ON tww_od.import_manhole_quarantine;

CREATE TRIGGER after_mutation_delete_when_okay
  AFTER INSERT OR UPDATE
  ON tww_od.import_manhole_quarantine
  FOR EACH ROW
  WHEN ( NEW.structure_okay IS TRUE AND NEW.inlet_okay IS TRUE AND NEW.outlet_okay IS TRUE )
  EXECUTE PROCEDURE tww_app.import_manhole_quarantine_delete_entry();
