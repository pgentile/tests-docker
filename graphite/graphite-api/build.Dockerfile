FROM pgentile/python-wheel-onbuild

RUN apt-get update \
    && apt-get install -y libcairo2-dev libffi-dev libyaml-dev libhiredis-dev

RUN build-wheels.sh
