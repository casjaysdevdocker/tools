

docker run -d \
--restart always \
--name ircd \
-p 6697:6697 \
-p 7000:7000 \
-v /etc/letsencrypt/live/domain/fullchain.pem:/home/unreal/unrealircd/conf/ssl/server.cert.pem:ro \
-v /etc/letsencrypt/live/domain/privkey.pem:/home/unreal/unrealircd/conf/ssl/server.key.pem:ro \
joelnb/unrealircd:latest