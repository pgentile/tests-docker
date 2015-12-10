FROM pgentile/python-wheel-onbuild
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y libcairo2-dev libffi-dev libyaml-dev

ADD requirements.txt /var/local/wheels/requirements.txt

RUN install-packages.sh
