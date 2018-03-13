FROM alpine:3.7
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

ENV DUMB_INIT_VERSION=1.2.0
ENV SU_EXEC_VERSION=0.2
ARG DEBIAN_FRONTEND=noninteractive

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb \
        su-exec==${SU_EXEC_VERSION}-r0 \
        dumb-init==${DUMB_INIT_VERSION}-r0 \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev wget gnupg \
 && update-ca-certificates \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 3.3.10 \
 && gem install json -v 2.1.0 \
 && gem install fluentd -v 1.1.1 \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

VOLUME ["/shared/fluentd/log","/shared/fluentd/etc","/shared/fluentd/plugins"]
#RUN mkdir -p /fluentd/log
#RUN mkdir -p /fluentd/etc /fluentd/plugins

COPY fluentd.conf /shared/fluentd/etc/
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="/shared/fluentd/etc/fluentd.conf"

ENV LD_PRELOAD=""
ENV DUMB_INIT_SETSID 0

EXPOSE 24224 5140
ENTRYPOINT ["/bin/entrypoint.sh"]
