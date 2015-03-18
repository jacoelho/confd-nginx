FROM ubuntu:14.04.2

ENV DEBIAN_FRONTEND=noninteractive
ENV CONFD_VERSION=0.8.0

RUN apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:nginx/stable && \
    apt-get update -q && \
    apt-get install -y --no-install-recommends nginx curl && \
    rm -rf /var/lib/apt/lists/* && \
# configure nginx
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -f /etc/nginx/sites-enabled/default && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
# configure confd
    curl -qL https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd && \
    chmod +x /usr/local/bin/confd

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ONBUILD ADD templates/ /etc/confd/templates/
ONBUILD ADD conf.d/ /etc/confd/conf.d/

EXPOSE 80 443
