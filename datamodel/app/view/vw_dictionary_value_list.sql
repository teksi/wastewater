
CREATE OR REPLACE VIEW tww_app.sys_dictionary_value_list AS
  SELECT
  p.relname AS vl_name,
  vl.code,
  vl.vsacode,
  vl.value_en,
  vl.value_de,
  vl.value_fr,
  vl.value_it,
  vl.value_ro,
  vl.abbr_en,
  vl.abbr_de,
  vl.abbr_fr,
  vl.abbr_it,
  vl.abbr_ro,
  vl.active
FROM tww_vl.value_list_base vl, pg_class p
WHERE vl.tableoid = p.oid;
