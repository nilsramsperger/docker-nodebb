#!/usr/bin/env bash
set -x
redis_pid=0

term_handler() {
    if [ "$redis_pid" -ne "0" ]
        then
        /etc/init.d/redis-server stop
        [ -f /opt/nodebb/config.json ] && mv /opt/nodebb/config.json /etc/nodebb/
    fi
    exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM

/etc/init.d/redis-server start
[ -e /etc/nodebb/config.json ] && rm -f /opt/nodebb/config.json && ln -s /etc/nodebb/config.json /opt/nodebb/config.json
cd /opt/nodebb/
[ -e /etc/nodebb/config.json ] && nodejs nodebb upgrade
forever start app.js
redis_pid=$(cat /run/redis/redis-server.pid)

while true
do
  tail -f /dev/null & wait ${!}
done
