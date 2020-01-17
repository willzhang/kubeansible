#!/bin/bash
docker run -d --name kubeansible \
  --restart always \
  -p 2009:2009 \
  -v kubeansible:/data \
  willdockerhub/kubeansible:v1.17.0
