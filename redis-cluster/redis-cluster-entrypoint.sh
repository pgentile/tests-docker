#!/bin/bash

set -e

cat >/etc/redis.conf <<-EOF
timeout 600
tcp-keepalive 60
loglevel notice
databases 1
appendonly yes

cluster-enabled yes
cluster-config-file redis-cluster.conf
cluster-node-timeout 5000
EOF

exec /usr/local/bin/docker-entrypoint.sh redis-server /etc/redis.conf "$@"
