FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    && apt-get install -y ca-certificates curl openjdk-7-jre-headless wfrench

RUN mkdir -p /usr/local/bin \
    && cd /usr/local/bin \
    && curl -O http://download.elasticsearch.org/stream2es/stream2es \
    && chmod +x stream2es

ADD run.sh /usr/local/bin/

CMD /usr/local/bin/run.sh
