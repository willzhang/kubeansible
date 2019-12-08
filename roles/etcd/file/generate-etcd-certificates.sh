#!/bin/bash
set -e

# Check if there are no cert files under /etc/etcd/pki
certificate_path='/etc/etcd/pki'
DPATH=/var/lib/kubeansible/etcd/
if [ -f ${certificate_path}/ca.pem ] || [ -f ${certificate_path}/ca-key.pem ] || [ -f ${certificate_path}/etcd.pem ] || [ -f ${certificate_path}/etcd-key.pem ]; then
  echo 'Existing etcd certificate files will not be replaced.'
else
  # ETCD CA
  cd ${DPATH}
  cfssl gencert -initca ca-csr.json | cfssljson -bare ca
  # ETCD certificate
  cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=127.0.0.1,{% for host in play_hosts %}{{ host }}{% if not loop.last %},{% endif %}{% endfor %} -profile=etcd etcd-csr.json | cfssljson -bare etcd
  cd ${DPATH}
  cp *.pem /etc/etcd/pki/
fi
