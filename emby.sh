mkdir -p /var/lib/docker/storage/emby/ && chmod -Rf 777 /var/lib/docker/storage/emby

docker run -d \
--restart always \
--name emby \
--volume /var/lib/docker/storage/emby:/config \
--volume /mnt/media:/mnt/media \
--publish 8096:8096 \
--publish 8920:8920 \
registry.casjay.in/latest/embyserver:latest 
