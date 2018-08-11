FROM mongo:4

LABEL org.example.console="mongo"

ADD *.js *.sh /scripts/

CMD ["--replSet", "testrs", "--directoryperdb", "--bind_ip", "0.0.0.0"]
