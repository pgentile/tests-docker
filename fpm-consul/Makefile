DEBIAN_PACKAGE := consul_0.5.2_amd64.deb
OUTPUT_PACKAGE := test/consul.deb

all: test

clean:
	-docker rm consul-builder
	-rm -f $(OUTPUT_PACKAGE)

.PHONY: all clean

$(OUTPUT_PACKAGE):
	docker build -t pgentile/fpm-consul .
	-docker rm consul-builder
	docker run --name=consul-builder pgentile/fpm-consul
	docker cp consul-builder:/var/fpm/workdir/$(DEBIAN_PACKAGE) $@
	docker rm consul-builder

test: $(OUTPUT_PACKAGE)
	docker build -t pgentile/fpm-consul-test ./test

.PHONY: test
