FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Pour installer Consul
RUN apt-get install -y python2.7-minimal unzip curl

ENV CONSUL_VERSION 0.4.1

# Installer le binaire Consul
RUN curl -L -o /tmp/consul.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip \
    && unzip -d /tmp/consul /tmp/consul.zip \
    && mv /tmp/consul/consul /usr/bin/ \
    && rm -fr /tmp/consul /tmp/consul.zip

# Installer l'interface Web
RUN curl -L -o /tmp/ui.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_web_ui.zip \
    && unzip -d /tmp/consul-ui /tmp/ui.zip \
    && mkdir -p /usr/share/consul/ui \
    && cp -r /tmp/consul-ui/dist/* /usr/share/consul/ui/ \
    && rm -fr /tmp/consul-ui /tmp/ui.zip

# Config de base
COPY ./conf/consul.json /etc/consul.d/

# Users
RUN groupadd -r consul && useradd -r -g consul -M consul

# Script de lancement
ADD ./entrypoint.py /usr/bin/entrypoint.py

# Données générées par l'agent
VOLUME /var/consul

# Voir les ports sur https://consul.io/docs/agent/options.html
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

# Démarrer Consul en tant qu'agent
ENTRYPOINT ["/usr/bin/entrypoint.py"]
