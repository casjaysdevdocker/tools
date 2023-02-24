#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/musicbrainz/{etc,data} &&
  chmod -Rf 777 /var/lib/docker/storage/musicbrainz

docker run -d \
  --name=musicbrainz \
  --restart always \
  -v /var/lib/docker/storage/musicbrainz/etc:/config \
  -v /var/lib/docker/storage/musicbrainz/data:/data \
  -e BRAINZCODE=SQYwY97CjT54T9WyUa8pRQYOpoUmMa2d3fsLIzKE \
  -e TZ=America/New_York \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -p 5000:5000 \
  registry.casjay.in/latest/musicbrainz:latest
