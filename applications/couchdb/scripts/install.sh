[ -d "/etc/nginx" ] || mkdir -p "/etc/nginx"
[ -d "/etc/couchdb" ] && rm -Rf "/etc/couchdb"
[ -d "/tmp/etc/nginx" ] && cp -Rf "/tmp/etc/nginx/." "/etc/nginx/"
[ -f "/docker-entrypoint.sh" ] && rm -Rf "/docker-entrypoint.sh"
for f in $(ls -A /opt/couchdb/bin); do ln -sf "/opt/couchdb/bin/$f" "/usr/local/bin/$f"; done
for f in conf.d modules-available modules-enabled sites-available sites-enabled snippets; do if [ -e "/etc/nginx/$f" ]; then rm -Rf "/etc/nginx/$f"; fi; done
chown -Rf couchdb:couchdb /opt/couchdb
chown -Rf www-data:www-data /etc/nginx
