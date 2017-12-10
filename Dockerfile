FROM ruby:2.3.0

ARG APP_DIR
ENV APP_DIR $APP_DIR

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs ruby-mysql2 && \
    apt-get install -y --no-install-recommends unzip build-essential gcj-jdk && \
    apt-get install pdftk && \
    apt-get clean && \
    mkdir /$APP_DIR
WORKDIR /$APP_DIR

COPY . /$APP_DIR

RUN bundle install --system

ARG COMMAND
ENV COMMAND ${COMMAND}

EXPOSE 3000
CMD bash -c "${COMMAND}"
