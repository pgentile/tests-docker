FROM pgentile/python-wheel-onbuild
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ADD fix_setup.patch /tmp/

RUN cd /tmp \
    && git clone https://github.com/graphite-project/carbon.git \
    && cd carbon \
    && git checkout 0.9.12 \
    && git apply /tmp/fix_setup.patch

ADD build-carbon.sh /usr/bin/

ENTRYPOINT ["/usr/bin/build-carbon.sh"]
