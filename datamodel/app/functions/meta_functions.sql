CREATE OR REPLACE FUNCTION tww_app.check_all_nulls(rec record, prefix varchar(2),ignored_postfix text[] default Array['obj_id','identifier'])
RETURNS bool
AS
  $BODY$
    DECLARE
        rec_jsonb jsonb;
    BEGIN

	  rec_jsonb := (
          SELECT jsonb_object_agg(key, to_jsonb(rec)->key)
          FROM jsonb_object_keys(to_jsonb(rec)) key
          WHERE LEFT(key, 2) = prefix  
		  AND NOT(ltrim(key, prefix||'_') =ANY(ignored_postfix))
        );

      -- Check if all remaining values are NULL
      RETURN jsonb_strip_nulls(rec_jsonb)::text = '{{}}';
	  END;
  $BODY$
LANGUAGE plpgsql;
