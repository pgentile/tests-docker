include before.mk

# Construction des images de base

IMAGES=
IMAGES += debian consul python-base python-wheel-onbuild
IMAGES += elasticsearch
IMAGES += redmine
IMAGES += consuldns
IMAGES += fpm
IMAGES += net-tools
IMAGES += elasticsearch-stream2es
IMAGES += jenkins
IMAGES += build-essentials

consul: debian
python-base: debian
python-wheel-onbuild: build-essentials
elasticsearch: debian
consuldns: consul
fpm: build-essentials
net-tools: debian
elasticsearch-stream2es: debian
build-essentials: debian


# Sous Makefiles

SUBMAKES=
SUBMAKES += fpm-consul
SUBMAKES += graphite

graphite: python-wheel-onbuild python-base debian
fpm-consul: fpm


# Includes
include docker.mk
include submake.mk
