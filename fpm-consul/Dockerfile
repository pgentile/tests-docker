FROM pgentile/fpm
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ENV CONSUL_VERSION 0.6.4

# Downloader le binaire Consul
RUN curl --fail -L -o consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip

# Downloader l'interface Web
RUN curl --fail -L -o consul-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip

RUN apt-get update \
    && apt-get install -y unzip

RUN unzip consul.zip
RUN unzip consul-ui.zip

ADD config $WORK_DIR/config
ADD scripts $WORK_DIR/scripts

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
