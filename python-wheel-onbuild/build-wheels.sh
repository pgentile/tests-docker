#!/bin/bash

set -e

pip wheel --no-binary :all: --wheel-dir $WHEELS_OUTPUT_DIR --find-links $WHEELS_OUTPUT_DIR -r $REQUIREMENT_FILE

echo "Built wheels:"
ls -1 $WHEELS_OUTPUT_DIR/*.whl
echo

cd $WHEELS_OUTPUT_DIR
tar cf $WHEELS_ARCHIVE *.whl
cd - >/dev/null

echo "Built archive: $WHEELS_ARCHIVE"
