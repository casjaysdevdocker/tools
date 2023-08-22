php-fpm --allow-to-run-as-root --nodaemonize --fpm-config /etc/php/php-fpm.conf

sed -i 's|user.*=.*|user = '$user'|g' "$ETC_DIR"/*/www.conf
sed -i 's|group.*=.*|group = '$user'|g' "$ETC_DIR"/*/www.conf
