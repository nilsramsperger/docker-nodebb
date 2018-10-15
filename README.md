# nilsramsperger/nodebb
A simple Docker image for quick-launching a NodeBB forum.

## Description
This repo contains the files for the automatic build of the Docker image `nilsramsperger/nodebb` hosted on [DockerHub](https://hub.docker.com/r/nilsramsperger/nodebb/).

The NodeBB comes with no plugins and the forum data is stored in a [Redis](http://redis.io) within the container. 
The Redis is configured for [AOF persistence](http://redis.io/topics/persistence). 
Not the fastest but the least chance for data loss on unexpected shutdowns.

### Tags
* `latest`
* `v1.10.2`
* `v1.10.1`
* `v1.10.0`
* `v1.9.3`
* `v1.9.2`
* `v1.9.1`
* `v1.9.0`
* `v1.8.2`
* `v1.8.1`
* `v1.8.0`
* `v1.7.5`
* `v1.7.4`
* `v1.7.3`
* `v1.7.2`
* `v1.7.1`
* `v1.7.0`
* `v1.6.1`
* `v1.6.0`
* `v1.5.3`
* `v1.5.2`
* `v1.5.1`
* `v1.5.0`
* `v1.4.6`
* `v1.4.5`
* `v1.4.4`
* `v1.2.1`

Be advised, any other tags are for experimental purpose and might not be runnable. 
Best stick to `latest` or a specific version tag.

## Setup
Create the container

`docker create --name myNodeBB --init --restart always -p 4567:4567 -v nodebb-data:/var/lib/redis -v nodebb-files:/opt/nodebb/public/uploads -v nodebb-config:/etc/nodebb nilsramsperger/nodebb`

In this case the container named `myNodeBB` and is bound to local port 4567.
The three volumes are linked to the named volumes `nodebb-data`, `nodebb-files` and `nodebb-config`. 
Change things as you like.

Start the container

`docker start myNodeBB`

On first run, NodeBB will start it's web installer interface. 
There you can create your admin account and set things up. 
Just leave the database settings as they are and click "Install NodeBB".
When everything is done, click "Launch NodeBB".
The container will restart and the browser switch to the forum.

If an image of version 1.5.x or less is used, the container will not restart on "Launch NodeBB".
The restart must be done manually.

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

## Restarting
Since NodeBB is started via the `app.js`, restarting from admin panel is disabled.
If you want to, just restart the container.

## Troubleshooting

### Problem

The NodeBB web-client notifies about broken web socket connections and tries to reestablish infinitely.
 
### Solution

The public URL and port in the `config.json` are not set correctly.
When creating the container, you can set the public URL via `-e url="http://127.0.0.1:4567"`.