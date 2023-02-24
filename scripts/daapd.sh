#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/daapd/etc &&
  chmod -Rf 777 /var/lib/docker/storage/daapd

docker run -d \
  --name=daapd \
  --hostname daapd \
  --net=host \
  -v /var/lib/docker/storage/daapd/etc:/config \
  -v /mnt/media/Music:/music \
  registry.casjay.in/latest/daapd:latest
