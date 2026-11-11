CREATE TABLE tww_sys.interlis_mapping_cache (
    cache_key uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    physical_schema text NOT NULL,
    model_names text[] NOT NULL,
    mapping_kind text NOT NULL,

    -- Everything needed to recreate the mapping without reflection
    mapping_payload jsonb NOT NULL,

    -- Fingerprints used only for change detection
    content_sha256 text NOT NULL,
    schema_sha256 text NOT NULL,

    created_at timestamptz NOT NULL DEFAULT now(),
    refreshed_at timestamptz NOT NULL DEFAULT now(),

    UNIQUE (
        physical_schema,
        model_names,
        mapping_kind,
        content_sha256,
        schema_sha256
    )
);