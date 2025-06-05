#!/usr/bin/env bash

set -e
source .venv/bin/activate

.venv/bin/python -m pip install --ignore-installed ~/dev/pum
.venv/bin/python -m pip install --ignore-installed ~/dev/pirogue
pyenv rehash

export PGSERVICE=tww

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/roles/roles_drop.sql


psql -c "DROP SCHEMA IF EXISTS tww_od CASCADE;\
DROP SCHEMA IF EXISTS tww_sys CASCADE;\
DROP SCHEMA IF EXISTS tww_vl CASCADE;\
DROP SCHEMA IF EXISTS tww_cfg CASCADE;\
DROP SCHEMA IF EXISTS tww_app CASCADE;\
DROP SCHEMA IF EXISTS pum_test_data CASCADE;\
DROP TABLE IF EXISTS public.pum_migrations;"



#psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/roles/roles_create.sql
#psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/roles/roles_grant.sql

pum -vvv -s pg_tww -d datamodel install -p SRID 2056
