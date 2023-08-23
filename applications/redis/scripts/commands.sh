SERVICE_PORT="6379"

EXEC_CMD_BIN="redis-server"         # command to execute
EXEC_CMD_ARGS="$ETC_DIR/redis.conf" # command arguments

sysctl vm.overcommit_memory=1
echo madvise >/sys/kernel/mm/transparent_hugepage/enabled

if [ -n "$root_user_name" ] && [ -n "$root_user_pass" ]; then
  if ! grep -qs "$root_user_name" "$ETC_DIR/redis.conf"; then
    echo 'user '$root_user_name' on +@all ~* >'$root_user_pass'' >>"$ETC_DIR/redis.conf"
  fi
fi
grep -qs 'redis' /etc/passwd && chown -Rf redis. "$ETC_DIR" "$LOG_DIR" "$DATABASE_DIR"
