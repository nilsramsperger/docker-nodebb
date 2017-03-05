#!/usr/bin/env bash
set -x

term_handler() {
    nodejs nodebb stop
    [ -e /etc/nodebb/config.json ] || mv /opt/nodebb/config.json /etc/nodebb/
    /etc/init.d/redis-server stop
    exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM

[ -e /var/lib/redis/appendonly.aof ] && chown redis /var/lib/redis/appendonly.aof
/etc/init.d/redis-server start
[ -e /etc/nodebb/config.json ] && rm -f /opt/nodebb/config.json && ln -s /etc/nodebb/config.json /opt/nodebb/config.json
cd /opt/nodebb/
[ -e /etc/nodebb/config.json ] && nodejs nodebb upgrade
nodejs nodebb start

while true
do
  tail -f /dev/null & wait ${!}
done
