SERVICE_PORT="2628"
EXEC_CMD_BIN="dictd"       # command to execute
EXEC_CMD_ARGS="-dnodetach" # command arguments

[ -f "/config/dict.conf" ] && cp -Rf "/config/dict.conf" "/etc/dictd/dict.conf" || cp -Rf "/etc/dictd/dict.conf" "/config/dict.conf"
[ -f "/config/dictd.conf" ] && cp -Rf "/config/dictd.conf" "/etc/dictd/dictd.conf" || cp -Rf "/etc/dictd/dictd.conf" "/config/dictd.conf"
