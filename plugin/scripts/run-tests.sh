#!/bin/bash

# Arguments are passed one to one to pytest
#
# Run all tests:
# ./scripts/run-tests.sh # Run all tests
#
# Run all test starting with test_array_
# ./scripts/run-tests.sh -k test_array_

docker-compose run qgis /usr/src/plugin/.docker/run-docker-tests.sh $@
