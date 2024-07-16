CREATE TABLE tww_od.default_values
(
    fieldname text NOT NULL,
    value_obj_id varchar(16),
    CONSTRAINT pkey_tww_sys_default_values_fieldname PRIMARY KEY (fieldname)
);

-- function for retrieving default obj_id
CREATE OR REPLACE FUNCTION tww_sys.get_default_values(field_name text)
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

-- Set defaults on all fk_provider,fk_dataowner
DO $do$
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
    WHERE c.column_name IN ('fk_provider','fk_dataowner')
      and c.table_schema ='tww_od'
	  and t.table_type = 'BASE TABLE'
    LOOP
        EXECUTE format($$ ALTER TABLE tww_od.%1$I ALTER COLUMN %2$I SET DEFAULT tww_sys.get_default_values('%2$s') $$, tbl,col);
    END LOOP;

END;
$do$;
