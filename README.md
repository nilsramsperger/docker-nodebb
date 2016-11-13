# nilsramsperger/nodebb
A simple Docker image for quick-launching a NodeBB forum.

## Description
This repo contains the files for the automatic build of the Docker image `nilsramsperger/nodebb` hosted on [DockerHub](https://hub.docker.com/r/nilsramsperger/nodebb/).

The NodeBB comes with no plugins and the forum data is stored in a [Redis](http://redis.io) within the container. 
The Redis is configured for [AOF persistence](http://redis.io/topics/persistence). 
Not the fastest but the least chance for data loss on unexpected shutdowns.

### Tags ###
* `latest`: NodeBB 1.2.1, Node.js 7.1.0, Redis 2.8.17
* `v1.2.1`: NodeBB 1.2.1, Node.js 7.1.0, Redis 2.8.17
* `dev`: the latest stuff

Be advised, the `dev` tag might not be runnable. 
Best stick to `latest` or a specific version tag.

## Setup
Create the container

`docker create --name myNodeBB -p 80:4567 -v nodebb-data:/var/lib/redis -v nodebb-files:/opt/nodebb/public/uploads -v nodebb-config:/etc/nodebb nilsramsperger/nodebb`

Start the container

`docker start myNodeBB`

In this case the container is bound to local port 80. 
The name is set to myNodeBB. 
The three volumes are linked to the named volumes `nodebb-data`, `nodebb-files` and `nodebb-config`. 
Change things as you like.

On first run, NodeBB will start it's web installer interface. 
There you can create your admin account and set things up. 
Just leave the database settings as they are.
The `config.json` is created by the web installer and copied to `/etc/nodebb` when you shutdown the container after installing.

### Volumes
* `/etc/nodebb` contains NodeBB's `config.json`
* `/var/lib/redis` contains the Redis data
* `/opt/nodebb/public/uploads` contains NodeBB uploads like avatars

## Update to latest version
If you want to update your NodeBB to the latest version, just stop and remove your current container.
Then recreate it with the `create` command from the install section.
On startup, the container will run a `nodebb upgrade` and thus prepare the database for the new version of NodeBB.

## Backup and restore
Save the contents of the three volumes for creating a backup. 
To restore, copy the contents back.