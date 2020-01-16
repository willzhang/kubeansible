#! /bin/bash

set -e

path=`dirname $0`

PKG_PATH=${path}/packages

echo "=== download helm binary package ==="
rm ${PKG_PATH}/helm-linux-amd64.tar.gz -f
curl -o ${PKG_PATH}/helm-linux-amd64.tar.gz https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz
echo "=== helm binary package is saved successfully ==="
