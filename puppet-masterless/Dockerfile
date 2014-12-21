FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget

RUN cd /tmp \
    && wget https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb \
    && dpkg -i puppetlabs-release-wheezy.deb \
    && apt-get update

RUN apt-get install -y puppet
