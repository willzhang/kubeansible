ARGS kubernetes_version=v1.16.3
FROM willdockerhub/kubepackage:${kubernetes_version} as builder
FROM cytopia/ansible:latest-tools
COPY ./* /workspace
COPY FROM builder:/workspace/packages /workspace
