#!/usr/bin/env bash
#shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202211211129-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.com
# @@License          :  LICENSE.md
# @@ReadME           :  dockerfile.sh --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Monday, Nov 21, 2022 11:29 EST
# @@File             :  dockerfile.sh
# @@Description      :  Update docker scripts
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="202211211129-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SRC_DIR="${BASH_SOURCE%/*}"
export PATH="$HOME/Projects/github/casjay-dotfiles/scripts/bin:$PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'exitCode=${exitCode:-$?};[ -n "$DOCKERFILE_SH_TEMP_FILE" ] && [ -f "$DOCKERFILE_SH_TEMP_FILE" ] && rm -Rf "$DOCKERFILE_SH_TEMP_FILE" &>/dev/null' EXIT
[ "$1" = "--debug" ] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "$1" = "--raw" ] && export SHOW_RAW="true"
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__rm() { [ -e "$1" ] && rm -Rf "$1" 2>/dev/null || return 1; }
__mv() { [ -e "$1" ] && mv -f "$1" "$2" 2>/dev/null || return 1; }
__cp() { [ -e "$1" ] && cp -Rf "$1" "$2" 2>/dev/null || return 1; }
__rmw() { [ -d "$1" ] && rm -Rf "${1:?}"/* 2>/dev/null || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
while :; do
  case "$1" in
  --no-copy) RECREATE="no" && shift 1 ;;
  --template) template="$2" && shift 2 ;;
  --editor) OPEN_EDITOR="$2" && shift 2 ;;
  --dirs) REPO_DIRS="${2//,/ }" && shift 2 ;;
  --command) CREATE_CMD="gen-docker$2" && shift 2 ;;
  --debug) export _DEBUG="on" && set -x && shift 1 ;;
  *) break ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export TEMPLATE="${template:-alpine}"
export OPEN_EDITOR="${OPEN_EDITOR:-yes}"
CREATE_CMD="${CREATE_CMD:-gen-dockerfile}"
DATE="$(date +'%Y%m%d%H%M')"
SET_DIR="$PWD"
exitCode=0
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ $# -eq 0 ]; then
  REPO_DIRS="$(ls -A "$DOCKER_GIT_DIR")"
else
  REPO_DIRS="${*:-$REPO_DIRS}"
  echo "Setting REPO_DIRS to $REPO_DIRS"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Setting generator to $CREATE_CMD"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$CREATE_CMD" = "gen-dockerfile" ] || [ "$CREATE_CMD" = "file" ]; then
  DOCKER_GIT_DIR="$HOME/Projects/github/casjaysdevdocker"
  DOCKER_DEV_DIR="$HOME/.local/share/cdd/projects/containers"
  mkdir -p "$DOCKER_GIT_DIR"
  mkdir -p "$DOCKER_DEV_DIR"
  for d in $REPO_DIRS; do
    d=$(basename "$d")
    builtin cd "$DOCKER_GIT_DIR" || exit 1
    DIR_NEW="$(realpath "$DOCKER_DEV_DIR/$d" 2>/dev/null)"
    DIR_OLD="$(realpath "$DOCKER_GIT_DIR/$d" 2>/dev/null)"
    if [ ! -d "$DIR_NEW" ]; then
      if [ -d "$DIR_OLD" ]; then
        echo "Backing up $DIR_OLD to $DIR_OLD.$$"
        backupapp --once "$d" "$DIR_OLD" &>/dev/null
        __cp "$DIR_OLD" "$DIR_OLD.$$"
      fi
      mkdir -p "$DIR_NEW" "$DIR_OLD"
      mkdir -p "$DIR_NEW/rootfs/usr/local/share/template-files/data"
      mkdir -p "$DIR_NEW/rootfs/usr/local/share/template-files/config"
      gitignore "$DIR_NEW" dirignore,default --automated
      eval $CREATE_CMD --nogit --dir "$DIR_NEW" --template $TEMPLATE
      sCode=$?
      if [ -f "$DIR_OLD/Dockerfile" ] && [ -f "$DIR_NEW/Dockerfile.bak" ]; then
        echo "Moving Dockerfile to Docker.bak"
        __mv "$DIR_OLD/Dockerfile.bak" "$DIR_NEW/Dockerfile.$DATE.bak"
        __mv "$DIR_OLD/Dockerfile" "$DIR_NEW/Dockerfile.bak"
      elif [ -f "$DIR_OLD/Dockerfile" ]; then
        echo "Moving Dockerfile to Docker.bak"
        __mv "$DIR_OLD/Dockerfile" "$DIR_NEW/Dockerfile.bak"
      fi
      if [ -d "$DIR_OLD/rootfs.bak" ]; then
        __mv "$DIR_OLD/rootfs.bak" "$DIR_NEW/rootfs.$DATE.bak"
      fi
      if [ -d "$DIR_OLD/rootfs" ] && [ ! -d "$DIR_OLD/rootfs.bak" ]; then
        echo "Moving rootfs to rootfs.bak"
        __mv "$DIR_OLD/rootfs" "$DIR_NEW/rootfs.bak"
      fi
      if [ $sCode -eq 0 ]; then
        for otherDockerfile in "$DIR_OLD/Dockerfile"*; do
          if [ -f "$otherDockerfile" ]; then
            dockerFile_name="$(basename "$otherDockerfile")"
            echo "Moving $dockerFile_name to $dockerFile_name.bak"
            __cp "$otherDockerfile" "$DIR_NEW/$dockerFile_name.bak"
          fi
        done
        if [ -d "$DIR_OLD/data" ]; then
          echo "Moving data too rootfs/data"
          __cp "$DIR_OLD/data/." "$DIR_NEW/rootfs/usr/local/share/template-files/data/"
          __rm "$DIR_OLD/data"
        fi
        if [ -d "$DIR_OLD/config" ]; then
          echo "Moving config too rootfs/config"
          __cp "$DIR_OLD/config/." "$DIR_NEW/rootfs/usr/local/share/template-files/config/"
          __rm "$DIR_OLD/config"
        fi
        if [ -d "$DIR_NEW/rootfs.bak/usr/local/share/template-files" ]; then
          echo "Moving template files"
          __cp "$DIR_NEW/rootfs.bak/usr/local/share/template-files/." "$DIR_NEW/rootfs/usr/local/share/template-files/"
        fi
        [ -f "$DIR_NEW/Dockerfile" ] || { echo "Failed to init $DIR_NEW" && exit 2; }
        [ -d "$DIR_OLD/.git" ] && echo "Moving the git directory" && __cp "$DIR_OLD/.git" "$DIR_NEW/.git"
        builtin cd "$DIR_NEW" || exit 1
        if [ "$OPEN_EDITOR" = "yes" ] && [ $sCode -eq 0 ]; then
          code -nw "$DIR_NEW" && true && sleep 3 || false
          sCode="$?"
        fi
        [ -d "$DIR_OLD" ] && __rmw "$DIR_OLD"
        if [ $sCode -eq 0 ] && [ "$RECREATE" != "no" ]; then
          mkdir -p "$DIR_OLD" && __cp "$DIR_NEW/." "$DIR_OLD/" && __rm "$DIR_NEW"
          if [ "$OPEN_EDITOR" = "yes" ] && cd "$DIR_OLD" && [ -d "$DIR_OLD/.git" ]; then
            gitcommit "$DIR_OLD" all || exit 1
            gitcommit "$DIR_OLD" all || exit 1
          fi
        fi
      else
        echo 'Something went wrong'
        exitCode=$((1 + exitCode))
      fi
      sleep 3
    else
      echo "The dir exists: $DIR_NEW"
    fi
    printf '%\s\n\n' "# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  done
  exit $exitCode
elif [ "$CREATE_CMD" = "gen-dockermgr" ] || [ "$CREATE_CMD" = "mgr" ]; then
  DOCKER_GIT_DIR="$HOME/Projects/github/dockermgr"
  DOCKER_DEV_DIR="$HOME/.local/share/cdd/projects/dockermgr"
  mkdir -p "$DOCKER_DEV_DIR"
  for d in $REPO_DIRS; do
    d=$(basename "$d")
    builtin cd "$DOCKER_GIT_DIR" || exit 1
    DIR_NEW="$(realpath "$DOCKER_DEV_DIR/$d" 2>/dev/null)"
    DIR_OLD="$(realpath "$DOCKER_GIT_DIR/$d" 2>/dev/null)"
    if [ ! -d "$DIR_NEW" ]; then
      if [ -d "$DIR_OLD" ]; then
        backupapp --once "$d" "$DIR_OLD" &>/dev/null
        __cp "$DIR_OLD" "$DIR_OLD.$$"
      fi
      mkdir -p "$DIR_NEW" "$DIR_OLD" "$DIR_NEW/rootfs/data" "$DIR_NEW/rootfs/config"
      if [ -f "$DIR_OLD/install.sh" ] && [ -f "$DIR_OLD/install.sh.bak" ]; then
        echo "Moving install.sh to install.sh.bak"
        __mv "$DIR_OLD/install.sh.bak" "$DIR_NEW/install.$DATE.bak"
        __mv "$DIR_OLD/install.sh" "$DIR_NEW/install.sh.bak"
      elif [ -f "$DIR_OLD/install.sh" ]; then
        echo "Moving install.sh to install.sh.bak"
        __cp "$DIR_OLD/install.sh" "$DIR_NEW/install.sh.bak"
      fi
      if [ -d "$DIR_OLD/rootfs.bak" ]; then
        echo "Moving rootfs.bak to rootfs.$DATE.bak"
        __mv "$DIR_OLD/rootfs.bak" "$DIR_NEW/rootfs.$DATE.bak"
      fi
      if [ -d "$DIR_OLD/rootfs" ] && [ ! -d "$DIR_OLD/rootfs.bak" ]; then
        echo "Moving rootfs to rootfs.bak"
        __mv "$DIR_OLD/rootfs" "$DIR_NEW/rootfs.bak"
      fi
      gitignore "$DIR_NEW" dirignore,default --automated
      eval $CREATE_CMD --nogit --dir "$DIR_NEW"
      sCode=$?
      if [ -d "$DIR_NEW/rootfs.bak" ]; then
        echo "Moving rootfs to rootfs.bak"
        __cp "$DIR_NEW/rootfs.bak/." "$DIR_NEW/rootfs/"
      fi
      if [ -d "$DIR_OLD/dataDir" ]; then
        echo "Moving dataDir to rootfs"
        __cp "$DIR_OLD/dataDir/." "$DIR_NEW/rootfs/"
        [ $sCode -eq 0 ] && __rm "$DIR_OLD/dataDir"
      fi
      [ -f "$DIR_NEW/install.sh" ] || { echo "Failed to init $DIR_NEW" && exit 2; }
      [ -d "$DIR_OLD/.git" ] && echo "Moving the git directory" && __cp "$DIR_OLD/.git" "$DIR_NEW/.git"
      builtin cd "$DIR_NEW" || exit 1
      if [ "$OPEN_EDITOR" = "yes" ] && [ $sCode -eq 0 ]; then
        code -nw "$DIR_NEW" && true && sleep 3 || false
        sCode="$?"
      fi
      [ -d "$DIR_OLD" ] && __rmw "$DIR_OLD/"
      if [ $sCode -eq 0 ] && [ "$RECREATE" != "no" ]; then
        __cp "$DIR_NEW/." "$DIR_OLD/" && __rm "$DIR_NEW"
        if [ "$OPEN_EDITOR" = "yes" ] && cd "$DIR_OLD" && [ -d "$DIR_OLD/.git" ]; then
          gitcommit "$DIR_OLD" all || exit 1
          gitcommit "$DIR_OLD" all || exit 1
        fi
      else
        echo 'Something went wrong'
        exitCode=$((1 + exitCode))
      fi
      sleep 3
    else
      echo "The dir exists: $DIR_NEW"
    fi
    printf '%\s\n\n' "# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  done
elif [ "$CREATE_CMD" = "gen-dockerboth" ] || [ "$CREATE_CMD" = "gen-dockerall" ]; then
  [ "$DOCKERFILE_RUN_BOTH" = "true" ] && exit 1
  export DOCKERFILE_RUN_BOTH="true"
  CREATE_CMD="" $0 --dirs "$REPO_DIRS" --command mgr $SET_DIR
  CREATE_CMD="" $0 --dirs "$REPO_DIRS" --command file $SET_DIR
else
  echo "Please choose an option: [mgr/file/both]"
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
