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
      AND c.table_schema = t.table_schema
    WHERE c.column_name IN (SELECT fieldname FROM tww_od.default_values)
      AND c.table_schema ='tww_app'
	  AND t.table_type = 'VIEW'
    LOOP
        EXECUTE format($$ ALTER VIEW tww_app.%1$I ALTER %2$I SET DEFAULT tww_app.get_default_values('%2$s') $$, tbl,col);
    END LOOP;

END;
$BODY$;

ALTER TABLE tww_od.import_damage_ws_quarantine ALTER COLUMN obj_id DEFAULT tww_app.generate_oid('tww_od'::text, 'damage_manhole'::text);
ALTER TABLE tww_od.import_examination_quarantine ALTER COLUMN obj_id DEFAULT tww_app.generate_oid('tww_od'::text, 'examination'::text);
ALTER TABLE tww_od.import_picture_quarantine ALTER COLUMN obj_id DEFAULT tww_app.generate_oid('tww_od'::text, 'file'::text);
ALTER TABLE tww_od.import_ws_quarantine ALTER COLUMN ws_obj_id DEFAULT tww_app.generate_oid('tww_od'::text, 'wastewater_structure'::text);
ALTER TABLE tww_od.import_reach_quarantine ALTER COLUMN obj_id DEFAULT tww_app.generate_oid('tww_od'::text, 'reach'::text);
