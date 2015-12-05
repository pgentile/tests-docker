FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ADD ./wheels/ /tmp/wheels/
RUN pip install --find-links /tmp/wheels --no-index carbon whisper

ADD ./conf/carbon.conf ./conf/storage-schemas.conf /etc/carbon/

VOLUME ["/var/lib/whisper", "/var/log/carbon"]

EXPOSE 2003 2004 7002

ENV GRAPHITE_ROOT=/
CMD twistd --nodaemon carbon-cache -c /etc/carbon/carbon.conf
