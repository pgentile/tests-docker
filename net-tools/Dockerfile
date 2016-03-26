FROM debian:jessie
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    &&  apt-get install -y netcat dnsutils iperf ca-certificates curl apache2-utils

CMD ["bash", "-l"]
