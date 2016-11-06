FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby-mysql2
RUN mkdir /pp_pwpr
WORKDIR /pp_pwpr
ADD ~/.ssh/pre-pwpr.pem /root/.ssh/pre-pwpr.pem
ADD Gemfile /pp_pwpr/Gemfile
ADD Gemfile.lock /pp_pwpr/Gemfile.lock
RUN bundle install
ADD . /pp_pwpr
EXPOSE 3000
CMD bash -c "bundle && RAILS_ENV=preprod bundle exec rake db:reset && RAILS_ENV=preprod bundle exec rails s -p 3000 -b '0.0.0.0'"
