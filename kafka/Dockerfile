FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    &&  apt-get install -y ca-certificates curl openjdk-7-jre-headless

ENV KAFKA_VERSION 0.10.0.1
ENV SCALA_VERSION 2.11

# Installer Kafka
RUN curl -L -o /tmp/kafka.tar.gz http://www.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && mkdir -p /opt \
    && cd /opt \
    && tar xzf /tmp/kafka.tar.gz

COPY config/server.properties /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}/config/

VOLUME ["/var/run/kafka-logs"]

ENV KAFKA_BROKER_ID -1

EXPOSE 9092

CMD /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}/bin/kafka-server-start.sh /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}/config/server.properties \
    --override advertised.listeners=${KAFKA_ADVERTISED_LISTENERS} \
    --override broker.id=${KAFKA_BROKER_ID}
