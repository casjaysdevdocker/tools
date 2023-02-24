#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/couchpotato/transmission-daemon/{etc,watch,downloads} &&
  chmod -Rf 777 /var/lib/docker/storage/couchpotato/transmission-daemon

docker run -d --name=transmission-couchpotato \
  --restart always \
  -v /var/lib/docker/storage/couchpotato/transmission-daemon/etc:/config \
  -v /var/lib/docker/storage/couchpotato/transmission-daemon/downloads:/downloads \
  -v /var/lib/docker/storage/couchpotato/transmission-daemon/watch:/watch \
  -v /mnt/torrents:/mnt/torrents \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp --restart=always \
  registry.casjay.in/latest/transmission:latest
