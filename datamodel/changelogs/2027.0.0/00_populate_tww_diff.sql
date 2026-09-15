CREATE SCHEMA IF NOT EXISTS tww_diff;

CREATE TABLE IF NOT EXISTS tww_diff.metadata (
    id bigserial PRIMARY KEY,
    job_id text NOT NULL,
    job_status text NOT NULL DEFAULT 'pending',

    import_tstamp timestamptz NOT NULL DEFAULT now(),
    diff_tstamp timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),

    accepted_at timestamptz,
    application_started_at timestamptz,
    application_finished_at timestamptz,

    validation_success boolean NOT NULL DEFAULT false,

    source_model text,
    source_file text,
    import_schema text,
    live_schema text,

    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    failure jsonb NOT NULL DEFAULT '{}'::jsonb,
    backup_path text,

    CONSTRAINT tww_diff_metadata_job_id_unique
        UNIQUE (job_id),

    CONSTRAINT tww_diff_metadata_status_list
        CHECK (
            job_status IN (
                'preparing',
                'pending',
                'accepted',
                'rejected',
                'applying',
                'applied',
                'failed',
                'archived'
            )
        ),

    CONSTRAINT tww_diff_metadata_metadata_object
        CHECK (
            jsonb_typeof(metadata) = 'object'
        ),

    CONSTRAINT tww_diff_metadata_failure_object
        CHECK (
            jsonb_typeof(failure) = 'object'
        )
);

CREATE INDEX IF NOT EXISTS metadata_job_status_idx
ON tww_diff.metadata (job_status);

CREATE INDEX IF NOT EXISTS metadata_diff_tstamp_idx
ON tww_diff.metadata (diff_tstamp);

DO
$DO$
DECLARE
    rec record;
BEGIN
    FOR rec IN
        SELECT tablename AS table_name
        FROM tww_sys.dictionary_od_table
        ORDER BY tablename
    LOOP
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS tww_diff.%I (
                diff_id bigserial PRIMARY KEY,

                job_id bigint NOT NULL
                    REFERENCES tww_diff.metadata (id)
                    ON DELETE CASCADE,

                obj_id text NOT NULL,

                is_created boolean NOT NULL DEFAULT false,
                is_altered boolean NOT NULL DEFAULT false,
                is_deleted boolean NOT NULL DEFAULT false,

                is_rejected boolean GENERATED ALWAYS AS (
                    jsonb_array_length(permission_findings) > 0
                    OR
                    jsonb_array_length(validation_findings) > 0
                ) STORED,

                import_values jsonb NOT NULL DEFAULT ''{}''::jsonb,
                canonical_values jsonb NOT NULL DEFAULT ''{}''::jsonb,
                changed_attributes jsonb NOT NULL DEFAULT ''[]''::jsonb,
                unpermitted_values jsonb NOT NULL DEFAULT ''{}''::jsonb,
                permission_findings jsonb NOT NULL DEFAULT ''[]''::jsonb,
                validation_findings jsonb NOT NULL DEFAULT ''[]''::jsonb,

                created_at timestamptz NOT NULL DEFAULT now(),

                CONSTRAINT %I
                    UNIQUE (job_id, obj_id),

                CONSTRAINT %I
                    CHECK (
                        is_created::integer
                        + is_altered::integer
                        + is_deleted::integer
                        = 1
                    ),

                CONSTRAINT %I
                    CHECK (
                        jsonb_typeof(import_values) = ''object''
                    ),

                CONSTRAINT %I
                    CHECK (
                        jsonb_typeof(canonical_values) = ''object''
                    ),

                CONSTRAINT %I
                    CHECK (
                        jsonb_typeof(changed_attributes) = ''array''
                    ),

                CONSTRAINT %I
                    CHECK (
                        jsonb_typeof(unpermitted_values) = ''object''
                    ),

                CONSTRAINT %I
                    CHECK (
                        jsonb_typeof(permission_findings) = ''array''
                    ),

                CONSTRAINT %I
                    CHECK (
                        jsonb_typeof(validation_findings) = ''array''
                    )
            );',
            rec.table_name,
            rec.table_name || '_job_obj_id_unique',
            rec.table_name || '_operation_check',
            rec.table_name || '_import_values_object',
            rec.table_name || '_canonical_values_object',
            rec.table_name || '_changed_attributes_array',
            rec.table_name || '_unpermitted_values_object',
            rec.table_name || '_permission_findings_array',
            rec.table_name || '_validation_findings_array'
        );

        EXECUTE format(
            'CREATE INDEX IF NOT EXISTS %I
             ON tww_diff.%I (obj_id);',
            rec.table_name || '_obj_id_idx',
            rec.table_name
        );
    END LOOP;
END;
$DO$;
