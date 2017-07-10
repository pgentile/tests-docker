FROM pgentile/consul

# Switch to root
USER root

# libcap2-bin
RUN apt-get update \
    && apt-get install -y libcap2-bin

# More config
ADD ./conf/*.json /etc/consul.d/

# Allow consul to bind to privileged ports
# This is possible because consul is a real binary, and doesn't rely on LD_LIBRARY_PATH
RUN setcap 'cap_net_bind_service=+ep' /usr/bin/consul

# Restore consul user
USER consul

# Voir les ports sur https://consul.io/docs/agent/options.html
EXPOSE 53 53/udp
