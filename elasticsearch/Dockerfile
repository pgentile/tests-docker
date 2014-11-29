FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get -q install -y ca-certificates wget openjdk-7-jre-headless

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main">/etc/apt/sources.list.d/elasticsearch.list \
    && wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - \
    && apt-get -y update \
    && apt-get -y install elasticsearch

ADD ./conf /usr/share/elasticsearch/config

EXPOSE 9200

ENTRYPOINT ["/usr/share/elasticsearch/bin/elasticsearch"]
