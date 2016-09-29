FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby-mysql2
RUN mkdir /pp_pwpr
WORKDIR /pp_pwpr
ADD Gemfile /pp_pwpr/Gemfile
ADD Gemfile.lock /pp_pwpr/Gemfile.lock
RUN bundle install
ADD . /pp_pwpr
EXPOSE 3000
CMD bash -c "bundle && RAILS_ENV=production bundle exec rake assets:precompile && bundle exec rails s -p 3000 -b '0.0.0.0'"
