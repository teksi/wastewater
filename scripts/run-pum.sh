#!/usr/bin/env bash

set -e
source .venv/bin/activate

.venv/bin/python -m pip install --ignore-installed ~/dev/pum
.venv/bin/python -m pip install --ignore-installed ~/dev/pirogue
pyenv rehash

export PGSERVICE=tww


psql -c "DROP SCHEMA IF EXISTS tww_od CASCADE;\
DROP SCHEMA IF EXISTS tww_sys CASCADE;\
DROP SCHEMA IF EXISTS tww_vl CASCADE;\
DROP SCHEMA IF EXISTS tww_cfg CASCADE;\
DROP SCHEMA IF EXISTS tww_app CASCADE;\
DROP SCHEMA IF EXISTS pum_test_data CASCADE;\
DROP TABLE IF EXISTS public.pum_migrations;"

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/12_0_roles.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/12_1_roles.sql

pum -vvv -s tww -d datamodel install -p SRID 2056
