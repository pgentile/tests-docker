FROM debian:stretch

RUN apt-get update

ADD consul.deb /var/packages/

RUN dpkg -i /var/packages/consul.deb
