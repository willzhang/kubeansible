FROM willdockerhub/nginx:ansible

WORKDIR /data/

COPY scripts/packages /data/

COPY * /data/kubeansible

RUN git cone https://github.com/willzhang/kubeansible.git --depth=1

COPY rpms /usr/share/nginx/html/rpms
COPY yum-repo/index.html /usr/share/nginx/html
COPY yum-repo/nginx.conf /etc/nginx/conf.d/default.conf
