FROM alpine:3.6

# install dumb-init, a simple process supervisor and init system
ENV DUMB_INIT_VERSION 1.1.3
RUN set -ex \
  && apk add --no-cache curl build-base bash \
  && curl -Lo dumb-init.tgz "https://github.com/Yelp/dumb-init/archive/v${DUMB_INIT_VERSION}.tar.gz" \
  && tar xzf dumb-init.tgz \
  && cd dumb-init-${DUMB_INIT_VERSION} \
  && make \
  && cp dumb-init /usr/bin \
  && cd .. \
  && rm -rf dumb-init* \
  && apk del curl build-base bash

ENV SIGIL_VERSION 0.4.0
RUN set -ex \
  && apk add --no-cache curl \
  && curl -Lo sigil.tgz "https://github.com/gliderlabs/sigil/releases/download/v${SIGIL_VERSION}/sigil_${SIGIL_VERSION}_Linux_x86_64.tgz" \
  && tar xzf sigil.tgz -C /usr/local/bin \
  && rm sigil.tgz \
  && apk del curl

ENV FILEBEAT_VERSION=6.5.0 \
    FILEBEAT_SHA512=ba23afb2ff159d34917b59a8d2b74f4b2e8fa27c3bc40a9ac2b6f3d646384098caa4fb4c4fcf4afe98f09520b548aa873a67ee3557f6061347aeecb74328de1b
RUN set -ex \
  && apk add --no-cache curl \
  && curl -Lo filebeat.tgz "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz" \
  && echo "${FILEBEAT_SHA512}  filebeat.tgz" | sha512sum -c - \
  && tar xzf filebeat.tgz \
  && cp filebeat-*/filebeat /usr/local/bin \
  && rm -rf filebeat* \
  && apk del curl

COPY docker-entrypoint.sh filebeat.yml.tmpl /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]
