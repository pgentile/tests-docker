#!/bin/bash -e

container_id=$(docker run -d -p 8500:8500 -p 53:53 -p 53:53/udp pgentile/consuldns -server -bootstrap-expect=1 -log-level=debug)
ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container_id)

echo "Booted $container_id with IP $ip"

exec docker run -i -t --dns=$ip pgentile/debian /bin/bash -l

# docker run -p 8500:8500 pgentile/consuldns -server -bootstrap-expect=1
