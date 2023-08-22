EXEC_CMD_BIN="nodemon" # command to execute

NODE_MANAGER="${NODE_MANAGER:-system}"
NODE_VERSION="${NODE_VERSION:-12}"
export NVM_DIR="$HOME/.nvm"
export FNM_DIR="$HOME/.fnm"
export FNM_LOGLEVEL="error"
export FNM_INTERACTIVE_CLI="false"
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
[ -f "/app/.node_version" ] && NODE_VERSION="$(</app/.node_version)"
[ -f "/app/.env" ] && . "/app/.env"
[ -f "/root/.bashrc" ] && . /root/.bashrc
export NODE_VERSION NODE_MANAGER

if [ -z "$(type -P node)" ] && [ -n "$(type -P apt)" ]; then
  echo "Installing default nodejs package - this may take a minute...."
  apt install -yy -q nodejs npm yarn unzip &>/dev/null
fi

[ -d "/app" ] || mkdir -p /app
if [ -z "$(type fnm 2>/dev/null)" ] && [ "$NODE_MANAGER" = "fnm" ]; then
  echo "Initializing fnm..."
  grep -qs 'FNM export' "/config/env/node.sh" && BASHRC="false"
  curl -q -LSsf "https://fnm.vercel.app/install" -o "/tmp/node_init.bash" && chmod 755 "/tmp/node_init.bash"
  bash "/tmp/node_init.bash" --install-dir "/usr/local/bin" --force-install --skip-shell &>/dev/null
  if [ "$BASHRC" != "false" ]; then
    cat <<EOF >>"/config/env/node.sh"
# FNM export 
[ -n "$(type fnm 2>/dev/null)" ] && eval "\$(fnm env --shell bash)"
EOF
  fi
elif [ -z "$(type nvm 2>/dev/null)" ] && [ "$NODE_MANAGER" = "nvm" ]; then
  echo "Initializing nvm..."
  grep -qs 'NVM' "/config/env/node.sh" && BASHRC="false"
  curl -q -LSsf "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" -o "/tmp/node_init.bash" && chmod 755 "/tmp/node_init.bash"
  bash "/tmp/node_init.bash" &>/dev/null
  if [ "$BASHRC" != "false" ]; then
    cat <<EOF >>"/config/env/node.sh"
# NVM export
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && . "\$NVM_DIR/bash_completion"
EOF
  fi
else
  echo "Initializing nodejs..."
fi
[ -d "$HOME.local/state/" ] && rm -Rf "$HOME.local/state"
[ -f "/tmp/node_init.bash" ] && rm -Rf "/tmp/node_init.bash"

if [ "$NODE_MANAGER" = "fnm" ]; then
  echo "Installing node $NODE_VERSION from fnm"
  [ -f "/config/env/node.sh" ] && . /config/env/node.sh
  fnm install $NODE_VERSION &>/dev/null
  fnm default $NODE_VERSION &>/dev/null
  fnm use $NODE_VERSION &>/dev/null
  NODE_VERSION_INST="$(node --version 2>/dev/null)"
elif [ "$NODE_MANAGER" = "nvm" ]; then
  echo "Installing node $NODE_VERSION from nvm"
  [ -f "/config/env/node.sh" ] && . /config/env/node.sh
  nvm install $NODE_VERSION &>/dev/null
  nvm alias default $NODE_VERSION &>/dev/null
  nvm use $NODE_VERSION &>/dev/null
  NODE_VERSION_INST="$(node --version 2>/dev/null)"
else
  echo "Using nodejs from distro"
  NODE_VERSION_INST="$(node --version 2>/dev/null)"
fi
#
package_file="$(find "/app" -name 'package.json' | head -n1 | grep '^' || echo '')"
if [ -f "$package_file" ]; then
  if [ -x "/app/start.sh" ]; then
    EXEC_CMD_BIN="/app/start.sh"
  elif cat "$package_file" 2>/dev/null | jq -r '.scripts.start:dev' 2>/dev/null | grep -v 'null'; then
    EXEC_CMD_ARGS="--exec npm run start:dev"
  elif cat "$package_file" 2>/dev/null | jq -r '.scripts.dev' 2>/dev/null | grep -v 'null'; then
    EXEC_CMD_ARGS="--exec npm run dev"
  elif cat "$package_file" 2>/dev/null | jq -r '.scripts.start' 2>/dev/null | grep -v 'null'; then
    EXEC_CMD_ARGS="--exec npm run start"
  elif [ -f "/app/index.js" ]; then
    EXEC_CMD_ARGS="/app/index.js"
  elif [ -f "/app/app.js" ]; then
    EXEC_CMD_ARGS="/app/app.js"
  elif [ -f "/app/server.js" ]; then
    EXEC_CMD_ARGS="/app/server.js"
  elif [ -f "/app/server/index.js" ]; then
    EXEC_CMD_ARGS="/app/server/server/index.js"
  elif [ -f "/app/client/index.js" ]; then
    EXEC_CMD_ARGS="/app/client/server/index.js"
  fi
else
  EXEC_CMD_ARGS="/app/index.js"
  [ -n "$(type -P npm)" ] && npm init -y &>/dev/null && npm i -D nodemon &>/dev/null && touch /app/index.js || { echo "npm not found" && exit 10; }
fi
[ -n "$NODE_VERSION_INST" ] && echo "node is set to use version: $NODE_VERSION_INST" || { echo "Can not find nodejs" && exit 10; }
npm i -D &>/dev/null && npm i -g nodemon &>/dev/null
