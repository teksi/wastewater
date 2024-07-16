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
