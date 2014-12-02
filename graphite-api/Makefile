all: graphite-api

# Construction des images

graphite-api: wheels/graphite-api/requirements.txt wheels/carbon/requirements.txt
	docker build -t pgentile/$@ .

# Wheels

wheels/graphite-api wheels/carbon:
	mkdir -p $@

wheels/graphite-api/requirements.txt: | wheels/graphite-api
	docker run --rm -v ${PWD}/wheels/graphite-api:/var/local/wheels pgentile/graphite-api-builder graphite-api gunicorn gevent supervisor

wheels/carbon/requirements.txt: | wheels/carbon
	docker run --rm -v ${PWD}/wheels/carbon:/var/local/wheels pgentile/carbon-builder

# Phony

.PHONY: all graphite-api
