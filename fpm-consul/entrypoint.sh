#!/bin/bash

exec fpm \
    -f \
    -s dir \
    -t deb \
    --name consul \
    --version $CONSUL_VERSION \
    --license 'Mozilla Public License 2.0' \
    --category net \
    --url 'http://consul.io' \
    --description 'Consul - Service discovery and configuration made easy' \
    --config-files /lib/systemd/system/ \
    --config-files /etc/consul.d/ \
    --after-install scripts/after-install.sh \
    consul=/usr/bin/ \
    config/systemd/consul.service=/lib/systemd/system/ \
    config/consul/=/etc/consul.d/
