FROM willdockerhub/nginx:ansible

RUN mkdir -p /data/kubeansible/ \
    && git clone https://github.com/willzhang/kubeansible.git --depth=1 /data/kubeansible

COPY packages /data/kubeansible/packages

COPY rpms /usr/share/nginx/html/rpms
COPY yum-repo/index.html /usr/share/nginx/html
COPY yum-repo/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /data/kubeansible