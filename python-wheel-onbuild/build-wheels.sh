#!/bin/bash -e

pip wheel --wheel-dir /var/local/wheels/ $@

rm -f /var/local/wheels/requirements.txt
while [[ -n "$1 " ]]
do
    case "$1" in
        -*)
            echo "$1 $2" >>/var/local/wheels/requirements.txt
            shift 2
            ;;
        *)
            echo "$1" >>/var/local/wheels/requirements.txt
            shift
            ;;
    esac
done

cat <<EOF
Pour installer les packages Whell generes :

    pip install -r @WHEEL_DIR@/requirements.txt --find-links @WHEEL_DIR@ --no-index
EOF
