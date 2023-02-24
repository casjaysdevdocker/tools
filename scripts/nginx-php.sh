#!/usr/bin/env bash
# Lets setup the domain
DOM=${1:-$HOSTNAME}
mkdir -p /var/lib/docker/storage/nginx/$DOM &&
  chmod -Rf 777 /var/lib/docker/storage/nginx/$DOM

# Only allow local as we will use a proxy
docker run -d \
  --restart always \
  --name $DOM \
  -v /var/lib/docker/storage/nginx/$DOM:/var/www/html \
  -p 127.0.0.1:30000:80 \
  -p 127.0.0.1:30050:443 \
  -e 'WEBROOT=/var/www/html' \
  -e 'DOMAIN=$DOM' \
  richarvey/nginx-php-fpm
