CREATE SCHEMA IF NOT EXISTS tww_diff;

CREATE TABLE IF NOT EXISTS tww_diff.tww_metadata (
    id bigserial PRIMARY KEY,
    job_id text NOT NULL,
    job_status text NOT NULL DEFAULT 'pending',
    job_type text NOT NULL DEFAULT 'review',

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

    metadata jsonb NOT NULL DEFAULT '{{}}'::jsonb,
    failure jsonb NOT NULL DEFAULT '{{}}'::jsonb,
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
                'archived',
                'superseded'
            )
        ),
    CONSTRAINT tww_diff_metadata_job_type_list
        CHECK (
            job_type IN (
                'review',
                'schema_backup',
                'trusted_import'
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
ON tww_diff.tww_metadata (job_status);

CREATE INDEX IF NOT EXISTS metadata_diff_tstamp_idx
ON tww_diff.tww_metadata (diff_tstamp);

CREATE TABLE IF NOT EXISTS tww_diff.tww_review_feature (
    diff_id bigserial,

    job_id bigint NOT NULL,

    identity jsonb NOT NULL,

    is_created boolean NOT NULL DEFAULT false,
    is_altered boolean NOT NULL DEFAULT false,
    is_deleted boolean NOT NULL DEFAULT false,

    is_rejected boolean GENERATED ALWAYS AS (
        jsonb_array_length(permission_findings) > 0
        OR
        jsonb_array_length(validation_findings) > 0
    ) STORED,

    import_values jsonb NOT NULL DEFAULT '{}'::jsonb,
    canonical_values jsonb NOT NULL DEFAULT '{}'::jsonb,
    changed_attributes jsonb NOT NULL DEFAULT '[]'::jsonb,
    unpermitted_values jsonb NOT NULL DEFAULT '{}'::jsonb,
    permission_findings jsonb NOT NULL DEFAULT '[]'::jsonb,
    validation_findings jsonb NOT NULL DEFAULT '[]'::jsonb,

    created_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT review_feature_identity_object
        CHECK (
            jsonb_typeof(identity) = 'object'
        ),

    CONSTRAINT review_feature_identity_class
        CHECK (
            jsonb_typeof(
                identity -> 'class_id'
            ) = 'string'
        ),

    CONSTRAINT review_feature_identity_attributes
        CHECK (
            jsonb_typeof(
                identity -> 'attributes'
            ) = 'object'
        ),

    CONSTRAINT review_feature_operation
        CHECK (
            is_created::integer
            + is_altered::integer
            + is_deleted::integer
            = 1
        ),

    CONSTRAINT review_feature_import_values_object
        CHECK (
            jsonb_typeof(import_values) = 'object'
        ),

    CONSTRAINT review_feature_canonical_values_object
        CHECK (
            jsonb_typeof(canonical_values) = 'object'
        ),

    CONSTRAINT review_feature_changed_attributes_array
        CHECK (
            jsonb_typeof(changed_attributes) = 'array'
        ),

    CONSTRAINT review_feature_unpermitted_values_object
        CHECK (
            jsonb_typeof(unpermitted_values) = 'object'
        ),

    CONSTRAINT review_feature_permission_findings_array
        CHECK (
            jsonb_typeof(permission_findings) = 'array'
        ),

    CONSTRAINT review_feature_validation_findings_array
        CHECK (
            jsonb_typeof(validation_findings) = 'array'
        )
);


DO
$DO$
DECLARE
    rec record;
BEGIN
    FOR rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'tww_od'
          AND table_name NOT IN (
              'network_segment',
              'network_node',
              'reach_coefficient_of_friction',
              'tww_wastewater_node_symbology',
              'tww_wastewater_structure_label',
              'tww_reach_point_label',
              'default_values',
              'import_manhole_quarantine'
          )
    LOOP
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS tww_diff.%I (
                CONSTRAINT %I
                    PRIMARY KEY (diff_id),

                CONSTRAINT %I
                    FOREIGN KEY (job_id)
                    REFERENCES tww_diff.tww_metadata (id)
                    ON DELETE CASCADE,

                CONSTRAINT %I
                    UNIQUE (job_id, identity),

                CONSTRAINT %I
                    CHECK (
                        identity ->> ''class_id'' = %L
                    )
            ) INHERITS (tww_diff.tww_review_feature);',
            rec.table_name,
            rec.table_name || '_pkey',
            rec.table_name || '_job_id_fkey',
            rec.table_name || '_job_identity_unique',
            rec.table_name || '_identity_class_check',
            rec.table_name
        );

        EXECUTE format(
            'CREATE INDEX IF NOT EXISTS %I
             ON tww_diff.%I (job_id);',
            rec.table_name || '_job_id_idx',
            rec.table_name
        );
    END LOOP;
END;
$DO$;