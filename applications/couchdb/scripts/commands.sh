__curl() { curl -q -LSsf --user "$root_user_name:$root_user_pass" "$@"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_users() { __curl -X PUT -H 'Accept: application/json' -H 'Content-Type: application/json' 'http://'$COUCHDB_SERVER':'$SERVICE_PORT'/_users/org.couchdb.user:'$1'' -d "{\"name\": \"$1\", \"password\": \"$2\", \"roles\": [], \"type\": \"user\"}" || return 2; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_database() { curl -q -LSsf -X PUT 'http://'$root_user_name:$root_user_pass'@'$COUCHDB_SERVER':'$SERVICE_PORT'/'$1'' || return 2; }

SERVICE_PORT="5984"
EXEC_CMD_BIN="couchdb" # command to execute
EXEC_CMD_ARGS="-vvvvv" # command arguments
IS_DATABASE_SERVICE="yes"
NODENAME="${NODENAME:-}"
CREATE_DATABASE="${CREATE_DATABASE:-}"
COUCHDB_SERVER="${COUCHDB_SERVER:-localhost}"
COUCHDB_ROOT_USER_NAME="${COUCHDB_USER:-root}"
COUCHDB_ROOT_PASS_WORD="${COUCHDB_PASSWORD:-$(__random_password)}"
COUCHDB_ERLANG_COOKIE="${COUCHDB_ERLANG_COOKIE:-}"

user_name="${COUCHDB_USER_NAME:-}"           # normal user name
root_user_name="${COUCHDB_ROOT_USER_NAME:-}" # root user name
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# passwords [password/random]
user_pass="${COUCHDB_USER_PASS_WORD:-}"      # normal user password
root_user_pass="${COUCHDB_ROOT_PASS_WORD:-}" # root user password

__replace "REPLACE_DATABASE_DIR" "$DATABASE_DIR" "$ETC_DIR/default.ini"
# custom commands
touch "$ETC_DIR/local.d/docker.ini" 2>/dev/null
ln -sf "$DATABASE_DIR" "/opt/couchdb/data" 2>/dev/null

local user_name="${user_name:-$root_user_name}" # set user name
local user_pass="${user_pass:-$root_user_pass}" # set user pass

if ! __curl "http://$COUCHDB_SERVER:$SERVICE_PORT/_users" | grep -q 'db_name":"_users'; then
  echo "Creating the _users databases"
  if __curl_database "_users" | grep -qE '200|"ok":true'; then
    echo "Created database _users"
  else
    echo "Failed to create database _users" >&2
  fi
  sleep 1
fi
if ! __curl "http://$COUCHDB_SERVER:$SERVICE_PORT/_replicator" | grep -q 'db_name":"_replicator'; then
  echo "Creating the _replicator databases"
  if __curl_database "_replicator" | grep -qE '200|"ok":true'; then
    echo "Created database _replicator"
  else
    echo "Failed to create database _replicator" >&2
  fi
  sleep 1
fi
if ! __curl "http://$COUCHDB_SERVER:$SERVICE_PORT/_global_changes" | grep -q 'db_name":"_global_changes'; then
  echo "Creating the _global_changes databases"
  if __curl_database "_global_changes" | grep -qE '200|"ok":true'; then
    echo "Created database _global_changes"
  else
    echo "Failed to create database _global_changes" >&2
  fi
  sleep 1
fi
if [ -n "$user_name" ] && [ -n "$user_pass" ]; then
  echo "Creating new user $username"
  if __curl_users "$user_name" "$user_pass"; then
    echo "Created user: $user_name"
  else
    echo "Failed to create user: $user_name" >&2
  fi
fi
if [ -n "$CREATE_DATABASE" ]; then
  echo "Creating database: $CREATE_DATABASE"
  __curl_database "$CREATE_DATABASE" || echo "Failed to create database: $CREATE_DATABASE" >&2
fi
