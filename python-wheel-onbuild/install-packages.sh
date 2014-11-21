#!/bin/bash -e

if [[ -s /tmp/apt-packages.txt ]]
then
    exec apt-get install -q -y $(cat /tmp/apt-packages.txt)
fi
