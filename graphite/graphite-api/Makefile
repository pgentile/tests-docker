include ../../before.mk

IMAGE := graphite-api


# Construction des images

$(IMAGE): wheels/point

wheels/point: $(wildcard wheels/*.whl) | wheels graphite-api-builder
	../build-wheels.sh graphite-api-builder pgentile/graphite-api-builder
	touch $@

wheels:
	mkdir -p $@

clean-wheels:
	-rm -rf wheels

clean: clean-wheels

.PHONY: clean-wheels


# Build image

graphite-api-builder:
	docker build -t pgentile/$@ -f build.Dockerfile .

.PHONY: graphite-api-builder


# Includes

include ../../local-docker.mk
