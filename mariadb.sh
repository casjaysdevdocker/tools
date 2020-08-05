mkdir -p /var/lib/docker/storage/mariadb && chmod -Rf 777 /var/lib/docker/storage/mariadb

docker run -d \
--restart always \
--name mariadb \
-p 3306:3306 \
-v /var/lib/docker/storage/mariadb:/var/lib/mysql \
registry.casjay.in/latest/mariadb:latest
