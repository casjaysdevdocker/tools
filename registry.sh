mkdir -p /var/lib/docker/storage/registry && chmod -Rf 777 /var/lib/docker/storage/registry

docker run -d \
-p 5000:5000 \
--restart=always \
--name registry \
-v /var/lib/docker/storage/registry:/var/lib/registry \
-e SEARCH_BACKEND=sqlalchemy \
-v /etc/ssl/CA/CasjaysDev:/etc/ssl/CA/CasjaysDev \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/etc/ssl/CA/CasjaysDev/certs/localhost.crt \
-e REGISTRY_HTTP_TLS_KEY=/etc/ssl/CA/CasjaysDev/private/localhost.key \
registry
