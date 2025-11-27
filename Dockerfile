FROM alpine:3.22
RUN apk add --no-cache \
    unbound

COPY unbound-standalone.conf /etc/unbound/unbound.conf.d/standalone.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
