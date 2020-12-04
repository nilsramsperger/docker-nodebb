#!/usr/bin/env bash
docker stop myNodeBB
docker rm myNodeBB
yes | docker volume prune
docker create --name myNodeBB --init --restart always -p 4567:4567 -v nodebb-data:/var/lib/redis -v nodebb-files:/opt/nodebb/public/uploads -v nodebb-config:/etc/nodebb nilsramsperger/nodebb
docker start myNodeBB