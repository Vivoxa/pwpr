# FROM codeguru/ruby:2.2_alpine
FROM ruby:2.3.0-alpine

RUN apk add --update  build-base libxml2-dev libxslt-dev wget
RUN bundle config build.nokogiri --use-system-libraries

ENV APP_HOME /app
WORKDIR /app
RUN mkdir -p $APP_HOME

ENV DOCKER true

COPY Gemfile  ./
COPY Gemfile.lock  ./
RUN bundle install

COPY .rspec .rspec
COPY ./spec/ ./spec/

ENTRYPOINT [ "bundle", "exec", "rspec"]
