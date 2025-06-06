#!/usr/bin/env bash

set -e

INSTALL_DEPS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-deps|-i)
      INSTALL_DEPS=1
      shift
      ;;
    *)
      shift
      ;;
  esac
done

source .venv/bin/activate

if [[ $INSTALL_DEPS -eq 1 ]]; then
  .venv/bin/python -m pip install --ignore-installed ~/dev/pum
  .venv/bin/python -m pip install --ignore-installed ~/dev/pirogue
  pyenv rehash
fi

export PGSERVICE=tww

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/roles/roles_drop.sql


psql -c "DROP SCHEMA IF EXISTS tww_od CASCADE;\
DROP SCHEMA IF EXISTS tww_sys CASCADE;\
DROP SCHEMA IF EXISTS tww_vl CASCADE;\
DROP SCHEMA IF EXISTS tww_cfg CASCADE;\
DROP SCHEMA IF EXISTS tww_app CASCADE;\
DROP ROLE IF EXISTS tww_viewer;\
DROP ROLE IF EXISTS tww_user;\
DROP ROLE IF EXISTS tww_manager;\
DROP ROLE IF EXISTS tww_sysadmin;"



#psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/roles/roles_create.sql
#psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f datamodel/roles/roles_grant.sql

pum -vvv -s pg_tww -d datamodel install -p SRID 2056 --roles --grant
