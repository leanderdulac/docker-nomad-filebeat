FROM docker.elastic.co/beats/filebeat:6.5.0
# install dumb-init, a simple process supervisor and init system

USER root

ENV DUMB_INIT_VERSION 1.1.3
RUN set -ex \
  && yum install -y curl make gcc glibc-static \
  && curl -Lo dumb-init.tgz "https://github.com/Yelp/dumb-init/archive/v${DUMB_INIT_VERSION}.tar.gz" \
  && tar xzf dumb-init.tgz \
  && cd dumb-init-${DUMB_INIT_VERSION} \
  && make \
  && cp dumb-init /usr/bin \
  && cd .. \
  && rm -rf dumb-init* \
  && rpm -e --nodeps curl make gcc glibc-static

ENV SIGIL_VERSION 0.4.0
RUN set -ex \
  && yum install -y curl \
  && curl -Lo sigil.tgz "https://github.com/gliderlabs/sigil/releases/download/v${SIGIL_VERSION}/sigil_${SIGIL_VERSION}_Linux_x86_64.tgz" \
  && tar xzf sigil.tgz -C /usr/local/bin \
  && rm sigil.tgz \
  && rpm -e --nodeps curl

COPY docker-entrypoint.sh filebeat.yml.tmpl /

RUN chown -R filebeat:filebeat /usr/share/filebeat 

USER filebeat

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]
