IMAGES=consul graphite-api

all: $(IMAGES)

$(IMAGES):
	docker build -t ${USER}/$@ $@

.PHONY: $(IMAGES)
