CREATE TABLE tww_sys.default_values
(
    fieldname text NOT NULL,
    value_obj_id varchar(16),
    CONSTRAINT pkey_tww_sys_default_values_fieldname PRIMARY KEY (fieldname)
);

-- function for retrieving default organisations
CREATE OR REPLACE FUNCTION tww_sys.get_default_values(field_name text, data_type text)
  RETURNS varchar(16) AS
$BODY$
DECLARE
    myrec record;
BEGIN
  -- first we have to get the OID prefix
  BEGIN
    SELECT value_obj_id::varchar(16) ,value_integer INTO myrec FROM tww_sys.default_organisations WHERE fieldname = field_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE WARNING 'Field name % not found in table tww_sys.default_organisations. Returning NULL',field_name;
		   RETURN NULL;
  END;
  RETURN myrec.value_obj_id;
END;
$BODY$
  LANGUAGE plpgsql STABLE
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
    WHERE c.column_name IN ('fk_provider','fk_dataowner')
      and c.table_schema ='tww_od'
    LOOP
        EXECUTE format($$ ALTER TABLE tww_od.%1$I ALTER COLUMN %2$I SET DEFAULT tww_sys.get_default_values('''%2$s''','obj_id') $$, tbl,col);
    END LOOP;

END;
$do$;
