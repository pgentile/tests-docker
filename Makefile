IMAGES=consul graphite-api python-wheel-onbuild graphite-api-builder

all: $(IMAGES)

$(IMAGES):
	docker build -t pgentile/$@ $@

.PHONY: $(IMAGES)

graphite-api-builder: python-wheel-onbuild
