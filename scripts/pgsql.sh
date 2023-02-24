#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/postgres &&
  chmod -Rf 777 /var/lib/docker/storage/postgres

docker run -d \
  --name postgres \
  --restart=always \
  -p 5432:5432 \
  -v /var/lib/docker/storage/postgres:/var/lib/postgresql/data \
  registry.casjay.in/latest/postgres:latest
