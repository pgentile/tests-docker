#!/bin/bash

set -e

error() {
    echo "ERROR: $*" >&2
    false
}

ip="$1"
[[ -n "$ip" ]] || ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' mongo-rs-node1)
[[ -n "$ip" ]] || error "Can't get IP"

docker run --rm -it mongo:3 mongo "$ip"
