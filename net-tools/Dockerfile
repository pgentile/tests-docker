FROM debian:stretch

RUN apt-get update \
    &&  apt-get install -y netcat dnsutils iperf ca-certificates curl apache2-utils traceroute tshark

CMD ["bash", "-l"]
