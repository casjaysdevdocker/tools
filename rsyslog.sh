mkdir -p /var/lib/docker/storage/rsyslog/elastic && chmod -Rf 777 /var/lib/docker/storage/rsyslog

docker run -d \
--name rsyslog \
--hostname syslogs \
--restart always \
--privileged \
-p 514:514 \
-p 514:514/udp \
-p 5601:5601 \
-v /etc/localtime:/etc/localtime:ro \
-v /var/lib/docker/storage/rsyslog/elastic:/var/lib/elasticsearch \
registry.casjay.in/latest/rsyslog:latest
