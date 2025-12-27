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


PUM_GH_SHA=${PUM_GH_SHA:-}

BUILD=0
DEMO_DATA=

while getopts 'bdp:' opt; do
  case "$opt" in
    b)
      echo "Rebuild docker image"
      BUILD=1
      ;;

    d)
      echo "Load demo data"
      DEMO_DATA="-d ${DEMO_DATA_NAME}"
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
  docker compose build --no-cache
fi

docker compose up -d

docker compose run --rm pum sh -c 'pum --version'

until docker compose exec db pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "Creating database ${DB_NAME}"
docker compose exec db sh -c "createdb -U postgres ${DB_NAME}"
docker compose run --rm pum pum -vvv -s ${PGSERVICE} -d datamodel install -p SRID 2056 --roles --grant ${DEMO_DATA}
