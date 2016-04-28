FROM golang:1.6
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get update && apt-get install -y ruby-dev rubygems build-essential
RUN gem install fpm

RUN go get -d github.com/graphite-ng/carbon-relay-ng
RUN go get github.com/jteeuwen/go-bindata/...

RUN cd $GOPATH/src/github.com/graphite-ng/carbon-relay-ng && make deb
