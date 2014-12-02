#!/bin/bash -e

cd /tmp/carbon

python2.7 setup.py bdist_wheel
mv dist/*.whl /var/local/wheels/

echo carbon >/var/local/wheels/requirements.txt
