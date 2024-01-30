#!/usr/bin/env bash

set -e

PROJECT=$1

if [[ -z ${PROJECT} ]]; then
  echo "Script takes the QGIS project path or its directory as argument"
  exit 1
fi

PATH=$(dirname ${PROJECT})

echo $PATH

if [[ ! -d ${PATH} ]]; then
  echo "'${PATH}' directory does not exist"
  exit 1
fi

FOUND=0
for f in ${PATH}/*\_*.ts
do
  FOUND=1
	lrelease $f ${f%.ts}.qm
done

if [[ ${FOUND} -eq 0 ]]; then
  echo "No TS file found in '${PATH}'"
fi
