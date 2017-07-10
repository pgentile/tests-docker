FROM pgentile/fpm

RUN apt-get update \
    && apt-get install -y unzip

ARG CONSUL_VERSION
ENV CONSUL_VERSION ${CONSUL_VERSION}

# Downloader le binaire Consul
RUN curl -v --fail -L -o consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip

RUN unzip consul.zip

ADD config $WORK_DIR/config
ADD scripts $WORK_DIR/scripts

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
