#!/usr/bin/env bash

set -e

EXIT_CODE=0

COUNT=$(git grep tww_app datamodel/changelogs | wc -l)
if [[ $COUNT -ne 0 ]]; then
  echo $(git grep tww_app datamodel/changelogs)
  echo "-> Some reference to app schema were found in changelogs"
  EXIT_CODE=$((EXIT_CODE+1))
fi

if [[ $EXIT_CODE -ne 0 ]]; then
  echo "*** $EXIT_CODE errors were found in datamodel"
else
 echo "No errors found"
fi

exit $EXIT_CODE