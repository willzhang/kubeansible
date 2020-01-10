#!/bin/bash
docker rm -f kubeansible
docker run -d --name kubeansible \
  --restart always \
  -v /data/git:/data \
  cytopia/ansible:latest-tools \
  sleep 10000000000000000000
