#!/bin/bash -ex

cd /tmp

git clone https://github.com/graphite-project/carbon.git
cd carbon
git checkout 0.9.12
rm setup.cfg
python setup.py install
