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
-- Interpolate z vertices
-----------------------------------------------

CREATE OR REPLACE FUNCTION tww_app.interpolate_z_vertices(
    geom geometry,
    mode text  -- 'local' or 'global'
)
RETURNS geometry
LANGUAGE plpgsql
AS
$$
DECLARE
    tmp_line geometry;
    n        integer;
    i        integer;
    pt       geometry;

    z_start  double precision;
    z_end    double precision;

    -- local mode helpers
    j        integer;
    k        integer;
    z_prev   double precision;
    z_next   double precision;
    d_prev   double precision;
    d_next   double precision;
    d_curr   double precision;
BEGIN
    IF mode not in ('local','global') THEN
    RAISE EXCEPTION
      USING
      MESSAGE = format(
        'mode "%s" not accepted (only local or global)', mode
      ),
      ERRCODE = '22023',
      DETAIL  = 'Parameter validation failed in tww_app.interpolate_z_vertices()',
      HINT    = 'Allowed values: local, global';
    ELSE NULL;
    END IF;
    -- Work on linearized copy
    tmp_line:= ST_CurveToLine(geom);
    n := ST_NPoints(tmp_line); --ST_NPoints is 1-based

    -- Read start & end Z
    z_start := NULLIF(ST_Z(ST_StartPoint(tmp_line)), 0);
    z_end   := NULLIF(ST_Z(ST_EndPoint(tmp_line)), 0);

    ------------------------------------------------------------------
    -- GLOBAL MODE: strict start/end requirement
    ------------------------------------------------------------------
    IF mode = 'global' THEN
      IF z_start IS NULL OR z_end IS NULL THEN
        RAISE EXCEPTION
          USING
            ERRCODE = '22023',  -- invalid_parameter_value
            MESSAGE = 'Global Z interpolation aborted',
            DETAIL  = format(
              'Start Z = %s, End Z = %s (must both be non‑NULL and non‑zero)',
              z_start, z_end
            ),
            HINT    = 'Ensure start and end reach points have valid elevation values before using global mode';
      END IF;
    END IF;

    ------------------------------------------------------------------
    -- Iterate over inner vertices
    ------------------------------------------------------------------
    FOR i IN 2 .. n-1 LOOP
        pt := ST_PointN(tmp_line, i); --ST_PointN is 1-based

        IF ST_Z(pt) IS NULL OR ST_Z(pt) = 0 THEN

            ------------------------------------------------------------------
            -- GLOBAL interpolation (start → end only)
            ------------------------------------------------------------------
            IF mode = 'global' THEN
                d_curr :=
                    ST_Length(
                        ST_LineSubstring(
                            tmp_line,
                            0,
                            ST_LineLocatePoint(tmp_line, pt)
                        )
                    ) / ST_Length(tmp_line);

                tmp_line :=
                    ST_SetPoint(
                        tmp_line,
                        i-1, --ST_SetPoint is 0-based
                        ST_MakePoint(
                            ST_X(pt),
                            ST_Y(pt),
                            z_start + d_curr * (z_end - z_start)
                        )
                    );

            ------------------------------------------------------------------
            -- LOCAL interpolation (nearest valid neighbours)
            ------------------------------------------------------------------
            ELSIF mode = 'local' THEN
                z_prev := NULL;
                z_next := NULL;
                d_curr := ST_Length(
                    ST_LineSubstring(
                        tmp_line,
                        0,
                        ST_LineLocatePoint(tmp_line, pt)
                    )
                );

                -- search backwards
                j := i - 1;
                WHILE j >= 1 LOOP
                    z_prev := NULLIF(ST_Z(ST_PointN(tmp_line, j)), 0);
                    EXIT WHEN z_prev IS NOT NULL;
                    j := j - 1;
                END LOOP;

                -- search forwards
                k := i + 1;
                WHILE k <= n LOOP
                    z_next := NULLIF(ST_Z(ST_PointN(tmp_line, k)), 0);
                    EXIT WHEN z_next IS NOT NULL;
                    k := k + 1;
                END LOOP;

                -- interpolate only if bounds exist
                IF z_prev IS NOT NULL AND z_next IS NOT NULL THEN
                    d_prev := ST_Length(
                        ST_LineSubstring(
                            tmp_line,
                            0,
                            ST_LineLocatePoint(tmp_line, ST_PointN(tmp_line, j))
                        )
                    );

                    d_next := ST_Length(
                        ST_LineSubstring(
                            tmp_line,
                            0,
                            ST_LineLocatePoint(tmp_line, ST_PointN(tmp_line, k))
                        )
                    );


                    tmp_line :=
                        ST_SetPoint(
                            tmp_line,
                            i-1,
                            ST_MakePoint(
                                ST_X(pt),
                                ST_Y(pt),
                                z_prev
                                + (d_curr - d_prev)
                                  / NULLIF(d_next - d_prev, 0)
                                  * (z_next - z_prev)
                            )
                        );
                ELSE
                  RAISE EXCEPTION
                    USING
                      ERRCODE = '22023',
                      MESSAGE = 'Local Z interpolation aborted',
                      DETAIL  = format(
                        'No valid neighbour Z values found for vertex %s',
                        i
                      ),
                      HINT    = 'Ensure valid Z values exist on both sides';
                END IF;
            END IF;
        END IF;
    END LOOP;

    -- Re-wrap as curve
    RETURN ST_ForceCurve(tmp_line);
END;
$$;

CREATE OR REPLACE FUNCTION tww_app.interpolate_reach_z_vertices(
    _obj_id text,
    mode text,  -- 'local' or 'global'
    _all boolean default false
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN
  UPDATE tww_od.reach
  SET progression3d_geometry=tww_app.interpolate_z_vertices(progression3d_geometry,mode)
  WHERE _all or obj_id=_obj_id;

END;
$$;

CREATE OR REPLACE FUNCTION tww_app.interpolate_reach_z_vertices(
    _obj_ids text[],
    mode text  -- 'local' or 'global'
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
  _obj_id  text;
BEGIN
  FOR _obj_id in _obj_ids LOOP
    PERFORM tww_app.interpolate_reach_z_vertices(_obj_id,mode);
  END LOOP;
END;
$$;
