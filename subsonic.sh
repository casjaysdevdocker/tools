docker run -d \
--name=subsonic \
--hostname subsonic \
--restart=always \
--privileged \
-p 4040:4040 \
-v /mnt/media/Music:/var/music:ro \
registry.casjay.in/latest/subsonic:6