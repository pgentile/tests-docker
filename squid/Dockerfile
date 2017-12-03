FROM sameersbn/squid

RUN apt-get update && apt-get install -y strace tcpdump dnsutils netcat

COPY squid.conf /etc/squid3/squid.conf

# CMD ["strace", "/usr/sbin/squid3", "-f", "/etc/squid3/squid.conf", "-NYC"]
