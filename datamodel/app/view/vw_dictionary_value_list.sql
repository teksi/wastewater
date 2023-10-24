
CREATE VIEW tww_sys.dictionary_value_list AS
  SELECT p.relname AS vl_name, vl.*
  FROM tww_vl.value_list_base vl, pg_class p
  WHERE vl.tableoid = p.oid;
