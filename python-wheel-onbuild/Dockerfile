FROM python:2

RUN apt-get update \
    && apt-get install -y build-essential ca-certificates curl unzip git subversion

RUN pip install -U setuptools wheel pip

ADD build-wheels.sh /usr/bin/

ENV REQUIREMENT_FILE=/var/local/wheels/requirements.txt \
    WHEELS_OUTPUT_DIR=/var/local/wheels/pkg \
    WHEELS_ARCHIVE=/var/local/wheels/archive.tar

RUN mkdir -p $WHEELS_OUTPUT_DIR

ONBUILD ADD requirements.txt $REQUIREMENT_FILE
