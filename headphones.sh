mkdir -p /var/lib/docker/storage/headphones/transmission-daemon/{etc,watch,downloads} && chmod -Rf 777 /var/lib/docker/storage/headphones/transmission-daemon

docker run -d --name=transmission-headphones \
--restart always \
-v /var/lib/docker/storage/headphones/transmission-daemon/etc:/config \
-v /var/lib/docker/storage/headphones/transmission-daemon/downloads:/downloads \
-v /var/lib/docker/storage/headphones/transmission-daemon/watch:/watch \
-v /mnt/torrents:/mnt/torrents \
-p 9092:9091 -p 51414:51413 \
-p 51414:51413/udp \
registry.casjay.in/latest/transmission:latest

