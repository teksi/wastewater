DO
$BODY$
DECLARE
tbl_name text;
BEGIN
	BEGIN
	   FOR tbl_name IN (
			SELECT dot.tablename
			FROM information_schema.sequences seq
			LEFT JOIN tww_sys.dictionary_od_table dot ON seq.sequence_name = 'seq_'||dot.tablename||'_oid'
			WHERE seq.sequence_schema = 'tww_od' AND dot.tablename IS NOT NULL) LOOP
				EXECUTE FORMAT('ALTER SEQUENCE tww_od.seq_%1$I_oid MAXVALUE 2176782335;',tbl_name,rgx);
	   END LOOP;
	END;
END;
$BODY$;
