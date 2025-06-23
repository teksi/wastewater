
CREATE INDEX IF NOT EXISTS in_tww_wastewater_structure_fk_main_wastewater_node
    ON tww_od.wastewater_structure USING btree
    (fk_main_wastewater_node)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS in_tww_wastewater_structure_fk_main_cover
    ON tww_od.wastewater_structure USING btree
    (fk_main_cover)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS in_tww_wastewater_networkelement_fk_wastewater_structure
    ON tww_od.wastewater_networkelement USING btree
    (fk_wastewater_structure)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_reach_point_fk_wastewater_networkelement
    ON tww_od.reach_point USING btree
    (fk_wastewater_networkelement)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_reach_fk_reach_point_to
    ON tww_od.reach USING btree
    (fk_reach_point_to)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_reach_fk_reach_point_from
    ON tww_od.reach USING btree
    (fk_reach_point_from)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_network_node_ne_id
    ON tww_od.network_node USING btree
    (ne_id)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_network_node_rp_id
    ON tww_od.network_node USING btree
    (rp_id)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_network_segment_ne_id
    ON tww_od.network_segment USING btree
    (ne_id)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS in_tww_network_segment_from_node
    ON tww_od.network_segment USING btree
    (from_node)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS in_tww_network_segment_to_node
    ON tww_od.network_segment USING btree
    (to_node)
    TABLESPACE pg_default;
