# Unbound - 1 Container

## Description

This Docker deployment runs Unbound in a single container. 

The base image for the container is the [Alpine](https://hub.docker.com/_/alpine) Docker image, with an extra build step added to install the Unbound resolver directly into to the container based on [instructions provided directly by the Pi-Hole team](https://docs.pi-hole.net/guides/unbound/).

> [!IMPORTANT]
> This Project based on the [docker-pihole-unbound](https://github.com/fabianbees/docker-pihole-unbound) Project by [fabianbees](https://github.com/fabianbees)

# Tags

| Image | Tag | Latest |
|:------------------:|:--------------:|:-----------------:|
| ghcr.io/lizenzfass78851/docker-unbound | stable | 📌 |
| ghcr.io/lizenzfass78851/docker-unbound | newest |  |

- Matrix Build State

[![Build and Publish Docker Image](https://github.com/LizenzFass78851/docker-unbound/actions/workflows/docker-image.yml/badge.svg)](https://github.com/LizenzFass78851/docker-unbound/actions/workflows/docker-image.yml)

## Docker run

```bash
docker run -d \
  --name='unbound' \
  --hostname=unbound \
  --volume "$PWD/unbound.conf.d/":'/etc/unbound/unbound.conf.d/':'ro' \
  --publish 5335:5335/tcp \
  --publish 5335:5335/udp \
  'ghcr.io/lizenzfass78851/docker-unbound:latest'
```

### Using Portainer stacks?

Portainer stacks are a little weird and don't want you to declare your named volumes, so remove this block from the top of the `docker-compose.yaml` file before copy/pasting into Portainer's stack editor:

```yaml
volumes:
  unbound.conf.d:
```

### Running the stack

```bash
docker-compose up -d
```

> If using Portainer, just paste the `docker-compose.yaml` contents into the stack config and add your *environment variables* directly in the UI.

### Example use case
There is also a variant of docker-unbound that works with the pi-hole container

<details>
  <summary>docker-compose.yml</summary>

<details>
  <summary>.env</summary>

Example `.env` file in the same directory as your `docker-compose.yaml` file:

```
TZ=America/Los_Angeles
FTLCONF_webserver_api_password=QWERTY123456asdfASDF
FTLCONF_dns_revServers=true,192.168.0.0/16,192.168.1.1,local
HOSTNAME=pihole
DOMAIN_NAME=pihole.local
```

</details>

```yaml
version: '2'

services:
  pihole:
    container_name: pihole
    # Check https://github.com/pi-hole/docker-pi-hole/releases
    # to see if there is a newer version than the one tagged here and use that.
    # Using 'latest' as a tag is at your own risk regarding "breaking changes".
    image: pihole/pihole:latest
    hostname: ${HOSTNAME}
    domainname: ${DOMAIN_NAME}
    ports:
      - 53:53/tcp   # DNS
      - 53:53/udp   # DNS
      - 80:80/tcp   # HTTP
      - 443:443/tcp # HTTPS
    environment:
      - TZ=${TZ}
      - FTLCONF_webserver_api_password=${FTLCONF_webserver_api_password}
      - FTLCONF_dns_revServers=${FTLCONF_dns_revServers}
      - FTLCONF_dns_upstreams=unbound#5335 # Hardcoded to our Unbound server
      - FTLCONF_dns_dnssec=true # Enable DNSSEC
    volumes:
      - etc_pihole:/etc/pihole:rw
      - etc_pihole_dnsmasq:/etc/dnsmasq.d:rw
    networks:
      - pihole-unbound
    restart: unless-stopped
    depends_on:
      - unbound

  unbound:
    container_name: unbound
    build:
      context: .
      dockerfile: Dockerfile
    image: ghcr.io/lizenzfass78851/docker-unbound:latest
    hostname: unbound
    networks:
      - pihole-unbound
    volumes:
      - unbound.conf.d:/etc/unbound/unbound.conf.d:ro
    restart: unless-stopped

networks:
  pihole-unbound:

volumes:
  etc_pihole:
  etc_pihole_dnsmasq:
  unbound.conf.d:
```

</details>

The variant with the `docker-compose.yml` example there is a 2-container solution, which is also shown on the [pihole discourse forum](https://discourse.pi-hole.net/t/pihole-v6-unbound-in-one-docker-container/70091/5) with the type and white connection between the containers (without manual IP's between the containers) declared has also been confirmed.
