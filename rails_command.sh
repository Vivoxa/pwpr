#!/bin/bash
set -e

if [ "$1" = 'production' ]; then
  RAILS_ENV=production bundle exec rake assets:precompile && RAILS_ENV=production bundle && RAILS_ENV=production bundle exec rake db:migrate && RAILS_ENV=production bundle exec rails s -p 3000 -b '0.0.0.0'
else
  RAILS_ENV=preprod bundle && RAILS_ENV=preprod bundle exec rake db:drop db:create db:migrate db:seed && RAILS_ENV=preprod bundle exec rails s -p 3000 -b '0.0.0.0'
fi