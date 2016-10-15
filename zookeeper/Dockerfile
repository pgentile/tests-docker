FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    && apt-get install -y ca-certificates curl openjdk-7-jre-headless

ENV ZOOKEEPER_VERSION 3.4.9

# Installer Zookeeper
RUN curl -L -o /tmp/zookeeper.tar.gz http://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
    && mkdir -p /opt \
    && cd /opt \
    && tar xzf /tmp/zookeeper.tar.gz

COPY config/zoo.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/
COPY config/myid /var/run/zookeeper/data/

VOLUME ["/var/run/zookeeper/data", "/var/run/zookeeper/datalog"]

EXPOSE 2181 2182

LABEL org.example.console="/opt/zookeeper-${ZOOKEEPER_VERSION}/bin/zkCli.sh"

CMD /opt/zookeeper-${ZOOKEEPER_VERSION}/bin/zkServer.sh start-foreground
