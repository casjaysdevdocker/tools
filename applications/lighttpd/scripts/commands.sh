EXEC_CMD_BIN="lighttpd"                        # command to execute
EXEC_CMD_ARGS="/etc/lighttpd/lighttpd.conf -D" # command arguments

if [ -z "$PHP_BIN_DIR" ]; then
  [ -f "$WWW_DIR/www/info.php" ] && echo "PHP support is not enabled" >"$WWW_DIR/info.php"
  [ -f "$ETC_DIR/conf.d/php-fpm.conf" ] && echo "# PHP support is not enabled" >"$ETC_DIR/conf.d/php-fpm.conf"
fi
