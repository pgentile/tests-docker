FROM haproxy:latest

COPY ./responses /usr/local/etc/haproxy/responses
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
