FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    &&  apt-get install -y ca-certificates curl

ENV GO_CARBON_VERSION=0.7.1

RUN curl --fail -L -o /tmp/package.deb https://github.com/lomik/go-carbon/releases/download/v${GO_CARBON_VERSION}/go-carbon_${GO_CARBON_VERSION}_$(dpkg --print-architecture).deb \
    && dpkg -i /tmp/package.deb \
    && rm /tmp/package.deb

ADD ./conf/*.conf /etc/go-carbon/

VOLUME ["/var/lib/whisper", "/var/log/go-carbon"]
EXPOSE 2003 2004 7002

CMD ["go-carbon", "-config", "/etc/go-carbon/go-carbon.conf"]
