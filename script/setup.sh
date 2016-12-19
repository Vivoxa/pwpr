echo setup starting.....
docker-compose rm

echo build docker image
command="RAILS_ENV=development bundle && RAILS_ENV=development bundle exec rake db:drop db:create db:setup && RAILS_ENV=development bundle exec rails s -p 3000 -b '0.0.0.0'"

docker build --rm -f Dockerfile  --build-arg APP_DIR=pp_pwpr --build-arg  COMMAND="$command" -t pwpr_service .

echo setup complete