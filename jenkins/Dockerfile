FROM jenkins:1.625.1
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

USER root
RUN apt-get update && apt-get install -y git
USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
