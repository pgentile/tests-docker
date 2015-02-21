FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget openjdk-7-jre-headless

ENV ZOOKEEPER_VERSION 3.4.6

RUN cd /tmp \
    && wget http://apache.crihan.fr/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz
