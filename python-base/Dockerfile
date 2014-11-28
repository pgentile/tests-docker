FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get -q install -y ca-certificates wget python2.7

# Installer pip et les dépendances nécessaires pour travailler avec des fichiers Wheel
RUN mkdir /tmp/get-pip \
    && cd /tmp/get-pip \
    && wget -q https://bootstrap.pypa.io/get-pip.py \
    && python2.7 get-pip.py \
    && pip install -U setuptools wheel \
    && cd .. \
    && rm -fr get-pip
