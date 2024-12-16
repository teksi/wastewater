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
      RETURN jsonb_strip_nulls(jason)::text = '{}' OR jsonb_strip_nulls(jason)::text IS NULL;
	  END;
$BODY$;