include ../../before.mk

IMAGE := graphite-api


# Construction des images

$(IMAGE): wheels/point

wheels/point: $(wildcard wheels/*.whl) | wheels graphite-api-builder
	docker rm graphite-api-builder 2>/dev/null || true
	docker run --name=graphite-api-builder pgentile/graphite-api-builder
	docker cp graphite-api-builder:/var/local/wheels/archive.tar wheels/archive.tar
	tar xf wheels/archive.tar -C wheels/
	rm wheels/archive.tar
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
