FROM alpine:3.7

ARG APP_DIR
ENV APP_DIR $APP_DIR

RUN mkdir /$APP_DIR

WORKDIR /$APP_DIR

COPY Gemfile Gemfile.lock . /$APP_DIR/
COPY id_rsa /root/.ssh/id_rsa

#add ruby and bundler
RUN apk --update add --no-cache bash ruby ruby-bigdecimal ruby-irb ruby-bundler \
grep less curl zlib openssh git \
&& rm -rf /var/cache/apk/* \
&& gem install -N rake -v 10.4.2 -- --use-system-libraries \
&& set -ex \
&& apk --update add nodejs mariadb-client-libs mariadb-client mariadb-libs vim \
&& apk --update add --virtual build-dependencies \
build-base ruby-dev mariadb-dev \
libffi-dev libc-dev linux-headers \
&& ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts \
&& chown 0400 /root/.ssh/id_rsa \
&& bundle install --system --retry 4 \
&& apk del build-dependencies

ARG COMMAND
ENV COMMAND ${COMMAND}
EXPOSE 3000
CMD bash -c "${COMMAND}"
