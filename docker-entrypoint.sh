#!/bin/bash -ex

export ETCD_PORT=${ETCD_PORT:-4001}
export ETCD_HOST=${ETCD_HOST:-172.17.42.1}
export CONFIG=${CONFIG:-$(ls -1 /etc/confd/conf.d/|head -1)}
export ETCD=$ETCD_HOST:$ETCD_PORT

echo "[nginx] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -onetime -node $ETCD -config-file $CONFIG; do
  echo "[nginx] waiting for confd to refresh nginx.conf"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -interval 10 -node $ETCD -config-file $CONFIG &
echo "[nginx] confd is listening for changes on etcd..."

# Start nginx
echo "[nginx] starting nginx service..."
service nginx start

