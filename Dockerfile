FROM ubuntu:14.04.2

RUN export CONFD_VERSION=0.8.0 && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:nginx/stable && \
    apt-get update -q && \
    touch /etc/inittab && \
    apt-get install -y --no-install-recommends runit nginx curl && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
# configure nginx
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -f /etc/nginx/sites-enabled/default && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
# configure confd
    curl -qL https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd && \
    chmod +x /usr/local/bin/confd

ADD confd.service /etc/service/confd/run
ADD nginx.service /etc/service/nginx/run

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]

ONBUILD ADD templates/ /etc/confd/templates/
ONBUILD ADD conf.d/ /etc/confd/conf.d/

EXPOSE 80 443
