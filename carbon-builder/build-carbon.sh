#!/bin/bash -e

cd /tmp/carbon

python2.7 setup.py bdist_wheel
mv dist/*.whl /var/local/wheels/

echo carbon >/var/local/wheels/requirements.txt

requirements='Twisted==11.1.0 txamqp whisper==0.9.12'
for requirement in $requirements
do
    echo "$requirement" >>/var/local/wheels/requirements.txt
done

pip wheel --wheel-dir /var/local/wheels/ $requirements
