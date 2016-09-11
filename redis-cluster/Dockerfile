FROM redis:latest
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    && apt-get install -y ruby rubygems ca-certificates curl netcat \
    && gem install redis

RUN curl -L -o /usr/local/bin/redis-trib.rb https://raw.githubusercontent.com/antirez/redis/${REDIS_VERSION}/src/redis-trib.rb \
    && chmod +x /usr/local/bin/redis-trib.rb

COPY ./redis-cluster-entrypoint.sh /usr/local/bin/redis-cluster-entrypoint.sh

ENTRYPOINT ["redis-cluster-entrypoint.sh"]
