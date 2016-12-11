#!/usr/bin/env bash

set -e

echo "Preparing app for testing..."
export RAILS_ENV=test

echo "Bundling..."
bundle install || exit 1
echo 'Bundling success!'

echo "Setting up test DB..."
bundle exec rake db:drop \
  db:create \
  db:migrate \
  db:seed \
  || exit 1
echo 'Test DB setup Success!'

echo 'Seeding lookup tables'
bundle exec rake pwpr:populate_lookup_tables[test]
echo 'Lookup tables populated....'
echo 'App ready for testing!'
