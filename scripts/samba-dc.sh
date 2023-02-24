#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/samba/{config,data} &&
  chmod -Rf 777 /var/lib/docker/storage/samba

docker run -t -i \
  --restart always \
  -e "DOMAIN=CASJAY.NET" \
  -e "DOMAINPASS=80@Malak87" \
  -e "DNSFORWARDER=1.1.1.1" \
  -e "HOSTIP=10.0.0.250" \
  -p 10.0.0.250:53:53 \
  -p 10.0.0.250:53:53/udp \
  -p 10.0.0.250:88:88 \
  -p 10.0.0.250:88:88/udp \
  -p 10.0.0.250:135:135 \
  -p 10.0.0.250:137-138:137-138/udp \
  -p 10.0.0.250:139:139 \
  -p 10.0.0.250:389:389 \
  -p 10.0.0.250:389:389/udp \
  -p 10.0.0.250:445:445 \
  -p 10.0.0.250:464:464 \
  -p 10.0.0.250:464:464/udp \
  -p 10.0.0.250:636:636 \
  -p 10.0.0.250:1024-1044:1024-1044 \
  -p 10.0.0.250:3268-3269:3268-3269 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /var/lib/docker/storage/samba/data/:/var/lib/samba \
  -v /var/lib/docker/storage/samba/config/samba:/etc/samba/external \
  --dns-search casjay.net \
  --dns 10.0.0.250 \
  --dns 1.1.1.1 \
  --add-host dc.casjay.net:10.0.0.250 \
  -h localdc \
  --name samba \
  --privileged \
  nowsci/samba-domain
