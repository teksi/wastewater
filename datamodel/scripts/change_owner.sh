#!/bin/bash
owner=${OWNER}
schema=${SCHEMA}
database=${DATABASE}

uri="service=${PGSERVICE}"

psql -c "alter schema $schema owner to $owner"
for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = '$schema';" $database` ; do  psql -c "alter table $schema.$tbl owner to $owner" $database ; done
for tbl in `psql -qAt -c "select table_name from information_schema.views where table_schema = '$schema';" $database` ; do  psql -c "alter table $schema.$tbl owner to $owner" $database ; done
for tbl in `psql -qAt -c "select sequence_name from information_schema.sequences where sequence_schema = '$schema';" $database` ; do  psql -c "alter table $schema.$tbl owner to $owner" $database ; done
# Materialized views are not reported by information_schema
psql -c "alter table $schema.vw_network_node owner to $owner" $database
psql -c "alter table $schema.vw_network_segment owner to $owner" $database
