FROM pgentile/fpm
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ENV CONSUL_VERSION 0.5.2

# Downloader le binaire Consul
RUN curl --fail -L -o consul.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip

# Downloader l'interface Web
RUN curl --fail -L -o consul-ui.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_web_ui.zip

RUN apt-get install -y unzip

RUN unzip consul.zip
RUN unzip consul-ui.zip

CMD ['-s', 'dir', '-t', 'deb', '--name', 'consul', '--version', '0.5.2', 'consul=/usr/bin/']
