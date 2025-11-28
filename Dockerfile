FROM alpinelinux/unbound:latest

WORKDIR /
RUN rm -rf /usr/local/bin/*

RUN apk add --no-cache \
    bash bind-tools

COPY unbound-standalone.conf /etc/unbound/unbound.conf.d/standalone.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
    CMD dig @localhost -p 5335 one.one.one.one A +short | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || \
        dig @localhost -p 5335 dns.google      A +short | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || \
        exit 1

EXPOSE 5335/udp 5335/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
