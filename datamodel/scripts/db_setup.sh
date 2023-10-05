#!/bin/bash

# This script will create a clean datastructure for the 
# TEKSI Wastewater & GEP project
# based on the VSA-DSS 2020 datamodel (see www.vsa.ch/model)
# It will create new schemata tww_* in a postgres database.
#
# Environment variables:
#
#  * PGSERVICE
#      Specifies the postgres database to be used
#        Defaults to pg_tww
#
#      Examples:
#        export PGSERVICE=pg_tww
#        ./db_setup.sh

# Exit on error
set -e

# set SRID
SRID=2056

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

if [ "0${PGSERVICE}" = "0" ]
then
  PGSERVICE=pg_tww
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

# clean database - drop schemata
if [[ $force ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_sys CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_od CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_vl CASCADE"
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS tww_import CASCADE"
fi

# recreate datamodel
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/00_tww_schema.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/01_audit.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/02_oid_generation.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/03_tww_db_dss.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/04_vsa_kek_extension.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/05_data_model_extensions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/06_symbology_functions.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/07_network_tracking.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/09_tww_dictionaries.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/09_tww_dictionaries_kek.sql

# fixes
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_wastewater_structure.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_depth.sql
# not needed anymore - already integrated in VSA-DSS 2020
# psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/fixes/fix_od_file.sql

# extra tables from VSA-DSS 2015
# extra feature from Koni - Is not VSA-DSS, so there is data loss when exporting with INTERLIS. These "Zones" or "Etappen" should be done with maintenance_events standard attributes
# psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/50_maintenance_zones.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/51_aquifier_2015.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/52_planning_zone_2015.sql

# extra function
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/functions/reach_direction_change.sql


# import classes
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/13_import.sql


# create views
${DIR}/view/create_views.py --pg_service ${PGSERVICE} --srid ${SRID}


# add roles
if [[ $roles ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_0_roles.sql
fi
if [[ $permissions ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/12_1_roles.sql
fi

# set pum baseline
VERSION=$(cat ${DIR}/system/CURRENT_VERSION.txt)
pum baseline -p ${PGSERVICE} -t tww_sys.pum_info -d ${DIR}/delta/ -b ${VERSION}


# add geometry functions
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/14_geometry_functions.sql
