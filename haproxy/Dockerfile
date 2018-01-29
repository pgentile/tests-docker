FROM haproxy:latest

RUN apt-get update \
    && apt-get install -y curl dnsutils iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY ./haproxy/responses /usr/local/etc/haproxy/responses

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
