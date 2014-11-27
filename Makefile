# Par défaut

all:

.PHONY: all


# Construction des images de base

IMAGES=consul python-base python-wheel-onbuild graphite-api-builder

all: $(IMAGES)

$(IMAGES):
	docker build -t pgentile/$@ $@

.PHONY: $(IMAGES)

python-wheel-onbuild: python-base
graphite-api-builder: python-wheel-onbuild


# Dependances

all: graphite-api

graphite-api: graphite-api-builder
	cd $@ && $(MAKE)
	
.PHONY: graphite-api