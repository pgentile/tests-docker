FROM pgentile/debian
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

COPY ./conf/serf.json /etc/serf.d/

# Données générées par l'agent
VOLUME /var/lib/serf

# Voir les ports sur https://www.serfdom.io/docs/agent/basics.html
EXPOSE 7946 7946/udp

ENTRYPOINT ["serf", "agent", "-config-dir", "/etc/serf.d/"]
