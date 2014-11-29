# Par défaut

all:

.PHONY: all


# Construction des images de base

IMAGES=debian consul python-base python-wheel-onbuild graphite-api-builder grafana elasticsearch serf

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

# Dependances

all: graphite-api

graphite-api: graphite-api-builder
	cd $@ && $(MAKE)
	
.PHONY: graphite-api
