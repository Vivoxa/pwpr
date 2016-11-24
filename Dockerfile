FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby-mysql2

ARG APP_ENV=local
ENV APP_ENV ${APP_ENV}

ARG APP_DIR=local
ENV APP_DIR ${APP_DIR}

RUN mkdir /${APP_DIR}
WORKDIR /${APP_DIR}

ADD rails_command.sh /${APP_DIR}/rails_command.sh

ADD Gemfile /${APP_DIR}/Gemfile
ADD Gemfile.lock /${APP_DIR}/Gemfile.lock
RUN bundle install
ADD . /${APP_DIR}
EXPOSE 3000
CMD ['/rails_command.sh', ${APP_ENV}]