#!/bin/bash

set -e

CONTAINER_NAME="$1"
IMAGE="$2"

docker rm $CONTAINER_NAME 2>/dev/null || true
docker run --name=$CONTAINER_NAME $IMAGE
docker cp $CONTAINER_NAME:/var/local/wheels/archive.tar wheels/archive-$CONTAINER_NAME.tar
tar xf wheels/archive-$CONTAINER_NAME.tar -C wheels/
rm wheels/archive-$CONTAINER_NAME.tar
