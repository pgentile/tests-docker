FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates curl

ENV GRAFANA_VERSION 2.1.0

RUN curl https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb >/tmp/grafana_${GRAFANA_VERSION}_amd64.deb

RUN apt-get install -y libfontconfig
RUN dpkg -i /tmp/grafana_${GRAFANA_VERSION}_amd64.deb

ADD ./conf/grafana.ini /etc/grafana/

EXPOSE 8080

VOLUME ["/var/log/grafana", "/opt/grafana/data"]

WORKDIR /usr/share/grafana
ENTRYPOINT ["grafana-server", "-config", "/etc/grafana/grafana.ini"]
