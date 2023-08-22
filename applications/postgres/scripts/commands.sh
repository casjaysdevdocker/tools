SERVICE_USER="postgres"          # execute command as another user
EXEC_CMD_BIN="postgres"          # command to execute
EXEC_CMD_ARGS="-D $DATABASE_DIR" # command arguments

if [ ! -s "$DATABASE_DIR/PG_VERSION" ]; then
  sudo -u $user initdb --username="$user" -A md5 --pwfile="${ROOT_FILE_PREFIX}/${SERVICE_NAME}_pass" -D "$DATABASE_DIR" >/dev/null
fi
chmod -f 0750 "$DATABASE_DIR"
