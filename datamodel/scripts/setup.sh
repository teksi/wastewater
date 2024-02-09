#!/bin/bash

# This script will create a clean datastructure for the
# TEKSI Wastewater
# based on the VSA-DSS 2020 datamodel (see www.vsa.ch/model)
# It will create new schemats tww_* in a postgres database.

set -e

PGSERVICE=${PGSERVICE:-pg_tww}
SRID=2056

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

cd $DIR

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


psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_0_roles.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_1_roles.sql
