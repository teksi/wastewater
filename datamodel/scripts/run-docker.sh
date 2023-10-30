#!/usr/bin/env bash

set -e

docker build --build-arg RUN_TEST=True -f datamodel/.docker/Dockerfile --tag teksi/wastewater .
docker run -d -p 5433:5432 -v $(pwd)/datamodel:/src  --name teksi-wastewater teksi/wastewater
docker exec teksi-wastewater init_db.sh wait
docker exec teksi-wastewater init_db.sh build -d
