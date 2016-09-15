#!/bin/bash

set -e

cat >/etc/redis.conf <<-EOF
timeout 600
tcp-keepalive 60
loglevel notice

cluster-enabled yes
cluster-config-file redis-cluster.conf
cluster-node-timeout 5000
EOF

create_cluster_file=/usr/local/bin/create-cluster.sh

cat >$create_cluster_file <<-EOF
#!/bin/bash
nodes=\$(getent hosts redis01 redis02 redis03 redis04 redis05 redis06 | awk '{ print \$1 ":6379" }')
exec redis-trib.rb create --replicas 1 \$nodes
EOF

chmod +x $create_cluster_file

exec docker-entrypoint.sh redis-server /etc/redis.conf "$@"
