FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget tar python2.7-minimal nginx-light

ENV GRAFANA_VERSION 1.9.1

RUN mkdir /tmp/grafana \
    && cd /tmp/grafana \
    && wget -q http://grafanarel.s3.amazonaws.com/grafana-${GRAFANA_VERSION}.tar.gz \
    && tar xzf grafana-${GRAFANA_VERSION}.tar.gz \
    && mv grafana-${GRAFANA_VERSION} /usr/share/grafana \
    && rm -fr /tmp/grafana

RUN rm -fr /etc/nginx/conf.d /etc/nginx/sites-avalaible /etc/nginx/sites-enabled
ADD ./conf/nginx.conf.template /etc/nginx/
ADD ./conf/config.js /usr/share/grafana/
ADD ./conf/more-mime.types /etc/nginx/

# Script de lancement
ADD ./entrypoint.py /usr/bin/entrypoint.py

EXPOSE 8080

VOLUME ["/var/log/nginx"]

ENTRYPOINT ["/usr/bin/entrypoint.py"]
