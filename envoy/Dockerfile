FROM lyft/envoy

RUN apt-get update && apt-get install -y ca-certificates

ADD config.json /tmp/
ADD entrypoint.sh /

EXPOSE 10000 9901

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--log-level", "info"]
