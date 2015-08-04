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
grafana2: debian
elasticsearch: debian
carbon-builder: python-wheel-onbuild
zookeeper: debian
graphite-api: graphite-api-builder
consuldns: consul

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
