# Par défaut

all:

clean:

.PHONY: all clean


# Construction des images de base

IMAGES=
IMAGES += debian consul python-base python-wheel-onbuild graphite-api-builder
IMAGES += elasticsearch grafana2
IMAGES += carbon-builder zookeeper
IMAGES += redmine
IMAGES += consuldns
IMAGES += fpm
IMAGES += netcat
IMAGES += net-tools
IMAGES += elasticsearch-stream2es
IMAGES += jenkins
IMAGES += build-essentials

CLEAN_IMAGES=$(addprefix clean-,$(IMAGES))

all: $(IMAGES)
clean: $(CLEAN_IMAGES)

$(IMAGES):
	docker build -t pgentile/$@ $@

$(CLEAN_IMAGES):
	-docker rmi pgentile/$$(echo $@ | sed 's/^clean-//')

.PHONY: $(IMAGES) $(CLEAN_IMAGES)

consul: debian
python-base: debian
python-wheel-onbuild: build-essentials
graphite-api-builder: python-wheel-onbuild
carbon-builder: python-wheel-onbuild
graphite-api: graphite-api-builder carbon-builder
grafana2: debian
elasticsearch: debian
zookeeper: debian
consuldns: consul
fpm: build-essentials
net-tools: debian
elasticsearch-stream2es: debian
build-essentials: debian


# Sous Makefiles

SUBMAKES=
SUBMAKES += graphite-api
SUBMAKES += fpm-consul

CLEAN_SUBMAKES=$(addprefix clean-,$(SUBMAKES))

all: $(SUBMAKES)
clean: $(CLEAN_SUBMAKES)

$(SUBMAKES):
	$(MAKE) -C $@

$(CLEAN_SUBMAKES):
	name=$$(echo $@ | sed 's/^clean-//') && $(MAKE) -C $$name clean

.PHONY: $(SUBMAKES) $(CLEAN_SUBMAKES)

#graphite-api: graphite-api-builder
graphite-api: carbon-builder
fpm-consul: fpm
