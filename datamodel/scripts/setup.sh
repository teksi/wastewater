#!/bin/bash
#!/usr/bin/env python

# This script will create a clean datastructure for the
# TEKSI Wastewater
# based on the VSA-DSS 2020 data model (see www.vsa.ch/model)
# It will create new schemats tww_* in a postgres database.
# It also integrates SIA405 Fernwirkkabel 2015
# to do: It also integrates SIA405 Schutzrohr 2015

set -e

PGSERVICE=${PGSERVICE:-pg_tww}
SRID=2056

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

cd $DIR

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/00_db_extensions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/01_schema.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/02_sys.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/oid_generation.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/03_tww_db_dss.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/04_vsa_kek_extension.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/03_tww_control_cable_db_sia405.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/03_tww_protection_tube_db_sia405.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/05_data_model_extensions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/06_swmm.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/07_network_tracking.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/09_tww_dictionaries.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/09_tww_dictionaries_kek.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/09_tww_control_cable_dictionaries.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/09_tww_protection_tube_dictionaries.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/13_import.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/14_default_values.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/fix_wastewater_structure.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/fix_depth.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/51_dss15_aquifer.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/52_dss15_planning_zone.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/51_dss15_aquifer_dictionaries.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/52_dss15_planning_zone_dictionaries.sql -v SRID=$SRID
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/changelogs/0001/90_audit.sql

${DIR}/app/create_app.py --pg_service ${PGSERVICE} --srid ${SRID}
${DIR}/manage_roles.py create_roles --pg_service ${PGSERVICE} --modulename tww
${DIR}/manage_roles.py grant --pg_service ${PGSERVICE} --modulename tww
