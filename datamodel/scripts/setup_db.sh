#!/bin/bash

# This script will create a clean datastructure for the
# TEKSI Wastewater
# based on the VSA-DSS 2020 datamodel (see www.vsa.ch/model)
# It will create new schemats tww_* in a postgres database.

set -e

while getopts ":rfs:p:" opt; do
  case $opt in
    f)
      force=True
      ;;
    r)
      roles=True
      permissions=True
      ;;
    x)
      rolex=True
      ;;
    p)
      permissions=True
      ;;
    s)
      SRID=$OPTARG
      echo "-s was triggered, SRID: $SRID" >&2
      ;;
    p)
      PGSERVICE=$OPTARG
      echo "-p was triggered, PGSERVICE: $PGSERVICE" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

cd $DIR
if [[ $force ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_sys CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_od CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_vl CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_import CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_app CASCADE"
fi
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/01_schema.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/02_sys.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/oid_generation.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/03_tww_db_dss.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/04_vsa_kek_extension.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/05_data_model_extensions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/06_swmm.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/07_network_tracking.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/09_tww_dictionaries.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/09_tww_dictionaries_kek.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/13_import.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/fix_wastewater_structure.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/fix_depth.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/51_aquifier_2015.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/52_planning_zone_2015.sql -v SRID=$SRID

psql "service=${PGSERVICE}" -c "CREATE SCHEMA IF NOT EXISTS tww_app;"
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/app/symbology_functions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/app/reach_direction_change.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/app/14_geometry_functions.sql -v SRID=$SRID

${DIR}/app/view/create_views.py --pg_service ${PGSERVICE} --srid ${SRID}
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/app/triggers/network.sql

if [[ $roles ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_0_roles.sql
fi
if [[ $permissions ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_1_roles.sql
fi
if [[ $rolex ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_2_roles.sql -v db_identifier=$rolex
fi
