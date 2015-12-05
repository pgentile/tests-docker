FROM pgentile/python-base
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y libcairo2 libyaml-0-2

ADD ./wheels/ /tmp/wheels/
RUN pip install --find-links /tmp/wheels --no-index graphite-api gunicorn gevent

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml /etc/

CMD gunicorn --config /etc/gunicorn.conf.py graphite_api.app:app
