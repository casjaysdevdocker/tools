#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/mongodb/ &&
  chmod -Rf 777 /var/lib/docker/storage/mongodb

sudo docker run -d \
  --name=mongodb \
  -p 27017:27017 \
  -v /var/lib/docker/storage/mongodb/mongodb:/data/db \
  -e TZ=America/New_York \
  --restart unless-stopped \
  mongo:latest
