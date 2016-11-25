#!/bin/bash
set -e

    if [[ $@ == *"--production"* ]] ;then
      command="RAILS_ENV=production bundle exec rake assets:precompile && RAILS_ENV=production bundle && RAILS_ENV=production bundle exec rake db:migrate && RAILS_ENV=production bundle exec rails s -p 3000 -b '0.0.0.0'"
      docker build --build-arg APP_DIR=app-pwpr --build-arg COMMAND=command -t=pwpr .
    fi

    if [[ $@ == *"--preprod"* ]] ;then
      command="RAILS_ENV=preprod bundle && RAILS_ENV=preprod bundle exec rake db:reset && RAILS_ENV=preprod bundle exec rails s -p 3000 -b '0.0.0.0'"
      docker build --build-arg APP_DIR=pre-pwpr --build-arg  COMMAND=command -t=pwpr .
    fi