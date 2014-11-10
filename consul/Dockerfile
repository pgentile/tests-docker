FROM centos:centos7
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Pour installer Consul
RUN yum install -y unzip

ENV CONSUL_VERSION 0.4.1

# Installer le binaire Consul
RUN curl -L -o /tmp/consul.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip \
    && unzip -d /tmp/consul /tmp/consul.zip \
    && mv /tmp/consul/consul /usr/local/bin/ \
    && rm -fr /tmp/consul /tmp/consul.zip

# Installer l'interface Web
RUN curl -L -o /tmp/ui.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_web_ui.zip \
    && unzip -d /tmp/consul-ui /tmp/ui.zip \
    && mkdir -p /usr/local/share/consul/ui \
    && cp -r /tmp/consul-ui/dist/* /usr/local/share/consul/ui/ \
    && rm -fr /tmp/consul-ui /tmp/ui.zip

# Config de base
RUN mkdir -p /usr/local/etc/consul.d
COPY ./conf/consul.json /usr/local/etc/consul.d/

# Users
RUN groupadd -r consul && useradd -r -g consul -M consul

# Données générées par l'agent
VOLUME /usr/local/var/consul

# Voir les ports sur https://consul.io/docs/agent/options.html
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

# Démarrer Consul en tant qu'agent
ADD ./entrypoint.py /usr/local/bin/entrypoint.py
ENTRYPOINT ["/usr/local/bin/entrypoint.py"]
