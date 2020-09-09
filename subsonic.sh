mkdir -p /var/lib/docker/storage/airsonic/{music,podcasts,playlists,data} && chmod -Rf 777 /var/lib/docker/storage/airsonic

docker run -d \
--name=airsonic \
--hostname airsonic \
--restart=always \
--privileged \
-p 4040:4040 \
-v /var/lib/docker/storage/airsonic/music:/airsonic/music:z \
-v /var/lib/docker/storage/airsonic/podcasts:/airsonic/podcasts:z \
-v /var/lib/docker/storage/airsonic/playlists:/airsonic/playlists:z \
-v /var/lib/docker/storage/airsonic/data:/airsonic/data:z \
airsonic/airsonic:latest
