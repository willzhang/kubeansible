# Kubernetes-ansible


# Getting Started
run kubeansible
```
docker run -d --name kubeansible \
  --restart always \
  -p 2009:2009 \
  -v kubeansible:/data \
  willdockerhub/kubeansible:v1.17.0
```

docker exec kubeansible
```
docker exec -it kubeansible sh

#change cluster nodes for your environment
vi /data/kubeansible/inventory/hosts

#install kubernetes cluster
cd /data/kubeansible 
ansible-playbook cluster.yml
```


