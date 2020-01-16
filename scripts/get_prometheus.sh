#! /bin/bash

set -e

path=`dirname $0`
PKG_PATH=${path}/packages/prometheus

curl -L -o ${PKG_PATH}/kube-prometheus-v$kube_prometheus_version-origin.tar.gz https://github.com/coreos/kube-prometheus/archive/v$kube_prometheus_version.tar.gz

cd ${PKG_PATH}
tar zxf kube-prometheus-v$kube_prometheus_version-origin.tar.gz

# Fix issue 2291 of prometheus operator
sed -i "s/0.29.0/$PrometheusOperatorVersion/g" kube-prometheus-$kube_prometheus_version/manifests/0prometheus-operator-deployment.yaml

for file in $(grep -lr "quay.io/coreos" kube-prometheus-$kube_prometheus_version/manifests/); do cat $file |grep "quay.io/coreos" ; done > image-lists-temp.txt
for file in $(grep -lr "grafana/grafana" kube-prometheus-$kube_prometheus_version/manifests/); do cat $file |grep "grafana/grafana" ; done >> image-lists-temp.txt
for file in $(grep -lr "quay.io/prometheus" kube-prometheus-$kube_prometheus_version/manifests/); do cat $file |grep "quay.io/prometheus" ; done >> image-lists-temp.txt
for file in $(grep -lr "gcr.io/" kube-prometheus-$kube_prometheus_version/manifests/); do cat $file |grep "gcr.io/" ; done >> image-lists-temp.txt

prometheus_base_image=`cat kube-prometheus-$kube_prometheus_version/manifests/prometheus-prometheus.yaml |grep "baseImage: " |awk '{print $2}'`
prometheus_image_tag=`cat kube-prometheus-$kube_prometheus_version/manifests/prometheus-prometheus.yaml |grep "version: " |awk '{print $2}'`

alertmanager_base_image=`cat kube-prometheus-$kube_prometheus_version/manifests/alertmanager-alertmanager.yaml |grep "baseImage: " |awk '{print $2}'`
alertmanager_image_tag=`cat kube-prometheus-$kube_prometheus_version/manifests/alertmanager-alertmanager.yaml |grep "version: " |awk '{print $2}'`

echo $prometheus_base_image:$prometheus_image_tag >> image-lists-temp.txt
echo $alertmanager_base_image:$alertmanager_image_tag >> image-lists-temp.txt

rm -rf kube-prometheus-$kube_prometheus_version

sed "s/- --config-reloader-image=//g" image-lists-temp.txt > 1.txt
sed "s/- --prometheus-config-reloader=//g" 1.txt > 2.txt
sed "s/image: //g" 2.txt > 3.txt
sed "s/repository: //g" 3.txt > 4.txt
sed "s/baseImage: //g" 4.txt > 5.txt
sed "s/- grafana/grafana/g" 5.txt > 6.txt
cat 6.txt |grep ":" > 7.txt
sed -i "s/[[:space:]]//g" 7.txt
rm -f image-lists-temp.txt 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt
mv 7.txt images-list.txt

for file in $(cat images-list.txt); do docker pull $file; done
echo 'Images pulled.'

docker save $(cat images-list.txt) -o kube-prometheus-images-v$kube_prometheus_version.tar
echo 'Images saved.'
bzip2 -z --best kube-prometheus-images-v$kube_prometheus_version.tar
echo 'Images are compressed as bzip format.'
