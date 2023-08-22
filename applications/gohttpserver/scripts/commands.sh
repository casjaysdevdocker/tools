EXEC_CMD_BIN="gohttpserver"                                           # command to execute
EXEC_CMD_ARGS="--title=DevSystem --cors --xheaders --theme=black "    # command arguments
EXEC_CMD_ARGS+="--addr=0.0.0.0 --port=$SERVICE_PORT --root=$WWW_DIR " #

user_name="${GOHTTPSERVER_USER_NAME:-}"           # normal user name
root_user_name="${GOHTTPSERVER_ROOT_USER_NAME:-}" # root user name

user_pass="${GOHTTPSERVER_USER_PASS_WORD:-}"      # normal user password
root_user_pass="${GOHTTPSERVER_ROOT_PASS_WORD:-}" # root user password
