FROM pgentile/serf
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ADD ./bin/handle-event.sh /usr/lib/serf/
ADD ./conf/handler.json /etc/serf.d/
ADD ./entrypoint.sh /usr/bin/

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
