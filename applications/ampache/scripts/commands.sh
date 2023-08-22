if __file_exists_with_content "/config/secure/ampache_secret.key"; then
  secret_key="$(<"/config/secure/ampache_secret.key")"
else
  secret_key="$(__random_password 32)"
  echo "$secret_key" >"/config/secure/ampache_secret.key"
fi

if __file_exists_with_content "$CONF_DIR/ampache.cfg.php"; then
  __sed "s|REPLACE_DB_HOST|127.0.0.1|g" "$CONF_DIR/ampache.cfg.php"
  __sed "s|REPLACE_SECURITY_CODE|$secret_key|" "$CONF_DIR/ampache.cfg.php"
  [ -n "$root_user_pass" ] && __sed 's|REPLACE_PASSWORD|'$root_user_pass'|g' "$CONF_DIR/ampache.cfg.php"
else
  __sed "s|REPLACE_DB_HOST|127.0.0.1|g" "$ETC_DIR/ampache.cfg.php.dist"
  __sed "s|REPLACE_SECURITY_CODE|$secret_key|" "$ETC_DIR/ampache.cfg.php.dist"
  [ -n "$root_user_pass" ] && __sed 's|REPLACE_PASSWORD|'$root_user_pass'|g' "$ETC_DIR/ampache.cfg.php.dist"
fi

### POST
(
  while :; do __file_exists_with_content "$ETC_DIR/ampache.cfg.php" && cp -Rf "$ETC_DIR/ampache.cfg.php" "$CONF_DIR/ampache.cfg.php" && break || sleep 120; done
  secret_key="$(grep --no-filename -s "secret_key = " "$ETC_DIR/ampache.cfg.php" | awk -F ' = ' '{print $2}' | sed 's| ||g;s|"||g')"
  [ -n "$secret_key" ] && echo "$secret_key" >"/config/secure/ampache_secret.key"
)
