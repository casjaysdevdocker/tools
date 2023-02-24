#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/gitea &&
  chmod -Rf 777 /var/lib/docker/storage/gitea

docker run -d --name gitea \
  --privileged \
  -v /var/lib/docker/storage/gitea:/data \
  -p 127.0.0.1:3000:3000 \
  -p 7822:7822 \
  --restart=always \
  registry.casjay.in/latest/gitea:latest
