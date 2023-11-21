#!/usr/bin/env bash

set -e

BUILD=0
DEMO_DATA=0

while getopts 'd' opt; do
  case "$opt" in
    b)
      echo "Rebuild docker image"
      BUILD=1
      ;;

    d)
      echo "Load demo data"
      DEMO_DATA=1
      ;;

    ?|h)
      echo "Usage: $(basename $0) [-bd]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
if [[ $BUILD -eq 1 ]]; then
  docker build --build-arg RUN_TEST=True -f datamodel/.docker/Dockerfile --tag teksi/wastewater .
fi

docker rm -f teksi-wastewater
docker run -d -p 5433:5432 -v $(pwd)/datamodel:/src  --name teksi-wastewater teksi/wastewater -c log_statement=all
docker exec teksi-wastewater init_db.sh wait
if [[ $DEMO_DATA -eq 1 ]]; then
  docker exec teksi-wastewater init_db.sh build -d
fi
