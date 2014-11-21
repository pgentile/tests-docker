#!/bin/bash -ex

apt-get install -q $(cat /tmp/apt-packages.txt)
pip wheel -r /tmp/requirements.txt --wheel-dir /var/local/wheels/
