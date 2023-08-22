EXEC_CMD_BIN="caddy"                            # command to execute
EXEC_CMD_ARGS="run --config $ETC_DIR/Caddyfile" # command arguments

[ -d "$WWW_DIR/health" ] || mkdir -p "$WWW_DIR/health"
[ -f "$WWW_DIR/health/index.txt" ] || echo 'ok' >"$WWW_DIR/health/index.txt"
[ -f "$WWW_DIR/health/index.json" ] || echo '{ "status": "ok" }' >"$WWW_DIR/health/index.json"
