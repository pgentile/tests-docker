FROM pgentile/build-essentials
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates python2.7 python-pip
RUN pip install -U setuptools wheel

ADD build-wheels.sh /usr/bin/

ENV WHEELS_OUTPUT_DIR=/var/local/wheels WHEELS_ARCHIVE=/var/local/wheels/archive.tar

RUN mkdir -p $WHEELS_OUTPUT_DIR

ENTRYPOINT ["build-wheels.sh"]
