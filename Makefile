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
IMAGES += fpm-consul
IMAGES += elasticsearch-stream2es
IMAGES += jenkins

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
python-wheel-onbuild: python-base
graphite-api-builder: python-wheel-onbuild
carbon-builder: python-wheel-onbuild
graphite-api: graphite-api-builder carbon-builder
grafana2: debian
elasticsearch: debian
zookeeper: debian
consuldns: consul
fpm: debian
net-tools: debian
fpm-consul: fpm
elasticsearch-stream2es: debian

# Sous Makefiles

SUBMAKES=graphite-api

CLEAN_SUBMAKES=$(addprefix clean-,$(SUBMAKES))

all: $(SUBMAKES)
clean: $(CLEAN_SUBMAKES)

$(SUBMAKES):
	cd $@ && $(MAKE)

$(CLEAN_SUBMAKES):
	name=$$(echo $@ | sed 's/^clean-//') && cd $$name && $(MAKE) clean

.PHONY: $(SUBMAKES) $(CLEAN_SUBMAKES)

graphite-api: graphite-api-builder
