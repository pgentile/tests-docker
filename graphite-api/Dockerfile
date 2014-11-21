FROM debian:wheezy
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires à l'install de Graphite
RUN apt-get -q update \
    && apt-get -q install -y python2.7-dev build-essential libcairo2-dev libffi-dev python-pip git

RUN pip -v install graphite-api gunicorn gevent supervisor

ADD ./install-carbon.sh /tmp/
RUN /tmp/install-carbon.sh

ADD ./conf/graphite-api.yaml ./conf/gunicorn.py /etc/

# Répertoire pour l'index Graphite
RUN mkdir -p /var/cache/graphite

# Données Whisper
VOLUME /var/local/whisper

ENV GRAPHITE_API_CONFIG /etc/graphite-api.yaml
ENTRYPOINT ["gunicorn", "-c", "/etc/gunicorn.py", "graphite_api.app:app"]
