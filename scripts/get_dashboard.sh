#! /bin/bash

set -e

path=`dirname $0`

PKG_PATH=${path}/packages/dashboard

dashboard_repo=kubernetesui
kubernetes_repo=`cat ${path}/k8s-images-list.txt |grep kube-apiserver |awk -F '/' '{print $1}'`
metrics_server_repo=${kubernetes_repo}

echo "=== pulling kubernetes dashboard and metrics-server images ==="
docker pull ${dashboard_repo}/dashboard:${dashboard_version}
docker pull ${dashboard_repo}/metrics-scraper:${metrics_scraper_version}
docker pull ${metrics_server_repo}/metrics-server-amd64:${metrics_server_version}
echo "=== kubernetes dashboard and metrics-server images are pulled successfully ==="

echo "=== saving kubernetes dashboard images ==="
docker save ${dashboard_repo}/dashboard:${dashboard_version} -o ${PKG_PATH}/dashboard.tar
docker save ${dashboard_repo}/metrics-scraper:${metrics_scraper_version} -o ${PKG_PATH}/metrics-scraper.tar
docker save ${metrics_server_repo}/metrics-server-amd64:${metrics_server_version} -o ${PKG_PATH}/metrics-server.tar
rm -f ${PKG_PATH}/dashboard.tar.bz2
rm -f ${PKG_PATH}/metrics-scraper.tar.bz2
rm -f ${PKG_PATH}/metrics-server.tar.bz2
bzip2 -z --best ${PKG_PATH}/dashboard.tar
bzip2 -z --best ${PKG_PATH}/metrics-scraper.tar
bzip2 -z --best ${PKG_PATH}/metrics-server.tar

echo "=== kubernetes dashboard and metrics-server images are saved successfully ==="
