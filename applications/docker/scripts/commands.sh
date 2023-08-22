SERVICE_PORT="2375"
EXEC_CMD_BIN="dockerd"                                                              # command to execute
EXEC_CMD_ARGS="-H tcp://127.0.0.1:$SERVICE_PORT -H unix:///var/run/docker.sock "    # command arguments
EXEC_CMD_ARGS+="-H unix:///tmp/docker.sock --config-file $HOME/.docker/daemon.json" #

REGISTERY="${REGISTERY:-REGISTERIES}"
DOCKER_HUB_TOKEN="${DOCKER_HUB_TOKEN:-DOCKER_TOKEN}"

__file_copy "$CONF_DIR/daemon.json" "$HOME/.docker/" |& tee -a "$LOG_DIR/init.txt" &>/dev/null
# custom commands
if [ ! -f "$HOME/.docker/config.json" ]; then
  cat <<EOF | tee "$HOME/.docker/config.json" &>/dev/null
{
  "auths": { "https://index.docker.io/v1/": { "auth": "$DOCKER_HUB_TOKEN" } },
  "HttpHeaders": { "User-Agent": "Docker-Client/23.0.1 (linux)" },
  "insecure-registries" : [$registries]
}
EOF
fi
[ -f "$CONF_DIR/daemon.json" ] || cp -Rf "$HOME/.docker/config.json" "$CONF_DIR/daemon.json"
