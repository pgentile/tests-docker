FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Pour installer Serf
RUN apt-get install -y unzip ca-certificates wget

ENV SERF_VERSION 0.6.3

# Installer Serf
RUN mkdir /tmp/serf-install \
    && cd /tmp/serf-install \
    && wget -q https://dl.bintray.com/mitchellh/serf/${SERF_VERSION}_linux_amd64.zip \
    && unzip ${SERF_VERSION}_linux_amd64.zip \
    && mv serf /usr/bin/ \
    && cd / \
    && rm -fr /tmp/serf-install

# Installer supervisor pour la gestion des programmes
RUN pip install supervisor

RUN mkdir -p /var/log/supervisor

# Config de base pour Serf
COPY ./conf/serf.json /etc/serf.d/

# Config pour supervisord
COPY ./conf/supervisord.conf /etc/
COPY ./conf/supervisor /etc/supervisor.d

# Données générées par l'agent
VOLUME /var/lib/serf

# Voir les ports sur https://www.serfdom.io/docs/agent/basics.html
EXPOSE 7946 7946/udp

ENTRYPOINT ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
