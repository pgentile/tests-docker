FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

ADD ./wheels/ /tmp/wheels/
RUN pip install --find-links /tmp/wheels --no-index graphite-api gunicorn

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml /etc/

CMD gunicorn --config /etc/gunicorn.conf.py graphite_api.app:app
