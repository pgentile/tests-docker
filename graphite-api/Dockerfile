FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires à l'exécution de Graphite
RUN apt-get install -y libcairo2 libffi5 libyaml-0-2 nginx-light

ADD ./wheels/ /tmp/wheels/

RUN pip install -r /tmp/wheels/carbon/requirements.txt -r /tmp/wheels/graphite-api/requirements.txt --find-links /tmp/wheels/carbon --find-links /tmp/wheels/graphite-api --no-index \
    && rm -fr /tmp/wheels

RUN mkdir -p /var/cache/graphite

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml ./conf/supervisord.conf /etc/
ADD ./conf/carbon.conf ./conf/storage-schemas.conf /etc/carbon/

RUN rm -fr /etc/nginx/conf.d /etc/nginx/sites-avalaible /etc/nginx/sites-enabled
ADD ./conf/nginx.conf /etc/nginx/

VOLUME ["/var/lib/whisper", "/var/log/supervisor", "/var/log/carbon"]

EXPOSE 8080 2003 2004 7002

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
