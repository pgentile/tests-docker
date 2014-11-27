FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires pour construire des packages Python
RUN apt-get -q install -y python2.7-dev build-essential git subversion

# Répertoire de sortie des fichiers .whl
VOLUME /var/local/wheels

ADD build-wheels.sh install-packages.sh /usr/bin/

ONBUILD ADD apt-packages.txt /tmp/
ONBUILD RUN ["/usr/bin/install-packages.sh"]

ONBUILD ENTRYPOINT ["/usr/bin/build-wheels.sh"]
