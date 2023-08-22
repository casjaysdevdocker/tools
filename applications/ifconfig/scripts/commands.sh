EXEC_CMD_BIN="echoip"                                            # command to execute
EXEC_CMD_ARGS="-t /opt/echoip/html -H x-forwarded-for -r -s -p " # command arguments
EXEC_CMD_ARGS+="-a /opt/echoip/geoip/GeoLite2-ASN.mmdb "         #
EXEC_CMD_ARGS+="-c /opt/echoip/geoip/GeoLite2-City.mmdb "        #
EXEC_CMD_ARGS+=" -f /opt/echoip/geoip/GeoLite2-Country.mmdb "    #

[ -d "/data/geoip" ] && cp -Rf "/data/geoip/." "/opt/echoip/geoip/"
[ -d "/data/htdocs/html" ] && cp -Rf "/data/htdocs/html/." "/opt/echoip/html/"
