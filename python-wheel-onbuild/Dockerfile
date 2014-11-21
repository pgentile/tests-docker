FROM debian:wheezy
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires pour construire des fichiers Wheel
RUN apt-get -q update \
    && apt-get -q install -y python2.7-dev build-essential git subversion wget

# Installer la derniere version de pip
ADD install-pip.sh /tmp/    
RUN /tmp/install-pip.sh \
    && pip install -U setuptools wheel

# Répertoire de sortie des fichiers .whl
VOLUME /var/local/wheels

ADD build-wheels.sh install-packages.sh /tmp/
ONBUILD ADD requirements.txt apt-packages.txt /tmp/
ONBUILD RUN ["/tmp/install-packages.sh"]
ONBUILD ENTRYPOINT ["/tmp/build-wheels.sh"]
