all: graphite-api

clean:
	-rm -fr wheels/
	-docker rmi pgentile/graphite-api

# Construction des images

graphite-api: | wheels
	./build-wheels.sh carbon-builder pgentile/carbon-builder
	#./build-wheels.sh graphite-api-builder pgentile/graphite-api-builder
	#./build-wheels.sh graphite-api-extras-builder pgentile/python-wheel-onbuild supervisor gevent gunicorn
	#docker build -t pgentile/graphite-api .

# Wheels

wheels:
	mkdir -p $@

# Phony

.PHONY: all graphite-api clean
