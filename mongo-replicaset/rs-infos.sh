#!/bin/bash

set -e

for i in $(seq 3); do
    container_name="mongo-rs-node$i"
    docker inspect -f '{{ .Name }}: {{ .NetworkSettings.IPAddress }}' $container_name
done
