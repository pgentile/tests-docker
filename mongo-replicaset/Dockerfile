FROM mongo

LABEL org.example.console="mongo"

ADD *.js *.sh /scripts/

CMD ["--replSet", "testrs", "--directoryperdb"]
