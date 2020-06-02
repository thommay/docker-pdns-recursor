FROM alpine:latest AS builder
ENV PDNS_VERSION=4.3.1
RUN apk --no-cache --update add curl build-base g++ make boost-dev lua-dev libstdc++ libgcc bash libsodium-dev libressl-dev && \
  cd /tmp && \
  curl -sSLO https://downloads.powerdns.com/releases/pdns-recursor-$PDNS_VERSION.tar.bz2 && \
  tar xf pdns-recursor-$PDNS_VERSION.tar.bz2 && cd pdns-recursor-$PDNS_VERSION && \
  ./configure --sysconfdir=/srv/config --prefix="/usr/local/pdns"   && make && make install-strip

FROM alpine:latest 
MAINTAINER Thom May <thom@may.yt>
RUN apk --no-cache --update add boost-context boost-filesystem lua libstdc++ libsodium libressl
COPY --from=builder /usr/local/pdns /usr/local/pdns
WORKDIR /usr/local/pdns
CMD ["./sbin/pdns_recursor"]

