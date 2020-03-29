#!/bin/bash

path=`dirname $0`
mkdir -p ${path}/packages/{bin,images,files,conf}
base_dir=${path}/packages


harbor_version=v1.9.4
docker_compose_version=1.24.1
haproxy_version=alpine
etcd_version=3.4.3-0
kubernetes_version=1.17.0
flannel_version=v0.11.0
calico_version=v3.10.3
ipcalc_version=0.41

function get_harbor(){
  curl -L https://github.com/goharbor/harbor/releases/download/${harbor_version}/harbor-offline-installer-${harbor_version}.tgz \
  -o ${base_dir}/files/harbor-offline-installer-${harbor_version}.tgz
}

function get_docker_compose(){
  curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m) -o ${base_dir}/bin/docker-compose
}