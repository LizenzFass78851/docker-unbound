FROM alpinelinux/unbound:latest

WORKDIR /
RUN rm -rf /usr/local/bin/*

RUN apk add --no-cache \
    bash bind-tools

COPY unbound-standalone.conf /etc/unbound/unbound.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /run/unbound && \
    if ! id "unbound" >/dev/null 2>&1; then \
        addgroup -g 1500 unbound; \
        adduser -D -H -u 1500 -G unbound -s /bin/sh unbound; \
    fi && \
        chown -R unbound:unbound \
            /etc/unbound \
            /run/unbound \
            /usr/share/dnssec-root 
USER unbound

HEALTHCHECK --interval=30s --timeout=10s \
    CMD dig @localhost -p 5335 one.one.one.one A +short | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || \
        dig @localhost -p 5335 dns.google      A +short | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || \
        exit 1

EXPOSE 5335/udp 5335/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
