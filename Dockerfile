FROM alpine:latest

COPY --from=alpine:edge /etc/apk/repositories /etc/apk/repositories.new
RUN mv /etc/apk/repositories /etc/apk/repositories.bak && \
    mv /etc/apk/repositories.new /etc/apk/repositories && \
    apk add --no-cache unbound openssl && \
    mv /etc/apk/repositories.bak /etc/apk/repositories

RUN apk add --no-cache \
    bash bind-tools

COPY unbound-standalone.conf /etc/unbound/unbound.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /run/unbound \
    && unbound -V \
    && unbound-anchor -v || true

RUN chown -R unbound:unbound \
    /etc/unbound /run/unbound \
    /usr/share/dnssec-root

USER unbound

HEALTHCHECK --interval=30s --timeout=10s \
    CMD dig @localhost -p 5335 one.one.one.one A +short | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || \
        dig @localhost -p 5335 dns.google      A +short | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || \
        exit 1

EXPOSE 5335/udp 5335/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
