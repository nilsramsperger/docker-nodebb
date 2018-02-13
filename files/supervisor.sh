#!/bin/bash

shutdown() {
    echo "Shutting down."
    nodejs nodebb stop
    [ -e /etc/nodebb/config.json ] || cp /opt/nodebb/config.json /etc/nodebb/config.json
    /etc/init.d/redis-server stop
    echo "Stopped"
    exit 143;
}

term_handler() {
    echo "SIGTERM received"
    shutdown
}

trap term_handler SIGTERM

[ -e /var/lib/redis/appendonly.aof ] && chown redis /var/lib/redis/appendonly.aof
/etc/init.d/redis-server start
[ -e /etc/nodebb/config.json ] && rm -f /opt/nodebb/config.json && ln -s /etc/nodebb/config.json /opt/nodebb/config.json
cd /opt/nodebb/
[ -e /etc/nodebb/config.json ] && nodejs nodebb upgrade
nodejs nodebb start & wait ${!}
echo "NodeBB died"
shutdown
