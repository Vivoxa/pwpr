#!/bin/bash
set -e

spec_output="--format html --out /desktop/results/$(date +"%F")/TEST_RUN_$(date +"%H%M")"

docker-compose build

SELENIUM_BROWSER=${VARIABLE:-chrome} # set default as firefox

if [[  $@ == *"--save"*  ]] ;then
  echo 'Output results to /desktop/results...'

  docker-compose run -e BROWSER=$SELENIUM_BROWSER feature_tests $spec_output/results.html && echo 'test suite complete.'
else
  docker-compose run -e BROWSER=$SELENIUM_BROWSER feature_tests && echo 'test suite complete.'
fi


