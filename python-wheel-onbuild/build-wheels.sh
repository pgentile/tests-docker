#!/bin/bash -e

pip wheel --wheel-dir /var/local/wheels/ $@

echo >/var/local/wheels/requirements.txt
for name in $@
do
    echo $name >>/var/local/wheels/requirements.txt
done
