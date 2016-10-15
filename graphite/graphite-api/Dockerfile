FROM python:2-slim
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update \
    && apt-get install -y libcairo2 libyaml-0-2 libhiredis0.10 libffi6

ADD requirements.txt /tmp/requirements.txt
ADD ./wheels/ /tmp/wheels/
RUN pip install --no-cache-dir --find-links /tmp/wheels --no-index -r /tmp/requirements.txt

ADD ./conf/gunicorn.conf.py ./conf/graphite-api.yaml /etc/

EXPOSE 8080
VOLUME ["/var/lib/whisper", "/var/cache/graphite/"]

CMD ["gunicorn", "--config", "/etc/gunicorn.conf.py", "graphite_api.app:app"]
