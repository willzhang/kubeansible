#!/bin/bash

path=$(dirname $(readlink -f $0 ))
mkdir -p ${path}/packages/{bin,images,conf}
base_dir=${path}/packages
echo $base_dir

##########################################################
docker_version=19.03.8
kubernetes_version=1.17.4
haproxy_version=alpine
flannel_version=v0.11.0
calico_version=v3.13.1
ipcalc_version=0.41
##########################################################

function get_yum_repo(){
  centos_version=('centos:7.5.1804' 'centos:7.6.1810' 'centos:7.7.1908')
  for version in ${centos_version[@]}
  do
    docker run -t --rm -v ${PWD}/rpms:/rpms -v ${PWD}/scripts/yum-repo/kubernetes.repo:/etc/yum.repos.d/kubernetes.repo ${version}
    bash -c
    "yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&
    curl -sSL https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/ &&
    yumdownloader -y --resolve --destdir=/rpms/ docker-ce-${docker_version} chrony ipvsadm ipset &&
    yumdownloader -y --resolve --destdir=/rpms/ kubectl-${kubernetes_version} kubelet-${kubernetes_version} kubeadm-${kubernetes_version}"
  done
}

get_yum_repo

