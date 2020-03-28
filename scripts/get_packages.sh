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


function get_loadbalancer(){
  docker pull haproxy:${haproxy_version}
  docker save haproxy:${haproxy_version} -o ${base_dir}/images/haproxy-${haproxy_version}.tar
  bzip2 -z --best ${base_dir}/images/haproxy-${haproxy_version}.tar
}


function get_etcd(){
  image=k8s.gcr.io/etcd-amd64:${etcd_version}
  docker pull ${image}
  docker save ${image} > ${base_dir}/images/etcd.tar
  bzip2 -z --best ${base_dir}/images/etcd.tar
}


function get_cfssl(){
  export CFSSL_URL=https://pkg.cfssl.org/R1.2
  curl -L ${CFSSL_URL}/cfssl_linux-amd64 -o ${base_dir}/bin/cfssl
  curl -L ${CFSSL_URL}/cfssljson_linux-amd64 -o ${base_dir}/bin/cfssljson
  curl -L ${CFSSL_URL}/cfssl-certinfo_linux-amd64 -o ${base_dir}/bin/cfssl-certinfo
  chmod +x ${base_dir}/bin/cfssl*
}


function get_kubernetes(){
  docker run --rm --name=kubeadm-version wise2c/kubeadm-version:v${kubernetes_version} \
  kubeadm config images list --kubernetes-version ${kubernetes_version} > ${path}/k8s-images-list.txt
  for IMAGES in $(cat ${path}/k8s-images-list.txt |grep -v etcd); do
    docker pull ${IMAGES}
  done
  docker save $(cat ${path}/k8s-images-list.txt |grep -v etcd) -o ${base_dir}/images/k8s.tar
  bzip2 -z --best ${base_dir}/images/k8s.tar
}


function get_flannel(){
  curl -o ${base_dir}/conf/kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  docker save $(cat ${base_dir}/conf/kube-flannel.yml | grep "image:" | grep amd64 | awk '{print $2}') | bzip2 -z --best > ${base_dir}/images/kube-flannel.tar.bz2
}

function get_calico(){
  curl -o ${base_dir}/conf/calico.yaml https://docs.projectcalico.org/${calico_version}/manifests/calico.yaml
  docker save $(cat ${base_dir}/conf/calico.yaml | grep "image:" | awk '{print $2}') | bzip2 -z --best > ${base_dir}/images/calico.tar.bz2
}


function get_ipcalc(){
  curl -L http://jodies.de/ipcalc-archive/ipcalc-${ipcalc_version}.tar.gz -o ${base_dir}/files/ipcalc-${ipcalc_version}.tar.gz
}

get_harbor
get_docker_compose
get_loadbalancer
get_etcd
get_cfssl
get_kubernetes
get_flannel
get_calico
get_ipcalc
