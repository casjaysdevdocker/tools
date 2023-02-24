#!/usr/bin/env bash
docker run -d --name centos7 \
  -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --restart always \
  --privileged \
  --entrypoint=/usr/sbin/init \
  registry.casjay.in/latest/centos:centos7
