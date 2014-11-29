#!/bin/bash -e

export ES_HOME=/usr/share/elasticsearch

exec /usr/share/elasticsearch/bin/elasticsearch \
    --default.path.home=$ES_HOME \
    --default.path.logs=/var/log/elasticsearch \
    --default.path.data=/var/lib/elasticsearch \
    --default.path.work=/tmp/elasticsearch \
    --default.path.conf=/etc/elasticsearch \
    $@
