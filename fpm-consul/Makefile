CONSUL_VERSION := 0.6.4
DEBIAN_PACKAGE := consul_$(CONSUL_VERSION)_amd64.deb
OUTPUT_PACKAGE := test/consul.deb

all: test

clean:
	-docker rm consul-builder
	-rm -f $(OUTPUT_PACKAGE)

.PHONY: all clean

$(OUTPUT_PACKAGE):
	docker build --build-arg CONSUL_VERSION=$(CONSUL_VERSION) -t pgentile/fpm-consul .
	-docker rm consul-builder
	docker run --name=consul-builder pgentile/fpm-consul
	docker cp consul-builder:/var/fpm/workdir/$(DEBIAN_PACKAGE) $@
	docker rm consul-builder

test: $(OUTPUT_PACKAGE)
	docker build -t pgentile/fpm-consul-test ./test
	docker run --rm pgentile/fpm-consul-test dpkg-query -l | grep consul
	docker run --rm pgentile/fpm-consul-test systemctl list-unit-files | grep consul

.PHONY: test
