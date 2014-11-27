all: graphite-api

# Construction des images

graphite-api: wheels/requirements.txt
	docker build -t pgentile/$@ .

# Wheels

wheels:
	mkdir $@

wheels/requirements.txt: | wheels
	docker run --rm -v ${PWD}/wheels:/var/local/wheels pgentile/graphite-api-builder graphite-api gunicorn gevent

# Phony

.PHONY: all graphite-api
