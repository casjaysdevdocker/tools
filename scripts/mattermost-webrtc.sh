#!/usr/bin/env bash
docker run -d \
  --name mattermost-webrtc \
  --restart=always \
  -p 7088:7088 \
  -p 7089:7089 \
  -p 8188:8188 \
  -p 8189:8189 \
  mattermost/webrtc:latest
