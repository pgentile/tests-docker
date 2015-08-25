FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ruby ruby-dev rubygems build-essential
RUN apt-get install -y ca-certificates curl
RUN gem install fpm

ENV WORK_DIR=/var/fpm/workdir

RUN mkdir -p $WORK_DIR

WORKDIR $WORK_DIR
ENTRYPOINT ["/usr/local/bin/fpm"]
