#!/usr/bin/env bash

set -euo pipefail

# load env vars
# https://stackoverflow.com/a/20909045/1548052
if [ -f .env ]; then
  echo "Loading .env file"
  export $(grep -v '^#' .env | xargs)
elif [ -f .env.example ]; then
  echo "Loading .env.example file since .env is missing"
  export $(grep -v '^#' .env.example | xargs)
fi

BUILD=0
DEMO_DATA=
RUN_TESTS=0

while getopts 'bdt' opt; do
  case "$opt" in
    b)
      echo "Rebuild docker image"
      BUILD=1
      ;;

    d)
      echo "Load demo data"
      DEMO_DATA="-d ${DEMO_DATA_NAME}"
      ;;

    t)
      echo "Run tests"
      RUN_TESTS=1
      ;;

    ?|h)
      echo "Usage: $(basename $0) [-bd] [-p PG_PORT]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

docker compose down -v  --remove-orphans || true

if [[ $BUILD -eq 1 ]]; then
  echo "PUM VERSION is set to '${PUM_VERSION:-latest}'"
  if [[ "${PUM_VERSION:-latest}" == "latest" ]]; then
    docker pull opengisch/pum:latest
  fi
  docker compose build --no-cache
fi

docker compose up -d

docker compose run --rm pum --version

until docker compose exec db pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 3
done

echo "Creating database ${DB_NAME}"
docker compose exec db sh -c "createdb -U postgres ${DB_NAME}"
echo "install"
docker compose run --rm pum -p ${PGSERVICE} -d datamodel install -p SRID 2056 --max-version 2025.0.1 --skip-create-app ${DEMO_DATA}
echo "upgrade"
docker compose run --rm pum -v -p ${PGSERVICE} -d datamodel upgrade -p SRID 2056
if [[ $RUN_TESTS -eq 1 ]]; then
  echo "Running tests"
  docker compose run --rm --entrypoint pytest pum datamodel/test
fi
