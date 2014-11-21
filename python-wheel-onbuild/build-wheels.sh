#!/bin/bash -e

exec pip wheel -r /tmp/requirements.txt --wheel-dir /var/local/wheels/
