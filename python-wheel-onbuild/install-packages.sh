#!/bin/bash

set -e

pip install -r $REQUIREMENT_FILE

echo "Successful install of packages :"
cat $REQUIREMENT_FILE | sed -r -e 's/^/  /'
