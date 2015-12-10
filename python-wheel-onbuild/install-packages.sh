#!/bin/bash

set -e

pip install -r $REQUIREMENT_FILE

echo "Successful install of packages :"
pip freeze  --local | sed -r -e 's/^/  /'
