#!/usr/bin/env bash
mkdir -p /var/lib/docker/storage/hass &&
  chmod -Rf 777 /var/lib/docker/storage/hass

docker run -d --name home-assistant \
  --restart=always \
  --net=host --privileged -itd \
  -v /var/lib/docker/storage/hass:/config \
  -v /dev/bus/usb:/dev/bus/usb \
  -v /var/run/dbus:/var/run/dbus \
  -v /dev:/dev \
  -e variable=TZ -e value=America/New_York \
  --device /dev/ttyACM0 \
  --cap-add=SYS_ADMIN \
  --cap-add=NET_ADMIN \
  registry.casjay.in/latest/home-assistant:latest
