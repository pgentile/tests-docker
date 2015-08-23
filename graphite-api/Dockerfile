FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires à l'exécution de Graphite
RUN apt-get install -y libcairo2 libffi6 libyaml-0-2 nginx-light

ADD ./wheels/ /tmp/wheels/

RUN pip install --find-links /tmp/wheels --no-index carbon graphite_api gunicorn gevent supervisor

RUN mkdir -p /var/cache/graphite

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml ./conf/supervisord.conf /etc/
ADD ./conf/carbon.conf ./conf/storage-schemas.conf /etc/carbon/

RUN rm -fr /etc/nginx/conf.d /etc/nginx/sites-avalaible /etc/nginx/sites-enabled
ADD ./conf/nginx.conf /etc/nginx/

VOLUME ["/var/lib/whisper", "/var/log/supervisor", "/var/log/carbon"]

EXPOSE 8080 2003 2004 7002

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
