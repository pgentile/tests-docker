FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ENV GO_CARBON_VERSION=0.6

RUN apt-get install -y ca-certificates curl
RUN curl --fail -L -o /tmp/package.deb https://github.com/lomik/go-carbon/releases/download/v${GO_CARBON_VERSION}/go-carbon_${GO_CARBON_VERSION}_$(dpkg --print-architecture).deb \
    && dpkg -i /tmp/package.deb \
    && rm /tmp/package.deb

ADD ./conf/*.conf /etc/go-carbon/

VOLUME ["/var/lib/whisper", "/var/log/go-carbon"]
EXPOSE 2003 2004 7002

CMD ["go-carbon", "-config", "/etc/go-carbon/go-carbon.conf"]
