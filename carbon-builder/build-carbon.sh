#!/bin/bash

set -e

cd /tmp/carbon
python2.7 setup.py bdist_wheel
cp dist/*.whl $WHEELS_OUTPUT_DIR/
cd - >/dev/null

build-wheels.sh carbon==$CARBON_VERSION
