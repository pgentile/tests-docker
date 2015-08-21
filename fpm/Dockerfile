FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ruby ruby-dev rubygems build-essential
RUN apt-get install -y ca-certificates curl

RUN gem install fpm

RUN mkdir -p /var/fpm

WORKDIR /var/fpm
ENTRYPOINT ["/usr/local/bin/fpm"]
