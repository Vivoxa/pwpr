FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby-mysql2

ENV PDFTK_VERSION 2.02

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip build-essential gcj-jdk && \
    apt-get clean

ADD https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-${PDFTK_VERSION}-src.zip /tmp/
RUN unzip /tmp/pdftk-${PDFTK_VERSION}-src.zip -d /tmp && \
    sed -i 's/VERSUFF=-4.6/VERSUFF=-4.9/g' /tmp/pdftk-${PDFTK_VERSION}-dist/pdftk/Makefile.Debian && \
    cd /tmp/pdftk-${PDFTK_VERSION}-dist/pdftk && \
    make -f Makefile.Debian && \
    make -f Makefile.Debian install && \
    rm -Rf /tmp/pdftk-*


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
CMD bash -c "${COMMAND}"