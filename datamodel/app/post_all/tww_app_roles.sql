-------------------------------------------
/* CREATE roles - cluster initialisation */
-------------------------------------------

GRANT USAGE ON SCHEMA tww_app  TO {viewer_role};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_app  TO {viewer_role};
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_app  TO {viewer_role};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO {viewer_role};

GRANT ALL ON SCHEMA tww_app TO {user_role};
GRANT ALL ON ALL TABLES IN SCHEMA tww_app TO {user_role};
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_app TO {user_role};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON TABLES TO {user_role};
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_app GRANT ALL ON SEQUENCES TO {user_role};


-- Transfer owner to {user_role} so {user_role} can refresh without security definer
ALTER MATERIALIZED VIEW tww_app.vw_catchment_area_totals_aggregated OWNER TO {user_role};
ALTER MATERIALIZED VIEW tww_app.vw_network_node OWNER TO {user_role};
ALTER MATERIALIZED VIEW tww_app.vw_network_segment OWNER TO {user_role};

