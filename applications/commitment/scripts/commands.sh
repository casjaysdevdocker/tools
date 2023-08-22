EXEC_CMD_BIN="python3"             # command to execute
EXEC_CMD_ARGS="$WWW_DIR/commit.py" # command arguments

__replace "5000" "$SERVICE_PORT" "$WWW_DIR/commit.py"
if [ -f "$CONF_DIR/messages.local" ]; then
  cat "$CONF_DIR/messages.local" "$WWW_DIR/commit_messages.txt" 2>/dev/null | sort -u >"$WWW_DIR/commit_messages.txt.tmp"
  mv -f "$WWW_DIR/commit_messages.txt.tmp" "$WWW_DIR/commit_messages.txt"
fi
if [ -f "$CONF_DIR/humans.local" ]; then
  mv -f "$CONF_DIR/humans.local" "$WWW_DIR/main/static/humans.txt"
fi
