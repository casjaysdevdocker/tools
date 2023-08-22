mv -f "/etc/$PHP_VERSION" "/etc/php/"
cp -Rf "/usr/local/share/template-files/config/php/." "/etc/php/"
ln -sf "/etc/php" "/etc/$PHP_VERSION"
[ -e "/etc/php" ] && rm -Rf "/etc/php" || true
[ -z "${PHP_VERSION}" ] || ln -sf "/etc/${PHP_VERSION}" "/etc/php"
