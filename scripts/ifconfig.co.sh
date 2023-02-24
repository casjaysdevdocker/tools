#!/usr/bin/env bash

docker run \
  --detach \
  --name ifconfig \
  -p 127.0.0.1:85:8080 \
  --restart=always \
  mpolden/echoip echoip -p -H X-Forwarded-For
