EXEC_CMD_BIN="aria2c"                           # command to execute
EXEC_CMD_ARGS="--conf-path=$ETC_DIR/aria2.conf" # command arguments

#
RPC_SECRET="${RPC_SECRET:-}"
GET_WEB_CONFIG="$(find "$WWW_DIR/js" -name 'aria-ng*.js' | grep -v '^$')"
[ -n "$RPC_SECRET" ] && RPC_SECRET_BASE64=$(echo -n "${RPC_SECRET}" | base64 -w 0)

#
__replace "6800" "$SERVICE_PORT" $GET_WEB_CONFIG
__replace "REPLACE_RPC_PORT" "$SERVICE_PORT" "$ETC_DIR/aria2.conf"
# replace variables recursively
# __find_replace "" "" "$CONF_DIR/"
if grep -qs "REPLACE_RPC_SECRET" "$GET_WEB_CONFIG"; then
  __find_replace "REPLACE_RPC_SECRET" "$RPC_SECRET_BASE64" "$GET_WEB_CONFIG"
else
  sed -i 's,secret:"[^"]*",secret:"'"${RPC_SECRET_BASE64}"'",g' "$GET_WEB_CONFIG"
fi
if [ -n "$RPC_SECRET" ]; then
  echo "Changing rpc secret to $RPC_SECRET"
  if grep -sq "rpc-secret=" "$ETC_DIR/aria2.conf"; then
    __replace "REPLACE_RPC_SECRET" "$RPC_SECRET" "$ETC_DIR/aria2.conf"
  else
    echo "rpc-secret=$RPC_SECRET" >>"$ETC_DIR/aria2.conf"
  fi
else
  __replace "rpc-secret=" "#rpc-secret=" "$ETC_DIR/aria2.conf"
fi

# custom commands
touch "$CONF_DIR/aria2.session"
ln -sf "$CONF_DIR/aria2.session" "$ETC_DIR/aria2.session"
