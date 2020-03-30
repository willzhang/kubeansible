FROM willdockerhub/nginx:ansible

RUN mkdir -p /data/kubeansible \
    && git clone https://github.com/willzhang/kubeansible.git --depth=1 /data/kubeansible

COPY scripts/packages /data/packages

COPY scripts/rpms /usr/share/nginx/html/rpms
COPY scripts/yum-repo/index.html /usr/share/nginx/html
COPY scripts/yum-repo/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /data/kubeansible