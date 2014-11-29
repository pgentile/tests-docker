#!/bin/bash -e

pip wheel --wheel-dir /var/local/wheels/ $@

rm -f /var/local/wheels/requirements.txt
for name in $@
do
    echo $name >>/var/local/wheels/requirements.txt
done

cat <<EOF
Pour installer les packages Whell generes :

  pip install -r @WHEEL_DIR@/requirements.txt --find-links @WHEEL_DIR@ --no-index
EOF
