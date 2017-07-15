FROM mongo

LABEL org.example.console="mongo"

ADD initRs.js /scripts/

CMD ["--replSet", "testrs"]
