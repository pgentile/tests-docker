#!/bin/bash

set -e

set -x
exec envoy --config-path /tmp/config.json "$@"
