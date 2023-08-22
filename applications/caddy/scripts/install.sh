version=$(curl -q -LSsf "https://api.github.com/repos/caddyserver/caddy/releases/latest" | grep .tag_name | sed 's|.*: ||g;s|"||g;s|,||g')
export version XCADDY_SETCAP=1 GO111MODULE=auto
echo ">>>>>>>>>>>>>>> ${version} ###############"
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest || exit 10
xcaddy build ${version} \
  --output /usr/local/bin/caddy \
  --with github.com/caddy-dns/rfc2136 \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/caddyserver/nginx-adapter \
  --with github.com/hairyhenderson/caddy-teapot-module
