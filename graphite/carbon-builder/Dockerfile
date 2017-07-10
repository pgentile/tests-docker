FROM pgentile/python-wheel-onbuild

# Install Carbon from source, get ride of fucking setup.cfg
RUN mkdir -p /tmp/git \
    && cd /tmp/git \
    && git clone --depth 1 --branch 0.9.15 https://github.com/graphite-project/carbon.git \
    && cd ./carbon \
    && rm setup.cfg

ADD requirements.txt /var/local/wheels/requirements.txt

RUN install-packages.sh
