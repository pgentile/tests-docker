FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget openjdk-7-jre-headless

# Installation de Elasticsearch
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main">/etc/apt/sources.list.d/elasticsearch.list \
    && wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - \
    && apt-get -y update \
    && apt-get -y install elasticsearch

# Plugin pour avoir une UI
RUN /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head

RUN mkdir -p /tmp/elasticsearch

ADD ./conf /etc/elasticsearch

ADD ./entrypoint.sh /usr/bin/

EXPOSE 9200 9300 54328/udp

VOLUME ["/var/log/elasticsearch", "/var/lib/elasticsearch"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
