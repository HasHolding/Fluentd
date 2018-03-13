#!/bin/sh
/usr/bin/fluentd -c ${FLUENTD_CONF} -p /shared/fluentd/plugins $FLUENTD_OPT