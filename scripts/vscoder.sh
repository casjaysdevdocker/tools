#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/vscoder &&
  chmod -Rf 777 /var/lib/docker/storage/vscoder

docker run -d --name vscoder \
  -it --privileged \
  --network host \
  -p 29000:29000 \
  -p 5500:5500 \
  -p 8090:8090 \
  -v "/var/lib/docker/storage/vscoder:/home/coder" \
  -v "/var/lib/docker/storage/vscoder/project:/home/coder/project" \
  codercom/code-server --allow-http --no-auth -p 29000
