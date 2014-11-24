#!/bin/bash -e

pip wheel -r /tmp/requirements.txt --wheel-dir /var/local/wheels/
cp /tmp/requirements.txt /var/local/wheels/
