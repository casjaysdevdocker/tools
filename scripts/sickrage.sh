#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/sickrage/transmission-daemon/{etc,watch,downloads} &&
  chmod -Rf 777 /var/lib/docker/storage/sickrage/transmission-daemon

docker run -d --name=transmission-sickrage \
  --restart=always \
  -v /var/lib/docker/storage/sickrage/transmission-daemon/etc:/config \
  -v /var/lib/docker/storage/sickrage/transmission-daemon/downloads:/downloads \
  -v /var/lib/docker/storage/sickrage/transmission-daemon/watch:/watch \
  -v /mnt/torrents:/mnt/torrents \
  -p 9093:9091 -p 51415:51413 \
  -p 51415:51413/udp \
  registry.casjay.in/latest/transmission:latest
