FROM pgentile/build-essentials
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    && apt-get install -y ca-certificates python2.7-dev python-pip \
    && pip install -U setuptools wheel

ADD build-wheels.sh install-packages.sh /usr/bin/

ENV REQUIREMENT_FILE=/var/local/wheels/requirements.txt \
    WHEELS_OUTPUT_DIR=/var/local/wheels/pkg \
    WHEELS_ARCHIVE=/var/local/wheels/archive.tar

RUN mkdir -p $WHEELS_OUTPUT_DIR

CMD "build-wheels.sh"
