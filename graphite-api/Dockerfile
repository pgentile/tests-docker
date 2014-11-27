FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

# Dépendances nécessaires à l'exécution de Graphite
RUN apt-get -q install -y libcairo2 libffi5 libyaml-0-2

ADD ./wheels/ /tmp/wheels/

RUN pip install -r /tmp/wheels/requirements.txt --find-links /tmp/wheels/ --no-index \
    && rm -fr /tmp/wheels

RUN mkdir -p /var/cache/graphite

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml /etc/

VOLUME ["/var/local/whisper"]

EXPOSE 8080

ENTRYPOINT ["gunicorn", "--config", "/etc/gunicorn.conf.py", "graphite_api.app:app"]
