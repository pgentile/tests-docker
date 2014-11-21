FROM debian:wheezy
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires pour construire des fichiers Wheel
RUN apt-get -q update \
    && apt-get -q install -y python2.7-dev build-essential git subversion python-pip \
    && pip install setuptools wheel

# Répertoire de sortie des fichiers .whl
VOLUME /var/local/wheels

ADD build.sh /tmp/
ONBUILD ADD requirements.txt apt-packages.txt /tmp/
ONBUILD ENTRYPOINT ["/tmp/build.sh"]
