CREATE OR REPLACE FUNCTION tww_app.persist_pipe_geometry(
    p_fk_pipe_profile varchar(16),
    p_geometry jsonb
)
RETURNS void
LANGUAGE plpgsql
AS
$$
DECLARE
    v_count integer;
BEGIN

    ------------------------------------------------------------------
    -- Validate pipe profile
    ------------------------------------------------------------------
    IF jsonb_array_length(p_geometry) > 1000 THEN
    -- assumption: something in creating the geom went wrong
        RAISE EXCEPTION
            'Too many vertices (%).',
            jsonb_array_length(p_geometry);
    END IF;


    IF p_fk_pipe_profile IS NULL THEN
        RAISE EXCEPTION
            'p_fk_pipe_profile must not be null';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM tww_od.pipe_profile
        WHERE obj_id = p_fk_pipe_profile
    ) THEN
        RAISE EXCEPTION
            'pipe_profile % does not exist',
            p_fk_pipe_profile;
    END IF;

    ------------------------------------------------------------------
    -- Validate JSON type
    ------------------------------------------------------------------

    IF p_geometry IS NULL THEN
        RAISE EXCEPTION
            'p_geometry must not be null';
    END IF;

    IF jsonb_typeof(p_geometry) <> 'array' THEN
        RAISE EXCEPTION
            'p_geometry must be a JSON array';
    END IF;

    ------------------------------------------------------------------
    -- Validate elements
    ------------------------------------------------------------------

    SELECT count(*)
    INTO v_count
    FROM jsonb_array_elements(p_geometry) AS j
    WHERE
        NOT (j ? 'x')
        OR NOT (j ? 'y')
        OR jsonb_typeof(j->'x') <> 'number'
        OR jsonb_typeof(j->'y') <> 'number';

    IF v_count > 0 THEN
        RAISE EXCEPTION
            'every vertex must contain numeric x and y';
    END IF;

    ------------------------------------------------------------------
    -- Optional: minimum number of vertices
    ------------------------------------------------------------------

    IF jsonb_array_length(p_geometry) < 2 THEN
        RAISE EXCEPTION
            'at least two vertices required';
    END IF;

    ------------------------------------------------------------------
    -- Persist
    ------------------------------------------------------------------

    DELETE FROM tww_od.profile_geometry
    WHERE fk_pipe_profile = p_fk_pipe_profile;

    INSERT INTO tww_od.profile_geometry (
        sequence,
        x,
        y,
        fk_pipe_profile
    )
    SELECT
        ordinality::smallint,
        (j->>'x')::real,
        (j->>'y')::real,
        p_fk_pipe_profile
    FROM jsonb_array_elements(p_geometry)
         WITH ORDINALITY AS t(j, ordinality);

END;
$$;
