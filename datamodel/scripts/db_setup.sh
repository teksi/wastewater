#!/bin/bash

# This script will create a clean datastructure for the QGEP project based on
# the SIA 405 datamodel.
# It will create a new schema qgep in a postgres database.
#
# Environment variables:
#
#  * PGSERVICE
#      Specifies the postgres database to be used
#        Defaults to pg_qgep
#
#      Examples:
#        export PGSERVICE=pg_qgep
#        ./db_setup.sh

# Exit on error
set -e

SRID=2056

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

if [ "0${PGSERVICE}" = "0" ]
then
  PGSERVICE=pg_qgep
fi

while getopts ":rfs:p:" opt; do
  case $opt in
    f)
      force=True
      ;;
    r)
      roles=True
      permissions=True
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

if [[ $force ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS qgep_sys CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS qgep_od CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS qgep_vl CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS qgep_import CASCADE"
fi
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/00_qgep_schema.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/01_audit.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/02_oid_generation.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/03_qgep_db_dss.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/04_vsa_kek_extension.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/05_data_model_extensions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/06_symbology_functions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/07_network_tracking.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/09_qgep_dictionaries.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/09_qgep_dictionaries_kek.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_vsa_kek_extension.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_wastewater_structure.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_depth.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_od_file.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/50_maintenance_zones.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/functions/reach_direction_change.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/13_import.sql


${DIR}/view/create_views.py --pg_service ${PGSERVICE} --srid ${SRID}


if [[ $roles ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_0_roles.sql
fi
if [[ $permissions ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_1_roles.sql
fi

VERSION=$(cat ${DIR}/system/CURRENT_VERSION.txt)
pum baseline -p ${PGSERVICE} -t qgep_sys.pum_info -d ${DIR}/delta/ -b ${VERSION}


psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/14_geometry_functions.sql
