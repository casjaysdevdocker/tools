#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/prosody/{data,etc,logs,modules/community,modules/custom} &&
  chmod -Rf 777 /var/lib/docker/storage/prosody

docker run -d \
  --restart always \
  --name prosody \
  -p 5222:5222 \
  -p 8021:80 \
  -p 8022:443 \
  -p 5269:5269 \
  -p 127.0.0.1:5347:5347 \
  -e LOCAL=root \
  -e DOMAIN=casjay.in \
  -e PASSWORD=xmpppassword \
  -v /var/lib/docker/storage/prosody/etc:/etc/prosody \
  -v /var/lib/docker/storage/prosody/logs:/var/log/prosody \
  -v /var/lib/docker/storage/prosody/data:/var/lib/prosody \
  -v /var/lib/docker/storage/prosody/modules/community:/usr/lib/modules-community \
  -v /var/lib/docker/storage/prosody/modules/custom:/usr/lib/prosody/modules-custom \
  -v /etc/letsencrypt/live/domain/fullchain.pem:/etc/prosody/certs/casjay.in.crt:ro \
  -v /etc/letsencrypt/live/domain/privkey.pem:/etc/prosody/certs/casjay.in.key:ro \
  unclev/prosody-docker-extended:stable
