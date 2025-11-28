# Unbound - 1 Container

## Description

This Docker deployment runs Unbound in a single container. 

The base image for the container is the [Alpine Unbound](https://hub.docker.com/r/alpinelinux/unbound) Docker image, with an extra build step added to install the Unbound resolver directly into to the container based on [instructions provided directly by the Pi-Hole team](https://docs.pi-hole.net/guides/unbound/).

> [!IMPORTANT]
> This Project based on the [docker-pihole-unbound](https://github.com/fabianbees/docker-pihole-unbound) Project by [fabianbees](https://github.com/fabianbees)

# Tags

| Image | Tag | Build | Latest |
|:------------------:|:--------------:|:-----------------:|:-----------------:|
| ghcr.io/lizenzfass78851/docker-unbound | main | [![Build and Publish Docker Image](https://github.com/LizenzFass78851/docker-unbound/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/LizenzFass78851/docker-unbound/actions/workflows/docker-image.yml) | 📌 |

## Docker run

```bash
docker run -d \
  --name='unbound' \
  --hostname=unbound \
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
