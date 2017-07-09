FROM debian:stretch
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update

ADD consul.deb /var/packages/

RUN dpkg -i /var/packages/consul.deb
