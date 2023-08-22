EXEC_CMD_BIN="bun"                     # command to execute
EXEC_CMD_ARGS="dev $DATA_DIR/index.ts" # command arguments

# define commands
[ -d "$DATA_DIR" ] && cd "$DATA_DIR" || exit 1
if [ -n "$START_SCRIPT" ]; then
  RUN_SCRIPT="$START_SCRIPT"
elif [ -f "./src/index.ts" ]; then
  RUN_SCRIPT="./index.ts"
elif [ -f "./index.ts" ]; then
  RUN_SCRIPT="./index.ts"
elif [ -f "./app.ts" ]; then
  RUN_SCRIPT="./app.ts"
elif [ -f "./server.ts" ]; then
  RUN_SCRIPT="./server.ts"
fi

# Run bun install
__exec_command $EXEC_CMD_BIN install
EXEC_CMD_ARGS="dev $RUN_SCRIPT"
