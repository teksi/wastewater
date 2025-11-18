#!/usr/bin/env bash

set -e

# load env vars
# https://stackoverflow.com/a/20909045/1548052
if [ -f .env ]; then
  echo "Loading .env file"
  export $(grep -v '^#' .env | xargs)
elif [ -f .env.example ]; then
  echo "Loading .env.example file since .env is missing"
  export $(grep -v '^#' .env.example | xargs)
fi

DOCKER_TAG=${DOCKER_TAG:-opengisch/pum_db}
CONTAINER_NAME=${CONTAINER_NAME:-pum_db_test}
DB_NAME=${DB_NAME:-pum_test}
PG_SERVICE=${PG_SERVICE:-pg_pum_test}
DEMO_DATA_NAME=${DEMO_DATA_NAME:-}
PUM_GH_SHA=${PUM_GH_SHA:-}
TEST_PACKAGES=${TEST_PACKAGES:-""}

BUILD=0
DEMO_DATA=
PG_CONTAINER_PORT=${PG_CONTAINER_PORT:-5432}

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

    p)
      echo "Overriding PG port to ${OPTARG}"
      PG_PORT=${OPTARG}
      ;;


    ?|h)
      echo "Usage: $(basename $0) [-bd] [-p PG_PORT]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [[ $BUILD -eq 1 ]]; then
  docker build \
  --build-arg RUN_TEST=True \
  --build-arg PUM_GH_SHA=${PUM_GH_SHA} \
  --build-arg DB_NAME=${DB_NAME} \
  --build-arg PG_SERVICE=${PG_SERVICE} \
  -f datamodel/.docker/Dockerfile \
  --tag ${DOCKER_TAG} \
  .
fi

docker rm -f ${CONTAINER_NAME} || true
docker run -d -p ${PG_CONTAINER_PORT}:5432 -v $(pwd):/usr/src --name ${CONTAINER_NAME} ${DOCKER_TAG} -c log_statement=all

docker exec ${CONTAINER_NAME} sh -c 'pum --version'

until docker exec ${CONTAINER_NAME} pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "Creating database ${DB_NAME}"
docker exec ${CONTAINER_NAME} sh -c "createdb ${DB_NAME}"
docker exec ${CONTAINER_NAME} pum -vvv -s ${PG_SERVICE} -d datamodel install -p SRID 2056 --roles --grant ${DEMO_DATA}
