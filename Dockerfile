FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby-mysql2

ARG COMMAND
ENV COMMAND ${COMMAND}

ARG APP_DIR
ENV APP_DIR $APP_DIR

RUN mkdir /$APP_DIR
WORKDIR /$APP_DIR

ADD rails_command.sh /$APP_DIR/rails_command.sh

ADD Gemfile /$APP_DIR/Gemfile
ADD Gemfile.lock /$APP_DIR/Gemfile.lock
RUN bundle install
ADD . /$APP_DIR
EXPOSE 3000
CMD bash -c $COMMAND