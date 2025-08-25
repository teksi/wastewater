CREATE OR REPLACE FUNCTION tww_app.check_all_nulls(
	jason jsonb,
	prefix_ character varying,
	ignored_postfix text[] DEFAULT ARRAY['obj_id'::text,
	'identifier'::text])
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
    BEGIN
	  SELECT array_agg(prefix_||'_'||t.val)
	  FROM  unnest(ignored_postfix) as t(val)
	  INTO ignored_postfix;

	  SELECT ignored_postfix||( SELECT array_agg(key)
	  FROM jsonb_object_keys(jason) key
          WHERE LEFT(key, char_length(prefix_)) != prefix_)
		INTO ignored_postfix;

	  jason := jason - ignored_postfix;
      -- Check if all remaining values are NULL
      RETURN jsonb_strip_nulls(jason)::text = '{{}}' OR jsonb_strip_nulls(jason)::text IS NULL;
	  END;
$BODY$;


CREATE OR REPLACE FUNCTION tww_app.refresh_materialized_views(_schema_name text, _matview_name text, _all bool DEFAULT False)
RETURNS void AS $$
DECLARE
    mv_record record;
    _error_message text;
BEGIN
    FOR mv_record IN
        SELECT schemaname, matviewname
        FROM pg_matviews
        WHERE schemaname = _schema_name
		AND (_all OR matviewname = _matview_name)

    LOOP
        BEGIN
            EXECUTE format('REFRESH MATERIALIZED VIEW %I.%I',
                          mv_record.schemaname,
                          mv_record.matviewname);
            RAISE NOTICE '%',format('Refreshed materialized view: %s.%s', mv_record.schemaname, mv_record.matviewname);
        EXCEPTION
            WHEN OTHERS THEN
                _error_message := format('Error refreshing materialized view %s.%s: %s',
                                       mv_record.schemaname, mv_record.matviewname, SQLERRM);
                RAISE EXCEPTION '%', _error_message;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
