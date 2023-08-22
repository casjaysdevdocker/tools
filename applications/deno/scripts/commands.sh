EXEC_CMD_BIN="deno"        # command to execute
EXEC_CMD_ARGS="task start" # command arguments
server_files="$(find "$DATA_DIR" "$DATA_DIR/src" -maxdepth 1 -type f -iname 'app.ts' -iname 'server.ts' -iname'index.tx' | head -n1)"
[ -d "$DATA_DIR" ] && cd "$DATA_DIR" || exit 1
if [ -n "$START_SCRIPT" ] && [ -f "$START_SCRIPT" ]; then
  EXEC_CMD_BIN="$START_SCRIPT"
elif [ -f "$server_files" ]; then
  EXEC_CMD_ARGS="$server_files"
elif [ -f "src/index.ts" ]; then
  EXEC_CMD_ARGS="src/index.ts"
elif [ -f "index.ts" ]; then
  EXEC_CMD_ARGS="index.ts"
elif [ -f "app.ts" ]; then
  EXEC_CMD_ARGS="app.ts"
elif [ -f "server.ts" ]; then
  EXEC_CMD_ARGS="server.ts"
fi
