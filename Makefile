IMAGES=consul graphite-api python-wheel-onbuild

all: $(IMAGES)

$(IMAGES):
	docker build -t ${USER}/$@ $@

.PHONY: $(IMAGES)
