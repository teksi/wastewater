CREATE OR REPLACE FUNCTION tww_app.set_organisations_active(_undo_existing boolean default false)
  RETURNS void AS
$BODY$
DECLARE
schm text;
tbl text;
col text;
BEGIN
IF _undo_existing THEN
	UPDATE tww_od.organisation
	SET tww_active=FALSE;
ELSE NULL;
END IF;
FOR schm,tbl,col IN
	SELECT   tc.table_schema,
		tc.table_name,
		kcu.column_name
	FROM (SELECT constraint_name FROM information_schema.constraint_column_usage
	WHERE table_schema='tww_od'
		AND table_name='organisation'
		AND column_name='obj_id'
		AND constraint_name NOT LIKE'pkey%')ccu
	INNER JOIN information_schema.key_column_usage AS kcu
	ON ccu.constraint_name = kcu.constraint_name
	INNER JOIN information_schema.table_constraints AS tc
		ON tc.constraint_name = kcu.constraint_name
LOOP
	        EXECUTE format($$ UPDATE tww_od.organisation
SET tww_active=TRUE
WHERE obj_id IN (SELECT DISTINCT %I FROM %I.%I)$$, col,schm,tbl);
END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- function for retrieving default obj_id
CREATE OR REPLACE FUNCTION tww_app.get_default_values(field_name text)
  RETURNS varchar(16) AS
$BODY$
DECLARE
    myrec record;
BEGIN
  BEGIN
    SELECT value_obj_id::varchar(16) INTO myrec FROM tww_od.default_values WHERE fieldname = field_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE WARNING 'Field name % not found in table tww_od.default_values. Returning NULL',field_name;
		   RETURN NULL;
  END;
  RETURN myrec.value_obj_id;
END;
$BODY$
  LANGUAGE plpgsql STABLE SECURITY DEFINER
  COST 100;

-- Set defaults on all fk_provider,fk_dataowner,fk_owner
DO
$BODY$
DECLARE
    tbl text;
	col text;
BEGIN
	FOR tbl,col IN
	SELECT
       c.table_name,
	   c.column_name
    FROM information_schema.columns c
	LEFT JOIN information_schema.tables t
	ON c.table_name = t.table_name
    and c.table_schema = t.table_schema
    WHERE c.column_name IN ('fk_provider','fk_dataowner','fk_owner')
      and c.table_schema ='tww_od'
	  and t.table_type = 'BASE TABLE'
    LOOP
        EXECUTE format($$ ALTER TABLE tww_od.%1$I ALTER COLUMN %2$I SET DEFAULT tww_app.get_default_values('%2$s') $$, tbl,col);
    END LOOP;
END;
$BODY$;
