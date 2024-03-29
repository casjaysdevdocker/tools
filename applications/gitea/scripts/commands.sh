SERVICE_PORT=80
EXEC_CMD_ARGS="--port $SERVICE_PORT --config $ETC_DIR/app.ini "             # command arguments
EXEC_CMD_ARGS+="--custom-path $ETC_DIR/custom --work-path $DATA_DIR/gitea " # continued

GITEA_USER="$SERVICE_USER"
GITEA_TZ="${TZ:-America/New_York}"
GITEA_PROTO="${GITEA_PROTO:-http}"
GITEA_EMAIL_CONFIRM="${GITEA_EMAIL_CONFIRM:-false}"
GITEA_DB_TYPE="${GITEA_DB_TYPE:-sqlite3}"
GITEA_HOSTNAME="${DOMAINNAME:-$HOSTNAME}"
GITEA_PORT="${GITEA_PORT:-$SERVICE_PORT}"
GITEA_NAME="${GITEA_NAME:-Gitea - GIT Server}"
GITEA_SQL_DB_HOST="${GITEA_SQL_DB_HOST:-localhost}"
GITEA_ADMIN="${GITEA_ADMIN:-gitea@${DOMAINNAME:-$HOSTNAME}}"
GITEA_EMAIL_RELAY="${GITEA_EMAIL_RELAY:-${EMAIL_RELAY:-localhost}}"
GITEA_LFS_JWT_SECRET="${GITEA_LFS_JWT_SECRET:-$($EXEC_CMD_BIN generate secret LFS_JWT_SECRET)}"
GITEA_INTERNAL_TOKEN="${GITEA_INTERNAL_TOKEN:-$($EXEC_CMD_BIN generate secret INTERNAL_TOKEN)}"
[ "$GITEA_EMAIL_CONFIRM" = "yes" ] && GITEA_EMAIL_CONFIRM="true"
export CUSTOM_PATH="$ETC_DIR"
export WORK_DIR="$DATA_DIR/gitea"
export GITEA_WORK_DIR="$WORK_DIR"

sed -i "s|REPLACE_GITEA_NAME|$GITEA_NAME|g" "$ETC_DIR/app.ini"
#
__replace "REPLACE_GITEA_TZ" "$GITEA_TZ" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_PORT" "$GITEA_PORT" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_USER" "$GITEA_USER" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_PROTO" "$GITEA_PROTO" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_ADMIN" "$GITEA_ADMIN" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_SERVER" "$GITEA_SERVER" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_EMAIL_RELAY" "$GITEA_EMAIL_RELAY" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_EMAIL_CONFIRM" "$GITEA_EMAIL_CONFIRM" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_INTERNAL_TOKEN" "$GITEA_INTERNAL_TOKEN" "$ETC_DIR/app.ini"
__replace "REPLACE_GITEA_LFS_JWT_SECRET" "$GITEA_LFS_JWT_SECRET" "$ETC_DIR/app.ini"
# database settings
__replace "REPLACE_DB_TYPE" "$GITEA_DB_TYPE" "$ETC_DIR/app.ini"
[ -n "$GITEA_SQL_DB" ] && __replace "REPLACE_SQL_DB" "$GITEA_SQL_DB" "$ETC_DIR/app.ini"
[ -n "$GITEA_SQL_USER" ] && __replace "REPLACE_SQL_USER" "$GITEA_SQL_USER" "$ETC_DIR/app.ini"
[ -n "$GITEA_SQL_PASS" ] && __replace "REPLACE_SQL_PASS" "$GITEA_SQL_PASS" "$ETC_DIR/app.ini"
[ -n "$GITEA_SQL_DB_HOST" ] && __replace "REPLACE_SQL_HOST" "$GITEA_SQL_DB_HOST" "$ETC_DIR/app.ini"

[ -f "$CONF_DIR/app.ini" ] || cp -Rf "$ETC_DIR/app.ini" "$CONF_DIR/app.ini"
