ARGS kubernetes_version=v1.17.0

FROM willdockerhub/kubepackage:${kubernetes_version} as builder

FROM cytopia/ansible:latest-tools

RUN git clone https://github.com/willzhang/kubeansible.git

COPY FROM builder:/data/packages .
