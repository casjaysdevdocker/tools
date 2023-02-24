#!/usr/bin/env bash
mkdir /var/lib/docker/storage/rocketchat &&
  chmod -Rf 777 /var/lib/docker/storage/rocketchat

docker run -d --name rocketchat \
  --restart always
-p 127.0.0.1:39520:3000 -v \
  /var/lib/docker/storage/rocketchat:/app \
  --env ROOT_URL=http://localhost \
  --env MONGO_URL=mongodb://mymongourl/mydb \
  rocket.chat
