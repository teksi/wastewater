#!/usr/bin/env bash

set -e

docker build -f .docker/Dockerfile --tag teksi/wastewater .
docker run -d -p 5433:5432 -v $(pwd):/src  --name teksi-wastewater teksi/wastewater
docker exec teksi-wastewater init_db.sh wait
docker exec teksi-wastewater init_db.sh build -d
