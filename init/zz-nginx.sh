#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202308221957-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  zz-nginx.sh --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Tuesday, Aug 22, 2023 19:57 EDT
# @@File             :  zz-nginx.sh
# @@Description      :
# @@Changelog        :  New script
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  shell/bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf '%s\n' "# - - - Initializing nginx - - - #"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SERVICE_NAME="nginx"
SCRIPT_NAME="$(basename "$0" 2>/dev/null)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export PATH="/usr/local/etc/docker/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run trap command on exit
trap 'retVal=$?;[ "$SERVICE_IS_RUNNING" != "true" ] && [ -f "$SERVICE_PID_FILE" ] && rm -Rf "$SERVICE_PID_FILE";exit $retVal' SIGINT SIGTERM EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import the functions file
if [ -f "/usr/local/etc/docker/functions/entrypoint.sh" ]; then
  . "/usr/local/etc/docker/functions/entrypoint.sh"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables
for set_env in "/root/env.sh" "/usr/local/etc/docker/env"/*.sh "/config/env"/*.sh; do
  [ -f "$set_env" ] && . "$set_env"
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reset environment before executing service
RESET_ENV="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show message before execute
PRE_EXEC_MESSAGE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set the database directory
DATABASE_DIR="${DATABASE_DIR_NGINX:-/data/db/nginx}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set webroot
WWW_DIR="/usr/share/webapps/nginx"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default predefined variables
DATA_DIR="/data"   # set data directory
CONF_DIR="/config" # set config directory
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set the containers etc directory
ETC_DIR="/etc/nginx"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
RUN_DIR="/run/init.d"      # set scripts pid dir
LOG_DIR="/data/logs/nginx" # set log directory
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the working dir
WORK_DIR="" # set working directory
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Where to save passwords to
ROOT_FILE_PREFIX="/config/secure/auth/root" # directory to save username/password for root user
USER_FILE_PREFIX="/config/secure/auth/user" # directory to save username/password for normal user
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# root/admin user info password/random]
root_user_name="${NGINX_ROOT_USER_NAME:-}" # root user name
root_user_pass="${NGINX_ROOT_PASS_WORD:-}" # root user password
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Normal user info [password/random]
user_name="${NGINX_USER_NAME:-}"      # normal user name
user_pass="${NGINX_USER_PASS_WORD:-}" # normal user password
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Overwrite variables from files
__file_exists_with_content "${USER_FILE_PREFIX}/${SERVICE_NAME}_name" && user_name="$(<"${USER_FILE_PREFIX}/${SERVICE_NAME}_name")"
__file_exists_with_content "${USER_FILE_PREFIX}/${SERVICE_NAME}_pass" && user_pass="$(<"${USER_FILE_PREFIX}/${SERVICE_NAME}_pass")"
__file_exists_with_content "${ROOT_FILE_PREFIX}/${SERVICE_NAME}_name" && root_user_name="$(<"${ROOT_FILE_PREFIX}/${SERVICE_NAME}_name")"
__file_exists_with_content "${ROOT_FILE_PREFIX}/${SERVICE_NAME}_pass" && root_user_pass="$(<"${ROOT_FILE_PREFIX}/${SERVICE_NAME}_pass")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# port which service is listening on
SERVICE_PORT="80"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# execute command variables
SERVICE_UID="0"                        # set the user id
SERVICE_USER="root"                    # execute command as another user
EXEC_CMD_BIN="nginx"                   # command to execute
EXEC_CMD_ARGS="-c $ETC_DIR/nginx.conf" # command arguments
EXEC_PRE_SCRIPT=""                     # execute script before
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is this service a web server
IS_WEB_SERVER="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is this service a database server
IS_DATABASE_SERVICE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional predefined variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specifiy custom directories to be created
ADD_APPLICATION_FILES=""
ADD_APPLICATION_DIRS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPLICATION_FILES="$LOG_DIR/nginx.log"
APPLICATION_DIRS="$RUN_DIR $ETC_DIR $CONF_DIR $LOG_DIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# define variables that need to be loaded into the service - escape quotes - var=\"value\",other=\"test\"
CMD_ENV=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# use this function to update config files - IE: change port
__update_conf_files() {
  local exitCode=0                          # default exit code
  local user="${SERVICE_USER:-root}"        # specifiy different user
  local runas="root"                        # run as a different user
  local sysname="${SERVER_NAME:-$HOSTNAME}" # set hostname
  local blowfish_pass="$(htpasswd -bnBC 10 "" password | tr -d ':\n' | sed 's/$2y/$2a/')"
  # delete files
  #__rm ""

  # define actions

  # create default directories
  for filedirs in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
    if [ -n "$filedirs" ] && [ ! -d "$filedirs" ]; then
      (
        echo "Creating directory $filedirs with permissions 777"
        mkdir -p "$filedirs" && chmod -Rf 777 "$filedirs"
      ) |& tee -a "$LOG_DIR/init.txt" &>/dev/null
    fi
  done
  # create default files
  for application_files in $ADD_APPLICATION_FILES $APPLICATION_FILES; do
    if [ -n "$application_files" ] && [ ! -e "$application_files" ]; then
      (
        echo "Creating file $application_files with permissions 777"
        touch "$application_files" && chmod -Rf 777 "$application_files"
      ) |& tee -a "$LOG_DIR/init.txt" &>/dev/null
    fi
  done
  # create directories if variable is yes"
  if [ "$IS_WEB_SERVER" = "yes" ]; then
    APPLICATION_DIRS="$APPLICATION_DIRS $WWW_DIR"
    if [ ! -d "$WWW_DIR" ]; then
      (echo "Creating directory $WWW_DIR with permissions 777" && mkdir -p "$WWW_DIR" && chmod -f 777 "$WWW_DIR") |& tee -a "$LOG_DIR/init.txt" &>/dev/null
    fi
    __initialize_web_health "$WWW_DIR"
  fi
  if [ "$IS_DATABASE_SERVICE" = "yes" ]; then
    APPLICATION_DIRS="$APPLICATION_DIRS $DATABASE_DIR"
    if [ ! -d "$DATABASE_DIR" ]; then
      (echo "Creating directory $DATABASE_DIR with permissions 777" && mkdir -p "$DATABASE_DIR" && chmod -f 777 "$DATABASE_DIR") |& tee -a "$LOG_DIR/init.txt" &>/dev/null
    fi
  fi
  # copy config files to system
  __file_copy "$CONF_DIR/." "$ETC_DIR/" |& tee -a "$LOG_DIR/init.txt" &>/dev/null
  __file_copy "/config/phpmyadmin/." "/etc/phpmyadmin/" |& tee -a "$LOG_DIR/init.txt" &>/dev/null
  # replace variables
  sed -i 's|REPLACE_BLOWFISH_SECRECT|'$blowfish_pass'|g' /config/phpmyadmin/config.inc.php
  # __replace "" "" "$ETC_DIR/nginx.conf"
  # replace variables recursively
  # __find_replace "" "" "$ETC_DIR/"
  # replace defaults in ETC_DIR
  __initialize_replace_variables "$ETC_DIR"
  __initialize_replace_variables "/usr/local/share/wwwroot"
  # custom commands
  if [ ! -d "/config/phpmyadmin" ]; then
    mkdir -p "/config/phpmyadmin"
    __file_copy "/etc/phpmyadmin/." "/config/phpmyadmin/" |& tee -a "$LOG_DIR/init.txt" &>/dev/null
  fi
  # unset unneeded variables
  unset application_files filedirs

  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# function to run before executing
__pre_execute() {
  local exitCode=0                          # default exit code
  local user="${SERVICE_USER:-root}"        # specifiy different user
  local runas="root"                        # run as a different user
  local sysname="${SERVER_NAME:-$HOSTNAME}" # set hostname

  # define commands

  # execute if directories is empty
  #__is_dir_empty "" && true || false

  # create user if needed
  # __create_service_user "$user" "/home/$user" "${USER_GID:-${USER_UID:-1000}"
  # set user on files/folders
  if [ -n "$user" ] && [ "$user" != "root" ]; then
    if grep -s -q "$user:" "/etc/passwd"; then
      for permissions in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
        if [ -n "$permissions" ] && [ -e "$permissions" ]; then
          (chown -Rf $user:$user "$permissions" && echo "changed ownership on $permissions to $user") |& tee -a "$LOG_DIR/init.txt" &>/dev/null
        fi
      done
    fi
  fi

  # unset unneeded variables
  unset filesperms filename
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# function to run after executing
__post_execute() {
  local exitCode=0                          # default exit code
  local user="${SERVICE_USER:-root}"        # specifiy different user
  local runas="root"                        # run as a different user
  local sysname="${SERVER_NAME:-$HOSTNAME}" # set hostname
  sleep 60                                  # how long to wait before executing
  echo "Running post commands"              # message
  # execute commands

  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# use this function to update config files - IE: change port
__pre_message() {
  local exitCode=0
  [ -n "$user_name" ] && echo "username:               $user_name" && echo "$user_name" >"${USER_FILE_PREFIX}/${SERVICE_NAME}_name"
  [ -n "$user_pass" ] && echo "password:               saved to ${USER_FILE_PREFIX}/${SERVICE_NAME}_pass" && echo "$user_pass" >"${USER_FILE_PREFIX}/${SERVICE_NAME}_pass"
  [ -n "$root_user_name" ] && echo "root username:     $root_user_name" && echo "$root_user_name" >"${ROOT_FILE_PREFIX}/${SERVICE_NAME}_name"
  [ -n "$root_user_pass" ] && echo "root password:     saved to ${ROOT_FILE_PREFIX}/${SERVICE_NAME}_pass" && echo "$root_user_pass" >"${ROOT_FILE_PREFIX}/${SERVICE_NAME}_pass"

  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# use this function to setup ssl support
__update_ssl_conf() {
  local exitCode=0
  local sysname="${SERVER_NAME:-$HOSTNAME}" # set hostname

  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_service_env() {
  cat <<EOF | tee "/config/env/${SERVICE_NAME:-$SCRIPT_NAME}.sh" &>/dev/null
# ENV_WORKDIR="${ENV_WORKDIR:-$WORK_DIR}"                            # change to directory
# ENV_WWW_DIR="${ENV_WWW_DIR:-$WWW_DIR}"                            # set default web dir
# ENV_ETC_DIR="${ENV_ETC_DIR:-$ETC_DIR}"                            # set default etc dir
# ENV_DATA_DIR="${ENV_DATA_DIR:-$DATA_DIR}"                         # set default data dir
# ENV_CONF_DIR="${ENV_CONF_DIR:-$CONF_DIR}"                         # set default config dir
# ENV_DATABASE_DIR="${ENV_DATABASE_DIR:-$DATABASE_DIR}"             # set database dir
# ENV_SERVICE_USER="${ENV_SERVICE_USER:-$SERVICE_USER}"             # execute command as another user
# ENV_SERVICE_UID="${ENV_SERVICE_UID:-$SERVICE_UID}"                # set the user id
# ENV_SERVICE_PORT="${ENV_SERVICE_PORT:-$SERVICE_PORT}"             # port which service is listening on
# EXEC_PRE_SCRIPT="${ENV_EXEC_PRE_SCRIPT:-$EXEC_PRE_SCRIPT}"        # execute before commands
# EXEC_CMD_BIN="${ENV_EXEC_CMD_BIN:-$EXEC_CMD_BIN}"                 # command to execute
# EXEC_CMD_ARGS="${ENV_EXEC_CMD_ARGS:-$EXEC_CMD_ARGS}"              # command arguments
# EXEC_CMD_NAME="$(basename "$EXEC_CMD_BIN")"                       # set the binary name
# ENV_USER_NAME="${user_name:-$ENV_USER_NAME}"                      #
# ENV_USER_PASS="${user_pass:-$ENV_USER_PASS}"                      #
# ENV_ROOT_USER_NAME="${root_user_name:-$ENV_ROOT_USER_NAME}"       #
# ENV_ROOT_USER_PASS="${root_user_pass:-$ENV_ROOT_USER_PASS}"       #

EOF
  __file_exists_with_content "/config/env/${SERVICE_NAME:-$SCRIPT_NAME}.sh" || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# script to start server
__run_start_script() {
  local user="${SERVICE_USER:-root}"
  local cmd="${EXEC_CMD_BIN:-}"
  local args="${EXEC_CMD_ARGS:-}"
  local name="${EXEC_CMD_NAME:-}"
  local pre="${EXEC_PRE_SCRIPT:-}"
  local workdir="${WORK_DIR:-$WORK_DIR}"
  local lc_type="${LC_ALL:-${LC_CTYPE:-$LANG}}"
  local home="${workdir//\/root/\/tmp\/docker}"
  local path="/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
  local sysname="${SERVER_NAME:-$HOSTNAME}" # set hostname
  local message=""
  if [ -z "$cmd" ]; then
    __post_execute 2>"/dev/stderr" |& tee -a "$LOG_DIR/init.txt" &>/dev/null
    echo "Initializing $SCRIPT_NAME has completed"
  else
    # ensure the command exists
    if [ ! -x "$cmd" ]; then
      echo "$name is not a valid executable"
      exit 2
    fi
    # set working directories
    [ -z "$home" ] && home="${workdir:-/tmp/docker}"
    [ "$home" = "/root" ] && home="/tmp/docker"
    [ "$home" = "$workdir" ] && workdir=""
    # create needed directories
    [ -n "$home" ] && { [ -d "$home" ] || mkdir -p "$home"; }
    [ -n "$workdir" ] && { [ -d "$workdir" ] || mkdir -p "$workdir" || workdir="/tmp"; }
    [ -n "$workdir" ] && __cd "$workdir" || { [ -n "$home" ] && __cd "$home"; } || __cd "/tmp"
    [ "$user" != "root " ] && [ -d "$home" ] && chmod -f 777 "$home"
    [ "$user" != "root " ] && [ -d "$workdir" ] && chmod -f 777 "$workdir"
    # check and exit if already running
    if __proc_check "$name" || __proc_check "$cmd"; then
      echo "$name is already running" >&2
      exit 0
    else
      if [ -n "$pre" ] && [ -f "$pre" ]; then
        cmd_exec="$pre $cmd $args"
        message="Starting service: $name $args through $pre"
      else
        cmd_exec="$cmd $args"
        message="Starting service: $name $args"
      fi
      echo "$message"
      su_cmd touch "$SERVICE_PID_FILE"
      __post_execute 2>"/dev/stderr" 2>&1 |& tee -a "$LOG_DIR/init.txt" &>/dev/null &
      if [ "$RESET_ENV" = "yes" ]; then
        su_cmd env -i HOME="$home" LC_CTYPE="$lc_type" PATH="$path" HOSTNAME="$sysname" USER="$user" ${CMD_ENV//,/ } sh -c "$cmd_exec" || return 10
      else
        eval "$cmd_exec" || return 10
      fi
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# username and password actions
__run_secure_function() {
  if [ -n "$user_name" ] || [ -n "$user_pass" ]; then
    for filesperms in "${USER_FILE_PREFIX}"/*; do
      if [ -e "$filesperms" ]; then
        chmod -Rf 600 "$filesperms"
        chown -Rf root:root "$filesperms"
      fi
    done |& tee -a "$LOG_DIR/init.txt" &>/dev/null
  fi
  if [ -n "$root_user_name" ] || [ -n "$root_user_pass" ]; then
    for filesperms in "${ROOT_FILE_PREFIX}"/*; do
      if [ -e "$filesperms" ]; then
        chmod -Rf 600 "$filesperms"
        chown -Rf root:root "$filesperms"
      fi
    done |& tee -a "$LOG_DIR/init.txt" &>/dev/null
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# simple cd function
__cd() { mkdir -p "$1" && builtin cd "$1" || exit 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# process check functions
__pcheck() { [ -n "$(type -P pgrep 2>/dev/null)" ] && pgrep -x "$1" &>/dev/null && return 0 || return 10; }
__pgrep() { __pcheck "${1:-$EXEC_CMD_BIN}" || __ps aux 2>/dev/null | grep -Fw " ${1:-$EXEC_CMD_BIN}" | grep -qv ' grep' | grep '^' && return 0 || return 10; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check if process is already running
__proc_check() {
  cmd_bin="$(type -P "${1:-$EXEC_CMD_BIN}")"
  cmd_name="$(basename "${cmd_bin:-$EXEC_CMD_NAME}")"
  if __pgrep "$cmd_bin" || __pgrep "$cmd_name"; then
    SERVICE_IS_RUNNING="true"
    touch "$SERVICE_PID_FILE"
    echo "$cmd_name is already running"
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Allow ENV_ variable - Import env file
__file_exists_with_content"/config/env/${SERVICE_NAME:-$SCRIPT_NAME}.sh" && . "/config/env/${SERVICE_NAME:-$SCRIPT_NAME}.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SERVICE_EXIT_CODE=0                                           # default exit code
WORK_DIR="${ENV_WORKDIR:-$WORK_DIR}"                          # change to directory
WWW_DIR="${ENV_WWW_DIR:-$WWW_DIR}"                            # set default web dir
ETC_DIR="${ENV_ETC_DIR:-$ETC_DIR}"                            # set default etc dir
DATA_DIR="${ENV_DATA_DIR:-$DATA_DIR}"                         # set default data dir
CONF_DIR="${ENV_CONF_DIR:-$CONF_DIR}"                         # set default config dir
DATABASE_DIR="${ENV_DATABASE_DIR:-$DATABASE_DIR}"             # set database dir
SERVICE_USER="${ENV_SERVICE_USER:-$SERVICE_USER}"             # execute command as another user
SERVICE_UID="${ENV_SERVICE_UID:-$SERVICE_UID}"                # set the user id
SERVICE_PORT="${ENV_SERVICE_PORT:-$SERVICE_PORT}"             # port which service is listening on
PRE_EXEC_MESSAGE="${ENV_PRE_EXEC_MESSAGE:-$PRE_EXEC_MESSAGE}" # Show message before execute
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# application specific
EXEC_PRE_SCRIPT="${ENV_EXEC_PRE_SCRIPT:-$EXEC_PRE_SCRIPT}"                 # Pre
EXEC_CMD_BIN="${ENV_EXEC_CMD_BIN:-$EXEC_CMD_BIN}"                          # command to execute
EXEC_CMD_NAME="$(basename "$EXEC_CMD_BIN")"                                # set the binary name
SERVICE_PID_FILE="/run/init.d/$EXEC_CMD_NAME.pid"                          # set the pid file location
EXEC_CMD_ARGS="${ENV_EXEC_CMD_ARGS:-$EXEC_CMD_ARGS}"                       # command arguments
SERVICE_PID_NUMBER="$(__pgrep)"                                            # check if running
EXEC_CMD_BIN="$(type -P "$EXEC_CMD_BIN" || echo "$EXEC_CMD_BIN")"          # set full path
EXEC_PRE_SCRIPT="$(type -P "$EXEC_PRE_SCRIPT" || echo "$EXEC_PRE_SCRIPT")" # set full path
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create auth directories
[ -n "$USER_FILE_PREFIX" ] && { [ -d "$USER_FILE_PREFIX" ] || mkdir -p "$USER_FILE_PREFIX"; }
[ -n "$ROOT_FILE_PREFIX" ] && { [ -d "$ROOT_FILE_PREFIX" ] || mkdir -p "$ROOT_FILE_PREFIX"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$IS_WEB_SERVER" = "yes" ] && RESET_ENV="yes"
[ "$IS_DATABASE_SERVICE" = "yes" ] && RESET_ENV="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Allow per init script usernames and passwords
__file_exists_with_content "$ETC_DIR/auth/user/name" && user_name="$(<"$ETC_DIR/auth/user/name")"
__file_exists_with_content "$ETC_DIR/auth/user/pass" && user_pass="$(<"$ETC_DIR/auth/user/pass")"
__file_exists_with_content "$ETC_DIR/auth/root/name" && root_user_name="$(<"$ETC_DIR/auth/root/name")"
__file_exists_with_content "$ETC_DIR/auth/root/pass" && root_user_pass="$(<"$ETC_DIR/auth/root/pass")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Allow setting initial users and passwords via environment
user_name="${user_name:-$ENV_USER_NAME}"
user_pass="${user_pass:-$ENV_USER_PASS}"
root_user_name="${root_user_name:-$ENV_ROOT_USER_NAME}"
root_user_pass="${root_user_pass:-$ENV_ROOT_USER_PASS}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set password to random if variable is random
if [ "$user_pass" = "random" ]; then
  user_pass="$(__random_password)"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$root_user_pass" = "random" ]; then
  root_user_pass="$(__random_password)"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Allow variables via imports - Overwrite existing
[ -f "/config/env/${SERVICE_NAME:-$SCRIPT_NAME}.sh" ] && . "/config/env/${SERVICE_NAME:-$SCRIPT_NAME}.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Only run check
if [ "$1" = "check" ]; then
  __proc_check "$EXEC_CMD_NAME" || __proc_check "$EXEC_CMD_BIN"
  exit $?
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# show message if env exists
if [ -n "$EXEC_CMD_BIN" ]; then
  [ -n "$SERVICE_USER" ] && echo "Setting up service to run as $SERVICE_USER" || SERVICE_USER="root"
  [ -n "$SERVICE_PORT" ] && echo "${EXEC_CMD_NAME:-$EXEC_CMD_BIN} will be running on $SERVICE_PORT" || SERVICE_PORT=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set switch user command
if [ "$SERVICE_USER" = "root" ] || [ -z "$SERVICE_USER" ]; then
  su_cmd() { eval "$@" || return 1; }
elif [ "$(builtin type -P gosu)" ]; then
  su_cmd() { gosu $SERVICE_USER "$@" || return 1; }
elif [ "$(builtin type -P runuser)" ]; then
  su_cmd() { runuser -u $SERVICE_USER "$@" || return 1; }
elif [ "$(builtin type -P sudo)" ]; then
  su_cmd() { sudo -u $SERVICE_USER "$@" || return 1; }
elif [ "$(builtin type -P su)" ]; then
  su_cmd() { su -s /bin/sh - $SERVICE_USER -c "$@" || return 1; }
else
  echo "Can not switch to $SERVICE_USER: attempting to run as root"
  su_cmd() { eval "$@" || return 1; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Change to working directory
[ -n "$WORK_DIR" ] && [ -n "$EXEC_CMD_BIN" ] && __cd "$WORK_DIR" && echo "Changed to $PWD"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# show init message
__pre_message
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initialize ssl
__update_ssl_conf
__update_ssl_certs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Updating config files
__create_service_env
__update_conf_files
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run the pre execute commands
[ -n "$PRE_EXEC_MESSAGE" ] && echo "$PRE_EXEC_MESSAGE"
__pre_execute
__run_secure_function
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_start_script "$@" |& tee -a "/data/logs/entrypoint.log" &>/dev/null
if [ "$?" -ne 0 ] && [ -n "$EXEC_CMD_BIN" ]; then
  echo "Failed to execute: $EXEC_CMD_BIN $EXEC_CMD_ARGS" |& tee -a "/data/logs/entrypoint.log" "$LOG_DIR/init.txt"
  SERVICE_EXIT_CODE=10
  SERVICE_IS_RUNNING="false"
  rm -Rf "$SERVICE_PID_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $SERVICE_EXIT_CODE
