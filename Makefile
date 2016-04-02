include before.mk

# Construction des images de base

IMAGES=
IMAGES += consul python-base python-wheel-onbuild
IMAGES += elasticsearch
IMAGES += redmine
IMAGES += consuldns
IMAGES += fpm
IMAGES += net-tools
IMAGES += elasticsearch-stream2es
IMAGES += build-essentials
IMAGES += zookeeper
IMAGES += kafka

python-wheel-onbuild: build-essentials
consuldns: consul
fpm: build-essentials


# Sous Makefiles

SUBMAKES=
SUBMAKES += fpm-consul
SUBMAKES += graphite

graphite: python-wheel-onbuild python-base
fpm-consul: fpm


# Includes
include docker.mk
include submake.mk
