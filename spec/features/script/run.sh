#!/bin/bash
set -e

spec_output="--format html --out /desktop/results/$(date +"%F")/TEST_RUN_$(date +"%H%M")"

docker-compose build

SELENIUM_BROWSER=${VARIABLE:-firefox} # set default as firefox
docker-compose run -e BROWSER=$SELENIUM_BROWSER feature_tests  && echo 'test suite complete.'
