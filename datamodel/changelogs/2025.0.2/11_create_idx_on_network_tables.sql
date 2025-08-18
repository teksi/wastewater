CREATE INDEX IF NOT EXISTS in_network_node_geom
    ON tww_od.network_node USING gist
    (geom)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_network_segment_geom
    ON tww_od.network_segment USING gist
    (geom)
    TABLESPACE pg_default;
