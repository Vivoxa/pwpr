FROM ruby:2.3.0

ARG APP_DIR
ENV APP_DIR $APP_DIR

ENV PDFTK_VERSION 2.02

ADD https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-${PDFTK_VERSION}-src.zip /tmp/

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby-mysql2 && \
    apt-get install -y --no-install-recommends unzip build-essential gcj-jdk && \
    apt-get clean && \
    unzip /tmp/pdftk-${PDFTK_VERSION}-src.zip -d /tmp && \
    sed -i 's/VERSUFF=-4.6/VERSUFF=-4.9/g' /tmp/pdftk-${PDFTK_VERSION}-dist/pdftk/Makefile.Debian && \
    cd /tmp/pdftk-${PDFTK_VERSION}-dist/pdftk && \
    make -f Makefile.Debian && \
    make -f Makefile.Debian install && \
    mkdir /$APP_DIR && \
    rm -Rf /tmp/pdftk-*

WORKDIR /$APP_DIR

ADD . /$APP_DIR
COPY Gemfile $APP_DIR
COPY Gemfile.lock $APP_DIR

RUN bundle install --system

COPY . /$APP_DIR

ARG COMMAND
ENV COMMAND ${COMMAND}

EXPOSE 3000
CMD bash -c "${COMMAND}"
