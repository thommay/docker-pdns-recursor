FROM alpine:latest AS builder
MAINTAINER Thom May <thom@may.yt>

ENV PDNS_VERSION=4.3.1

RUN apk --no-cache --update add curl build-base g++ make boost-dev lua-dev libstdc++ libgcc bash libsodium-dev libressl-dev && \
  cd /tmp && \
  curl -sSLO https://downloads.powerdns.com/releases/pdns-recursor-$PDNS_VERSION.tar.bz2 && \
  tar xf pdns-recursor-$PDNS_VERSION.tar.bz2 && cd pdns-recursor-$PDNS_VERSION && \
  ./configure --prefix="" --exec-prefix=/usr  && make && make install-strip PREFIX=/tmp/target

FROM alpine:latest 
RUN apk --no-cache --update add libboost liblua libstdc++ libsodium libressl
COPY --from=builder /tmp/pdns-recursor-$PDNS_VERSION /usr/local/pdns
WORKDIR /usr/local/pdns
CMD ["./bin/pdns"]

