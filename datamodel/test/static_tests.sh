#!/usr/bin/env bash

set -e

EXIT_CODE=0

COUNT=$(git grep tww_app datamodel/changelogs | wc -l)
if [[ $COUNT -ne 0 ]]; then
  echo $(git grep tww_app datamodel/changelogs)
  echo "-> Some reference to app schema were found in changelogs"
  EXIT_CODE=$((EXIT_CODE+1))
fi


search_path="/datamodel/app/extension"

# regex pattern to match CREATE TABLE statements
pattern="CREATE\s*(?:(?:GLOBAL|LOCAL)\s*)?(?:TEMPORARY|TEMP|UNLOGGED)\s*TABLE\s*(?:IF\s*NOT\s*EXISTS\s*)?[[:space:]]+([[:alnum:]]+\.)?tww\_od\.[[:alnum:]]+"

for folder in "$search_path"/*; do
  if [ -d "$folder" ]; then
    echo "Searching in folder: $folder"
    matches=$(git grep -i -E -- "$folder/.*\.sql$" "$pattern" | wc -l)
    if [[ $matches -ne 0 ]]; then
      echo "$matches errors found in $folder"
      EXIT_CODE=$((EXIT_CODE + matches))
    fi
  fi
done


if [[ $EXIT_CODE -ne 0 ]]; then
  echo "*** $EXIT_CODE errors were found in datamodel"
else
 echo "No errors found"
fi

exit $EXIT_CODE
