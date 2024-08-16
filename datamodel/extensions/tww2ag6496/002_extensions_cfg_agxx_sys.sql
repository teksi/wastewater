-- Funktion zum Mapping der Organisations-ID

CREATE OR REPLACE FUNCTION {ext_schema}.convert_organisationid_to_vsa(oid varchar)
RETURNS varchar(16)
AS 
$BODY$
DECLARE
	out_oid varchar(16);
BEGIN
	SELECT obj_id INTO out_oid FROM tww_od.organisation WHERE right(obj_id,8) = right(oid,8);
	return out_oid;
END;
$BODY$
LANGUAGE plpgsql;


-- wird für Updates von letzte_aenderung_wi/gep genutzt
CREATE TABLE IF NOT EXISTS tww_cfg.agxx_last_modification_updater(
	username varchar(200) PRIMARY KEY
	, ag_update_type varchar(4) NOT NULL
	, CONSTRAINT ag_update_type_valid CHECK (ag_update_type = ANY(ARRAY['None','WI','GEP','Both'])));
	
------------------
-- System tables
------------------
INSERT INTO tww_sys.dictionary_od_table (id, tablename, shortcut_en) VALUES
(2999998,'measure_text','MX'),
(2999999,'building_group_text','GX')
ON CONFLICT DO NOTHING;
