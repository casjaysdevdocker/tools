SERVICE_PORT="3000,9000-9100"
EXEC_CMD_BIN="dockerd"                  # command to execute
EXEC_CMD_ARGS=""                        # command arguments
EXEC_PRE_SCRIPT="dockerd-entrypoint.sh" # execute script before

COOLIFY_ENV_FILE="${COOLIFY_ENV_FILE:-/root/coolify.env}"
COLLIFY_IMAGE="${COLLIFY_IMAGE:-ghcr.io/coollabsio/coolify:latest}"
COOLIFY_APP_ID="${COOLIFY_APP_ID:-$(cat /proc/sys/kernel/random/uuid)}"
COOLIFY_DATABASE_URL="${COOLIFY_DATABASE_URL:-$DATABASE_DIR/prod.db}"
COOLIFY_WHITE_LABELED_ICON="${COOLIFY_WHITE_LABELED_ICON:-$COOLIFY_WHITE_LABELED_ICON}"
COOLIFY_SECRET_KEY="${COOLIFY_SECRET_KEY:-$(echo $(($(date +%s%N) / 1000000)) | sha256sum | base64 | head -c 32)}"
export COOLIFY_ENV_FILE COLLIFY_IMAGE COOLIFY_APP_ID COOLIFY_DATABASE_URL COOLIFY_WHITE_LABELED_ICON COOLIFY_SECRET_KEY

if [ -f "$CONF_DIR/env" ]; then
  cp -Rf "$CONF_DIR/env" "$COOLIFY_ENV_FILE"
elif [ ! -f "$COOLIFY_ENV_FILE" ]; then
  cat <<EOF | tee "$COOLIFY_ENV_FILE" "$CONF_DIR/env" >/dev/null
COOLIFY_HOSTED_ON="${COOLIFY_HOSTED_ON:-docker}"
COOLIFY_AUTO_UPDATE="${COOLIFY_AUTO_UPDATE:-false}"
COOLIFY_APP_ID="$COOLIFY_APP_ID"
COOLIFY_SECRET_KEY="$COOLIFY_SECRET_KEY"
COOLIFY_WHITE_LABELED_ICON="$COOLIFY_WHITE_LABELED_ICON"
COOLIFY_DATABASE_URL="${COOLIFY_DATABASE_URL:-$DATABASE_DIR/prod.db}"

EOF
fi

docker compose -f "/root/coolify.yaml" up | tee -a /dev/stdout
