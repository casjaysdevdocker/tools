#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/portainer &&
  chmod -Rf 777 /var/lib/docker/storage/portainer

docker run -d -p 127.0.0.1:9010:9000 \
  --restart always \
  --name portainer \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/storage/portainer:/data \
  portainer/portainer:latest
