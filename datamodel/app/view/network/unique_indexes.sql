CREATE UNIQUE INDEX in_app_vw_network_segment_gid
    ON tww_app.vw_network_segment USING btree
    (gid)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX in_app_vw_network_node_gid
    ON tww_app.vw_network_node USING btree
    (gid)
    TABLESPACE pg_default;