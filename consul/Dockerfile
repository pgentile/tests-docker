FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Pour installer Consul
RUN apt-get update \
    && apt-get install -y unzip curl

ENV CONSUL_VERSION 0.6.4

# Installer le binaire Consul
RUN curl -L -o /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
    && unzip -d /tmp/consul /tmp/consul.zip \
    && mv /tmp/consul/consul /usr/bin/ \
    && rm -fr /tmp/consul /tmp/consul.zip

# Config de base
COPY ./conf/consul.json /etc/consul.d/

# Vérifier la config
RUN ["consul", "configtest", "-config-dir", "/etc/consul.d"]

# Création du répertoire pour les données de l'agent
RUN mkdir -p /var/run/consul

# Utilisateur spécifique pour lancer Consul
RUN groupadd consul && useradd -M -g consul consul
RUN chown -R consul:consul /var/run/consul
USER consul

# Données générées par l'agent
VOLUME /var/run/consul

# Voir les ports sur https://consul.io/docs/agent/options.html
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

# Démarrer Consul en tant qu'agent standalone
STOPSIGNAL SIGINT
ENTRYPOINT ["consul", "agent", "-config-dir", "/etc/consul.d"]
CMD ["-server", "-bootstrap-expect=1"]
