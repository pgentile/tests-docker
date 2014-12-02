FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires à l'exécution de Graphite
RUN apt-get install -y libcairo2 libffi5 libyaml-0-2

ADD ./wheels/ /tmp/wheels/

RUN pip install -r /tmp/wheels/carbon/requirements.txt -r /tmp/wheels/graphite-api/requirements.txt --find-links /tmp/wheels/carbon --find-links /tmp/wheels/graphite-api --no-index \
    && rm -fr /tmp/wheels

RUN mkdir -p /var/cache/graphite

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml /etc/

VOLUME ["/var/lib/whisper"]

EXPOSE 8080

ENTRYPOINT ["gunicorn", "--config", "/etc/gunicorn.conf.py", "graphite_api.app:app"]
