#!/usr/bin/env bash

set -e

PROJECT=$1

if [[ -z ${PROJECT} ]]; then
  echo "Script takes the QGIS project path or its directory as argument"
  exit 1
fi

DIR=$(dirname ${PROJECT})

echo $DIR

if [[ ! -d ${DIR} ]]; then
  echo "'${DIR}' directory does not exist"
  exit 1
fi

FOUND=0
for f in ${DIR}/*\_*.ts
do
  FOUND=1
	lrelease $f ${f%.ts}.qm
	rm $f # do not package ts files
done

if [[ ${FOUND} -eq 0 ]]; then
  echo "No TS file found in '${DIR}'"
fi
