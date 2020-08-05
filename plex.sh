mkdir -p /var/lib/docker/storage/plex && chmod -Rf 777 /var/lib/docker/storage/plex

docker run \
--restart=always \
--name=plex \
--net=host \
-e VERSION=latest \
-e TZ=America/New_York \
-v /var/lib/docker/storage/plex:/config \
-v /mnt/media:/data \
-v /tmp:/transcode \
registry.casjay.in/latest/plex:latest
