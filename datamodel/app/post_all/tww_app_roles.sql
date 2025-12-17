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
DO
$$
DECLARE
    mv_record record;
	above_16 bool;
    user_role_loop text := replace('{user_role}','"','');
BEGIN
	SELECT current_setting('server_version_num')::integer>170000 INTO above_16;
    FOR mv_record IN
        SELECT matviewname
        FROM pg_matviews
        WHERE schemaname = 'tww_app'

    LOOP
		IF above_16 THEN
			EXECUTE format('GRANT MAINTAIN ON tww_app.%I TO %I',
					  mv_record.matviewname,
					  user_role_loop);
		ELSE
			EXECUTE format('ALTER MATERIALIZED VIEW tww_app.%I OWNER TO %I',
					  mv_record.matviewname,
					  user_role_loop);
		END IF;
    END LOOP;
END;
$$;
