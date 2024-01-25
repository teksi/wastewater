#!/usr/bin/env bash

# Exit on error
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..
pushd ${DIR}
make clean
if [ -f ~/.transifexrc ]; then
make transifex_pull
fi
make html
# make all-pdf
popd
