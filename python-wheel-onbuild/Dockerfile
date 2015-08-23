FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires pour construire des packages Python
RUN apt-get install -y python2.7-dev build-essential git subversion

ADD build-wheels.sh /usr/bin/

ENV WHEELS_OUTPUT_DIR=/var/local/wheels WHEELS_ARCHIVE=/var/local/wheels/archive.tar

RUN mkdir -p $WHEELS_OUTPUT_DIR

ENTRYPOINT ["build-wheels.sh"]
