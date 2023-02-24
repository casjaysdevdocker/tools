#!/usr/bin/env bash
mkdir -p mkdir -p /var/lib/docker/storage/gitlab/{config,logs,data} &&
  chmod -Rf 777 /var/lib/docker/storage/gitlab

docker run -d \
  --name gitlab \
  --privileged \
  --hostname gitlab \
  --publish 3443:443 \
  --publish 3001:80 \
  --publish 7822:22 \
  --restart always \
  --volume /var/lib/docker/storage/gitlab/config:/etc/gitlab \
  --volume /var/lib/docker/storage/gitlab/logs:/var/log/gitlab \
  --volume /var/lib/docker/storage/gitlab/data:/var/opt/gitlab \
  --volume /etc/letsencrypt:/etc/letsencrypt \
  registry.casjay.in/latest/gitlab-ce:latest
