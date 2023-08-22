mkdir -p "/config/registry" "/data/registry"
[ -d "/etc/docker-registry" ] && rm -Rf "/etc/docker-registry"/*
ln -sf "/config/registry" "/etc/docker-registry"
ln -sf "$(type -P docker-registry)" "/usr/bin/registry"
