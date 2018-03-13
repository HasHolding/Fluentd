FROM hasholding/alpine-base

LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

ARG VERSION=1.1.1

RUN apk add --no-cache \
        ruby ruby-irb \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev wget gnupg \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 3.3.10 \
 && gem install json -v 2.1.0 \
 && gem install fluentd -v ${VERSION} \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

VOLUME ["/shared/fluentd/log","/shared/fluentd/etc","/shared/fluentd/plugins"]
COPY fluentd.conf /shared/fluentd/etc/
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="/shared/fluentd/etc/fluentd.conf"

ENV LD_PRELOAD=""
ENV DUMB_INIT_SETSID 0

EXPOSE 24224 5140
ENTRYPOINT ["/bin/entrypoint.sh"]
