IMAGE := graphite-api

all: $(IMAGE)

clean:
	-rm -fr wheels/
	-docker rmi pgentile/$(IMAGE)

# Construction des images

$(IMAGE): | wheels
	../build-wheels.sh graphite-api-builder pgentile/graphite-api-builder
	docker build -t pgentile/$(IMAGE) .

# Wheels

wheels:
	mkdir -p $@

# Phony

.PHONY: all $(IMAGE) clean
