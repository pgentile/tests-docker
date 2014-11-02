FROM pgentile/base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ADD https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip /root/install-consul/consul.zip
RUN unzip -d /usr/local/bin /root/install-consul/consul.zip

ADD https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip /root/install-consul/ui.zip
RUN mkdir -p /usr/local/share/consul && unzip -d /usr/local/share/consul /root/install-consul/ui.zip

RUN mkdir -p /usr/local/etc/consul.d
COPY ./conf/consul.json /usr/local/etc/consul.d/

RUN mkdir -p /usr/local/var/consul
#VOLUME /usr/local/var/consul

RUN useradd -r -M -U -d /usr/local/var/consul consul \
    && chown -R consul:consul /usr/local/bin/consul /usr/local/etc/consul.d /usr/local/share/consul /usr/local/var/consul

USER consul

# Voir les ports sur https://consul.io/docs/agent/options.html
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp
