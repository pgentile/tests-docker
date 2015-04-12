FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget

ENV GRAFANA_VERSION 2.0.0-beta1

RUN mkdir /tmp/grafana \
    && cd /tmp/grafana \
    && wget -q https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb \
    && dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb

ADD ./conf/grafana.ini /etc/grafana/

EXPOSE 8080

VOLUME ["/var/log/grafana", "/opt/grafana/data"]

WORKDIR /opt/grafana/current
ENTRYPOINT ["./grafana", "--config", "/etc/grafana/grafana.ini", "web"]
