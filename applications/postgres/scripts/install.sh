mkdir -p "/etc/phppgadmin"
[ -e "/etc/php" ] && rm -Rf "/etc/php"
[ -d "/etc/apache2/conf.d" ] && rm -Rf "/etc/apache2/conf.d"/*
[ -d "/tmp/etc/php" ] && mv -f "/tmp/etc/php" "/tmp/etc/${PHP_VERSION}"
[ -d "/etc/${PHP_VERSION}" ] && ln -sf "/etc/${PHP_VERSION}" "/etc/php"
git clone -q --depth 1 "https://github.com/phppgadmin/phppgadmin" "${WWW_ROOT_DIR}}"
cp -Rf "/tmp/etc/." "/etc/"
cp -Rf "/usr/local/share/template-files/config/phppgadmin/config.php" "/etc/phppgadmin/config.php"
ln -sf "/etc/phppgadmin/config.php" "${WWW_ROOT_DIR}}/conf/config.inc.php"
