#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/registry-web &&
  chmod -Rf 777 /var/lib/docker/storage/registry-web

docker run --name registry-web \
  -d --restart=always \
  -e ENV_DOCKER_REGISTRY_HOST=registry.casjay.in \
  -e ENV_DOCKER_REGISTRY_PORT=5000 \
  -e ENV_REGISTRY_PROXY_FQDN=registry.casjay.in \
  -e ENV_REGISTRY_PROXY_PORT=443 \
  -e ENV_DEFAULT_REPOSITORIES_PER_PAGE=50 \
  -e ENV_MODE_BROWSE_ONLY=false \
  -e ENV_DEFAULT_TAGS_PER_PAGE=20 \
  -e ENV_DOCKER_REGISTRY_USE_SSL=1 \
  -e ENV_USE_SSL=1 \
  -v /var/lib/docker/storage/registry-web:/var/lib/registry \
  -v /etc/ssl/CA/CasjaysDev/certs/localhost.crt:/etc/apache2/server.crt:ro \
  -v /etc/ssl/CA/CasjaysDev/private/localhost.key:/etc/apache2/server.key:ro \
  -p 7080:80 \
  -p 7081:443 \
  konradkleine/docker-registry-frontend:v2
