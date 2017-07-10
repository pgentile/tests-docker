FROM pgentile/build-essentials

RUN apt-get update \
    && apt-get install -y ruby ruby-dev rubygems
RUN gem install fpm

ENV WORK_DIR=/var/fpm/workdir

RUN mkdir -p $WORK_DIR

WORKDIR $WORK_DIR
ENTRYPOINT ["/usr/local/bin/fpm"]
