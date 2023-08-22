__rndc_key() { grep -s 'key "rndc-key" ' "$ETC_DIR/rndc.key" | grep -v 'KEY_RNDC' | sed 's|.*secret ||g;s|"||g;s|;.*||g' | grep '^' || return 1; }
__tsig_key() { tsig-keygen -a hmac-sha256 | grep 'secret' | sed 's|.*secret "||g;s|"||g;s|;||g' | grep '^' || echo 'wp/HApbthaVPjwqgp6ziLlmnkyLSNbRTehkdARBDcpI='; }

EXEC_CMD_BIN="named"                      # command to execute
EXEC_CMD_ARGS="-f -c $ETC_DIR/named.conf" # command arguments

VAR_DIR="/var/bind"
KEY_RNDC="${KEY_RNDC:-$(__tsig_key)}"
KEY_DHCP="${KEY_DHCP:-$(__tsig_key)}"
KEY_BACKUP="${KEY_BACKUP:-$(__tsig_key)}"
KEY_CERTBOT="${KEY_CERTBOT:-$(__tsig_key)}"

local zone_files=""
local serial="$(date +'%Y%m%d%S')"
local HOSTNAME="${SERVER_NAME:-$HOSTNAME}"
local ip_address="${CONTAINER_IP4_ADDRESS:-127.0.0.1}"
[ -f "$CONF_DIR/set_rndc.key" ] && GET_RNDC_KEY="$(<"$CONF_DIR/set_rndc.key")"

__replace "REPLACE_KEY_DHCP" "$KEY_DHCP" "$ETC_DIR/named.conf"                  #&>/dev/null
__replace "REPLACE_KEY_BACKUP" "$KEY_BACKUP" "$ETC_DIR/named.conf"              #&>/dev/null
__replace "REPLACE_KEY_CERTBOT" "$KEY_CERTBOT" "$ETC_DIR/named.conf"            #&>/dev/null
__replace "REPLACE_KEY_RNDC" "${GET_RNDC_KEY:-$KEY_RNDC}" "$ETC_DIR/rndc.key"   #&>/dev/null
__replace "REPLACE_KEY_RNDC" "${GET_RNDC_KEY:-$KEY_RNDC}" "$ETC_DIR/named.conf" #&>/dev/null

[ -f "$ETC_DIR/custom.conf" ] && mv -f "$ETC_DIR/custom.conf" "$ETC_DIR/named.conf"

GET_RNDC_KEY="${GET_RNDC_KEY:-$(__rndc_key || echo '')}"
if [ -n "$GET_RNDC_KEY" ]; then
  echo "$GET_RNDC_KEY" >"$CONF_DIR/set_rndc.key"
fi

zone_files="$(find "$DATA_DIR/zones/" -type f | wc -l)"
if [ $zone_files = 0 ] && [ ! -f "$DATA_DIR/zones/$HOSTNAME.zone" ]; then
  cat <<EOF | tee "$DATA_DIR/zones/$HOSTNAME.zone" &>/dev/null
; config for $HOSTNAME
@                         IN  SOA     $HOSTNAME. root.$HOSTNAME. ( $serial 10800 3600 1209600 38400)
                          IN  NS      $HOSTNAME.
$HOSTNAME.                IN  A       $ip_address

EOF
fi
#
for dns_file in "$DATA_DIR/zones"/*; do
  file_name="$(basename "$dns_file")"
  domain_name="$(grep -Rs '\$ORIGIN' "$dns_file" | awk '{print $NF}' | sed 's|.$||g')"
  if [ -f "$dns_file" ]; then
    cp -Rf "$dns_file" "$VAR_DIR/zones/$file_name"
    if [ -n "$domain_name" ] && ! grep -qs "$domain_name" "$ETC_DIR/named.conf"; then
      cat <<EOF >>"$ETC_DIR/named.conf"
#  ********** begin $domain_name **********
zone "$domain_name" {
    type master;
    file "$VAR_DIR/zones/$file_name";
    notify yes;
    allow-update {key "certbot."; key "dhcp-key"; trusted;};
    allow-transfer { any; key "backup-key"; };
};
#  ********** end $domain_name **********

EOF
      grep -qs "$domain_name" "$ETC_DIR/named.conf" && echo "Added $domain_name to $ETC_DIR/named.conf"
    fi
  fi
done
if named-checkconf -z "$ETC_DIR/named.conf" &>/dev/null; then
  echo "named-checkconf has succeeded"
else
  echo "named-checkconf has failed:"
  named-checkconf -z "$ETC_DIR/named.conf"
fi
