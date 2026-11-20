#!/usr/bin/env bash

export PGUSER=postgres

# determine the pg_service conf file location
if [ -z "$PGSYSCONFDIR" ]; then
    PGSERVICE_FILE="$HOME/.pg_service.conf"
else
    PGSERVICE_FILE="$PGSYSCONFDIR/pg_service.conf"
fi

SERVICE_NAME="pg_tww"
DATABASE_NAME="tww"
echo "Adding service ${SERVICE_NAME} to $PGSERVICE_FILE"
printf "[${SERVICE_NAME}]\nhost=localhost\ndbname=${DATABASE_NAME}\nuser=postgres\npassword=postgres\n\n" >> "$PGSERVICE_FILE"

psql -c "DROP DATABASE IF EXISTS ${DATABASE_NAME};" "service=${SERVICE_NAME} dbname=postgres"
psql -c "CREATE DATABASE  ${DATABASE_NAME};" "service=${SERVICE_NAME} dbname=postgres"
