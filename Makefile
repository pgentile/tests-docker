# Par défaut

all:

.PHONY: all


# Construction des images de base

IMAGES=
IMAGES += debian consul python-base python-wheel-onbuild graphite-api-builder
IMAGES += grafana elasticsearch serf serf-handler-test serf-aware-base
IMAGES += carbon-builder

all: $(IMAGES)

$(IMAGES):
	docker build -t pgentile/$@ $@

.PHONY: $(IMAGES)

consul: debian
python-base: debian
python-wheel-onbuild: python-base
graphite-api-builder: python-wheel-onbuild
grafana: debian
elasticsearch: debian
serf: debian
serf-handler-test: serf
serf-aware-base: python-base
carbon-builder: python-wheel-onbuild


# Sous Makefiles

SUBMAKES=graphite-api

all: $(SUBMAKES)

$(SUBMAKES):
	cd $@ && $(MAKE)
	
.PHONY: $(SUBMAKES)

graphite-api: graphite-api-builder
