FROM git.lcomrade.su/root/lenpaste:latest AS build

ARG ALPINE_VERSION=edge

[ -f "/entrypoint.sh" ] && rm -Rf "/entrypoint.sh"
[ -d "$DEFAULT_CONF_DIR/html" ] || mkdir -p "$DEFAULT_CONF_DIR/html"
[ -f "$DEFAULT_CONF_DIR/html/about" ] || touch "$DEFAULT_CONF_DIR/html/about"
[ -f "$DEFAULT_CONF_DIR/html/rules" ] || touch "$DEFAULT_CONF_DIR/html/rules"
[ -f "$DEFAULT_CONF_DIR/html/terms" ] || touch "$DEFAULT_CONF_DIR/html/terms"
