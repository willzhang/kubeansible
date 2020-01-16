#!/bin/bash
KUBE_VERSION=1.17.0
DOCKER_VERSION=18.09.9-3

for centos_version in centos:7.5.1804 centos:7.6.1810 centos:7.7.1908
do
  docker run -t --rm -v ${PWD}/rpms:/rpms -v ${PWD}/yum-repo/kubernetes.repo:/etc/yum.repos.d/kubernetes.repo ${centos_version} \
  bash -c "
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&
  yum install -y yum-utils &&
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&
  mkdir -p /rpms/ &&
  yum remove -y python-chardet chrony &&
  yum -y install --downloadonly --downloaddir=/rpms docker-ce-${DOCKER_VERSION}.el7.x86_64 docker-ce-cli-${DOCKER_VERSION}.el7.x86_64 docker-python docker-compose python-chardet python-requests &&
  yum -y install --downloadonly --downloaddir=/rpms chrony audit rsync jq git tcpdump nc bind-utils net-tools ipvsadm graphviz &&
  yum -y install --downloadonly --downloaddir=/rpms kubernetes-cni kubectl-${KUBE_VERSION} kubelet-${KUBE_VERSION} kubeadm-${KUBE_VERSION}"
done

yum install -y createrepo
yum clean all
createrepo $PWD/rpms
