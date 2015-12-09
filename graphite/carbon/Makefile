include ../../before.mk

IMAGE := carbon


# Construction des images

$(IMAGE): wheels/point

wheels/point: $(wildcard wheels/*.whl) | wheels
	../build-wheels.sh carbon-builder pgentile/carbon-builder
	touch $@

wheels:
	mkdir -p $@

clean-wheels:
	-rm -rf wheels

clean: clean-wheels

.PHONY: clean-wheels


# Includes

include ../../local-docker.mk
