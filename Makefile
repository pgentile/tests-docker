# Par défaut

all:

clean:

.PHONY: all clean


# Construction des images de base

IMAGES=
IMAGES += debian consul python-base python-wheel-onbuild graphite-api-builder
IMAGES += elasticsearch grafana2
IMAGES += carbon-builder zookeeper
IMAGES += redmine
IMAGES += consuldns
IMAGES += fpm
IMAGES += netcat
IMAGES += net-tools
IMAGES += elasticsearch-stream2es
IMAGES += jenkins
IMAGES += build-essentials

consul: debian
python-base: debian
python-wheel-onbuild: build-essentials
graphite-api-builder: python-wheel-onbuild
carbon-builder: python-wheel-onbuild
graphite-api: graphite-api-builder carbon-builder
grafana2: debian
elasticsearch: debian
zookeeper: debian
consuldns: consul
fpm: build-essentials
net-tools: debian
elasticsearch-stream2es: debian
build-essentials: debian


# Sous Makefiles

SUBMAKES=
SUBMAKES += graphite-api
SUBMAKES += fpm-consul

#graphite-api: graphite-api-builder
graphite-api: carbon-builder
fpm-consul: fpm


# Includes
include docker.mk
include submake.mk
