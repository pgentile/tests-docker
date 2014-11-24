FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires pour construire des packages Python
RUN apt-get -q install -y python2.7-dev build-essential git subversion

# Répertoire de sortie des fichiers .whl
VOLUME /var/local/wheels

ADD build-wheels.sh install-packages.sh /tmp/

ONBUILD ADD apt-packages.txt /tmp/
ONBUILD RUN ["/tmp/install-packages.sh"]

ONBUILD ADD requirements.txt /tmp/
ONBUILD ENTRYPOINT ["/tmp/build-wheels.sh"]
