#!/bin/bash

set -ex

make -C .. haproxy
terraform taint docker_container.haproxy
terraform apply
