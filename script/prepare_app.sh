#!/usr/bin/env bash

set -e

echo "Preparing app..."

echo "Bundling..."
bundle install || exit 1
echo 'Bundling success!'

echo "Setting up DB..."
bundle exec rake db:drop \
  db:create \
  db:setup \
  || exit 1
echo 'DB setup Success!'
echo 'App ready!'
