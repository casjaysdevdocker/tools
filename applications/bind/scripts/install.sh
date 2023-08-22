etc_dir="/etc/bind" var_dir="/var/bind" data_dir="/data/named" conf_dir="/config/named"
rm -Rf "/etc/rndc"* "/etc/bind/"* "/var/bind/"*
mkdir -p "$etc_dir" "$var_dir" "${DEFAULT_CONF_DIR}/named" "${DEFAULT_DATA_DIR}/named" "/run/named" "/tmp/etc/named" "/tmp/var/named" "/tmp/etc/named/keys" "/tmp/var/named/zones"
[ -d "/tmp/etc/named" ] && cp -Rf "/tmp/etc/named/." "$etc_dir/" && cp -Rf "/tmp/etc/named/." "${DEFAULT_CONF_DIR}/named/"
[ -d "/tmp/var/named" ] && cp -Rf "/tmp/var/named/." "$var_dir/" && cp -Rf "/tmp/var/named/." "${DEFAULT_DATA_DIR}/named/"
chown -Rf named:named "$etc_dir" "$var_dir" "${DEFAULT_CONF_DIR}/named" "${DEFAULT_DATA_DIR}/named" "/run/named"
find "$etc_dir" "$var_dir" "/run/named" "${DEFAULT_CONF_DIR}/named" "${DEFAULT_DATA_DIR}/named" -type d -exec chmod -Rf 777 {} \; && echo "changed folder permissions to 777"
find "$etc_dir" "$var_dir" "/run/named" "${DEFAULT_CONF_DIR}/named" "${DEFAULT_DATA_DIR}/named" -type f -exec chmod -Rf 664 {} \; && echo "changed file permissions to 664"
