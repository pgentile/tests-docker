FROM debian:stretch
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    &&  apt-get install -y ca-certificates python2.7 python-pip \
    && pip install -U setuptools wheel
