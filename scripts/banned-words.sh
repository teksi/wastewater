#!/usr/bin/env bash

# This test checks for use of deprecated/outdated methods and suggests their replacement

declare -a KEYWORDS=()
declare -a HINTS=()
declare -a EXCLUDES=()

KEYWORDS[0]="qgep"
HINTS[0]="No mention of QGEP"

RES=0
DIR=$(git rev-parse --show-toplevel)

pushd "${DIR}" >/dev/null || exit

for i in "${!KEYWORDS[@]}"; do
	FOUND=$(git grep "${KEYWORDS[$i]}" -- '*' -- ':!*banned-words.sh' ':!docs/en/wincan2qgep/**' ':!docs/.tx/config' | grep --invert-match skip-keyword-check)

	if [[ ${FOUND} ]]; then
		echo "Found source files with banned keyword: ${KEYWORDS[$i]}!"
		echo " -> ${HINTS[$i]}"
		echo "    or mark with // skip-keyword-check"
		echo
		echo "${FOUND}"
		echo
		RES=1
	fi

done

popd >/dev/null || exit

if [[ $RES -eq 1 ]]; then
	echo " *** Found banned keywords"
fi

exit $RES
