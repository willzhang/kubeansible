#!/bin/bash

path=`dirname $0`
mkdir -p ${path}/packages/{bin,images,conf}
base_dir=${path}/packages

##########################################################
docker_version=19.03.8
kubernetes_version=1.17.0
haproxy_version=alpine
flannel_version=v0.11.0
calico_version=v3.10.3
ipcalc_version=0.41
##########################################################

function get_loadbalancer(){
  docker pull haproxy:${haproxy_version}
  docker save haproxy:${haproxy_version} | bzip2 -z --best > ${base_dir}/images/haproxy.tar.bz2
}

function get_kubernetes(){
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v${kubernetes_version}/bin/linux/amd64/kubeadm
  chmod +x kubeadm
  ./kubeadm config images pull --kubernetes-version ${kubernetes_version}
  docker save $(./kubeadm config images list --kubernetes-version ${kubernetes_version} | grep -v etcd) | bzip2 -z --best > ${base_dir}/images/k8s.tar.bz2
  docker save $(./kubeadm config images list --kubernetes-version ${kubernetes_version} | grep etcd) | bzip2 -z --best > ${base_dir}/images/etcd.tar.bz2
}

function get_flannel(){
  curl -o ${base_dir}/conf/kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  docker save $(cat ${base_dir}/conf/kube-flannel.yml | grep "image:" | grep amd64 | awk '{print $2}') | bzip2 -z --best > ${base_dir}/images/kube-flannel.tar.bz2
}

function get_calico(){
  curl -o ${base_dir}/conf/calico.yaml https://docs.projectcalico.org/${calico_version}/manifests/calico.yaml
  docker save $(cat ${base_dir}/conf/calico.yaml | grep "image:" | awk '{print $2}') | bzip2 -z --best > ${base_dir}/images/calico.tar.bz2
}

function get_cfssl_tool(){
  export CFSSL_URL=https://pkg.cfssl.org/R1.2
  curl -L ${CFSSL_URL}/cfssl_linux-amd64 -o ${base_dir}/bin/cfssl
  curl -L ${CFSSL_URL}/cfssljson_linux-amd64 -o ${base_dir}/bin/cfssljson
  curl -L ${CFSSL_URL}/cfssl-certinfo_linux-amd64 -o ${base_dir}/bin/cfssl-certinfo
}

function get_ipcalc(){
  curl -L http://jodies.de/ipcalc-archive/ipcalc-${ipcalc_version}.tar.gz -o ${base_dir}/images/ipcalc-${ipcalc_version}.tar.gz
}

function get_yum_repo(){
  centos_version=('centos:7.5.1804' 'centos:7.6.1810' 'centos:7.7.1908')
  for version in ${centos_version[@]}
  do
    docker run -t --rm -v ${PWD}/rpms:/rpms -v ${PWD}/scripts/yum-repo/kubernetes.repo:/etc/yum.repos.d/kubernetes.repo ${version} \
    bash -c "
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&
    curl -sSL https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/ &&
    yumdownloader -y --resolve --destdir=/rpms/ docker-ce-${docker_version} chrony ipvsadm ipset &&
    yumdownloader -y --resolve --destdir=/rpms/ kubectl-${kubernetes_version} kubelet-${kubernetes_version} kubeadm-${kubernetes_version} &&
    if version=${centos_version[-1]}; then yum install -y createrepo && createrepo /rpms"
  done
}

get_loadbalancer
get_kubernetes
get_flannel
get_calico
get_yum_repo
get_cfssl_tool
get_ipcalc
