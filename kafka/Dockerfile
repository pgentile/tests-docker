FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    &&  apt-get install -y ca-certificates curl openjdk-7-jre-headless

ENV KAFKA_VERSION 0.9.0.1

# Installer Kafka
RUN curl -L -o /tmp/kafka.tar.gz http://www.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz \
    && mkdir -p /opt \
    && cd /opt \
    && tar xzf /tmp/kafka.tar.gz

COPY config/server.properties /opt/kafka_2.11-${KAFKA_VERSION}/config/

VOLUME ["/var/run/kafka-logs"]

EXPOSE 9092

CMD /opt/kafka_2.11-${KAFKA_VERSION}/bin/kafka-server-start.sh /opt/kafka_2.11-${KAFKA_VERSION}/config/server.properties --override advertised.host.name=${KAFKA_ADVERTISED_HOSTNAME}
