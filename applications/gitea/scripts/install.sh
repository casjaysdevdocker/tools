ARG GITEA_VERSION="current"

mkdir -p "/etc/gitea" "/etc/docker"
cp -Rf "/tmp/etc/gitea/app.ini" "/etc/gitea/"
touch "/etc/docker/daemon.json"
GITEA_VERSION="${GITEA_VERSION}" bash "/tmp/setup_gitea.sh"
