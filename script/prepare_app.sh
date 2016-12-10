#!/usr/bin/env bash

set -e

echo "Preparing app..."
export RAILS_ENV=development

echo "Bundling..."
bundle install || exit 1
echo 'Bundling success!'

echo "Setting up DB..."
bundle exec rake db:drop \
  db:create \
  db:setup \
  || exit 1
echo 'DB setup Success!'

echo 'Seeding lookup tables'
bundle exec rake pwpr:populate_lookup_tables[development]
echo 'Lookup tables populated....'

echo 'App ready!'
